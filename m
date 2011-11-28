Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab1K1OBr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 09:01:47 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:37592 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab1K1OBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 09:01:46 -0500
Date: Mon, 28 Nov 2011 15:01:43 +0100
From: Borislav Petkov <bp@amd64.org>
To: Bob Tracy <rct@gherkin.frus.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] 3.2-rcX regression: boot failure on AMD K6-III/450
Message-ID: <20111128140143.GA4522@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@amd64.org>,
	Bob Tracy <rct@gherkin.frus.com>, linux-kernel@vger.kernel.org
References: <20111126181724.GA1993@gherkin.frus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20111126181724.GA1993@gherkin.frus.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Nov 26, 2011 at 12:17:24PM -0600, Bob Tracy wrote:
> Verified for 3.2-rc[1-3].  Subject system using LILO as bootloader.
> The following messages appear on the console:
> 
> Loading linux-dev.
> BIOS data check successful
> Probing EDD (edd=off to disable)... ok
> <blank line>
> Decompressing Linux... Parsing ELF... done.
> Booting the kernel.
> <hang here -- no further output>
> 
> The console output is normal and expected up to the point of the hang.
> Versions 3.1 and prior work fine.  I had earlier thought the floppy
> regression Pavel reported applied to my case (and it may), but I don't
> seem to be getting that far in the boot process.

can you try the following patch:

--
From: Borislav Petkov <borislav.petkov@amd.com>
Date: Wed, 9 Nov 2011 18:08:40 +0100
Subject: [PATCH] x86, microcode, AMD: Restrict microcode reporting

bcb80e53877c ("x86, microcode, AMD: Add microcode revision to
/proc/cpuinfo") added support for dumping microcode patch level in
/proc/cpuinfo on AMD. Although we were very cautious and did rdmsr_safe
the microcode patch level MSR, this broke booting on Geode LX because
this CPU doesn't have that MSR and at the time we do the read, exception
tables which are used by rdmsr_safe are not yet initialized, leading to
the boot hang.

This is the simple fix which enables the microcode line in /proc/cpuinfo
for K8 and newer (it is not that interesting for older boxes anyway :-)).

Reported-and-bisected-and-tested-by: Daniel Drake <dsd@laptop.org>
Link: http://lkml.kernel.org/r/CAMLZHHTSuHZoPbm_YfB8G05JA+xKCE4+Jmj4NW8mnZUHogQSBA@mail.gmail.com
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/amd.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index c7e46cb..a72d183 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -474,7 +474,8 @@ static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 	}
 #endif
 
-	rdmsr_safe(MSR_AMD64_PATCH_LEVEL, &c->microcode, &dummy);
+	if (c->x86 >= 0xf)
+		rdmsr_safe(MSR_AMD64_PATCH_LEVEL, &c->microcode, &dummy);
 }
 
 static void __cpuinit init_amd(struct cpuinfo_x86 *c)
-- 
1.7.8.rc0

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
