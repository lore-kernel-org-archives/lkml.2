Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750884Ab1DUEDv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 00:03:51 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:61804 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab1DUEDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 00:03:50 -0400
Subject: [RFC PATCH v2 0/4] Switch to core code for irq allocation
To: benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
From: Grant Likely <grant.likely@secretlab.ca>
Cc: tglx@linutronix.de
Date: Wed, 20 Apr 2011 22:03:48 -0600
Message-ID: <20110421040036.30579.53752.stgit@ponder>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Ben,

Can you take a look at this series and let me know what you think.
The only functional change is in the last patch which uses the core
irq_alloc_desc*() infrastructure to allocating irqs.

I know I've left race conditions in the code; specifically the
unlikely case of two threads trying to map the same interrupt at the
same time.  Both will see that it isn't allocated, and both will do
the allocation (I think).  I need to hack on it more, but I wanted to
get your feedback.

Ultimately I'm hoping to be rid of the irq_map table entirely.

g.

---

Grant Likely (4):
      powerpc: stop exporting irq_map
      powerpc: make irq_{alloc,free}_virt private and remove count argument
      powerpc: move irq_alloc_descs_at() call into irq_alloc_virt()
      powerpc: use irq_alloc_desc() to manage irq allocations


 arch/microblaze/kernel/setup.c                   |    2 
 arch/powerpc/include/asm/irq.h                   |   47 ------
 arch/powerpc/kernel/irq.c                        |  162 +++++++++++-----------
 arch/powerpc/platforms/512x/mpc5121_ads_cpld.c   |    4 -
 arch/powerpc/platforms/52xx/media5200.c          |    4 -
 arch/powerpc/platforms/52xx/mpc52xx_pic.c        |   79 ++---------
 arch/powerpc/platforms/82xx/pq2ads-pci-pic.c     |    4 -
 arch/powerpc/platforms/85xx/socrates_fpga_pic.c  |   26 +---
 arch/powerpc/platforms/86xx/gef_pic.c            |   10 -
 arch/powerpc/platforms/8xx/m8xx_setup.c          |    2 
 arch/powerpc/platforms/cell/axon_msi.c           |    2 
 arch/powerpc/platforms/cell/spider-pic.c         |   10 +
 arch/powerpc/platforms/embedded6xx/flipper-pic.c |    8 +
 arch/powerpc/platforms/embedded6xx/hlwd-pic.c    |    8 +
 arch/powerpc/platforms/iseries/irq.c             |   10 +
 arch/powerpc/platforms/powermac/pic.c            |   12 +-
 arch/powerpc/platforms/pseries/ras.c             |    4 -
 arch/powerpc/platforms/pseries/xics.c            |   14 +-
 arch/powerpc/sysdev/cpm1.c                       |    8 +
 arch/powerpc/sysdev/cpm2_pic.c                   |   10 +
 arch/powerpc/sysdev/ipic.c                       |   16 +-
 arch/powerpc/sysdev/mpc8xx_pic.c                 |   10 +
 arch/powerpc/sysdev/mpc8xxx_gpio.c               |   12 +-
 arch/powerpc/sysdev/mpic.c                       |   28 ++--
 arch/powerpc/sysdev/mv64x60_pic.c                |   14 +-
 arch/powerpc/sysdev/qe_lib/qe_ic.c               |    6 -
 arch/powerpc/sysdev/uic.c                        |   12 +-
 arch/powerpc/sysdev/xilinx_intc.c                |    8 +
 28 files changed, 206 insertions(+), 326 deletions(-)

-- 
Signature
