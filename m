Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab1HRTIX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:08:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47514 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349Ab1HRTIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:08:20 -0400
Date: Thu, 18 Aug 2011 20:08:19 +0100
To: richard@nod.at
Subject: Subject: [PATCH 56/91] um: take register_winch_irq() into the
 caller of is_skas_winch()
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7wx-0007rd-Og@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/drivers/chan_user.c     |    7 ++++++-
 arch/um/os-Linux/skas/process.c |    6 +-----
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/um/drivers/chan_user.c b/arch/um/drivers/chan_user.c
index 7ed06a7..f180813 100644
--- a/arch/um/drivers/chan_user.c
+++ b/arch/um/drivers/chan_user.c
@@ -281,7 +281,12 @@ void register_winch(int fd, struct tty_struct *tty)
 		return;
 
 	pid = tcgetpgrp(fd);
-	if (!is_skas_winch(pid, fd, tty) && (pid == -1)) {
+	if (is_skas_winch(pid, fd, tty)) {
+		register_winch_irq(-1, fd, -1, tty, 0);
+		return;
+	}
+
+	if (pid == -1) {
 		thread = winch_tramp(fd, tty, &thread_fd, &stack);
 		if (thread < 0)
 			return;
diff --git a/arch/um/os-Linux/skas/process.c b/arch/um/os-Linux/skas/process.c
index 514683f..3fdac54 100644
--- a/arch/um/os-Linux/skas/process.c
+++ b/arch/um/os-Linux/skas/process.c
@@ -26,11 +26,7 @@
 
 int is_skas_winch(int pid, int fd, void *data)
 {
-	if (pid != getpgrp())
-		return 0;
-
-	register_winch_irq(-1, fd, -1, data, 0);
-	return 1;
+	return pid == getpgrp();
 }
 
 static int ptrace_dump_regs(int pid)
-- 
1.7.2.5


