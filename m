Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217Ab2BEWsd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:48:33 -0500
Received: from 1wt.eu ([62.212.114.60]:61854 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753607Ab2BEW0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:16 -0500
Message-Id: <20120205220950.516072640@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:10:14 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Joerg Roedel <joerg.roedel@amd.com>, Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 25/91] x86/amd-iommu: Fix 3 possible endless loops
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

commit 0de66d5b35ee148455e268b2782873204ffdef4b upstream.

The driver contains several loops counting on an u16 value
where the exit-condition is checked against variables that
can have values up to 0xffff. In this case the loops will
never exit. This patch fixed 3 such loops.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kernel/amd_iommu_init.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

Index: longterm-2.6.27/arch/x86/kernel/amd_iommu_init.c
===================================================================
--- longterm-2.6.27.orig/arch/x86/kernel/amd_iommu_init.c	2012-02-05 22:34:34.270914795 +0100
+++ longterm-2.6.27/arch/x86/kernel/amd_iommu_init.c	2012-02-05 22:34:38.426915208 +0100
@@ -538,8 +538,8 @@
 {
 	u8 *p = (u8 *)h;
 	u8 *end = p, flags = 0;
-	u16 dev_i, devid = 0, devid_start = 0, devid_to = 0;
-	u32 ext_flags = 0;
+	u16 devid = 0, devid_start = 0, devid_to = 0;
+	u32 dev_i, ext_flags = 0;
 	bool alias = false;
 	struct ivhd_entry *e;
 
@@ -638,7 +638,7 @@
 /* Initializes the device->iommu mapping for the driver */
 static int __init init_iommu_devices(struct amd_iommu *iommu)
 {
-	u16 i;
+	u32 i;
 
 	for (i = iommu->first_device; i <= iommu->last_device; ++i)
 		set_iommu_for_device(iommu, i);
@@ -833,7 +833,7 @@
  */
 static void init_device_table(void)
 {
-	u16 devid;
+	u32 devid;
 
 	for (devid = 0; devid <= amd_iommu_last_bdf; ++devid) {
 		set_dev_entry_bit(devid, DEV_ENTRY_VALID);


