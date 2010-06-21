Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142Ab0FUQY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 12:24:27 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:18059 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758121Ab0FUQYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 12:24:19 -0400
X-IronPort-AV: E=Sophos;i="4.53,453,1272859200"; 
   d="scan'208";a="102450223"
From: stefano@stabellini.net
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, Stefano.Stabellini@eu.citrix.com,
       sheng@linux.intel.com, ddutile@redhat.com, jeremy@goop.org,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 10/13] Do not try to disable hpet if it hasn't been initialized before
Date: Mon, 21 Jun 2010 17:14:04 +0100
Message-Id: <1277136847-13266-10-git-send-email-stefano@stabellini.net>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1006211456360.18470@kaball-desktop>
References: <alpine.DEB.2.00.1006211456360.18470@kaball-desktop>
X-OriginalArrivalTime: 21 Jun 2010 16:14:50.0192 (UTC) FILETIME=[DFF04500:01CB115C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

hpet_disable is called unconditionally on machine reboot if hpet support
is compiled in the kernel.
hpet_disable only checks if the machine is hpet capable but doesn't make
sure that hpet has been initialized.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/kernel/hpet.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 23b4ecd..2b299da 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -959,16 +959,18 @@ fs_initcall(hpet_late_init);
 
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

