Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010Ab0IKXqh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 19:46:37 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64985 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab0IKXqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 19:46:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=xcfPoSAAV8F1LczzRQpaJMB9J3KHalxSRPshM9IeIBdt0vTO2F/XArVATDtuCfVIYE
         uKBmcYIJbhLg1lpzRI+KfmvV/jh9dUNwPmzftQ1rxCVubNrsErnx0tw1+FGsKiGVdmZm
         90I63U0rgHsbi5RncJVAcIi9ZmeqESLqzuMfQ=
MIME-Version: 1.0
Date: Sat, 11 Sep 2010 19:46:35 -0400
Message-ID: <AANLkTi=RrFrYkWVHhLmyA21zNdb3KdaGXRCgLxVgZkah@mail.gmail.com>
Subject: [PATCH] drivers/net/usb/hso.c: prevent reading uninitialized memory
From: Dan Rosenberg <dan.j.rosenberg@gmail.com>
To: j.dumon@option.com
Cc: linux-kernel@vger.kernel.org, security@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TIOCGICOUNT device ioctl allows unprivileged users to read 9 bytes
of uninitialized stack memory, because the "reserved" member of the
serial_icounter_struct struct declared on the stack in hso_get_count()
is not altered or zeroed before being copied back to the user.  This
patch takes care of it.

Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>

--- linux-2.6.35.4.orig/drivers/net/usb/hso.c	2010-09-11
19:12:00.000000000 -0400
+++ linux-2.6.35.4/drivers/net/usb/hso.c	2010-09-11 19:15:23.000000000 -0400
@@ -1653,6 +1653,8 @@ static int hso_get_count(struct hso_seri
 	struct uart_icount cnow;
 	struct hso_tiocmget  *tiocmget = serial->tiocmget;

+	memset(&icount, 0, sizeof(struct serial_icounter_struct));
+
 	if (!tiocmget)
 		 return -ENOENT;
 	spin_lock_irq(&serial->serial_lock);
