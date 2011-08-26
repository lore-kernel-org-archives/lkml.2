Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab1HZJEf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 05:04:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33762 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab1HZJEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 05:04:30 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux@arm.linux.org.uk, linus.walleij@linaro.org, rpurdie@rpsys.net,
        tony@atomide.com, jochen@scram.de, linux@maxim.org.za,
        nicolas.pitre@linaro.org, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org, jamie@jamieiles.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 01/18] led-triggers: use atomic kzalloc during led trigger registering
Date: Fri, 26 Aug 2011 17:03:18 +0800
Message-Id: <1314349415-889-2-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.5
In-Reply-To: <1314349415-889-1-git-send-email-bryan.wu@canonical.com>
References: <1314349415-889-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kzalloc might cause sleep and will generate some warning detected by lockdep,
when call led_trigger_register_simple on each cpu cores in SMP. This patch fix
this.

[    1.999938] ------------[ cut here ]------------
[    2.004791] WARNING: at kernel/lockdep.c:2664 lockdep_trace_alloc+0xd8/0xf0()
[    2.012298] Modules linked in:
[    2.015563] [<c001b0cc>] (unwind_backtrace+0x0/0xf0) from [<c0052408>] (warn_slowpath_common+0x4c/0x64)
[    2.025451] [<c0052408>] (warn_slowpath_common+0x4c/0x64) from [<c005243c>] (warn_slowpath_null+0x1c/0x24)
[    2.035583] [<c005243c>] (warn_slowpath_null+0x1c/0x24) from [<c008be28>] (lockdep_trace_alloc+0xd8/0xf0)
[    2.045684] [<c008be28>] (lockdep_trace_alloc+0xd8/0xf0) from [<c00feeb4>] (kmem_cache_alloc_trace+0x2c/0x148)
[    2.056213] [<c00feeb4>] (kmem_cache_alloc_trace+0x2c/0x148) from [<c03770a0>] (led_trigger_register_simple+0x20/0x74)
[    2.067474] [<c03770a0>] (led_trigger_register_simple+0x20/0x74) from [<c0627a30>] (ledtrig_cpu_register+0x4c/0x8c)
[    2.078460] [<c0627a30>] (ledtrig_cpu_register+0x4c/0x8c) from [<c0094ca4>] (generic_smp_call_function_single_interrupt+0xcc/0x138)
[    2.090911] [<c0094ca4>] (generic_smp_call_function_single_interrupt+0xcc/0x138) from [<c0008408>] (do_IPI+0xb0/0x128)
[    2.102172] [<c0008408>] (do_IPI+0xb0/0x128) from [<c045921c>] (__irq_svc+0x3c/0x100)
[    2.110412] Exception stack(0xc07adf70 to 0xc07adfb8)
[    2.115722] df60:                                     c07c80f8 0000fb45 00000000 c07c80f8
[    2.124328] df80: c07ac000 c0837be4 c0464b64 c07c9d8c 00000000 411fc092 00000000 00000000
[    2.132934] dfa0: c0649760 c07adfb8 c07c5c58 c0014d50 20000013 ffffffff
[    2.139892] [<c045921c>] (__irq_svc+0x3c/0x100) from [<c0014d50>] (default_idle+0x30/0x38)
[    2.148590] [<c0014d50>] (default_idle+0x30/0x38) from [<c0014f74>] (cpu_idle+0xb4/0xf4)
[    2.157135] [<c0014f74>] (cpu_idle+0xb4/0xf4) from [<c0602778>] (start_kernel+0x2a8/0x2fc)
[    2.165832] [<c0602778>] (start_kernel+0x2a8/0x2fc) from [<80008040>] (0x80008040)
[    2.173797] ---[ end trace 97549d21d8dad3f5 ]---

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 drivers/leds/led-triggers.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index 4bebae7..9a9c78d 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -256,7 +256,7 @@ void led_trigger_register_simple(const char *name, struct led_trigger **tp)
 	struct led_trigger *trigger;
 	int err;
 
-	trigger = kzalloc(sizeof(struct led_trigger), GFP_KERNEL);
+	trigger = kzalloc(sizeof(struct led_trigger), GFP_ATOMIC);
 
 	if (trigger) {
 		trigger->name = name;
-- 
1.7.5

