Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891Ab1LQJzx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 04:55:53 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39952 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab1LQJzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 04:55:45 -0500
From: Thilo-Alexander Ginkel <thilo@ginkel.com>
To: oliver@neukum.name, gregkh@suse.de
Cc: jhovold@gmail.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thilo-Alexander Ginkel <thilo@ginkel.com>
Subject: [PATCH 1/1] usb: cdc-acm: Fix acm_tty_hangup() vs. acm_tty_close() race
Date: Sat, 17 Dec 2011 10:55:10 +0100
Message-Id: <1324115710-14756-1-git-send-email-thilo@ginkel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a race condition involving acm_tty_hangup() and acm_tty_close() where
hangup() would attempt to access tty->driver_data without proper locking and
NULL checking after close() has potentially already set it to NULL.
One possibility to (sporadically) trigger this behavior is to perform a
suspend/resume cycle with a running WWAN data connection.

This patch addresses the issue by introducing a NULL check for
tty->driver_data in acm_tty_hangup() protected by open_mutex and exiting
gracefully when hangup() is invoked on a device that has already been closed.

Signed-off-by: Thilo-Alexander Ginkel <thilo@ginkel.com>
---
 drivers/usb/class/cdc-acm.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index a8078d0..97f2e58 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -554,10 +554,18 @@ static void acm_port_down(struct acm *acm)
 
 static void acm_tty_hangup(struct tty_struct *tty)
 {
-	struct acm *acm = tty->driver_data;
-	tty_port_hangup(&acm->port);
+	struct acm *acm;
+
 	mutex_lock(&open_mutex);
+	acm = tty->driver_data;
+
+	if (!acm)
+		goto out;
+
+	tty_port_hangup(&acm->port);
 	acm_port_down(acm);
+
+out:
 	mutex_unlock(&open_mutex);
 }
 
-- 
1.7.5.4

