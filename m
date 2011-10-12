Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903Ab1JLA0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 20:26:19 -0400
Received: from smtp-out.google.com ([216.239.44.51]:51298 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab1JLA0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 20:26:17 -0400
From: Doug Anderson <dianders@chromium.org>
To: Jiri Slaby <jirislaby@gmail.com>, Stephen Warren <swarren@nvidia.com>,
        Olof Johansson <olof@lixom.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        Allen Martin <AMartin@nvidia.com>, Tom Warren <twarren@nvidia.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Doug Anderson <dianders@chromium.org>
Subject: [PATCH v2] TTY: serial_core: Fix crash if DCD drop during suspend
Date: Tue, 11 Oct 2011 17:25:44 -0700
Message-Id: <1318379144-27187-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1318024753-15336-1-git-send-email-dianders@chromium.org>
References: <1318024753-15336-1-git-send-email-dianders@chromium.org>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This crash was showing up 100% of the time on Tegra CPUs when an
agetty was running on the serial port and the console was not running
on the serial port.  The reason the Tegra saw it so reliably is that
the Tegra CPU internally ties DTR to DCD/DSR.  That means when we
dropped DTR during suspend we would get always get an immediate DCD
drop.

The specific order of operations that were running:
* uart_suspend_port() would be called to put the uart in suspend mode
* we'd drop DTR (ops->set_mctrl(uport, 0)).
* the DTR drop would be looped back in the CPU to be a DCD drop.
* the DCD drop would look to the serial driver as a hangup
* the hangup would call uart_shutdown()
* ... suspend / resume happens ...
* uart_resume_port() would be called and run the code in the
  (port->flags & ASYNC_SUSPENDED) block, which would startup the port
  (and enable tx again).
* Since the UART would be available for tx, we'd immediately get
  an interrupt, eventually calling transmit_chars()
* The transmit_chars() function would crash.  The first crash would
  be a dereference of a NULL tty member, but since the port has been
  shutdown that was just a symptom.

I have proposed a patch that would fix the Tegra CPUs here (see
https://lkml.org/lkml/2011/10/11/444 - tty/serial: Prevent drop of DCD
on suspend for Tegra UARTs).  However, even with that fix it is still
possible for systems that have an externally visible DCD line to see a
crash if the DCD drops at just the right time during suspend: thus
this patch is still useful.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
v2: Updated change description and comments based on deeper digging.

 drivers/tty/serial/serial_core.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index a3efbea..7a86b39 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -255,6 +255,13 @@ static void uart_shutdown(struct tty_struct *tty, struct uart_state *state)
 	}
 
 	/*
+	 * It's possible for shutdown to be called after suspend if we get
+	 * a DCD drop (hangup) at just the right time.  Clear suspended bit so
+	 * we don't try to resume a port that has been shutdown.
+	 */
+	clear_bit(ASYNCB_SUSPENDED, &port->flags);
+
+	/*
 	 * kill off our tasklet
 	 */
 	tasklet_kill(&state->tlet);
-- 
1.7.3.1

