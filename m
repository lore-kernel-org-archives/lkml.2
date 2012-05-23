Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965022Ab2EWCoP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 22:44:15 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:53142 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964844Ab2EWCoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 22:44:10 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Masami Hiramatsu <mhiramat@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Use test_and_clear_bit() instead atomic_dec_and_test() for stop_machine
References: <87likkt7u6.fsf@devron.myhome.or.jp>
	<87ehqct7a3.fsf@devron.myhome.or.jp>
	<20120522214633.GB30024@home.goodmis.org>
Date: Wed, 23 May 2012 11:44:04 +0900
In-Reply-To: <20120522214633.GB30024@home.goodmis.org> (Steven Rostedt's
	message of "Tue, 22 May 2012 17:46:33 -0400")
Message-ID: <87aa0zty4r.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:

> On Wed, May 23, 2012 at 03:11:48AM +0900, OGAWA Hirofumi wrote:
>> [forgot to Cc: lkml, resend]
>> 
>> Hi,
>> 
>> Maybe, nobody using debug patch in atomic_dec_and_test()...  Well,
>> anyway, how about this?
>
> What debug patch?

It is this patch. I got this from -mm (akpm series), I don't know
whether -mm is still using though.

The patch below will detect atomic counter underflows.  This has been
test-driven in the -RT patchset for some time.  qdisc_destroy() triggered
it sometimes (in a seemingly nonfatal way, during device shutdown) - with
DaveM suggesting that it is most likely a bug in the networking code.  So
it would be nice to have this in -mm for some time to validate all atomic
counters on a broader base.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

Change it to atomic check.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 arch/x86/include/asm/atomic.h      |   13 +++++++++++++
 arch/x86/include/asm/atomic64_32.h |    5 ++++-
 arch/x86/include/asm/atomic64_64.h |   12 ++++++++++++
 3 files changed, 29 insertions(+), 1 deletion(-)

diff -puN arch/x86/include/asm/atomic.h~debug_atomic_t-underflows-atomic arch/x86/include/asm/atomic.h
--- linux/arch/x86/include/asm/atomic.h~debug_atomic_t-underflows-atomic	2012-04-03 17:29:38.000000000 +0900
+++ linux-hirofumi/arch/x86/include/asm/atomic.h	2012-04-03 17:29:38.000000000 +0900
@@ -6,6 +6,18 @@
 #include <asm/processor.h>
 #include <asm/alternative.h>
 #include <asm/cmpxchg.h>
+#include <asm/bug.h>
+
+#define ATOMIC_UNDERFLOW_CHECK(v)	do {				\
+	unsigned char __sf;						\
+	/* if (atomic_read(v) < 0) */					\
+	__asm__ __volatile__("sets %0"					\
+			     : "=qm" (__sf)				\
+			     : /* no input */				\
+			     : "memory");				\
+	WARN(__sf, KERN_ERR "atomic counter underflow: %d\n",		\
+	     atomic_read(v));						\
+} while(0)
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
@@ -123,6 +135,7 @@ static inline int atomic_dec_and_test(at
 	asm volatile(LOCK_PREFIX "decl %0; sete %1"
 		     : "+m" (v->counter), "=qm" (c)
 		     : : "memory");
+	ATOMIC_UNDERFLOW_CHECK(v);
 	return c != 0;
 }
 
diff -puN arch/x86/include/asm/atomic64_32.h~debug_atomic_t-underflows-atomic arch/x86/include/asm/atomic64_32.h
--- linux/arch/x86/include/asm/atomic64_32.h~debug_atomic_t-underflows-atomic	2012-04-03 17:29:38.000000000 +0900
+++ linux-hirofumi/arch/x86/include/asm/atomic64_32.h	2012-04-03 17:29:38.000000000 +0900
@@ -244,7 +244,10 @@ static inline void atomic64_dec(atomic64
  */
 static inline int atomic64_dec_and_test(atomic64_t *v)
 {
-	return atomic64_dec_return(v) == 0;
+	long long ret = atomic64_dec_return(v);
+	WARN(ret < 0, KERN_ERR "atomic counter underflow: %lld\n",
+	     atomic64_read(v));
+	return ret == 0;
 }
 
 /**
diff -puN arch/x86/include/asm/atomic64_64.h~debug_atomic_t-underflows-atomic arch/x86/include/asm/atomic64_64.h
--- linux/arch/x86/include/asm/atomic64_64.h~debug_atomic_t-underflows-atomic	2012-04-03 17:29:38.000000000 +0900
+++ linux-hirofumi/arch/x86/include/asm/atomic64_64.h	2012-04-03 17:29:38.000000000 +0900
@@ -5,6 +5,17 @@
 #include <asm/alternative.h>
 #include <asm/cmpxchg.h>
 
+#define ATOMIC64_UNDERFLOW_CHECK(v)	do {				\
+	unsigned char __sf;						\
+	/* if (atomic64_read(v) < 0) */					\
+	__asm__ __volatile__("sets %0"					\
+			     : "=qm" (__sf)				\
+			     : /* no input */				\
+			     : "memory");				\
+	WARN(__sf, KERN_ERR "atomic counter underflow: %ld\n",		\
+	     atomic64_read(v));						\
+} while(0)
+
 /* The 64-bit atomic type */
 
 #define ATOMIC64_INIT(i)	{ (i) }
@@ -121,6 +132,7 @@ static inline int atomic64_dec_and_test(
 	asm volatile(LOCK_PREFIX "decq %0; sete %1"
 		     : "=m" (v->counter), "=qm" (c)
 		     : "m" (v->counter) : "memory");
+	ATOMIC64_UNDERFLOW_CHECK(v);
 	return c != 0;
 }
 
_

>> stop_machine_first is just to see if it is first one or not.  So, there
>> is no reason to use atomic_dec_and_test(), and makes the value below 0.
>> 
>> I think it is not desirable, because this usage only triggers
>> atomic_dec_and_test() underflow debug patch. (the patch tests result
>> of atomic_dec_and_test() is < 0)
>
> Well it should only underflow if you have a box with more than 2 billion
> CPUs.

It meant < 0, not underflow INT_MIN.

>> -static atomic_t stop_machine_first;
>> +static unsigned long stop_machine_first;
>
> The down side to this is that it adds 4 more bytes on a 64bit
> machine. (sizeof(unsigned log) == 8 and sizeof(atomic_t) == 4)

Oh, sure. If nobody has interest, unfortunately I will use this as my
local patch...

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
