Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161Ab1DMTY1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 15:24:27 -0400
Received: from 8bytes.org ([88.198.83.132]:38433 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757951Ab1DMTY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 15:24:26 -0400
Date: Wed, 13 Apr 2011 21:24:24 +0200
From: Joerg Roedel <joro@8bytes.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
        Alex Deucher <alexdeucher@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Thomas Gleixner <tglx@linutronix.de>,
        Tejun Heo <tj@kernel.org>
Subject: Re: Linux 2.6.39-rc3
Message-ID: <20110413192424.GJ19819@8bytes.org>
References: <BANLkTimNvX=U6qy2FgvDpWE6HY7cehWvyQ@mail.gmail.com> <20110412090207.GE19819@8bytes.org> <BANLkTimSgAmT5a1s0ciBr2jsE-Nu7n4buQ@mail.gmail.com> <20110412184433.GF19819@8bytes.org> <20110413064609.GA18777@elte.hu> <20110413172147.GI19819@8bytes.org> <4DA5F0BB.1000308@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DA5F0BB.1000308@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 11:51:39AM -0700, H. Peter Anvin wrote:
> On 04/13/2011 10:21 AM, Joerg Roedel wrote:
> > 
> > First of all, I bisected between v2.6.37-rc2..f005fe12b90c which where
> > only a couple of patches and merged v2.6.38-rc4 in at every step. There
> > was no failure found.
> > Then I tried this again, but this time I merged v2.6.38-rc5 at every
> > step and was successful. The bad commit in this branch turned out to be
> > 
> > 	1a4a678b12c84db9ae5dce424e0e97f0559bb57c
> > 
> > which is related to memblock.
> > 
> > Then I tried to find out which change between 2.6.38-rc4 and 2.6.38-rc5
> > is needed to trigger the failure, so I used f005fe12b90c as a base,
> > bisected between v2.6.38-rc4..v2.6.38-rc5 and merged every bisect step
> > into the base and tested. Here the bad commit turned out to be
> > 
> > 	e6d2e2b2b1e1455df16d68a78f4a3874c7b3ad20
> > 
> > which is related to gart. It turned out that the gart aperture on that
> > box is on another position with these patches. Before it was as
> > 0xa4000000 and now it is at 0xa0000000. It seems like this has something
> > to do with the root-cause.
> > 
> > Reverting commit 1a4a678b12c84db9ae5dce424e0e97f0559bb57c fixes the
> > problem btw. and booting with iommu=soft also works, but I have no idea
> > yet why the aperture at that address is a problem (with the patch
> > reverted the aperture lands at 0x80000000).
> > 
> 
> Does reverting e6d2e2b2b1e1455df16d68a78f4a3874c7b3ad20 solve the
> problem for you?

No, reverting that patch doesn't make the problem go away (and the gart
aperture is still on 0xa0000000). I tested this in 39-rc3, I havn't
tested if it makes a difference on the original bisect-commit from Ingo,
probably it does (don't know if that matters).
Strange about this commit is that it fixes an x86 gart aperture
allocation bug in generic memblock code.

> 1a4a678b12c84db9ae5dce424e0e97f0559bb57c is a memory-allocation-order
> patch, which have a nasty tendency to unmask bugs elsewhere in the
> kernel.  However, e6d2e2b2b1e1455df16d68a78f4a3874c7b3ad20 looks
> positively strange (and it doesn't exactly help that the description is
> written in Yinghai-ese and is therefore nearly impossible to decode,
> never mind tell if it is remotely correct.)

I think that the two commits are okay and the bug is somewhere else, but
I have no idea yet were to look next. I spent some time looking at
radeon code and talking to Alex about it (because it seemed suspicous
that the GTT is on 0xa0000000 too, but as Alex explained me this is an
address in the GPU address space and shouldn't matter).

Regards,

       Joerg	

