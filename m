Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab1JWAZp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 20:25:45 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49611 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab1JWAZo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 20:25:44 -0400
MIME-Version: 1.0
In-Reply-To: <1319229182-32226-1-git-send-email-jistone@redhat.com>
References: <1319229182-32226-1-git-send-email-jistone@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 23 Oct 2011 03:25:19 +0300
X-Google-Sender-Auth: _UECjutOtxAEoRtvc4cCX8vi3O4
Message-ID: <CA+55aFzXHLrcP1idskKJXcxdPfjSCfgmtYzd7r4uA4ni1E+k+A@mail.gmail.com>
Subject: Re: [PATCH] x86: Fix compilation bug in kprobes' twobyte_is_boostable
To: Josh Stone <jistone@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Jakub Jelinek <jakub@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 21, 2011 at 11:33 PM, Josh Stone <jistone@redhat.com> wrote:
> When compiling an i386_defconfig kernel with gcc-4.6.1-9.fc15.i686, I
> noticed a warning about the asm operand for test_bit in kprobes'
> can_boost.  I discovered that this caused only the first long of
> twobyte_is_boostable[] to be output.
>
> Jakub filed and fixed gcc PR50571 to correct the warning and this output
> issue.  But to solve it for less current gcc, we can make kprobes'
> twobyte_is_boostable[] volatile, and it won't be optimized out.

Hmm. I'd *much* rather do this in arch/x86/include/asm/bitops.h
instead, methinks.

Also, rather than your

> See also my more general fix, https://lkml.org/lkml/2011/10/6/412

wouldn't the simple fix be just to add the volatile there to the cast
we already do, ie something like the appended (cut-and-paste, so it's
whitespace-damaged, but you get the idea).

Now, I'm the first to say that I hate volatile, and I'm not entirely
happy about the cast there, but (a) we're casting a volatile pointer
to begin with, and (b) it's essentially the same thing that we do for
the inline asms that modify the bit (see the "ADDR" macro, which also
handles some gcc versioning issues).

And I don't mind volatile in code nearly as much as I mind volatile on
the data structures (it's one of my "C typing was misdesigned" pet
peeves: I think "volatile" is about the access, not about the data)

Does this fix the gcc problem too?

Historical notes:

 - We *used* to have a volatile there (and a whole base address and
"tell gcc which word changed" mess) up until commit eb2b4e682a6 ("x86:
revert commit 709f744 ("x86: bitops asm constraint fixes")"). We
reverted the base address mess, but we probably should have kept the
"volatile".

 - Long long ago, we had that "big array" approach for ADDR too. So
we've wavered between the volatile and using a block memory op. But
we've used the "volatile" for a long time now for the bit change ones,
so I don't think we should mix concepts like your patch.

Comments? Does the simple 'volatile' approach also fix the problem?

               Linus

---
 arch/x86/include/asm/bitops.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index 1775d6e5920e..87f000d9377e 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -319,7 +319,7 @@ static inline int variable_test_bit(int nr, volatile const u
        asm volatile("bt %2,%1\n\t"
                     "sbb %0,%0"
                     : "=r" (oldbit)
-                    : "m" (*(unsigned long *)addr), "Ir" (nr));
+                    : "m" (*(volatile unsigned long *)addr), "Ir" (nr));

        return oldbit;
 }
