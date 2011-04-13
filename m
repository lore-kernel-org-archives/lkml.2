Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933210Ab1DMRVt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 13:21:49 -0400
Received: from 8bytes.org ([88.198.83.132]:57707 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932664Ab1DMRVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 13:21:48 -0400
Date: Wed, 13 Apr 2011 19:21:47 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, Alex Deucher <alexdeucher@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>
Subject: Re: Linux 2.6.39-rc3
Message-ID: <20110413172147.GI19819@8bytes.org>
References: <BANLkTimNvX=U6qy2FgvDpWE6HY7cehWvyQ@mail.gmail.com> <20110412090207.GE19819@8bytes.org> <BANLkTimSgAmT5a1s0ciBr2jsE-Nu7n4buQ@mail.gmail.com> <20110412184433.GF19819@8bytes.org> <20110413064609.GA18777@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110413064609.GA18777@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 08:46:09AM +0200, Ingo Molnar wrote:
> Could you please send the before/after bootlog (in particular all memory init 
> messages included) and your .config?
> 
>  before:  f005fe12b90c: x86-64: Move out cleanup higmap [_brk_end, _end) out of init_memory_mapping()
>   after:  d2137d5af425: Merge branch 'linus' into x86/bootmem
> 
> I've Cc:-ed more people who might have an idea about it.

Okay, I have done some more bisecting and debugging today.

First of all, I bisected between v2.6.37-rc2..f005fe12b90c which where
only a couple of patches and merged v2.6.38-rc4 in at every step. There
was no failure found.
Then I tried this again, but this time I merged v2.6.38-rc5 at every
step and was successful. The bad commit in this branch turned out to be

	1a4a678b12c84db9ae5dce424e0e97f0559bb57c

which is related to memblock.

Then I tried to find out which change between 2.6.38-rc4 and 2.6.38-rc5
is needed to trigger the failure, so I used f005fe12b90c as a base,
bisected between v2.6.38-rc4..v2.6.38-rc5 and merged every bisect step
into the base and tested. Here the bad commit turned out to be

	e6d2e2b2b1e1455df16d68a78f4a3874c7b3ad20

which is related to gart. It turned out that the gart aperture on that
box is on another position with these patches. Before it was as
0xa4000000 and now it is at 0xa0000000. It seems like this has something
to do with the root-cause.

Reverting commit 1a4a678b12c84db9ae5dce424e0e97f0559bb57c fixes the
problem btw. and booting with iommu=soft also works, but I have no idea
yet why the aperture at that address is a problem (with the patch
reverted the aperture lands at 0x80000000).

I have put some debug-data online. There is my .config and two
dmesg-files for good (==2.6.39-rc3 + revert) and bad (==2.6.39-rc3)
I also created these dmesg-files again with memblock=debug, maybe that
helps to find the problem. The files are at

	http://www.8bytes.org/~joro/debug/

Or someone else has an idea about the issue...

	Joerg

