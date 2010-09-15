Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab0IOVu2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 17:50:28 -0400
Received: from mx1.vsecurity.com ([209.67.252.12]:60502 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754434Ab0IOVuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 17:50:25 -0400
Subject: [PATCH] drivers/char/nozomi.c: prevent reading uninitialized stack
 memory
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: linux-kernel@vger.kernel.org
Cc: security@kernel.org, stable@kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Sep 2010 17:44:01 -0400
Message-ID: <1284587041.6275.97.camel@dan>
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

--- linux-2.6.35.4.orig/drivers/char/nozomi.c	2010-08-26 19:47:12.000000000 -0400
+++ linux-2.6.35.4/drivers/char/nozomi.c	2010-09-15 13:58:26.324877778 -0400
@@ -1810,6 +1810,8 @@ static int ntty_ioctl_tiocgicount(struct
 	const struct async_icount cnow = port->tty_icount;
 	struct serial_icounter_struct icount;
 
+	memset(&icount, 0, sizeof(struct serial_icounter_struct));
+
 	icount.cts = cnow.cts;
 	icount.dsr = cnow.dsr;
 	icount.rng = cnow.rng;




