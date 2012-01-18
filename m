Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab2ARXHk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 18:07:40 -0500
Received: from mail-yx0-f202.google.com ([209.85.213.202]:63154 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755358Ab2ARXHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 18:07:37 -0500
From: Simon Glass <sjg@chromium.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-serial@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Simon Glass <sjg@chromium.org>
Subject: [PATCH 2/2] serial: Use device_init_wakeup_flag() to make device wakeup-capable
Date: Wed, 18 Jan 2012 15:07:07 -0800
Message-Id: <1326928027-20610-2-git-send-email-sjg@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1326928027-20610-1-git-send-email-sjg@chromium.org>
References: <1326826563-32215-3-git-send-email-sjg@chromium.org>
 <1326928027-20610-1-git-send-email-sjg@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want the serial device to be wakeup-capable but not actually enable
the wakeup function. The original code results in making the serial
device wakeup-capable, then enabling and then immediately disabling
the actual wakeup feature on the device. This ends up in a
synchronise_rcu() in wakeup_source_remove() which can take some 15ms
to run, yet is entirely avoidable. The cost over 4 ports is about 600ms
on my Tegra2x system (with CONFIG_PREEMPT disabled).

Using the new function avoids this problem.

Signed-off-by: Simon Glass <sjg@chromium.org>
---
 drivers/tty/serial/serial_core.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index c7bf31a..a8b01db 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2348,11 +2348,11 @@ int uart_add_one_port(struct uart_driver *drv, struct uart_port *uport)
 	 */
 	tty_dev = tty_register_device(drv->tty_driver, uport->line, uport->dev);
 	if (likely(!IS_ERR(tty_dev))) {
-		device_init_wakeup(tty_dev, 1);
-		device_set_wakeup_enable(tty_dev, 0);
-	} else
+		device_init_wakeup_flag(tty_dev, PM_WAKEUP_CAP);
+	} else {
 		printk(KERN_ERR "Cannot register tty device on line %d\n",
 		       uport->line);
+	}
 
 	/*
 	 * Ensure UPF_DEAD is not set.
-- 
1.7.7.3

