Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758665Ab0JVSWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:22:23 -0400
Received: from kroah.org ([198.145.64.141]:41941 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755789Ab0JVSWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:22:21 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: David Daney <ddaney@caviumnetworks.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 32/49] serial: 8250: Don't delay after transmitter is ready.
Date: Fri, 22 Oct 2010 11:21:11 -0700
Message-Id: <1287771688-14805-32-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175112.GC13489@kroah.com>
References: <20101022175112.GC13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <ddaney@caviumnetworks.com>

The loop in wait_for_xmitr() is delaying one extra uS after the ready
condition has been met.  Rewrite the loop to only delay if the
transmitter is not ready.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/8250.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 24110f6..31b8cca 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -1867,15 +1867,17 @@ static void wait_for_xmitr(struct uart_8250_port *up, int bits)
 	unsigned int status, tmout = 10000;
 
 	/* Wait up to 10ms for the character(s) to be sent. */
-	do {
+	for (;;) {
 		status = serial_in(up, UART_LSR);
 
 		up->lsr_saved_flags |= status & LSR_SAVE_FLAGS;
 
+		if ((status & bits) == bits)
+			break;
 		if (--tmout == 0)
 			break;
 		udelay(1);
-	} while ((status & bits) != bits);
+	}
 
 	/* Wait up to 1s for flow control if necessary */
 	if (up->port.flags & UPF_CONS_FLOW) {
-- 
1.7.2

