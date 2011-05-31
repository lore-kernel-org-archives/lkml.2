Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108Ab1EaPeh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 11:34:37 -0400
Received: from hyde.gogi.tv ([87.106.161.174]:41748 "EHLO hyde.gogi.tv"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756573Ab1EaPef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 11:34:35 -0400
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 31 May 2011 16:34:33 +0100
From: Daniel Haid <d.haid@gogi.tv>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>, <linux-kernel@vger.kernel.org>
Subject: Re: Question about iommu on =?UTF-8?Q?x=38=36=5F=36=34=20and=20ra?=
 =?UTF-8?Q?deon=20driver=2E?=
In-Reply-To: <20110531134519.GC14641@dumpdata.com>
References: <6ac3f6faad655602b767aa14b355e982@admin.gogi.tv>
 <20110523220536.GB11961@dumpdata.com>
 <756073831c36e0404199a4e8239bcb70@admin.gogi.tv>
 <m2wrhf4sw5.fsf@firstfloor.org>
 <08370791664f069624d25c757ed101c0@admin.gogi.tv>
 <20110525125752.GB3467@dumpdata.com>
 <dfd8bfd19ba1fb77d6448bff97123e13@admin.gogi.tv>
 <20110527155507.GB11273@dumpdata.com>
 <9e26ea71798d10a3f900c777b71ff485@admin.gogi.tv>
 <20110531134519.GC14641@dumpdata.com>
Message-ID: <59be1730ec1660abeb7b4dc584510d34@admin.gogi.tv>
User-Agent: Roundcube Webmail/0.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Noo.. It does, but the normal assumption of 'phys_to_virt' ==
> 'phys_to_bus' is
> not valid anymore. Think of a buffer (swiotlb) which has a pool
> of pages and when a PCI device wants a page, it hands one out. It 
> also has
> other functionality such as 'mapping' of an already allocated page. 
> If the
> PCI device asks the IOMMU (swiotlb) to map a page (and if you have
> 'swiotlb=force'
> the page provided has been allocated above 4GB and the device can 
> only handle
> up to 32-bit),

 Does the radeon driver allocate without DMA32, possibly above 4GB, ...

> then swiotlb gives out a page from its own pool. You now have
> two addresses: the one from the PCI pool (swiotlb) and the one you 
> already
> allocated.

 ... or does it allocate under 4GB but nevertheless get a page from
 the swiotlb pool?

> You are suppose to program your PCI card to read/write data to the
> page provided from the IOMMU (so the swiotlb), which means that it 
> won't
> write to the page you had allocated. Hence there are a calls, such as
> 'sync_page'..
> which will copy the contents from the swiotlb page to the one you had
> allocated
> (or vice-versa). This is called 'bounce buffer'.
>
> The radeon (and nouveau) don't have the code to call the 'sync_page', 
> and
> you wouldn't really want to do so - as it slows down the performance 
> of the
> machine. There exists another mechanism which is to allocate the 
> pages
> at the start, and not do mapping later one.

 Why can the radeon not simply allocate addresses under 4GB and not 
 request
 adresses from the iommu at all?

 I assume that if you request a page from the IOMMU, you are required to 
 do
 these sync_page calls (and that they get optimized away with a hardware 
 IOMMU?).

 So if the radeon uses the IOMMU but does not call sync_page even if 
 required to
 the code seems to be broken. If this is indeed the case would it not be 
 possible to
 simply add the sync_page calls for now (and thus fix the code), if it 
 is not
 difficult, and implement the method with more performance later?

