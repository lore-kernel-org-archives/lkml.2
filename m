Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751233Ab2IJEPQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 00:15:16 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38659 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab2IJEPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 00:15:13 -0400
Date: Sun, 9 Sep 2012 21:12:37 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>
Cc: Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        Colin Cross <ccross@android.com>, Brian Swetland <swetland@google.com>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        kgdb-bugreport@lists.sourceforge.net, linux-serial@vger.kernel.org
Subject: [PATCH 02/14] drivers/tty/serial/amba-pl0{10,11}.c: use
 clk_prepare_enable and clk_disable_unprepare
Message-ID: <20120910041237.GB29537@lizard>
References: <20120910040802.GA1261@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120910040802.GA1261@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Clk_prepare_enable and clk_disable_unprepare combine clk_prepare and
clk_enable, and clk_disable and clk_unprepare.  The9 make the code more
concise, and ensure that clk_unprepare is called when clk_enable fails.

A simplified version of the semantic patch that introduces calls to these
functions is as follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e;
@@

- clk_prepare(e);
- clk_enable(e);
+ clk_prepare_enable(e);

@@
expression e;
@@

- clk_disable(e);
- clk_unprepare(e);
+ clk_disable_unprepare(e);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---

The patch was taken from the TTY tree.

If this patch rejects because 'already applied', this means that your
tree is probably based on TTY tree or -next (e.g. -mm). In which case
you don't need this patch, just drop it.

If your tree is based on Linus' tree, you need this patch to not bring
horrible conflicts into -next.

 drivers/tty/serial/amba-pl010.c | 15 ++++-----------
 drivers/tty/serial/amba-pl011.c | 15 ++++-----------
 2 files changed, 8 insertions(+), 22 deletions(-)

diff --git a/drivers/tty/serial/amba-pl010.c b/drivers/tty/serial/amba-pl010.c
index 0d91a54..22317dd 100644
--- a/drivers/tty/serial/amba-pl010.c
+++ b/drivers/tty/serial/amba-pl010.c
@@ -312,16 +312,12 @@ static int pl010_startup(struct uart_port *port)
 	struct uart_amba_port *uap = (struct uart_amba_port *)port;
 	int retval;
 
-	retval = clk_prepare(uap->clk);
-	if (retval)
-		goto out;
-
 	/*
 	 * Try to enable the clock producer.
 	 */
-	retval = clk_enable(uap->clk);
+	retval = clk_prepare_enable(uap->clk);
 	if (retval)
-		goto clk_unprep;
+		goto out;
 
 	uap->port.uartclk = clk_get_rate(uap->clk);
 
@@ -346,9 +342,7 @@ static int pl010_startup(struct uart_port *port)
 	return 0;
 
  clk_dis:
-	clk_disable(uap->clk);
- clk_unprep:
-	clk_unprepare(uap->clk);
+	clk_disable_unprepare(uap->clk);
  out:
 	return retval;
 }
@@ -375,8 +369,7 @@ static void pl010_shutdown(struct uart_port *port)
 	/*
 	 * Shut down the clock producer
 	 */
-	clk_disable(uap->clk);
-	clk_unprepare(uap->clk);
+	clk_disable_unprepare(uap->clk);
 }
 
 static void
diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index 92b1ac8..3322023 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -1324,16 +1324,12 @@ static int pl011_startup(struct uart_port *port)
 				"could not set default pins\n");
 	}
 
-	retval = clk_prepare(uap->clk);
-	if (retval)
-		goto out;
-
 	/*
 	 * Try to enable the clock producer.
 	 */
-	retval = clk_enable(uap->clk);
+	retval = clk_prepare_enable(uap->clk);
 	if (retval)
-		goto clk_unprep;
+		goto out;
 
 	uap->port.uartclk = clk_get_rate(uap->clk);
 
@@ -1411,9 +1407,7 @@ static int pl011_startup(struct uart_port *port)
 	return 0;
 
  clk_dis:
-	clk_disable(uap->clk);
- clk_unprep:
-	clk_unprepare(uap->clk);
+	clk_disable_unprepare(uap->clk);
  out:
 	return retval;
 }
@@ -1473,8 +1467,7 @@ static void pl011_shutdown(struct uart_port *port)
 	/*
 	 * Shut down the clock producer
 	 */
-	clk_disable(uap->clk);
-	clk_unprepare(uap->clk);
+	clk_disable_unprepare(uap->clk);
 	/* Optionally let pins go into sleep states */
 	if (!IS_ERR(uap->pins_sleep)) {
 		retval = pinctrl_select_state(uap->pinctrl, uap->pins_sleep);
-- 
1.7.11.5

