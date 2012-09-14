Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758817Ab2INIQv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 04:16:51 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50623 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755710Ab2INIP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 04:15:28 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: gregkh@linuxfoundation.org, wharms@bfs.de, kernel-janitors@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/9] drivers/staging/gdm72xx/gdm_sdio.c: Remove useless kfree
Date: Fri, 14 Sep 2012 10:15:18 +0200
Message-Id: <1347610518-3099-1-git-send-email-peter.senna@gmail.com>
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
 drivers/staging/gdm72xx/gdm_sdio.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_sdio.c b/drivers/staging/gdm72xx/gdm_sdio.c
index f824290..f13dcbf 100644
--- a/drivers/staging/gdm72xx/gdm_sdio.c
+++ b/drivers/staging/gdm72xx/gdm_sdio.c
@@ -93,18 +93,13 @@ static struct sdio_rx *alloc_rx_struct(struct rx_cxt *rx)
 {
 	struct sdio_rx *r = NULL;
 
-	r = kmalloc(sizeof(*r), GFP_ATOMIC);
-	if (r == NULL)
-		goto out;
-
-	memset(r, 0, sizeof(*r));
+	r = kzalloc(sizeof(*r), GFP_ATOMIC);
+	if (!r)
+		return NULL;
 
 	r->rx_cxt = rx;
 
 	return r;
-out:
-	kfree(r);
-	return NULL;
 }
 
 static void free_rx_struct(struct sdio_rx *r)

