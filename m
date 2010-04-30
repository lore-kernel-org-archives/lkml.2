Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933434Ab0D3TSt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 15:18:49 -0400
Received: from kroah.org ([198.145.64.141]:53034 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757964Ab0D3Qxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 12:53:42 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia@diku.dk>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 3/3] serial: drivers/serial/pmac_zilog.c: add missing unlock
Date: Fri, 30 Apr 2010 09:37:40 -0700
Message-Id: <1272645460-16491-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <20100430163654.GB16424@kroah.com>
References: <20100430163654.GB16424@kroah.com>
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
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/pmac_zilog.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/pmac_zilog.c b/drivers/serial/pmac_zilog.c
index 4eaa043..700e108 100644
--- a/drivers/serial/pmac_zilog.c
+++ b/drivers/serial/pmac_zilog.c
@@ -752,8 +752,10 @@ static void pmz_break_ctl(struct uart_port *port, int break_state)
 		uap->curregs[R5] = new_reg;
 
 		/* NOTE: Not subject to 'transmitter active' rule. */
-		if (ZS_IS_ASLEEP(uap))
+		if (ZS_IS_ASLEEP(uap)) {
+			spin_unlock_irqrestore(&port->lock, flags);
 			return;
+		}
 		write_zsreg(uap, R5, uap->curregs[R5]);
 	}
 
-- 
1.7.0.4

