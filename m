Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233Ab2GQWkJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 18:40:09 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:39618 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932202Ab2GQWkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 18:40:04 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 16/17] um: remove IRQF_SAMPLE_RANDOM which is now a no-op
Date: Tue, 17 Jul 2012 17:32:35 -0400
Message-Id: <1342560756-18737-17-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.11.1.108.gb129051
In-Reply-To: <1342560756-18737-1-git-send-email-tytso@mit.edu>
References: <1342560756-18737-1-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the changes in the random tree, IRQF_SAMPLE_RANDOM is now a
no-op; interrupt randomness is now collected unconditionally in a very
low-overhead fashion; see commit 775f4b297b.  The IRQF_SAMPLE_RANDOM
flag was scheduled to be removed in 2009 on the
feature-removal-schedule, so this patch is preparation for the final
removal of this flag.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
---
 arch/um/drivers/line.c          | 13 ++++++-------
 arch/um/drivers/mconsole_kern.c |  3 +--
 arch/um/drivers/port_kern.c     |  6 ++----
 arch/um/drivers/random.c        |  3 +--
 arch/um/drivers/xterm_kern.c    |  3 +--
 arch/um/kernel/sigio.c          |  3 +--
 6 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
index acfd0e0..ac9d25c 100644
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -362,18 +362,18 @@ static irqreturn_t line_write_interrupt(int irq, void *data)
 int line_setup_irq(int fd, int input, int output, struct line *line, void *data)
 {
 	const struct line_driver *driver = line->driver;
-	int err = 0, flags = IRQF_SHARED | IRQF_SAMPLE_RANDOM;
+	int err = 0;
 
 	if (input)
 		err = um_request_irq(driver->read_irq, fd, IRQ_READ,
-				       line_interrupt, flags,
-				       driver->read_irq_name, data);
+				     line_interrupt, IRQF_SHARED,
+				     driver->read_irq_name, data);
 	if (err)
 		return err;
 	if (output)
 		err = um_request_irq(driver->write_irq, fd, IRQ_WRITE,
-					line_write_interrupt, flags,
-					driver->write_irq_name, data);
+				     line_write_interrupt, IRQF_SHARED,
+				     driver->write_irq_name, data);
 	return err;
 }
 
@@ -779,8 +779,7 @@ void register_winch_irq(int fd, int tty_fd, int pid, struct tty_struct *tty,
 				   .stack	= stack });
 
 	if (um_request_irq(WINCH_IRQ, fd, IRQ_READ, winch_interrupt,
-			   IRQF_SHARED | IRQF_SAMPLE_RANDOM,
-			   "winch", winch) < 0) {
+			   IRQF_SHARED, "winch", winch) < 0) {
 		printk(KERN_ERR "register_winch_irq - failed to register "
 		       "IRQ\n");
 		goto out_free;
diff --git a/arch/um/drivers/mconsole_kern.c b/arch/um/drivers/mconsole_kern.c
index 88e466b..e1c5197 100644
--- a/arch/um/drivers/mconsole_kern.c
+++ b/arch/um/drivers/mconsole_kern.c
@@ -775,8 +775,7 @@ static int __init mconsole_init(void)
 	register_reboot_notifier(&reboot_notifier);
 
 	err = um_request_irq(MCONSOLE_IRQ, sock, IRQ_READ, mconsole_interrupt,
-			     IRQF_SHARED | IRQF_SAMPLE_RANDOM,
-			     "mconsole", (void *)sock);
+			     IRQF_SHARED, "mconsole", (void *)sock);
 	if (err) {
 		printk(KERN_ERR "Failed to get IRQ for management console\n");
 		goto out;
diff --git a/arch/um/drivers/port_kern.c b/arch/um/drivers/port_kern.c
index 11866ff..1d83d50 100644
--- a/arch/um/drivers/port_kern.c
+++ b/arch/um/drivers/port_kern.c
@@ -100,8 +100,7 @@ static int port_accept(struct port_list *port)
 		  .port 	= port });
 
 	if (um_request_irq(TELNETD_IRQ, socket[0], IRQ_READ, pipe_interrupt,
-			  IRQF_SHARED | IRQF_SAMPLE_RANDOM,
-			  "telnetd", conn)) {
+			  IRQF_SHARED, "telnetd", conn)) {
 		printk(KERN_ERR "port_accept : failed to get IRQ for "
 		       "telnetd\n");
 		goto out_free;
@@ -184,8 +183,7 @@ void *port_data(int port_num)
 	}
 
 	if (um_request_irq(ACCEPT_IRQ, fd, IRQ_READ, port_interrupt,
-			  IRQF_SHARED | IRQF_SAMPLE_RANDOM,
-			  "port", port)) {
+			  IRQF_SHARED, "port", port)) {
 		printk(KERN_ERR "Failed to get IRQ for port %d\n", port_num);
 		goto out_close;
 	}
diff --git a/arch/um/drivers/random.c b/arch/um/drivers/random.c
index b25296e..e32c6aa 100644
--- a/arch/um/drivers/random.c
+++ b/arch/um/drivers/random.c
@@ -131,8 +131,7 @@ static int __init rng_init (void)
 	random_fd = err;
 
 	err = um_request_irq(RANDOM_IRQ, random_fd, IRQ_READ, random_interrupt,
-			     IRQF_SAMPLE_RANDOM, "random",
-			     NULL);
+			     0, "random", NULL);
 	if (err)
 		goto err_out_cleanup_hw;
 
diff --git a/arch/um/drivers/xterm_kern.c b/arch/um/drivers/xterm_kern.c
index b68bbe2..e3031e6 100644
--- a/arch/um/drivers/xterm_kern.c
+++ b/arch/um/drivers/xterm_kern.c
@@ -50,8 +50,7 @@ int xterm_fd(int socket, int *pid_out)
 	init_completion(&data->ready);
 
 	err = um_request_irq(XTERM_IRQ, socket, IRQ_READ, xterm_interrupt,
-			     IRQF_SHARED | IRQF_SAMPLE_RANDOM,
-			     "xterm", data);
+			     IRQF_SHARED, "xterm", data);
 	if (err) {
 		printk(KERN_ERR "xterm_fd : failed to get IRQ for xterm, "
 		       "err = %d\n",  err);
diff --git a/arch/um/kernel/sigio.c b/arch/um/kernel/sigio.c
index 2a16392..c882111 100644
--- a/arch/um/kernel/sigio.c
+++ b/arch/um/kernel/sigio.c
@@ -25,8 +25,7 @@ int write_sigio_irq(int fd)
 	int err;
 
 	err = um_request_irq(SIGIO_WRITE_IRQ, fd, IRQ_READ, sigio_interrupt,
-			     IRQF_SAMPLE_RANDOM, "write sigio",
-			     NULL);
+			     0, "write sigio", NULL);
 	if (err) {
 		printk(KERN_ERR "write_sigio_irq : um_request_irq failed, "
 		       "err = %d\n", err);
-- 
1.7.11.1.108.gb129051

