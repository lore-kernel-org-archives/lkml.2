Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933631Ab0EYSSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 14:18:41 -0400
Received: from kroah.org ([198.145.64.141]:44419 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933489Ab0EYSRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 14:17:38 -0400
X-Mailbox-Line: From gregkh@clark.site Tue May 25 11:12:14 2010
Message-Id: <20100525181214.231161745@clark.site>
User-Agent: quilt/0.48-8.10
Date: Tue, 25 May 2010 11:09:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jean Delvare <khali@linux-fr.org>
Subject: [22/25] hwmon: (w83781d) Request I/O ports individually for probing
In-Reply-To: <20100525181259.GA18630@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jean Delvare <khali@linux-fr.org>

commit b0bcdd3cd0adb85a7686b396ba50493871b1135c upstream.

Different motherboards have different PNP declarations for
W83781D/W83782D chips. Some declare the whole range of I/O ports (8
ports), some declare only the useful ports (2 ports at offset 5) and
some declare fancy ranges, for example 4 ports at offset 4. To
properly handle all cases, request all ports individually for probing.
After we have determined that we really have a W83781D or W83782D
chip, the useful port range will be requested again, as a single
block.

I did not see a board which needs this yet, but I know of one for lm78
driver and I'd like to keep the logic of these two drivers in sync.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/w83781d.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/drivers/hwmon/w83781d.c
+++ b/drivers/hwmon/w83781d.c
@@ -1797,17 +1797,17 @@ static int __init
 w83781d_isa_found(unsigned short address)
 {
 	int val, save, found = 0;
+	int port;
 
-	/* We have to request the region in two parts because some
-	   boards declare base+4 to base+7 as a PNP device */
-	if (!request_region(address, 4, "w83781d")) {
-		pr_debug("w83781d: Failed to request low part of region\n");
-		return 0;
-	}
-	if (!request_region(address + 4, 4, "w83781d")) {
-		pr_debug("w83781d: Failed to request high part of region\n");
-		release_region(address, 4);
-		return 0;
+	/* Some boards declare base+0 to base+7 as a PNP device, some base+4
+	 * to base+7 and some base+5 to base+6. So we better request each port
+	 * individually for the probing phase. */
+	for (port = address; port < address + W83781D_EXTENT; port++) {
+		if (!request_region(port, 1, "w83781d")) {
+			pr_debug("w83781d: Failed to request port 0x%x\n",
+				 port);
+			goto release;
+		}
 	}
 
 #define REALLY_SLOW_IO
@@ -1881,8 +1881,8 @@ w83781d_isa_found(unsigned short address
 			val == 0x30 ? "W83782D" : "W83781D", (int)address);
 
  release:
-	release_region(address + 4, 4);
-	release_region(address, 4);
+	for (port--; port >= address; port--)
+		release_region(port, 1);
 	return found;
 }
 


