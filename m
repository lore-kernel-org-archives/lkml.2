Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab2FMOvk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 10:51:40 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:50683 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753857Ab2FMOvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 10:51:39 -0400
From: Aurelien Gerault <aurelien.gerault-xsig@stericsson.com>
To: <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Aurelien Gerault <aurelien.gerault-nonst@stericsson.com>
Subject: [PATCH] printk: Ensure oops printing if console is locked
Date: Wed, 13 Jun 2012 16:51:08 +0200
Message-ID: <1339599068-25215-1-git-send-email-aurelien.gerault-xsig@stericsson.com>
X-Mailer: git-send-email 1.7.10
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aurelien Gerault <aurelien.gerault-nonst@stericsson.com>

Ensuring that oops & panic messages/backtraces will be printed
in console, even when the console is locked.

If console is locked by someone else but an oops is ongoing, force
unlocking / re-locking to display the oops.

Signed-off-by: Aurelien Gerault <aurelien.gerault-nonst@stericsson.com>
---
 kernel/printk.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/printk.c b/kernel/printk.c
index 6d24237..be2a625 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1014,6 +1014,11 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 	 */
 	if (console_trylock_for_printk(this_cpu))
 		console_unlock();
+	else if (oops_in_progress) {
+		/* force releasing / acquiring console lock to print oops */
+		console_unlock();
+		console_lock();
+	}
 
 	lockdep_on();
 out_restore_irqs:
-- 
1.7.10

