Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab0EOVUR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 17:20:17 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:51382 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755968Ab0EOVUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 17:20:12 -0400
Date: Sat, 15 May 2010 23:20:07 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
       linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 23/37] drivers/s390/char: Use kmemdup
Message-ID: <Pine.LNX.4.64.1005152319490.21345@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use kmemdup when some other buffer is immediately copied into the
allocated region.

A simplified version of the semantic patch that makes this change is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression from,to,size,flag;
statement S;
@@

-  to = \(kmalloc\|kzalloc\)(size,flag);
+  to = kmemdup(from,size,flag);
   if (to==NULL || ...) S
-  memcpy(to, from, size);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/s390/char/keyboard.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -u -p a/drivers/s390/char/keyboard.c b/drivers/s390/char/keyboard.c
--- a/drivers/s390/char/keyboard.c
+++ b/drivers/s390/char/keyboard.c
@@ -59,12 +59,11 @@ kbd_alloc(void) {
 		goto out_kbd;
 	for (i = 0; i < ARRAY_SIZE(key_maps); i++) {
 		if (key_maps[i]) {
-			kbd->key_maps[i] =
-				kmalloc(sizeof(u_short)*NR_KEYS, GFP_KERNEL);
+			kbd->key_maps[i] = kmemdup(key_maps[i],
+						   sizeof(u_short) * NR_KEYS,
+						   GFP_KERNEL);
 			if (!kbd->key_maps[i])
 				goto out_maps;
-			memcpy(kbd->key_maps[i], key_maps[i],
-			       sizeof(u_short)*NR_KEYS);
 		}
 	}
 	kbd->func_table = kzalloc(sizeof(func_table), GFP_KERNEL);
@@ -83,12 +82,11 @@ kbd_alloc(void) {
 		kzalloc(sizeof(fn_handler_fn *) * NR_FN_HANDLER, GFP_KERNEL);
 	if (!kbd->fn_handler)
 		goto out_func;
-	kbd->accent_table =
-		kmalloc(sizeof(struct kbdiacruc)*MAX_DIACR, GFP_KERNEL);
+	kbd->accent_table = kmemdup(accent_table,
+				    sizeof(struct kbdiacruc) * MAX_DIACR,
+				    GFP_KERNEL);
 	if (!kbd->accent_table)
 		goto out_fn_handler;
-	memcpy(kbd->accent_table, accent_table,
-	       sizeof(struct kbdiacruc)*MAX_DIACR);
 	kbd->accent_table_size = accent_table_size;
 	return kbd;
 
