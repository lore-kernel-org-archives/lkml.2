Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab2DSNpg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 09:45:36 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:36059
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752808Ab2DSNpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 09:45:35 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bh8275dhz2dh668h839hd24h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M2QBA9-01-7WN-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/2] iommu/amd: Add workaround for event log erratum
Date: Thu, 19 Apr 2012 15:39:37 +0200
Message-ID: <1334842777-23214-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1334842777-23214-1-git-send-email-joerg.roedel@amd.com>
References: <1334842777-23214-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to a recent erratum it can happen that the head pointer
of the event-log is updated before the actual event-log
entry is written. This patch implements the recommended
workaround.

Cc: stable@vger.kernel.org	# all stable kernels
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu.c |   29 +++++++++++++++++++++++------
 1 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 08f3eec..d90a421 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -450,12 +450,27 @@ static void dump_command(unsigned long phys_addr)
 
 static void iommu_print_event(struct amd_iommu *iommu, void *__evt)
 {
-	u32 *event = __evt;
-	int type  = (event[1] >> EVENT_TYPE_SHIFT)  & EVENT_TYPE_MASK;
-	int devid = (event[0] >> EVENT_DEVID_SHIFT) & EVENT_DEVID_MASK;
-	int domid = (event[1] >> EVENT_DOMID_SHIFT) & EVENT_DOMID_MASK;
-	int flags = (event[1] >> EVENT_FLAGS_SHIFT) & EVENT_FLAGS_MASK;
-	u64 address = (u64)(((u64)event[3]) << 32) | event[2];
+	int type, devid, domid, flags;
+	volatile u32 *event = __evt;
+	int count = 0;
+	u64 address;
+
+retry:
+	type    = (event[1] >> EVENT_TYPE_SHIFT)  & EVENT_TYPE_MASK;
+	devid   = (event[0] >> EVENT_DEVID_SHIFT) & EVENT_DEVID_MASK;
+	domid   = (event[1] >> EVENT_DOMID_SHIFT) & EVENT_DOMID_MASK;
+	flags   = (event[1] >> EVENT_FLAGS_SHIFT) & EVENT_FLAGS_MASK;
+	address = (u64)(((u64)event[3]) << 32) | event[2];
+
+	if (type == 0) {
+		/* Did we hit the erratum? */
+		if (++count == LOOP_TIMEOUT) {
+			pr_err("AMD-Vi: No event written to event log\n");
+			return;
+		}
+		udelay(1);
+		goto retry;
+	}
 
 	printk(KERN_ERR "AMD-Vi: Event logged [");
 
@@ -508,6 +523,8 @@ static void iommu_print_event(struct amd_iommu *iommu, void *__evt)
 	default:
 		printk(KERN_ERR "UNKNOWN type=0x%02x]\n", type);
 	}
+
+	memset(__evt, 0, 4 * sizeof(u32));
 }
 
 static void iommu_poll_events(struct amd_iommu *iommu)
-- 
1.7.5.4


