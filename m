Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab2EHEWm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 00:22:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51274 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab2EHEWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 00:22:41 -0400
Date: Mon, 7 May 2012 21:22:27 -0700
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-396e2c6fed4ff13b53ce0e573105531cf53b0cad@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jbeulich@suse.com, JBeulich@suse.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        JBeulich@suse.com, jbeulich@suse.com, tglx@linutronix.de
In-Reply-To: <4F79D0BB020000780007C02D@nat28.tlf.novell.com>
References: <4F79D0BB020000780007C02D@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] x86:
  Clear HPET configuration registers on startup
Git-Commit-ID: 396e2c6fed4ff13b53ce0e573105531cf53b0cad
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 07 May 2012 21:22:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  396e2c6fed4ff13b53ce0e573105531cf53b0cad
Gitweb:     http://git.kernel.org/tip/396e2c6fed4ff13b53ce0e573105531cf53b0cad
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Mon, 2 Apr 2012 15:15:55 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 7 May 2012 15:06:27 +0200

x86: Clear HPET configuration registers on startup

While Linux itself has been calling hpet_disable() for quite a
while, having e.g. a secondary (kexec) kernel depend on such
behavior of the primary (crashed) environment is fragile. It
particularly broke until very recently when the primary
environment was Xen based, as that hypervisor did not clear any
of the HPET settings it may have used.

Rather than blindly (and incompletely) clearing certain HPET
settings in hpet_disable(), latch the config register settings
during boot and restore then here.

(Note on the hpet_set_mode() change: Now that we're clearing the
level bit upon initialization, there's no need anymore to do so
here.)

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Link: http://lkml.kernel.org/r/4F79D0BB020000780007C02D@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/hpet.c |   59 +++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 51 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index ad0de0c..70bce5d 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -319,8 +319,6 @@ static void hpet_set_mode(enum clock_event_mode mode,
 		now = hpet_readl(HPET_COUNTER);
 		cmp = now + (unsigned int) delta;
 		cfg = hpet_readl(HPET_Tn_CFG(timer));
-		/* Make sure we use edge triggered interrupts */
-		cfg &= ~HPET_TN_LEVEL;
 		cfg |= HPET_TN_ENABLE | HPET_TN_PERIODIC |
 		       HPET_TN_SETVAL | HPET_TN_32BIT;
 		hpet_writel(cfg, HPET_Tn_CFG(timer));
@@ -787,15 +785,16 @@ static int hpet_clocksource_register(void)
 	return 0;
 }
 
+static u32 *hpet_boot_cfg;
+
 /**
  * hpet_enable - Try to setup the HPET timer. Returns 1 on success.
  */
 int __init hpet_enable(void)
 {
-	unsigned long hpet_period;
-	unsigned int id;
+	u32 hpet_period, cfg, id;
 	u64 freq;
-	int i;
+	unsigned int i, last;
 
 	if (!is_hpet_capable())
 		return 0;
@@ -847,15 +846,45 @@ int __init hpet_enable(void)
 	id = hpet_readl(HPET_ID);
 	hpet_print_config();
 
+	last = (id & HPET_ID_NUMBER) >> HPET_ID_NUMBER_SHIFT;
+
 #ifdef CONFIG_HPET_EMULATE_RTC
 	/*
 	 * The legacy routing mode needs at least two channels, tick timer
 	 * and the rtc emulation channel.
 	 */
-	if (!(id & HPET_ID_NUMBER))
+	if (!last)
 		goto out_nohpet;
 #endif
 
+	cfg = hpet_readl(HPET_CFG);
+	hpet_boot_cfg = kmalloc((last + 2) * sizeof(*hpet_boot_cfg),
+				GFP_KERNEL);
+	if (hpet_boot_cfg)
+		*hpet_boot_cfg = cfg;
+	else
+		pr_warn("HPET initial state will not be saved\n");
+	cfg &= ~(HPET_CFG_ENABLE | HPET_CFG_LEGACY);
+	hpet_writel(cfg, HPET_Tn_CFG(i));
+	if (cfg)
+		pr_warn("HPET: Unrecognized bits %#x set in global cfg\n",
+			cfg);
+
+	for (i = 0; i <= last; ++i) {
+		cfg = hpet_readl(HPET_Tn_CFG(i));
+		if (hpet_boot_cfg)
+			hpet_boot_cfg[i + 1] = cfg;
+		cfg &= ~(HPET_TN_ENABLE | HPET_TN_LEVEL | HPET_TN_FSB);
+		hpet_writel(cfg, HPET_Tn_CFG(i));
+		cfg &= ~(HPET_TN_PERIODIC | HPET_TN_PERIODIC_CAP
+			 | HPET_TN_64BIT_CAP | HPET_TN_32BIT | HPET_TN_ROUTE
+			 | HPET_TN_FSB | HPET_TN_FSB_CAP);
+		if (cfg)
+			pr_warn("HPET: Unrecognized bits %#x set in cfg#%u\n",
+				cfg, i);
+	}
+	hpet_print_config();
+
 	if (hpet_clocksource_register())
 		goto out_nohpet;
 
@@ -923,14 +952,28 @@ fs_initcall(hpet_late_init);
 void hpet_disable(void)
 {
 	if (is_hpet_capable() && hpet_virt_address) {
-		unsigned int cfg = hpet_readl(HPET_CFG);
+		unsigned int cfg = hpet_readl(HPET_CFG), id, last;
 
-		if (hpet_legacy_int_enabled) {
+		if (hpet_boot_cfg)
+			cfg = *hpet_boot_cfg;
+		else if (hpet_legacy_int_enabled) {
 			cfg &= ~HPET_CFG_LEGACY;
 			hpet_legacy_int_enabled = 0;
 		}
 		cfg &= ~HPET_CFG_ENABLE;
 		hpet_writel(cfg, HPET_CFG);
+
+		if (!hpet_boot_cfg)
+			return;
+
+		id = hpet_readl(HPET_ID);
+		last = ((id & HPET_ID_NUMBER) >> HPET_ID_NUMBER_SHIFT);
+
+		for (id = 0; id <= last; ++id)
+			hpet_writel(hpet_boot_cfg[id + 1], HPET_Tn_CFG(id));
+
+		if (*hpet_boot_cfg & HPET_CFG_ENABLE)
+			hpet_writel(*hpet_boot_cfg, HPET_CFG);
 	}
 }
 
