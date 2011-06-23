Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934064Ab1FWRvP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:51:15 -0400
Received: from mail.windriver.com ([147.11.1.11]:35415 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933649Ab1FWRiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:38:16 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 211/247] USB: cdc-acm: fix potential null-pointer dereference on disconnect
Date: Thu, 23 Jun 2011 13:34:39 -0400
Message-Id: <1308850515-15242-152-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hovold <jhovold@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 7e7797e7f6f7bfab73fca02c65e40eaa5bb9000c upstream.

Fix potential null-pointer exception on disconnect introduced by commit
11ea859d64b69a747d6b060b9ed1520eab1161fe (USB: additional power savings
for cdc-acm devices that support remote wakeup).

Only access acm->dev after making sure it is non-null in control urb
completion handler.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/class/cdc-acm.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index a45e6c4..073a9ef 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -297,6 +297,8 @@ static void acm_ctrl_irq(struct urb *urb)
 	if (!ACM_READY(acm))
 		goto exit;
 
+	usb_mark_last_busy(acm->dev);
+
 	data = (unsigned char *)(dr + 1);
 	switch (dr->bNotificationType) {
 	case USB_CDC_NOTIFY_NETWORK_CONNECTION:
@@ -336,7 +338,6 @@ static void acm_ctrl_irq(struct urb *urb)
 		break;
 	}
 exit:
-	usb_mark_last_busy(acm->dev);
 	retval = usb_submit_urb(urb, GFP_ATOMIC);
 	if (retval)
 		dev_err(&urb->dev->dev, "%s - usb_submit_urb failed with "
-- 
1.7.4.4

