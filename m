Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933086Ab2C1VXp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 17:23:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40817 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758763Ab2C1VXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 17:23:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH v2 6/8] PM / Sleep: Mitigate race between the freezer and request_firmware()
Date: Wed, 28 Mar 2012 23:24:36 +0200
User-Agent: KMail/1.13.6 (Linux/3.3.0+; KDE/4.6.0; x86_64; ; )
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk,
        Linux PM mailing list <linux-pm@vger.kernel.org>
References: <201203032122.36745.chunkeey@googlemail.com> <201203260000.34377.rjw@sisk.pl> <201203282319.54708.rjw@sisk.pl>
In-Reply-To: <201203282319.54708.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203282324.36810.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

There is a race condition between the freezer and request_firmware()
such that if request_firmware() is run on one CPU and
freeze_processes() is run on another CPU and usermodehelper_disable()
called by it succeeds to grab umhelper_sem for writing before
usermodehelper_read_trylock() called from request_firmware()
acquires it for reading, the request_firmware() will fail and
trigger a WARN_ON() complaining that it was called at a wrong time.
However, in fact, it wasn't called at a wrong time and
freeze_processes() simply happened to be executed simultaneously.

To avoid this race, at least in some cases, modify
usermodehelper_read_trylock() so that it doesn't fail if the
freezing of tasks has just started and hasn't been completed yet.
Instead, during the freezing of tasks, it will try to freeze the
task that has called it so that it can wait until user space is
thawed without triggering the scary warning.

For this purpose, change usermodehelper_disabled so that it can
take three different values, UMH_ENABLED (0), UMH_FREEZING and
UMH_DISABLED.  The first one means that usermode helpers are
enabled, the last one means "hard disable" (i.e. the system is not
ready for usermode helpers to be used) and the second one
is reserved for the freezer.  Namely, when freeze_processes() is
started, it sets usermodehelper_disabled to UMH_FREEZING which
tells usermodehelper_read_trylock() that it shouldn't fail just
yet and should call try_to_freeze() if woken up and cannot
return immediately.  This way all freezable tasks that happen
to call request_firmware() right before freeze_processes() is
started and lose the race for umhelper_sem with it will be
frozen and will sleep until thaw_processes() unsets
usermodehelper_disabled.  [For the non-freezable callers of
request_firmware() the race for umhelper_sem against
freeze_processes() is unfortunately unavoidable.]

Reported-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/kmod.h   |   21 +++++++++++++++++++--
 kernel/kmod.c          |   47 +++++++++++++++++++++++++++++++++++++----------
 kernel/power/process.c |    3 ++-
 3 files changed, 58 insertions(+), 13 deletions(-)

