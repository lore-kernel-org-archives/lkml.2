Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434Ab1EPKVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 06:21:39 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:30662 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792Ab1EPKVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 06:21:38 -0400
X-IronPort-AV: E=Sophos;i="4.64,373,1301875200"; 
   d="scan'208";a="5772764"
Date: Mon, 16 May 2011 11:23:14 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "yinghai@kernel.org" <yinghai@kernel.org>,
        "jeremy@goop.org" <jeremy@goop.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: Xen MMU's requirement to pin pages RO and
 initial_memory_mapping.
In-Reply-To: <20110513153010.GB16519@dumpdata.com>
Message-ID: <alpine.DEB.2.00.1105131650550.8972@kaball-desktop>
References: <20110513153010.GB16519@dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 May 2011, Konrad Rzeszutek Wilk wrote:
> aka, remove the hack added by git commit 609cfda586c7fe3e5d1a02c51edb587506294167
> (Merge branch 'stable/bug-fixes-for-rc5' of git://git.kernel.org/../xen)
> 
> One idea that is on the table was proposed by Yinghai:
> "Xen should set RAM for page-table to RO after init_memory mapping."
> 
> In other words, don't do the magic 'mask_rw_pte' when set_pte is called.
> (and don't do the calls to make_lowmem_page_readonly when allocating
> the PTE table, nor PMD, nor PUD) - I think?
> 
> But instead do:
>  a). when we load the cr3? We could go through the whole pagetable and
>      set the RO as we need?
>  b). when we are finished with the creation of a page table? So similary 
>      to the point above - don't set the RO on the pages until we have completed
>      the full creation of the page.
>  c). when post_allocator_start is called?

I think c) is too late because there might be allocations or at least
memblock allocations after init_memory_mapping and before
post_allocator_start.


>  d). other ideas?
> 
> But I vaguelly recall that we are using the page table as we are adding in the
> entries. And that we are pinning them as well. Perhaps the trigger to scan the
> pagetable and set them to RO should be done .. at what point? When the PUD/PMD
> allocations are done? And when PUD/PMD are set?
> 

Setting the pagetable pages RO after init_memory_mapping is difficult
because pagetable pages have to be set RO before becoming pagetable
pages.
They become pagetable pages when:

- they are explicitly pinned by pin_pagetable_pfn

- they are hooked into the current pagetable

Like you wrote, considering that the x86_64 version of
kernel_physical_mapping_init hooks the pagetable pages into the
currently used pagetable, it wouldn't be possible to mark the pagetable
pages RO after init_memory_mapping.
