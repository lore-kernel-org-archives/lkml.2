Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378Ab2JQQRr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 12:17:47 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40720 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752985Ab2JQQRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 12:17:46 -0400
Date: Wed, 17 Oct 2012 17:17:38 +0100
From: Will Deacon <will.deacon@arm.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Marc Zyngier <Marc.Zyngier@arm.com>
Subject: Re: [PATCH] virtio: 9p: correctly pass physical address to userspace
 for high pages
Message-ID: <20121017161738.GK5973@mudshark.cambridge.arm.com>
References: <1350468877-7677-1-git-send-email-will.deacon@arm.com>
 <CA+1xoqcjomrD05vxdgx4FG2wR8DTmV58Xk5=BeVD3JGVfWrssA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1xoqcjomrD05vxdgx4FG2wR8DTmV58Xk5=BeVD3JGVfWrssA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 05:05:00PM +0100, Sasha Levin wrote:
> On Wed, Oct 17, 2012 at 6:14 AM, Will Deacon <will.deacon@arm.com> wrote:
> > When using a virtio transport, the 9p net device allocates pages to back
> > the descriptors inserted into the virtqueue. These allocations may be
> > performed from atomic context (under the channel lock) and can therefore
> > return high mappings which aren't suitable for virt_to_phys.
> >
> > This patch ensures that virtual addresses for virtio queue descriptors
> > are converted to physical addresses using kmap_to_page, which handles
> > high memory correctly.
> >
> > Cc: Rusty Russell <rusty@rustcorp.com.au>
> > Cc: Sasha Levin <levinsasha928@gmail.com>
> > Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> > Signed-off-by: Will Deacon <will.deacon@arm.com>
> > ---
> 
> One of the things I was seeing when fuzzing within lkvm were random
> crashes resulting
> from "odd" addresses used by virtio-9p queue descriptions. I
> attributed that to memory
> corruption as a result of something else failing the fuzz tests
> before, but this patch
> explains what might have gone wrong.

This is *exactly* what I have observed. More specifically, I hacked kvmtool
to support memory banks above 0x0 (I'll send some patches soon) so my
PHYS_OFFSET was 0x80000000. virtio-9p then gave me physical addresses at
0x7fe02000, which if linearly mapped would be 0xffe02000 -- the pkmap!

> I'll plug it in and run tests on it.

The kernel-janitors list pointed out to me that we need to EXPORT_SYMBOL on
kmap_to_page, so if you're building the virtio ring as a module you'll need
to do that.

Cheers,

Will
