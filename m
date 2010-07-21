Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab0GURcA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 13:32:00 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:42108 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294Ab0GURb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 13:31:56 -0400
X-IronPort-AV: E=Sophos;i="4.55,239,1278288000"; 
   d="scan'208";a="1007013"
Date: Wed, 21 Jul 2010 18:32:37 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: x86@kernel.org
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Venkatesh Pallipadi (Venki)" <venki@google.com>
Subject: [PATCH] x86: Do not try to disable hpet if it hasn't been initialized
 before
Message-ID: <alpine.DEB.2.00.1007211726240.22235@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hpet_disable is called unconditionally on machine reboot if hpet support
is compiled in the kernel.
hpet_disable only checks if the machine is hpet capable but doesn't make
sure that hpet has been initialized.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Acked-by: Venkatesh Pallipadi <venki@google.com>
---
 arch/x86/kernel/hpet.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index a198b7c..9e90dac 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -964,16 +964,18 @@ fs_initcall(hpet_late_init);
 
 void hpet_disable(void)
 {
-	if (is_hpet_capable()) {
-		unsigned int cfg = hpet_readl(HPET_CFG);
+	unsigned int cfg;
 
-		if (hpet_legacy_int_enabled) {
-			cfg &= ~HPET_CFG_LEGACY;
-			hpet_legacy_int_enabled = 0;
-		}
-		cfg &= ~HPET_CFG_ENABLE;
-		hpet_writel(cfg, HPET_CFG);
+	if (!is_hpet_capable() || !hpet_address || !hpet_virt_address)
+		return;
+
+	cfg = hpet_readl(HPET_CFG);
+	if (hpet_legacy_int_enabled) {
+		cfg &= ~HPET_CFG_LEGACY;
+		hpet_legacy_int_enabled = 0;
 	}
+	cfg &= ~HPET_CFG_ENABLE;
+	hpet_writel(cfg, HPET_CFG);
 }
 
 #ifdef CONFIG_HPET_EMULATE_RTC
-- 
1.7.0.4

