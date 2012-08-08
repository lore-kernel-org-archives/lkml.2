Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758767Ab2HHPQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 11:16:20 -0400
Received: from mail.ispras.ru ([83.149.199.43]:44344 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758663Ab2HHPQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 11:16:18 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Kurt Van Dijck <kurt.van.dijck@eia.be>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@ispras.ru
Subject: [PATCH] can/softing: Fix potential memory leak in softing_load_fw()
Date: Wed,  8 Aug 2012 19:15:01 +0400
Message-Id: <1344438901-25005-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not leak memory by updating pointer with potentially NULL realloc return value.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/net/can/softing/softing_fw.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/softing/softing_fw.c b/drivers/net/can/softing/softing_fw.c
index 3105961..b595d34 100644
--- a/drivers/net/can/softing/softing_fw.c
+++ b/drivers/net/can/softing/softing_fw.c
@@ -150,7 +150,7 @@ int softing_load_fw(const char *file, struct softing *card,
 	const uint8_t *mem, *end, *dat;
 	uint16_t type, len;
 	uint32_t addr;
-	uint8_t *buf = NULL;
+	uint8_t *buf = NULL, *new_buf;
 	int buflen = 0;
 	int8_t type_end = 0;
 
@@ -199,11 +199,12 @@ int softing_load_fw(const char *file, struct softing *card,
 		if (len > buflen) {
 			/* align buflen */
 			buflen = (len + (1024-1)) & ~(1024-1);
-			buf = krealloc(buf, buflen, GFP_KERNEL);
-			if (!buf) {
+			new_buf = krealloc(buf, buflen, GFP_KERNEL);
+			if (!new_buf) {
 				ret = -ENOMEM;
 				goto failed;
 			}
+			buf = new_buf;
 		}
 		/* verify record data */
 		memcpy_fromio(buf, &dpram[addr + offset], len);
-- 
1.7.9.5

