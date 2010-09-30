Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab0I3MgL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 08:36:11 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50609 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab0I3MgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 08:36:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mMW/hxPybBDhAHIFfuSEqhc7V6POLs9T/xwfxeARb4ukewlrtpbs6cNVPPMZdTD5Sd
         mMBNSrCcz2EjTJltMl1mqXjgslnC0oCRASrvwnIqfUqO7xZ6GuRZvTwYbiVE3OXlOAfZ
         GfiJ+SN26q3Ya5WHBIJ9yCTol+18188ACXchI=
Date: Thu, 30 Sep 2010 14:32:35 +0200
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] x86, mtrr: Assume SYS_CFG[Tom2ForceMemTypeWB] exists
 on all future AMD CPUs
Message-ID: <20100930123235.GB20545@loge.amd.com>
References: <20100930121839.GA20545@loge.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100930121839.GA20545@loge.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Herrmann <andreas.herrmann3@amd.com>

Instead of adapting the CPU family check in amd_special_default_mtrr()
for each new CPU family assume that all new AMD CPUs support the
necessary bits in SYS_CFG MSR.

Tom2Enabled is architectural (defined in APM Vol.2).
Tom2ForceMemTypeWB is defined in all BKDGs starting with K8 NPT.
In pre K8-NPT BKDG this bit is reserved (read as zero).

W/o this adaption Linux would unnecessarily complain about bad MTRR
settings on every new AMD CPU family, e.g.

[    0.000000] WARNING: BIOS bug: CPU MTRRs don't cover all of memory, losing 4863MB of RAM.

Cc: stable@kernel.org # .32.x, .35.x
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/cpu/mtrr/cleanup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/cleanup.c b/arch/x86/kernel/cpu/mtrr/cleanup.c
index c5f59d0..ac140c7 100644
--- a/arch/x86/kernel/cpu/mtrr/cleanup.c
+++ b/arch/x86/kernel/cpu/mtrr/cleanup.c
@@ -827,7 +827,7 @@ int __init amd_special_default_mtrr(void)
 
 	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD)
 		return 0;
-	if (boot_cpu_data.x86 < 0xf || boot_cpu_data.x86 > 0x11)
+	if (boot_cpu_data.x86 < 0xf)
 		return 0;
 	/* In case some hypervisor doesn't pass SYSCFG through: */
 	if (rdmsr_safe(MSR_K8_SYSCFG, &l, &h) < 0)
-- 
1.6.4.4

