Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560Ab2CRA0I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 20:26:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50606 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964791Ab2CRAZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 20:25:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC] firmware loader: retry _nowait requests when userhelper is not yet available
Date: Sun, 18 Mar 2012 01:29:38 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Christian Lamparter <chunkeey@googlemail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        alan@lxorguk.ukuu.org.uk,
        Linux PM mailing list <linux-pm@vger.kernel.org>
References: <201203032122.36745.chunkeey@googlemail.com> <201203170123.10599.rjw@sisk.pl> <CA+55aFxiJABjKJz4J6Dwk8Jy4=Vds2P15XTVtX8_j6TDkTwXEg@mail.gmail.com>
In-Reply-To: <CA+55aFxiJABjKJz4J6Dwk8Jy4=Vds2P15XTVtX8_j6TDkTwXEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203180129.38469.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, March 17, 2012, Linus Torvalds wrote:
> On Fri, Mar 16, 2012 at 5:23 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >
> > OK, but that asynchronous thread needs to know whether or not the system is up.
> 
> Sure.
> 
> > It can use the usermodehelper_is_disabled() check, but that needs to be done
> > under read_lock_usermodehelper() and it can't release the lock before
> > calling _request_firmware(), or all that thing would be racy.
> 
> Well, I think that it would actually be a good idea to perhaps split
> up that existing _request_firmware() a bit. In fact, it might be good
> to split up that whole "fw_create_instance()" too - and re-organize
> the code a bit so that you end up creating the "firmware_priv" thing
> first.
> 
> So maybe we could have a helper function that does that first part of
> fw_create_instance() (the part that allocates it and does the
> __module_get() part and other really basic initialization), and that
> can be called unconditionally by the request_firmware_nowait() code
> early.
> 
> That early part probably should *not* create the device attribute
> files etc (although who knows - maybe sysfs is ok at this point).
> 
> So I think we really could re-organize the code to do a sane job - and
> move just the actual udev setup etc to the final part that needs to be
> delayed.
> 
> Hmm?
> 
> I haven't looked very deeply into it, but my *gut* feel is that it
> should be doable pretty cleanly.
> 
> But yeah, it would be more than a little one-liner. I think it might
> be worth it, though. Clearly separating out the three stages: "setup"
> -> "wait for system to be ready" -> "do the actual load".
> 
> Then, the regular request_firmware() function would do exactly the
> same things, except it would never do the "wait for system to be
> ready" part: it would just fail with the warning if it wasn't already
> ready. So they'd still share all the basic core code, it would just be
> a slightly different organization from what it is now.

The patch below (untested) goes slightly into that direction, although not as
far as to modify fw_create_instance().  It does, however, split
_request_firmware() into "prepare", "load" and "cleanup" parts and moves
the usermodehelper check along with the read-locking of umhelper_sem down
to the callers, ie. request_firmware() and request_firmware_work_func().

The difference between them is that request_firmware() fails immediately
with a WARN_ON() if it sees usermodehelper_disabled set after acquiring
umhelper_sem, while request_firmware_work_func() waits for
usermodehelper_disabled to be unset, with a timeout (the wait time is
subtracted from the _request_firmware() timeout).  The reason why
request_firmware_work_func() does it this way is that it can't wait for
usermodehelper_disabled to be unset with umhelper_sem held and it has to
call _request_firmware() under umhelper_sem (otherwise user space might be
frozen out from under it).

I'm falling asleep now, but hopefully the patch isn't totally busted. :-)
It should be split into a series of patches, though.

Thanks,
Rafael

---
 drivers/base/firmware_class.c |   98 +++++++++++++++++++++++++++---------------
 include/linux/kmod.h          |    6 +-
 kernel/kmod.c                 |   83 ++++++++++++++++++++++++-----------
 3 files changed, 124 insertions(+), 63 deletions(-)

Index: linux/kernel/kmod.c
===================================================================
--- linux.orig/kernel/kmod.c
+++ linux/kernel/kmod.c
@@ -291,22 +291,74 @@ static atomic_t running_helpers = ATOMIC
 static DECLARE_WAIT_QUEUE_HEAD(running_helpers_waitq);
 
 /*
+ * Used by usermodehelper_read_lock_wait() to wait for usermodehelper_disabled
+ * to become 'false'.
+ */
+static DECLARE_WAIT_QUEUE_HEAD(usermodehelper_disabled_waitq);
+
+/*
  * Time to wait for running_helpers to become zero before the setting of
  * usermodehelper_disabled in usermodehelper_disable() fails
  */
 #define RUNNING_HELPERS_TIMEOUT	(5 * HZ)
 
