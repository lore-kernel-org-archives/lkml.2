Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab1IWB0b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 21:26:31 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:57750 "EHLO
	mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754519Ab1IWB00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 21:26:26 -0400
Date: Fri, 23 Sep 2011 01:27:51 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Greg KH <greg@kroah.com>
Cc: "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Oleg Nesterov <oleg@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
        richard@nod.at, Andrew Morton <akpm@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH resend] user namespace: usb: make usb urbs user namespace
 aware (v2)
Message-ID: <20110923012751.GA27386@hallyn.com>
References: <20110919214531.GA18085@sergelap>
 <20110919214700.GA22300@sergelap>
 <20110920131738.GA29852@redhat.com>
 <20110921050127.GB6691@sergelap>
 <20110921183101.GB25590@redhat.com>
 <20110921191238.GA16720@sergelap>
 <20110921191856.GA30859@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110921191856.GA30859@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(re-sending to Cc: Greg and linux-usb)

Add to the dev_state and alloc_async structures the user namespace
corresponding to the uid and euid.  Pass these to kill_pid_info_as_uid(),
which can then implement a proper, user-namespace-aware uid check.

Changelog:
Sep 20: Per Oleg's suggestion: Instead of caching and passing user namespace,
	uid, and euid each separately, pass a struct cred.

