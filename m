Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab1AJKeo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 05:34:44 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:45545 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101Ab1AJKen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 05:34:43 -0500
X-IronPort-AV: E=Sophos;i="4.60,299,1291593600"; 
   d="scan'208";a="3677795"
Date: Mon, 10 Jan 2011 10:36:05 +0000
From: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v2 00/12] xen: allow usermode to map granted pages
Message-ID: <alpine.DEB.2.00.1101101012190.2390@kaball-desktop>
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


Changes compared to v1:

- a new patch by Daniel De Graaf has been added to fix a circular
locking dependency problem;

- changed an unsigned into an int in "xen gntdev: use gnttab_map_refs
and gnttab_unmap_refs" for conformity, addressing Konrad's comments;

- cleanups and fixes applied to "xen: introduce gnttab_map_refs and
gnttab_unmap_refs", addressing Konrad's comments;

- fixed a typo in "gntdev: move use of GNTMAP_contains_pte next to the
map_op", addressing Konrad's comments;

- several cleanups applied to "xen/gntdev: allow usermode to map granted
pages", addressing Konrad's comments;

- a check for the validity of the page passed as argument has been added
to m2p_remove_override;

- the code of "xen p2m: clear the old pte when adding a page to
m2p_override" has been rearranged to return an error before modifying
the p2m.



The list of patches and the diffstat follow:

Daniel De Graaf (1):
      xen/gntdev: Fix circular locking dependency

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
 arch/x86/xen/p2m.c              |  509 ++++++++++++++++++++++++++++++
 drivers/xen/Kconfig             |    7 +
 drivers/xen/Makefile            |    2 +
 drivers/xen/gntdev.c            |  665 +++++++++++++++++++++++++++++++++++++++
 drivers/xen/grant-table.c       |   46 +++
 include/xen/gntdev.h            |  119 +++++++
 include/xen/grant_table.h       |   44 +++-
 10 files changed, 1406 insertions(+), 370 deletions(-)


A git branch with this series on top of Linux 2.6.37-rc5 is available
here:

git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git 2.6.37-rc5-gntdev-2

Cheers,

Stefano

