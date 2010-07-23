Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760431Ab0GWPXj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 11:23:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:27515 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758360Ab0GWPXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 11:23:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,248,1278313200"; 
   d="scan'208";a="820994537"
Message-ID: <4C49B3F5.3030904@linux.intel.com>
Date: Fri, 23 Jul 2010 17:23:33 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Alok Kataria <akataria@vmware.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        "lenb@kernel.org" <lenb@kernel.org>, "x86@kernel.org" <x86@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Petr Vandrovec <petr@vmware.com>
Subject: Re: swiotlb detection should be memory hotplug aware ?
References: <20100721135750Z.fujita.tomonori@lab.ntt.co.jp> <1279732414.10874.6.camel@ank32.eng.vmware.com> <20100722084413I.fujita.tomonori@lab.ntt.co.jp> <20100722090329O.fujita.tomonori@lab.ntt.co.jp> <1279823680.31733.20.camel@ank32.eng.vmware.com> <20100723142208.GA4008@phenom.dumpdata.com> <4C49A83C.8070203@linux.intel.com> <20100723145945.GA31857@phenom.dumpdata.com>
In-Reply-To: <20100723145945.GA31857@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I was thinking about this at some point. I think the first step is to
> make SWIOTLB use the debugfs to actually print out how much of its
> buffers are used - and see if the 64MB is a good fit.

swiotlb is near always wrongly sized. For most system it's far too much, 
but for some
not enough. I have some systemtap scripts around to instrument it.

Also it depends on the IO load, so if you size it reasonable you
risk overflow on large IO (however these days this very rarely happens 
because
all "serious" IO devices don't need swiotlb anymore)

The other problem is that using only  two bits for the needed address 
space is also extremly
inefficient (4GB and 16MB on x86). Really want masks everywhere and 
optimize for the
actual requirements.

> The shrinking part scares me - I think it might be more prudent to first
> explore on how to grow it. The big problem looks to allocate a physical
> contiguity set of pages. And I guess SWIOTLB would need to change from
> using one big region to something of a pool system?
>

Shrinking: you define a movable zone, so with some delay it can be 
always freed.

The problem with swiotlb is however it still cannot block, but it can 
adapt to load.

The real fix would be blockable swiotlb, but the way drivers are set up 
this is difficult
(at least in kernels using spinlocks)

>> allocator patchkit,
>> unfortunately that didn't go forward.
> I wasn't present at that time so I don't know what the issues were - you
> wouldn't have a link to LKML for this?


There wasn't all that much opposition, but I ran out of time because 
fixing the infrastructure
(e.g. getting rid of all of GFP_DMA) is a lot of work. In a sense it's a 
big tree sweep project like
getting rid of BKL.

The old patch kit is at ftp://firstfloor.org/pub/ak/dma/
"intro" has the rationale.

I have a slightly newer version of the SCSI & misc drivers patchkit 
somewhere.

-Andi