Signed-off-by: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Greg KH <greg@kroah.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Tejun Heo <tj@kernel.org>
---
 drivers/usb/core/devio.c |   28 ++++++++++++----------------
 include/linux/sched.h    |    3 ++-
 kernel/signal.c          |   24 ++++++++++++++++--------
 3 files changed, 30 insertions(+), 25 deletions(-)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 37518df..e53a585 100644
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
@@ -68,7 +69,7 @@ struct dev_state {
 	wait_queue_head_t wait;     /* wake up if a request completed */
 	unsigned int discsignr;
 	struct pid *disc_pid;
-	uid_t disc_uid, disc_euid;
+	const struct cred *cred;
 	void __user *disccontext;
 	unsigned long ifclaimed;
 	u32 secid;
@@ -79,7 +80,7 @@ struct async {
 	struct list_head asynclist;
 	struct dev_state *ps;
 	struct pid *pid;
-	uid_t uid, euid;
+	const struct cred *cred;
 	unsigned int signr;
 	unsigned int ifnum;
 	void __user *userbuffer;
@@ -248,6 +249,7 @@ static struct async *alloc_async(unsigned int numisoframes)
 static void free_async(struct async *as)
 {
 	put_pid(as->pid);
+	put_cred(as->cred);
 	kfree(as->urb->transfer_buffer);
 	kfree(as->urb->setup_packet);
 	usb_free_urb(as->urb);
@@ -393,9 +395,8 @@ static void async_completed(struct urb *urb)
 	struct dev_state *ps = as->ps;
 	struct siginfo sinfo;
 	struct pid *pid = NULL;
-	uid_t uid = 0;
-	uid_t euid = 0;
 	u32 secid = 0;
+	const struct cred *cred = NULL;
 	int signr;
 
 	spin_lock(&ps->lock);
@@ -408,8 +409,7 @@ static void async_completed(struct urb *urb)
 		sinfo.si_code = SI_ASYNCIO;
 		sinfo.si_addr = as->userurb;
 		pid = as->pid;
-		uid = as->uid;
-		euid = as->euid;
+		cred = as->cred;
 		secid = as->secid;
 	}
 	snoop(&urb->dev->dev, "urb complete\n");
@@ -423,8 +423,7 @@ static void async_completed(struct urb *urb)
 	spin_unlock(&ps->lock);
 
 	if (signr)
-		kill_pid_info_as_uid(sinfo.si_signo, &sinfo, pid, uid,
-				      euid, secid);
+		kill_pid_info_as_cred(sinfo.si_signo, &sinfo, pid, cred, secid);
 
 	wake_up(&ps->wait);
 }
@@ -706,8 +705,7 @@ static int usbdev_open(struct inode *inode, struct file *file)
 	init_waitqueue_head(&ps->wait);
 	ps->discsignr = 0;
 	ps->disc_pid = get_pid(task_pid(current));
-	ps->disc_uid = cred->uid;
-	ps->disc_euid = cred->euid;
+	ps->cred = get_cred(cred);
 	ps->disccontext = NULL;
 	ps->ifclaimed = 0;
 	security_task_getsecid(current, &ps->secid);
@@ -749,6 +747,7 @@ static int usbdev_release(struct inode *inode, struct file *file)
 	usb_unlock_device(dev);
 	usb_put_dev(dev);
 	put_pid(ps->disc_pid);
+	put_cred(ps->cred);
 
 	as = async_getcompleted(ps);
 	while (as) {
@@ -1048,7 +1047,6 @@ static int proc_do_submiturb(struct dev_state *ps, struct usbdevfs_urb *uurb,
 	struct usb_host_endpoint *ep;
 	struct async *as;
 	struct usb_ctrlrequest *dr = NULL;
-	const struct cred *cred = current_cred();
 	unsigned int u, totlen, isofrmlen;
 	int ret, ifnum = -1;
 	int is_in;
@@ -1262,8 +1260,7 @@ static int proc_do_submiturb(struct dev_state *ps, struct usbdevfs_urb *uurb,
 	as->signr = uurb->signr;
 	as->ifnum = ifnum;
 	as->pid = get_pid(task_pid(current));
-	as->uid = cred->uid;
-	as->euid = cred->euid;
+	as->cred = get_current_cred();
 	security_task_getsecid(current, &as->secid);
 	if (!is_in && uurb->buffer_length > 0) {
 		if (copy_from_user(as->urb->transfer_buffer, uurb->buffer,
@@ -1981,9 +1978,8 @@ static void usbdev_remove(struct usb_device *udev)
 			sinfo.si_errno = EPIPE;
 			sinfo.si_code = SI_ASYNCIO;
 			sinfo.si_addr = ps->disccontext;
-			kill_pid_info_as_uid(ps->discsignr, &sinfo,
-					ps->disc_pid, ps->disc_uid,
-					ps->disc_euid, ps->secid);
+			kill_pid_info_as_cred(ps->discsignr, &sinfo,
+					ps->disc_pid, ps->cred, ps->secid);
 		}
 	}
 }
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4ac2c05..57ddb52 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2166,7 +2166,8 @@ extern int force_sigsegv(int, struct task_struct *);
 extern int force_sig_info(int, struct siginfo *, struct task_struct *);
 extern int __kill_pgrp_info(int sig, struct siginfo *info, struct pid *pgrp);
 extern int kill_pid_info(int sig, struct siginfo *info, struct pid *pid);
-extern int kill_pid_info_as_uid(int, struct siginfo *, struct pid *, uid_t, uid_t, u32);
+extern int kill_pid_info_as_cred(int, struct siginfo *, struct pid *,
+				const struct cred *, u32);
 extern int kill_pgrp(struct pid *pid, int sig, int priv);
 extern int kill_pid(struct pid *pid, int sig, int priv);
 extern int kill_proc_info(int, struct siginfo *, pid_t);
diff --git a/kernel/signal.c b/kernel/signal.c
index 466219b..9803707 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1355,13 +1355,24 @@ int kill_proc_info(int sig, struct siginfo *info, pid_t pid)
 	return error;
 }
 
+static int kill_as_cred_perm(const struct cred *cred,
+			     struct task_struct *target)
+{
+	const struct cred *pcred = __task_cred(target);
+	if (cred->user_ns != pcred->user_ns)
+		return 0;
+	if (cred->euid != pcred->suid && cred->euid != pcred->uid &&
+	    cred->uid  != pcred->suid && cred->uid  != pcred->uid)
+		return 0;
+	return 1;
+}
+
 /* like kill_pid_info(), but doesn't use uid/euid of "current" */
-int kill_pid_info_as_uid(int sig, struct siginfo *info, struct pid *pid,
-		      uid_t uid, uid_t euid, u32 secid)
+int kill_pid_info_as_cred(int sig, struct siginfo *info, struct pid *pid,
+			 const struct cred *cred, u32 secid)
 {
 	int ret = -EINVAL;
 	struct task_struct *p;
-	const struct cred *pcred;
 	unsigned long flags;
 
 	if (!valid_signal(sig))
@@ -1373,10 +1384,7 @@ int kill_pid_info_as_uid(int sig, struct siginfo *info, struct pid *pid,
 		ret = -ESRCH;
 		goto out_unlock;
 	}
-	pcred = __task_cred(p);
-	if (si_fromuser(info) &&
-	    euid != pcred->suid && euid != pcred->uid &&
-	    uid  != pcred->suid && uid  != pcred->uid) {
+	if (si_fromuser(info) && !kill_as_cred_perm(cred, p)) {
 		ret = -EPERM;
 		goto out_unlock;
 	}
@@ -1395,7 +1403,7 @@ out_unlock:
 	rcu_read_unlock();
 	return ret;
 }
-EXPORT_SYMBOL_GPL(kill_pid_info_as_uid);
+EXPORT_SYMBOL_GPL(kill_pid_info_as_cred);
 
 /*
  * kill_something_info() interprets pid in interesting ways just like kill(2).
-- 
1.7.5.4

