Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263Ab2CQCr5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 22:47:57 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3736 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab2CQCry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 22:47:54 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6651"; a="171025355"
Message-ID: <4F63FB59.9010104@codeaurora.org>
Date: Fri, 16 Mar 2012 19:47:53 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Saravana Kannan <skannan@codeaurora.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] firmware loader: don't cancel _nowait requests when helper
 is not yet available
References: <201203032122.36745.chunkeey@googlemail.com> <201203150034.08863.rjw@sisk.pl> <4F612C05.8010301@codeaurora.org> <201203150111.05724.rjw@sisk.pl>
In-Reply-To: <201203150111.05724.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/12 17:11, Rafael J. Wysocki wrote:
> On Thursday, March 15, 2012, Stephen Boyd wrote:
>> On 03/14/12 16:34, Rafael J. Wysocki wrote:
>>> On Thursday, March 15, 2012, Stephen Boyd wrote:
>>>> On 03/14/12 16:13, Rafael J. Wysocki wrote:
>>>>> On Thursday, March 15, 2012, Rafael J. Wysocki wrote:
>>>>>
>>>>>> Which is OK, I think.
>>>>> Moreover, thaw_kernel_threads() is _only_ called by (a) freeze_kernel_threads()
>>>>> on error and (b) user-space hibernate interface in kernel/power/user.c
>>>>> (and please read the comment in there describing what it's there for, which
>>>>> also explains why the schedule() call in there is necessary).
>>>> Exactly. So in case (a) when the error occurs we'll have this call flow:
>>>>
>>>> usermodehelpers_disable()
>>>> suspend_freeze_processes()
>>>>     freeze_processes()
>>>>     freeze_kernel_threads()
>>>>         try_to_freeze_tasks() <-- returns error
>>>>         thaw_kernel_threads()
>>>>             schedule()
>>>>     thaw_processes()
>>>> usermodehelpers_enable()
>>>>
>>>> Shouldn't we schedule only after we thaw all processes (not just tasks)?
>>>> Otherwise we may run a kernel thread before userspace is thawed?
>>> Yes, we may, but that isn't wrong, is it?
>>>
>>> Only a few kernel threads are freezable, so definitely kernel threads
>>> can run while user space is frozen.
>>>
>> Yes but if someone calls request_firmware() from a kthread then they
>> will hit the same problem where the thread runs and requests the
>> firmware and usermodehelpers are still disabled. Currently my code is
>> written with kthreads and that thread makes the request firmware call,
>> so this doesn't seem far fetched (although in my case I can probably fix
>> it).
> So again, please consider using suspend/resume notifiers to synchronize
> your kthread with system power transitions.

Ah. Freezable workqueues and threads are entirely not what I want. I
have to use suspend/resume notifiers so that I don't call
request_firmware() until suspend is over and I have to synchronize that
with a rwsem so that suspend is blocked until my call to
request_firmware() completes (and so request_firmware() is blocked until
suspend completes). Every user of request_firmware() has to do the same
check or be certain that their code won't run during a system-wide
suspend/resume.  Ouch.

Can we fix this in the core firmware loading code somehow? I really want
to have a way to differentiate between tasks that can block suspend from
progressing and tasks that won't. This way everyone who doesn't care
about suspend can still call request_firmware() and go to sleep if we're
in the middle of suspending and the ones who would block suspend get
failed immediately. That would seem to be more in line with why this
patch was made (i.e. don't block suspend/resume from progressing with
request_firmware() calls).

What about this? It basically keeps track of which task is the
suspending task and then only fails that one. I'm not completely sold on
this one but it would work most of the time.

---8<-----

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 6c9387d..5127534 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -533,9 +533,7 @@ static int _request_firmware(const struct firmware **firmware_p,
 		return 0;
 	}
 
