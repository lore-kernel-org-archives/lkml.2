Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502Ab2B2JgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 04:36:08 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48226 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932269Ab2B2JgE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 04:36:04 -0500
MIME-Version: 1.0
In-Reply-To: <1329929337-16648-1-git-send-email-m.szyprowski@samsung.com>
References: <1329929337-16648-1-git-send-email-m.szyprowski@samsung.com>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 29 Feb 2012 17:35:42 +0800
Message-ID: <CAGsJ_4wgVcVjtAa6Qpki=8jSON7MfwJ8yumJ1YXE5p8L3PqUzw@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCHv23 00/16] Contiguous Memory Allocator
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org, Ohad Ben-Cohen <ohad@wizery.com>,
        Daniel Walker <dwalker@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Jonathan Corbet <corbet@lwn.net>, Mel Gorman <mel@csn.ul.ie>,
        Michal Nazarewicz <mina86@mina86.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Jesse Barker <jesse.barker@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rob Clark <rob.clark@linaro.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/23 Marek Szyprowski <m.szyprowski@samsung.com>:
> Hi,
>
> This is (yet another) quick update of CMA patches. I've rebased them
> onto next-20120222 tree from
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git and
> fixed the bug pointed by Aaro Koskinen.

For the whole series:

Tested-by: Barry Song <Baohua.Song@csr.com>

and i also write a simple kernel helper to test the CMA:

/*
 * kernek module helper for testing CMA
 *
 * Copyright (c) 2011 Cambridge Silicon Radio Limited, a CSR plc group company.
 *
 * Licensed under GPLv2 or later.
 */

#include <linux/module.h>
#include <linux/device.h>
#include <linux/fs.h>
#include <linux/miscdevice.h>
#include <linux/dma-mapping.h>

#define CMA_NUM  10
static struct device *cma_dev;
static dma_addr_t dma_phys[CMA_NUM];
static void *dma_virt[CMA_NUM];

/* any read request will free coherent memory, eg.
 * cat /dev/cma_test
 */
static ssize_t
cma_test_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
{
	int i;

	for (i = 0; i < CMA_NUM; i++) {
		if (dma_virt[i]) {
			dma_free_coherent(cma_dev, (i + 1) * SZ_1M, dma_virt[i], dma_phys[i]);
			_dev_info(cma_dev, "free virt: %p phys: %p\n", dma_virt[i], (void
*)dma_phys[i]);
			dma_virt[i] = NULL;
			break;
		}
	}
	return 0;
}

/*
 * any write request will alloc coherent memory, eg.
 * echo 0 > /dev/cma_test
 */
static ssize_t
cma_test_write(struct file *file, const char __user *buf, size_t
count, loff_t *ppos)
{
	int i;
	int ret;

	for (i = 0; i < CMA_NUM; i++) {
		if (!dma_virt[i]) {
			dma_virt[i] = dma_alloc_coherent(cma_dev, (i + 1) * SZ_1M,
&dma_phys[i], GFP_KERNEL);

			if (dma_virt[i])
				_dev_info(cma_dev, "alloc virt: %p phys: %p\n", dma_virt[i], (void
*)dma_phys[i]);
			else {
				dev_err(cma_dev, "no mem in CMA area\n");
				ret = -ENOMEM;
			}
			break;
		}
	}

	return count;
}

static const struct file_operations cma_test_fops = {
	.owner =    THIS_MODULE,
	.read  =    cma_test_read,
	.write =    cma_test_write,
};

static struct miscdevice cma_test_misc = {
	.name = "cma_test",
	.fops = &cma_test_fops,
};

static int __init cma_test_init(void)
{
	int ret = 0;

	ret = misc_register(&cma_test_misc);
	if (unlikely(ret)) {
		pr_err("failed to register cma test misc device!\n");
		return ret;
	}
	cma_dev = cma_test_misc.this_device;
	cma_dev->coherent_dma_mask = ~0;
	_dev_info(cma_dev, "registered.\n");

	return ret;
}
module_init(cma_test_init);

