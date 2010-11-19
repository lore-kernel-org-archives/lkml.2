Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507Ab0KSJwo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 04:52:44 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:46626 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279Ab0KSJwm convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:6:1>);
	Fri, 19 Nov 2010 04:52:42 -0500
Message-Id: <4CE656F402000078000234A0@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 19 Nov 2010 09:52:36 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <stable@kernel.org>, <cebbert@redhat.com>, "Jeff Mahoney" <jeffm@suse.com>,
        <linux-kernel@vger.kernel.org>, <viro@zeniv.linux.org.uk>
Subject: [PATCH] x86: restore 9d55b9923a1b7ea8193b8875c57ec940dc2ff027
	 (x86: replace LOCK_PREFIX in futex.h)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Somehow this change got lost during the move from include/asm-x86 to
arch/x86/include/asm (i.e. between .27 and .28, while the original fix
was applied for .25). The original commit comment was

"The exception fixup for the futex macros __futex_atomic_op1/2 and
 futex_atomic_cmpxchg_inatomic() is missing an entry when the lock
 prefix is replaced by a NOP via SMP alternatives.

 Chuck Ebert tracked this down from the information provided in:
 https://bugzilla.redhat.com/show_bug.cgi?id=429412 

 A possible solution would be to add another fixup after the
 LOCK_PREFIX, so both the LOCK and NOP case have their own entry in
 the exception table, but it's not really worth the trouble.

 Simply replace LOCK_PREFIX with lock and keep those untouched by SMP
 alternatives."

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: stable@kernel.org 
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Chuck Ebbert <cebbert@redhat.com>
Cc: Jeff Mahoney <jeffm@suse.com>

---
 arch/x86/include/asm/futex.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.37-rc2/arch/x86/include/asm/futex.h
+++ linux-2.6.37-rc2/arch/x86/include/asm/futex.h
@@ -25,7 +25,7 @@
 	asm volatile("1:\tmovl	%2, %0\n"			\
 		     "\tmovl\t%0, %3\n"				\
 		     "\t" insn "\n"				\
-		     "2:\t" LOCK_PREFIX "cmpxchgl %3, %2\n"	\
+		     "2:\tlock; cmpxchgl %3, %2\n"	\
 		     "\tjnz\t1b\n"				\
 		     "3:\t.section .fixup,\"ax\"\n"		\
 		     "4:\tmov\t%5, %1\n"			\
@@ -64,7 +64,7 @@ static inline int futex_atomic_op_inuser
 		__futex_atomic_op1("xchgl %0, %2", ret, oldval, uaddr, oparg);
 		break;
 	case FUTEX_OP_ADD:
-		__futex_atomic_op1(LOCK_PREFIX "xaddl %0, %2", ret, oldval,
+		__futex_atomic_op1("lock; xaddl %0, %2", ret, oldval,
 				   uaddr, oparg);
 		break;
 	case FUTEX_OP_OR:
@@ -122,7 +122,7 @@ static inline int futex_atomic_cmpxchg_i
 	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
 		return -EFAULT;
 
-	asm volatile("1:\t" LOCK_PREFIX "cmpxchgl %3, %1\n"
+	asm volatile("1:\tlock; cmpxchgl %3, %1\n"
 		     "2:\t.section .fixup, \"ax\"\n"
 		     "3:\tmov     %2, %0\n"
 		     "\tjmp     2b\n"