-void read_lock_usermodehelper(void)
+int usermodehelper_read_trylock(void)
+{
+	int ret = 0;
+
+	down_read(&umhelper_sem);
+	if (usermodehelper_disabled) {
+		up_read(&umhelper_sem);
+		ret = -EAGAIN;
+	}
+	return ret;
+}
+EXPORT_SYMBOL_GPL(usermodehelper_read_trylock);
+
+long usermodehelper_read_lock_wait(long timeout)
 {
+	DEFINE_WAIT(wait);
+	long ret = timeout;
+
+	if (timeout < 0)
+		return -EINVAL;
+
 	down_read(&umhelper_sem);
+	for (;;) {
+		prepare_to_wait(&usermodehelper_disabled_waitq, &wait,
+				TASK_UNINTERRUPTIBLE);
+		if (!usermodehelper_disabled)
+			break;
+
+		up_read(&umhelper_sem);
+
+		ret = schedule_timeout(timeout);
+		if (!ret)
+			break;
+
+		down_read(&umhelper_sem);
+	}
+	finish_wait(&usermodehelper_disabled_waitq, &wait);
+	return ret;
 }
-EXPORT_SYMBOL_GPL(read_lock_usermodehelper);
+EXPORT_SYMBOL_GPL(usermodehelper_read_lock_wait);
 
-void read_unlock_usermodehelper(void)
+void usermodehelper_read_unlock(void)
 {
 	up_read(&umhelper_sem);
 }
