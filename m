Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706Ab0CRJHk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 05:07:40 -0400
Received: from mail-yx0-f191.google.com ([209.85.210.191]:60035 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab0CRJHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 05:07:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=boshB3I5ixj4xAHFvp1xp35cFgcdoiIJq2dqOzoYWM8hikD4sIoM/5iIlz0BXglhN1
         p57pZI+I1KRY/7ap3Ps31A3al5Sl/3I5z6715CH5xkdoZibeecVUkEuJlVPrRLWClBL2
         L5r9nVn26XoaA+Oanvca1iTSzjUbgO9nvcAcQ=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 02/12] cpu-hotplug: return better errno on cpu hotplug failure
Date: Thu, 18 Mar 2010 18:05:14 +0900
Message-Id: <1268903124-10237-2-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1268903124-10237-1-git-send-email-akinobu.mita@gmail.com>
References: <1268903124-10237-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, onlining or offlining a CPU failure by one of the cpu
notifiers error always cause -EINVAL error.
(i.e. writing 0 or 1 to /sys/devices/system/cpu/cpuX/online gets EINVAL)

To get better error reporting rather than always getting -EINVAL,
This changes cpu_notify() to return -errno value with notifier_to_errno() and
fix the callers. Now that cpu notifiers can return encapsulate errno value.

Currently, all cpu hotplug notifiers return NOTIFY_OK, NOTIFY_BAD,
or NOTIFY_DONE. So cpu_notify() can returns 0 or -EPERM with this change
for now.
(notifier_to_errno(NOTIFY_OK) == 0, notifier_to_errno(NOTIFY_DONE) == 0,
notifier_to_errno(NOTIFY_BAD) == -EPERM)

Forthcoming patches convert several cpu notifiers to return encapsulate
errno value with notifier_from_errno().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/cpu.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index bc9c301..d3f335e 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -136,8 +136,12 @@ int __ref register_cpu_notifier(struct notifier_block *nb)
 static int __cpu_notify(unsigned long val, void *v, int nr_to_call,
 			int *nr_calls)
 {
-	return __raw_notifier_call_chain(&cpu_chain, val, v, nr_to_call,
+	int ret;
+
+	ret = __raw_notifier_call_chain(&cpu_chain, val, v, nr_to_call,
 					nr_calls);
+
+	return notifier_to_errno(ret);
 }
 
 static int cpu_notify(unsigned long val, void *v)
@@ -150,7 +154,7 @@ static void cpu_notify_nofail(unsigned long val, void *v)
 	int err;
 
 	err = cpu_notify(val, v);
-	BUG_ON(err == NOTIFY_BAD);
+	BUG_ON(err);
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
@@ -230,14 +234,13 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 	cpu_hotplug_begin();
 	set_cpu_active(cpu, false);
 	err = __cpu_notify(CPU_DOWN_PREPARE | mod, hcpu, -1, &nr_calls);
-	if (err == NOTIFY_BAD) {
+	if (err) {
 		set_cpu_active(cpu, true);
 
 		nr_calls--;
 		__cpu_notify(CPU_DOWN_FAILED | mod, hcpu, nr_calls, NULL);
 		printk("%s: attempt to take down CPU %u failed\n",
 				__func__, cpu);
-		err = -EINVAL;
 		goto out_release;
 	}
 
@@ -314,11 +317,10 @@ static int __cpuinit _cpu_up(unsigned int cpu, int tasks_frozen)
 
 	cpu_hotplug_begin();
 	ret = __cpu_notify(CPU_UP_PREPARE | mod, hcpu, -1, &nr_calls);
-	if (ret == NOTIFY_BAD) {
+	if (ret) {
 		nr_calls--;
 		printk("%s: attempt to bring up CPU %u failed\n",
 				__func__, cpu);
-		ret = -EINVAL;
 		goto out_notify;
 	}
 
-- 
1.6.0.6

