Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932485Ab2FTSZB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:25:01 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45916 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932604Ab2FTSY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:24:56 -0400
Message-Id: <20120620173041.026664020@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Date: Wed, 20 Jun 2012 10:30:56 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Otto Meta <otto.patches@sister-shadow.de>,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 17/20] usb: cdc-acm: fix devices not unthrottled on open
In-Reply-To: <20120620173044.GA6910@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/class/cdc-acm.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -498,6 +498,14 @@ static int acm_tty_open(struct tty_struc
 
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
 


