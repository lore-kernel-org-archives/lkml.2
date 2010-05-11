Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab0EKPkM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 11:40:12 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:57143 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab0EKPkJ (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 11 May 2010 11:40:09 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org
Cc: albert_herranz@yahoo.es, chrisw@sous-sol.org, Ian.Campbell@eu.citrix.com,
       jeremy@goop.org, dwmw2@infradead.org
Subject: [PATCH] swiotlb v0.8: seperation of physical/virtual address translation
Date: Tue, 11 May 2010 11:39:07 -0400
Message-Id: <1273592353-23224-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.6.2.5
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090204.4BE97A4B.0097:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fujita-san et al.

Thank you for your continued careful review of these patches! I've attached your
set of patches to this e-mail, I hope that is ok?

Since the last posting [v7] I've done:
 - Minimized the list of exported functions even further.
 - Integrated your set of patches and changed "swiotlb_tlb" to "swiotlb_tbl"
[v6-v7 changes:]
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

The set of patches is also accessible on:

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/swiotlb-2.6.git swiotlb-0.8

 include/linux/swiotlb.h |   27 ++++++++-
 lib/swiotlb.c           |  140 ++++++++++++++++++++++++++++-------------------
 2 files changed, 108 insertions(+), 59 deletions(-)


