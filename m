Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422Ab1DVUjZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 16:39:25 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:53558 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984Ab1DVUjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 16:39:22 -0400
From: Julia Lawall <julia@diku.dk>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/tty/moxa.c: Put correct tty value
Date: Fri, 22 Apr 2011 22:46:21 +0200
Message-Id: <1303505181-16359-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tty value that should be put is the one that was just gotten by
tty_port_tty_get, not the one that is the argument to the enclosing
function.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@exists@
local idexpression struct tty_struct *x;
expression ra,rr;
statement S1,S2;
@@

x = tty_port_tty_get(...)
... when != x = rr
    when any
    when != tty_kref_put(x,...)
    when != if (...) { ... tty_kref_put(x,...) ...}
(
if(<+...x...+>) S1 else S2
|
if(...) { ... when != x = ra
     when forall
     when != tty_kref_put(x,...)
*return...;
}
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/tty/moxa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/moxa.c b/drivers/tty/moxa.c
index 35b0c38..e097a23 100644
--- a/drivers/tty/moxa.c
+++ b/drivers/tty/moxa.c
@@ -371,7 +371,7 @@ static int moxa_ioctl(struct tty_struct *tty,
 					tmp.cflag = p->cflag;
 				else
 					tmp.cflag = ttyp->termios->c_cflag;
-				tty_kref_put(tty);
+				tty_kref_put(ttyp);
 copy:
 				if (copy_to_user(argm, &tmp, sizeof(tmp)))
 					return -EFAULT;

