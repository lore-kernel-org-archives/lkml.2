Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab0F3Vt2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 17:49:28 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:47726 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753027Ab0F3Vt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 17:49:27 -0400
Date: Wed, 30 Jun 2010 14:49:23 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, muli@il.ibm.com,
       cschultz@linux.vnet.ibm.com, stable@kernel.org, tglx@linutronix.de,
       mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: [PATCH] x86, Calgary: Increase max PHB number
Message-ID: <20100630214923.GP15515@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20100624212647.GI15515@tux1.beaverton.ibm.com> <tip-499a00e92dd9a75395081f595e681629eb1eebad@git.kernel.org> <20100629155151.7caaff4b.akpm@linux-foundation.org> <4C2BB7C0.9040000@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C2BB7C0.9040000@zytor.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Newer systems (x3950M2) can have 48 PHBs per chassis and 4 chassis, so bump the
limits up and provide an explanation of the requirements for each class.  Since
we can't have more than 256 PCI buses in these systems, we don't need the array
check.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 arch/x86/kernel/pci-calgary_64.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)


diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index fb99f7e..fd4e27b 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -103,10 +103,14 @@ int use_calgary __read_mostly = 0;
 #define PMR_SOFTSTOPFAULT	0x40000000
 #define PMR_HARDSTOP		0x20000000
 
-#define MAX_NUM_OF_PHBS		8 /* how many PHBs in total? */
-#define MAX_NUM_CHASSIS		8 /* max number of chassis */
-/* MAX_PHB_BUS_NUM is the maximal possible dev->bus->number */
-#define MAX_PHB_BUS_NUM		(MAX_NUM_OF_PHBS * MAX_NUM_CHASSIS * 2)
+/*
+ * The maximum PHB bus number.
+ * x3950M2: 4 chassis, 48 PHBs per chassis        = 192
+ * x3950 (PCIE): 8 chassis, 32 PHBs per chassis   = 256
+ * x3950 (PCIX): 8 chassis, 16 PHBs per chassis   = 128
+ */
+#define MAX_PHB_BUS_NUM		256
+
 #define PHBS_PER_CALGARY	4
 
 /* register offsets in Calgary's internal register space */
@@ -1051,8 +1055,6 @@ static int __init calgary_init_one(struct pci_dev *dev)
 	struct iommu_table *tbl;
 	int ret;
 
-	BUG_ON(dev->bus->number >= MAX_PHB_BUS_NUM);
-
 	bbar = busno_to_bbar(dev->bus->number);
 	ret = calgary_setup_tar(dev, bbar);
 	if (ret)
