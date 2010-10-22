Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758859Ab0JVSYv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:24:51 -0400
Received: from kroah.org ([198.145.64.141]:37734 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758834Ab0JVSYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:24:47 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Sonic Zhang <sonic.zhang@analog.com>, Mike Frysinger <vapier@gentoo.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 48/49] serial: bfin_sport_uart: speed up sport RX sample rate to be 3% faster
Date: Fri, 22 Oct 2010 11:21:27 -0700
Message-Id: <1287771688-14805-48-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175112.GC13489@kroah.com>
References: <20101022175112.GC13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

The actual uart baud rate of devices vary between +/-2% of what is
asked.  The SPORT RX sample rate should be faster than double of the
worst case.  Otherwise, wrong data may be received.  So set SPORT RX
clock to be 3% faster in general.

Reported-by: Olivier STOCK <ostockemer@ereca.fr>
Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/bfin_sport_uart.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/bfin_sport_uart.c b/drivers/serial/bfin_sport_uart.c
index 5318dd3..6f1b51e 100644
--- a/drivers/serial/bfin_sport_uart.c
+++ b/drivers/serial/bfin_sport_uart.c
@@ -131,7 +131,12 @@ static int sport_uart_setup(struct sport_uart_port *up, int size, int baud_rate)
 	pr_debug("%s RCR1:%x, RCR2:%x\n", __func__, SPORT_GET_RCR1(up), SPORT_GET_RCR2(up));
 
 	tclkdiv = sclk / (2 * baud_rate) - 1;
-	rclkdiv = sclk / (2 * baud_rate * 2) - 1;
+	/* The actual uart baud rate of devices vary between +/-2%. The sport
+	 * RX sample rate should be faster than the double of the worst case,
+	 * otherwise, wrong data are received. So, set sport RX clock to be
+	 * 3% faster.
+	 */
+	rclkdiv = sclk / (2 * baud_rate * 2 * 97 / 100) - 1;
 	SPORT_PUT_TCLKDIV(up, tclkdiv);
 	SPORT_PUT_RCLKDIV(up, rclkdiv);
 	SSYNC();
-- 
1.7.2

