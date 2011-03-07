Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab1CGVHH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 16:07:07 -0500
Received: from cantor.suse.de ([195.135.220.2]:35506 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994Ab1CGVHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 16:07:05 -0500
Date: Mon, 7 Mar 2011 13:06:56 -0800
From: Tony Jones <tonyj@suse.de>
To: linux-kernel@vger.kernel.org
Cc: linux-audit@redhat.com, David Howells <dhowells@redhat.com>,
        Eric Paris <eparis@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: PATCH [1/1]: audit: acquire creds selectively to reduce atomic op
 overhead
Message-ID: <20110307210656.GA1750@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit c69e8d9c01db added calls to get_task_cred and put_cred in 
audit_filter_rules.  Profiling with a large number of audit rules active on the
exit chain shows that we are spending upto 48% in this routine for syscall 
intensive tests, most of which is in the atomic ops. 

The following patch acquires the cred if a rule requires it.  In our particular
case above, most rules had no cred requirement and this dropped the time spent
in audit_filter_rules down to ~12%.  An alternative would be for the caller to 
acquire the cred just once for the whole chain and pass into audit_filter_rules.
I can create an alternate patch doing this if required.

Signed-off-by: Tony Jones <tonyj@suse.de>
---

 kernel/auditsc.c |   24 +++++++++++++++++++++---
 1 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index f49a031..4a930a1 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -450,7 +450,7 @@ static int audit_filter_rules(struct task_struct *tsk,
 			      struct audit_names *name,
 			      enum audit_state *state)
 {
-	const struct cred *cred = get_task_cred(tsk);
+	const struct cred *cred=NULL;
 	int i, j, need_sid = 1;
 	u32 sid;
 
@@ -470,27 +470,43 @@ static int audit_filter_rules(struct task_struct *tsk,
 			}
 			break;
 		case AUDIT_UID:
+ 			if (!cred) 
+				cred=get_task_cred(tsk);
 			result = audit_comparator(cred->uid, f->op, f->val);
 			break;
 		case AUDIT_EUID:
+ 			if (!cred) 
+				cred=get_task_cred(tsk);
 			result = audit_comparator(cred->euid, f->op, f->val);
 			break;
 		case AUDIT_SUID:
+ 			if (!cred) 
+				cred=get_task_cred(tsk);
 			result = audit_comparator(cred->suid, f->op, f->val);
 			break;
 		case AUDIT_FSUID:
+ 			if (!cred) 
+				cred=get_task_cred(tsk);
 			result = audit_comparator(cred->fsuid, f->op, f->val);
 			break;
 		case AUDIT_GID:
+ 			if (!cred) 
+				cred=get_task_cred(tsk);
 			result = audit_comparator(cred->gid, f->op, f->val);
 			break;
 		case AUDIT_EGID:
+ 			if (!cred) 
+				cred=get_task_cred(tsk);
 			result = audit_comparator(cred->egid, f->op, f->val);
 			break;
 		case AUDIT_SGID:
+ 			if (!cred) 
+				cred=get_task_cred(tsk);
 			result = audit_comparator(cred->sgid, f->op, f->val);
 			break;
 		case AUDIT_FSGID:
+ 			if (!cred) 
+				cred=get_task_cred(tsk);
 			result = audit_comparator(cred->fsgid, f->op, f->val);
 			break;
 		case AUDIT_PERS:
@@ -638,7 +654,8 @@ static int audit_filter_rules(struct task_struct *tsk,
 		}
 
 		if (!result) {
-			put_cred(cred);
+			if (cred)
+				put_cred(cred);
 			return 0;
 		}
 	}
@@ -656,7 +673,8 @@ static int audit_filter_rules(struct task_struct *tsk,
 	case AUDIT_NEVER:    *state = AUDIT_DISABLED;	    break;
 	case AUDIT_ALWAYS:   *state = AUDIT_RECORD_CONTEXT; break;
 	}
-	put_cred(cred);
+	if (cred)
+		put_cred(cred);
 	return 1;
 }
 
