Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760577Ab2FGNaJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 09:30:09 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:41884 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760441Ab2FGNaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 09:30:08 -0400
MIME-Version: 1.0
Date: Thu, 7 Jun 2012 09:30:06 -0400
X-Google-Sender-Auth: xoE1xK8Qiw78BoYWwKWIJbGD8bg
Message-ID: <CAOvdn6VWdOy1nNM+x3ogCCFXy8FExZjTJaV-s6SR7kbGu+REOA@mail.gmail.com>
Subject: [PATCH] xen/hvc: Fix polling mode to work with kdb/kgdb
From: Ben Guthro <ben@guthro.net>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the polling section of the hvc driver to use the global "last_hvc"
variable, rather than the ttys.

With this change debugging a xen dom0 kernel is possible via the
following kernel parameter:
kgdboc=hvc0

Signed-off-by: Ben Guthro <Benjamin.Guthro@citrix.com>


diff --git a/drivers/tty/hvc/hvc_console.c b/drivers/tty/hvc/hvc_console.c
index 2d691eb..3750e74 100644
--- a/drivers/tty/hvc/hvc_console.c
+++ b/drivers/tty/hvc/hvc_console.c
@@ -766,12 +766,10 @@ int hvc_poll_init(struct tty_driver *driver, int
line, char *options)

 static int hvc_poll_get_char(struct tty_driver *driver, int line)
 {
-       struct tty_struct *tty = driver->ttys[0];
-       struct hvc_struct *hp = tty->driver_data;
        int n;
        char ch;

-       n = hp->ops->get_chars(hp->vtermno, &ch, 1);
+       n = cons_ops[last_hvc]->get_chars(vtermnos[last_hvc], &ch, 1);

        if (n == 0)
                return NO_POLL_CHAR;
@@ -781,12 +779,10 @@ static int hvc_poll_get_char(struct tty_driver
*driver, int line)

 static void hvc_poll_put_char(struct tty_driver *driver, int line, char ch)
 {
-       struct tty_struct *tty = driver->ttys[0];
-       struct hvc_struct *hp = tty->driver_data;
        int n;

        do {
-               n = hp->ops->put_chars(hp->vtermno, &ch, 1);
+               n = cons_ops[last_hvc]->put_chars(vtermnos[last_hvc], &ch, 1);
        } while (n <= 0);
 }
 #endif
