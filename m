Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760658Ab2FUXsA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 19:48:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:38636 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759835Ab2FUXr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 19:47:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="156925030"
Subject: [PATCH] pci: support alignments upto 8Gb in pbus_size_mem()
From: Nikhil P Rao <nikhil.rao@intel.com>
To: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        nikhil.rao@intel.com
In-Reply-To: <1340222160.77018.19.camel@localhost.localdomain>
References: <1340222160.77018.19.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Jun 2012 16:47:57 -0700
Message-ID: <1340322477.56127.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-10.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I ran into the "disabling BAR .." error message when
trying to use a 8Gb PCIe card on a system with a BIOS
that didnt have support for BAR size > 2Gb. This patch fixed
the problem, but I also see the code reading the IORESOURCE_MEM_64
flag so I am not sure what the right solution is

Signed-off-by: Nikhil P Rao <nikhil.rao@intel.com>
---
 drivers/pci/setup-bus.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 8fa2d4b..3b3601f 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -780,7 +780,7 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 {
 	struct pci_dev *dev;
 	resource_size_t min_align, align, size, size0, size1;
-	resource_size_t aligns[12];	/* Alignments from 1Mb to 2Gb */
+	resource_size_t aligns[14];	/* Alignments from 1Mb to 8Gb */
 	int order, max_order;
 	struct resource *b_res = find_free_bus_resource(bus, type);
 	unsigned int mem64_mask = 0;
@@ -819,7 +819,7 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 			/* For bridges size != alignment */
 			align = pci_resource_alignment(dev, r);
 			order = __ffs(align) - 20;
-			if (order > 11) {
+			if (order >= ARRAY_SIZE(aligns)) {
 				dev_warn(&dev->dev, "disabling BAR %d: %pR "
 					 "(bad alignment %#llx)\n", i, r,
 					 (unsigned long long) align);
-- 
1.7.1



