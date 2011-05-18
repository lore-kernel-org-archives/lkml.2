Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab1ERUoQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 16:44:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:56333 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777Ab1ERUoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 16:44:14 -0400
Date: Wed, 18 May 2011 20:43:54 GMT
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-26afb7c661080ae3f1f13ddf7f0c58c4f931c22b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, brgerst@gmail.com, jolsa@redhat.com,
        stable@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        brgerst@gmail.com, torvalds@linux-foundation.org, jolsa@redhat.com,
        stable@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1305210630-7136-1-git-send-email-jolsa@redhat.com>
References: <1305210630-7136-1-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86, 64-bit: Fix copy_[to/from]_user() checks for the userspace address limit
Git-Commit-ID: 26afb7c661080ae3f1f13ddf7f0c58c4f931c22b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 18 May 2011 20:43:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  26afb7c661080ae3f1f13ddf7f0c58c4f931c22b
Gitweb:     http://git.kernel.org/tip/26afb7c661080ae3f1f13ddf7f0c58c4f931c22b
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Thu, 12 May 2011 16:30:30 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 18 May 2011 12:49:00 +0200

x86, 64-bit: Fix copy_[to/from]_user() checks for the userspace address limit

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

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Brian Gerst <brgerst@gmail.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <stable@kernel.org>
Link: http://lkml.kernel.org/r/1305210630-7136-1-git-send-email-jolsa@redhat.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/uaccess.h |    2 +-
 arch/x86/lib/copy_user_64.S    |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index abd3e0e..99f0ad7 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -42,7 +42,7 @@
  * Returns 0 if the range is valid, nonzero otherwise.
  *
  * This is equivalent to the following test:
- * (u33)addr + (u33)size >= (u33)current->addr_limit.seg (u65 for x86_64)
+ * (u33)addr + (u33)size > (u33)current->addr_limit.seg (u65 for x86_64)
  *
  * This needs 33-bit (65-bit for x86_64) arithmetic. We have a carry...
  */
diff --git a/arch/x86/lib/copy_user_64.S b/arch/x86/lib/copy_user_64.S
index d17a117..0248402 100644
--- a/arch/x86/lib/copy_user_64.S
+++ b/arch/x86/lib/copy_user_64.S
@@ -79,7 +79,7 @@ ENTRY(_copy_to_user)
 	addq %rdx,%rcx
 	jc bad_to_user
 	cmpq TI_addr_limit(%rax),%rcx
-	jae bad_to_user
+	ja bad_to_user
 	ALTERNATIVE_JUMP X86_FEATURE_REP_GOOD,X86_FEATURE_ERMS,	\
 		copy_user_generic_unrolled,copy_user_generic_string,	\
 		copy_user_enhanced_fast_string
@@ -94,7 +94,7 @@ ENTRY(_copy_from_user)
 	addq %rdx,%rcx
 	jc bad_from_user
 	cmpq TI_addr_limit(%rax),%rcx
-	jae bad_from_user
+	ja bad_from_user
 	ALTERNATIVE_JUMP X86_FEATURE_REP_GOOD,X86_FEATURE_ERMS,	\
 		copy_user_generic_unrolled,copy_user_generic_string,	\
 		copy_user_enhanced_fast_string
