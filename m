Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282Ab0ENTbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 15:31:18 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:54933 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759411Ab0ENTbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 15:31:12 -0400
Date: Fri, 14 May 2010 21:31:07 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Neil Brown <neilb@suse.de>, dm-devel@redhat.com,
       linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 9/10] drivers/md: Use kstrdup
Message-ID: <Pine.LNX.4.64.1005142130490.28935@ask.diku.dk>
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
 drivers/md/dm-crypt.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -u -p a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1168,12 +1168,11 @@ static int crypt_ctr(struct dm_target *t
 	if (ivmode && cc->iv_gen_ops) {
 		if (ivopts)
 			*(ivopts - 1) = ':';
-		cc->iv_mode = kmalloc(strlen(ivmode) + 1, GFP_KERNEL);
+		cc->iv_mode = kstrdup(ivmode, GFP_KERNEL);
 		if (!cc->iv_mode) {
 			ti->error = "Error kmallocing iv_mode string";
 			goto bad_ivmode_string;
 		}
-		strcpy(cc->iv_mode, ivmode);
 	} else
 		cc->iv_mode = NULL;
 
