Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933203Ab2BJWuI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:50:08 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53942 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933021Ab2BJWuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:50:03 -0500
MIME-Version: 1.0
Message-Id: <20120210224851.969824726@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:47:52 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jakub Schmidtke <sjakub@gmail.com>,
        "Kevin A. Granade" <kevin.granade@gmail.com>,
        Pekka Paalanen <pq@iki.fi>
Subject: [13/21] Staging: asus_oled: fix image processing
In-Reply-To: <20120210224858.GA30752@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Pekka Paalanen <pq@iki.fi>

commit 635032cb397b396241372fa0ff36ae758e658b23 upstream.

Programming an image was broken, because odev->buf_offs was not advanced
for val == 0 in append_values(). This regression was introduced in:

 commit 1ff12a4aa354bed093a0240d5e6347b1e27601bc
 Author: Kevin A. Granade <kevin.granade@gmail.com>
 Date:   Sat Sep 5 01:03:39 2009 -0500

     Staging: asus_oled: Cleaned up checkpatch issues.

Fix the image processing by special-casing val == 0.

I have tested this change on an Asus G50V laptop only.

Cc: Jakub Schmidtke <sjakub@gmail.com>
Cc: Kevin A. Granade <kevin.granade@gmail.com>
Signed-off-by: Pekka Paalanen <pq@iki.fi>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/asus_oled/asus_oled.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/staging/asus_oled/asus_oled.c
+++ b/drivers/staging/asus_oled/asus_oled.c
@@ -349,7 +349,14 @@ static void send_data(struct asus_oled_d
 
 static int append_values(struct asus_oled_dev *odev, uint8_t val, size_t count)
 {
-	while (count-- > 0 && val) {
+	odev->last_val = val;
+
+	if (val == 0) {
+		odev->buf_offs += count;
+		return 0;
+	}
+
+	while (count-- > 0) {
 		size_t x = odev->buf_offs % odev->width;
 		size_t y = odev->buf_offs / odev->width;
 		size_t i;
@@ -400,7 +407,6 @@ static int append_values(struct asus_ole
 			;
 		}
 
-		odev->last_val = val;
 		odev->buf_offs++;
 	}
 


