Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461Ab1DNI40 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 04:56:26 -0400
Received: from 8bytes.org ([88.198.83.132]:53096 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756972Ab1DNI4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 04:56:25 -0400
Date: Thu, 14 Apr 2011 10:56:24 +0200
From: Joerg Roedel <joro@8bytes.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Alex Deucher <alexdeucher@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Thomas Gleixner <tglx@linutronix.de>,
        Tejun Heo <tj@kernel.org>
Subject: Re: Linux 2.6.39-rc3
Message-ID: <20110414085624.GC18463@8bytes.org>
References: <BANLkTimNvX=U6qy2FgvDpWE6HY7cehWvyQ@mail.gmail.com> <20110412090207.GE19819@8bytes.org> <BANLkTimSgAmT5a1s0ciBr2jsE-Nu7n4buQ@mail.gmail.com> <20110412184433.GF19819@8bytes.org> <20110413064609.GA18777@elte.hu> <20110413172147.GI19819@8bytes.org> <4DA5F62F.3030504@kernel.org> <4DA654D6.2060103@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DA654D6.2060103@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 06:58:46PM -0700, H. Peter Anvin wrote:
> On 04/13/2011 12:14 PM, Yinghai Lu wrote:
> > 
> > so looks bios program wrong address to the radon card?
> > 
> 
> Okay, staring at this, it definitely seems toxic to overlay the GART
> over memory areas reserved by the BIOS.  If I were to guess, I would say
> that the problem here seems to be that the kernel thinks it is
> overlaying 64 MiB of memory, but the actual GART is in fact 512 MiB in
> size -- 131072 CPU pages -- which now overlaps the BIOS reserved areas.
> 
> Alex D., could you comment on the "num cpu pages" bit?

Okay, I tried the debug-patch from Yinghai (posted to the bugzilla):

--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -325,6 +325,8 @@ void radeon_gtt_location(struct radeon_device *rdev, struct radeon_mc *mc)
                        mc->gtt_size = size_bf;
                }
                mc->gtt_start = (mc->vram_start & ~mc->gtt_base_align) - mc->gtt_size;
+               if (mc->gtt_start == 0xa0000000)
+                       mc->gtt_start = 0x80000000;
        } else {
                if (mc->gtt_size > size_af) {
                        dev_warn(rdev->dev, "limiting GTT\n");

And this makes a difference, with this change on-top of -rc3 the box boots
fine. So there seems to be some dependency between the GART base and the GTT
base even when they are in different address spaces.

Alex, can you comment on this?

Regards,

	Joerg

