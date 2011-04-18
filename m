Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327Ab1DROBl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 10:01:41 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:42280 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927Ab1DROBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 10:01:15 -0400
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>, EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Nagananda Chumbalkar <Nagananda.Chumbalkar@hp.com>,
        Prarit Bhargava <prarit@redhat.com>, Russ Anderson <rja@sgi.com>
Subject: [PATCH -v2 1/2] x86, MCE: Do not taint when handling correctable errors
Date: Mon, 18 Apr 2011 16:00:21 +0200
Message-Id: <1303135222-17118-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Correctable errors are considered something rather normal on modern
hardware these days. Even more importantly, correctable errors mean
exactly that - they've been corrected by the hardware - and there's no
need to taint the kernel since execution hasn't been compromised so far.

Also, drop tainting in the thermal throttling code for a similar reason:
crossing a thermal threshold does not mean corruption.

Cc: Nagananda Chumbalkar <Nagananda.Chumbalkar@hp.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Acked-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c         |    1 -
 arch/x86/kernel/cpu/mcheck/therm_throt.c |    3 ---
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 3385ea2..68e2303 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -590,7 +590,6 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 		if (!(flags & MCP_DONTLOG) && !mce_dont_log_ce) {
 			mce_log(&m);
 			atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, &m);
-			add_taint(TAINT_MACHINE_CHECK);
 		}
 
 		/*
diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index 6f8c5e9..5846a79 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -187,8 +187,6 @@ static int therm_throt_process(bool new_event, int event, int level)
 				this_cpu,
 				level == CORE_LEVEL ? "Core" : "Package",
 				state->count);
-
-		add_taint(TAINT_MACHINE_CHECK);
 		return 1;
 	}
 	if (old_event) {
@@ -393,7 +391,6 @@ static void unexpected_thermal_interrupt(void)
 {
 	printk(KERN_ERR "CPU%d: Unexpected LVT thermal interrupt!\n",
 			smp_processor_id());
-	add_taint(TAINT_MACHINE_CHECK);
 }
 
 static void (*smp_thermal_vector)(void) = unexpected_thermal_interrupt;
-- 
1.7.4.rc2

