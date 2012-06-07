Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759831Ab2FGEog (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:44:36 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59627 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759636Ab2FGERN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:17:13 -0400
Message-Id: <20120607040340.344605807@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:04:03 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Joerg Roedel <joerg.roedel@amd.com>
Subject: [ 27/82] iommu/amd: Add workaround for event log erratum
In-Reply-To: <20120607041406.GA13233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

commit 3d06fca8d2aa3543030e40b95f1d62f9f5a03540 upstream.

Due to a recent erratum it can happen that the head pointer
of the event-log is updated before the actual event-log
entry is written. This patch implements the recommended
workaround.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/amd_iommu.c |   29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -450,12 +450,27 @@ static void dump_command(unsigned long p
 
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
 
@@ -508,6 +523,8 @@ static void iommu_print_event(struct amd
 	default:
 		printk(KERN_ERR "UNKNOWN type=0x%02x]\n", type);
 	}
+
+	memset(__evt, 0, 4 * sizeof(u32));
 }
 
 static void iommu_poll_events(struct amd_iommu *iommu)


