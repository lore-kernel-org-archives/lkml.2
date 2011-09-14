Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036Ab1INQia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 12:38:30 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48559 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756502Ab1INQi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 12:38:29 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, marc.zyngier@arm.com, thomas.abraham@linaro.org,
        jamie@jamieiles.com, b-cousson@ti.com, shawn.guo@linaro.org,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 0/5] GIC OF bindings
Date: Wed, 14 Sep 2011 11:31:35 -0500
Message-Id: <1316017900-19918-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

This series introduces of_irq_init to scan the device tree for interrupt
controller nodes and call their init functions in proper order. The GIC
init function is then called from this function. The platform code then
looks something like this:

const static struct of_device_id irq_match[] = {
	{ .compatible = "arm,cortex-a9-gic", .data = gic_of_init, },
	{}
};

static void __init highbank_init_irq(void)
{
	of_irq_init(irq_match);
}

The binding for GIC PPIs is now done with a 3rd interrupt cell to specify
a cpu mask for which cpu the PPI is connected to. This was discussed at LPC
and suggested by Grant.

I dropped the public intc_desc struct. The the interrupt controller's node
and the interrupt parent's node are passed in directly to the controller's
init function. The linux irq assignment is now done dynamically using
irq_alloc_descs.

The first 2 patches are minor fixes to irqdomains.

Rob

Rob Herring (5):
  irq: add declaration of irq_domain_simple_ops to irqdomain.h
  irq: fix existing domain check in irq_domain_add
  of/irq: introduce of_irq_init
  ARM: gic: allow irq_start to be 0
  ARM: gic: add OF based initialization

 Documentation/devicetree/bindings/arm/gic.txt |   53 ++++++++++++++
 arch/arm/common/gic.c                         |   57 +++++++++++++--
 arch/arm/include/asm/hardware/gic.h           |   10 +++
 drivers/of/irq.c                              |   96 +++++++++++++++++++++++++
 include/linux/irqdomain.h                     |    1 +
 include/linux/of_irq.h                        |    1 +
 kernel/irq/irqdomain.c                        |    2 +-
 7 files changed, 214 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/gic.txt

-- 
1.7.5.4

