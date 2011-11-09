Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522Ab1KIReS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 12:34:18 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:60785 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118Ab1KIReR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 12:34:17 -0500
Date: Wed, 9 Nov 2011 18:34:12 +0100
From: Borislav Petkov <bp@amd64.org>
To: Daniel Drake <dsd@laptop.org>
Cc: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Geode LX boot fails after x86 microcode revision change
Message-ID: <20111109173412.GE14181@aftab>
References: <CAMLZHHTSuHZoPbm_YfB8G05JA+xKCE4+Jmj4NW8mnZUHogQSBA@mail.gmail.com>
 <20111108203116.GF25083@aftab>
 <4EB9A6BC.7050600@zytor.com>
 <F625F33982F5D847987879CC59FF132D6F5B@storexdag03.amd.com>
 <CAMLZHHTu-FNphvt5_L7fxqRpPukfs8nbS71x3GYo5GsPBo5cNw@mail.gmail.com>
 <20111108223744.GA1996@x1.osrc.amd.com>
 <CAMLZHHRc+yNr=6SB7Z1t_hyL+e8a0T-BokyQ+wVUPw-vhd3rQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMLZHHRc+yNr=6SB7Z1t_hyL+e8a0T-BokyQ+wVUPw-vhd3rQA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 04:59:05PM -0600, Daniel Drake wrote:
> On Tue, Nov 8, 2011 at 4:37 PM, Borislav Petkov <bp@alien8.de> wrote:
> > Yep, just send me /proc/cpuinfo from a working kernel.

Daniel, would you please test? It should work though :-)

Thanks.

--
>From daa04c94628d5686404bd6985d4545f12c2fa4fd Mon Sep 17 00:00:00 2001
From: Borislav Petkov <borislav.petkov@amd.com>
Date: Wed, 9 Nov 2011 18:08:40 +0100
Subject: [PATCH] x86, microcode, AMD: Restrict microcode reporting

bcb80e53877c ("x86, microcode, AMD: Add microcode revision to
/proc/cpuinfo") added support for dumping microcode patch level in
/proc/cpuinfo on AMD. Although we were very cautious and did rdmsr_safe
on the microcode patch level MSR, this broke booting on Geode LX because
this CPU doesn't have that MSR and at the time we do the read, exception
tables which are used by rdmsr_safe are not yet initialized, leading to
a boot hang.

This is the simple fix which enables the microcode line in /proc/cpuinfo
for K8 and newer (it is not that interesting for older boxes anyway
:-)).

Reported-and-bisected-by: Daniel Drake <dsd@laptop.org>
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


-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
