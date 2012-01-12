Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab2ALVz0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 16:55:26 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:44346 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755645Ab2ALVzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 16:55:25 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: Arnd Bergmann <arnd@arndb.de>, alan@linux.intel.com,
        linux-serial@vger.kernel.org, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        "3.0 3.1 3.2" <stable@vger.kernel.org>
Subject: [PATCH] TTY: fix UV serial console regression
Date: Thu, 12 Jan 2012 22:55:15 +0100
Message-Id: <1326405315-6601-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <4EDE988B.6010501@suse.cz>
References: <4EDE988B.6010501@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 74c2107759d (serial: Use block_til_ready helper) and its fixup
3f582b8c110 (serial: fix termios settings in open) introduced a
regression on UV systems. The serial eventually freezes while being
used. It's completely unpredictable and sometimes needs a heap of
traffic to happen first.

To reproduce this, yast installation was used as it turned out to be
pretty reliable in reproducing. Especially during installation process
where one doesn't have an SSH daemon running. And no monitor as the HW
is completely headless. So this was fun to find. Given the machine
doesn't boot on vanilla before 2.6.36 final. (And the commits above
are older.)

Unless there is some bad race in the code, the hardware seems to be
pretty broken. Otherwise pure MSR read should not cause such a bug,
or?

So to prevent the bug, revert to the old behavior. I.e. read modem
status only if we really have to -- for non-CLOCAL set serials.
Non-CLOCAL works on this hardware OK, I tried. See? I don't.

And document that shit.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: 3.0 3.1 3.2 <stable@vger.kernel.org>
References: https://lkml.org/lkml/2011/12/6/573
References: https://bugzilla.novell.com/show_bug.cgi?id=718518
---
 drivers/tty/tty_port.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index 7a4fb1c..1109e1b 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -227,7 +227,6 @@ int tty_port_block_til_ready(struct tty_port *port,
 	int do_clocal = 0, retval;
 	unsigned long flags;
 	DEFINE_WAIT(wait);
-	int cd;
 
 	/* block if port is in the process of being closed */
 	if (tty_hung_up_p(filp) || port->flags & ASYNC_CLOSING) {
@@ -284,11 +283,14 @@ int tty_port_block_til_ready(struct tty_port *port,
 				retval = -ERESTARTSYS;
 			break;
 		}
-		/* Probe the carrier. For devices with no carrier detect this
-		   will always return true */
-		cd = tty_port_carrier_raised(port);
+		/*
+		 * Probe the carrier. For devices with no carrier detect
+		 * tty_port_carrier_raised will always return true.
+		 * Never ask drivers if CLOCAL is set, this causes troubles
+		 * on some hardware.
+		 */
 		if (!(port->flags & ASYNC_CLOSING) &&
-				(do_clocal || cd))
+				(do_clocal || tty_port_carrier_raised(port)))
 			break;
 		if (signal_pending(current)) {
 			retval = -ERESTARTSYS;
-- 
1.7.8.3


