Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423Ab2BAVS2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:18:28 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:58951 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757389Ab2BAVRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:17:42 -0500
X-Sasl-enc: 5xQDZ0q7qzR95YpcGcrUFsLD444Z3fDDXwsIfSm5TkTH 1328131061
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:49 2012
Message-Id: <20120201210049.705813938@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 13:00:30 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Oliver Neukum <oliver@neukum.org>
Subject: [66/89] USB: cdc-wdm: call wake_up_all to allow driver to shutdown on device removal
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjørn Mork <bjorn@mork.no>

commit 62aaf24dc125d7c55c93e313d15611f152b030c7 upstream.

wdm_disconnect() waits for the mutex held by wdm_read() before
calling wake_up_all().  This causes a deadlock, preventing device removal
to complete.  Do the wake_up_all() before we start waiting for the locks.

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Cc: Oliver Neukum <oliver@neukum.org>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/cdc-wdm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -786,13 +786,13 @@ static void wdm_disconnect(struct usb_in
 	/* to terminate pending flushes */
 	clear_bit(WDM_IN_USE, &desc->flags);
 	spin_unlock_irqrestore(&desc->iuspin, flags);
+	wake_up_all(&desc->wait);
 	mutex_lock(&desc->rlock);
 	mutex_lock(&desc->wlock);
 	kill_urbs(desc);
 	cancel_work_sync(&desc->rxwork);
 	mutex_unlock(&desc->wlock);
 	mutex_unlock(&desc->rlock);
-	wake_up_all(&desc->wait);
 	if (!desc->count)
 		cleanup(desc);
 	mutex_unlock(&wdm_mutex);


