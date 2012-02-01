Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599Ab2BAVK0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:10:26 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36902 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932548Ab2BAVKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:10:14 -0500
X-Sasl-enc: 0VqUegRMCaXLKHxZOSRHYFq3saztGB3jaPaiTphv07aO 1328130613
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:47 2012
Message-Id: <20120201210047.876525578@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 13:00:09 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Oliver Neukum <oneukum@suse.de>
Subject: [45/89] USB: cdc-wdm: updating desc->length must be protected by spin_lock
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjørn Mork <bjorn@mork.no>

commit c428b70c1e115c5649707a602742e34130d19428 upstream.

wdm_in_callback() will also touch this field, so we cannot change it without locking

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Acked-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/cdc-wdm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -467,7 +467,9 @@ retry:
 	for (i = 0; i < desc->length - cntr; i++)
 		desc->ubuf[i] = desc->ubuf[i + cntr];
 
+	spin_lock_irq(&desc->iuspin);
 	desc->length -= cntr;
+	spin_unlock_irq(&desc->iuspin);
 	/* in case we had outstanding data */
 	if (!desc->length)
 		clear_bit(WDM_READ, &desc->flags);


