Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348Ab0DVUPF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:15:05 -0400
Received: from kroah.org ([198.145.64.141]:59875 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932082Ab0DVUBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:01:05 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:14 2010
Message-Id: <20100422195414.017018906@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:54:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Avi Kivity <avi@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [089/139] x86-64, rwsem: Avoid store forwarding hazard in __downgrade_write
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Avi Kivity <avi@redhat.com>

commit 0d1622d7f526311d87d7da2ee7dd14b73e45d3fc upstream.

The Intel Architecture Optimization Reference Manual states that a short
load that follows a long store to the same object will suffer a store
forwading penalty, particularly if the two accesses use different addresses.
Trivially, a long load that follows a short store will also suffer a penalty.

__downgrade_write() in rwsem incurs both penalties:  the increment operation
will not be able to reuse a recently-loaded rwsem value, and its result will
not be reused by any recently-following rwsem operation.

A comment in the code states that this is because 64-bit immediates are
special and expensive; but while they are slightly special (only a single
instruction allows them), they aren't expensive: a test shows that two loops,
one loading a 32-bit immediate and one loading a 64-bit immediate, both take
1.5 cycles per iteration.

Fix this by changing __downgrade_write to use the same add instruction on
i386 and on x86_64, so that it uses the same operand size as all the other
rwsem functions.

Signed-off-by: Avi Kivity <avi@redhat.com>
LKML-Reference: <1266049992-17419-1-git-send-email-avi@redhat.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/rwsem.h |   25 +++++--------------------
 1 file changed, 5 insertions(+), 20 deletions(-)

--- a/arch/x86/include/asm/rwsem.h
+++ b/arch/x86/include/asm/rwsem.h
@@ -232,34 +232,19 @@ static inline void __up_write(struct rw_
  */
 static inline void __downgrade_write(struct rw_semaphore *sem)
 {
-#ifdef CONFIG_X86_64
-# if RWSEM_WAITING_BIAS != -0x100000000
-#  error "This code assumes RWSEM_WAITING_BIAS == -2^32"
-# endif
-
-	/* 64-bit immediates are special and expensive, and not needed here */
-	asm volatile("# beginning __downgrade_write\n\t"
-		     LOCK_PREFIX "incl 4(%1)\n\t"
-		     /* transitions 0xZZZZZZZZ00000001 -> 0xYYYYYYYY00000001 */
-		     "  jns       1f\n\t"
-		     "  call call_rwsem_downgrade_wake\n"
-		     "1:\n\t"
-		     "# ending __downgrade_write\n"
-		     : "+m" (sem->count)
-		     : "a" (sem)
-		     : "memory", "cc");
-#else
 	asm volatile("# beginning __downgrade_write\n\t"
 		     LOCK_PREFIX _ASM_ADD "%2,(%1)\n\t"
-		     /* transitions 0xZZZZ0001 -> 0xYYYY0001 */
+		     /*
+		      * transitions 0xZZZZ0001 -> 0xYYYY0001 (i386)
+		      *     0xZZZZZZZZ00000001 -> 0xYYYYYYYY00000001 (x86_64)
+		      */
 		     "  jns       1f\n\t"
 		     "  call call_rwsem_downgrade_wake\n"
 		     "1:\n\t"
 		     "# ending __downgrade_write\n"
 		     : "+m" (sem->count)
-		     : "a" (sem), "i" (-RWSEM_WAITING_BIAS)
+		     : "a" (sem), "er" (-RWSEM_WAITING_BIAS)
 		     : "memory", "cc");
-#endif
 }
 
 /*


