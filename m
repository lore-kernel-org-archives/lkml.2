Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217Ab0FTLZG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 07:25:06 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:57177 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066Ab0FTLZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 07:25:00 -0400
Date: Sun, 20 Jun 2010 13:24:54 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/2] arch/sh/mm: Eliminate a double lock
Message-ID: <Pine.LNX.4.64.1006201324360.4366@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The function begins and ends with a read_lock.  The latter is changed to a
read_unlock.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@locked@
expression E1;
position p;
@@

read_lock(E1@p,...);

@r exists@
expression x <= locked.E1;
expression locked.E1;
expression E2;
identifier lock;
position locked.p,p1,p2;
@@

*lock@p1 (E1@p,...);
... when != E1
    when != \(x = E2\|&x\)
*lock@p2 (E1,...);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
Not tested

 arch/sh/mm/pmb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sh/mm/pmb.c b/arch/sh/mm/pmb.c
index 18623ba..6379091 100644
--- a/arch/sh/mm/pmb.c
+++ b/arch/sh/mm/pmb.c
@@ -770,7 +770,7 @@ static void __init pmb_resize(void)
 		spin_unlock_irqrestore(&pmbe->lock, flags);
 	}
 
-	read_lock(&pmb_rwlock);
+	read_unlock(&pmb_rwlock);
 }
 #endif
 
