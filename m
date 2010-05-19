Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921Ab0ESBnV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 21:43:21 -0400
Received: from mail.windriver.com ([147.11.1.11]:41211 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756893Ab0ESBkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 21:40:20 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 5/7] kgdboc: Add ekgdboc for early use of the kernel debugger
Date: Tue, 18 May 2010 20:40:00 -0500
Message-Id: <1274233202-3734-6-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1274233202-3734-1-git-send-email-jason.wessel@windriver.com>
References: <1274233202-3734-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 19 May 2010 01:40:09.0938 (UTC) FILETIME=[37A34320:01CAF6F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ekgdboc= differs from kgdboc= in that you can begin debuggin as
soon as the exceptions are setup and the kgdb I/O driver is available,
instead of waiting until the tty subsystem is available.

CC: kgdb-bugreport@lists.sourceforge.net
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 Documentation/kernel-parameters.txt |    6 ++++++
 drivers/serial/kgdboc.c             |   19 +++++++++++++++++++
 2 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 414347e..e618c75 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -709,6 +709,12 @@ and is between 256 and 4096 characters. It is defined in the file
 			The VGA output is eventually overwritten by the real
 			console.
 
+	ekgdboc=	[X86,KGDB] Allow early kernel console debugging
+			ekgdboc=kbd
+
+			This is desgined to be used in conjunction with
+			the boot argument: earlyprintk=vga
+
 	eata=		[HW,SCSI]
 
 	edd=		[EDD]
diff --git a/drivers/serial/kgdboc.c b/drivers/serial/kgdboc.c
index b765ab4..a9a94ae 100644
--- a/drivers/serial/kgdboc.c
+++ b/drivers/serial/kgdboc.c
@@ -223,6 +223,25 @@ static struct kgdb_io kgdboc_io_ops = {
 	.post_exception		= kgdboc_post_exp_handler,
 };
 
+#ifdef CONFIG_KGDB_SERIAL_CONSOLE
+/* This is only available if kgdboc is a built in for early debugging */
+int __init kgdboc_early_init(char *opt)
+{
+	/* save the first character of the config string because the
+	 * init routine can destroy it.
+	 */
+	char save_ch;
+
+	kgdboc_option_setup(opt);
+	save_ch = config[0];
+	init_kgdboc();
+	config[0] = save_ch;
+	return 0;
+}
+
+early_param("ekgdboc", kgdboc_early_init);
+#endif /* CONFIG_KGDB_SERIAL_CONSOLE */
+
 module_init(init_kgdboc);
 module_exit(cleanup_kgdboc);
 module_param_call(kgdboc, param_set_kgdboc_var, param_get_string, &kps, 0644);
-- 
1.6.3.3

