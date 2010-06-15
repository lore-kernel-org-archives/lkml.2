Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505Ab0FOLLO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 07:11:14 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35126 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754849Ab0FOLLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 07:11:10 -0400
Subject: Re: [PATCH v2] sata_sil24: Use memory barriers before issuing
 commands
From: Catalin Marinas <catalin.marinas@arm.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Nick Piggin <npiggin@suse.de>, Tejun Heo <tj@kernel.org>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Colin Tuckley <colin.tuckley@arm.com>, Jeff Garzik <jeff@garzik.org>,
       linux-arch <linux-arch@vger.kernel.org>
In-Reply-To: <AANLkTilxkyOVQU6OjL7ceucxPnbX9qAjWjjM1U16M1Rm@mail.gmail.com>
References: <AANLkTilxkyOVQU6OjL7ceucxPnbX9qAjWjjM1U16M1Rm@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Tue, 15 Jun 2010 12:10:53 +0100
Message-ID: <1276600253.26369.46.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jun 2010 11:10:53.0890 (UTC) FILETIME=[6BC6EA20:01CB0C7B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-06-12 at 02:30 +0100, Robert Hancock wrote:
> On Fri, Jun 11, 2010 at 5:04 AM, Catalin Marinas
> <catalin.marinas@arm.com> wrote:
> > On Fri, 2010-06-11 at 11:11 +0100, Nick Piggin wrote:
> >> On Fri, Jun 11, 2010 at 10:41:46AM +0100, Catalin Marinas wrote:
> >> > The only reference of DMA buffers vs I/O I found in the DMA-API.txt
> >> > file:
> >> >
> >> >         Consistent memory is memory for which a write by either the
> >> >         device or the processor can immediately be read by the processor
> >> >         or device without having to worry about caching effects. (You
> >> >         may however need to make sure to flush the processor's write
> >> >         buffers before telling devices to read that memory.)
> >> >
> >> > But there is no API for "flushing the processor's write buffers". Does
> >> > it mean that this should be taken care of in writel()? We would make the
> >> > I/O accessors pretty expensive on some architectures.
> >>
> >> The APIs for that are mb/wmb/rmb ones.
> >
> > So if that's the API for the above case and we are strictly referring to
> > the sata_sil24 patch I sent - shouldn't we just add wmb() in the driver
> > between the write to the DMA buffer and the writel() to start the DMA
> > transfer? Do we need to move the wmb() to the writel() macro?
> 
> I think it would be best if writel, etc. did the write buffer flushing
> by default. As Nick said, if there are some performance critical areas
> then those can use the relaxed versions but it's safest if the default
> behavior works as drivers expect.

I went through the past discussion pointed to by Fujita (thanks!) but I
wouldn't say it resulted in a definitive guideline on how architectures
should implement the I/O accessors.

>From an ARM perspective, I would prefer to add wmb() in the drivers
where it matters - basically only those using DMA coherent buffers. A
lot of drivers already have this in place and that's already documented
in DMA-API.txt (maybe with a bit of clarification).

Some statistics - grepping drivers/ for alloc_coherent shows 285 files.
Of these, 69 already use barriers. It's not trivial to go through 200+
drivers and add barriers but I wouldn't say that's impossible.

If we go the other route of adding mb() in writel() (though I don't
prefer it), there are two additional issues:

(1) how relaxed would the "writel_relaxed" etc. accessors be? Are they
relaxed only with regards to coherent DMA buffers or relaxed with other
I/O operations as well? Can the compiler reorder them?

(2) do we go through all the drivers that currently have *mb() and
remove them? A quick grep in drivers/ shows over 1600 occurrences of
*mb().

-- 
Catalin

