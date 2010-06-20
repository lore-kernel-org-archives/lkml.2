Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198Ab0FTUv5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 16:51:57 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51903 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757102Ab0FTUvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 16:51:55 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 20 Jun 2010 22:51:05 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2/8] firewire: cdev: fix race in iso context creation
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.ba0692c55cd50593@s5r6.in-berlin.de>
Message-ID: <tkrat.9e7edf6dc0ca32ad@s5r6.in-berlin.de>
References: <tkrat.ba0692c55cd50593@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Date: Mon, 14 Jun 2010 11:46:25 +0200
From: Clemens Ladisch <clemens@ladisch.de>

Protect the client's iso context pointer against a race that can happen
when more than one creation call is executed at the same time.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-cdev.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

Index: b/drivers/firewire/core-cdev.c
===================================================================
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -865,10 +865,6 @@ static int ioctl_create_iso_context(stru
 	struct fw_cdev_create_iso_context *a = &arg->create_iso_context;
 	struct fw_iso_context *context;
 
-	/* We only support one context at this time. */
-	if (client->iso_context != NULL)
-		return -EBUSY;
-
 	if (a->channel > 63)
 		return -EINVAL;
 
@@ -893,10 +889,17 @@ static int ioctl_create_iso_context(stru
 	if (IS_ERR(context))
 		return PTR_ERR(context);
 
+	/* We only support one context at this time. */
+	spin_lock_irq(&client->lock);
+	if (client->iso_context != NULL) {
+		spin_unlock_irq(&client->lock);
+		fw_iso_context_destroy(context);
+		return -EBUSY;
+	}
 	client->iso_closure = a->closure;
 	client->iso_context = context;
+	spin_unlock_irq(&client->lock);
 
-	/* We only support one context at this time. */
 	a->handle = 0;
 
 	return 0;

-- 
Stefan Richter
-=====-==-=- -==- =-=--
http://arcgraph.de/sr/

