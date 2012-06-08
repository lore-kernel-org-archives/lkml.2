Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759097Ab2FHFGr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:06:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43112 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756728Ab2FHFGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:06:44 -0400
Message-Id: <20120608041841.051049112@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:18:41 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Joerg Roedel <joerg.roedel@amd.com>
Subject: [ 01/82] iommu/amd: Add workaround for event log erratum
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

commit 3d06fca8d2aa3543030e40b95f1d62f9f5a03540 upstream.

Due to a recent erratum it can happen that the head pointer
of the event-log is updated before the actual event-log
entry is written. This patch implements the recommended
workaround.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/iommu/amd_iommu.c |   29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

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


