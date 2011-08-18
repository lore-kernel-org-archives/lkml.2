Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab1HRS7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 14:59:42 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49890 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab1HRS7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 14:59:39 -0400
Date: Thu, 18 Aug 2011 19:59:39 +0100
To: richard@nod.at
Subject: Subject: [PATCH 04/91] um: winch_interrupt() can happen inside of free_winch()
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7oZ-0007QL-4L@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


... so set winch->fd to -1 before doing free_irq(), to avoid having
winch_interrupt() come from/during the latter and attempt to do
reactivate_fd() on something that's already gone.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/drivers/line.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
index c5bff1d..91bf1894 100644
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -725,6 +725,8 @@ struct winch {
 
 static void free_winch(struct winch *winch, int free_irq_ok)
 {
+	int fd = winch->fd;
+	winch->fd = -1;
 	if (free_irq_ok)
 		free_irq(WINCH_IRQ, winch);
 
@@ -732,8 +734,8 @@ static void free_winch(struct winch *winch, int free_irq_ok)
 
 	if (winch->pid != -1)
 		os_kill_process(winch->pid, 1);
-	if (winch->fd != -1)
-		os_close_file(winch->fd);
+	if (fd != -1)
+		os_close_file(fd);
 	if (winch->stack != 0)
 		free_stack(winch->stack, 0);
 	kfree(winch);
-- 
1.7.2.5


