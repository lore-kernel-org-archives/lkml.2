Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932848Ab1DMUzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 16:55:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42801 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932296Ab1DMUzq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 16:55:46 -0400
MIME-Version: 1.0
In-Reply-To: <4DA60C30.4060606@kernel.org>
References: <BANLkTimNvX=U6qy2FgvDpWE6HY7cehWvyQ@mail.gmail.com>
 <20110412090207.GE19819@8bytes.org> <BANLkTimSgAmT5a1s0ciBr2jsE-Nu7n4buQ@mail.gmail.com>
 <20110412184433.GF19819@8bytes.org> <20110413064609.GA18777@elte.hu>
 <20110413172147.GI19819@8bytes.org> <4DA5F62F.3030504@kernel.org>
 <20110413193459.GL19819@8bytes.org> <4DA60C30.4060606@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 13 Apr 2011 13:54:55 -0700
Message-ID: <BANLkTik7W0u92n_s0t32dsoLULu4QTZneA@mail.gmail.com>
Subject: Re: Linux 2.6.39-rc3
To: Yinghai Lu <yinghai@kernel.org>
Cc: Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@elte.hu>,
        Alex Deucher <alexdeucher@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 1:48 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>
> can you try following change ? it will push gart to 0x80000000
>
> diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
> index 86d1ad4..3b6a9d5 100644
> --- a/arch/x86/kernel/aperture_64.c
> +++ b/arch/x86/kernel/aperture_64.c
> @@ -83,7 +83,7 @@ static u32 __init allocate_aperture(void)
>         * so don't use 512M below as gart iommu, leave the space for kernel
>         * code for safe
>         */
> -       addr = memblock_find_in_range(0, 1ULL<<32, aper_size, 512ULL<<20);
> +       addr = memblock_find_in_range(0, 1ULL<<32, aper_size, 512ULL<<21);

What are all the magic numbers, and why would 0x80000000 be special?

Why don't we write code that just works?

Or absent a "just works" set of patches, why don't we revert to code
that has years of testing?

This kind of "I broke things, so now I will jiggle things randomly
until they unbreak" is not acceptable.

Either explain why that fixes a real BUG (and why the magic constants
need to be what they are), or just revert the patch that caused the
problem, and go back to the allocation patters that have years of
experience.

Guys, we've had this discussion before, in PCI allocation. We don't do
this. We tried switching the PCI region allocations to top-down, and
IT WAS A FAILURE. We reverted it to what we had years of testing with.

Don't just make random changes. There really are only two acceptable
models of development: "think and analyze" or "years and years of
testing on thousands of machines". Those two really do work.

                   Linus
