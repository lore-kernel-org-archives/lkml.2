Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167Ab2HLMSP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 08:18:15 -0400
Received: from mail1.windriver.com ([147.11.146.13]:36014 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab2HLMRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 08:17:21 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <kgdb-bugreport@lists.sourceforge.net>,
        Jason Wessel <jason.wessel@windriver.com>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 2/4] pmac_zilog,kdb: Fix console poll hook to return instead of loop
Date: Sun, 12 Aug 2012 07:16:43 -0500
Message-ID: <1344773805-12844-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344773805-12844-1-git-send-email-jason.wessel@windriver.com>
References: <1344773805-12844-1-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kdb <-> kgdb transitioning does not work properly with this UART
driver because the get character routine loops indefinitely as opposed
to returning NO_POLL_CHAR per the expectation of the KDB I/O driver
API.

The symptom is a kernel hang when trying to switch debug modes.

Cc: Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/tty/serial/pmac_zilog.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/pmac_zilog.c b/drivers/tty/serial/pmac_zilog.c
index 654755a..333c8d0 100644
--- a/drivers/tty/serial/pmac_zilog.c
+++ b/drivers/tty/serial/pmac_zilog.c
@@ -1348,10 +1348,16 @@ static int pmz_verify_port(struct uart_port *port, struct serial_struct *ser)
 static int pmz_poll_get_char(struct uart_port *port)
 {
 	struct uart_pmac_port *uap = (struct uart_pmac_port *)port;
+	int tries = 2;
 
-	while ((read_zsreg(uap, R0) & Rx_CH_AV) == 0)
-		udelay(5);
-	return read_zsdata(uap);
+	while (tries) {
+		if ((read_zsreg(uap, R0) & Rx_CH_AV) != 0)
+			return read_zsdata(uap);
+		if (tries--)
+			udelay(5);
+	}
+
+	return NO_POLL_CHAR;
 }
 
 static void pmz_poll_put_char(struct uart_port *port, unsigned char c)
-- 
1.7.9.5

