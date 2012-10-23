Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933410Ab2JWT66 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 15:58:58 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:49915 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933380Ab2JWT6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 15:58:54 -0400
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>
Cc: Julia.Lawall@lip6.fr, kernel-janitors@vger.kernel.org,
        Ezequiel Garcia <elezegarcia@gmail.com>,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 08/23] cx25840: Replace memcpy with struct assignment
Date: Tue, 23 Oct 2012 16:57:11 -0300
Message-Id: <1351022246-8201-8-git-send-email-elezegarcia@gmail.com>
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
 drivers/media/i2c/cx25840/cx25840-ir.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/cx25840/cx25840-ir.c b/drivers/media/i2c/cx25840/cx25840-ir.c
index 38ce76e..9ae977b 100644
--- a/drivers/media/i2c/cx25840/cx25840-ir.c
+++ b/drivers/media/i2c/cx25840/cx25840-ir.c
@@ -1251,13 +1251,11 @@ int cx25840_ir_probe(struct v4l2_subdev *sd)
 		cx25840_write4(ir_state->c, CX25840_IR_IRQEN_REG, 0);
 
 	mutex_init(&ir_state->rx_params_lock);
-	memcpy(&default_params, &default_rx_params,
-		       sizeof(struct v4l2_subdev_ir_parameters));
+	default_params = default_rx_params;
 	v4l2_subdev_call(sd, ir, rx_s_parameters, &default_params);
 
 	mutex_init(&ir_state->tx_params_lock);
-	memcpy(&default_params, &default_tx_params,
-		       sizeof(struct v4l2_subdev_ir_parameters));
+	default_params = default_tx_params;
 	v4l2_subdev_call(sd, ir, tx_s_parameters, &default_params);
 
 	return 0;
-- 
1.7.4.4