-	read_lock_usermodehelper();
-
-	if (WARN_ON(usermodehelper_is_disabled())) {
+	if (is_sleep_task()) {
 		dev_err(device, "firmware: %s will not be loaded\n", name);
 		retval = -EBUSY;
 		goto out;
@@ -550,6 +548,7 @@ static int _request_firmware(const struct firmware **firmware_p,
 		goto out;
 	}
 
+	read_lock_usermodehelper();
 	if (uevent) {
 		if (loading_timeout > 0)
 			mod_timer(&fw_priv->timeout,
@@ -560,6 +559,7 @@ static int _request_firmware(const struct firmware **firmware_p,
 	}
 
 	wait_for_completion(&fw_priv->completion);
+	read_unlock_usermodehelper();
 
 	set_bit(FW_STATUS_DONE, &fw_priv->status);
 	del_timer_sync(&fw_priv->timeout);
@@ -573,7 +573,6 @@ static int _request_firmware(const struct firmware **firmware_p,
 	fw_destroy_instance(fw_priv);
 
 out:
-	read_unlock_usermodehelper();
 
 	if (retval) {
 		release_firmware(firmware);
diff --git a/include/linux/kmod.h b/include/linux/kmod.h
index 9efeae6..d84da8c 100644
--- a/include/linux/kmod.h
+++ b/include/linux/kmod.h
@@ -115,6 +115,7 @@ extern void usermodehelper_init(void);
 extern int usermodehelper_disable(void);
 extern void usermodehelper_enable(void);
 extern bool usermodehelper_is_disabled(void);
+extern bool is_sleep_task(void);
 extern void read_lock_usermodehelper(void);
 extern void read_unlock_usermodehelper(void);
 
diff --git a/kernel/kmod.c b/kernel/kmod.c
index 9faa560..50fae27 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -368,6 +368,13 @@ void read_unlock_usermodehelper(void)
 }
 EXPORT_SYMBOL_GPL(read_unlock_usermodehelper);
 
+static struct task_struct *system_sleep_task;
+
+bool is_sleep_task(void)
+{
+	return current == system_sleep_task;
+}
+
 /**
  * usermodehelper_disable - prevent new helpers from being started
  */
@@ -375,9 +382,9 @@ int usermodehelper_disable(void)
 {
 	long retval;
 
+	system_sleep_task = current;
 	down_write(&umhelper_sem);
 	usermodehelper_disabled = 1;
-	up_write(&umhelper_sem);
 
 	/*
 	 * From now on call_usermodehelper_exec() won't start any new
@@ -391,9 +398,9 @@ int usermodehelper_disable(void)
 	if (retval)
 		return 0;
 
-	down_write(&umhelper_sem);
 	usermodehelper_disabled = 0;
 	up_write(&umhelper_sem);
+	system_sleep_task = NULL;
 	return -EAGAIN;
 }
 
@@ -402,9 +409,9 @@ int usermodehelper_disable(void)
  */
 void usermodehelper_enable(void)
 {
-	down_write(&umhelper_sem);
 	usermodehelper_disabled = 0;
 	up_write(&umhelper_sem);
+	system_sleep_task = NULL;
 }
 
 /**
-- 


Or maybe we should modify request_firmware_nowait() to have the suspend
notifier checks? Right now if I call request_firmware_nowait() from a
probe it just might happen to fail because the kthread could run before
resume is complete. I didn't call request_firmware(), so I really tried
not to block resume progress but I'm gambling that resume will be over
before my thread runs. I could write notifier rwsem code and then wait
for resume to finish before calling request_firmware_nowat(), but that
would require me to fork a thread/workqueue to run
request_firmware_nowait() which will then fork a thread again. Seems
useless to even use request_firmware_nowait() then.

How about this totally untested patch? We do the rwsem thing for
request_firmware_nowait() at least.
----8<-----

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 6c9387d..f320ccd 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -20,6 +20,8 @@
 #include <linux/highmem.h>
 #include <linux/firmware.h>
 #include <linux/slab.h>
+#include <linux/suspend.h>
+#include <linux/rwsem.h>
 
 #define to_dev(obj) container_of(obj, struct device, kobj)
 
@@ -629,6 +631,9 @@ struct firmware_work {
 	bool uevent;
 };
 
+/* Synchronize request_firmware_work_func() with suspend */
+static DECLARE_RWSEM(fw_pm_rwsem);
+
 static int request_firmware_work_func(void *arg)
 {
 	struct firmware_work *fw_work = arg;
@@ -640,8 +645,10 @@ static int request_firmware_work_func(void *arg)
 		return 0;
 	}
 
+	down_read(&fw_pm_rwsem);
 	ret = _request_firmware(&fw, fw_work->name, fw_work->device,
 				fw_work->uevent, true);
+	up_read(&fw_pm_rwsem);
 	fw_work->cont(fw, fw_work->context);
 
 	module_put(fw_work->module);
@@ -704,13 +711,33 @@ request_firmware_nowait(
 	return 0;
 }
 
+static int firmware_class_pm_notify(struct notifier_block *block,
+		unsigned long event, void *p)
+{
+	switch (event) {
+	case PM_SUSPEND_PREPARE:
+		down_write(&fw_pm_rwsem);
+		break;
+	case PM_POST_SUSPEND:
+		up_write(&fw_pm_rwsem);
+		break;
+	}
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block firmware_class_pm_notifier = {
+	.notifier_call = firmware_class_pm_notify,
+};
+
 static int __init firmware_class_init(void)
 {
+	register_pm_notifier(&firmware_class_pm_notifier);
 	return class_register(&firmware_class);
 }
 
 static void __exit firmware_class_exit(void)
 {
+	unregister_pm_notifier(&firmware_class_pm_notifier);
 	class_unregister(&firmware_class);
 }
 
-- 


Hmm it seems something similar is going on in the other part of the
thread. I'll work something up in a few hours.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

