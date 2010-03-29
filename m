Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab0C2Pfa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 11:35:30 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:41509 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754135Ab0C2Pf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 11:35:26 -0400
Date: Mon, 29 Mar 2010 17:35:24 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 7/12] drivers/pcmcia: Add missing local_irq_restore
Message-ID: <Pine.LNX.4.64.1003291735050.21896@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use local_irq_restore in this error-handling case just like in the one just
below.

A simplified version of the semantic patch that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
expression E1;
identifier f;
@@

f (...) { <+...
* local_irq_save (E1,...);
... when != E1
* return ...;
...+> }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/pcmcia/db1xxx_ss.c          |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/pcmcia/db1xxx_ss.c b/drivers/pcmcia/db1xxx_ss.c
index a520193..a3fec01 100644
--- a/drivers/pcmcia/db1xxx_ss.c
+++ b/drivers/pcmcia/db1xxx_ss.c
@@ -165,8 +165,10 @@ static int db1x_pcmcia_setup_irqs(struct db1x_pcmcia_sock *sock)
 
 		ret = request_irq(sock->insert_irq, db1200_pcmcia_cdirq,
 				  IRQF_DISABLED, "pcmcia_insert", sock);
-		if (ret)
+		if (ret) {
+			local_irq_restore(flags);
 			goto out1;
+		}
 
 		ret = request_irq(sock->eject_irq, db1200_pcmcia_cdirq,
 				  IRQF_DISABLED, "pcmcia_eject", sock);
