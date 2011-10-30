Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934268Ab1J3QiR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 12:38:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:41901 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934217Ab1J3QiL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 12:38:11 -0400
Date: Sun, 30 Oct 2011 09:41:42 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: gregkh@suse.de
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] tty: make the ptmx_fops initialized at compile time
Message-ID: <20111030094142.06da0eb6@infradead.org>
In-Reply-To: <20111030094038.7046d529@infradead.org>
References: <20111030094038.7046d529@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 0d4c4ba964e65485fe87c4ce439522588956133c Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sat, 29 Oct 2011 10:43:57 -0700
Subject: [PATCH 2/3] tty: make the ptmx_fops initialized at compile time

Now that the tty file operations functions are no longer static,
the pty code can do compile time initialization of the ptmx_fops
struct, which then also allows it to be marked "const".

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 drivers/tty/pty.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index e809e9d..54e0e56 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -713,7 +713,18 @@ out:
 	return retval;
 }
 
-static struct file_operations ptmx_fops;
+static const struct file_operations ptmx_fops = 
+{
+	.llseek		= no_llseek,
+	.read		= tty_read,
+	.write		= tty_write,
+	.poll		= tty_poll,
+	.unlocked_ioctl	= tty_ioctl,
+	.compat_ioctl	= tty_compat_ioctl,
+	.open		= ptmx_open,
+	.release	= tty_release,
+	.fasync		= tty_fasync,
+};
 
 static void __init unix98_pty_init(void)
 {
@@ -767,9 +778,6 @@ static void __init unix98_pty_init(void)
 	register_sysctl_table(pty_root_table);
 
 	/* Now create the /dev/ptmx special device */
-	tty_default_fops(&ptmx_fops);
-	ptmx_fops.open = ptmx_open;
-
 	cdev_init(&ptmx_cdev, &ptmx_fops);
 	if (cdev_add(&ptmx_cdev, MKDEV(TTYAUX_MAJOR, 2), 1) ||
 	    register_chrdev_region(MKDEV(TTYAUX_MAJOR, 2), 1, "/dev/ptmx") < 0)
-- 
1.7.6

