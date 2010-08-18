Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab0HRQOl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 12:14:41 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:45466 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab0HRQOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 12:14:38 -0400
Date: Wed, 18 Aug 2010 18:16:39 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@alien8.de>, Alok Kataria <akataria@vmware.com>,
        the arch/x86 maintainers <x86@kernel.org>, Greg KH <gregkh@suse.de>,
        "greg@kroah.com" <greg@kroah.com>,
        "ksrinivasan@novell.com" <ksrinivasan@novell.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86, tsc: Limit CPU frequency calibration on AMD
Message-ID: <20100818161639.GF9880@aftab>
References: <1281986754.23253.32.camel@ank32.eng.vmware.com>
 <4C69D02F.6090601@zytor.com>
 <1282024311.20786.2.camel@ank32.eng.vmware.com>
 <4C6A2C98.4060605@zytor.com>
 <20100817070520.GD32714@liondog.tnic>
 <1282063532.4388.8.camel@ank32.eng.vmware.com>
 <20100817185634.GA10597@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100817185634.GA10597@liondog.tnic>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

6b37f5a20c0e5c334c010a587058354215433e92 introduced the CPU frequency
calibration code for AMD CPUs whose TSCs didn't increment with the
core's P0 frequency. From F10h, revB onward, the TSC increment rate is
denoted by MSRC001_0015[24] and when this bit is set (which is normally
done by the BIOS,) the TSC increments with the P0 frequency so the
calibration is not needed and booting can be a couple of mcecs faster on
those machines.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/tsc.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index ce8e502..41b2b8b 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -927,8 +927,18 @@ void __init tsc_init(void)
 	}
 
 	if (cpu_has(&boot_cpu_data, X86_FEATURE_CONSTANT_TSC) &&
-			(boot_cpu_data.x86_vendor == X86_VENDOR_AMD))
-		cpu_khz = calibrate_cpu();
+			(boot_cpu_data.x86_vendor == X86_VENDOR_AMD)) {
+
+		if (boot_cpu_data.x86 > 0x10 ||
+		    (boot_cpu_data.x86 == 0x10 &&
+		     boot_cpu_data.x86_model >= 0x2)) {
+			u64 val;
+
+			rdmsrl(MSR_K7_HWCR, val);
+			if (!(val & BIT(24)))
+				cpu_khz = calibrate_cpu();
+		}
+	}
 
 	printk("Detected %lu.%03lu MHz processor.\n",
 			(unsigned long)cpu_khz / 1000,
-- 
1.7.1


-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
