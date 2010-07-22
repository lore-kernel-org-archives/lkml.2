Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab0GVXWr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 19:22:47 -0400
Received: from claw.goop.org ([74.207.240.146]:49431 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043Ab0GVXWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 19:22:46 -0400
Message-ID: <4C48D2C2.20303@goop.org>
Date: Thu, 22 Jul 2010 16:22:42 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Lightning/1.0b2pre Thunderbird/3.0.5
MIME-Version: 1.0
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
CC: the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Venkatesh Pallipadi <venki@google.com>
Subject: [PATCH] x86: Do not try to disable hpet if it hasn't been initialized
 before
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ x86 folk: While this patch is just a generic x86 bugfix, it really only affects
  the Xen pv-on-hvm patch series that I'm going to post shortly.  Do you want to
  commit it separately via tip.git, or are you OK with me sending it to Linus
  directly? - J ]

hpet_disable is called unconditionally on machine reboot if hpet support
is compiled in the kernel.
hpet_disable only checks if the machine is hpet capable but doesn't make
sure that hpet has been initialized.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Acked-by: Venkatesh Pallipadi <venki@google.com>

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


