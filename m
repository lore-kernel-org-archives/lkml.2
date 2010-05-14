Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759321Ab0ENT2V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 15:28:21 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:42586 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571Ab0ENT2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 15:28:18 -0400
Date: Fri, 14 May 2010 21:28:13 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
       linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 1/10] drivers/s390/char: Use kstrdup
Message-ID: <Pine.LNX.4.64.1005142127100.28935@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use kstrdup when the goal of an allocation is copy a string into the
allocated region.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x,from,to;
expression flag,E1,E2,E3;
statement S;
@@

-   x = strlen(from) + 1;
    ... when != \( x = E1 \| from = E1 \)
-   to = \(kmalloc\|kzalloc\)(x,flag);
+   to = kstrdup(from, flag);
    ... when != \(x = E2 \| from = E2 \| to = E2 \)
    if (to==NULL || ...) S
    ... when != \(x = E3 \| from = E3 \| to = E3 \)
-   memcpy(to, from, x);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/s390/char/keyboard.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -u -p a/drivers/s390/char/keyboard.c b/drivers/s390/char/keyboard.c
--- a/drivers/s390/char/keyboard.c
+++ b/drivers/s390/char/keyboard.c
@@ -72,11 +72,10 @@ kbd_alloc(void) {
 		goto out_maps;
 	for (i = 0; i < ARRAY_SIZE(func_table); i++) {
 		if (func_table[i]) {
-			len = strlen(func_table[i]) + 1;
-			kbd->func_table[i] = kmalloc(len, GFP_KERNEL);
+			kbd->func_table[i] = kstrdup(func_table[i],
+						     GFP_KERNEL);
 			if (!kbd->func_table[i])
 				goto out_func;
-			memcpy(kbd->func_table[i], func_table[i], len);
 		}
 	}
 	kbd->fn_handler =
