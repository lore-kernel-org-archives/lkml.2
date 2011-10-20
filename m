Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565Ab1JTKpu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 06:45:50 -0400
Received: from smtp.citrix.com ([66.165.176.89]:44130 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300Ab1JTKpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 06:45:49 -0400
X-IronPort-AV: E=Sophos;i="4.69,378,1315195200"; 
   d="scan'208";a="18393781"
From: David Vrabel <david.vrabel@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/4] xen: map foreign pages for shared rings by updating the PTEs directly
Date: Thu, 20 Oct 2011 11:45:15 +0100
Message-ID: <1319107519-2253-1-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches allows the vmalloc_sync_all() to be removed
from alloc_vm_area() by getting the hypervisor to update the PTEs (in
init_mm) directly rather than having the hypervisor look in the
current page tables to find the PTEs.

Once the hypervisor has updated the PTEs, the normal mechanism of
syncing the page tables after a fault works as expected.

This mechanism doesn't currently work on the ia64 port as that does
not support the GNTMAP_contains_pte flag.

Andrew, patch 4 (xen: map foreign pages for shared rings by updating
the PTEs directly) depends on patch 1 so it's probably best to go via
Konrad's Xen tree with your acked-by.

David

David Vrabel (4):
  xen: use generic functions instead of xen_{alloc,free}_vm_area()
  block: xen-blkback: use API provided by xenbus module to map rings
  net: xen-netback: use API provided by xenbus module to map rings
  xen: map foreign pages for shared rings by updating the PTEs directly

 arch/ia64/include/asm/xen/grant_table.h |   29 -----------
 arch/ia64/xen/grant-table.c             |   62 ------------------------
 arch/x86/include/asm/xen/grant_table.h  |    7 ---
 arch/x86/xen/grant-table.c              |    2 +-
 drivers/block/xen-blkback/common.h      |    5 +--
 drivers/block/xen-blkback/xenbus.c      |   54 +++------------------
 drivers/net/xen-netback/common.h        |   11 ++--
 drivers/net/xen-netback/netback.c       |   80 +++++++------------------------
 drivers/xen/xenbus/xenbus_client.c      |   15 ++++--
 include/linux/vmalloc.h                 |    2 +-
 include/xen/grant_table.h               |    1 -
 mm/vmalloc.c                            |   27 +++++-----
 12 files changed, 55 insertions(+), 240 deletions(-)
 delete mode 100644 arch/ia64/include/asm/xen/grant_table.h
 delete mode 100644 arch/x86/include/asm/xen/grant_table.h

-- 
1.7.2.5

