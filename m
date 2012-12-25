Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab2LYLTu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 06:19:50 -0500
Received: from mail-da0-f44.google.com ([209.85.210.44]:35108 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697Ab2LYLTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 06:19:45 -0500
From: Hideki EIRAKU <hdk@igel.co.jp>
To: Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-sh@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Katsuya MATSUBARA <matsu@igel.co.jp>,
        Damian Hobson-Garcia <dhobsong@igel.co.jp>,
        Hideki EIRAKU <hdk@igel.co.jp>
Subject: [PATCH v5 0/4] Renesas IPMMU driver for sh7372, sh73a0 and r8a7740
Date: Tue, 25 Dec 2012 20:19:11 +0900
Message-Id: <1356434355-3279-1-git-send-email-hdk@igel.co.jp>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the Renesas IPMMU driver, IOMMU API implementation and IPMMU
device support for sh7372 (AP4EVB and Mackerel), sh73a0 and r8a7740.

The IPMMU module supports the MMU function and the PMB function.  The
MMU function provides address translation by pagetable compatible with
ARMv6.  The PMB function provides address translation including
tile-linear translation.  This is implementation of the MMU function.

Note: The IPMMU module translates DMA memory address from all of the
IP blocks on the ICB.  The IOMMU API has iommu_attach_device() which
attaches one device to one domain, but the IPMMU module cannot attach
only one device.  The IPMMU module only can attach all devices to one
domain.

Tested on:
- armadillo800eva
- kzma9
- mackerel (I could not make it boot the v3.8-rc1 with Device Tree, so
  I tested a kernel without Device Tree support, reverting
  3b7b70552afe351a8bd8fff1eb2d60aab2206576 and
  0ce53cdc5c7e28f378e480363a0b0c2ed7e7eaf9)

How to test:
1. Boot a kernel built with CONFIG_SHMOBILE_IOMMU=y.
2. Check whether a display on the board shows console normally.
3. Check whether the IMCTR1 register is 1 which means the MMU function enabled.
   To read the IMCTR1 register:
   # peekpoke 0xfe951000
4. Change the IMCTR1 to 0 to disable the MMU function.
   To change the IMCTR1 register to 0:
   # peekpoke 0xfe951000 0
5. Check whether the display shows broken data.
6. Change the IMCTR1 to 1 to enable the MMU function.
   To change the IMCTR1 register to 1:
   # peekpoke 0xfe951000 1
7. Check whether a display on the board shows console normally.
8. Capture and check the framebuffer contents via memory mapped by mmap().
   To capture the framebuffer contents and save the image to a file "filename":
   # fbcat /dev/fb0 > filename
   To look at the contents saved by fbcat on a PC:
   $ display filename
- fbcat can be downloaded from https://code.google.com/p/fbcat/.
- display is one of the ImageMagick tools.
- peekpoke is:
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include <err.h>
int main(int argc,char**argv){
  uint32_t*p,addr;
  int fd=open("/dev/mem",O_RDWR);
  if(fd<0)err(1,"open");
  addr=strtoul(argv[1],NULL,0);
  p=mmap(NULL,0x1000,PROT_READ|PROT_WRITE,MAP_SHARED,fd,addr&~0xfff);
  if(p==MAP_FAILED)err(1,"mmap");
  if(argc<=2)printf("0x%08x\n",p[addr/4&0x3ff]);
  else printf("wrote 0x%08x\n",p[addr/4&0x3ff]=strtoul(argv[2],NULL,0));
}

Changelog:
v5:
- Rebased on 3.8-rc1.
- Add sh73a0 and r8a7740 support.
- CONFIG_SHMOBILE_IOMMU is now selectable only for arm shmobile
  architecture.
- Fix "defined but not used" warnings when CONFIG_SHMOBILE_IOMMU is
  not set.
- Add help text of CONFIG_SHMOBILE_IOMMU.
- Apply some of Laurent Pinchart's rework patches: Move the driver to
  drivers/iommu/.
- Use platform_data to specify attaching devices instead of
  ipmmu_add_device() API.
v4:
- Rebased on 3.7-rc1.
- Use address space size instead of page table size in config.
- Use Kconfig default value instead of #ifdef-#define-#endif.
v3:
- Rebased on 3.6-rc5.
- Simplify configs.  SHMOBILE_IPMMU is now selected by setting
  SHMOBILE_IOMMU.
- Remove weak symbols.
- Use drvdata to store private driver data.
- Make a function for writing to a register of IPMMU.
- Add a lock to accessing the tlb_enabled member.
- Make unmap work correctly with size larger than map size.
- Free L2 page table when 1MiB page is mapped or unmapped.
- Add VEU devices as IP blocks on the ICB.
v2:
- Rebased on v3.6-rc1.
- Make variable names clear.
- Page table size can now be selected by config.

Hideki EIRAKU (4):
  iommu/shmobile: Add iommu driver for Renesas IPMMU modules
  ARM: mach-shmobile: sh7372: Add IPMMU device
  ARM: mach-shmobile: sh73a0: Add IPMMU device
  ARM: mach-shmobile: r8a7740: Add IPMMU device

 arch/arm/mach-shmobile/setup-r8a7740.c |  33 ++++
 arch/arm/mach-shmobile/setup-sh7372.c  |  39 ++++
 arch/arm/mach-shmobile/setup-sh73a0.c  |  31 +++
 drivers/iommu/Kconfig                  |  74 +++++++
 drivers/iommu/Makefile                 |   2 +
 drivers/iommu/shmobile-iommu.c         | 341 +++++++++++++++++++++++++++++++++
 drivers/iommu/shmobile-ipmmu.c         | 136 +++++++++++++
 drivers/iommu/shmobile-ipmmu.h         |  37 ++++
 include/linux/platform_data/sh_ipmmu.h |  18 ++
 9 files changed, 711 insertions(+)
 create mode 100644 drivers/iommu/shmobile-iommu.c
 create mode 100644 drivers/iommu/shmobile-ipmmu.c
 create mode 100644 drivers/iommu/shmobile-ipmmu.h
 create mode 100644 include/linux/platform_data/sh_ipmmu.h

-- 
1.8.0

