Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422957Ab2JDQmw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 12:42:52 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:36456 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422675Ab2JDQmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 12:42:51 -0400
Date: Thu, 4 Oct 2012 12:31:02 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Alexander Duyck <alexander.h.duyck@intel.com>
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, rob@landley.net,
        akpm@linux-foundation.org, joerg.roedel@amd.com, bhelgaas@google.com,
        shuahkhan@gmail.com, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, x86@kernel.org
Subject: Re: [RFC PATCH 1/7] swiotlb: Instead of tracking the end of the
 swiotlb region just calculate it
Message-ID: <20121004163102.GB12128@phenom.dumpdata.com>
References: <20121004002113.5016.66913.stgit@gitlad.jf.intel.com>
 <20121004003847.5016.50978.stgit@gitlad.jf.intel.com>
 <20121004130107.GB9158@phenom.dumpdata.com>
 <506DB121.3020700@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506DB121.3020700@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 08:54:09AM -0700, Alexander Duyck wrote:
> On 10/04/2012 06:01 AM, Konrad Rzeszutek Wilk wrote:
> > On Wed, Oct 03, 2012 at 05:38:47PM -0700, Alexander Duyck wrote:
> >> In the case of swiotlb we already have the start of the region and the number
> >> of slabs that give us the region size.  Instead of having to call
> >> virt_to_phys on two pointers we can just take advantage of the fact that the
> >> region is linear and just compute the end based on the start plus the size.
> > Why not take advantage of 'the fact that the region is linear' and just
> > pre-compute the end in swiotlb_init_with_tbl?
> >
> > That way the logic in is_swiotlb_buffer is even simpler?
> >
> 
> Using a pre-computed end point based on a virtual address is more
> expensive in the x86_64 case.  The calls to __phys_addr require a
> separate function call.  By just using the physical address of the start
> and adding the offset I can avoid the second call and the compiler will
> take advantage of the smaller function size.  The result is that
> is_swiotlb_buffer will be inlined.

Right, that is not what I was thinking. My thought was that since you
are already computing the start of the DMA address, you can also
compute the end - and save both values in a global variable.

Then use said global variables to check for your DMA instead of
doing the extra compution of shifting to find the end of the DMA address.

> 
> Thanks,
> 
> Alex
