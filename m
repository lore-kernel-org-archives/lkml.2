Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759287Ab2FQSim (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:38:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50190 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758053Ab2FQSWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:22:35 -0400
Message-Id: <20120617175950.955142805@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Jun 2012 19:00:47 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Otto Meta <otto.patches@sister-shadow.de>,
        Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 66/69] usb: cdc-acm: fix devices not unthrottled on open
In-Reply-To: <20120617175941.281333656@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Otto Meta <otto.patches@sister-shadow.de>

commit 6c4707f3f8c44ec18282e1c014c80e1c257042f9 upstream.

Currently CDC-ACM devices stay throttled when their TTY is closed while
throttled, stalling further communication attempts after the next open.

Unthrottling during open/activate got lost starting with kernel
3.0.0 and this patch reintroduces it.

Signed-off-by: Otto Meta <otto.patches@sister-shadow.de>
Acked-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/class/cdc-acm.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -498,6 +498,14 @@
 
 	usb_autopm_put_interface(acm->control);
 
+	/*
+	 * Unthrottle device in case the TTY was closed while throttled.
+	 */
+	spin_lock_irq(&acm->read_lock);
+	acm->throttled = 0;
+	acm->throttle_req = 0;
+	spin_unlock_irq(&acm->read_lock);
+
 	if (acm_submit_read_urbs(acm, GFP_KERNEL))
 		goto bail_out;
 


