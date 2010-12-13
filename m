Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687Ab0LMNRJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 08:17:09 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41478 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757574Ab0LMNRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 08:17:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=fXlHOfMGv3O/XGH4FqXTVH2tey0g8tzwFRL/7Te+4Rfz8e5mayA4r9REtyTrJiVWuw
         5OlMJyePoSkOSWce0kAhzp7efwTBSuxzF8lbLVFzvpYSjCAfxlzbebBFU2v6pbhZ/av9
         j+tHYjIpfOELZBJnkTArdWk8ZO4fI9VZWsQS4=
From: Namhyung Kim <namhyung@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Martyn Welch <martyn.welch@ge.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] Staging: vme_ca91cx42: fix compiler warning on 64-bit build
Date: Mon, 13 Dec 2010 22:16:29 +0900
Message-Id: <1292246196-2332-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.3.3.400.g93cef
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The gcc complains about the cast pointer to int on 64-bit as follows.
Use unsigned long instead and wrap it up in new macro.

  CC [M]  drivers/staging/vme/bridges/vme_ca91cx42.o
drivers/staging/vme/bridges/vme_ca91cx42.c: In function ‘ca91cx42_master_read’:
drivers/staging/vme/bridges/vme_ca91cx42.c:870: warning: cast from pointer to integer of different size
drivers/staging/vme/bridges/vme_ca91cx42.c:876: warning: cast from pointer to integer of different size
drivers/staging/vme/bridges/vme_ca91cx42.c: In function ‘ca91cx42_master_write’:
drivers/staging/vme/bridges/vme_ca91cx42.c:924: warning: cast from pointer to integer of different size
drivers/staging/vme/bridges/vme_ca91cx42.c:930: warning: cast from pointer to integer of different size
drivers/staging/vme/bridges/vme_ca91cx42.c: In function ‘ca91cx42_master_rmw’:
drivers/staging/vme/bridges/vme_ca91cx42.c:983: warning: cast from pointer to integer of different size

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
I'm not sure about the name. Suggestions?

 drivers/staging/vme/bridges/vme_ca91cx42.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vme/bridges/vme_ca91cx42.c b/drivers/staging/vme/bridges/vme_ca91cx42.c
index d1df7d12f504..cb72a5d1eeca 100644
--- a/drivers/staging/vme/bridges/vme_ca91cx42.c
+++ b/drivers/staging/vme/bridges/vme_ca91cx42.c
@@ -845,6 +845,8 @@ int ca91cx42_master_get(struct vme_master_resource *image, int *enabled,
 	return retval;
 }
 
+#define check_aligned(addr, align)	((unsigned long)addr & align)
+
 ssize_t ca91cx42_master_read(struct vme_master_resource *image, void *buf,
 	size_t count, loff_t offset)
 {
@@ -867,13 +869,13 @@ ssize_t ca91cx42_master_read(struct vme_master_resource *image, void *buf,
 	 * maximal configured data cycle is used and splits it
 	 * automatically for non-aligned addresses.
 	 */
-	if ((int)addr & 0x1) {
+	if (check_aligned(addr, 0x1)) {
 		*(u8 *)buf = ioread8(addr);
 		done += 1;
 		if (done == count)
 			goto out;
 	}
-	if ((int)addr & 0x2) {
+	if (check_aligned(addr, 0x2)) {
 		if ((count - done) < 2) {
 			*(u8 *)(buf + done) = ioread8(addr + done);
 			done += 1;
@@ -921,13 +923,13 @@ ssize_t ca91cx42_master_write(struct vme_master_resource *image, void *buf,
 	/* Here we apply for the same strategy we do in master_read
 	 * function in order to assure D16 cycle when required.
 	 */
-	if ((int)addr & 0x1) {
+	if (check_aligned(addr, 0x1)) {
 		iowrite8(*(u8 *)buf, addr);
 		done += 1;
 		if (done == count)
 			goto out;
 	}
-	if ((int)addr & 0x2) {
+	if (check_aligned(addr, 0x2)) {
 		if ((count - done) < 2) {
 			iowrite8(*(u8 *)(buf + done), addr + done);
 			done += 1;
@@ -980,7 +982,7 @@ unsigned int ca91cx42_master_rmw(struct vme_master_resource *image,
 	/* Lock image */
 	spin_lock(&(image->lock));
 
-	pci_addr = (u32)image->kern_base + offset;
+	pci_addr = (u32)(unsigned long)image->kern_base + offset;
 
 	/* Address must be 4-byte aligned */
 	if (pci_addr & 0x3) {
-- 
1.7.3.3.400.g93cef

