Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934447Ab2AJXIq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 18:08:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52744 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934376Ab2AJXD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 18:03:29 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan 10 13:56:02 2012
Message-Id: <20120110215602.382071205@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 10 Jan 2012 13:55:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Pontus Fuchs <pontus.fuchs@gmail.com>,
        Luciano Coelho <coelho@ti.com>
Subject: [10/49] wl12xx: Check buffer bound when processing nvs data
In-Reply-To: <20120110215609.GA22505@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pontus Fuchs <pontus.fuchs@gmail.com>

commit f6efe96edd9c41c624c8f4ddbc4930c1a2d8f1e1 upstream.

An nvs with malformed contents could cause the processing of the
calibration data to read beyond the end of the buffer. Prevent this
from happening by adding bound checking.

Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
Reviewed-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/wl12xx/boot.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/net/wireless/wl12xx/boot.c
+++ b/drivers/net/wireless/wl12xx/boot.c
@@ -347,6 +347,9 @@ static int wl1271_boot_upload_nvs(struct
 		nvs_ptr += 3;
 
 		for (i = 0; i < burst_len; i++) {
+			if (nvs_ptr + 3 >= (u8 *) wl->nvs + nvs_len)
+				goto out_badnvs;
+
 			val = (nvs_ptr[0] | (nvs_ptr[1] << 8)
 			       | (nvs_ptr[2] << 16) | (nvs_ptr[3] << 24));
 
@@ -358,6 +361,9 @@ static int wl1271_boot_upload_nvs(struct
 			nvs_ptr += 4;
 			dest_addr += 4;
 		}
+
+		if (nvs_ptr >= (u8 *) wl->nvs + nvs_len)
+			goto out_badnvs;
 	}
 
 	/*
@@ -369,6 +375,10 @@ static int wl1271_boot_upload_nvs(struct
 	 */
 	nvs_ptr = (u8 *)wl->nvs +
 			ALIGN(nvs_ptr - (u8 *)wl->nvs + 7, 4);
+
+	if (nvs_ptr >= (u8 *) wl->nvs + nvs_len)
+		goto out_badnvs;
+
 	nvs_len -= nvs_ptr - (u8 *)wl->nvs;
 
 	/* Now we must set the partition correctly */
@@ -384,6 +394,10 @@ static int wl1271_boot_upload_nvs(struct
 
 	kfree(nvs_aligned);
 	return 0;
+
+out_badnvs:
+	wl1271_error("nvs data is malformed");
+	return -EILSEQ;
 }
 
 static void wl1271_boot_enable_interrupts(struct wl1271 *wl)


