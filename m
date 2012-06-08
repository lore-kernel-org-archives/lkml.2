Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761894Ab2FHFTA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:19:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43314 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761432Ab2FHFHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:25 -0400
Message-Id: <20120608041844.619141115@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:19:08 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>,
        Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Hugh Dickins <hughd@google.com>
Subject: [ 28/82] mm/fork: fix overflow in vma length when copying mmap on clone
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>

commit 7edc8b0ac16cbaed7cb4ea4c6b95ce98d2997e84 upstream.

The vma length in dup_mmap is calculated and stored in a unsigned int,
which is insufficient and hence overflows for very large maps (beyond
16TB). The following program demonstrates this:

#include <stdio.h>
#include <unistd.h>
#include <sys/mman.h>

#define GIG 1024 * 1024 * 1024L
#define EXTENT 16393

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

Increase the storage size of the result to unsigned long, which is
sufficient for storing the difference between addresses.

Signed-off-by: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/fork.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -352,7 +352,8 @@
 		}
 		charge = 0;
 		if (mpnt->vm_flags & VM_ACCOUNT) {
-			unsigned int len = (mpnt->vm_end - mpnt->vm_start) >> PAGE_SHIFT;
+			unsigned long len;
+			len = (mpnt->vm_end - mpnt->vm_start) >> PAGE_SHIFT;
 			if (security_vm_enough_memory(len))
 				goto fail_nomem;
 			charge = len;


