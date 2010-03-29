Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab0C2Pga (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 11:36:30 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:41536 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754315Ab0C2Pg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 11:36:26 -0400
Date: Mon, 29 Mar 2010 17:36:24 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 10/12] drivers/serial: Add missing unlock
Message-ID: <Pine.LNX.4.64.1003291736030.21896@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

In an error handling case the lock is not unlocked.

A simplified version of the semantic patch that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
expression E1;
identifier f;
@@

f (...) { <+...
* spin_lock_irqsave (E1,...);
... when != E1
* return ...;
...+> }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/serial/pmac_zilog.c         |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/pmac_zilog.c b/drivers/serial/pmac_zilog.c
index f020de1..fe463b0 100644
--- a/drivers/serial/pmac_zilog.c
+++ b/drivers/serial/pmac_zilog.c
@@ -753,8 +753,10 @@ static void pmz_break_ctl(struct uart_port *port, int break_state)
 		uap->curregs[R5] = new_reg;
 
 		/* NOTE: Not subject to 'transmitter active' rule. */
-		if (ZS_IS_ASLEEP(uap))
+		if (ZS_IS_ASLEEP(uap)) {
+			spin_unlock_irqrestore(&port->lock, flags);
 			return;
+		}
 		write_zsreg(uap, R5, uap->curregs[R5]);
 	}
 
