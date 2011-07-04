Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418Ab1GDOMf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 10:12:35 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:35344 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305Ab1GDOLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 10:11:51 -0400
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH 4/5] drivers/parport/parport_gsc.c: add missing kfree
Date: Mon,  4 Jul 2011 16:11:44 +0200
Message-Id: <1309788705-22278-4-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

ops was allocated previously in this function, so it should be freed before
leaving the function, as done in other nearby error-handling code.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
identifier x;
@@

kfree(x)

@@
identifier r.x;
expression E1!=0,E2,E3,E4;
statement S;
@@

(
if (<+...x...+>) S
|
if (...) { ... when != kfree(x)
               when != if (...) { ... kfree(x); ... }
               when != x = E3
* return E1;
}
... when != x = E2
if (...) { ... when != x = E4
 kfree(x); ... return ...; }
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/parport/parport_gsc.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/parport/parport_gsc.c b/drivers/parport/parport_gsc.c
index 5d6de38..352f961 100644
--- a/drivers/parport/parport_gsc.c
+++ b/drivers/parport/parport_gsc.c
@@ -271,6 +271,7 @@ struct parport *__devinit parport_gsc_probe_port (unsigned long base,
 	if (!parport_SPP_supported (p)) {
 		/* No port. */
 		kfree (priv);
+		kfree(ops);
 		return NULL;
 	}
 	parport_PS2_supported (p);

