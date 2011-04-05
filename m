Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab1DEPeX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:34:23 -0400
Received: from smtp.nokia.com ([147.243.128.26]:47538 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754651Ab1DEPeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 11:34:14 -0400
From: Roger Quadros <roger.quadros@nokia.com>
To: gregkh@suse.de
Cc: mina86@mina86.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] usb: gadget: f_mass_storage: Fix Bulk-only RESET handling
Date: Tue,  5 Apr 2011 18:36:38 +0300
Message-Id: <1302017802-16614-2-git-send-email-roger.quadros@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1302017802-16614-1-git-send-email-roger.quadros@nokia.com>
References: <1302017802-16614-1-git-send-email-roger.quadros@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ep0 request tag was not recorded thus resulting in phase
problems while sending status/response in handle_execption() handler.
This was resulting in MSC compliance test failures with USBCV tool.

With this patch, the Bulk-Only Mass storage RESET request is
handled correctly and the MSC compliance tests pass.

Signed-off-by: Roger Quadros <roger.quadros@nokia.com>
---
 drivers/usb/gadget/f_mass_storage.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index ef6c65a..90472af 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -613,6 +613,11 @@ static int fsg_setup(struct usb_function *f,
 	if (!fsg_is_set(fsg->common))
 		return -EOPNOTSUPP;
 
+	++fsg->common->ep0_req_tag;	/* Record arrival of a new request */
+	req->context = NULL;
+	req->length = 0;
+	dump_msg(fsg, "ep0-setup", (u8 *) ctrl, sizeof(*ctrl));
+
 	switch (ctrl->bRequest) {
 
 	case USB_BULK_RESET_REQUEST:
-- 
1.6.0.4

