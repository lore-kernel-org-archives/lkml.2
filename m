Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699Ab2FRMht (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 08:37:49 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49571 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab2FRMhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 08:37:42 -0400
From: Michal Nazarewicz <mpn@google.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] usb: gadget: mass_storage: require backing file for non-removable LUNs
Date: Mon, 18 Jun 2012 14:37:21 +0200
Message-Id: <593bff689c31fefb07534e3f500d8a8c29fcdacb.1340022674.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <cover.1340022674.git.mina86@mina86.com>
References: <cover.1340022674.git.mina86@mina86.com>
In-Reply-To: <cover.1340022674.git.mina86@mina86.com>
References: <cover.1340022674.git.mina86@mina86.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

The fsg_file_store() function does not check whether a LUN is removable or not
allowing one to specify an empty file name for a non-removable LUN.  This
commit adds explicit check of whether a file name is provided for
non-removable LUNs.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/usb/gadget/storage_common.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/gadget/storage_common.c b/drivers/usb/gadget/storage_common.c
index e576678..52334d7 100644
--- a/drivers/usb/gadget/storage_common.c
+++ b/drivers/usb/gadget/storage_common.c
@@ -878,6 +878,9 @@ static ssize_t fsg_store_file(struct device *dev, struct device_attribute *attr,
 	if (count > 0 && buf[count-1] == '\n')
 		((char *) buf)[count-1] = 0;		/* Ugh! */
 
+	/* Must specify a valid file if LUN is not removable. */
+	if (!curlun->removable && !*buf)
+		return -EINVAL;
 
 	/* Load new medium */
 	down_write(filesem);
-- 
1.7.7.3

