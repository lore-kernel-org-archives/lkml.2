Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab1CQSMI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 14:12:08 -0400
Received: from cantor.suse.de ([195.135.220.2]:40394 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582Ab1CQSMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 14:12:05 -0400
Date: Thu, 17 Mar 2011 11:11:59 -0700
From: Tony Jones <tonyj@suse.de>
To: David Howells <dhowells@redhat.com>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        linux-audit@redhat.com, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: PATCH [1/1]: audit: acquire creds selectively to reduce atomic
 op overhead
Message-ID: <20110317181159.GA31948@suse.de>
References: <1300211077.3748.2.camel@localhost.localdomain>
 <20110310202516.GA16122@suse.de>
 <20110307210656.GA1750@suse.de>
 <18893.1299607373@redhat.com>
 <29980.1299861232@redhat.com>
 <20110315173810.GA12775@suse.de>
 <21526.1300219877@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21526.1300219877@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 08:11:17PM +0000, David Howells wrote:
> Eric Paris <eparis@redhat.com> wrote:
> 
> > WARN_ON(cred != current->cred && cred->refcnt != 1)
> 
> 'tsk->parent == current' perhaps?  Or audit_alloc() could pass a flag
> indicating the state, or just look to see if tsk->audit_context is still NULL.
> 
> David

Round 3.   tsk->parent == current isn't an option as it's not set by
copy_process until after audit_alloc.  I used a flag to provide an explicit
indication.  I didn't have audit_alloc pass the flag into audit_filter_task
as there is already a explicit "process creation time" comment for this static
function. If you want it pushed all the way upto audit_alloc, let me know and
I'll revise.

Oddly sparse didn't throw any warnings about the direct use of tsk->cred.

tony
---

Commit c69e8d9c01db added calls to get_task_cred and put_cred in
audit_filter_rules.  Profiling with a large number of audit rules active on the
exit chain shows that we are spending upto 48% in this routine for syscall
intensive tests, most of which is in the atomic ops.

1. The code should be accessing tsk->cred rather than tsk->real_cred.  
2. Since tsk is current (or tsk is being created by copy_process) access to 
tsk->cred without rcu read lock is possible.  At the request of the audit
maintainer, a new flag has been added to audit_filter_rules in order to make 
this explicit and guide future code.

Signed-off-by: Tony Jones <tonyj@suse.de>
---
 kernel/auditsc.c |   27 +++++++++++++++++----------
 1 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index f49a031..281dcf1 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -443,17 +443,25 @@ static int match_tree_refs(struct audit_context *ctx, struct audit_tree *tree)
 
 /* Determine if any context name data matches a rule's watch data */
 /* Compare a task_struct with an audit_rule.  Return 1 on match, 0
- * otherwise. */
+ * otherwise.
+ *
+ * If task_creation is true, this is an explicit indication that we are
+ * filtering a task rule at task creation time.  This and tsk == current are
+ * the only situations where tsk->cred may be accessed without an rcu read lock.
+ */
 static int audit_filter_rules(struct task_struct *tsk,
 			      struct audit_krule *rule,
 			      struct audit_context *ctx,
 			      struct audit_names *name,
-			      enum audit_state *state)
+			      enum audit_state *state,
+			      bool task_creation)
 {
-	const struct cred *cred = get_task_cred(tsk);
+	const struct cred *cred;
 	int i, j, need_sid = 1;
 	u32 sid;
 
+	cred = rcu_dereference_check(tsk->cred, tsk == current || task_creation);
+
 	for (i = 0; i < rule->field_count; i++) {
 		struct audit_field *f = &rule->fields[i];
 		int result = 0;
@@ -637,10 +645,8 @@ static int audit_filter_rules(struct task_struct *tsk,
 			break;
 		}
 
-		if (!result) {
-			put_cred(cred);
+		if (!result)
 			return 0;
-		}
 	}
 
 	if (ctx) {
@@ -656,7 +662,6 @@ static int audit_filter_rules(struct task_struct *tsk,
 	case AUDIT_NEVER:    *state = AUDIT_DISABLED;	    break;
 	case AUDIT_ALWAYS:   *state = AUDIT_RECORD_CONTEXT; break;
 	}
-	put_cred(cred);
 	return 1;
 }
 
@@ -671,7 +676,8 @@ static enum audit_state audit_filter_task(struct task_struct *tsk, char **key)
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(e, &audit_filter_list[AUDIT_FILTER_TASK], list) {
-		if (audit_filter_rules(tsk, &e->rule, NULL, NULL, &state)) {
+		if (audit_filter_rules(tsk, &e->rule, NULL, NULL,
+				       &state, true)) {
 			if (state == AUDIT_RECORD_CONTEXT)
 				*key = kstrdup(e->rule.filterkey, GFP_ATOMIC);
 			rcu_read_unlock();
@@ -705,7 +711,7 @@ static enum audit_state audit_filter_syscall(struct task_struct *tsk,
 		list_for_each_entry_rcu(e, list, list) {
 			if ((e->rule.mask[word] & bit) == bit &&
 			    audit_filter_rules(tsk, &e->rule, ctx, NULL,
-					       &state)) {
+					       &state, false)) {
 				rcu_read_unlock();
 				ctx->current_state = state;
 				return state;
@@ -743,7 +749,8 @@ void audit_filter_inodes(struct task_struct *tsk, struct audit_context *ctx)
 
 		list_for_each_entry_rcu(e, list, list) {
 			if ((e->rule.mask[word] & bit) == bit &&
-			    audit_filter_rules(tsk, &e->rule, ctx, n, &state)) {
+			    audit_filter_rules(tsk, &e->rule, ctx, n,
+				    	       &state, false)) {
 				rcu_read_unlock();
 				ctx->current_state = state;
 				return;
