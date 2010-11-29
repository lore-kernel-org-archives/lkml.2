Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab0K2WhK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 17:37:10 -0500
Received: from www.tglx.de ([62.245.132.106]:38883 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754941Ab0K2WhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 17:37:08 -0500
Date: Mon, 29 Nov 2010 23:36:05 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Borislav Petkov <bp@amd64.org>
cc: "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        john stultz <johnstul@us.ibm.com>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>, "avi@redhat.com" <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: [PATCH -v1.1] HPET: Fix HPET readout for small deltas
In-Reply-To: <20101129155254.GC1170@aftab>
Message-ID: <alpine.LFD.2.00.1011292322080.2900@localhost6.localdomain6>
References: <20101129155254.GC1170@aftab>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Nov 2010, Borislav Petkov wrote:
>  
> +	/* Accept only sensible values written by BIOS */
> +	if (hpet_tbl->minimum_tick < hpet_min_tick)
> +		hpet_min_tick = hpet_tbl->minimum_tick;

I ran this through everything I could get hold of. And as I feared
when ACPI was mentioned in the first place, I found at least three
machines which have hpet_tbl->minimum_tick < 4. Two of those failed to
boot.

This is all doomed to fail. 

1) ACPI's trustworthiness aproaches ZERO

2) The chipset manufactures who implement the "HPET spec" are even
   worse. They could tell us the exact number of cycles which are
   necessary to make these "specificatin compliant" trainwrecks
   functional, but all we get is a reference to #1.

Crap. If you don't come up with some real facts, I'm simply going to
commit

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index ae03cab..0388a70 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -408,7 +408,7 @@ static int hpet_next_event(unsigned long delta,
 	 */
 	res = (s32)(cnt - hpet_readl(HPET_COUNTER));
 
-	return res < 8 ? -ETIME : 0;
+	return res < 128 ? -ETIME : 0;
 }
 
 static void hpet_legacy_set_mode(enum clock_event_mode mode,

along with the corresponding fix for the min_delta_ns value.

Thanks,

	tglx
