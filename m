Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180Ab0FAUxw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 16:53:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61752 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757504Ab0FAUxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 16:53:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH 24/31] cdc-acm: remove dead code
Date: Tue,  1 Jun 2010 22:53:04 +0200
Message-Id: <1275425591-8803-25-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1275425591-8803-1-git-send-email-arnd@arndb.de>
References: <1275425591-8803-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19NZivv4ENQYfzQRGgL/KPif2jKn0hehXXqNX4
 YKXYwM6P9oUcxYddu1hSAszhnhRvMBPjIC/C3Xu56oIK7SM2VY
 dn80Kf7h3WyNaHmmECqnA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The wait_event_interruptible_timeout in acm_port_down is
never reached. Remove it to avoid possible deadlocks
with the big tty mutex if someone were to start using
the blocking version of acm_port_down.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/usb/class/cdc-acm.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 0c2f14f..d00d155 100644
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
1.7.0.4

