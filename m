Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab1F1V4y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 17:56:54 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:51067 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab1F1V4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 17:56:41 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: akpm@linux-foundation.org
Cc: oleg@redhat.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH -resend v2 3/3] do_coredump: fix the "ispipe" error check
Date: Tue, 28 Jun 2011 23:56:25 +0200
Message-Id: <1309298185-31434-3-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1309298185-31434-1-git-send-email-jslaby@suse.cz>
References: <1309298185-31434-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

do_coredump() assumes that if format_corename() fails it should
return -ENOMEM. This is not true, for example cn_print_exe_file()
can propagate the error from d_path. Even if it was true, this is
too fragile. Change the code to check "ispipe < 0".

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Reviewed-by: Neil Horman <nhorman@tuxdriver.com>
---
 fs/exec.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 424ec9d..549b7dc 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -2112,16 +2112,16 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 
 	ispipe = format_corename(&cn, signr);
 
-	if (ispipe == -ENOMEM) {
-		printk(KERN_WARNING "format_corename failed\n");
-		printk(KERN_WARNING "Aborting core\n");
-		goto fail_corename;
-	}
-
  	if (ispipe) {
 		int dump_count;
 		char **helper_argv;
 
+		if (ispipe < 0) {
+			printk(KERN_WARNING "format_corename failed\n");
+			printk(KERN_WARNING "Aborting core\n");
+			goto fail_corename;
+		}
+
 		if (cprm.limit == 1) {
 			/*
 			 * Normally core limits are irrelevant to pipes, since
-- 
1.7.6


