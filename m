Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab1FOWH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 18:07:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:54319 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281Ab1FOWHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 18:07:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Larry Bassel <lbassel@codeaurora.org>
Subject: Re: [Linaro-mm-sig] [PATCH 08/10] mm: cma: Contiguous Memory Allocator added
Date: Thu, 16 Jun 2011 00:06:07 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        "'Zach Pfeffer'" <zach.pfeffer@linaro.org>,
        "'Daniel Walker'" <dwalker@codeaurora.org>,
        "'Daniel Stone'" <daniels@collabora.com>,
        "'Jesse Barker'" <jesse.barker@linaro.org>,
        "'Mel Gorman'" <mel@csn.ul.ie>,
        "'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org,
        "'Michal Nazarewicz'" <mina86@mina86.com>,
        linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Ankita Garg'" <ankita@in.ibm.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
References: <1307699698-29369-1-git-send-email-m.szyprowski@samsung.com> <000901cc2b37$4c21f030$e465d090$%szyprowski@samsung.com> <20110615213958.GB28032@labbmf-linux.qualcomm.com>
In-Reply-To: <20110615213958.GB28032@labbmf-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106160006.07742.arnd@arndb.de>
X-Provags-ID: V02:K0:DK+qTfyEfSF3RuHfcvOAXHGU9lh7KcNtf7nHawp6/kw
 RoLca5628cuKTe60sVNpLr0Q5Y8hg31NnINzPMWmaU40CVIjJ+
 n67BwY6zYtNY1Y774B/4Lj+4/ZC2cbNc205nBY82Z6Zs/fUR56
 WitkyFdsmPau47qzLc509lViOQC28Yq6kk+3kmcxqHvgkGo/1I
 R8ipe2KbzVDPCX6GT7H2Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 June 2011 23:39:58 Larry Bassel wrote:
> On 15 Jun 11 10:36, Marek Szyprowski wrote:
> > On Tuesday, June 14, 2011 10:42 PM Arnd Bergmann wrote:
> > 
> > > On Tuesday 14 June 2011 20:58:25 Zach Pfeffer wrote:
> > > > I've seen this split bank allocation in Qualcomm and TI SoCs, with
> > > > Samsung, that makes 3 major SoC vendors (I would be surprised if
> > > > Nvidia didn't also need to do this) - so I think some configurable
> > > > method to control allocations is necessarily. The chips can't do
> > > > decode without it (and by can't do I mean 1080P and higher decode is
> > > > not functionally useful). Far from special, this would appear to be
> > > > the default.
> 
> We at Qualcomm have some platforms that have memory of different
> performance characteristics, some drivers will need a way of
> specifying that they need fast memory for an allocation (and would prefer
> an error if it is not available rather than a fallback to slower
> memory). It would also be bad if allocators who don't need fast
> memory got it "accidentally", depriving those who really need it.

Can you describe how the memory areas differ specifically?
Is there one that is always faster but very small, or are there
just specific circumstances under which some memory is faster than
another?

> > > The possible conflict that I still see with per-bank CMA regions are:
> > > 
> > > * It completely destroys memory power management in cases where that
> > >   is based on powering down entire memory banks.
> > 
> > I don't think that per-bank CMA regions destroys memory power management
> > more than the global CMA pool. Please note that the contiguous buffers
> > (or in general dma-buffers) right now are unmovable so they don't fit
> > well into memory power management.
> 
> We also have platforms where a well-defined part of the memory
> can be powered off, and other parts can't (or won't). We need a way
> to steer the place allocations come from to the memory that won't be
> turned off (so that CMA allocations are not an obstacle to memory
> hotremove).

We already established that we have to know something about the banks,
and your additional input makes it even clearer that we need to consider
the bigger picture here: We need to describe parts of memory separately
regarding general performance, device specific allocations and hotplug
characteristics.

It still sounds to me that this can be done using the NUMA properties
that Linux already understands, and teaching more subsystems about it,
but maybe the memory hotplug developers have already come up with
another scheme. The way that memory hotplug and CMA choose their
memory regions certainly needs to take both into account. As far as
I can see there are both conflicting and synergistic effects when
you combine the two.

	Arnd
