Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab1ACN5t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 08:57:49 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36659 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754977Ab1ACNuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 08:50:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=tqhH0fI6qtfr6bEXLu07HBGLh1/9kcmPqmwiR4HvxiQK4m5+htaurjmAziCs1Q2lJN
         ASNtmpTdQ9Jw39g6Q5z0K241UNhDOyLlijHJhczqrTB52cW02Hq4r10HkSARrdLeQn42
         YJnUOyoBoMpZOl71UFGgQ0LeOXlj0w8k5+75k=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        linuxppc-dev@lists.ozlabs.org, Dave Jones <davej@redhat.com>,
        cpufreq@vger.kernel.org
Subject: [PATCH 02/32] powerpc/cell: use system_wq in cpufreq_spudemand
Date: Mon,  3 Jan 2011 14:49:25 +0100
Message-Id: <1294062595-30097-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1294062595-30097-1-git-send-email-tj@kernel.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With cmwq, there's no reason to use a separate workqueue in
cpufreq_spudemand.  Use system_wq instead.  The work items are already
sync canceled on stop, so it's already guaranteed that no work is
running when spu_gov_exit() is entered.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: Dave Jones <davej@redhat.com>
Cc: cpufreq@vger.kernel.org
---
Only compile tested.  Please feel free to take it into the subsystem
tree or simply ack - I'll route it through the wq tree.

Thanks.

 arch/powerpc/platforms/cell/cpufreq_spudemand.c |   20 +++-----------------
 1 files changed, 3 insertions(+), 17 deletions(-)

diff --git a/arch/powerpc/platforms/cell/cpufreq_spudemand.c b/arch/powerpc/platforms/cell/cpufreq_spudemand.c
index 968c1c0..d809836 100644
--- a/arch/powerpc/platforms/cell/cpufreq_spudemand.c
+++ b/arch/powerpc/platforms/cell/cpufreq_spudemand.c
@@ -39,8 +39,6 @@ struct spu_gov_info_struct {
 };
 static DEFINE_PER_CPU(struct spu_gov_info_struct, spu_gov_info);
 
-static struct workqueue_struct *kspugov_wq;
-
 static int calc_freq(struct spu_gov_info_struct *info)
 {
 	int cpu;
@@ -71,14 +69,14 @@ static void spu_gov_work(struct work_struct *work)
 	__cpufreq_driver_target(info->policy, target_freq, CPUFREQ_RELATION_H);
 
 	delay = usecs_to_jiffies(info->poll_int);
-	queue_delayed_work_on(info->policy->cpu, kspugov_wq, &info->work, delay);
+	schedule_delayed_work_on(info->policy->cpu, &info->work, delay);
 }
 
 static void spu_gov_init_work(struct spu_gov_info_struct *info)
 {
 	int delay = usecs_to_jiffies(info->poll_int);
 	INIT_DELAYED_WORK_DEFERRABLE(&info->work, spu_gov_work);
-	queue_delayed_work_on(info->policy->cpu, kspugov_wq, &info->work, delay);
+	schedule_delayed_work_on(info->policy->cpu, &info->work, delay);
 }
 
 static void spu_gov_cancel_work(struct spu_gov_info_struct *info)
@@ -152,27 +150,15 @@ static int __init spu_gov_init(void)
 {
 	int ret;
 
-	kspugov_wq = create_workqueue("kspugov");
-	if (!kspugov_wq) {
-		printk(KERN_ERR "creation of kspugov failed\n");
-		ret = -EFAULT;
-		goto out;
-	}
-
 	ret = cpufreq_register_governor(&spu_governor);
-	if (ret) {
+	if (ret)
 		printk(KERN_ERR "registration of governor failed\n");
-		destroy_workqueue(kspugov_wq);
-		goto out;
-	}
-out:
 	return ret;
 }
 
 static void __exit spu_gov_exit(void)
 {
 	cpufreq_unregister_governor(&spu_governor);
-	destroy_workqueue(kspugov_wq);
 }
 
 
-- 
1.7.1

