Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab1ISVrI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 17:47:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57515 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756409Ab1ISVrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 17:47:06 -0400
Date: Mon, 19 Sep 2011 16:47:00 -0500
From: "Serge E. Hallyn" <serge.hallyn@canonical.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: richard@nod.at, Andrew Morton <akpm@google.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
        serge@hallyn.com, serge.hallyn@canonical.com
Subject: [PATCH] user namespace: usb: make usb urbs user namespace aware
Message-ID: <20110919214700.GA22300@sergelap>
References: <20110919214531.GA18085@sergelap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110919214531.GA18085@sergelap>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add to the dev_state and alloc_async structures the user namespace
corresponding to the uid and euid.  Pass these to kill_pid_info_as_uid(),
which can then implement a proper, user-namespace-aware uid check.

Signed-off-by: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Greg KH <greg@kroah.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Tejun Heo <tj@kernel.org>
---
 drivers/usb/core/devio.c |   17 +++++++++++++----
 include/linux/sched.h    |    3 ++-
 kernel/signal.c          |   22 ++++++++++++++++------
 3 files changed, 31 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 37518df..b875a11 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -46,6 +46,7 @@
 #include <linux/cdev.h>
 #include <linux/notifier.h>
 #include <linux/security.h>
+#include <linux/user_namespace.h>
 #include <asm/uaccess.h>
 #include <asm/byteorder.h>
 #include <linux/moduleparam.h>
@@ -68,6 +69,7 @@ struct dev_state {
 	wait_queue_head_t wait;     /* wake up if a request completed */
 	unsigned int discsignr;
 	struct pid *disc_pid;
+	struct user_namespace *user_ns;
 	uid_t disc_uid, disc_euid;
 	void __user *disccontext;
 	unsigned long ifclaimed;
@@ -79,6 +81,7 @@ struct async {
 	struct list_head asynclist;
 	struct dev_state *ps;
 	struct pid *pid;
+	struct user_namespace *user_ns;
 	uid_t uid, euid;
 	unsigned int signr;
 	unsigned int ifnum;
@@ -248,6 +251,7 @@ static struct async *alloc_async(unsigned int numisoframes)
 static void free_async(struct async *as)
 {
 	put_pid(as->pid);
+	put_user_ns(as->user_ns);
 	kfree(as->urb->transfer_buffer);
 	kfree(as->urb->setup_packet);
 	usb_free_urb(as->urb);
@@ -396,6 +400,7 @@ static void async_completed(struct urb *urb)
 	uid_t uid = 0;
 	uid_t euid = 0;
 	u32 secid = 0;
+	struct user_namespace *user_ns;
 	int signr;
 
 	spin_lock(&ps->lock);
@@ -408,6 +413,7 @@ static void async_completed(struct urb *urb)
 		sinfo.si_code = SI_ASYNCIO;
 		sinfo.si_addr = as->userurb;
 		pid = as->pid;
+		user_ns = as->user_ns;
 		uid = as->uid;
 		euid = as->euid;
 		secid = as->secid;
@@ -423,8 +429,8 @@ static void async_completed(struct urb *urb)
 	spin_unlock(&ps->lock);
 
 	if (signr)
-		kill_pid_info_as_uid(sinfo.si_signo, &sinfo, pid, uid,
-				      euid, secid);
+		kill_pid_info_as_uid(sinfo.si_signo, &sinfo, pid, user_ns,
+				     uid, euid, secid);
 
 	wake_up(&ps->wait);
 }
@@ -708,6 +714,7 @@ static int usbdev_open(struct inode *inode, struct file *file)
 	ps->disc_pid = get_pid(task_pid(current));
 	ps->disc_uid = cred->uid;
 	ps->disc_euid = cred->euid;
+	ps->user_ns = get_user_ns(cred->user_ns);
 	ps->disccontext = NULL;
 	ps->ifclaimed = 0;
 	security_task_getsecid(current, &ps->secid);
@@ -749,6 +756,7 @@ static int usbdev_release(struct inode *inode, struct file *file)
 	usb_unlock_device(dev);
 	usb_put_dev(dev);
 	put_pid(ps->disc_pid);
+	put_user_ns(ps->user_ns);
 
 	as = async_getcompleted(ps);
 	while (as) {
@@ -1262,6 +1270,7 @@ static int proc_do_submiturb(struct dev_state *ps, struct usbdevfs_urb *uurb,
 	as->signr = uurb->signr;
 	as->ifnum = ifnum;
 	as->pid = get_pid(task_pid(current));
+	as->user_ns = get_user_ns(cred->user_ns);
 	as->uid = cred->uid;
 	as->euid = cred->euid;
 	security_task_getsecid(current, &as->secid);
@@ -1982,8 +1991,8 @@ static void usbdev_remove(struct usb_device *udev)
 			sinfo.si_code = SI_ASYNCIO;
 			sinfo.si_addr = ps->disccontext;
 			kill_pid_info_as_uid(ps->discsignr, &sinfo,
-					ps->disc_pid, ps->disc_uid,
-					ps->disc_euid, ps->secid);
+					ps->disc_pid, ps->user_ns,
+					ps->disc_uid, ps->disc_euid, ps->secid);
 		}
 	}
 }
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4ac2c05..2d47cc2 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2166,7 +2166,8 @@ extern int force_sigsegv(int, struct task_struct *);
 extern int force_sig_info(int, struct siginfo *, struct task_struct *);
 extern int __kill_pgrp_info(int sig, struct siginfo *info, struct pid *pgrp);
 extern int kill_pid_info(int sig, struct siginfo *info, struct pid *pid);
