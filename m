Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758231Ab0G3AjH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 20:39:07 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:33298 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755397Ab0G3AjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 20:39:04 -0400
Subject: Re: [PATCH] Tight check of pfn_valid on sparsemem - v4
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Christoph Lameter <cl@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Milton Miller <miltonm@bga.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, Johannes Weiner <hannes@cmpxchg.org>,
        Kukjin Kim <kgene.kim@samsung.com>
In-Reply-To: <20100729221426.GA28699@n2100.arm.linux.org.uk>
References: <20100728155617.GA5401@barrios-desktop>
	 <alpine.DEB.2.00.1007281158150.21717@router.home>
	 <20100728225756.GA6108@barrios-desktop>
	 <alpine.DEB.2.00.1007291038100.16510@router.home>
	 <20100729161856.GA16420@barrios-desktop>
	 <alpine.DEB.2.00.1007291132210.17734@router.home>
	 <20100729170313.GB16420@barrios-desktop>
	 <alpine.DEB.2.00.1007291222410.17734@router.home>
	 <20100729183320.GH18923@n2100.arm.linux.org.uk>
	 <1280436919.16922.11246.camel@nimitz>
	 <20100729221426.GA28699@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Thu, 29 Jul 2010 17:38:58 -0700
Message-ID: <1280450338.16922.11735.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-29 at 23:14 +0100, Russell King - ARM Linux wrote:
> What we need is something which allows us to handle memory scattered
> in several regions of the physical memory map, each bank being a
> variable size. 

Russell, it does sound like you have a pretty pathological case here. :)
It's not one that we've really attempted to address on any other
architectures.

Just to spell it out, if you have 4GB of physical address space, with
512k sections, you need 8192 sections, which means 8192*8 bytes, so it'd
eat 64k of memory.  That's the normal SPARSEMEM case.

SPARSEMEM_EXTREME would be a bit different.  It's a 2-level lookup.
You'd have 16 "section roots", each representing 256MB of address space.
Each time we put memory under one of those roots, we'd fill in a
512-section second-level table, which is designed to always fit into one
page.  If you start at 256MB, you won't waste all those entries.

The disadvantage of SPARSEMEM_EXTREME is that it costs you the extra
level in the lookup.  The space loss in arm's case would only be 16
pointers, which would more than be made up for by the other gains.

The other case where it really makes no sense is when you're populating
a single (or small number) of sections, evenly across the address space.
For instance, let's say you have 16 512k banks, evenly spaced at 256MB
intervals:

	512k@0x00000000
	512k@0x10000000
	512k@0x20000000
	...
	512k@0xF0000000

If you use SPARSEMEM_EXTREME on that it will degenerate to having the
same memory consumption as classic SPARSEMEM, along with the extra
lookup of EXTREME.  But, I haven't heard you say that you have this kind
of configuration, yet. :)

SPARSEMEM_EXTREME is really easy to test.  You just have to set it in
your .config.  To get much use out of it, you'd also need to make the
SECTION_SIZE, like the 512k we were talking about.


-- Dave

