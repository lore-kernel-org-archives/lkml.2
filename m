Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933037Ab0HEWlf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:41:35 -0400
Received: from kroah.org ([198.145.64.141]:37678 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760832Ab0HEWYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:24:20 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 38/67] cdc-acm: remove dead code
Date: Thu,  5 Aug 2010 15:23:05 -0700
Message-Id: <1281047014-23429-38-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100805213528.GA13794@kroah.com>
References: <20100805213528.GA13794@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The wait_event_interruptible_timeout in acm_port_down is
never reached. Remove it to avoid possible deadlocks
with the big tty mutex if someone were to start using
the blocking version of acm_port_down.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/class/cdc-acm.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 89d260d..1833b3a 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -636,19 +636,13 @@ static void acm_tty_unregister(struct acm *acm)
 
 static int acm_tty_chars_in_buffer(struct tty_struct *tty);
 
-static void acm_port_down(struct acm *acm, int drain)
+static void acm_port_down(struct acm *acm)
 {
 	int i, nr = acm->rx_buflimit;
 	mutex_lock(&open_mutex);
 	if (acm->dev) {
 		usb_autopm_get_interface(acm->control);
 		acm_set_control(acm, acm->ctrlout = 0);
-		/* try letting the last writes drain naturally */
-		if (drain) {
-			wait_event_interruptible_timeout(acm->drain_wait,
-				(ACM_NW == acm_wb_is_avail(acm)) || !acm->dev,
-					ACM_CLOSE_TIMEOUT * HZ);
-		}
 		usb_kill_urb(acm->ctrlurb);
 		for (i = 0; i < ACM_NW; i++)
 			usb_kill_urb(acm->wb[i].urb);
@@ -664,7 +658,7 @@ static void acm_tty_hangup(struct tty_struct *tty)
 {
 	struct acm *acm = tty->driver_data;
 	tty_port_hangup(&acm->port);
-	acm_port_down(acm, 0);
+	acm_port_down(acm);
 }
 
 static void acm_tty_close(struct tty_struct *tty, struct file *filp)
@@ -685,7 +679,7 @@ static void acm_tty_close(struct tty_struct *tty, struct file *filp)
 		mutex_unlock(&open_mutex);
 		return;
 	}
-	acm_port_down(acm, 0);
+	acm_port_down(acm);
 	tty_port_close_end(&acm->port, tty);
 	tty_port_tty_set(&acm->port, NULL);
 }
-- 
1.7.2