-extern int kill_pid_info_as_uid(int, struct siginfo *, struct pid *, uid_t, uid_t, u32);
+extern int kill_pid_info_as_uid(int, struct siginfo *, struct pid *,
+				struct user_namespace *, uid_t, uid_t, u32);
 extern int kill_pgrp(struct pid *pid, int sig, int priv);
 extern int kill_pid(struct pid *pid, int sig, int priv);
 extern int kill_proc_info(int, struct siginfo *, pid_t);
diff --git a/kernel/signal.c b/kernel/signal.c
index bb8ce03..4a00eb2 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1346,13 +1346,26 @@ int kill_proc_info(int sig, struct siginfo *info, pid_t pid)
 	return error;
 }
 
+static int kill_as_uid_perm(struct task_struct *p,
+			    struct user_namespace *user_ns, uid_t uid,
+			    uid_t euid)
+{
+	const struct cred *pcred = __task_cred(p);
+	if (user_ns != pcred->user_ns)
+		return 0;
+	if (euid != pcred->suid && euid != pcred->uid &&
+	    uid  != pcred->suid && uid  != pcred->uid)
+		return 0;
+	return 1;
+}
+
 /* like kill_pid_info(), but doesn't use uid/euid of "current" */
 int kill_pid_info_as_uid(int sig, struct siginfo *info, struct pid *pid,
-		      uid_t uid, uid_t euid, u32 secid)
+			 struct user_namespace *user_ns, uid_t uid, uid_t euid,
+			 u32 secid)
 {
 	int ret = -EINVAL;
 	struct task_struct *p;
-	const struct cred *pcred;
 	unsigned long flags;
 
 	if (!valid_signal(sig))
@@ -1364,10 +1377,7 @@ int kill_pid_info_as_uid(int sig, struct siginfo *info, struct pid *pid,
 		ret = -ESRCH;
 		goto out_unlock;
 	}
-	pcred = __task_cred(p);
-	if (si_fromuser(info) &&
-	    euid != pcred->suid && euid != pcred->uid &&
-	    uid  != pcred->suid && uid  != pcred->uid) {
+	if (si_fromuser(info) && !kill_as_uid_perm(p, user_ns, uid, euid)) {
 		ret = -EPERM;
 		goto out_unlock;
 	}
-- 
1.7.5.4