static void __exit cma_test_exit(void)
{
	misc_deregister(&cma_test_misc);
}
module_exit(cma_test_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Barry Song <Baohua.Song@csr.com>");
MODULE_DESCRIPTION("kernel module to help the test of CMA");
MODULE_ALIAS("CMA test");

While fulfilling "dd if=/dev/mmcblk0 of=/dev/null bs=4096
count=1024000000 &" and "dd if=/dev/zero of=/data/1 bs=4096
count=1024000000 &" to exhaust memory at background,
i alloc the contiguous memories using the cma_test driver:
$echo 0 > /dev/cma_test
[   16.582216] misc cma_test: alloc virt: ceb00000 phys: 0eb00000
$echo 0 > /dev/cma_test
[   20.843395] misc cma_test: alloc virt: cec00000 phys: 0ec00000
$echo 0 > /dev/cma_test
[   21.774601] misc cma_test: alloc virt: cee00000 phys: 0ee00000
$echo 0 > /dev/cma_test
[   22.925633] misc cma_test: alloc virt: cf100000 phys: 0f100000

i did see the page write back is executed and contiguous memories are
always available.

P.S. the whole series was also back ported to 2.6.38.8 which our
release is based on.

>
> Best regards
> Marek Szyprowski
> Samsung Poland R&D Center
>
> Links to previous versions of the patchset:
> v22: <http://www.spinics.net/lists/linux-media/msg44370.html>
> v21: <http://www.spinics.net/lists/linux-media/msg44155.html>
> v20: <http://www.spinics.net/lists/linux-mm/msg29145.html>
> v19: <http://www.spinics.net/lists/linux-mm/msg29145.html>
> v18: <http://www.spinics.net/lists/linux-mm/msg28125.html>
> v17: <http://www.spinics.net/lists/arm-kernel/msg148499.html>
> v16: <http://www.spinics.net/lists/linux-mm/msg25066.html>
> v15: <http://www.spinics.net/lists/linux-mm/msg23365.html>
> v14: <http://www.spinics.net/lists/linux-media/msg36536.html>
> v13: (internal, intentionally not released)
> v12: <http://www.spinics.net/lists/linux-media/msg35674.html>
> v11: <http://www.spinics.net/lists/linux-mm/msg21868.html>
> v10: <http://www.spinics.net/lists/linux-mm/msg20761.html>
>  v9: <http://article.gmane.org/gmane.linux.kernel.mm/60787>
>  v8: <http://article.gmane.org/gmane.linux.kernel.mm/56855>
>  v7: <http://article.gmane.org/gmane.linux.kernel.mm/55626>
>  v6: <http://article.gmane.org/gmane.linux.kernel.mm/55626>
>  v5: (intentionally left out as CMA v5 was identical to CMA v4)
>  v4: <http://article.gmane.org/gmane.linux.kernel.mm/52010>
>  v3: <http://article.gmane.org/gmane.linux.kernel.mm/51573>
>  v2: <http://article.gmane.org/gmane.linux.kernel.mm/50986>
>  v1: <http://article.gmane.org/gmane.linux.kernel.mm/50669>
>
>
> Changelog:
>
> v23:
>    1. fixed bug spotted by Aaro Koskinen (incorrect check inside VM_BUG_ON)
>
>    2. rebased onto next-20120222 tree from
>       git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
>
> v22:
>    1. Fixed compilation break caused by missing fixup patch in v21
>
>    2. Fixed typos in the comments
>
>    3. Removed superfluous #include entries
>
> v21:
>    1. Fixed incorrect check which broke memory compaction code
>
>    2. Fixed hacky and racy min_free_kbytes handling
>
>    3. Added serialization patch to watermark calculation
>
>    4. Fixed typos here and there in the comments
>
> v20 and earlier - see previous patchsets.
>
>
> Patches in this patchset:
>
> Marek Szyprowski (6):
>  mm: extract reclaim code from __alloc_pages_direct_reclaim()
>  mm: trigger page reclaim in alloc_contig_range() to stabilise
>    watermarks
>  drivers: add Contiguous Memory Allocator
>  X86: integrate CMA with DMA-mapping subsystem
>  ARM: integrate CMA with DMA-mapping subsystem
>  ARM: Samsung: use CMA for 2 memory banks for s5p-mfc device
>
> Mel Gorman (1):
>  mm: Serialize access to min_free_kbytes
>
> Michal Nazarewicz (9):
>  mm: page_alloc: remove trailing whitespace
>  mm: compaction: introduce isolate_migratepages_range()
>  mm: compaction: introduce map_pages()
>  mm: compaction: introduce isolate_freepages_range()
>  mm: compaction: export some of the functions
>  mm: page_alloc: introduce alloc_contig_range()
>  mm: page_alloc: change fallbacks array handling
>  mm: mmzone: MIGRATE_CMA migration type added
>  mm: page_isolation: MIGRATE_CMA isolation functions added
>
>  Documentation/kernel-parameters.txt   |    9 +
>  arch/Kconfig                          |    3 +
>  arch/arm/Kconfig                      |    2 +
>  arch/arm/include/asm/dma-contiguous.h |   15 ++
>  arch/arm/include/asm/mach/map.h       |    1 +
>  arch/arm/kernel/setup.c               |    9 +-
>  arch/arm/mm/dma-mapping.c             |  369 ++++++++++++++++++++++++------
>  arch/arm/mm/init.c                    |   23 ++-
>  arch/arm/mm/mm.h                      |    3 +
>  arch/arm/mm/mmu.c                     |   31 ++-
>  arch/arm/plat-s5p/dev-mfc.c           |   51 +----
>  arch/x86/Kconfig                      |    1 +
>  arch/x86/include/asm/dma-contiguous.h |   13 +
>  arch/x86/include/asm/dma-mapping.h    |    4 +
>  arch/x86/kernel/pci-dma.c             |   18 ++-
>  arch/x86/kernel/pci-nommu.c           |    8 +-
>  arch/x86/kernel/setup.c               |    2 +
>  drivers/base/Kconfig                  |   89 +++++++
>  drivers/base/Makefile                 |    1 +
>  drivers/base/dma-contiguous.c         |  401 +++++++++++++++++++++++++++++++
>  include/asm-generic/dma-contiguous.h  |   28 +++
>  include/linux/device.h                |    4 +
>  include/linux/dma-contiguous.h        |  110 +++++++++
>  include/linux/gfp.h                   |   12 +
>  include/linux/mmzone.h                |   47 +++-
>  include/linux/page-isolation.h        |   18 +-
>  mm/Kconfig                            |    2 +-
>  mm/Makefile                           |    3 +-
>  mm/compaction.c                       |  418 +++++++++++++++++++++------------
>  mm/internal.h                         |   33 +++
>  mm/memory-failure.c                   |    2 +-
>  mm/memory_hotplug.c                   |    6 +-
>  mm/page_alloc.c                       |  409 ++++++++++++++++++++++++++++----
>  mm/page_isolation.c                   |   15 +-
>  mm/vmstat.c                           |    3 +
>  35 files changed, 1790 insertions(+), 373 deletions(-)
>  create mode 100644 arch/arm/include/asm/dma-contiguous.h
>  create mode 100644 arch/x86/include/asm/dma-contiguous.h
>  create mode 100644 drivers/base/dma-contiguous.c
>  create mode 100644 include/asm-generic/dma-contiguous.h
>  create mode 100644 include/linux/dma-contiguous.h
>
> --
> 1.7.1.569.g6f426

Thanks
barry
