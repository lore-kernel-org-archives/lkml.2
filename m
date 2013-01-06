Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751065Ab3AFF3N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 00:29:13 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:33008 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab3AFF3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 00:29:12 -0500
From: Xi Wang <xi.wang@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jason Baron <jbaron@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Xi Wang <xi.wang@gmail.com>
Subject: [PATCH RFC] exec: avoid possible undefined behavior in count()
Date: Sun,  6 Jan 2013 00:29:05 -0500
Message-Id: <1357450145-23964-1-git-send-email-xi.wang@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tricky problem is this check:

	if (i++ >= max)

icc (mis)optimizes this check as:

	if (++i > max)

The check now becomes a no-op since max is MAX_ARG_STRINGS (0x7FFFFFFF).

This is "allowed" by the C standard, assuming i++ never overflows,
because signed integer overflow is undefined behavior.  This optimization
effectively reverts the previous commit 362e6663ef ("exec.c, compat.c:
fix count(), compat_count() bounds checking") that tries to fix the check.

This patch simply moves ++ after the check.

Signed-off-by: Xi Wang <xi.wang@gmail.com>
---
Not sure how many people are using Intel's icc to compiled the kernel.
Some projects like LinuxDNA did.

The kernel uses gcc's -fno-strict-overflow to disable this optimization.
icc probably doesn't recognize the option.

To illustrate the problem, try this simple program:

int count(int i, int max)
{
        if (i++ >= max) {
                __builtin_trap();
                return -1;
        }
        return i;
}

#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
        int x = atoi(argv[1]);
        int max = atoi(argv[2]);
        printf("%d %d %d\n", x, max, count(x, max));
}

$ gcc -O2 t.c
$ ./a.out 2147483647 2147483647
Illegal instruction (core dumped)

$ icc -O2 t.c
$ ./a.out 2147483647 2147483647
2147483647 2147483647 -2147483648

There's no difference whether we add -fno-strict-overflow or not.
---
 fs/exec.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/exec.c b/fs/exec.c
index 18c45ca..20df02c 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -434,8 +434,9 @@ static int count(struct user_arg_ptr argv, int max)
 			if (IS_ERR(p))
 				return -EFAULT;
 
-			if (i++ >= max)
+			if (i >= max)
 				return -E2BIG;
+			++i;
 
 			if (fatal_signal_pending(current))
 				return -ERESTARTNOHAND;
-- 
1.7.10.4

