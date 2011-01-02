Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970Ab1ABHZw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:25:52 -0500
Received: from mail.windriver.com ([147.11.1.11]:37161 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873Ab1ABHZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:25:49 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Sergei Shtylyov <sshtylyov@ru.mvista.com>,
        Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 247/260] usb: musb: blackfin: call gpio_free() on error path in musb_platform_init()
Date: Sun,  2 Jan 2011 02:19:03 -0500
Message-Id: <1293952756-15010-248-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:24:39.0855 (UTC) FILETIME=[1E0D4BF0:01CBAA4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

commit 00be545e49d83485d49a598d3b7e090088934be8 upstream.

Blackfin's musb_platform_init() needs to call gpio_free() for error cleanup iff
otg_get_transceiver() call returns NULL.

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Acked-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/musb/blackfin.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/musb/blackfin.c b/drivers/usb/musb/blackfin.c
index ec8d324..6a9e891 100644
--- a/drivers/usb/musb/blackfin.c
+++ b/drivers/usb/musb/blackfin.c
@@ -289,8 +289,10 @@ int __init musb_platform_init(struct musb *musb)
 
 	usb_nop_xceiv_register();
 	musb->xceiv = otg_get_transceiver();
-	if (!musb->xceiv)
+	if (!musb->xceiv) {
+		gpio_free(musb->config->gpio_vrsel);
 		return -ENODEV;
+	}
 
 	if (ANOMALY_05000346) {
 		bfin_write_USB_APHY_CALIB(ANOMALY_05000346_value);
-- 
1.7.3.3

