Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934197Ab1ESSLb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:11:31 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:57775 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934107Ab1ESSJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:09:36 -0400
X-Sasl-enc: laRHtwRjl8uXKaxqM6jhwemCHf/g9p3NQWG8dq74vIVU 1305828575
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:06:00 2011
Message-Id: <20110519180600.800586087@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:05:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Luben Tuikov <ltuikov@yahoo.com>,
        James Bottomley <James.Bottomley@suse.de>
Subject: [68/71] [SCSI] Revert "[SCSI] Retrieve the Caching mode page"
In-Reply-To: <20110519180626.GA16555@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: James Bottomley <James.Bottomley@suse.de>

commit 3dea642afd9187728d119fce5c82a7ed9faa9b6a upstream.

This reverts commit 24d720b726c1a85f1962831ac30ad4d2ef8276b1.

Previously we thought there was little possibility that devices would
crash with this, but some have been found.

Reported-by: Alan Stern <stern@rowland.harvard.edu>
Cc: Luben Tuikov <ltuikov@yahoo.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/sd.c |   63 +++++++++++++-----------------------------------------
 1 file changed, 16 insertions(+), 47 deletions(-)

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1910,14 +1910,10 @@ sd_read_cache_type(struct scsi_disk *sdk
 	int old_rcd = sdkp->RCD;
 	int old_dpofua = sdkp->DPOFUA;
 
-	if (sdp->skip_ms_page_8) {
-		if (sdp->type == TYPE_RBC)
-			goto defaults;
-		else {
-			modepage = 0x3F;
-			dbd = 0;
-		}
-	} else if (sdp->type == TYPE_RBC) {
+	if (sdp->skip_ms_page_8)
+		goto defaults;
+
+	if (sdp->type == TYPE_RBC) {
 		modepage = 6;
 		dbd = 8;
 	} else {
@@ -1945,11 +1941,13 @@ sd_read_cache_type(struct scsi_disk *sdk
 	 */
 	if (len < 3)
 		goto bad_sense;
-	else if (len > SD_BUF_SIZE) {
-		sd_printk(KERN_NOTICE, sdkp, "Truncating mode parameter "
-			  "data from %d to %d bytes\n", len, SD_BUF_SIZE);
-		len = SD_BUF_SIZE;
-	}
+	if (len > 20)
+		len = 20;
+
+	/* Take headers and block descriptors into account */
+	len += data.header_length + data.block_descriptor_length;
+	if (len > SD_BUF_SIZE)
+		goto bad_sense;
 
 	/* Get the data */
 	res = sd_do_mode_sense(sdp, dbd, modepage, buffer, len, &data, &sshdr);
@@ -1957,45 +1955,16 @@ sd_read_cache_type(struct scsi_disk *sdk
 	if (scsi_status_is_good(res)) {
 		int offset = data.header_length + data.block_descriptor_length;
 
-		while (offset < len) {
-			u8 page_code = buffer[offset] & 0x3F;
-			u8 spf       = buffer[offset] & 0x40;
-
-			if (page_code == 8 || page_code == 6) {
-				/* We're interested only in the first 3 bytes.
-				 */
-				if (len - offset <= 2) {
-					sd_printk(KERN_ERR, sdkp, "Incomplete "
-						  "mode parameter data\n");
-					goto defaults;
-				} else {
-					modepage = page_code;
-					goto Page_found;
-				}
-			} else {
-				/* Go to the next page */
-				if (spf && len - offset > 3)
-					offset += 4 + (buffer[offset+2] << 8) +
-						buffer[offset+3];
-				else if (!spf && len - offset > 1)
-					offset += 2 + buffer[offset+1];
-				else {
-					sd_printk(KERN_ERR, sdkp, "Incomplete "
-						  "mode parameter data\n");
-					goto defaults;
-				}
-			}
+		if (offset >= SD_BUF_SIZE - 2) {
+			sd_printk(KERN_ERR, sdkp, "Malformed MODE SENSE response\n");
+			goto defaults;
 		}
 
-		if (modepage == 0x3F) {
-			sd_printk(KERN_ERR, sdkp, "No Caching mode page "
-				  "present\n");
-			goto defaults;
-		} else if ((buffer[offset] & 0x3f) != modepage) {
+		if ((buffer[offset] & 0x3f) != modepage) {
 			sd_printk(KERN_ERR, sdkp, "Got wrong page\n");
 			goto defaults;
 		}
-	Page_found:
+
 		if (modepage == 8) {
 			sdkp->WCE = ((buffer[offset + 2] & 0x04) != 0);
 			sdkp->RCD = ((buffer[offset + 2] & 0x01) != 0);


