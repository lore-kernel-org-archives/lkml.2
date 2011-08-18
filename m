Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507Ab1HRS7y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 14:59:54 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49892 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab1HRS7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 14:59:49 -0400
Date: Thu, 18 Aug 2011 19:59:49 +0100
To: richard@nod.at
Subject: Subject: [PATCH 05/91] um: fix free_winch() mess
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7oj-0007Qd-4Y@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


while not doing free_irq() from irq handler is commendable, kfree() on
the data passed to said handler before free_irq() is Not Good(tm).
Freeing the stack it's being run on is also not nice...  Solution:
delay actually freeing stuff.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/drivers/line.c |   38 ++++++++++++++++++++++++--------------
 1 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
index 91bf1894..364c8a1 100644
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -721,43 +721,53 @@ struct winch {
 	int pid;
 	struct tty_struct *tty;
 	unsigned long stack;
+	struct work_struct work;
 };
 
-static void free_winch(struct winch *winch, int free_irq_ok)
+static void __free_winch(struct work_struct *work)
 {
-	int fd = winch->fd;
-	winch->fd = -1;
-	if (free_irq_ok)
-		free_irq(WINCH_IRQ, winch);
-
-	list_del(&winch->list);
+	struct winch *winch = container_of(work, struct winch, work);
+	free_irq(WINCH_IRQ, winch);
 
 	if (winch->pid != -1)
 		os_kill_process(winch->pid, 1);
-	if (fd != -1)
-		os_close_file(fd);
 	if (winch->stack != 0)
 		free_stack(winch->stack, 0);
 	kfree(winch);
 }
 
+static void free_winch(struct winch *winch)
+{
+	int fd = winch->fd;
+	winch->fd = -1;
+	if (fd != -1)
+		os_close_file(fd);
+	list_del(&winch->list);
+	__free_winch(&winch->work);
+}
+
 static irqreturn_t winch_interrupt(int irq, void *data)
 {
 	struct winch *winch = data;
 	struct tty_struct *tty;
 	struct line *line;
+	int fd = winch->fd;
 	int err;
 	char c;
 
-	if (winch->fd != -1) {
-		err = generic_read(winch->fd, &c, NULL);
+	if (fd != -1) {
+		err = generic_read(fd, &c, NULL);
 		if (err < 0) {
 			if (err != -EAGAIN) {
+				winch->fd = -1;
+				list_del(&winch->list);
+				os_close_file(fd);
 				printk(KERN_ERR "winch_interrupt : "
 				       "read failed, errno = %d\n", -err);
 				printk(KERN_ERR "fd %d is losing SIGWINCH "
 				       "support\n", winch->tty_fd);
-				free_winch(winch, 0);
+				INIT_WORK(&winch->work, __free_winch);
+				schedule_work(&winch->work);
 				return IRQ_HANDLED;
 			}
 			goto out;
@@ -829,7 +839,7 @@ static void unregister_winch(struct tty_struct *tty)
 	list_for_each_safe(ele, next, &winch_handlers) {
 		winch = list_entry(ele, struct winch, list);
 		if (winch->tty == tty) {
-			free_winch(winch, 1);
+			free_winch(winch);
 			break;
 		}
 	}
@@ -845,7 +855,7 @@ static void winch_cleanup(void)
 
 	list_for_each_safe(ele, next, &winch_handlers) {
 		winch = list_entry(ele, struct winch, list);
-		free_winch(winch, 1);
+		free_winch(winch);
 	}
 
 	spin_unlock(&winch_handler_lock);
-- 
1.7.2.5


