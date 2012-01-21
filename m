Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519Ab2AUTCz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 14:02:55 -0500
Received: from cox.rootnode.net ([89.248.165.14]:57083 "EHLO cox.rootnode.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141Ab2AUTCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 14:02:52 -0500
From: Szymon Janc <szymon@janc.net.pl>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Szymon Janc <szymon@janc.net.pl>
Subject: [PATCH] binfmt_misc: Fix compilation error in parse_command()
Date: Sat, 21 Jan 2012 20:02:37 +0100
Message-Id: <1327172558-19180-1-git-send-email-szymon@janc.net.pl>
X-Mailer: git-send-email 1.7.8.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.8 (cox.rootnode.net [0.0.0.0]); Sat, 21 Jan 2012 20:02:50 +0100 (CET)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Sat Jan 21 20:02:50 2012
X-DSPAM-Confidence: 0.9983
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4f1b0bda260341804284693
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fix compilation error with CONFIG_DEBUG_STRICT_USER_COPY_CHECKS
enabled. It looks like gcc 4.6.2 is not able to prove that count
is within sizeof(s) bounds (although it is).

  CC [M]  fs/binfmt_misc.o
In file included from arch/x86/include/asm/uaccess.h:573:0,
                 from include/linux/uaccess.h:5,
                 from include/linux/highmem.h:7,
                 from include/linux/pagemap.h:10,
                 from fs/binfmt_misc.c:26:
In function ‘copy_from_user’,
    inlined from ‘parse_command.part.1’ at fs/binfmt_misc.c:421:20:
arch/x86/include/asm/uaccess_32.h:211:26: error: call to ‘copy_from_user_overflow’ declared with attribute error: copy_from_user() buffer size is not provably correct
make[1]: *** [fs/binfmt_misc.o] Error 1
make: *** [fs] Error 2

Signed-off-by: Szymon Janc <szymon@janc.net.pl>
---
 fs/binfmt_misc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index a9198df..4879d35 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -418,7 +418,7 @@ static int parse_command(const char __user *buffer, size_t count)
 		return 0;
 	if (count > 3)
 		return -EINVAL;
-	if (copy_from_user(s, buffer, count))
+	if (copy_from_user(s, buffer, min(count, sizeof(s))))
 		return -EFAULT;
 	if (s[count-1] == '\n')
 		count--;
-- 
1.7.8.3


