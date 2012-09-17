Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271Ab2IQPw7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 11:52:59 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:12628 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932093Ab2IQPw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 11:52:57 -0400
Message-ID: <1347897172.3227.61.camel@lorien2>
Subject: Re: [PATCH] dma-debug: New interfaces to debug dma mapping errors
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Greg KH <greg@kroah.com>
Cc: joerg.roedel@amd.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rob@landley.net, akpm@linux-foundation.org, bhelgaas@google.com,
        stern@rowland.harvard.edu, LKML <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org, devel@linuxdriverproject.org,
        x86@kernel.org, shuahkhan@gmail.com
Date: Mon, 17 Sep 2012 09:52:52 -0600
In-Reply-To: <20120917133937.GC11553@phenom.dumpdata.com>
References: <1347843171.4370.13.camel@lorien2>
	 <20120917133937.GC11553@phenom.dumpdata.com>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-17 at 09:39 -0400, Konrad Rzeszutek Wilk wrote:

> > check_unmap():
> > 	This is an existing internal routines that checks for unmap errors,
> > 	changed to increment dma_unmap_errors for the current device, as well
> > 	as the dma_unmap_errors counter for the system, dma-debug api keeps
> > 	track of, when a device requests an invalid address to be unmapped.
> > 	Please note that this routine can no longer call dma_mapping_error(),
> > 	because of the newly added debug_dma_mapping_error() interface. Calling
> > 	dma_mapping_error() from this routine will decrement
> > 	dma_map_errors_not_checked counter incorrectly.
> 
> 
> I like the direction of this patch. That said I am wondering why you
> choose to do it this way? Was there no way to have all of the logic within
> debug dma file, and within check_unmap?

> What is the extra complexity? Can you explain as if I was a newbie to debug DMA
> API - perhaps there is still some hope in doing it there?
> 
> > struct device eliminates the need for maintaining failed mappings in dma-debug
> > infrastructure and is cleaner and simpler without impacting the existing
> > dma-debug infrastructure.
> 
> Could you explain please why it would be more difficult to do it in the existing
> dma-debug infrastructure?

I started out with a goal to provide a debug infrastructure to track all
the cases where dma mapping errors go unchecked.

I could have gone the route to track system wide counts and not be
concerned about per device counts. In which case, it would be a sub-set
of the functionality in this pacth.  i.e debug_dma_map_page() increments
dma_map_errors and dma_map_errors_not_checked. The new interface
debug_dma_mapping_error() simply decrements dma_map_errors_not_checked.

check_unmap() can increment the third system wide counter,
dma_unmap_errors.

However, system wide counters are of limited use, per device counters
will give us the ability to identify the drivers that need fixing and
fix them and have a way to regression test old drivers and sanity check
the new in the future.

Having decided on per device counters, my first approach was looking
into enhancing dma-debug infrastructure and contain this logic within
that module by enhancing the existing dma_debug_entry to track these
errors. 

One issue with this approach is that the current dma-debug
infrastructure tracks only the successful mappings. Entries are added to
the dma_debug_entry able from mapping interfaces for good maps. This
table is hashed using the mapped address (dma_addr). When dma mapping
error is detected by the debug interfaces debug_dma_map_page() namely,
nothing gets added to the dma_debug_entry table.

Tracking failed mappings would require either changing the current table
usage to include failed maps and change the hash function to use some
other key instead of the mapped address. I didn't want to go that route.
One option I considered was to maintain device list with dma-debug
module and at that point adding fields to struct device sounded like one
way to go instead of adding another set of parallel data structures to
maintain the association between these counts and devices.

But from what I am hearing as feedback "changing struct device for this
purpose is not a desirable." :)

I will go back and take a look at another approach to not disturb the
existing dma_debug_entry usage, still provide per device counts
contained within the dma-debug module. I have couple of ideas to pursue
further and see if they work.

-- Shuah






