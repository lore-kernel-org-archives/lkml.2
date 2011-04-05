Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391Ab1DEPe1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:34:27 -0400
Received: from smtp.nokia.com ([147.243.128.26]:47580 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755331Ab1DEPeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 11:34:20 -0400
From: Roger Quadros <roger.quadros@nokia.com>
To: gregkh@suse.de
Cc: mina86@mina86.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] usb: gadget: f_mass_storage: Fix potential memory leak
Date: Tue,  5 Apr 2011 18:36:41 +0300
Message-Id: <1302017802-16614-5-git-send-email-roger.quadros@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1302017802-16614-1-git-send-email-roger.quadros@nokia.com>
References: <1302017802-16614-1-git-send-email-roger.quadros@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If allocation of multiple buffers would fail then we would leak memory.
Fix that.

Signed-off-by: Roger Quadros <roger.quadros@nokia.com>
---
 drivers/usb/gadget/f_mass_storage.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index f6bd001..60b4df9 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -2863,6 +2863,12 @@ buffhds_first_it:
 		bh->buf = kmalloc(FSG_BUFLEN, GFP_KERNEL);
 		if (unlikely(!bh->buf)) {
 			rc = -ENOMEM;
+			/* clean up */
+			while (i < FSG_NUM_BUFFERS) {
+				bh--;
+				kfree(bh->buf);
+				i++;
+			}
 			goto error_release;
 		}
 	} while (--i);
-- 
1.6.0.4

