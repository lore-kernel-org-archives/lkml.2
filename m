Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667Ab0LONjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 08:39:09 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:19137 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab0LONjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 08:39:08 -0500
X-IronPort-AV: E=Sophos;i="4.59,348,1288569600"; 
   d="scan'208";a="3360595"
Date: Wed, 15 Dec 2010 13:39:27 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: linux-kernel@vger.kernel.org
CC: xen-devel@lists.xensource.com,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: [PATCH 00/11] xen: allow usermode to map granted pages
Message-ID: <alpine.DEB.2.00.1012151259510.2390@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
this patch series introduces the gntdev device that allows usermode
to map granted pages; gntdev is used by qemu to implement Xen backends
in userspace.

Considering that granted pages still have the same entry in the m2p
as before being granted, the following patches also add a mechanism to
override portions of the m2p so that we can find out the pfn
corresponding to the mfn of a granted page in the "receiver" domain.
This is needed so that we can have pte_page work correctly for these
pages. Once this requirement is satisfied, __get_user_pages_fast can
work on granted pages and userspace applications (the xen block backend
implemented in qemu) can use AIO on them.


The list of patches and the diffstat follow:

Gerd Hoffmann (1):
      xen/gntdev: allow usermode to map granted pages

Ian Campbell (2):
      xen: define gnttab_set_map_op/unmap_op
      xen: gntdev: move use of GNTMAP_contains_pte next to the map_op

Jeremy Fitzhardinge (5):
      xen/gntdev: add VM_PFNMAP to vma
      xen: move p2m handling to separate file
      xen: add m2p override mechanism
      xen/gntdev: stop using "token" argument
      xen p2m: clear the old pte when adding a page to m2p_override

Stefano Stabellini (3):
      xen p2m: transparently change the p2m mappings in the m2p override
      xen: introduce gnttab_map_refs and gnttab_unmap_refs
      xen gntdev: use gnttab_map_refs and gnttab_unmap_refs

 arch/x86/include/asm/xen/page.h |   16 +-
 arch/x86/xen/Makefile           |    3 +-
 arch/x86/xen/mmu.c              |  365 ---------------------
 arch/x86/xen/p2m.c              |  493 ++++++++++++++++++++++++++++
 drivers/xen/Kconfig             |    7 +
 drivers/xen/Makefile            |    2 +
 drivers/xen/gntdev.c            |  672 +++++++++++++++++++++++++++++++++++++++
 drivers/xen/grant-table.c       |   36 ++
 include/xen/gntdev.h            |  119 +++++++
 include/xen/grant_table.h       |   44 +++-
 10 files changed, 1387 insertions(+), 370 deletions(-)


Cheers,

Stefano


P.S.
I'll be AFK for a couple of weeks, so don't expect an immediate reply.
