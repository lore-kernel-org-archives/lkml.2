Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab2IRTm5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 15:42:57 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:48700 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754268Ab2IRTmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 15:42:53 -0400
Message-ID: <1347997369.2747.68.camel@lorien2>
Subject: Re: [PATCH] dma-debug: New interfaces to debug dma mapping errors
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Greg KH <greg@kroah.com>,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, rob@landley.net,
        akpm@linux-foundation.org, bhelgaas@google.com,
        stern@rowland.harvard.edu, LKML <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org, devel@linuxdriverproject.org,
        x86@kernel.org, shuahkhan@gmail.com
Date: Tue, 18 Sep 2012 13:42:49 -0600
In-Reply-To: <20120918133414.GM2505@amd.com>
References: <1347843171.4370.13.camel@lorien2>
	 <20120917133937.GC11553@phenom.dumpdata.com>
	 <1347897172.3227.61.camel@lorien2>
	 <20120917172317.GB15783@phenom.dumpdata.com>
	 <1347921915.3227.143.camel@lorien2> <20120918133414.GM2505@amd.com>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-18 at 15:34 +0200, Joerg Roedel wrote:
> On Mon, Sep 17, 2012 at 04:45:15PM -0600, Shuah Khan wrote:
> > Yeah. I will firm up my ideas a bit and summarize in a day or two. Would
> > like to hear your ideas as well at that time, so we can pick the one
> > that works the best.
> 
> I think the best approach for this functionality is to add a flag to
> 'struct dma_debug_entry' which tells whether the address has been
> checked with dma_mapping error or not. On unmap or driver unload you can
> then check for that flag and print a warning when an unchecked address
> is detected.

Was hoping to get comments from you as well. You are original author for
this dam-debug module.

Are you ok with the system wide and per device error counts I added? Any
comments on the overall approach?

The approach you suggested will cover the cases where drivers fail to
check good map cases. We won't able to catch failed maps that get used
without checks. Are you not concerned about these cases? These could
cause a silent error with wild writes or could bring the system down. Or
are you recommending changing the infrastructure to track failed maps as
well?

I am still pursuing a way to track failed map cases. I combined the flag
idea with one of the ideas I am looking into. Details below: (if this
sounds like a reasonable approach, I can do v2 patch and we can discuss
the code)

. Add new fields dma_map_errors, dma_map_errors_not_checked,
dma_unmap_errors, iotlb_overflow_cnt, and flag to struct
dma_debug_entry. Maybe flag is not even needed if
dma_map_errors_not_checked can double as status.

. Enhance dma_debug_init() to create a second table to track failed maps
with PREALLOC_DMA_DEBUG_ENTRIES/64 = 64. 64 devices probably is good
enough.

. Entries added to this new table when debug_dma_map_page() detects
error when mapping error is detected for the first time. Subsequent
errors, will increment dma_map_errors, dma_map_errors_not_checked for
that the device that is tracked by this entry. Note: paddr field could
work as an index into this table (existing table uses dma_addr)

. Decrement dma_map_errors_not_checked from debug_dma_mapping_error(),
clear the flag.

. check_unmap() when it detects mapping error, checks flag (status) and
prints warn message.

-- Shuah

