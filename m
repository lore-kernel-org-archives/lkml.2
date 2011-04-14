Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556Ab1DNJL7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 05:11:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57334 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932493Ab1DNJL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 05:11:58 -0400
Date: Thu, 14 Apr 2011 11:11:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joro@8bytes.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Alex Deucher <alexdeucher@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Thomas Gleixner <tglx@linutronix.de>,
        Tejun Heo <tj@kernel.org>
Subject: Re: Linux 2.6.39-rc3
Message-ID: <20110414091137.GC9248@elte.hu>
References: <BANLkTimNvX=U6qy2FgvDpWE6HY7cehWvyQ@mail.gmail.com>
 <20110412090207.GE19819@8bytes.org>
 <BANLkTimSgAmT5a1s0ciBr2jsE-Nu7n4buQ@mail.gmail.com>
 <20110412184433.GF19819@8bytes.org>
 <20110413064609.GA18777@elte.hu>
 <20110413172147.GI19819@8bytes.org>
 <4DA5F62F.3030504@kernel.org>
 <4DA654D6.2060103@zytor.com>
 <20110414085624.GC18463@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110414085624.GC18463@8bytes.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joerg Roedel <joro@8bytes.org> wrote:

> On Wed, Apr 13, 2011 at 06:58:46PM -0700, H. Peter Anvin wrote:
> > On 04/13/2011 12:14 PM, Yinghai Lu wrote:
> > > 
> > > so looks bios program wrong address to the radon card?
> > > 
> > 
> > Okay, staring at this, it definitely seems toxic to overlay the GART
> > over memory areas reserved by the BIOS.  If I were to guess, I would say
> > that the problem here seems to be that the kernel thinks it is
> > overlaying 64 MiB of memory, but the actual GART is in fact 512 MiB in
> > size -- 131072 CPU pages -- which now overlaps the BIOS reserved areas.
> > 
> > Alex D., could you comment on the "num cpu pages" bit?
> 
> Okay, I tried the debug-patch from Yinghai (posted to the bugzilla):
> 
> --- a/drivers/gpu/drm/radeon/radeon_device.c
> +++ b/drivers/gpu/drm/radeon/radeon_device.c
> @@ -325,6 +325,8 @@ void radeon_gtt_location(struct radeon_device *rdev, struct radeon_mc *mc)
>                         mc->gtt_size = size_bf;
>                 }
>                 mc->gtt_start = (mc->vram_start & ~mc->gtt_base_align) - mc->gtt_size;
> +               if (mc->gtt_start == 0xa0000000)
> +                       mc->gtt_start = 0x80000000;
>         } else {
>                 if (mc->gtt_size > size_af) {
>                         dev_warn(rdev->dev, "limiting GTT\n");
> 
> And this makes a difference, with this change on-top of -rc3 the box boots
> fine. So there seems to be some dependency between the GART base and the GTT
> base even when they are in different address spaces.
> 
> Alex, can you comment on this?

I'd strongly suggest we revert back to the old and proven allocation order, as 
long as it results in valid layouts. Even if we figure out this particular 
GART/GTT assumption there might be a dozen others in other types of hardware.

Thanks,

	Ingo
