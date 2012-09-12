Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608Ab2ILM6q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 08:58:46 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:37861 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758309Ab2ILM4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:56:24 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/8] drivers/media/dvb-frontends/s921.c: Removes useless kfree()
Date: Wed, 12 Sep 2012 14:56:01 +0200
Message-Id: <1347454564-5178-5-git-send-email-peter.senna@gmail.com>
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
 drivers/media/dvb-frontends/s921.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb-frontends/s921.c b/drivers/media/dvb-frontends/s921.c
index cd2288c..a271ac3 100644
--- a/drivers/media/dvb-frontends/s921.c
+++ b/drivers/media/dvb-frontends/s921.c
@@ -487,9 +487,9 @@ struct dvb_frontend *s921_attach(const struct s921_config *config,
 		kzalloc(sizeof(struct s921_state), GFP_KERNEL);
 
 	dprintk("\n");
-	if (state == NULL) {
+	if (!state) {
 		rc("Unable to kzalloc\n");
-		goto rcor;
+		return NULL;
 	}
 
 	/* setup the state */
@@ -502,11 +502,6 @@ struct dvb_frontend *s921_attach(const struct s921_config *config,
 	state->frontend.demodulator_priv = state;
 
 	return &state->frontend;
-
-rcor:
-	kfree(state);
-
-	return NULL;
 }
 EXPORT_SYMBOL(s921_attach);
 

