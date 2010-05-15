Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab0EOVAz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 17:00:55 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:61033 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488Ab0EOVAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 17:00:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <gregkh@suse.de>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 04/10] cdc-acm: remove dead code
Date: Sat, 15 May 2010 22:59:50 +0200
Message-Id: <1273957196-13768-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1273957196-13768-1-git-send-email-arnd@arndb.de>
References: <1273957196-13768-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+nOtJQauRuQpFakk4ObEWGJlWL0OPs2k+LL2l
 OuO8sp77pFx/VaLSl9RRP9xFvd0rEOfaIYDiZ/VM/K+tl6qWiT
 dahdfMs59mX1OuC4WSJnw==
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
index 5e1a253..7b50bf5 100644
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

