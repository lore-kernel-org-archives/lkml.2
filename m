Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab2BEW1L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:27:11 -0500
Received: from 1wt.eu ([62.212.114.60]:62131 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754738Ab2BEW1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:27:04 -0500
Message-Id: <20120205220952.783533652@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:11:07 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Brian Gerst <brgerst@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 78/91] x86, 64-bit: Fix copy_[to/from]_user() checks for the userspace address limit
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

commit 26afb7c661080ae3f1f13ddf7f0c58c4f931c22b upstream.

As reported in BZ #30352:

  https://bugzilla.kernel.org/show_bug.cgi?id=30352

there's a kernel bug related to reading the last allowed page on x86_64.

The _copy_to_user() and _copy_from_user() functions use the following
check for address limit:

  if (buf + size >= limit)
	fail();

while it should be more permissive:

  if (buf + size > limit)
	fail();

That's because the size represents the number of bytes being
read/write from/to buf address AND including the buf address.
So the copy function will actually never touch the limit
address even if "buf + size == limit".

Following program fails to use the last page as buffer
due to the wrong limit check:

 #include <sys/mman.h>
 #include <sys/socket.h>
 #include <assert.h>

 #define PAGE_SIZE       (4096)
 #define LAST_PAGE       ((void*)(0x7fffffffe000))

 int main()
 {
        int fds[2], err;
        void * ptr = mmap(LAST_PAGE, PAGE_SIZE, PROT_READ | PROT_WRITE,
                          MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED, -1, 0);
        assert(ptr == LAST_PAGE);
        err = socketpair(AF_LOCAL, SOCK_STREAM, 0, fds);
        assert(err == 0);
        err = send(fds[0], ptr, PAGE_SIZE, 0);
        perror("send");
        assert(err == PAGE_SIZE);
        err = recv(fds[1], ptr, PAGE_SIZE, MSG_WAITALL);
        perror("recv");
        assert(err == PAGE_SIZE);
        return 0;
 }

The other place checking the addr limit is the access_ok() function,
which is working properly. There's just a misleading comment
for the __range_not_ok() macro - which this patch fixes as well.

The last page of the user-space address range is a guard page and
Brian Gerst observed that the guard page itself due to an erratum on K8 cpus
(#121 Sequential Execution Across Non-Canonical Boundary Causes Processor
Hang).

However, the test code is using the last valid page before the guard page.
The bug is that the last byte before the guard page can't be read
because of the off-by-one error. The guard page is left in place.

This bug would normally not show up because the last page is
part of the process stack and never accessed via syscalls.

[WT: in 2.6.27 use include/asm-x86/uaccess.h]

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Brian Gerst <brgerst@gmail.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1305210630-7136-1-git-send-email-jolsa@redhat.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/include/asm/uaccess.h |    2 +-
 arch/x86/lib/copy_user_64.S    |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

Index: longterm-2.6.27/include/asm-x86/uaccess.h
===================================================================
--- longterm-2.6.27.orig/include/asm-x86/uaccess.h	2012-02-05 22:34:32.595915339 +0100
+++ longterm-2.6.27/include/asm-x86/uaccess.h	2012-02-05 22:34:45.985914777 +0100
@@ -42,7 +42,7 @@
  * Returns 0 if the range is valid, nonzero otherwise.
  *
  * This is equivalent to the following test:
- * (u33)addr + (u33)size >= (u33)current->addr_limit.seg (u65 for x86_64)
+ * (u33)addr + (u33)size > (u33)current->addr_limit.seg (u65 for x86_64)
  *
  * This needs 33-bit (65-bit for x86_64) arithmetic. We have a carry...
  */
Index: longterm-2.6.27/arch/x86/lib/copy_user_64.S
===================================================================
--- longterm-2.6.27.orig/arch/x86/lib/copy_user_64.S	2012-02-05 22:34:32.601914938 +0100
+++ longterm-2.6.27/arch/x86/lib/copy_user_64.S	2012-02-05 22:34:45.992914590 +0100
@@ -72,7 +72,7 @@
 	addq %rdx,%rcx
 	jc bad_to_user
 	cmpq TI_addr_limit(%rax),%rcx
-	jae bad_to_user
+	ja bad_to_user
 	ALTERNATIVE_JUMP X86_FEATURE_REP_GOOD,copy_user_generic_unrolled,copy_user_generic_string
 	CFI_ENDPROC
 
@@ -84,7 +84,7 @@
 	addq %rdx,%rcx
 	jc bad_from_user
 	cmpq TI_addr_limit(%rax),%rcx
-	jae bad_from_user
+	ja bad_from_user
 	ALTERNATIVE_JUMP X86_FEATURE_REP_GOOD,copy_user_generic_unrolled,copy_user_generic_string
 	CFI_ENDPROC
 ENDPROC(copy_from_user)


