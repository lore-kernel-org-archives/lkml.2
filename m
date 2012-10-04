Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964867Ab2JDONZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 10:13:25 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:61933 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933385Ab2JDONY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 10:13:24 -0400
Date: Thu, 4 Oct 2012 10:01:57 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: shuah.khan@hp.com, konrad.wilk@oracle.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, rob@landley.net,
        stern@rowland.harvard.edu, joerg.roedel@amd.com, bhelgaas@google.com,
        LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
        devel@linuxdriverproject.org, x86@kernel.org, shuahkhan@gmail.com
Subject: Re: [PATCH v3] dma-debug: New interfaces to debug dma mapping errors
Message-ID: <20121004140156.GG9158@phenom.dumpdata.com>
References: <1347843171.4370.13.camel@lorien2>
 <1348621517.3091.6.camel@lorien2>
 <1349276159.3192.4.camel@lorien2>
 <20121003144511.bdacbc8a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121003144511.bdacbc8a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 02:45:11PM -0700, Andrew Morton wrote:
> On Wed, 03 Oct 2012 08:55:59 -0600
> Shuah Khan <shuah.khan@hp.com> wrote:
> 
> > A recent dma mapping error analysis effort showed that a large percentage
> > of dma_map_single() and dma_map_page() returns are not checked for mapping
> > errors.
> > 
> > Reference:
> > http://linuxdriverproject.org/mediawiki/index.php/DMA_Mapping_Error_Analysis
> > 
> > Adding support for tracking dma mapping and unmapping errors to help assess
> > the following:
> > 
> > When do dma mapping errors get detected?
> > How often do these errors occur?
> > Why don't we see failures related to missing dma mapping error checks?
> > Are they silent failures?
> 
> This seems to be a strange way of addressing kernel programming errors.
> Instead of fixing them up, we generate lots of statistics about how
> often they happen!

And by using this we can fix the drivers.
> 
> Would it not be better to find and fix the buggy code sites?  A
> coccinelle script wold probably help here.

That is the end goal (fixing the buggy code sites). Shuah has
identified the bad culprits.

> 
> And let's also look at *why* we keep doing this.  Partly it's because
> these things are self-propagating - people copy-n-paste bad code so we
> get more bad code.


And this patch will now tell the poor engineers that write new code that
they pasted bad code.

> 
> 
> Another reason surely is the poor documentation.  Suppose our diligent
> programmer goes to the dma_map_single() definition site:
> 
> #define dma_map_single(d, a, s, r) dma_map_single_attrs(d, a, s, r, NULL)
> 
> No documentation at all.  Because it's a stupid macro it doesn't even
> give the types and names of the arguments or the type of the return
> value.
> 
> So he goes to dma_map_single_attrs() and finds that is altogether
> undocmented.
> 
> So he goes into Documentation/DMA-API-HOWTO.txt, searches for
> "dma_map_single" and finds
> 
> : To map a single region, you do:
> : 
> : 	struct device *dev = &my_dev->dev;
> : 	dma_addr_t dma_handle;
> : 	void *addr = buffer->ptr;
> : 	size_t size = buffer->len;
> : 
> : 	dma_handle = dma_map_single(dev, addr, size, direction);
> : 
> : and to unmap it:
> : 
> : 	dma_unmap_single(dev, dma_handle, size, direction);
> 
> 
> So it is hardly surprising that we keep screwing this up!

Right, so that should be also modified (Thank you for looking at that)!

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
