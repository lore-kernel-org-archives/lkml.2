Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933585Ab2JZO4a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 10:56:30 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57358 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932853Ab2JZO42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 10:56:28 -0400
Date: Fri, 26 Oct 2012 16:56:23 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andre Przywara <andre.przywara@amd.com>
Cc: hpa@zytor.com, tglx@linutronix.de, mingo@elte.hu,
        linux-kernel@vger.kernel.org, andreas.herrmann3@amd.com
Subject: Re: [PATCH] x86/amd: disable way access filter on affected CPUs
Message-ID: <20121026145623.GA15912@gmail.com>
References: <1351065377-1989-1-git-send-email-andre.przywara@amd.com>
 <20121024104609.GA13010@gmail.com>
 <50880AD7.2030806@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50880AD7.2030806@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andre Przywara <andre.przywara@amd.com> wrote:

> On 10/24/2012 12:46 PM, Ingo Molnar wrote:
> >
> >* Andre Przywara <andre.przywara@amd.com> wrote:
> >
> >>The WAF may hurt the performance of some workloads, caused by
> >>aliasing issues in the L1 cache.
> >>Disable it on the affected CPUs.
> >>
> >>Signed-off-by: Andre Przywara <andre.przywara@amd.com>
> >>---
> >>  arch/x86/kernel/cpu/amd.c | 14 ++++++++++++++
> >>  1 file changed, 14 insertions(+)
> >>
> >>diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> >>index f7e98a2..1b7d165 100644
> >>--- a/arch/x86/kernel/cpu/amd.c
> >>+++ b/arch/x86/kernel/cpu/amd.c
> >>@@ -631,6 +631,20 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
> >>  		}
> >>  	}
> >>
> >>+	/*
> >>+	 * The way access filter has a performance penalty on some workloads.
> >>+	 * Disable it on the affected CPUs.
> >>+	 */
> >>+	if ((c->x86 == 0x15) &&
> >>+	    (c->x86_model >= 0x02) && (c->x86_model < 0x20)) {
> >>+		u64 val;
> >>+
> >>+		if (!rdmsrl_safe(0xc0011021, &val) && !(val & 0x1E)) {
> >>+			val |= 0x1E;
> >>+			wrmsrl_safe(0xc0011021, val);
> >>+		}
> >>+	}
> >
> >Would be nice to hear more about the background of this change,
> >about the amount of 'penalty' and the nature of the workloads.
> 
> The issue is similar to that one of last year:
> http://lkml.indiana.edu/hypermail/linux/kernel/1107.3/00041.html
> That new patch does not replace the old one, we just need another
> quirk for newer CPUs.
> 
> The penalty depends on the circumstances, if you need a number, I
> can only tell you the 3% from last year.
> 
> The workloads would be those that access code from the same physical
> page under different virtual addresses, so different processes using
> the same libraries with ASLR or multiple instances of PIE-binaries.
> The code needs to be accessed simultaneously from both cores of the
> same compute unit.
> 
> More details here:
> http://developer.amd.com/Assets/SharedL1InstructionCacheonAMD15hCPU.pdf
> 
> >Also, it would be useful to know how the [0x02..0x1f] model
> >range was chosen.
> 
> That is everything that has the core known as Piledriver.
> That includes the AMD A-Series (aka Trinity) and the just released
> new CPUs of the FX-Series (aka Vishera).
> The model numbering is a bit odd here: FX CPUs have model 2,
> A-Series has model 10h, with possible extensions to 1Fh. Hence the
> range of model ids.
> Model 2 CPUs should have the fix in BIOS, but I guess there are
> quite some boxes out there which will not be updated. Better safe
> than sorry.

Most of this info makes a perfect changelog entry - mind sending 
an updated v2 patch with this information included?

Thanks,

	Ingo
