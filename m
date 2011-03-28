Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab1C1R0l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 13:26:41 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:56382 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab1C1R0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 13:26:40 -0400
X-IronPort-AV: E=Sophos;i="4.63,256,1299456000"; 
   d="scan'208";a="5012129"
Date: Mon, 28 Mar 2011 18:26:41 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Yinghai Lu <yinghai@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: another pagetable initialization crash on xen
Message-ID: <alpine.DEB.2.00.1103281729190.5516@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yinghai,
unfortunately I found another pagetable initialization bug on xen
affecting linux 2.6.39-rc0.
The problem is that on xen we need to make sure that all the pagetable pages
are mapped read-only, in fact in xen_set_pte we have this check:

if (pfn >= pgt_buf_start && pfn < pgt_buf_end)
    /* make the pte read-only */

however pgt_buf_end is where the kernel pagetable *currently* ends, so
some kernel pagetable pages allocated after pgt_buf_end might be marked
read-write by mistake.  A simple way to fix the issue would be to use
pgt_buf_top instead:

if (pfn >= pgt_buf_start && pfn < pgt_buf_top)
    /* make the pte read-only */

however after building the kernel pagetable in init_memory_mapping we
only reserve memory between pgt_buf_start and pgt_buf_end:

if (!after_bootmem && pgt_buf_end > pgt_buf_start)
        memblock_x86_reserve_range(pgt_buf_start << PAGE_SHIFT,
                 pgt_buf_end << PAGE_SHIFT, "PGTABLE");

so feature allocations might use memory between the final value of
pgt_buf_end and pgt_buf_top that has been marked read-only in the xen
specific code, causing a crash.
The only way I could find to fix the crash is to reserve also the memory
region between pgt_buf_start and pgt_buf_top on xen, but that would
require an ugly if(xen_domain()) at the of init_memory_mapping or
the introduction of a new pvop function to reserve the pagetable memory.
I don't like the idea, but I couldn't find anything better.
Yinghai, do you have any better suggestions?

Thanks,

Stefano
