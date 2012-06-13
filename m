Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab2FMLCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 07:02:19 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:40705 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566Ab2FMLCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 07:02:14 -0400
X-AuditID: cbfee61b-b7fcc6d000003a7a-83-4fd87334f22f
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        Krishna Reddy <vdumpa@nvidia.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>, Subash Patel <subashrp@gmail.com>,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCHv3 0/3] ARM: replace custom consistent dma region with vmalloc
Date: Wed, 13 Jun 2012 13:01:43 +0200
Message-id: <1339585306-7147-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.10
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJJMWRmVeSWpSXmKPExsVy+t9jQV2T4hv+BisaFC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGs+MzWQoWClXMnPWErYHxOl8XIyeHhICJxJ+nE1ghbDGJC/fW
	s4HYQgLTGSUmL3fsYuQCslczSczr/sgMkmATMJToetsFVMTBISJQIzFvBiNIDbPAXGaJezt/
	soPUCAv4Snzt7mMEsVkEVCV2t68C6+UVcJf4PuMUO8QyeYmn9/vYJjByL2BkWMUomlqQXFCc
	lJ5rpFecmFtcmpeul5yfu4kR7MFn0jsYVzVYHGIU4GBU4uGNKLjhL8SaWFZcmXuIUYKDWUmE
	91k2UIg3JbGyKrUoP76oNCe1+BCjNAeLkjhvk/UFfyGB9MSS1OzU1ILUIpgsEwenVANjQaHG
	ztTDJx4cja7w3qd5gZv96Jl5Lhd53mztPqpuvEkyKjvyq/TJI8u5314Ojn+rdmbV21jju3Ou
	pL76GZ7dm3fBSNfig3bxqlntrGzqjkkntlTV9xkw62b6e4qEGcqenXToY89M9W1zmeVdpnyt
	7YxmPsgUV7zZ2pfrq8sz79p81ebd1x4psRRnJBpqMRcVJwIAnYHi59wBAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

This patchset replaces custom consistent dma regions usage in
dma-mapping framework in favour of generic vmalloc areas created on
demand for each allocation. The main purpose for this patchset is to
remove 2MiB limit of dma coherent/writecombine allocations.

Atomic allocations are served from special pool preallocated on boot,
becasue vmalloc areas cannot be reliably created in atomic context.

Linux v3.5-rc1 introduced a lot of changes to ARM dma-mapping subsystem
(CMA and dmamap_ops based implementation has been finally merged), so
the previous version of these patches is not applicable anymore. This
version provides an update required for applying them on v3.5-rc2 kernel
as well as some changes requested by Minchan Kim in his review.

This patch is based on vanilla v3.5-rc2 release.

Atomic allocations have been tested with s3c-sdhci driver on Samsung
UniversalC210 board with dmabounce code enabled to force
dma_alloc_coherent() use on each dma_map_* call (some of them are made
from interrupts).

Best regards
Marek Szyprowski
Samsung Poland R&D Center

Changelog:

v3:
- rebased onto v3.4-rc2: added support for IOMMU-aware implementation 
  of dma-mapping calls, unified with CMA coherent dma pool
- implemented changes requested by Minchan Kim: added more checks for
  vmarea->flags & VM_DMA, renamed some variables, removed obsole locks,
  squashed find_vm_area() exporting patch into the main redesign patch 

v2: http://thread.gmane.org/gmane.linux.kernel.mm/78563
- added support for atomic allocations (served from preallocated pool)
- minor cleanup here and there
- rebased onto v3.4-rc7

v1: http://thread.gmane.org/gmane.linux.kernel.mm/76703
- initial version

Patch summary:

Marek Szyprowski (3):
  mm: vmalloc: use const void * for caller argument
  mm: vmalloc: add VM_DMA flag to indicate areas used by dma-mapping
    framework
  ARM: dma-mapping: remove custom consistent dma region

 Documentation/kernel-parameters.txt |    2 +-
 arch/arm/include/asm/dma-mapping.h  |    2 +-
 arch/arm/mm/dma-mapping.c           |  503 ++++++++++++-----------------------
 include/linux/vmalloc.h             |   10 +-
 mm/vmalloc.c                        |   31 ++-
 5 files changed, 206 insertions(+), 342 deletions(-)

-- 
1.7.1.569.g6f426

