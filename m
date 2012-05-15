Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965598Ab2EOCYP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:24:15 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53558 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964902Ab2EOCS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:18:27 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 177/179] score: fix off-by-one index into syscall table
Date: Mon, 14 May 2012 22:14:33 -0400
Message-ID: <1337048075-6132-178-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Rosenberg <drosenberg@vsecurity.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit c25a785d6647984505fa165b5cd84cfc9a95970b upstream.

If the provided system call number is equal to __NR_syscalls, the
current check will pass and a function pointer just after the system
call table may be called, since sys_call_table is an array with total
size __NR_syscalls.

Whether or not this is a security bug depends on what the compiler puts
immediately after the system call table.  It's likely that this won't do
anything bad because there is an additional NULL check on the syscall
entry, but if there happens to be a non-NULL value immediately after the
system call table, this may result in local privilege escalation.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: <stable@vger.kernel.org>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
Cc: Eugene Teo <eugeneteo@kernel.sg>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/score/kernel/entry.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/score/kernel/entry.S b/arch/score/kernel/entry.S
index 577abba..83bb960 100644
--- a/arch/score/kernel/entry.S
+++ b/arch/score/kernel/entry.S
@@ -408,7 +408,7 @@ ENTRY(handle_sys)
 	sw	r9, [r0, PT_EPC]
 
 	cmpi.c	r27, __NR_syscalls 	# check syscall number
-	bgtu	illegal_syscall
+	bgeu	illegal_syscall
 
 	slli	r8, r27, 2		# get syscall routine
 	la	r11, sys_call_table
-- 
1.7.9.6

