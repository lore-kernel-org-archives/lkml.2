Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab2IIXdM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:33:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51185 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755269Ab2IIXQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:16:10 -0400
Message-Id: <20120909224202.893071204@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:43:20 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jason Wessel <jason.wessel@windriver.com>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 90/95] pmac_zilog,kdb: Fix console poll hook to return instead of loop
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wessel <jason.wessel@windriver.com>

commit 38f8eefccf3a23c4058a570fa2938a4f553cf8e0 upstream.

kdb <-> kgdb transitioning does not work properly with this UART
driver because the get character routine loops indefinitely as opposed
to returning NO_POLL_CHAR per the expectation of the KDB I/O driver
API.

The symptom is a kernel hang when trying to switch debug modes.

Cc: Alan Cox <alan@linux.intel.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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


