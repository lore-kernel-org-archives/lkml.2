Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab1ABIEd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 03:04:33 -0500
Received: from mail.windriver.com ([147.11.1.11]:34667 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab1ABHWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:22:19 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Toby Gray <toby.gray@realvnc.com>,
        Oliver Neukum <oliver@neukum.name>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 055/260] USB: cdc-acm: Fixing crash when ACM probing interfaces with no endpoint descriptors.
Date: Sun,  2 Jan 2011 02:15:51 -0500
Message-Id: <1293952756-15010-56-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:21:06.0210 (UTC) FILETIME=[9EB5A820:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Toby Gray <toby.gray@realvnc.com>

commit 577045c0a76e34294f902a7d5d60e90b04d094d0 upstream.

Certain USB devices, such as the Nokia X6 mobile phone, don't expose any
endpoint descriptors on some of their interfaces. If the ACM driver is forced
to probe all interfaces on a device the a NULL pointer dereference will occur
when the ACM driver attempts to use the endpoint of the alternative settings.
One way to get the ACM driver to probe all the interfaces is by using the
/sys/bus/usb/drivers/cdc_acm/new_id interface.

This patch checks that the endpoint pointer for the current alternate settings
is non-NULL before using it.

Signed-off-by: Toby Gray <toby.gray@realvnc.com>
Cc: Oliver Neukum <oliver@neukum.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/class/cdc-acm.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index ffbf1aa..f1accc8 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -971,7 +971,8 @@ static int acm_probe(struct usb_interface *intf,
 	}
 
 	if (!buflen) {
-		if (intf->cur_altsetting->endpoint->extralen &&
+		if (intf->cur_altsetting->endpoint &&
+				intf->cur_altsetting->endpoint->extralen &&
 				intf->cur_altsetting->endpoint->extra) {
 			dev_dbg(&intf->dev,
 				"Seeking extra descriptors on endpoint\n");
-- 
1.7.3.3

