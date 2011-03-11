Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847Ab1CKVjT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 16:39:19 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41566 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028Ab1CKVip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 16:38:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=NjYaD3I1QeMfH7GdIKlN4DBbplsfzTgSE7SYrawBqWxnnDnGon3KwduxJh24dpKqDk
         OgDhL0LUkRsgGb2S625fIEBRliB4KonfA+tHwJBMllEC71Ylv7n5CtSfCBakyXQusYe9
         tYvD1nZX8Zyuh+VBfpdaVB0A8KAV0XHUQwAPo=
From: "=?UTF-8?q?Jean-Fran=C3=A7ois=20Dagenais?=" <jeff.dagenais@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: johnpol@2ka.mipt.ru,
        =?UTF-8?q?Jean-Fran=C3=A7ois=20Dagenais?= <dagenaisj@sonatest.com>
Subject: [w1 PATCHES 1/3] Add 1-wire (w1) reset and resume command API support
Date: Fri, 11 Mar 2011 16:38:31 -0500
Message-Id: <1299879513-14884-2-git-send-email-dagenaisj@sonatest.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1299879513-14884-1-git-send-email-dagenaisj@sonatest.com>
References: <1299879513-14884-1-git-send-email-dagenaisj@sonatest.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jean-François Dagenais <dagenaisj@sonatest.com>
---
:100644 100644 d8a9709... f804eba... M	drivers/w1/w1.h
:100644 100644 3ebe972... 8e8b64c... M	drivers/w1/w1_io.c
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
 
@@ -213,6 +214,7 @@ void w1_write_block(struct w1_master *, const u8 *, int);
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
+ * If the bus has only one slave, traditionnaly the match ROM is skipped
+ * and a "SKIP ROM" is done for efficiency. On multi-slave busses, this
+ * doesn't work of course, but the resume command is the next best thing.
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
  * Put out a strong pull-up of the specified duration after the next write
  * operation.  Not all hardware supports strong pullups.  Hardware that
  * doesn't support strong pullups will sleep for the given time after the
-- 
1.7.4.1

