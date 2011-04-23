Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab1DWQoX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 12:44:23 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:59481 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221Ab1DWQoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 12:44:18 -0400
From: Julia Lawall <julia@diku.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/char/ppdev.c: Put gotten port value
Date: Sat, 23 Apr 2011 18:51:23 +0200
Message-Id: <1303577483-16064-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

parport_find_number calls parport_get_port on its result, so there should
be a corresponding call to parport_put_port before dropping the reference.
Similar code is found in the function register_device in the same file.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@exists@
local idexpression struct parport * x;
expression ra,rr;
statement S1,S2;
@@

x = parport_find_number(...)
... when != x = rr
    when any
    when != parport_put_port(x,...)
    when != if (...) { ... parport_put_port(x,...) ...}
(
if(<+...x...+>) S1 else S2
|
if(...) { ... when != x = ra
     when forall
     when != parport_put_port(x,...)
*return...;
}
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/char/ppdev.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/ppdev.c b/drivers/char/ppdev.c
index f176dba..3fcf80f 100644
--- a/drivers/char/ppdev.c
+++ b/drivers/char/ppdev.c
@@ -457,6 +457,7 @@ static int pp_do_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 			return -ENODEV;
 
 		modes = port->modes;
+		parport_put_port(port);
 		if (copy_to_user (argp, &modes, sizeof (modes))) {
 			return -EFAULT;
 		}

