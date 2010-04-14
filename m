Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab0DNPCU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 11:02:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:53790 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755726Ab0DNPCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 11:02:18 -0400
Date: Wed, 14 Apr 2010 15:01:48 GMT
From: tip-bot for Arnd Bergmann <arnd@relay.de.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       arnd@relay.de.ibm.com, arnd@arndb.de, fweisbec@gmail.com,
       dmitry.adamushko@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: arnd@arndb.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       dmitry.adamushko@gmail.com, arnd@relay.de.ibm.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1270910781-8786-1-git-send-regression-fweisbec@gmail.com>
References: <1270910781-8786-1-git-send-regression-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/microcode] x86/microcode: Use nonseekable_open()
Message-ID: <tip-3f10940e4fb69d312602078f2c5234206797ca31@git.kernel.org>
Git-Commit-ID: 3f10940e4fb69d312602078f2c5234206797ca31
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 14 Apr 2010 15:01:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3f10940e4fb69d312602078f2c5234206797ca31
Gitweb:     http://git.kernel.org/tip/3f10940e4fb69d312602078f2c5234206797ca31
Author:     Arnd Bergmann <arnd@relay.de.ibm.com>
AuthorDate: Sat, 10 Apr 2010 16:46:21 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 14 Apr 2010 12:27:34 +0200

x86/microcode: Use nonseekable_open()

No need to seek on this file, so prevent it outright so we can
avoid using default_llseek - removes one more BKL usage.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
[drop useless llseek = no_llseek and smp_lock.h inclusion]
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnd Bergmann <arnd@relay.de.ibm.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>
LKML-Reference: <1270910781-8786-1-git-send-regression-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
