Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab1HHWii (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 18:38:38 -0400
Received: from smtp-out.google.com ([216.239.44.51]:51594 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260Ab1HHWih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 18:38:37 -0400
From: Vincent Palatin <vpalatin@chromium.org>
To: Oliver Neukum <oliver@neukum.name>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Vincent Palatin <vpalatin@chromium.org>
Subject: [PATCH] USB: cdc-acm: fix possible null pointer in acm_tty_hangup
Date: Mon,  8 Aug 2011 15:38:20 -0700
Message-Id: <1312843100-1811-1-git-send-email-vpalatin@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes, acm_tty_hangup and acm_tty_close are called concurrently.
This results in acm pointer being null in acm_tty_hangup and panics when
it is dereferenced.

Signed-off-by: Vincent Palatin <vpalatin@chromium.org>
---
 drivers/usb/class/cdc-acm.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index dac7676..3d389f3 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -539,7 +539,6 @@ static void acm_port_down(struct acm *acm)
 {
 	int i;
 
-	mutex_lock(&open_mutex);
 	if (acm->dev) {
 		usb_autopm_get_interface(acm->control);
 		acm_set_control(acm, acm->ctrlout = 0);
@@ -551,14 +550,19 @@ static void acm_port_down(struct acm *acm)
 		acm->control->needs_remote_wakeup = 0;
 		usb_autopm_put_interface(acm->control);
 	}
-	mutex_unlock(&open_mutex);
 }
 
 static void acm_tty_hangup(struct tty_struct *tty)
 {
-	struct acm *acm = tty->driver_data;
-	tty_port_hangup(&acm->port);
-	acm_port_down(acm);
+	struct acm *acm;
+
+	mutex_lock(&open_mutex);
+	acm = tty->driver_data;
+	if (acm) {
+		tty_port_hangup(&acm->port);
+		acm_port_down(acm);
+	}
+	mutex_unlock(&open_mutex);
 }
 
 static void acm_tty_close(struct tty_struct *tty, struct file *filp)
@@ -579,7 +583,9 @@ static void acm_tty_close(struct tty_struct *tty, struct file *filp)
 		mutex_unlock(&open_mutex);
 		return;
 	}
+	mutex_lock(&open_mutex);
 	acm_port_down(acm);
+	mutex_unlock(&open_mutex);
 	tty_port_close_end(&acm->port, tty);
 	tty_port_tty_set(&acm->port, NULL);
 }
-- 
1.7.3.1

