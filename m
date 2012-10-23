Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933485Ab2JWT71 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 15:59:27 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:49915 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757516Ab2JWT7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 15:59:19 -0400
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>
Cc: Julia.Lawall@lip6.fr, kernel-janitors@vger.kernel.org,
        Ezequiel Garcia <elezegarcia@gmail.com>,
        Andy Walls <awalls@md.metrocast.net>,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 18/23] cx18: Replace memcpy with struct assignment
Date: Tue, 23 Oct 2012 16:57:21 -0300
Message-Id: <1351022246-8201-18-git-send-email-elezegarcia@gmail.com>
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

Cc: Andy Walls <awalls@md.metrocast.net>
Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/pci/cx18/cx18-i2c.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/pci/cx18/cx18-i2c.c b/drivers/media/pci/cx18/cx18-i2c.c
index 51609d5..930d40f 100644
--- a/drivers/media/pci/cx18/cx18-i2c.c
+++ b/drivers/media/pci/cx18/cx18-i2c.c
@@ -240,15 +240,13 @@ int init_cx18_i2c(struct cx18 *cx)
 
 	for (i = 0; i < 2; i++) {
 		/* Setup algorithm for adapter */
-		memcpy(&cx->i2c_algo[i], &cx18_i2c_algo_template,
-			sizeof(struct i2c_algo_bit_data));
+		cx->i2c_algo[i] = cx18_i2c_algo_template;
 		cx->i2c_algo_cb_data[i].cx = cx;
 		cx->i2c_algo_cb_data[i].bus_index = i;
 		cx->i2c_algo[i].data = &cx->i2c_algo_cb_data[i];
 
 		/* Setup adapter */
-		memcpy(&cx->i2c_adap[i], &cx18_i2c_adap_template,
-			sizeof(struct i2c_adapter));
+		cx->i2c_adap[i] = cx18_i2c_adap_template;
 		cx->i2c_adap[i].algo_data = &cx->i2c_algo[i];
 		sprintf(cx->i2c_adap[i].name + strlen(cx->i2c_adap[i].name),
 				" #%d-%d", cx->instance, i);
-- 
1.7.4.4

