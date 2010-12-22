Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab0LVPEm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 10:04:42 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:23539 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352Ab0LVPEj (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 22 Dec 2010 10:04:39 -0500
Date: Wed, 22 Dec 2010 10:04:21 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com,
        Jan Beulich <JBeulich@novell.com>, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: Re: [PATCH 05/10] xen/setup: Set identity mapping for non-RAM E820
 and E820 gaps.
Message-ID: <20101222150421.GE1760@dumpdata.com>
References: <1292967460-15709-1-git-send-email-konrad.wilk@oracle.com>
 <1292967460-15709-6-git-send-email-konrad.wilk@oracle.com>
 <4D112B80.9020600@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D112B80.9020600@goop.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Couldn't you just do something like:
> 
> 	if (e820->map[i].type != E820_RAM)

I am going to assume you meant '==' here.

> 		continue;
> 
> 	for (pfn = PFN_UP(last); pfn < PFN_DOWN(start); pfn++)
> 		set_phys_to_machine(pfn, pfn);
> 	identity += pfn - PFN_UP(last);
> 
> 	last = end;
> 
> ie, handle the hole and non-RAM cases together?

A derivation of this does work:

   last = ISA_END_ADDRESS;
   for (i = 0; i < e820->nr_map; i++) {
                phys_addr_t start = e820->map[i].addr;
                phys_addr_t end = start + e820->map[i].size;

                if (end < start)
                        continue;

                /* Skip over the 1MB region. */
                if (last > end)
                        continue;

                if (e820->map[i].type == E820_RAM) {
                        /* Without saving 'last' we would end up gobbling RAM regions. */
                        last = end;
                        continue;
                }   

                for (pfn = PFN_UP(last); pfn < PFN_DOWN(end); pfn++)
                        set_phys_to_machine(pfn, pfn);
                identity += pfn - PFN_UP(last);

                last = end;
	}


> 
> Also, what happens with the p2m tree mid layers in this?  If you're
> doing page-by-page set_phys_to_machine, won't it end up allocating them
> all?  How can you optimise the "large chunks of address space are
> identity" case?

The issue here is that when this code path is called (xen_memory_setup),
the p2m_top[topidx][mididx] has been set to start_info->mfn_list[] (by
xen_build_dynamic_phys_to_machine).

Granted, some of these entries have been evicted (by the xen_return_unused_memory),
so the regions in the mfn_list are pock-marked with INVALID_P2M_ENTRY. For those
regions we set the PFN in the p2m_top[topidx][mididx][idx]. We do
not allocate anything during this pass.

In the the dom0_mem=max:X (or X,max:Y, where Y>X), which I neglected to test this
would actually try to allocate (whoops). Let me roll up a patch for this.

> 
> It would probably be cleanest to have a set_ident_phys_to_machine(start,
> end) function which can do all that.

Not sure if it is truly needed.
