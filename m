Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab0FCNMG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 09:12:06 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:30773 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243Ab0FCNLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 09:11:34 -0400
X-IronPort-AV: E=Sophos;i="4.53,354,1272859200"; 
   d="scan'208";a="99908973"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: Stefano.Stabellini@eu.citrix.com, xen-devel@lists.xensource.com,
       jeremy@goop.org, ddutile@redhat.com, sheng@linux.intel.com,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 10/12] Do not try to disable hpet if it hasn't been initialized before
Date: Thu,  3 Jun 2010 14:10:43 +0100
Message-Id: <1275570645-27189-10-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1275570645-27189-1-git-send-email-stefano.stabellini@eu.citrix.com>
References: <1275570645-27189-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-OriginalArrivalTime: 03 Jun 2010 13:11:33.0209 (UTC) FILETIME=[49CA5490:01CB031E]
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

