Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471Ab2E0BEk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:04:40 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37624 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755735Ab2E0BAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:00:06 -0400
Message-Id: <20120527002618.869742917@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 09:26:46 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        Scott Teel <scott.teel@hp.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Jonathan Nieder <jrnieder@gmail.com>
Subject: [ 33/55] SCSI: hpsa: Fix problem with MSA2xxx devices
In-Reply-To: <20120527005203.GA2146@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>

commit 9bc3711cbb67ac620bf09b4a147cbab45b2c36c0 upstream.

Upgraded firmware on Smart Array P7xx (and some others) made them show up as
SCSI revision 5 devices and this caused the driver to fail to map MSA2xxx
logical drives to the correct bus/target/lun.  A symptom of this would be that
the target ID of the logical drives as presented by the external storage array
is ignored, and all such logical drives are assigned to target zero,
differentiated only by LUN.  Some multipath software reportedly does not deal
well with this behavior, failing to recognize different paths to the same
device as such.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Signed-off-by: Scott Teel <scott.teel@hp.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Cc: Jonathan Nieder <jrnieder@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/hpsa.c |   34 +++++++++++++++-------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1654,30 +1654,26 @@ static void figure_bus_target_lun(struct
 
 	if (is_logical_dev_addr_mode(lunaddrbytes)) {
 		/* logical device */
-		if (unlikely(is_scsi_rev_5(h))) {
-			/* p1210m, logical drives lun assignments
-			 * match SCSI REPORT LUNS data.
+		lunid = le32_to_cpu(*((__le32 *) lunaddrbytes));
+		if (is_msa2xxx(h, device)) {
+			/* msa2xxx way, put logicals on bus 1
+			 * and match target/lun numbers box
+			 * reports.
 			 */
-			lunid = le32_to_cpu(*((__le32 *) lunaddrbytes));
-			*bus = 0;
-			*target = 0;
-			*lun = (lunid & 0x3fff) + 1;
+			*bus = 1;
+			*target = (lunid >> 16) & 0x3fff;
+			*lun = lunid & 0x00ff;
 		} else {
-			/* not p1210m... */
-			lunid = le32_to_cpu(*((__le32 *) lunaddrbytes));
-			if (is_msa2xxx(h, device)) {
-				/* msa2xxx way, put logicals on bus 1
-				 * and match target/lun numbers box
-				 * reports.
-				 */
-				*bus = 1;
-				*target = (lunid >> 16) & 0x3fff;
-				*lun = lunid & 0x00ff;
+			if (likely(is_scsi_rev_5(h))) {
+				/* All current smart arrays (circa 2011) */
+				*bus = 0;
+				*target = 0;
+				*lun = (lunid & 0x3fff) + 1;
 			} else {
-				/* Traditional smart array way. */
+				/* Traditional old smart array way. */
 				*bus = 0;
-				*lun = 0;
 				*target = lunid & 0x3fff;
+				*lun = 0;
 			}
 		}
 	} else {


