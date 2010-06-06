Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458Ab0FFUXh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 16:23:37 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:46597 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754045Ab0FFUXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 16:23:36 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: akpm@linux-foundation.org
Cc: adobriyan@gmail.com, nhorman@tuxdriver.com, oleg@redhat.com,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: [PATCH v3 06/11] rlimits: do security check under task_lock
Date: Sun,  6 Jun 2010 22:23:03 +0200
Message-Id: <1275855783-27316-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100513155621.51ca77a4.akpm@linux-foundation.org>
References: <20100513155621.51ca77a4.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 10 May 2010 20:00:46 +0200
> Jiri Slaby <jslaby@suse.cz> wrote:
> > @@ -1309,11 +1305,13 @@ int do_setrlimit(struct task_struct *tsk, unsigned int resource,
> >  
> >  	old_rlim = tsk->signal->rlim + resource;
> >  	task_lock(tsk->group_leader);
> > -	if ((new_rlim->rlim_max <= old_rlim->rlim_max) ||
> > -				capable(CAP_SYS_RESOURCE))
> > -		*old_rlim = *new_rlim;
> > -	else
> > +	if ((new_rlim->rlim_max > old_rlim->rlim_max) &&
> > +				!capable(CAP_SYS_RESOURCE))
> >  		retval = -EPERM;
> > +	if (!retval)
> > +		retval = security_task_setrlimit(tsk, resource, new_rlim);
> 
> I looked at the amount of code which exists under
> security_task_setrlimit() and nearly died.  Please convince me that it
> is correct to do all that work under tasklist_lock, and that it is also
> maintainable.

When I wrote this code, I looked how it is done in the current code
and redid what others, including getioprio, setnice and task_kill
(this one even with task_lock write-locked) do. I need the lock
to protect task->signal (which is checked inside the security
function) from disappearing.

> > +	if (!retval)
> > +		*old_rlim = *new_rlim;
> >  	task_unlock(tsk->group_leader);
> >  
> >  	if (retval || resource != RLIMIT_CPU)
> 
> Yikes, so the locking around all that selinux code becomes even more
> brutal.  How much rope are you tying around the selinux developers'
> hands here?

I agree with that and didn't find a better solution than is attached
here.

--
The code performed in security_task_setrlimit is very long when
CONFIG_SECURITY is enabled. Don't execute the function under
alloc_lock, unlock it temporarily and check whether the limits changed
in the meantime while the lock was not held. If yes, redo do check.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 kernel/sys.c |   39 +++++++++++++++++++++++++++++++++++----
 1 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index d7fcd4a..48cb21d 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1304,12 +1304,37 @@ static void rlim64_to_rlim(const struct rlimit64 *rlim64, struct rlimit *rlim)
 		rlim->rlim_max = (unsigned long)rlim64->rlim_max;
 }
 
+/**
+ * check_security_task_setrlimit_unlocked - calls security_task_setrlimit
+ *
+ * But security_task_setrlimit is complex with much of code, so that we don't
+ * want to call it while holding the task_lock. We temporarily unlock the lock
+ * and after the check we test whether the limits changed in the meantime.
+ */
+static int check_security_task_setrlimit_unlocked(struct task_struct *tsk,
+		unsigned int resource, struct rlimit *new_rlim,
+		struct rlimit *old_rlim)
+{
+	struct rlimit rlim;
+	int ret;
+
+	memcpy(&rlim, old_rlim, sizeof(rlim));
+
+	task_unlock(tsk->group_leader);
+	ret = security_task_setrlimit(tsk, resource, new_rlim);
+	task_lock(tsk->group_leader);
+
+	if (!ret && memcmp(&rlim, old_rlim, sizeof(rlim)))
+		return -EAGAIN;
+	return ret;
+}
+
 /* make sure you are allowed to change @tsk limits before calling this */
 int do_prlimit(struct task_struct *tsk, unsigned int resource,
 		struct rlimit *new_rlim, struct rlimit *old_rlim)
 {
 	struct rlimit *rlim;
-	int retval = 0;
+	int retval;
 
 	if (resource >= RLIM_NLIMITS)
 		return -EINVAL;
@@ -1339,13 +1364,19 @@ int do_prlimit(struct task_struct *tsk, unsigned int resource,
 
 	rlim = tsk->signal->rlim + resource;
 	task_lock(tsk->group_leader);
+again:
+	retval = 0;
 	if (new_rlim) {
 		if ((new_rlim->rlim_max > rlim->rlim_max) &&
 					!capable(CAP_SYS_RESOURCE))
 			retval = -EPERM;
-		if (!retval)
-			retval = security_task_setrlimit(tsk, resource,
-					new_rlim);
+		if (!retval) {
+			retval = check_security_task_setrlimit_unlocked(tsk,
+					resource, new_rlim, rlim);
+			if (retval == -EAGAIN) {
+				goto again;
+			}
+		}
 	}
 	if (!retval) {
 		if (old_rlim)
-- 
1.7.1


