Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758532Ab2ILM50 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 08:57:26 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50909 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758327Ab2ILM40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:56:26 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/8] drivers/media/dvb-frontends/s5h1432.c: Removes useless kfree()
Date: Wed, 12 Sep 2012 14:56:02 +0200
Message-Id: <1347454564-5178-6-git-send-email-peter.senna@gmail.com>
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
 drivers/media/dvb-frontends/s5h1432.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb-frontends/s5h1432.c b/drivers/media/dvb-frontends/s5h1432.c
index 8352ce1..6ec16a2 100644
--- a/drivers/media/dvb-frontends/s5h1432.c
+++ b/drivers/media/dvb-frontends/s5h1432.c
@@ -351,8 +351,8 @@ struct dvb_frontend *s5h1432_attach(const struct s5h1432_config *config,
 	printk(KERN_INFO " Enter s5h1432_attach(). attach success!\n");
 	/* allocate memory for the internal state */
 	state = kmalloc(sizeof(struct s5h1432_state), GFP_KERNEL);
-	if (state == NULL)
-		goto error;
+	if (!state)
+		return NULL;
 
 	/* setup the state */
 	state->config = config;
@@ -367,10 +367,6 @@ struct dvb_frontend *s5h1432_attach(const struct s5h1432_config *config,
 	state->frontend.demodulator_priv = state;
 
 	return &state->frontend;
-
-error:
-	kfree(state);
-	return NULL;
 }
 EXPORT_SYMBOL(s5h1432_attach);
 

