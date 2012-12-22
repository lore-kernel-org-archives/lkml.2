Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761Ab2LVQVC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 11:21:02 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:41242 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab2LVQVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 11:21:00 -0500
From: Cong Ding <dinggnu@gmail.com>
To: Steve Underwood <steveu@coppice.org>, David Rowe <david@rowetel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jesper Juhl <jj@chaosbits.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] staging: echo.c: fix memory leakage
Date: Sat, 22 Dec 2012 17:12:26 +0100
Message-Id: <1356192750-13370-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we should check the return value of calling function fir16_create(): a NULL
value means the memory allocation fails.

this patch also cleans up the error handling in function function oslec_create()

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 drivers/staging/echo/echo.c |   39 ++++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/echo/echo.c b/drivers/staging/echo/echo.c
index ca87ce9..0c24a10 100644
--- a/drivers/staging/echo/echo.c
+++ b/drivers/staging/echo/echo.c
@@ -230,6 +230,7 @@ struct oslec_state *oslec_create(int len, int adaption_mode)
 {
 	struct oslec_state *ec;
 	int i;
+	const int16_t *history;
 
 	ec = kzalloc(sizeof(*ec), GFP_KERNEL);
 	if (!ec)
@@ -239,15 +240,22 @@ struct oslec_state *oslec_create(int len, int adaption_mode)
 	ec->log2taps = top_bit(len);
 	ec->curr_pos = ec->taps - 1;
 
-	for (i = 0; i < 2; i++) {
-		ec->fir_taps16[i] =
-		    kcalloc(ec->taps, sizeof(int16_t), GFP_KERNEL);
-		if (!ec->fir_taps16[i])
-			goto error_oom;
-	}
+	ec->fir_taps16[0] =
+	    kcalloc(ec->taps, sizeof(int16_t), GFP_KERNEL);
+	if (!ec->fir_taps16[0])
+		goto error_oom_0;
+
+	ec->fir_taps16[1] =
+	    kcalloc(ec->taps, sizeof(int16_t), GFP_KERNEL);
+	if (!ec->fir_taps16[1])
+		goto error_oom_1;
 
-	fir16_create(&ec->fir_state, ec->fir_taps16[0], ec->taps);
-	fir16_create(&ec->fir_state_bg, ec->fir_taps16[1], ec->taps);
+	history = fir16_create(&ec->fir_state, ec->fir_taps16[0], ec->taps);
+	if (!history)
+		goto error_state;
+	history = fir16_create(&ec->fir_state_bg, ec->fir_taps16[1], ec->taps);
+	if (!history)
+		goto error_state_bg;
 
 	for (i = 0; i < 5; i++)
 		ec->xvtx[i] = ec->yvtx[i] = ec->xvrx[i] = ec->yvrx[i] = 0;
@@ -257,7 +265,7 @@ struct oslec_state *oslec_create(int len, int adaption_mode)
 
 	ec->snapshot = kcalloc(ec->taps, sizeof(int16_t), GFP_KERNEL);
 	if (!ec->snapshot)
-		goto error_oom;
+		goto error_snap;
 
 	ec->cond_met = 0;
 	ec->Pstates = 0;
@@ -270,10 +278,15 @@ struct oslec_state *oslec_create(int len, int adaption_mode)
 
 	return ec;
 
-error_oom:
-	for (i = 0; i < 2; i++)
-		kfree(ec->fir_taps16[i]);
-
+error_snap:
+	fir16_free(&ec->fir_state_bg);
+error_state_bg:
+	fir16_free(&ec->fir_state);
+error_state:
+	kfree(ec->fir_taps16[1]);
+error_oom_1:
+	kfree(ec->fir_taps16[0]);
+error_oom_0:
 	kfree(ec);
 	return NULL;
 }
-- 
1.7.10.4

