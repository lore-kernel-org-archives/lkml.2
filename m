Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab1J3Iwr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 04:52:47 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52304 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab1J3Iwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 04:52:45 -0400
Message-ID: <1319964754.13597.26.camel@edumazet-laptop>
Subject: Re: >Re: [RFC] should VM_BUG_ON(cond) really evaluate cond
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ben Hutchings <bhutchings@solarflare.com>,
        Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Sun, 30 Oct 2011 09:52:34 +0100
In-Reply-To: <CA+55aFz=sxRjw6u-ww0P=9hhvWaZP=+QJZ68W+B9WtvQqj9Ogg@mail.gmail.com>
References: <1319764761.23112.14.camel@edumazet-laptop>
	 <20111028012521.GF25795@one.firstfloor.org>
	 <CA+55aFy9oJSK99K=brRzSfSnLocO=PuS7yuKkAcw3t5hATJrfw@mail.gmail.com>
	 <1319766293.6759.17.camel@deadeye>
	 <1319770376.23112.58.camel@edumazet-laptop>
	 <1319772566.6759.27.camel@deadeye>
	 <1319777025.23112.67.camel@edumazet-laptop>
	 <CA+55aFzHf563auNYdNeJnsbbry1OUfkepkiVHt7Fy-bG64Fruw@mail.gmail.com>
	 <1319803781.23112.113.camel@edumazet-laptop>
	 <CA+55aFxzgc5pC1p6J8YADNDwmAjUYNRKLvir6OQMueWqUXOaEQ@mail.gmail.com>
	 <CA+55aFxy6VSBbikFrfXwUPOafihR+MOdi+yKSp_6qz7_Vax_YA@mail.gmail.com>
	 <1319813252.23112.122.camel@edumazet-laptop>
	 <CA+55aFxvcvUopBc-Q6Fp87asTuBohev8Xdm67jcKfy4Z4_BZRg@mail.gmail.com>
	 <CA+55aFz=sxRjw6u-ww0P=9hhvWaZP=+QJZ68W+B9WtvQqj9Ogg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 29 octobre 2011 à 10:34 -0700, Linus Torvalds a écrit :
> On Fri, Oct 28, 2011 at 7:55 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Comments? I think I'm open to tested patches..
> 
> Here's a *untested* patch.
> 
> In particular, I worry that I'd need to add a "#include
> <linux/compiler.h>" to some header file, although I suspect it gets
> included some way regardless.
> 
> And when I say "untested", I mean it. I verified that this makes
> *some* difference to the generated code, but I didn't actually check
> if it really matters, or if it actually compiles and works in general.
> 
> Caveat tester,
> 

Since jetlag strikes me again, I took your patch and had to change it a
bit, since :

1) x86 uses its own atomic_read() definition in
arch/x86/include/asm/atomic.h

2) We can use a const pointer in ACCESS_AT_MOST_ONCE(*ptr), so I had to
change a bit your implementation, I hope I did not mess it.

Tested (built/booted) on x86 and x86_64

We could logically split this patch in three parts, but hey, maybe I can
try to sleep after all ;)

Thanks

[PATCH] atomic: introduce ACCESS_AT_MOST_ONCE() helper

In commit 4e60c86bd9e (gcc-4.6: mm: fix unused but set warnings)
Andi forced VM_BUG_ON(cond) to evaluate cond, even if CONFIG_DEBUG_VM is
not set :

#ifdef CONFIG_DEBUG_VM
#define VM_BUG_ON(cond) BUG_ON(cond)
#else
#define VM_BUG_ON(cond) do { (void)(cond); } while (0)
#endif

As a side effect, get_page()/put_page_testzero() are performing more bus
transactions on contended cache line on some workloads (tcp_sendmsg()
for example, where a page is acting as a shared buffer)

