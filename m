Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296Ab2EIGeq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:34:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38651 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754796Ab2EIFwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:52:39 -0400
Message-Id: <20120509055031.522297581@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:50:43 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Oliver Neukum <oliver@neukum.org>,
        Oliver Neukum <oneukum@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 014/167] [PATCH] uwb: fix use of del_timer_sync() in interrupt
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oliver@neukum.org>

commit 9426cd05682745d1024dbabdec5631309bd2f480 upstream.

del_timer_sync() cannot be used in interrupt.
Replace it with del_timer() and a flag

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/uwb/neh.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/uwb/neh.c b/drivers/uwb/neh.c
index a269937..8cb71bb 100644
--- a/drivers/uwb/neh.c
+++ b/drivers/uwb/neh.c
@@ -107,6 +107,7 @@ struct uwb_rc_neh {
 	u8 evt_type;
 	__le16 evt;
 	u8 context;
+	u8 completed;
 	uwb_rc_cmd_cb_f cb;
 	void *arg;
 
@@ -409,6 +410,7 @@ static void uwb_rc_neh_grok_event(struct uwb_rc *rc, struct uwb_rceb *rceb, size
 	struct device *dev = &rc->uwb_dev.dev;
 	struct uwb_rc_neh *neh;
 	struct uwb_rceb *notif;
+	unsigned long flags;
 
 	if (rceb->bEventContext == 0) {
 		notif = kmalloc(size, GFP_ATOMIC);
@@ -422,7 +424,11 @@ static void uwb_rc_neh_grok_event(struct uwb_rc *rc, struct uwb_rceb *rceb, size
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
@@ -568,6 +574,10 @@ static void uwb_rc_neh_timer(unsigned long arg)
 	unsigned long flags;
 
 	spin_lock_irqsave(&rc->neh_lock, flags);
+	if (neh->completed) {
+		spin_unlock_irqrestore(&rc->neh_lock, flags);
+		return;
+	}
 	if (neh->context)
 		__uwb_rc_neh_rm(rc, neh);
 	else
-- 
1.7.10



