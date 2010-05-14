Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759963Ab0ENVD7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 17:03:59 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:38954 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758419Ab0ENVD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 17:03:57 -0400
Date: Fri, 14 May 2010 23:03:51 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
       linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/10] drivers/s390/char: Use kstrdup
In-Reply-To: <Pine.LNX.4.64.1005142210320.28935@ask.diku.dk>
Message-ID: <Pine.LNX.4.64.1005142303180.28935@ask.diku.dk>
References: <Pine.LNX.4.64.1005142127100.28935@ask.diku.dk>
 <Pine.LNX.4.64.1005142210320.28935@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use kstrdup when the goal of an allocation is copy a string into the
allocated region.  Additionally drop the now unused variable len.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression from,to;
expression flag,E1,E2;
statement S;
@@

-  to = kmalloc(strlen(from) + 1,flag);
+  to = kstrdup(from, flag);
   ... when != \(from = E1 \| to = E1 \)
   if (to==NULL || ...) S
   ... when != \(from = E2 \| to = E2 \)
-  strcpy(to, from);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/s390/char/keyboard.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -u -p a/drivers/s390/char/keyboard.c b/drivers/s390/char/keyboard.c
--- a/drivers/s390/char/keyboard.c
+++ b/drivers/s390/char/keyboard.c
@@ -49,7 +49,7 @@ static unsigned char ret_diacr[NR_DEAD] 
 struct kbd_data *
 kbd_alloc(void) {
 	struct kbd_data *kbd;
-	int i, len;
+	int i;
 
 	kbd = kzalloc(sizeof(struct kbd_data), GFP_KERNEL);
 	if (!kbd)
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
