Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932622Ab1J1MPw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 08:15:52 -0400
Received: from mx18.lb01.inode.at ([62.99.145.20]:10122 "EHLO mx.inode.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932233Ab1J1MPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 08:15:49 -0400
From: Michael Thalmeier <michael.thalmeier@hale.at>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: rt <linux-rt-users@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Michael Thalmeier <michael@thalmeier.at>
Subject: [PATCH] USB: g_serial: fix deadlock with PREEMPT_RT enabled
Date: Fri, 28 Oct 2011 14:16:25 +0200
Message-Id: <1319804185-18559-1-git-send-email-michael.thalmeier@hale.at>
X-Mailer: git-send-email 1.7.6.4
MIME-Version: 1.0
X-HALE-MailScanner-Information: Please contact the ISP for more information
X-MailScanner-ID: p9SCFmI8030473
X-HALE-MailScanner: Found to be clean
X-HALE-MailScanner-From: michael.thalmeier@hale.at
MailScanner-NULL-Check: 1320408948.70489@eymcYEjCUshUGI6Ws8+fWQ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit 44a0c0190b500ee6bcfc0976fe540f65dee2cd67 unlocking of spin_locks has
been removed. This patch party restores this functionality.

Signed-off-by: Michael Thalmeier <michael.thalmeier@hale.at>
---
 drivers/usb/gadget/u_serial.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/gadget/u_serial.c b/drivers/usb/gadget/u_serial.c
index 40f7716..a925b9e 100644
--- a/drivers/usb/gadget/u_serial.c
+++ b/drivers/usb/gadget/u_serial.c
@@ -553,7 +553,16 @@ recycle:
 	 * a workqueue, so we won't get callbacks and can hold port_lock
 	 */
 	if (tty && do_push) {
+		/*
+		 * Drop the lock here since it might end up calling
+		 * gs_flush_chars, which takes the lock.
+		 */
+		spin_unlock_irq(&port->port_lock);
 		tty_flip_buffer_push(tty);
+		spin_lock_irq(&port->port_lock);
+
+		/* tty may have been closed */
+		tty = port->port_tty;
 	}
 
 
-- 
1.7.6.4



--
Scanned by MailScanner.

