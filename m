Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784Ab1KIVsD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 16:48:03 -0500
Received: from smtp-out.google.com ([216.239.44.51]:37314 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675Ab1KIVr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 16:47:59 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=BItHjLxI8KmYz8nUz/IQW3QYLoeYbMvDHDxk9W9rY93FiLR2iCapuG/ixbVlBkk22
	HLK2ucSRpOGoAEfwqsTeA==
From: Havard Skinnemoen <hskinnemoen@google.com>
To: Oliver Neukum <oliver@neukum.name>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Havard Skinnemoen <hskinnemoen@google.com>
Subject: [PATCH] cdc-acm: Fix disconnect() vs close() race
Date: Wed,  9 Nov 2011 13:47:38 -0800
Message-Id: <1320875258-3751-1-git-send-email-hskinnemoen@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's a race between the USB disconnect handler and the TTY close
handler which may cause the acm object to be freed while it's still
being used. This may lead to things like

http://article.gmane.org/gmane.linux.usb.general/54250

and

https://lkml.org/lkml/2011/5/29/64

This is the simplest fix I could come up with. Holding on to open_mutex
while closing the TTY device prevents acm_disconnect() from freeing the
acm object between acm->port.count drops to 0 and the TTY side of the
cleanups are finalized.

Signed-off-by: Havard Skinnemoen <hskinnemoen@google.com>
---
 drivers/usb/class/cdc-acm.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index dac7676..5b5dc3a 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -539,7 +539,6 @@ static void acm_port_down(struct acm *acm)
 {
 	int i;
 
-	mutex_lock(&open_mutex);
 	if (acm->dev) {
 		usb_autopm_get_interface(acm->control);
 		acm_set_control(acm, acm->ctrlout = 0);
@@ -551,14 +550,15 @@ static void acm_port_down(struct acm *acm)
 		acm->control->needs_remote_wakeup = 0;
 		usb_autopm_put_interface(acm->control);
 	}
-	mutex_unlock(&open_mutex);
 }
 
 static void acm_tty_hangup(struct tty_struct *tty)
 {
 	struct acm *acm = tty->driver_data;
 	tty_port_hangup(&acm->port);
+	mutex_lock(&open_mutex);
 	acm_port_down(acm);
+	mutex_unlock(&open_mutex);
 }
 
 static void acm_tty_close(struct tty_struct *tty, struct file *filp)
@@ -569,8 +569,9 @@ static void acm_tty_close(struct tty_struct *tty, struct file *filp)
 	   shutdown */
 	if (!acm)
 		return;
+
+	mutex_lock(&open_mutex);
 	if (tty_port_close_start(&acm->port, tty, filp) == 0) {
-		mutex_lock(&open_mutex);
 		if (!acm->dev) {
 			tty_port_tty_set(&acm->port, NULL);
 			acm_tty_unregister(acm);
@@ -582,6 +583,7 @@ static void acm_tty_close(struct tty_struct *tty, struct file *filp)
 	acm_port_down(acm);
 	tty_port_close_end(&acm->port, tty);
 	tty_port_tty_set(&acm->port, NULL);
+	mutex_unlock(&open_mutex);
 }
 
 static int acm_tty_write(struct tty_struct *tty,
-- 
1.7.3.1

