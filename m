Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab2C3PUM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 11:20:12 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52924 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab2C3PUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 11:20:06 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jiang Liu <jiang.liu@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        Keping Chen <chenkeping@huawei.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/4] normalize return value of chip->irq_set_affinity()
Date: Fri, 30 Mar 2012 23:11:32 +0800
Message-Id: <1333120296-13563-1-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On x86 platforms, interrupt controller chip's irq_set_affinity() method
always copies affinity mask to irq_data->affinity field but still returns
0(IRQ_SET_MASK_OK). That return value causes the interrupt core logic
unnecessarily copies the mask to irq_data->affinity field again.
So return IRQ_SET_MASK_OK_NOCOPY instead of IRQ_SET_MASK_OK to get rid of
the duplicated copy operation.

This patch also fixes a minor bug in irq_move_masked_irq(), which treats
return value IRQ_SET_MASK_OK_NOCOPY as error code.

v2/v3: split patches to only do one thing in a patch according to Thomas'
    suggestion

Jiang Liu (4):
  IRQ: correctly handle return value from chip->irq_set_affinity() in
    irq_move_masked_irq()
  IRQ: introduce irq_do_set_affinity() to reduce duplicated code
  IRQ,x86: normalize return value of chip->irq_set_affinity() method
  IRQ,IA64: normalize return value of chip->irq_set_affinity() method

 arch/ia64/kernel/iosapic.c     |    4 +++-
 arch/ia64/kernel/msi_ia64.c    |    4 ++--
 arch/ia64/sn/kernel/irq.c      |    2 +-
 arch/ia64/sn/kernel/msi_sn.c   |    2 +-
 arch/x86/kernel/apic/io_apic.c |   11 ++++++-----
 arch/x86/platform/uv/uv_irq.c  |    2 +-
 kernel/irq/internals.h         |    3 +++
 kernel/irq/manage.c            |   39 ++++++++++++++++++++++-----------------
 kernel/irq/migration.c         |    6 +-----
 9 files changed, 40 insertions(+), 33 deletions(-)

-- 
1.7.5.4

