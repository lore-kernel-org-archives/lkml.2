Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab2HZQB3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 12:01:29 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:56799
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753803Ab2HZQBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 12:01:19 -0400
X-IronPort-AV: E=Sophos;i="4.80,315,1344204000"; 
   d="scan'208";a="153852297"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Alan Cox <alan@linux.intel.com>
Cc: kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 9/13] drivers/tty/serial/amba-pl0{10,11}.c: use clk_prepare_enable and clk_disable_unprepare
Date: Sun, 26 Aug 2012 18:01:01 +0200
Message-Id: <1345996865-32082-10-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1345996865-32082-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1345996865-32082-1-git-send-email-Julia.Lawall@lip6.fr>
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

---
 drivers/tty/serial/amba-pl010.c |   15 ++++-----------
 drivers/tty/serial/amba-pl011.c |   15 ++++-----------
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

