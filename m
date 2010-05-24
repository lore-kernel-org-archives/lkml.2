Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948Ab0EXUcM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 16:32:12 -0400
Received: from smtp-out.google.com ([216.239.44.51]:5568 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756861Ab0EXUb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 16:31:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:
	references:x-system-of-record;
	b=OX09tZn/3zqDsRYVtCpPhnI9zTPNUeejCUKtV4hkRQiDL+l+5QybNmUN8l55wCEGN
	9M+YSNbBfjQ9gsQliLglg==
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Subject: [PATCH 01/11] x86 rwsem: stay on fast path when count>0 in __up_write()
Date: Mon, 24 May 2010 13:31:11 -0700
Message-Id: <1274733081-4623-2-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1274733081-4623-1-git-send-email-walken@google.com>
References: <1274733081-4623-1-git-send-email-walken@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When count>0 there is no need to take the call_rwsem_wake path.
If we did take that path, it would just return without doing anything
due to the active count not being zero.

Signed-off-by: Michel Lespinasse <walken@google.com>
Acked-by: David Howells <dhowells@redhat.com>
---
 arch/x86/include/asm/rwsem.h |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/rwsem.h b/arch/x86/include/asm/rwsem.h
index 606ede1..3fd1ed3 100644
--- a/arch/x86/include/asm/rwsem.h
+++ b/arch/x86/include/asm/rwsem.h
@@ -216,9 +216,8 @@ static inline void __up_write(struct rw_semaphore *sem)
 	rwsem_count_t tmp;
 	asm volatile("# beginning __up_write\n\t"
 		     LOCK_PREFIX "  xadd      %1,(%2)\n\t"
-		     /* tries to transition
-			0xffff0001 -> 0x00000000 */
-		     "  jz       1f\n"
+		     /* substracts 0xffff0001, returns the old value */
+		     "  jns        1f\n\t"
 		     "  call call_rwsem_wake\n"
 		     "1:\n\t"
 		     "# ending __up_write\n"
-- 
1.7.0.1

