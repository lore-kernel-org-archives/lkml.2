Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169Ab2FDLk3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 07:40:29 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:44987 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097Ab2FDLfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 07:35:44 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        user-mode-linux-devel@lists.sourceforge.net
Subject: [PATCH 13/24] TTY: um/line, use tty from tty_port
Date: Mon,  4 Jun 2012 13:35:27 +0200
Message-Id: <1338809738-18967-14-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.10.3
In-Reply-To: <1338809738-18967-1-git-send-email-jslaby@suse.cz>
References: <1338809738-18967-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This means switching to the tty refcounted model so that we will not
race with interrupts.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: user-mode-linux-devel@lists.sourceforge.net
---
 arch/um/drivers/chan_kern.c |    4 +++-
 arch/um/drivers/line.c      |   25 ++++++++++++++++++-------
 arch/um/drivers/line.h      |    1 -
 3 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/arch/um/drivers/chan_kern.c b/arch/um/drivers/chan_kern.c
index 45e248c..87eebfe 100644
--- a/arch/um/drivers/chan_kern.c
+++ b/arch/um/drivers/chan_kern.c
@@ -150,9 +150,11 @@ void chan_enable_winch(struct chan *chan, struct tty_struct *tty)
 static void line_timer_cb(struct work_struct *work)
 {
 	struct line *line = container_of(work, struct line, task.work);
+	struct tty_struct *tty = tty_port_tty_get(&line->port);
 
 	if (!line->throttled)
-		chan_interrupt(line, line->tty, line->driver->read_irq);
+		chan_interrupt(line, tty, line->driver->read_irq);
+	tty_kref_put(tty);
 }
 
 int enable_chan(struct line *line)
diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
index 482a7bd..fb6e4ea 100644
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -19,9 +19,11 @@ static irqreturn_t line_interrupt(int irq, void *data)
 {
 	struct chan *chan = data;
 	struct line *line = chan->line;
+	struct tty_struct *tty = tty_port_tty_get(&line->port);
 
 	if (line)
-		chan_interrupt(line, line->tty, irq);
+		chan_interrupt(line, tty, irq);
+	tty_kref_put(tty);
 	return IRQ_HANDLED;
 }
 
@@ -333,7 +335,7 @@ static irqreturn_t line_write_interrupt(int irq, void *data)
 {
 	struct chan *chan = data;
 	struct line *line = chan->line;
-	struct tty_struct *tty = line->tty;
+	struct tty_struct *tty;
 	int err;
 
 	/*
@@ -352,10 +354,13 @@ static irqreturn_t line_write_interrupt(int irq, void *data)
 	}
 	spin_unlock(&line->lock);
 
+	tty = tty_port_tty_get(&line->port);
 	if (tty == NULL)
 		return IRQ_NONE;
 
 	tty_wakeup(tty);
+	tty_kref_put(tty);
+
 	return IRQ_HANDLED;
 }
 
@@ -409,7 +414,7 @@ int line_open(struct line *lines, struct tty_struct *tty)
 
 	BUG_ON(tty->driver_data);
 	tty->driver_data = line;
-	line->tty = tty;
+	tty_port_tty_set(&line->port, tty);
 
 	err = enable_chan(line);
 	if (err) /* line_close() will be called by our caller */
@@ -449,7 +454,7 @@ void line_close(struct tty_struct *tty, struct file * filp)
 	if (--line->port.count)
 		goto out_unlock;
 
-	line->tty = NULL;
+	tty_port_tty_set(&line->port, NULL);
 	tty->driver_data = NULL;
 
 	if (line->sigio) {
@@ -610,9 +615,15 @@ int line_get_config(char *name, struct line *lines, unsigned int num, char *str,
 	mutex_lock(&line->count_lock);
 	if (!line->valid)
 		CONFIG_CHUNK(str, size, n, "none", 1);
-	else if (line->tty == NULL)
-		CONFIG_CHUNK(str, size, n, line->init_str, 1);
-	else n = chan_config_string(line, str, size, error_out);
+	else {
+		struct tty_struct *tty = tty_port_tty_get(&line->port);
+		if (tty == NULL) {
+			CONFIG_CHUNK(str, size, n, line->init_str, 1);
+		} else {
+			n = chan_config_string(line, str, size, error_out);
+			tty_kref_put(tty);
+		}
+	}
 	mutex_unlock(&line->count_lock);
 
 	return n;
diff --git a/arch/um/drivers/line.h b/arch/um/drivers/line.h
index 0e06a1f..5b3d4fb 100644
--- a/arch/um/drivers/line.h
+++ b/arch/um/drivers/line.h
@@ -33,7 +33,6 @@ struct line_driver {
 
 struct line {
 	struct tty_port port;
-	struct tty_struct *tty;
 	struct mutex count_lock;
 	int valid;
 
-- 
1.7.10.3


