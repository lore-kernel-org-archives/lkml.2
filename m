Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212Ab1H2QOr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 12:14:47 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:52404 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754099Ab1H2QNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 12:13:51 -0400
From: Richard Weinberger <richard@nod.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        Al Viro <viro@ftp.linux.org.uk>, Al Viro <viro@zeniv.linux.org.uk>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5/9] um: winch_interrupt() can happen inside of free_winch()
Date: Mon, 29 Aug 2011 18:13:35 +0200
Message-Id: <1314634419-24766-6-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1314634419-24766-1-git-send-email-richard@nod.at>
References: <1314634419-24766-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ftp.linux.org.uk>

... so set winch->fd to -1 before doing free_irq(), to avoid having
winch_interrupt() come from/during the latter and attempt to do
reactivate_fd() on something that's already gone.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Richard Weinberger <richard@nod.at>
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
1.7.6.1