Index: linux/include/linux/kmod.h
===================================================================
--- linux.orig/include/linux/kmod.h
+++ linux/include/linux/kmod.h
@@ -110,10 +110,27 @@ call_usermodehelper(char *path, char **a
 
 extern struct ctl_table usermodehelper_table[];
 
+enum umh_disable_depth {
+	UMH_ENABLED = 0,
+	UMH_FREEZING,
+	UMH_DISABLED,
+};
+
 extern void usermodehelper_init(void);
 
-extern int usermodehelper_disable(void);
-extern void usermodehelper_enable(void);
+extern int __usermodehelper_disable(enum umh_disable_depth depth);
+extern void __usermodehelper_set_disable_depth(enum umh_disable_depth depth);
+
+static inline int usermodehelper_disable(void)
+{
+	return __usermodehelper_disable(UMH_DISABLED);
+}
+
+static inline void usermodehelper_enable(void)
+{
+	__usermodehelper_set_disable_depth(UMH_ENABLED);
+}
+
 extern int usermodehelper_read_trylock(void);
 extern long usermodehelper_read_lock_wait(long timeout);
 extern void usermodehelper_read_unlock(void);
Index: linux/kernel/kmod.c
===================================================================
--- linux.orig/kernel/kmod.c
+++ linux/kernel/kmod.c
@@ -322,7 +322,7 @@ static void __call_usermodehelper(struct
  * land has been frozen during a system-wide hibernation or suspend operation).
  * Should always be manipulated under umhelper_sem acquired for write.
  */
-static int usermodehelper_disabled = 1;
+static enum umh_disable_depth usermodehelper_disabled = UMH_DISABLED;
 
 /* Number of helpers running */
 static atomic_t running_helpers = ATOMIC_INIT(0);
@@ -347,13 +347,30 @@ static DECLARE_WAIT_QUEUE_HEAD(usermodeh
 
 int usermodehelper_read_trylock(void)
 {
+	DEFINE_WAIT(wait);
 	int ret = 0;
 
 	down_read(&umhelper_sem);
-	if (usermodehelper_disabled) {
+	for (;;) {
+		prepare_to_wait(&usermodehelper_disabled_waitq, &wait,
+				TASK_INTERRUPTIBLE);
+		if (!usermodehelper_disabled)
+			break;
+
+		if (usermodehelper_disabled == UMH_DISABLED)
+			ret = -EAGAIN;
+
 		up_read(&umhelper_sem);
-		ret = -EAGAIN;
+
+		if (ret)
+			break;
+
+		schedule();
+		try_to_freeze();
+
+		down_read(&umhelper_sem);
 	}
+	finish_wait(&usermodehelper_disabled_waitq, &wait);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(usermodehelper_read_trylock);
@@ -392,25 +409,35 @@ void usermodehelper_read_unlock(void)
 EXPORT_SYMBOL_GPL(usermodehelper_read_unlock);
 
 /**
- * usermodehelper_enable - allow new helpers to be started again
+ * __usermodehelper_set_disable_depth - Modify usermodehelper_disabled.
+ * depth: New value to assign to usermodehelper_disabled.
+ *
+ * Change the value of usermodehelper_disabled (under umhelper_sem locked for
+ * writing) and wakeup tasks waiting for it to change.
  */
-void usermodehelper_enable(void)
+void __usermodehelper_set_disable_depth(enum umh_disable_depth depth)
 {
 	down_write(&umhelper_sem);
-	usermodehelper_disabled = 0;
+	usermodehelper_disabled = depth;
 	wake_up(&usermodehelper_disabled_waitq);
 	up_write(&umhelper_sem);
 }
 
 /**
- * usermodehelper_disable - prevent new helpers from being started
+ * __usermodehelper_disable - Prevent new helpers from being started.
+ * @depth: New value to assign to usermodehelper_disabled.
+ *
+ * Set usermodehelper_disabled to @depth and wait for running helpers to exit.
  */
-int usermodehelper_disable(void)
+int __usermodehelper_disable(enum umh_disable_depth depth)
 {
 	long retval;
 
+	if (!depth)
+		return -EINVAL;
+
 	down_write(&umhelper_sem);
-	usermodehelper_disabled = 1;
+	usermodehelper_disabled = depth;
 	up_write(&umhelper_sem);
 
 	/*
@@ -425,7 +452,7 @@ int usermodehelper_disable(void)
 	if (retval)
 		return 0;
 
-	usermodehelper_enable();
+	__usermodehelper_set_disable_depth(UMH_ENABLED);
 	return -EAGAIN;
 }
 
Index: linux/kernel/power/process.c
===================================================================
--- linux.orig/kernel/power/process.c
+++ linux/kernel/power/process.c
@@ -123,7 +123,7 @@ int freeze_processes(void)
 {
 	int error;
 
-	error = usermodehelper_disable();
+	error = __usermodehelper_disable(UMH_FREEZING);
 	if (error)
 		return error;
 
@@ -135,6 +135,7 @@ int freeze_processes(void)
 	error = try_to_freeze_tasks(true);
 	if (!error) {
 		printk("done.");
+		__usermodehelper_set_disable_depth(UMH_DISABLED);
 		oom_killer_disable();
 	}
 	printk("\n");

