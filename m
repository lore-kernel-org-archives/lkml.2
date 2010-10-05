Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab0JESkQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 14:40:16 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:16451 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab0JESkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 14:40:14 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: linux-serial@vger.kernel.org, gregkh@suse.de, linux-kernel@vger.kernel.org
Cc: David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH] 8250: Don't delay after transmitter is ready.
Date: Tue,  5 Oct 2010 11:40:07 -0700
Message-Id: <1286304007-4715-1-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.2
X-OriginalArrivalTime: 05 Oct 2010 18:40:20.0253 (UTC) FILETIME=[C33F5CD0:01CB64BC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The loop in wait_for_xmitr() is delaying one extra uS after the ready
condition has been met.  Rewrite the loop to only delay if the
transmitter is not ready.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
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
1.7.2.2

