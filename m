Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab2FDU1x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 16:27:53 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47835 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967Ab2FDU1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 16:27:49 -0400
From: Richard Weinberger <richard@nod.at>
To: jslaby@suse.cz
Cc: user-mode-linux-devel@lists.sourceforge.net, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        alan@linux.intel.com, Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 1/6] TTY: um/line, add tty_port
Date: Mon,  4 Jun 2012 22:27:32 +0200
Message-Id: <1338841657-30358-2-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1338841657-30358-1-git-send-email-richard@nod.at>
References: <1338841657-30358-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

And use count from there.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: user-mode-linux-devel@lists.sourceforge.net
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/drivers/line.c |    7 ++++---
 arch/um/drivers/line.h |    2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
index acfd0e0..482a7bd 100644
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -404,7 +404,7 @@ int line_open(struct line *lines, struct tty_struct *tty)
 		goto out_unlock;
 
 	err = 0;
-	if (line->count++)
+	if (line->port.count++)
 		goto out_unlock;
 
 	BUG_ON(tty->driver_data);
@@ -446,7 +446,7 @@ void line_close(struct tty_struct *tty, struct file * filp)
 	mutex_lock(&line->count_lock);
 	BUG_ON(!line->valid);
 
-	if (--line->count)
+	if (--line->port.count)
 		goto out_unlock;
 
 	line->tty = NULL;
@@ -478,7 +478,7 @@ int setup_one_line(struct line *lines, int n, char *init,
 
 	mutex_lock(&line->count_lock);
 
-	if (line->count) {
+	if (line->port.count) {
 		*error_out = "Device is already open";
 		goto out;
 	}
@@ -663,6 +663,7 @@ int register_lines(struct line_driver *line_driver,
 	driver->init_termios = tty_std_termios;
 	
 	for (i = 0; i < nlines; i++) {
+		tty_port_init(&lines[i].port);
 		spin_lock_init(&lines[i].lock);
 		mutex_init(&lines[i].count_lock);
 		lines[i].driver = line_driver;
diff --git a/arch/um/drivers/line.h b/arch/um/drivers/line.h
index 0a18347..0e06a1f 100644
--- a/arch/um/drivers/line.h
+++ b/arch/um/drivers/line.h
@@ -32,9 +32,9 @@ struct line_driver {
 };
 
 struct line {
+	struct tty_port port;
 	struct tty_struct *tty;
 	struct mutex count_lock;
-	unsigned long count;
 	int valid;
 
 	char *init_str;
-- 
1.7.7.3

