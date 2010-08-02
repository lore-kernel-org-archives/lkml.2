Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab0HBP7K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 11:59:10 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:64980 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab0HBP7I (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 2 Aug 2010 11:59:08 -0400
Date: Mon, 2 Aug 2010 11:58:18 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: torvalds@linux-foundation.org
Cc: fujita.tomonori@lab.ntt.co.jp, albert_herranz@yahoo.es,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] SWIOTLB features: separation of physical and virtual
 address translation for v2.6.36
Message-ID: <20100802155818.GB28961@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4C56EB2D.019C:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please include the following patches, located at this git tree:

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/swiotlb-2.6.git stable/swiotlb-0.8.3

in your new 2.6.36 branch.

They have been reviewed, ack-ed, re-reviewed, tested and been brewing properly for 7
weeks in linux-next. These set of patches separate the address translation
(virt_to_phys, virt_to_bus, etc) and allocation of the SWIOTLB buffer
from the SWIOTLB library. A more detailed explanation is right after the changelist.

The authors:

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

This patchset changelist:

Since the last posting [v8.4]:
 - Added in this writeup in the patch.
[v8 changes:]
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
and also to allocate the core IOTLB memory outside SWIOTLB.

One customers of this is the pv-ops project, which can switch between
different modes of operation depending on the environment it is running in:
bare-metal or virtualized (Xen for now). Another is the Wii DMA - used to
implement the MEM2 DMA facility needed by its EHCI controller (for details:
http://lkml.org/lkml/2010/5/18/303)

On bare-metal SWIOTLB is used when there are no hardware IOMMU. In virtualized
environment it used when PCI pass-through is enabled for the guest. The problems
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


