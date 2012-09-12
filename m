Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758394Ab2ILM43 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 08:56:29 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38091 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758341Ab2ILM40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:56:26 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/8] drivers/media/dvb-frontends/lg2160.c: Removes useless kfree()
Date: Wed, 12 Sep 2012 14:56:03 +0200
Message-Id: <1347454564-5178-7-git-send-email-peter.senna@gmail.com>
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
 drivers/media/dvb-frontends/lg2160.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb-frontends/lg2160.c b/drivers/media/dvb-frontends/lg2160.c
index cc11260..5fd14f8 100644
--- a/drivers/media/dvb-frontends/lg2160.c
+++ b/drivers/media/dvb-frontends/lg2160.c
@@ -1421,8 +1421,8 @@ struct dvb_frontend *lg2160_attach(const struct lg2160_config *config,
 	       config ? config->i2c_addr : 0);
 
 	state = kzalloc(sizeof(struct lg216x_state), GFP_KERNEL);
-	if (state == NULL)
-		goto fail;
+	if (!state)
+		return NULL;
 
 	state->cfg = config;
 	state->i2c_adap = i2c_adap;
@@ -1449,10 +1449,6 @@ struct dvb_frontend *lg2160_attach(const struct lg2160_config *config,
 	state->frontend.dtv_property_cache.atscmh_parade_id = 1;
 
 	return &state->frontend;
-fail:
-	lg_warn("unable to detect LG216x hardware\n");
-	kfree(state);
-	return NULL;
 }
 EXPORT_SYMBOL(lg2160_attach);
 

