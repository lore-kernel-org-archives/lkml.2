Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab0IOVur (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 17:50:47 -0400
Received: from mx1.vsecurity.com ([209.67.252.12]:61126 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213Ab0IOVub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 17:50:31 -0400
Subject: [PATCH] drivers/serial/serial_core.c: prevent reading
 uninitialized stack memory
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, security@kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Sep 2010 17:44:09 -0400
Message-ID: <1284587049.6275.99.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TIOCGICOUNT device ioctl allows unprivileged users to read
uninitialized stack memory, because the "reserved" member of the
serial_icounter_struct struct declared on the stack is not altered or
zeroed before being copied back to the user.  This patch takes care of
it.

Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>

--- linux-2.6.35.4.orig/drivers/serial/serial_core.c	2010-08-26 19:47:12.000000000 -0400
+++ linux-2.6.35.4/drivers/serial/serial_core.c	2010-09-15 13:57:04.767375072 -0400
@@ -1081,6 +1081,8 @@ static int uart_get_count(struct uart_st
 	struct uart_icount cnow;
 	struct uart_port *uport = state->uart_port;
 
+	memset(&icount, 0, sizeof(struct serial_icounter_struct));
+
 	spin_lock_irq(&uport->lock);
 	memcpy(&cnow, &uport->icount, sizeof(struct uart_icount));
 	spin_unlock_irq(&uport->lock);