0,05 :  ffffffff815e4775:       je     ffffffff815e4970 <tcp_sendmsg+0xc80>
0,05 :  ffffffff815e477b:       mov    0x1c(%r9),%eax    // useless                  
3,32 :  ffffffff815e477f:       mov    (%r9),%rax        // useless                  
0,51 :  ffffffff815e4782:       lock incl 0x1c(%r9)                        
3,87 :  ffffffff815e4787:       mov    (%r9),%rax                          
0,00 :  ffffffff815e478a:       test   $0x80,%ah                           
0,00 :  ffffffff815e478d:       jne    ffffffff815e49f2 <tcp_sendmsg+0xd02>      

Thats because both atomic_read() and constant_test_bit() use a volatile
attribute and thus compiler is forced to perform a read, even if the
result is optimized away.

Linus suggested using an asm("") trick and place it in a variant of
ACCESS_ONCE(), allowing compiler to omit reading memory if result is
unused.

This patch introduces ACCESS_AT_MOST_ONCE() helper and use it in the x86
implementation of atomic_read() and constant_test_bit()

on x86_64, we thus reduce vmlinux text a bit (if CONFIG_DEBUG_VM=n)

# size vmlinux.old vmlinux.new
   text	   data	    bss	    dec	    hex	filename
10706848	2894216	1540096	15141160	 e70928	vmlinux.old
10704680	2894216	1540096	15138992	 e700b0	vmlinux.new

Based on a prior patch from Linus

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 arch/x86/include/asm/atomic.h |    2 +-
 arch/x86/include/asm/bitops.h |    7 +++++--
 include/asm-generic/atomic.h  |    2 +-
 include/linux/compiler.h      |   10 ++++++++++
 4 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/atomic.h b/arch/x86/include/asm/atomic.h
index 58cb6d4..b1f0c6b 100644
--- a/arch/x86/include/asm/atomic.h
+++ b/arch/x86/include/asm/atomic.h
@@ -22,7 +22,7 @@
  */
 static inline int atomic_read(const atomic_t *v)
 {
-	return (*(volatile int *)&(v)->counter);
+	return ACCESS_AT_MOST_ONCE(v->counter);
 }
 
 /**
diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index 1775d6e..e30a190 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -308,8 +308,11 @@ static inline int test_and_change_bit(int nr, volatile unsigned long *addr)
 
 static __always_inline int constant_test_bit(unsigned int nr, const volatile unsigned long *addr)
 {
-	return ((1UL << (nr % BITS_PER_LONG)) &
-		(addr[nr / BITS_PER_LONG])) != 0;
+	const unsigned long *word = (const unsigned long *)addr +
+				    (nr / BITS_PER_LONG);
+	unsigned long bit = 1UL << (nr % BITS_PER_LONG);
+
+	return (bit & ACCESS_AT_MOST_ONCE(*word)) != 0;
 }
 
 static inline int variable_test_bit(int nr, volatile const unsigned long *addr)
diff --git a/include/asm-generic/atomic.h b/include/asm-generic/atomic.h
index e37963c..c05e21f 100644
--- a/include/asm-generic/atomic.h
+++ b/include/asm-generic/atomic.h
@@ -39,7 +39,7 @@
  * Atomically reads the value of @v.
  */
 #ifndef atomic_read
-#define atomic_read(v)	(*(volatile int *)&(v)->counter)
+#define atomic_read(v)	ACCESS_AT_MOST_ONCE((v)->counter)
 #endif
 
 /**
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 320d6c9..21f102d 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -308,4 +308,14 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
  */
 #define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
 
+/*
+ * Like ACCESS_ONCE, but can be optimized away if nothing uses the value,
+ * and/or merged with previous non-ONCE accesses.
+ */
+#define ACCESS_AT_MOST_ONCE(x)			\
+	({	unsigned long __y;		\
+		asm("":"=r" (__y):"0" (x));	\
+		(__force __typeof__(x)) __y;	\
+	})
+
 #endif /* __LINUX_COMPILER_H */


