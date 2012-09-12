Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758349Ab2ILM40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 08:56:26 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:37861 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757566Ab2ILM4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:56:18 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 8/8] drivers/media/tuners/mt2063.c: Removes useless kfree()
Date: Wed, 12 Sep 2012 14:55:57 +0200
Message-Id: <1347454564-5178-1-git-send-email-peter.senna@gmail.com>
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
 drivers/media/tuners/mt2063.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/tuners/mt2063.c b/drivers/media/tuners/mt2063.c
index 0ed9091..620c4fa 100644
--- a/drivers/media/tuners/mt2063.c
+++ b/drivers/media/tuners/mt2063.c
@@ -2249,8 +2249,8 @@ struct dvb_frontend *mt2063_attach(struct dvb_frontend *fe,
 	dprintk(2, "\n");
 
 	state = kzalloc(sizeof(struct mt2063_state), GFP_KERNEL);
-	if (state == NULL)
-		goto error;
+	if (!state)
+		return NULL;
 
 	state->config = config;
 	state->i2c = i2c;
@@ -2261,10 +2261,6 @@ struct dvb_frontend *mt2063_attach(struct dvb_frontend *fe,
 
 	printk(KERN_INFO "%s: Attaching MT2063\n", __func__);
 	return fe;
-
-error:
-	kfree(state);
-	return NULL;
 }
 EXPORT_SYMBOL_GPL(mt2063_attach);
 

