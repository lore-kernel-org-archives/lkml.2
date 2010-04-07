Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab0DGUc2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 16:32:28 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:20566 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab0DGUcX (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 7 Apr 2010 16:32:23 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       albert_herranz@yahoo.es
Cc: linux@eikelenboom.it, chrisw@sous-sol.org, Ian.Campbell@eu.citrix.com,
       jeremy@goop.org, dwmw2@infradead.org, alex.williamson@hp.com
Subject: [PATCH] swiotlb 0.7: separation of physical and virtual address translation.
Date: Wed,  7 Apr 2010 16:29:24 -0400
Message-Id: <1270672170-31833-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.6.2.5
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4BBCEB6A.003A:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fujita-san et al.

Attached is a set of patches that separate the address translation
(virt_to_phys, virt_to_bus, etc) from the SWIOTLB library.

Since the last posting [v6] I've done:
 - Minimized the list exported functions/variable with a prefix of: "swiotbl_tbl".
 - Made the usage of 'int dir' to be 'enum dma_data_direction'.
[v5-v6 changes:]
 - Made the exported functions/variables have the 'swiotlb_bk' prefix to be
   more uniform.
 - dropped the checkpatches/other reworks

.. and the writeup for this set set of patches:

The idea behind this set of patches is to make it possible to have separate
mechanisms for translating virtual to physical or virtual to DMA addresses
on platforms which need an SWIOTLB, and where physical != PCI bus address.

One customers of this is the pv-ops project, which can switch between
different modes of operation depending on the environment it is running in:
bare-metal or virtualized (Xen for now). Another is the Wii DMA implementation
so that the Wii USB controller can work.

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

The set of patches is also accessible on

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/swiotlb-2.6.git swiotlb-0.7

 include/linux/swiotlb.h |   37 +++++++-
 lib/swiotlb.c           |  244 +++++++++++++++++++++++++---------------------
 2 files changed, 168 insertions(+), 113 deletions(-)

P.S.
There is also a branch utilizing the above mentioned patches: xen-swiotlb-0.7
