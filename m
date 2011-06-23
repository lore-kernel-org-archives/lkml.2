Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932667Ab1FWSbE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:31:04 -0400
Received: from mail.windriver.com ([147.11.1.11]:62985 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759902Ab1FWRWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:22:13 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 024/247] USB: prevent buggy hubs from crashing the USB stack
Date: Thu, 23 Jun 2011 13:17:47 -0400
Message-Id: <1308849690-14530-25-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit d199c96d41d80a567493e12b8e96ea056a1350c1 upstream.

If anyone comes across a high-speed hub that (by mistake or by design)
claims to have no Transaction Translators, plugging a full- or
low-speed device into it will cause the USB stack to crash.  This
patch (as1446) prevents the problem by ignoring such devices, since
the kernel has no way to communicate with them.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Perry Neben <neben@vmware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/core/hub.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 5b63c45..f4e54ba 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2710,6 +2710,11 @@ hub_port_init (struct usb_hub *hub, struct usb_device *udev, int port1,
 		udev->ttport = hdev->ttport;
 	} else if (udev->speed != USB_SPEED_HIGH
 			&& hdev->speed == USB_SPEED_HIGH) {
+		if (!hub->tt.hub) {
+			dev_err(&udev->dev, "parent hub has no TT\n");
+			retval = -EINVAL;
+			goto fail;
+		}
 		udev->tt = &hub->tt;
 		udev->ttport = port1;
 	}
-- 
1.7.4.4

