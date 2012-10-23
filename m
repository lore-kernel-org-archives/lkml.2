Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933503Ab2JWT7b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 15:59:31 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:62157 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933486Ab2JWT71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 15:59:27 -0400
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>
Cc: Julia.Lawall@lip6.fr, kernel-janitors@vger.kernel.org,
        Ezequiel Garcia <elezegarcia@gmail.com>,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 21/23] dvb-frontends: Replace memcpy with struct assignment
Date: Tue, 23 Oct 2012 16:57:24 -0300
Message-Id: <1351022246-8201-21-git-send-email-elezegarcia@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1351022246-8201-1-git-send-email-elezegarcia@gmail.com>
References: <1351022246-8201-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This kind of memcpy() is error-prone. Its replacement with a struct
assignment is prefered because it's type-safe and much easier to read.

Found by coccinelle. Hand patched and reviewed.
Tested by compilation only.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier struct_name;
struct struct_name to;
struct struct_name from;
expression E;
@@
-memcpy(&(to), &(from), E);
+to = from;
// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/dvb-frontends/cx24116.c   |    2 +-
 drivers/media/dvb-frontends/drxd_hard.c |    5 ++---
 drivers/media/dvb-frontends/stv0299.c   |    2 +-
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb-frontends/cx24116.c b/drivers/media/dvb-frontends/cx24116.c
index b488791..2916d7c 100644
--- a/drivers/media/dvb-frontends/cx24116.c
+++ b/drivers/media/dvb-frontends/cx24116.c
@@ -819,7 +819,7 @@ static int cx24116_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 static void cx24116_clone_params(struct dvb_frontend *fe)
 {
 	struct cx24116_state *state = fe->demodulator_priv;
-	memcpy(&state->dcur, &state->dnxt, sizeof(state->dcur));
+	state->dcur = state->dnxt;
 }
 
 /* Wait for LNB */
diff --git a/drivers/media/dvb-frontends/drxd_hard.c b/drivers/media/dvb-frontends/drxd_hard.c
index 6d98537..dca1752 100644
--- a/drivers/media/dvb-frontends/drxd_hard.c
+++ b/drivers/media/dvb-frontends/drxd_hard.c
@@ -2963,7 +2963,7 @@ struct dvb_frontend *drxd_attach(const struct drxd_config *config,
 		return NULL;
 	memset(state, 0, sizeof(*state));
 
-	memcpy(&state->ops, &drxd_ops, sizeof(struct dvb_frontend_ops));
+	state->ops = drxd_ops;
 	state->dev = dev;
 	state->config = *config;
 	state->i2c = i2c;
@@ -2974,8 +2974,7 @@ struct dvb_frontend *drxd_attach(const struct drxd_config *config,
 	if (Read16(state, 0, 0, 0) < 0)
 		goto error;
 
-	memcpy(&state->frontend.ops, &drxd_ops,
-	       sizeof(struct dvb_frontend_ops));
+	state->frontend.ops = drxd_ops;
 	state->frontend.demodulator_priv = state;
 	ConfigureMPEGOutput(state, 0);
 	return &state->frontend;
diff --git a/drivers/media/dvb-frontends/stv0299.c b/drivers/media/dvb-frontends/stv0299.c
index 92a6075..b57ecf4 100644
--- a/drivers/media/dvb-frontends/stv0299.c
+++ b/drivers/media/dvb-frontends/stv0299.c
@@ -420,7 +420,7 @@ static int stv0299_send_legacy_dish_cmd (struct dvb_frontend* fe, unsigned long
 
 	do_gettimeofday (&nexttime);
 	if (debug_legacy_dish_switch)
-		memcpy (&tv[0], &nexttime, sizeof (struct timeval));
+		tv[0] = nexttime;
 	stv0299_writeregI (state, 0x0c, reg0x0c | 0x50); /* set LNB to 18V */
 
 	dvb_frontend_sleep_until(&nexttime, 32000);
-- 
1.7.4.4

