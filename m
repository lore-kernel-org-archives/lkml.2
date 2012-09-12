Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640Ab2ILM7n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 08:59:43 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:64800 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757721Ab2ILM4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:56:20 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 6/8] drivers/media/dvb-frontends/tda665x.c: Removes useless kfree()
Date: Wed, 12 Sep 2012 14:55:59 +0200
Message-Id: <1347454564-5178-3-git-send-email-peter.senna@gmail.com>
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
 drivers/media/dvb-frontends/tda665x.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb-frontends/tda665x.c b/drivers/media/dvb-frontends/tda665x.c
index 2c1c759..63cc123 100644
--- a/drivers/media/dvb-frontends/tda665x.c
+++ b/drivers/media/dvb-frontends/tda665x.c
@@ -228,8 +228,8 @@ struct dvb_frontend *tda665x_attach(struct dvb_frontend *fe,
 	struct dvb_tuner_info *info;
 
 	state = kzalloc(sizeof(struct tda665x_state), GFP_KERNEL);
-	if (state == NULL)
-		goto exit;
+	if (!state)
+		return NULL;
 
 	state->config		= config;
 	state->i2c		= i2c;
@@ -246,10 +246,6 @@ struct dvb_frontend *tda665x_attach(struct dvb_frontend *fe,
 	printk(KERN_DEBUG "%s: Attaching TDA665x (%s) tuner\n", __func__, info->name);
 
 	return fe;
-
-exit:
-	kfree(state);
-	return NULL;
 }
 EXPORT_SYMBOL(tda665x_attach);
 

