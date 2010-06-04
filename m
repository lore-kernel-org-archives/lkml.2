Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438Ab0FDRzr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 13:55:47 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:27663 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038Ab0FDRzo (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Fri, 4 Jun 2010 13:55:44 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: albert_herranz@yahoo.es, fujita.tomonori@lab.ntt.co.jp,
       akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, jeremy@goop.org,
       iommu@lists.linux-foundation.org, linux@arm.linux.org.uk,
       dwmw2@infradead.org, chrisw@sous-sol.org, Ian.Campbell@eu.citrix.com
Subject: [PATCH] swiotlb-0.8.2: seperation of physical/virtual address translation and core memory allocation.
Date: Fri,  4 Jun 2010 13:52:30 -0400
Message-Id: <1275673955-30267-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.6.2.5
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090207.4C093DCD.0054:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please include the following patches, located at this git tree:

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/swiotlb-2.6.git swiotlb-0.8.2

in your -mm tree.

Attached is a set of patches that separate the address translation
(virt_to_phys, virt_to_bus, etc) and allocation of the SWIOTLB buffer
from the SWIOTLB library.

Since the last posting [v8.1] I've done:
 - Rolled-up the last two patches in one.
 - Rebased against linus latest. That meant dealing with swiotlb_sync_single_range_* changes.
 - added Acked-by: Fujita Tomonori and Tested-by: Albert Herranz
[v7-v8 changes:]
 - Minimized the list of exported functions.
 - Integrated Fujita's patches and changed "swiotlb_tlb" to "swiotlb_tbl" in them.
[v6-v7 changes:]
 - Minimized the amount of exported functions/variable with a prefix of: "swiotbl_tbl".
 - Made the usage of 'int dir' to be 'enum dma_data_direction'.
[v5-v6 changes:]
 - Made the exported functions/variables have the 'swiotlb_bk' prefix.
 - dropped the checkpatches/other reworks

.. and the writeup for this set set of patches:

The idea behind this set of patches is to make it possible to have separate
mechanisms for translating virtual to physical or virtual to DMA addresses
on platforms which need an SWIOTLB, and where physical != PCI bus address
and also able to allocate the core IOTLB memory outside SWIOTLB.

One customers of this is the pv-ops project, which can switch between
different modes of operation depending on the environment it is running in:
bare-metal or virtualized (Xen for now). Another is the Wii DMA - used to
implement the MEM2 DMA facility needed by its EHCI controller (for details:
http://lkml.org/lkml/2010/5/18/303)

On bare-metal SWIOTLB is used when there are no hardware IOMMU. In virtualized
environment it used when PCI pass-through(*1) is enabled for the guest. The problems
with PCI pass-through is that the guest's idea of PFN's is not the real thing.
To fix that, there is translation layer for PFN->machine frame number and vice-versa.
To bubble that up to the SWIOTLB layer there are two possible solutions.

One solution has been to wholesale copy the SWIOTLB, stick it in
arch/x86/xen/swiotlb.c and modify the virt_to_phys, phys_to_virt and others
to use the Xen address translation functions. Unfortunately, since the kernel can
run on bare-metal, there would be big code overlap with the real SWIOTLB.
(git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git xen/dom0/swiotlb-new)

Another approach, which this set of patches explores, is to abstract the
address translation and address determination functions away from the
SWIOTLB book-keeping functions. This way the core SWIOTLB library functions
are present in one place, while the address related functions are in
a separate library that can be loaded when running under non-bare-metal platform.

The changes since commit 9dda696f0de87a2e5cfabb147e28c76b7d3c6846:
Linus Torvalds:
    Merge branch 'release' of git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux-2.6

are as follow:

FUJITA Tomonori (2):
      swiotlb: add swiotlb_tbl_map_single library function
      swiotlb: add the swiotlb initialization function with iotlb memory

Konrad Rzeszutek Wilk (3):
      swiotlb: Make internal bookkeeping functions have 'swiotlb_tbl' prefix.
      swiotlb: search and replace "int dir" with "enum dma_data_direction dir"
      swiotlb: Make swiotlb bookkeeping functions visible in the header file.

 include/linux/swiotlb.h |   27 +++++++++-
 lib/swiotlb.c           |  137 ++++++++++++++++++++++++++++-------------------
 2 files changed, 106 insertions(+), 58 deletions(-)


*1: PCI passthrough:
Haven't posted those yet. Located at:
git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git pv/pcifront-2.6.34

