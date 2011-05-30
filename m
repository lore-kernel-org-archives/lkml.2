Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502Ab1E3QZE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 12:25:04 -0400
Received: from grimli.r00tworld.net ([83.169.44.195]:42954 "EHLO
	mail.r00tworld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666Ab1E3QZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 12:25:03 -0400
X-Greylist: delayed 472 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 May 2011 12:25:03 EDT
From: Mathias Krause <minipli@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: Mathias Krause <minipli@googlemail.com>, stable@kernel.org
Subject: [PATCH] init: use KERNEL_DS when trying to start init process
Date: Mon, 30 May 2011 18:17:08 +0200
Message-Id: <1306772228-1603-1-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use kernel_execve() to transfer control of the init procces from
kernel to userland. If the program to start as init process isn't given
on the kernel command line or fails to start we use a few hardcoded
fallbacks. This fallback mechanism does not work when we encounter a
file that is executable but fails to start, e.g. due to a missing
library dependency or by having an unsupported file format.

The bug is, that search_binary_handler() sets the address limit to
USER_DS but doesn't reset it on error which will make all further
attempts fail with -EFAULT because argv[0] is a pointer to kernel
memory, not userland.

The bug can easily be reproduced by starting a 32 bit kernel with a 64
bit executable as /init and a 32 bit version as /sbin/init within an
initramfs. The hardcoded defaults should make /init fail because of the
unsupported file format but should make /sbin/init succeed. This doesn't
happen because the string "/sbin/init" lives in kernel memory and is no
longer allowed because of the modified address limit to USER_DS after
the failed execution attempt of /init.

Fixing the only user of kernel_execve that needs this tweaking was far
more easy than changing the implementation for all architectures. This
also makes backporting far more easy as this bug is in there from the
very beginning -- at least it's in v2.6.12, too.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
CC: stable@kernel.org
---
 init/main.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/init/main.c b/init/main.c
index cafba67..4ee893a 100644
--- a/init/main.c
+++ b/init/main.c
@@ -731,6 +731,9 @@ static void __init do_pre_smp_initcalls(void)
 
 static void run_init_process(const char *init_filename)
 {
+	/* Ensure we can access in-kernel filenames -- previous exec attempts
+	 * might have set the address limit to USER_DS */
+	set_fs(KERNEL_DS);
 	argv_init[0] = init_filename;
 	kernel_execve(init_filename, argv_init, envp_init);
 }
-- 
1.5.6.5

