Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704Ab0G2W2U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 18:28:20 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:44034 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751792Ab0G2W2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 18:28:19 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: a1OweT0VM1mhDpjcFsk6vxMnq4bJur9D0pOqlgWS1neOatH
 Vdb.4wP79IWE3Zd3qas2IEhY9FifYFnc4GIrZbe13gfcFFuz0p8rTNCIgY60
 GJLtMshSLeRTVCXYne2fkTQGFHGn.XeMjEuhRKdgrX5if8qyBHwrJ5ANT_Sq
 _Hx0ie7O28ynwUAQhG2PKFRx3flOC4_nrHEtxCx4x.tYlTkWICsdw_14rCpO
 cmcafDq1e6TKIfVpgOi8._QVDdOat
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 29 Jul 2010 17:28:14 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Dave Hansen <dave@linux.vnet.ibm.com>, Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Milton Miller <miltonm@bga.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, Johannes Weiner <hannes@cmpxchg.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH] Tight check of pfn_valid on sparsemem - v4
In-Reply-To: <20100729221426.GA28699@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.00.1007291723310.21024@router.home>
References: <20100728155617.GA5401@barrios-desktop> <alpine.DEB.2.00.1007281158150.21717@router.home> <20100728225756.GA6108@barrios-desktop> <alpine.DEB.2.00.1007291038100.16510@router.home> <20100729161856.GA16420@barrios-desktop>
 <alpine.DEB.2.00.1007291132210.17734@router.home> <20100729170313.GB16420@barrios-desktop> <alpine.DEB.2.00.1007291222410.17734@router.home> <20100729183320.GH18923@n2100.arm.linux.org.uk> <1280436919.16922.11246.camel@nimitz>
 <20100729221426.GA28699@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jul 2010, Russell King - ARM Linux wrote:

> We don't map lowmem in using 4K pages.  That would be utter madness
> given the small TLB size ARM processors tend to have.  Instead, we
> map lowmem using 1MB section mappings (which occupy one entry in the
> L1 page table.)  Modifying these mappings requires all page tables
> in the system to be updated - which given that we're SMP etc. now
> is not practical.
>
> So the idea that we can remap a section of memory for the mem_map
> struct (as suggested several times in this thread) isn't possible
> without having it allocated in something like vmalloc space.
> Plus, of course, that if you did such a remapping in the lowmem
> mapping, the pages which were there become unusable as they lose
> their virtual mapping (thereby causing phys_to_virt/virt_to_phys
> on their addresses to break.)  Therefore, you only gain even more
> problems by this method.

A 1M page dedicated to vmemmap would only be used for memmap and only be
addressed using the virtual memory address. The pfn to page and vice versa
mapping that is the basic mechamism for virt_to_page and friends is then
straightforward. Nothing breaks.

memory-model.h:
#elif defined(CONFIG_SPARSEMEM_VMEMMAP)

/* memmap is virtually contiguous.  */
#define __pfn_to_page(pfn)      (vmemmap + (pfn))
#define __page_to_pfn(page)     (unsigned long)((page) - vmemmap)


However, if you have such a sparse address space you would not want 1M
blocks for memmap but rather 4k pages. So yes you would need to use
vmalloc space (or reserve another virtual range for that purpose).

