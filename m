Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965342Ab2EOCkj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:40:39 -0400
Received: from mail.windriver.com ([147.11.1.11]:49780 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964822Ab2EOCRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:44 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 128/179] ses: requesting a fault indication
Date: Mon, 14 May 2012 22:13:44 -0400
Message-ID: <1337048075-6132-129-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Douglas Gilbert <dgilbert@interlog.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 2a350cab9daf9a46322d83b091bb05cf54ccf6ab upstream.

Noticed that when the sysfs interface of the SCSI SES
driver was used to request a fault indication the LED
flashed but the buzzer didn't sound. So it was doing
what REQUEST IDENT (locate) should do.

Changelog:
   - fix the setting of REQUEST FAULT for the device slot
     and array device slot elements in the enclosure control
     diagnostic page
   - note the potentially defective code that reads the
     FAULT SENSED and FAULT REQUESTED bits from the enclosure
     status diagnostic page

The attached patch is against git/scsi-misc-2.6

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/scsi/ses.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 3b00e90..fedb4f9 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -158,6 +158,10 @@ static unsigned char *ses_get_page2_descriptor(struct enclosure_device *edev,
 	return NULL;
 }
 
+/* For device slot and array device slot elements, byte 3 bit 6
+ * is "fault sensed" while byte 3 bit 5 is "fault reqstd". As this
+ * code stands these bits are shifted 4 positions right so in
+ * sysfs they will appear as bits 2 and 1 respectively. Strange. */
 static void ses_get_fault(struct enclosure_device *edev,
 			  struct enclosure_component *ecomp)
 {
@@ -179,7 +183,7 @@ static int ses_set_fault(struct enclosure_device *edev,
 		/* zero is disabled */
 		break;
 	case ENCLOSURE_SETTING_ENABLED:
-		desc[2] = 0x02;
+		desc[3] = 0x20;
 		break;
 	default:
 		/* SES doesn't do the SGPIO blink settings */
-- 
1.7.9.6

