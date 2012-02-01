Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309Ab2BAVQf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:16:35 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56575 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932587Ab2BAVKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:10:24 -0500
X-Sasl-enc: YZaj5Pus8PW7DHfaC2GheUizMVkmZxAejlo/6Beh3dvO 1328130622
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:48 2012
Message-Id: <20120201210048.299953262@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 13:00:14 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jiri Slaby <jslaby@suse.cz>
Subject: [50/89] TTY: fix UV serial console regression
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

commit 0eee50af5b13e00b3fb7a5fe8480419a71b8235d upstream.

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
References: https://lkml.org/lkml/2011/12/6/573
References: https://bugzilla.novell.com/show_bug.cgi?id=718518
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/tty_port.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -227,7 +227,6 @@ int tty_port_block_til_ready(struct tty_
 	int do_clocal = 0, retval;
 	unsigned long flags;
 	DEFINE_WAIT(wait);
-	int cd;
 
 	/* block if port is in the process of being closed */
 	if (tty_hung_up_p(filp) || port->flags & ASYNC_CLOSING) {
@@ -284,11 +283,14 @@ int tty_port_block_til_ready(struct tty_
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


