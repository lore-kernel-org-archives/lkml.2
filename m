Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520Ab1EUT1o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 15:27:44 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:39858 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752910Ab1EUT1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 15:27:42 -0400
From: Matt Fleming <matt@console-pimps.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@linux.intel.com>
Subject: [PATCH] timers: Don't oops when no rtc devices are found
Date: Sat, 21 May 2011 20:27:37 +0100
Message-Id: <1306006057-5150-1-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@linux.intel.com>

Currently we check if 'str' is NULL but we don't initialise it before
passing it to class_find_device(). If no rtc devices are found then
'str' can contain garbage, which can cause the following oops if we
dereference it,

  | BUG: unable to handle kernel NULL pointer dereference at 00000246
  | IP: [<c05c461c>] strcmp+0xf/0x22
  | *pdpt = 0000000000000000 *pde = 0000000000000000
  | Oops: 0000 [#1] SMP
  | Modules linked in:
  |
  | Pid: 1, comm: swapper Not tainted 2.6.39+ #25
  | EIP: 0060:[<c05c461c>] EFLAGS: 00000246 CPU: 0
  | EIP is at strcmp+0xf/0x22
  | EAX: dc348b72 EBX: df45df7c ECX: dc388c00 EDX: 00000246
  | ESI: dc348b79 EDI: 00000246 EBP: df45df68 ESP: df45df60
  |  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
  | Process swapper (pid: 1, ti=df45c000 task=df460000 task.ti=df45c000)
  | Stack:
  |  00000000 dc388c00 df45df70 c06e3a40 df45df94 c0669712 00000246 df4d043c
  |  dc388d3c 00000000 c0aa604c 00000000 00000000 df45dfac c06e39ce c06e3a27
  |  c0aa604c 00000001 00000000 df45dfb8 c0a3db8f 00000246 df45dfd4 c0403158
  | Call Trace:
  |  [<c06e3a40>] __rtc_match+0x19/0x23
  |  [<c0669712>] class_find_device+0x58/0x84
  |  [<c06e39ce>] rtc_class_open+0x20/0x79
  |  [<c06e3a27>] ? rtc_class_open+0x79/0x79
  |  [<c0a3db8f>] alarmtimer_init_late+0x27/0x52
  |  [<c0403158>] do_one_initcall+0x76/0x122
  |  [<c0a3db68>] ? alarmtimer_init+0x121/0x121
  |  [<c0a27805>] kernel_init+0xb7/0x132
  |  [<c0a2774e>] ? start_kernel+0x333/0x333
  |  [<c07cac3e>] kernel_thread_helper+0x6/0x10

Furthermore, we should be checking the return value of
class_find_device() to decide whether an rtc device was found or not,
since that it is the how the function is designed to be used.

Signed-off-by: Matt Fleming <matt.fleming@linux.intel.com>
---
 kernel/time/alarmtimer.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index 9265014..968da75 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -669,11 +669,12 @@ static int __init has_wakealarm(struct device *dev, void *name_ptr)
  */
 static int __init alarmtimer_init_late(void)
 {
-	char *str;
+	struct device *dev;
+	char *str = NULL;
 
 	/* Find an rtc device and init the rtc_timer */
-	class_find_device(rtc_class, NULL, &str, has_wakealarm);
-	if (str)
+	dev = class_find_device(rtc_class, NULL, &str, has_wakealarm);
+	if (dev && str)
 		rtcdev = rtc_class_open(str);
 	if (!rtcdev) {
 		printk(KERN_WARNING "No RTC device found, ALARM timers will"
-- 
1.7.4.4

