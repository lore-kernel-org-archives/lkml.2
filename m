Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148Ab2DXRue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 13:50:34 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:60516 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757128Ab2DXRu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 13:50:29 -0400
From: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
Subject: [PATCH] Fix overflow in vma length when copying mmap on clone
Date: Tue, 24 Apr 2012 23:20:53 +0530
Message-Id: <1335289853-2923-1-git-send-email-siddhesh.poyarekar@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vma length in dup_mmap is calculated and stored in a unsigned int,
which is insufficient and hence overflows for very large maps (beyond
16TB). The following program demonstrates this:

\#include <stdio.h>
\#include <unistd.h>
\#include <sys/mman.h>

\#define GIG 1024 * 1024 * 1024L
\#define EXTENT 16393

int main(void)
{
        int i, r;
        void *m;
        char buf[1024];

        for (i = 0; i < EXTENT; i++) {
                m = mmap(NULL, (size_t) 1 * 1024 * 1024 * 1024L,
                         PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, 0, 0);

                if (m == (void *)-1)
                        printf("MMAP Failed: %d\n", m);
                else
                        printf("%d : MMAP returned %p\n", i, m);

                r = fork();

                if (r == 0) {
                        printf("%d: successed\n", i);
                        return 0;
                } else if (r < 0)
                        printf("FORK Failed: %d\n", r);
                else if (r > 0)
                        wait(NULL);
        }
        return 0;
}

This trivial patch increases the storage size of the result to
unsigned long, which should be sufficient for storing the difference
between addresses.

Signed-off-by: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
---
 kernel/fork.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index b9372a0..7acaee1 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -355,7 +355,8 @@ static int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 		}
 		charge = 0;
 		if (mpnt->vm_flags & VM_ACCOUNT) {
-			unsigned int len = (mpnt->vm_end - mpnt->vm_start) >> PAGE_SHIFT;
+			unsigned long len;
+			len = (mpnt->vm_end - mpnt->vm_start) >> PAGE_SHIFT;
 			if (security_vm_enough_memory_mm(oldmm, len)) /* sic */
 				goto fail_nomem;
 			charge = len;
-- 
1.7.7.6

