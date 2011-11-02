Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933263Ab1KBPy4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 11:54:56 -0400
Received: from cernmx30.cern.ch ([137.138.144.177]:8840 "EHLO CERNMX30.cern.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932383Ab1KBPyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 11:54:55 -0400
From: Manohar Vanga <manohar.vanga@cern.ch>
To: <gregkh@suse.de>
CC: <martyn.welch@ge.com>, <cota@braap.org>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>, Manohar Vanga <manohar.vanga@cern.ch>
Subject: [PATCH 1/1] staging: vme: fix address cast warnings for 64 bit architectures
Date: Wed, 2 Nov 2011 16:50:39 +0100
Message-ID: <1320249039-21569-1-git-send-email-manohar.vanga@cern.ch>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Manohar Vanga <manohar.vanga@cern.ch>
---
 drivers/staging/vme/bridges/vme_ca91cx42.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/vme/bridges/vme_ca91cx42.c b/drivers/staging/vme/bridges/vme_ca91cx42.c
index 0e4feac..f563a00 100644
--- a/drivers/staging/vme/bridges/vme_ca91cx42.c
+++ b/drivers/staging/vme/bridges/vme_ca91cx42.c
@@ -876,13 +876,13 @@ static ssize_t ca91cx42_master_read(struct vme_master_resource *image,
 	 * maximal configured data cycle is used and splits it
 	 * automatically for non-aligned addresses.
 	 */
-	if ((int)addr & 0x1) {
+	if ((uintptr_t)addr & 0x1) {
 		*(u8 *)buf = ioread8(addr);
 		done += 1;
 		if (done == count)
 			goto out;
 	}
-	if ((int)addr & 0x2) {
+	if ((uintptr_t)addr & 0x2) {
 		if ((count - done) < 2) {
 			*(u8 *)(buf + done) = ioread8(addr + done);
 			done += 1;
@@ -930,13 +930,13 @@ static ssize_t ca91cx42_master_write(struct vme_master_resource *image,
 	/* Here we apply for the same strategy we do in master_read
 	 * function in order to assure D16 cycle when required.
 	 */
-	if ((int)addr & 0x1) {
+	if ((uintptr_t)addr & 0x1) {
 		iowrite8(*(u8 *)buf, addr);
 		done += 1;
 		if (done == count)
 			goto out;
 	}
-	if ((int)addr & 0x2) {
+	if ((uintptr_t)addr & 0x2) {
 		if ((count - done) < 2) {
 			iowrite8(*(u8 *)(buf + done), addr + done);
 			done += 1;
@@ -973,7 +973,8 @@ static unsigned int ca91cx42_master_rmw(struct vme_master_resource *image,
 	unsigned int mask, unsigned int compare, unsigned int swap,
 	loff_t offset)
 {
-	u32 pci_addr, result;
+	u32 result;
+	uintptr_t pci_addr;
 	int i;
 	struct ca91cx42_driver *bridge;
 	struct device *dev;
@@ -990,7 +991,7 @@ static unsigned int ca91cx42_master_rmw(struct vme_master_resource *image,
 	/* Lock image */
 	spin_lock(&image->lock);
 
-	pci_addr = (u32)image->kern_base + offset;
+	pci_addr = (uintptr_t)image->kern_base + offset;
 
 	/* Address must be 4-byte aligned */
 	if (pci_addr & 0x3) {
-- 
1.7.4.1

