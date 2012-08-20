Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab2HTECJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 00:02:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51799 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381Ab2HTECA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 00:02:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jason Wessel <jason.wessel@windriver.com>,
        Alan Cox <alan@linux.intel.com>
Subject: [ 45/46] pmac_zilog,kdb: Fix console poll hook to return instead of loop
Date: Sun, 19 Aug 2012 20:59:21 -0700
Message-Id: <20120820035838.504653759@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.2.565.gbd578b5
In-Reply-To: <20120820035832.274275502@linuxfoundation.org>
References: <20120820035832.274275502@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wessel <jason.wessel@windriver.com>

commit 38f8eefccf3a23c4058a570fa2938a4f553cf8e0 upstream.

kdb <-> kgdb transitioning does not work properly with this UART
driver because the get character routine loops indefinitely as opposed
to returning NO_POLL_CHAR per the expectation of the KDB I/O driver
API.

The symptom is a kernel hang when trying to switch debug modes.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Cc: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/pmac_zilog.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/tty/serial/pmac_zilog.c
+++ b/drivers/tty/serial/pmac_zilog.c
@@ -1348,10 +1348,16 @@ static int pmz_verify_port(struct uart_p
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


