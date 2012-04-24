Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264Ab2DXWqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:46:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49279 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932744Ab2DXWhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:37:35 -0400
Message-Id: <20120424223254.331759146@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:33:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Oliver Neukum <oneukum@suse.de>
Subject: [ 10/42] uwb: fix use of del_timer_sync() in interrupt
In-Reply-To: <20120424223311.GA8456@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oliver@neukum.org>

commit 9426cd05682745d1024dbabdec5631309bd2f480 upstream.

del_timer_sync() cannot be used in interrupt.
Replace it with del_timer() and a flag

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/uwb/neh.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/uwb/neh.c
+++ b/drivers/uwb/neh.c
@@ -106,6 +106,7 @@ struct uwb_rc_neh {
 	u8 evt_type;
 	__le16 evt;
 	u8 context;
+	u8 completed;
 	uwb_rc_cmd_cb_f cb;
 	void *arg;
 
@@ -408,6 +409,7 @@ static void uwb_rc_neh_grok_event(struct
 	struct device *dev = &rc->uwb_dev.dev;
 	struct uwb_rc_neh *neh;
 	struct uwb_rceb *notif;
+	unsigned long flags;
 
 	if (rceb->bEventContext == 0) {
 		notif = kmalloc(size, GFP_ATOMIC);
@@ -421,7 +423,11 @@ static void uwb_rc_neh_grok_event(struct
 	} else {
 		neh = uwb_rc_neh_lookup(rc, rceb);
 		if (neh) {
-			del_timer_sync(&neh->timer);
+			spin_lock_irqsave(&rc->neh_lock, flags);
+			/* to guard against a timeout */
+			neh->completed = 1;
+			del_timer(&neh->timer);
+			spin_unlock_irqrestore(&rc->neh_lock, flags);
 			uwb_rc_neh_cb(neh, rceb, size);
 		} else
 			dev_warn(dev, "event 0x%02x/%04x/%02x (%zu bytes): nobody cared\n",
@@ -567,6 +573,10 @@ static void uwb_rc_neh_timer(unsigned lo
 	unsigned long flags;
 
 	spin_lock_irqsave(&rc->neh_lock, flags);
+	if (neh->completed) {
+		spin_unlock_irqrestore(&rc->neh_lock, flags);
+		return;
+	}
 	if (neh->context)
 		__uwb_rc_neh_rm(rc, neh);
 	else


