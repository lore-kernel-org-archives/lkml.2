Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757631Ab1FGSJ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 14:09:56 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:64816 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab1FGSJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 14:09:55 -0400
X-IronPort-AV: E=Sophos;i="4.65,333,1304294400"; 
   d="scan'208";a="6147567"
Date: Tue, 7 Jun 2011 19:13:03 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ingo Molnar <mingo@elte.hu>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 0/3] x86: remove x86_init.mapping.pagetable_reserve
Message-ID: <alpine.DEB.2.00.1106071849290.12963@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently find_early_table_space calculates an overestimate of how much
memory the pagetable for 1:1 mapping is going to need. After
kernel_physical_mapping_init completes we know exactly how much memory
we used so we memblock reserve only the used memory and "free" the rest.

This patch series modifies find_early_table_space to calculate the exact
amount of memory we need for the 1:1 mapping, so that we can memblock
reverve it right away and we don't need to free the unused memory after
kernel_physical_mapping_init.

At this point we can also safely revert "x86,xen: introduce
x86_init.mapping.pagetable_reserve".


The list of patches with diffstat follows:

Stefano Stabellini (3):
      x86: calculate precisely the memory needed by init_memory_mapping
      Revert "x86,xen: introduce x86_init.mapping.pagetable_reserve"
      x86: move memblock_x86_reserve_range PGTABLE to find_early_table_space

 arch/x86/include/asm/pgtable_types.h |    1 -
 arch/x86/include/asm/x86_init.h      |   12 -----
 arch/x86/kernel/x86_init.c           |    4 --
 arch/x86/mm/init.c                   |   87 +++++++++++++++++++---------------
 arch/x86/xen/mmu.c                   |   15 ------
 5 files changed, 49 insertions(+), 70 deletions(-)


Many thanks to Konrad that helped me review the patch series and
performed an impressive amount of tests:

*Configurations
baremetal Linux 64-bit
baremetal Linux 32-bit NOHIGHMEM, HIGHMEM4G and HIGHMEM64G
32-bit and 64-bit Linux on Xen
32-bit and 64-bit Linux HVM on Xen


*Hardware
AMD development box (Tilapia) - 8GB
AMD  BIOSTAR Grp N61PB-M2S/N61PB-M2S (Sempron) - 4GB
Intel DX58SO (Core i7) - 8GB
Supermicro X7DB8/X7DB8 (Harpertown) - 4GB
IBM x3850 (Cranford) - 8GB
MSI MS-7680/H61M-P23 (MS-7680) (SandyBridge, i2500)- 8GB


A git branch based on 3.0-rc1 is available here:

git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git 3.0-rc1-rem_pg_reserve-4

- Stefano
