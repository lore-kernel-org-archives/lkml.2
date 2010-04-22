Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304Ab0DVThL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:37:11 -0400
Received: from kroah.org ([198.145.64.141]:41420 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756845Ab0DVT3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:29:44 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:22 2010
Message-Id: <20100422190922.421234374@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:10:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       <Anton@anikin.name>, <stable-commits@vger.kernel.org>,
       Ping Cheng <pingc@wacom.com>, Dmitry Torokhov <dtor@mail.ru>
Subject: [168/197] Input: wacom - switch mode upon system resume
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ping Cheng <pingc@wacom.com>

commit 014f61504af276ba9d9544d8a7401d8f8526eb73 upstream.

When Wacom devices wake up from a sleep, the switch mode command
(wacom_query_tablet_data) is needed before wacom_open is called.
wacom_query_tablet_data should not be executed inside wacom_open
since wacom_open is called more than once during probe.

Reported-and-tested-by: Anton Anikin <Anton@Anikin.name>
Signed-off-by: Ping Cheng <pingc@wacom.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/input/tablet/wacom_sys.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -562,11 +562,15 @@ static int wacom_resume(struct usb_inter
 	int rv;
 
 	mutex_lock(&wacom->lock);
-	if (wacom->open) {
+
+	/* switch to wacom mode first */
+	wacom_query_tablet_data(intf);
+
+	if (wacom->open)
 		rv = usb_submit_urb(wacom->irq, GFP_NOIO);
-		wacom_query_tablet_data(intf);
-	} else
+	else
 		rv = 0;
+
 	mutex_unlock(&wacom->lock);
 
 	return rv;


