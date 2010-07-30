Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760710Ab0G3TVX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 15:21:23 -0400
Received: from mail.windriver.com ([147.11.1.11]:33855 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760625Ab0G3TSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 15:18:04 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu,
        Jason Wessel <jason.wessel@windriver.com>,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: [PATCH 14/15] sunhv,kgdboc: Add sunhv console poll hooks for kgdboc
Date: Fri, 30 Jul 2010 14:17:35 -0500
Message-Id: <1280517456-1167-15-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1280517456-1167-1-git-send-email-jason.wessel@windriver.com>
References: <1280517456-1167-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 30 Jul 2010 19:17:51.0299 (UTC) FILETIME=[E74C7930:01CB301B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the CONSOLE_POLL hooks for use with kgdboc on the sunhv uart
driver.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
CC: David S. Miller <davem@davemloft.net>
CC: sparclinux@vger.kernel.org
---
 drivers/serial/sunhv.c |   51 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/sunhv.c b/drivers/serial/sunhv.c
index 890f917..bab9515 100644
--- a/drivers/serial/sunhv.c
+++ b/drivers/serial/sunhv.c
@@ -309,6 +309,53 @@ static void sunhv_break_ctl(struct uart_port *port, int break_state)
 	}
 }
 
+#ifdef CONFIG_CONSOLE_POLL
+/*
+ * Console polling routines for writing and reading from the uart while
+ * in an interrupt or debug context.
+ */
+
+static int poll_buf[PAGE_SIZE];
+static int poll_buf_cnt;
+static int poll_buf_idx;
+
+static int sunhv_get_poll_char(struct uart_port *port)
+{
+	unsigned long bytes_read;
+	long stat;
+	unsigned long ra;
+	int i;
+
+	if (poll_buf_idx < poll_buf_cnt)
+		return poll_buf[poll_buf_idx++];
+
+	ra = __pa(con_read_page);
+	stat = sun4v_con_read(ra, PAGE_SIZE, &bytes_read);
+	if (stat == HV_EOK) {
+		poll_buf_idx = 1;
+		poll_buf_cnt = bytes_read;
+		for (i = 0; i < bytes_read; i++)
+			poll_buf[i] = con_read_page[i];
+		return poll_buf[0];
+	}
+
+	return NO_POLL_CHAR;
+}
+
+
+static void sunhv_put_poll_char(struct uart_port *port,
+			 unsigned char c)
+{
+	while (1) {
+		long status = sun4v_con_putchar(c);
+		if (status == HV_EOK)
+			break;
+		udelay(1);
+	}
+}
+
+#endif /* CONFIG_CONSOLE_POLL */
+
 /* port->lock is not held.  */
 static int sunhv_startup(struct uart_port *port)
 {
@@ -388,6 +435,10 @@ static struct uart_ops sunhv_pops = {
 	.request_port	= sunhv_request_port,
 	.config_port	= sunhv_config_port,
 	.verify_port	= sunhv_verify_port,
+#ifdef CONFIG_CONSOLE_POLL
+	.poll_get_char = sunhv_get_poll_char,
+	.poll_put_char = sunhv_put_poll_char,
+#endif
 };
 
 static struct uart_driver sunhv_reg = {
-- 
1.6.4.rc1