-EXPORT_SYMBOL_GPL(read_unlock_usermodehelper);
+EXPORT_SYMBOL_GPL(usermodehelper_read_unlock);
+
+/**
+ * usermodehelper_enable - allow new helpers to be started again
+ */
+void usermodehelper_enable(void)
+{
+	down_write(&umhelper_sem);
+	usermodehelper_disabled = 0;
+	wake_up(&usermodehelper_disabled_waitq);
+	up_write(&umhelper_sem);
+}
 
 /**
  * usermodehelper_disable - prevent new helpers from being started
@@ -331,31 +383,10 @@ int usermodehelper_disable(void)
 	if (retval)
 		return 0;
 
-	down_write(&umhelper_sem);
-	usermodehelper_disabled = 0;
-	up_write(&umhelper_sem);
+	usermodehelper_enable();
 	return -EAGAIN;
 }
 
-/**
- * usermodehelper_enable - allow new helpers to be started again
- */
-void usermodehelper_enable(void)
-{
-	down_write(&umhelper_sem);
-	usermodehelper_disabled = 0;
-	up_write(&umhelper_sem);
-}
-
-/**
- * usermodehelper_is_disabled - check if new helpers are allowed to be started
- */
-bool usermodehelper_is_disabled(void)
-{
-	return usermodehelper_disabled;
-}
-EXPORT_SYMBOL_GPL(usermodehelper_is_disabled);
-
 static void helper_lock(void)
 {
 	atomic_inc(&running_helpers);
Index: linux/include/linux/kmod.h
===================================================================
--- linux.orig/include/linux/kmod.h
+++ linux/include/linux/kmod.h
@@ -116,8 +116,8 @@ extern void usermodehelper_init(void);
 
 extern int usermodehelper_disable(void);
 extern void usermodehelper_enable(void);
-extern bool usermodehelper_is_disabled(void);
-extern void read_lock_usermodehelper(void);
-extern void read_unlock_usermodehelper(void);
+extern int usermodehelper_read_trylock(void);
+extern long usermodehelper_read_lock_wait(long timeout);
+extern void usermodehelper_read_unlock(void);
 
 #endif /* __LINUX_KMOD_H__ */
Index: linux/drivers/base/firmware_class.c
===================================================================
--- linux.orig/drivers/base/firmware_class.c
+++ linux/drivers/base/firmware_class.c
@@ -435,7 +435,7 @@ static void firmware_class_timeout(u_lon
 }
 
 static struct firmware_priv *
-fw_create_instance(struct firmware *firmware, const char *fw_name,
+fw_create_instance(const struct firmware *firmware, const char *fw_name,
 		   struct device *device, bool uevent, bool nowait)
 {
 	struct firmware_priv *fw_priv;
@@ -449,7 +449,7 @@ fw_create_instance(struct firmware *firm
 		goto err_out;
 	}
 
-	fw_priv->fw = firmware;
+	fw_priv->fw = (struct firmware *)firmware;
 	fw_priv->nowait = nowait;
 	strcpy(fw_priv->fw_id, fw_name);
 	init_completion(&fw_priv->completion);
@@ -510,16 +510,10 @@ static void fw_destroy_instance(struct f
 	device_unregister(f_dev);
 }
 
-static int _request_firmware(const struct firmware **firmware_p,
-			     const char *name, struct device *device,
-			     bool uevent, bool nowait)
+static int _request_firmware_prepare(const struct firmware **firmware_p,
+				     const char *name, struct device *device)
 {
-	struct firmware_priv *fw_priv;
 	struct firmware *firmware;
-	int retval = 0;
-
-	if (!firmware_p)
-		return -EINVAL;
 
 	*firmware_p = firmware = kzalloc(sizeof(*firmware), GFP_KERNEL);
 	if (!firmware) {
@@ -533,28 +527,33 @@ static int _request_firmware(const struc
 		return 0;
 	}
 
-	read_lock_usermodehelper();
+	return 1;
+}
 
-	if (WARN_ON(usermodehelper_is_disabled())) {
-		dev_err(device, "firmware: %s will not be loaded\n", name);
-		retval = -EBUSY;
-		goto out;
-	}
+static void _request_firmware_cleanup(const struct firmware **firmware_p)
+{
+	release_firmware(*firmware_p);
+	*firmware_p = NULL;
+}
+
+static int _request_firmware(const struct firmware *firmware,
+			     const char *name, struct device *device,
+			     bool uevent, bool nowait, long timeout)
+{
+	struct firmware_priv *fw_priv;
+	int retval = 0;
 
 	if (uevent)
 		dev_dbg(device, "firmware: requesting %s\n", name);
 
 	fw_priv = fw_create_instance(firmware, name, device, uevent, nowait);
-	if (IS_ERR(fw_priv)) {
-		retval = PTR_ERR(fw_priv);
-		goto out;
-	}
+	if (IS_ERR(fw_priv))
+		return PTR_ERR(fw_priv);
 
 	if (uevent) {
-		if (loading_timeout > 0)
+		if (timeout > 0)
 			mod_timer(&fw_priv->timeout,
-				  round_jiffies_up(jiffies +
-						   loading_timeout * HZ));
+				  round_jiffies_up(jiffies + timeout));
 
 		kobject_uevent(&fw_priv->dev.kobj, KOBJ_ADD);
 	}
@@ -572,14 +571,6 @@ static int _request_firmware(const struc
 
 	fw_destroy_instance(fw_priv);
 
-out:
-	read_unlock_usermodehelper();
-
-	if (retval) {
-		release_firmware(firmware);
-		*firmware_p = NULL;
-	}
-
 	return retval;
 }
 
@@ -602,7 +593,24 @@ int
 request_firmware(const struct firmware **firmware_p, const char *name,
                  struct device *device)
 {
-        return _request_firmware(firmware_p, name, device, true, false);
+	int ret;
+
+	ret = _request_firmware_prepare(firmware_p, name, device);
+	if (ret <= 0)
+		return ret;
+
+	ret = usermodehelper_read_trylock();
+	if (WARN_ON(ret)) {
+		dev_err(device, "firmware: %s will not be loaded\n", name);
+	} else {
+		ret = _request_firmware(*firmware_p, name, device, true, false,
+					loading_timeout * HZ);
+		usermodehelper_read_unlock();
+	}
+	if (ret)
+		_request_firmware_cleanup(firmware_p);
+
+	return ret;
 }
 
 /**
@@ -633,6 +641,7 @@ static int request_firmware_work_func(vo
 {
 	struct firmware_work *fw_work = arg;
 	const struct firmware *fw;
+	long timeout;
 	int ret;
 
 	if (!arg) {
@@ -640,8 +649,29 @@ static int request_firmware_work_func(vo
 		return 0;
 	}
 
-	ret = _request_firmware(&fw, fw_work->name, fw_work->device,
-				fw_work->uevent, true);
+	ret = _request_firmware_prepare(&fw, fw_work->name, fw_work->device);
+	if (ret <= 0)
+		return ret;
+
+	if (loading_timeout) {
+		timeout = usermodehelper_read_lock_wait(loading_timeout * HZ);
+		if (timeout <= 0)
+			ret = -EAGAIN;
+	} else {
+		usermodehelper_read_lock_wait(MAX_SCHEDULE_TIMEOUT);
+		timeout = 0;
+	}
+	if (ret > 0) {
+		ret = _request_firmware(fw, fw_work->name, fw_work->device,
+					fw_work->uevent, true, timeout);
+		usermodehelper_read_unlock();
+	} else {
+		dev_dbg(fw_work->device, "firmware: %s loading timed out\n",
+			fw_work->name);
+	}
+	if (ret)
+		_request_firmware_cleanup(&fw);
+
 	fw_work->cont(fw, fw_work->context);
 
 	module_put(fw_work->module);
