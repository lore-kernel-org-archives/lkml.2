Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932600Ab0D3RPH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:15:07 -0400
Received: from mail.openrapids.net ([64.15.138.104]:47286 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932838Ab0D3ROu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:14:50 -0400
Date: Fri, 30 Apr 2010 12:22:16 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: David Howells <dhowells@redhat.com>
Cc: Peter Fritzsche <peter.fritzsche@gmx.de>,
       Jamie Lokier <jamie@shareable.org>, Arnd Bergmann <arnd@arndb.de>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Keith M Wesolowski <wesolows@foobazco.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: mn10300 use generic atomic.h
Message-ID: <20100430162216.GA32570@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 12:20:21 up 97 days, 18:57, 11 users,  load average: 0.07, 0.06,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

asm-generic/atomic.h has been derived from the mn10300 implementation. Remove
the now duplicated mn10300 implementation by including the generic version
instead.

This adds cmpxchg_local() and cmpxchg64_local() for free to the architecture, as
they are implemented in asm-generic/atomic.h.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Acked-by: David Howells <dhowells@redhat.com>
Acked-by: Peter Fritzsche <peter.fritzsche@gmx.de>
CC: Jamie Lokier <jamie@shareable.org>
CC: Arnd Bergmann <arnd@arndb.de>
CC: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Keith M Wesolowski <wesolows@foobazco.org>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 arch/mn10300/include/asm/atomic.h |  158 --------------------------------------
 1 file changed, 1 insertion(+), 157 deletions(-)

Index: linux.trees.git/arch/mn10300/include/asm/atomic.h
===================================================================
--- linux.trees.git.orig/arch/mn10300/include/asm/atomic.h	2010-04-30 12:16:39.000000000 -0400
+++ linux.trees.git/arch/mn10300/include/asm/atomic.h	2010-04-30 12:16:54.000000000 -0400
@@ -1,157 +1 @@
-/* MN10300 Atomic counter operations
- *
- * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
- */
-#ifndef _ASM_ATOMIC_H
-#define _ASM_ATOMIC_H
-
-#ifdef CONFIG_SMP
-#error not SMP safe
-#endif
-
-/*
- * Atomic operations that C can't guarantee us.  Useful for
- * resource counting etc..
- */
-
-#define ATOMIC_INIT(i)	{ (i) }
-
-#ifdef __KERNEL__
-
-/**
- * atomic_read - read atomic variable
- * @v: pointer of type atomic_t
- *
- * Atomically reads the value of @v.  Note that the guaranteed
- * useful range of an atomic_t is only 24 bits.
- */
-#define atomic_read(v)	((v)->counter)
-
-/**
- * atomic_set - set atomic variable
- * @v: pointer of type atomic_t
- * @i: required value
- *
- * Atomically sets the value of @v to @i.  Note that the guaranteed
- * useful range of an atomic_t is only 24 bits.
- */
-#define atomic_set(v, i) (((v)->counter) = (i))
-
-#include <asm/system.h>
-
-/**
- * atomic_add_return - add integer to atomic variable
- * @i: integer value to add
- * @v: pointer of type atomic_t
- *
- * Atomically adds @i to @v and returns the result
- * Note that the guaranteed useful range of an atomic_t is only 24 bits.
- */
-static inline int atomic_add_return(int i, atomic_t *v)
-{
-	unsigned long flags;
-	int temp;
-
-	local_irq_save(flags);
-	temp = v->counter;
-	temp += i;
-	v->counter = temp;
-	local_irq_restore(flags);
-
-	return temp;
-}
-
-/**
- * atomic_sub_return - subtract integer from atomic variable
- * @i: integer value to subtract
- * @v: pointer of type atomic_t
- *
- * Atomically subtracts @i from @v and returns the result
- * Note that the guaranteed useful range of an atomic_t is only 24 bits.
- */
-static inline int atomic_sub_return(int i, atomic_t *v)
-{
-	unsigned long flags;
-	int temp;
-
-	local_irq_save(flags);
-	temp = v->counter;
-	temp -= i;
-	v->counter = temp;
-	local_irq_restore(flags);
-
-	return temp;
-}
-
-static inline int atomic_add_negative(int i, atomic_t *v)
-{
-	return atomic_add_return(i, v) < 0;
-}
-
-static inline void atomic_add(int i, atomic_t *v)
-{
-	atomic_add_return(i, v);
-}
-
-static inline void atomic_sub(int i, atomic_t *v)
-{
-	atomic_sub_return(i, v);
-}
-
-static inline void atomic_inc(atomic_t *v)
-{
-	atomic_add_return(1, v);
-}
-
-static inline void atomic_dec(atomic_t *v)
-{
-	atomic_sub_return(1, v);
-}
-
-#define atomic_dec_return(v)		atomic_sub_return(1, (v))
-#define atomic_inc_return(v)		atomic_add_return(1, (v))
-
-#define atomic_sub_and_test(i, v)	(atomic_sub_return((i), (v)) == 0)
-#define atomic_dec_and_test(v)		(atomic_sub_return(1, (v)) == 0)
-#define atomic_inc_and_test(v)		(atomic_add_return(1, (v)) == 0)
-
-#define atomic_add_unless(v, a, u)				\
-({								\
-	int c, old;						\
-	c = atomic_read(v);					\
-	while (c != (u) && (old = atomic_cmpxchg((v), c, c + (a))) != c) \
-		c = old;					\
-	c != (u);						\
-})
-
-#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
-
-static inline void atomic_clear_mask(unsigned long mask, unsigned long *addr)
-{
-	unsigned long flags;
-
-	mask = ~mask;
-	local_irq_save(flags);
-	*addr &= mask;
-	local_irq_restore(flags);
-}
-
-#define atomic_xchg(ptr, v)		(xchg(&(ptr)->counter, (v)))
-#define atomic_cmpxchg(v, old, new)	(cmpxchg(&((v)->counter), (old), (new)))
-
-/* Atomic operations are already serializing on MN10300??? */
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
-
-#include <asm-generic/atomic-long.h>
-
-#endif /* __KERNEL__ */
-#endif /* _ASM_ATOMIC_H */
+#include <asm-generic/atomic.h>
-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
