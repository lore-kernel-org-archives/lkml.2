Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935930Ab1JGAAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 20:00:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759363Ab1JGAAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 20:00:36 -0400
From: Josh Stone <jistone@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Josh Stone <jistone@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Jakub Jelinek <jakub@redhat.com>
Subject: [PATCH] x86: Make variable_test_bit reference all of *addr
Date: Thu,  6 Oct 2011 16:58:28 -0700
Message-Id: <1317945508-19575-1-git-send-email-jistone@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <4E7A89D5.4000001@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This casts the addr that's fed to asm into a struct-array pointer, so
gcc knows that more than just the first long is needed.  Since there's
no fixed size for all callers, an arbitrary size is chosen just to
ensure that it's probably good enough.

I noticed this warning on i686, with gcc-4.6.1-9.fc15:

  CC      arch/x86/kernel/kprobes.o
In file included from include/linux/bitops.h:22:0,
                 from include/linux/kernel.h:17,
                 from [...]/arch/x86/include/asm/percpu.h:44,
                 from [...]/arch/x86/include/asm/current.h:5,
                 from [...]/arch/x86/include/asm/processor.h:15,
                 from [...]/arch/x86/include/asm/atomic.h:6,
                 from include/linux/atomic.h:4,
                 from include/linux/mutex.h:18,
                 from include/linux/notifier.h:13,
                 from include/linux/kprobes.h:34,
                 from arch/x86/kernel/kprobes.c:43:
[...]/arch/x86/include/asm/bitops.h: In function ‘can_boost.part.1’:
[...]/arch/x86/include/asm/bitops.h:319:2: warning: use of memory input without lvalue in asm operand 1 is deprecated [enabled by default]

In investigating the impact of this warning, I discovered that only the
first long of the 32-byte twobyte_is_boostable[] was making into the
object file.

Jakub advised that variable_test_bit is incorrectly telling gcc that its
asm only uses a single long from the addr pointer, and he suggested the
struct-array cast to broaden the memory reference.

Signed-off-by: Josh Stone <jistone@redhat.com>
Cc: Jakub Jelinek <jakub@redhat.com>

---

An alternate fix would be to make kprobes' twobyte_is_boostable[]
volatile, which forces gcc to keep it around.  I feel that's treating
the symptom though, rather than the cause in variable_test_bit().

IMO this is also a good candidate for -stable, for fixing the obviously bad
data behavior, but I'll let others judge...

---
 arch/x86/include/asm/bitops.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index 1775d6e..0565371 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -319,7 +319,8 @@ static inline int variable_test_bit(int nr, volatile const unsigned long *addr)
 	asm volatile("bt %2,%1\n\t"
 		     "sbb %0,%0"
 		     : "=r" (oldbit)
-		     : "m" (*(unsigned long *)addr), "Ir" (nr));
+		     : "m" (*(struct { unsigned long _[0x10000]; } *)addr),
+		       "Ir" (nr));
 
 	return oldbit;
 }
-- 
1.7.6.4

