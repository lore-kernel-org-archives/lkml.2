Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831Ab0DJOqb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 10:46:31 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:59592 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab0DJOq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 10:46:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=XcjZVe/ZUyw250lyHTbVPZxcwS1hxQl9BBARVamc+pKAmb05On3C1GnWn/R/bBT6dz
         pb0G9DlmFuasq7GANYgVw1ICUO/cxDCa+1DounUVQc6b3biDnP4QWBoC6QhDHD5bfgIl
         S1TcrED5oOJcj5sVX4DNa2JMbH3Hn4R5gebw8=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@relay.de.ibm.com>,
       Arnd Bergmann <arnd@arndb.de>, "H . Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] x86/microcode: Use nonseekable_open
Date: Sat, 10 Apr 2010 16:46:21 +0200
Message-Id: <1270910781-8786-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@relay.de.ibm.com>

No need to seek on this file, so prevent it outright so we can
avoid using default_llseek.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
[drop useless llseek = no_llseek and smp_lock.h inclusion]
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/microcode_core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index cceb5bc..2cd8c54 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -201,9 +201,9 @@ static int do_microcode_update(const void __user *buf, size_t size)
 	return error;
 }
 
-static int microcode_open(struct inode *unused1, struct file *unused2)
+static int microcode_open(struct inode *inode, struct file *file)
 {
-	return capable(CAP_SYS_RAWIO) ? 0 : -EPERM;
+	return capable(CAP_SYS_RAWIO) ? nonseekable_open(inode, file) : -EPERM;
 }
 
 static ssize_t microcode_write(struct file *file, const char __user *buf,
-- 
1.6.2.3

