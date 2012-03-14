Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761417Ab2CNTVf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 15:21:35 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19325 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757394Ab2CNTVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 15:21:32 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6648"; a="170175538"
Message-ID: <4F60EFBB.5050703@codeaurora.org>
Date: Wed, 14 Mar 2012 12:21:31 -0700
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
References: <201203032122.36745.chunkeey@googlemail.com> <CAPXgP10oHRnPo7Es1RX8GM68dH13E0rzcFhXzOYFPcmKs=yh1A@mail.gmail.com> <4F5F16D9.3080607@codeaurora.org> <201203132114.57828.rjw@sisk.pl>
In-Reply-To: <201203132114.57828.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/12 13:14, Rafael J. Wysocki wrote:
> All of those use cases are in fact of the "wait for user space to be thawed
> and then load the firmware" type, which I believe may be handled without
> changing that code.
>
> Why don't you make your kthread freezable, for one example?
>
> Why don't you use a freezable workqueue instead?
>

If we put it on the freezable workqueue or make it a freezable thread
will it work?

In my scenario a wakeup interrupt comes in that wakes us up from
suspend. Within that wakeup handler a work item is scheduled to the
freezable workqueue. That work item then calls request_firmware().

It looks like we call schedule() after thawing the workqueues and tasks
so the work item could run before usermodehelpers are enabled and then
request_firmware() would fail. Do we need something like this (ignore
the fact that we call usermodhelper_enable() twice)?

diff --git a/kernel/power/process.c b/kernel/power/process.c
index 7e42645..61bfa95 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -187,6 +187,7 @@ void thaw_processes(void)
        } while_each_thread(g, p);
        read_unlock(&tasklist_lock);
 
+       usermodehelper_enable();
        schedule();
        printk("done.\n");
 }


Is there a reason we disable usermodehelpers if
CONFIG_SUSPEND_FREEZER=n? Should we do this instead so that
usermodehelpers are only disabled if we freeze userspace? Also what is
that schedule() call in thaw_kernel_threads() for? It looks like we'll
call schedule between kernel thread thawing and userspace thawing. I
pushed out the schedule() call to the callers so that we don't call
schedule() until userspace is thawed.

diff --git a/kernel/power/process.c b/kernel/power/process.c
index 7e42645..8fae228 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -125,6 +125,7 @@ int freeze_processes(void)
 	if (!pm_freezing)
 		atomic_inc(&system_freezing_cnt);
 
+	usermodehelper_disable();
 	printk("Freezing user space processes ... ");
 	pm_freezing = true;
 	error = try_to_freeze_tasks(true);
@@ -187,6 +188,7 @@ void thaw_processes(void)
 	} while_each_thread(g, p);
 	read_unlock(&tasklist_lock);
 
+	usermodehelper_enable();
 	schedule();
 	printk("done.\n");
 }
@@ -207,6 +209,5 @@ void thaw_kernel_threads(void)
 	} while_each_thread(g, p);
 	read_unlock(&tasklist_lock);
 
-	schedule();
 	printk("done.\n");
 }
diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
index 4fd51be..1ab3e59 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -101,17 +101,12 @@ static int suspend_prepare(void)
 	if (error)
 		goto Finish;
 
-	error = usermodehelper_disable();
-	if (error)
-		goto Finish;
-
 	error = suspend_freeze_processes();
 	if (!error)
 		return 0;
 
 	suspend_stats.failed_freeze++;
 	dpm_save_failed_step(SUSPEND_FREEZE);
-	usermodehelper_enable();
  Finish:
 	pm_notifier_call_chain(PM_POST_SUSPEND);
 	pm_restore_console();
@@ -259,7 +254,6 @@ int suspend_devices_and_enter(suspend_state_t state)
 static void suspend_finish(void)
 {
 	suspend_thaw_processes();
-	usermodehelper_enable();
 	pm_notifier_call_chain(PM_POST_SUSPEND);
 	pm_restore_console();
 }
diff --git a/kernel/power/user.c b/kernel/power/user.c
index 3e10007..1a8fd6f 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -222,14 +222,8 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 		sys_sync();
 		printk("done.\n");
 
-		error = usermodehelper_disable();
-		if (error)
-			break;
-
 		error = freeze_processes();
-		if (error)
-			usermodehelper_enable();
-		else
+		if (!error)
 			data->frozen = 1;
 		break;
 
@@ -238,7 +232,6 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 			break;
 		pm_restore_gfp_mask();
 		thaw_processes();
-		usermodehelper_enable();
 		data->frozen = 0;
 		break;
 
@@ -251,6 +244,7 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 		error = hibernation_snapshot(data->platform_support);
 		if (error) {
 			thaw_kernel_threads();
+			schedule();
 		} else {
 			error = put_user(in_suspend, (int __user *)arg);
 			if (!error && !freezer_test_done)
@@ -258,6 +252,7 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 			if (freezer_test_done) {
 				freezer_test_done = false;
 				thaw_kernel_threads();
+				schedule();
 			}
 		}
 		break;
@@ -285,6 +280,7 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 		 * might fail or even deadlock).
 		 */
 		thaw_kernel_threads();
+		schedule();
 		break;
 
 	case SNAPSHOT_PREF_IMAGE_SIZE:

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

