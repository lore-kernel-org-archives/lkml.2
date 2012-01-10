Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934364Ab2AJXEE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 18:04:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52869 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934168Ab2AJXD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 18:03:56 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan 10 13:56:05 2012
Message-Id: <20120110215605.730705023@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 10 Jan 2012 13:55:51 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, jhovold@gmail.com, linux-usb@vger.kernel.org,
        Thilo-Alexander Ginkel <thilo@ginkel.com>
Subject: [48/49] usb: cdc-acm: Fix acm_tty_hangup() vs. acm_tty_close() race
In-Reply-To: <20120110215609.GA22505@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thilo-Alexander Ginkel <thilo@ginkel.com>

[Not upstream as it was fixed differently for 3.3 with a much more
"intrusive" rework of the driver - gregkh]

There is a race condition involving acm_tty_hangup() and acm_tty_close()
where hangup() would attempt to access tty->driver_data without proper
locking and NULL checking after close() has potentially already set it
to NULL.  One possibility to (sporadically) trigger this behavior is to
perform a suspend/resume cycle with a running WWAN data connection.

This patch addresses the issue by introducing a NULL check for
tty->driver_data in acm_tty_hangup() protected by open_mutex and exiting
gracefully when hangup() is invoked on a device that has already been
closed.

Signed-off-by: Thilo-Alexander Ginkel <thilo@ginkel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html



