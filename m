Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751389Ab2L0Hum (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 02:50:42 -0500
Received: from intranet.asianux.com ([58.214.24.6]:34695 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab2L0Huk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 02:50:40 -0500
X-Spam-Score: -100.8
Message-ID: <50DBFE03.7080303@asianux.com>
Date: Thu, 27 Dec 2012 15:51:31 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>, Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/tty/serial: extern function which for release resource,
 need check pointer, before free it
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  for extern function uart_remove_one_port:
    need check pointer whether be NULL, before the main work.
    just like what the other extern function uart_add_one_port has done.
    uart_add_one_port and uart_remove_one_port are pair

  information:
    for the callers (such as drivers/tty/serial/jsm: jsm_tty.c, jsm_driver.c)
    they realy assume that:
      they still can call uart_remove_one_port, after uart_add_one_port failed
    we (as an extern function), have to understand it (just like kfree).
 

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 drivers/tty/serial/serial_core.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 2c7230a..bd65549 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2642,6 +2642,7 @@ int uart_remove_one_port(struct uart_driver *drv, struct uart_port *uport)
 {
 	struct uart_state *state = drv->state + uport->line;
 	struct tty_port *port = &state->port;
+	int ret = 0;
 
 	BUG_ON(in_interrupt());
 
@@ -2656,6 +2657,11 @@ int uart_remove_one_port(struct uart_driver *drv, struct uart_port *uport)
 	 * succeeding while we shut down the port.
 	 */
 	mutex_lock(&port->mutex);
+	if (!state->uart_port) {
+		mutex_unlock(&port->mutex);
+		ret = -EINVAL;
+		goto out;
+	}
 	uport->flags |= UPF_DEAD;
 	mutex_unlock(&port->mutex);
 
@@ -2679,9 +2685,10 @@ int uart_remove_one_port(struct uart_driver *drv, struct uart_port *uport)
 	uport->type = PORT_UNKNOWN;
 
 	state->uart_port = NULL;
+out:
 	mutex_unlock(&port_mutex);
 
-	return 0;
+	return ret;
 }
 
 /*
-- 
1.7.10.4
