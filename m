Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533Ab2HOTuH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:50:07 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62834 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756506Ab2HOTuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:50:00 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: =?UTF-8?q?Micha=C5=82=20Sroczy=C5=84ski?= <msroczyn@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 046/165] USB: PL2303: correctly handle baudrates above 115200
Date: Wed, 15 Aug 2012 15:46:30 -0400
Message-ID: <1345060109-9187-47-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michał Sroczyński <msroczyn@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 8d48fdf689fed2c73c493e5146d1463689246442 upstream.

PL2303: correctly handle baudrates above 115200

Signed-off-by: Michal Sroczynski <msroczyn@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/serial/pl2303.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 4b357d6..9f49375 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -616,10 +616,28 @@ static void pl2303_set_termios(struct tty_struct *tty,
 				baud = 6000000;
 		}
 		dbg("%s - baud set = %d", __func__, baud);
-		buf[0] = baud & 0xff;
-		buf[1] = (baud >> 8) & 0xff;
-		buf[2] = (baud >> 16) & 0xff;
-		buf[3] = (baud >> 24) & 0xff;
+		if (baud <= 115200) {
+			buf[0] = baud & 0xff;
+			buf[1] = (baud >> 8) & 0xff;
+			buf[2] = (baud >> 16) & 0xff;
+			buf[3] = (baud >> 24) & 0xff;
+		} else {
+			/* apparently the formula for higher speeds is:
+			 * baudrate = 12M * 32 / (2^buf[1]) / buf[0]
+			 */
+			unsigned tmp = 12*1000*1000*32 / baud;
+			buf[3] = 0x80;
+			buf[2] = 0;
+			buf[1] = (tmp >= 256);
+			while (tmp >= 256) {
+				tmp >>= 2;
+				buf[1] <<= 1;
+			}
+			if (tmp > 256) {
+				tmp %= 256;
+			}
+			buf[0] = tmp;
+		}
 	}
 
 	/* For reference buf[4]=0 is 1 stop bits */
-- 
1.7.12.rc2

