Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932826Ab1KWAnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:43:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43115 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932799Ab1KWAm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:42:56 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:24:07 2011
Message-Id: <20111123002407.884917534@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:23:42 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Havard Skinnemoen <hskinnemoen@google.com>,
        Oliver Neukum <oliver@neukum.name>
Subject: [35/53] USB: cdc-acm: Fix disconnect() vs close() race
In-Reply-To: <20111123002419.GA8531@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Havard Skinnemoen <hskinnemoen@google.com>

commit 5dc2470c602da8851907ec18942cd876c3b4ecc1 upstream.

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
Cc: Oliver Neukum <oliver@neukum.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/class/cdc-acm.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -539,7 +539,6 @@ static void acm_port_down(struct acm *ac
 {
 	int i;
 
-	mutex_lock(&open_mutex);
 	if (acm->dev) {
 		usb_autopm_get_interface(acm->control);
 		acm_set_control(acm, acm->ctrlout = 0);
@@ -551,14 +550,15 @@ static void acm_port_down(struct acm *ac
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
@@ -569,8 +569,9 @@ static void acm_tty_close(struct tty_str
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
@@ -582,6 +583,7 @@ static void acm_tty_close(struct tty_str
 	acm_port_down(acm);
 	tty_port_close_end(&acm->port, tty);
 	tty_port_tty_set(&acm->port, NULL);
+	mutex_unlock(&open_mutex);
 }
 
 static int acm_tty_write(struct tty_struct *tty,


