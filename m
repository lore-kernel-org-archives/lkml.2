Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151Ab1ABH22 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:28:28 -0500
Received: from mail.windriver.com ([147.11.1.11]:37201 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755026Ab1ABHZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:25:58 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Alon Ziv <alon+git@nolaviz.org>,
        Alon Ziv <alon-git@nolaviz.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 253/260] USB: opticon: Fix long-standing bugs in opticon driver
Date: Sun,  2 Jan 2011 02:19:09 -0500
Message-Id: <1293952756-15010-254-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:24:46.0386 (UTC) FILETIME=[21F1D920:01CBAA4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alon Ziv <alon+git@nolaviz.org>

commit 97cd8dc4ca9a1a5efb2cc38758e01492e3b013e2 upstream.

The bulk-read callback had two bugs:
a) The bulk-in packet's leading two zeros were returned (and the two last
   bytes truncated)
b) The wrong URB was transmitted for the second (and later) read requests,
   causing further reads to return the entire packet (including leading
   zeros)

Signed-off-by: Alon Ziv <alon-git@nolaviz.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/serial/opticon.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/serial/opticon.c b/drivers/usb/serial/opticon.c
index ed01f3b..9ff19c8 100644
--- a/drivers/usb/serial/opticon.c
+++ b/drivers/usb/serial/opticon.c
@@ -96,8 +96,8 @@ static void opticon_bulk_callback(struct urb *urb)
 			/* real data, send it to the tty layer */
 			tty = tty_port_tty_get(&port->port);
 			if (tty) {
-				tty_insert_flip_string(tty, data,
-							       data_length);
+				tty_insert_flip_string(tty, data + 2,
+						       data_length);
 				tty_flip_buffer_push(tty);
 				tty_kref_put(tty);
 			}
@@ -130,7 +130,7 @@ exit:
 						  priv->bulk_address),
 				  priv->bulk_in_buffer, priv->buffer_size,
 				  opticon_bulk_callback, priv);
-		result = usb_submit_urb(port->read_urb, GFP_ATOMIC);
+		result = usb_submit_urb(priv->bulk_read_urb, GFP_ATOMIC);
 		if (result)
 			dev_err(&port->dev,
 			    "%s - failed resubmitting read urb, error %d\n",
-- 
1.7.3.3

