Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453Ab0EQEiD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 00:38:03 -0400
Received: from ozlabs.org ([203.10.76.45]:56169 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947Ab0EQEiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 00:38:00 -0400
Date: Mon, 17 May 2010 14:34:57 +1000
From: Anton Blanchard <anton@samba.org>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       willy@linux.intel.com, benh@kernel.crashing.org, paulus@samba.org
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2]: atomic_t: Remove volatile from atomic_t definition
Message-ID: <20100517043457.GA22416@kryten>
References: <20100517043353.GA22127@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100517043353.GA22127@kryten>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When looking at a performance problem on PowerPC, I noticed some awful code
generation:

c00000000051fc98:       3b 60 00 01     li      r27,1
...
c00000000051fca0:       3b 80 00 00     li      r28,0
...
c00000000051fcdc:       93 61 00 70     stw     r27,112(r1)
c00000000051fce0:       93 81 00 74     stw     r28,116(r1)
c00000000051fce4:       81 21 00 70     lwz     r9,112(r1)
c00000000051fce8:       80 01 00 74     lwz     r0,116(r1)
c00000000051fcec:       7d 29 07 b4     extsw   r9,r9
c00000000051fcf0:       7c 00 07 b4     extsw   r0,r0

c00000000051fcf4:       7c 20 04 ac     lwsync
c00000000051fcf8:       7d 60 f8 28     lwarx   r11,0,r31
c00000000051fcfc:       7c 0b 48 00     cmpw    r11,r9
c00000000051fd00:       40 c2 00 10     bne-    c00000000051fd10
c00000000051fd04:       7c 00 f9 2d     stwcx.  r0,0,r31
c00000000051fd08:       40 c2 ff f0     bne+    c00000000051fcf8
c00000000051fd0c:       4c 00 01 2c     isync

We create two constants, write them out to the stack, read them straight back
in and sign extend them. What a mess.

It turns out this bad code is a result of us defining atomic_t as a
volatile int.

We removed the volatile attribute from the powerpc atomic_t definition years
ago, but commit ea435467500612636f8f4fb639ff6e76b2496e4b (atomic_t: unify all
arch definitions) added it back in. 

To dig up an old quote from Linus:

> The fact is, volatile on data structures is a bug. It's a wart in the C
> language. It shouldn't be used.
>
> Volatile accesses in *code* can be ok, and if we have "atomic_read()"
> expand to a "*(volatile int *)&(x)->value", then I'd be ok with that.
>
> But marking data structures volatile just makes the compiler screw up
> totally, and makes code for initialization sequences etc much worse.

And screw up it does :)

With the volatile removed, we see much more reasonable code generation:

c00000000051f5b8:       3b 60 00 01     li      r27,1
...
c00000000051f5c0:       3b 80 00 00     li      r28,0
...

c00000000051fc7c:       7c 20 04 ac     lwsync
c00000000051fc80:       7c 00 f8 28     lwarx   r0,0,r31
c00000000051fc84:       7c 00 d8 00     cmpw    r0,r27
c00000000051fc88:       40 c2 00 10     bne-    c00000000051fc98
c00000000051fc8c:       7f 80 f9 2d     stwcx.  r28,0,r31
c00000000051fc90:       40 c2 ff f0     bne+    c00000000051fc80
c00000000051fc94:       4c 00 01 2c     isync

Six instructions less.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux-cpumask/include/linux/types.h
===================================================================
--- linux-cpumask.orig/include/linux/types.h	2010-04-08 19:46:02.916696580 +1000
+++ linux-cpumask/include/linux/types.h	2010-05-17 13:21:59.135964013 +1000
@@ -188,12 +188,12 @@ typedef u32 phys_addr_t;
 typedef phys_addr_t resource_size_t;
 
 typedef struct {
-	volatile int counter;
+	int counter;
 } atomic_t;
 
 #ifdef CONFIG_64BIT
 typedef struct {
-	volatile long counter;
+	long counter;
 } atomic64_t;
 #endif
 
