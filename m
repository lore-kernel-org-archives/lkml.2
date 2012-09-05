Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196Ab2IEVBr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 17:01:47 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:20103 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937Ab2IEVBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 17:01:46 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6826"; a="230997338"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] ARM: Fix deadlock scenario with smp_send_stop()
Date: Wed,  5 Sep 2012 14:01:26 -0700
Message-Id: <1346878886-7159-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.12.176.g3fc0e4c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If one process calls sys_reboot and that process then stops other
CPUs while those CPUs are within a spin_lock() region we can
potentially encounter a deadlock scenario like below.

CPU 0                   CPU 1
-----                   -----
                        spin_lock(my_lock)
smp_send_stop()
 send_IPI               handle_IPI()
                         disable_preemption/irqs
                          while(1);
 <PREEMPT>
spin_lock(my_lock) <--- Waits forever

We shouldn't attempt to run any other tasks after we send a stop
IPI to a CPU so disable preemption so that the reboot task runs to
completion.

Reported-by: Sundarajan Srinivasan <sundaraj@codeaurora.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

Unfortunately this won't fix the other problem I mentioned two weeks
ago where smp_send_stop races with other CPUs calling cpu_up().

 arch/arm/kernel/process.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 693b744..663a7a8 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -239,6 +239,7 @@ __setup("reboot=", reboot_setup);
 
 void machine_shutdown(void)
 {
+	preempt_disable();
 #ifdef CONFIG_SMP
 	smp_send_stop();
 #endif
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

