Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab1C0P6N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 11:58:13 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40463 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866Ab1C0P6L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 11:58:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:mime-version:content-type:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to:x-mailer;
        b=O3+LEyuf4B032oNMsU3zdYb/92mPTcGby/Wm5I6mz3IjeApOqtPNEzkUdbSbm0kJYB
         1ZNDLGzrQuiif9F2jUzIqszTlQDQBMq5QErpf76Cbm58X69fcbIVsjZu8bNolVeawE5m
         PWiS1oIHhndhvc/ogJXE1WOv+cdP7eFrm/otE=
Subject: [PATCH] w1: Add 1-wire reset and resume API (0xA5)
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=iso-8859-1
From: =?iso-8859-1?Q?Jean-Fran=E7ois_Dagenais?= <jeff.dagenais@gmail.com>
In-Reply-To: <1299879513-14884-1-git-send-email-dagenaisj@sonatest.com>
Date: Sun, 27 Mar 2011 11:58:08 -0400
Cc: johnpol@2ka.mipt.ru
Content-Transfer-Encoding: 8BIT
Message-Id: <0AED457F-1E8B-4558-BCB3-DD5DD2D1821F@gmail.com>
References: <1299879513-14884-1-git-send-email-dagenaisj@sonatest.com>
To: linux-kernel@vger.kernel.org
X-Mailer: Apple Mail (2.1082)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

from: Jean-François Dagenais <jeff.dagenais@gmail.com>

add generic functionnality to w1_io for Resume Command [A5h]
lots of slaves support. It is useful for multi-commands/reset workflows
with the same slave on a multi-slave bus where reset-skip-ROM is
inappropriate.

Signed-off-by: Jean-François Dagenais <jeff.dagenais@gmail.com>
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

