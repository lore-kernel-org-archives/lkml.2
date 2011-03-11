Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167Ab1CKRXp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 12:23:45 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:54486 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab1CKRXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 12:23:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=WA/eo6WjrkgCNRn3TcbpFMU0Vd4LBmABzdLCB46Liscm/Q1Ax0T5sett7/Ekr8N8mc
         ZG6bsMlt8jl6L7MUuNoocg45vl4kArYMacbfamhI7Eu2LfTMngx3EOPs0r9bqb8axFUn
         yUlt9anuxBLyaXQAxHHyxxzWZqwXAYFzL/RWQ=
Subject: [PATCH] Add 1-wire (w1) reset and resume command API support
From: Jean-Francois Dagenais <jeff.dagenais@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Mar 2011 12:23:41 -0500
Message-ID: <1299864221.8754.11.camel@jfddesk>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed for my next patch about DS2408

>From aba11ba9d50c0fa7a29c81ecb81c13afb986b042 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Jean-Fran=C3=A7ois=20Dagenais?= <dagenaisj@sonatest.com>
Date: Thu, 10 Mar 2011 11:04:16 -0500
Subject: [PATCH] Add 1-wire (w1) reset and resume command API support
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: johnpol@2ka.mipt.ru
Cc: linux-kernel@vger.kernel.org

Signed-off-by: Jean-François Dagenais <dagenaisj@sonatest.com>
---
 drivers/w1/w1.h    |    2 ++
 drivers/w1/w1_io.c |   26 ++++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/w1/w1.h b/drivers/w1/w1.h
index d8a9709..f804eba 100644
--- a/drivers/w1/w1.h
+++ b/drivers/w1/w1.h
@@ -55,6 +55,7 @@ struct w1_reg_num
 #define W1_READ_ROM		0x33
 #define W1_READ_PSUPPLY		0xB4
 #define W1_MATCH_ROM		0x55
+#define W1_RESUME_CMD		0xA5
 
 #define W1_SLAVE_ACTIVE		0
 
@@ -213,6 +214,7 @@ void w1_write_block(struct w1_master *, const u8 *,
int);
 void w1_touch_block(struct w1_master *, u8 *, int);
 u8 w1_read_block(struct w1_master *, u8 *, int);
 int w1_reset_select_slave(struct w1_slave *sl);
+int w1_reset_resume_command(struct w1_master *);
 void w1_next_pullup(struct w1_master *, int);
 
 static inline struct w1_slave* dev_to_w1_slave(struct device *dev)
diff --git a/drivers/w1/w1_io.c b/drivers/w1/w1_io.c
index 3ebe972..8e8b64c 100644
--- a/drivers/w1/w1_io.c
+++ b/drivers/w1/w1_io.c
@@ -390,6 +390,32 @@ int w1_reset_select_slave(struct w1_slave *sl)
 EXPORT_SYMBOL_GPL(w1_reset_select_slave);
 
 /**
+ * When the workflow with a slave amongst many requires several
+ * successive commands a reset between each, this function is similar
+ * to doing a reset then a match ROM for the last matched ROM. The
+ * advantage being that the matched ROM step is skipped in favor of the
+ * resume command. The slave must support the command of course.
+ *
+ * If the bus has only one slave, traditionnaly the match ROM is
skipped
+ * and a "SKIP ROM" is done for efficiency. On multi-slave busses, this
+ * doesn't work of course, but the resume command is the next best
thing.
+ *
+ * The w1 master lock must be held.
+ *
+ * @param dev     the master device
+ */
+int w1_reset_resume_command(struct w1_master *dev)
+{
+	if (w1_reset_bus(dev))
+		return -1;
+
+	/* This will make only the last matched slave perform a skip ROM. */
+	w1_write_8(dev, W1_RESUME_CMD);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(w1_reset_resume_command);
+
+/**
  * Put out a strong pull-up of the specified duration after the next
write
  * operation.  Not all hardware supports strong pullups.  Hardware that
  * doesn't support strong pullups will sleep for the given time after
the
-- 
1.7.4.1


