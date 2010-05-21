Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934076Ab0EUQwD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 12:52:03 -0400
Received: from kroah.org ([198.145.64.141]:50281 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934054Ab0EUQv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:51:57 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Sonic Zhang <sonic.zhang@analog.com>, Mike Frysinger <vapier@gentoo.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 02/25] serial: bfin_sport_uart: shorten the SPORT TX waiting loop
Date: Fri, 21 May 2010 09:51:31 -0700
Message-Id: <1274460714-11277-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165113.GB11216@kroah.com>
References: <20100521165113.GB11216@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

The waiting loop to stop SPORT TX from TX interrupt is too long.  This may
block the SPORT RX interrupts and cause the RX FIFO to overflow. So, do
stop sport TX only after the last char in TX FIFO is moved into the shift
register.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/bfin_sport_uart.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/bfin_sport_uart.c b/drivers/serial/bfin_sport_uart.c
index c88f8ad..6991c36 100644
--- a/drivers/serial/bfin_sport_uart.c
+++ b/drivers/serial/bfin_sport_uart.c
@@ -271,7 +271,13 @@ static void sport_uart_tx_chars(struct sport_uart_port *up)
 	}
 
 	if (uart_circ_empty(xmit) || uart_tx_stopped(&up->port)) {
-		sport_stop_tx(&up->port);
+		/* The waiting loop to stop SPORT TX from TX interrupt is
+		 * too long. This may block SPORT RX interrupts and cause
+		 * RX FIFO overflow. So, do stop sport TX only after the last
+		 * char in TX FIFO is moved into the shift register.
+		 */
+		if (SPORT_GET_STAT(up) & TXHRE)
+			sport_stop_tx(&up->port);
 		return;
 	}
 
-- 
1.7.0.3

