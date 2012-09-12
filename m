Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760049Ab2ILPIk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 11:08:40 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:65276 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759898Ab2ILPHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 11:07:16 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kernel-janitors@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/9] drivers/staging/gdm72xx/gdm_sdio.c: Remove useless kfree
Date: Wed, 12 Sep 2012 17:06:44 +0200
Message-Id: <1347462407-13499-6-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

Remove useless kfree() and clean up code related to the removal.

The semantic patch that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
position p1,p2;
expression x;
@@

if (x@p1 == NULL) { ... kfree@p2(x); ... return ...; }

@unchanged exists@
position r.p1,r.p2;
expression e <= r.x,x,e1;
iterator I;
statement S;
@@

if (x@p1 == NULL) { ... when != I(x,...) S
                        when != e = e1
                        when != e += e1
                        when != e -= e1
                        when != ++e
                        when != --e
                        when != e++
                        when != e--
                        when != &e
   kfree@p2(x); ... return ...; }

@ok depends on unchanged exists@
position any r.p1;
position r.p2;
expression x;
@@

... when != true x@p1 == NULL
kfree@p2(x);

@depends on !ok && unchanged@
position r.p2;
expression x;
@@

*kfree@p2(x);
// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/staging/gdm72xx/gdm_sdio.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_sdio.c b/drivers/staging/gdm72xx/gdm_sdio.c
index f824290..a0621d9 100644
--- a/drivers/staging/gdm72xx/gdm_sdio.c
+++ b/drivers/staging/gdm72xx/gdm_sdio.c
@@ -94,17 +94,14 @@ static struct sdio_rx *alloc_rx_struct(struct rx_cxt *rx)
 	struct sdio_rx *r = NULL;
 
 	r = kmalloc(sizeof(*r), GFP_ATOMIC);
-	if (r == NULL)
-		goto out;
+	if (!r)
+		return NULL;
 
 	memset(r, 0, sizeof(*r));
 
 	r->rx_cxt = rx;
 
 	return r;
-out:
-	kfree(r);
-	return NULL;
 }
 
 static void free_rx_struct(struct sdio_rx *r)

