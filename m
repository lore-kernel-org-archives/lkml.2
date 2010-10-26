Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760551Ab0JZWS0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 18:18:26 -0400
Received: from claw.goop.org ([74.207.240.146]:40549 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754453Ab0JZWSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 18:18:25 -0400
Message-ID: <4CC753AD.1090403@goop.org>
Date: Tue, 26 Oct 2010 15:18:21 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: early_node_mem()'s memory allocation policy
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 We're seeing problems under Xen where large portions of the memory
could be reserved (because they're not yet physically present, even
though the appear in E820), and the 'start' and 'end' early_node_mem()
is choosing is entirely within that reserved range.

Also, the code seems dubious because it adjusts start and end without
regarding how much space it is trying to allocate:

	/* extend the search scope */
	end = max_pfn_mapped << PAGE_SHIFT;
	if (end > (MAX_DMA32_PFN<<PAGE_SHIFT))
		start = MAX_DMA32_PFN<<PAGE_SHIFT;
	else
		start = MAX_DMA_PFN<<PAGE_SHIFT;

what if max_pfn_mapped is only a few pages larger than MAX_DMA32_PFN,
and that is smaller than the size it is trying to allocate?

I tried just removing the start and end adjustments in early_node_mem()
and the kernel booted fine under Xen, but it seemed to allocate at a
very low address.  Should the for_each_active_range_index_in_nid() loop
in find_memory_core_early() be iterating from high to low addresses?  If
the allocation could be relied on to be top-down, then you wouldn't need
to adjust start at all, and it would return the highest available memory
in a natural way.

Thanks,
    J
