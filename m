Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759005Ab2CMAXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:23:41 -0400
Received: from mail.windriver.com ([147.11.1.11]:48180 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758927Ab2CMAX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:23:27 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Jim Bos <jim876@xs4all.nl>,
        Andi Kleen <andi@firstfloor.org>,
        Andreas Schwab <schwab@linux-m68k.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 112/196] i8k: Tell gcc that *regs gets clobbered
Date: Mon, 12 Mar 2012 20:20:25 -0400
Message-Id: <1331598109-31424-67-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Bos <jim876@xs4all.nl>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 6b4e81db2552bad04100e7d5ddeed7e848f53b48 upstream.

More recent GCC caused the i8k driver to stop working, on Slackware
compiler was upgraded from gcc-4.4.4 to gcc-4.5.1 after which it didn't
work anymore, meaning the driver didn't load or gave total nonsensical
output.

As it turned out the asm(..) statement forgot to mention it modifies the
*regs variable.

Credits to Andi Kleen and Andreas Schwab for providing the fix.

Signed-off-by: Jim Bos <jim876@xs4all.nl>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Andreas Schwab <schwab@linux-m68k.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/char/i8k.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index fc8cf7a..828fd24 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -141,7 +141,7 @@ static int i8k_smm(struct smm_regs *regs)
 		"lahf\n\t"
 		"shrl $8,%%eax\n\t"
 		"andl $1,%%eax\n"
-		:"=a"(rc)
+		:"=a"(rc), "+m" (*regs)
 		:    "a"(regs)
 		:    "%ebx", "%ecx", "%edx", "%esi", "%edi", "memory");
 #else
@@ -166,7 +166,8 @@ static int i8k_smm(struct smm_regs *regs)
 	    "movl %%edx,0(%%eax)\n\t"
 	    "lahf\n\t"
 	    "shrl $8,%%eax\n\t"
-	    "andl $1,%%eax\n":"=a"(rc)
+	    "andl $1,%%eax\n"
+	    :"=a"(rc), "+m" (*regs)
 	    :    "a"(regs)
 	    :    "%ebx", "%ecx", "%edx", "%esi", "%edi", "memory");
 #endif
-- 
1.7.9.3

