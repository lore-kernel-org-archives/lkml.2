Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760127Ab0FKLEn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 07:04:43 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52850 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757635Ab0FKLE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 07:04:27 -0400
Subject: Re: [PATCH v2] sata_sil24: Use memory barriers before issuing
 commands
From: Catalin Marinas <catalin.marinas@arm.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Robert Hancock <hancockrwd@gmail.com>, Tejun Heo <tj@kernel.org>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Colin Tuckley <colin.tuckley@arm.com>, Jeff Garzik <jeff@garzik.org>,
       linux-arch <linux-arch@vger.kernel.org>
In-Reply-To: <20100611101117.GD16436@laptop>
References: <20100611101117.GD16436@laptop>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Fri, 11 Jun 2010 12:04:12 +0100
Message-ID: <1276254252.16663.9.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Jun 2010 11:04:13.0633 (UTC) FILETIME=[D38D8B10:01CB0955]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-11 at 11:11 +0100, Nick Piggin wrote:
> On Fri, Jun 11, 2010 at 10:41:46AM +0100, Catalin Marinas wrote:
> > On Fri, 2010-06-11 at 02:38 +0100, Nick Piggin wrote:
> > > On Thu, Jun 10, 2010 at 06:43:03PM -0600, Robert Hancock wrote:
> > > > IMHO, it would be better for the platform code to ensure that MMIO
> > > > access was strongly ordered with respect to each other and to RAM
> > > > access. Drivers are just too likely to get this wrong, especially
> > > > when x86, the most tested platform, doesn't have such issues.
> > >
> > > The plan is to make all platforms do this. writes should be
> > > strongly ordered with memory. That serves to keep them inside
> > > critical sections as well.
[...]
> Also I think most high performance drivers tend to have just a few
> critical mmios so they should be able to be identified and improved
> relatively easily (relatively, as in: much  more easily than trying to
> find all the obscure ordering problems).
> 
> So anyway powerpc were reluctant because they try to fix it in their
> spinlocks, but I demonstrated that there were drivers using mutexes
> and other synchronization and found one or two broken ones in the
> first place I looked.

On the ARM implementation we are safe with regards to spinlocks/mutexes
vs. IO accesses, no weird ordering issues here (if there would be, I
agree that it would need fixing).

> > The only reference of DMA buffers vs I/O I found in the DMA-API.txt
> > file:
> >
> >         Consistent memory is memory for which a write by either the
> >         device or the processor can immediately be read by the processor
> >         or device without having to worry about caching effects. (You
> >         may however need to make sure to flush the processor's write
> >         buffers before telling devices to read that memory.)
> >
> > But there is no API for "flushing the processor's write buffers". Does
> > it mean that this should be taken care of in writel()? We would make the
> > I/O accessors pretty expensive on some architectures.
> 
> The APIs for that are mb/wmb/rmb ones.

So if that's the API for the above case and we are strictly referring to
the sata_sil24 patch I sent - shouldn't we just add wmb() in the driver
between the write to the DMA buffer and the writel() to start the DMA
transfer? Do we need to move the wmb() to the writel() macro?

-- 
Catalin

