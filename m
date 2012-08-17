Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758724Ab2HQSDN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 14:03:13 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:31472 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab2HQSDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 14:03:08 -0400
Message-ID: <1345226555.3025.7.camel@lorien2>
Subject: Re: dma mapping error check analysis
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org,
        paul.gortmaker@windriver.com, bhelgaas@google.com, amwang@redhat.com,
        LKML <linux-kernel@vger.kernel.org>, shuahkhan@gmail.com
Date: Fri, 17 Aug 2012 12:02:35 -0600
In-Reply-To: <20120817141120.GD8093@phenom.dumpdata.com>
References: <1344638802.8018.18.camel@lorien2>
	 <20120817141120.GD8093@phenom.dumpdata.com>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-08-17 at 10:11 -0400, Konrad Rzeszutek Wilk wrote:
> On Fri, Aug 10, 2012 at 04:46:42PM -0600, Shuah Khan wrote:
> > I analyzed current calls to dma_map_single() and dma_map_page() in the kernel
> > to see if dma mapping errors are checked after mapping routines return.
> > 
> > Reference linux-next August 6 2012.
> > 
> > This analysis stemmed from the discussion on my patch that disables swiotlb
> > overflow as a first step towards removing the support all together. Please
> > refer to thread below:
> > 
> > https://lkml.org/lkml/2012/7/24/391
> > 
> > The goal of this analysis is to find drivers that don't currently check dma
> > mapping errors and fix them. I did a grep for dma_map_single() and
> > dma_map_page() and looked at the code that calls these routines. I classified
> > the results of dma mapping error check status as follows:
> > 
> > Broken:
> > 1. No error checks
> > 2. Partial checks - In that source file, not all calls are followed by checks.
> > 3. Checks dma mapping errors, doesn't unmap already mapped pages when mapping
> >    error occurs in the middle of a multiple mapping attempt.
> > 
> > The first two categories are classified as broken and need fixing.
> > 
> > The third one needs fixing, since it leaves dangling mapped pages, and holds
> > on to them which is equivalent to memory leak. Some drivers release all mapped
> > pages when the device closes, but others don't. Not doing unmap might be
> > harmless on some architectures going by the comments I found in some source
> > files.
> > 
> > Good:
> > 1. Checks dma mapping errors and unmaps already mapped pages when mapping
> >    error occurs in the middle of a multiple mapping attempt.
> > 2. Checks dma mapping errors without unlikely()
> > 3. Checks dma mapping errors with unlikely()
> > 
> > I lumped the above three cases as good cases. Using unlikely() is icing on the
> > cake, and something we need to be concerned about compared to other problems in
> > this area.
> > 
> > - dmap_map_single() - results
> > No error checks - 195 (46%)
> > Partial checks - 46 (11%)
> > Doesn't unmap: 26 (6%)
> > Good: 147 (35%)
> > 
> > - dma_map_page() - results
> > No error checks: 61 (59%)
> > Partial checks: 7 (.06%)
> > Doesn't unmap: 15 (14.5%)
> > Good: 20 (19%)
> > 
> > In summary a large % of the cases (> 50%) go unchecked. That raises the
> > following questions:
> > 
> > When do mapping errors get detected?
> > How often do these errors occur?
> > Why don't we see failures related to missing dma mapping error checks?
> > Are they silent failures?
> > 
> > Based on what I found, I am not too eager to remove swiotlb overflow support
> > which would increase the probability of returning dma mapping errors.
> > 
> > However I propose the following to gather more information:
> > 
> > - Change swiotlb to log (pr_info or pr_debug) cases where overflow buffer is
> >   triggered. (This is a delta on the disable swiotlb patch I sent a few weeks
> >   ago - References in this posting).
> 
> As opposed to printk(KERN_ERR ? Why?

printk(KERN_ERR) is just fine.

> 
> > - Change dma_map_single() and dma_map_page() to track how many times they
> >   return before attempting to fix all the places that don't do dma mapping
> >   error checks. (Maybe a counter that keeps track, pr_* is not an option).
> 
> Perhaps this should be done in the DMA debug API instead?

Yes that is a good idea. Will explore that.

-- Shuah


