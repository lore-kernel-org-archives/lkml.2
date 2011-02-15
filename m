Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab1BOSyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 13:54:46 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:59808 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752008Ab1BOSyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 13:54:44 -0500
X-Authenticated: #11915224
X-Provags-ID: V01U2FsdGVkX18qospWj5gqmiv0GSHN4isC/ZVh6hOsR583HGagNg
	ZBmg7s1viA8pM9
Date: Wed, 16 Feb 2011 00:24:29 +0530
From: Amit Shah <amitshah@gmx.net>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>, Jiri Slaby <jslaby@suse.cz>,
        gregkh@suse.de, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] USB: serial/usb_wwan, fix tty NULL dereference
Message-ID: <20110215185428.GF12932@amit-x200.redhat.com>
References: <1297781707-3985-1-git-send-email-jslaby@suse.cz>
 <4D5AB48A.2040504@ru.mvista.com>
 <20110215181045.GA12700@amit-x200.redhat.com>
 <4D5AC7AC.2020702@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D5AC7AC.2020702@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Tue) 15 Feb 2011 [19:36:28], Jiri Slaby wrote:
> > If you're fixing that, might as well return in the 'if' above
> 
> No, the urb has to be resubmitted.

Ah; I meant the following, but it hardly matters..

diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
index b004b2a..ad89228 100644
--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -293,25 +293,24 @@ static void usb_wwan_indat_callback(struct urb *urb)
 	if (status) {
 		dbg("%s: nonzero status: %d on endpoint %02x.",
 		    __func__, status, endpoint);
-	} else {
-		tty = tty_port_tty_get(&port->port);
-		if (urb->actual_length) {
-			tty_insert_flip_string(tty, data, urb->actual_length);
-			tty_flip_buffer_push(tty);
-		} else
-			dbg("%s: empty read urb received", __func__);
-		tty_kref_put(tty);
-
-		/* Resubmit urb so we continue receiving */
-		if (status != -ESHUTDOWN) {
-			err = usb_submit_urb(urb, GFP_ATOMIC);
-			if (err && err != -EPERM)
-				printk(KERN_ERR "%s: resubmit read urb failed. "
-				       "(%d)", __func__, err);
-			else
-				usb_mark_last_busy(port->serial->dev);
-		}
-
+		return;
+	}
+	tty = tty_port_tty_get(&port->port);
+	if (urb->actual_length) {
+		tty_insert_flip_string(tty, data, urb->actual_length);
+		tty_flip_buffer_push(tty);
+	} else
+		dbg("%s: empty read urb received", __func__);
+	tty_kref_put(tty);
+
+	/* Resubmit urb so we continue receiving */
+	if (status != -ESHUTDOWN) {
+		err = usb_submit_urb(urb, GFP_ATOMIC);
+		if (err && err != -EPERM)
+			printk(KERN_ERR "%s: resubmit read urb failed. "
+			       "(%d)", __func__, err);
+		else
+			usb_mark_last_busy(port->serial->dev);
 	}
 }
 

		Amit
-- 
http://log.amitshah.net/
