Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab0C2JkE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 05:40:04 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:59939 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752931Ab0C2Jj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 05:39:59 -0400
Date: Mon, 29 Mar 2010 11:39:53 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/serial/sunsu.c: Correct use after free
Message-ID: <Pine.LNX.4.64.1003291139250.21896@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The of_iounmap is at the out_unmap label, but at that point up has already
been freed.  The free cannot be moved to the out_unmap label, because that
label is reachable from cases where up should not be freed.  So the call to
of_iounmap is just duplicated, and the goto converted to a return.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x,e;
identifier f;
iterator I;
statement S;
@@

*kfree(x);
... when != &x
    when != x = e
    when != I(x,...) S
*x->f
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/serial/sunsu.c              |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/sunsu.c b/drivers/serial/sunsu.c
index 170d3d6..cbcfb18 100644
--- a/drivers/serial/sunsu.c
+++ b/drivers/serial/sunsu.c
@@ -1453,8 +1453,10 @@ static int __devinit su_probe(struct of_device *op, const struct of_device_id *m
 	if (up->su_type == SU_PORT_KBD || up->su_type == SU_PORT_MS) {
 		err = sunsu_kbd_ms_init(up);
 		if (err) {
+			of_iounmap(&op->resource[0],
+				   up->port.membase, up->reg_size);
 			kfree(up);
-			goto out_unmap;
+			return err;
 		}
 		dev_set_drvdata(&op->dev, up);
 
