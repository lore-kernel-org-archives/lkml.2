Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761622Ab2EQKzD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 06:55:03 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:9481 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760405Ab2EQKzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 06:55:00 -0400
Date: Thu, 17 May 2012 12:54:41 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCHv2 0/4] ARM: replace custom consistent dma region with vmalloc
To: linux-arm-kernel@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        Krishna Reddy <vdumpa@nvidia.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>, Subash Patel <subashrp@gmail.com>
Message-id: <1337252085-22039-1-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.10.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

Recent changes to ioremap and unification of vmalloc regions on ARM
significantly reduces the possible size of the consistent dma region.
They are significantly limited allowed dma coherent/writecombine
allocations.

This experimental patchset replaces custom consistent dma regions usage
in dma-mapping framework in favour of generic vmalloc areas created on
demand for each coherent and writecombine allocations. The main purpose
for this patchset is to remove 2MiB limit of dma coherent/writecombine
allocations.

Atomic allocations are served from special pool preallocated on boot,
becasue vmalloc areas cannot be reliably created in atomic context.

This patch is based on vanilla v3.4-rc7 release.

Atomic allocations have been tested with s3c-sdhci driver on Samsung
UniversalC210 board with dmabounce code enabled to force
dma_alloc_coherent() use on each dma_map_* call (some of them are made
from interrupts).

Best regards
Marek Szyprowski
Samsung Poland R&D Center

Changelog:

v2:
- added support for atomic allocations (served from preallocated pool)
- minor cleanup here and there
- rebased onto v3.4-rc7

v1: http://thread.gmane.org/gmane.linux.kernel.mm/76703
- initial version

Patch summary:

Marek Szyprowski (4):
  mm: vmalloc: use const void * for caller argument
  mm: vmalloc: export find_vm_area() function
  mm: vmalloc: add VM_DMA flag to indicate areas used by dma-mapping
    framework
  ARM: dma-mapping: remove custom consistent dma region

 Documentation/kernel-parameters.txt |    4 +
 arch/arm/include/asm/dma-mapping.h  |    2 +-
 arch/arm/mm/dma-mapping.c           |  360 ++++++++++++++++-------------------
 include/linux/vmalloc.h             |   10 +-
 mm/vmalloc.c                        |   31 ++--
 5 files changed, 185 insertions(+), 196 deletions(-)

-- 
1.7.10.1

