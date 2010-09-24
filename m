Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961Ab0IXQmd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:42:33 -0400
Received: from kroah.org ([198.145.64.141]:37222 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933040Ab0IXQfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:35:24 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:33:47 2010
Message-Id: <20100924163347.219871923@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:32:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Petr Tesarik <ptesarik@suse.cz>, Tony Luck <tony.luck@intel.com>
Subject: [36/68] IA64: Optimize ticket spinlocks in fsys_rt_sigprocmask
In-Reply-To: <20100924163357.GA15741@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Petr Tesarik <ptesarik@suse.cz>

commit 2d2b6901649a62977452be85df53eda2412def24 upstream.

Tony's fix (f574c843191728d9407b766a027f779dcd27b272) has a small bug,
it incorrectly uses "r3" as a scratch register in the first of the two
unlock paths ... it is also inefficient.  Optimize the fast path again.

Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/ia64/kernel/fsys.S |   42 +++++++++++-------------------------------
 1 file changed, 11 insertions(+), 31 deletions(-)

--- a/arch/ia64/kernel/fsys.S
+++ b/arch/ia64/kernel/fsys.S
@@ -420,34 +420,31 @@ EX(.fail_efault, ld8 r14=[r33])			// r14
 	;;
 
 	RSM_PSR_I(p0, r18, r19)			// mask interrupt delivery
-	mov ar.ccv=0
 	andcm r14=r14,r17			// filter out SIGKILL & SIGSTOP
+	mov r8=EINVAL			// default to EINVAL
 
 #ifdef CONFIG_SMP
 	// __ticket_spin_trylock(r31)
 	ld4 r17=[r31]
-	mov r8=EINVAL			// default to EINVAL
-	;;
-	extr r9=r17,17,15
 	;;
-	xor r18=r17,r9
+	mov.m ar.ccv=r17
+	extr.u r9=r17,17,15
 	adds r19=1,r17
+	extr.u r18=r17,0,15
 	;;
-	extr.u r18=r18,0,15
+	cmp.eq p6,p7=r9,r18
 	;;
-	cmp.eq p0,p7=0,r18
+(p6)	cmpxchg4.acq r9=[r31],r19,ar.ccv
+(p6)	dep.z r20=r19,1,15		// next serving ticket for unlock
 (p7)	br.cond.spnt.many .lock_contention
-	mov.m ar.ccv=r17
-	;;
-	cmpxchg4.acq r9=[r31],r19,ar.ccv
 	;;
 	cmp4.eq p0,p7=r9,r17
+	adds r31=2,r31
 (p7)	br.cond.spnt.many .lock_contention
 	ld8 r3=[r2]			// re-read current->blocked now that we hold the lock
 	;;
 #else
 	ld8 r3=[r2]			// re-read current->blocked now that we hold the lock
-	mov r8=EINVAL			// default to EINVAL
 #endif
 	add r18=IA64_TASK_PENDING_OFFSET+IA64_SIGPENDING_SIGNAL_OFFSET,r16
 	add r19=IA64_TASK_SIGNAL_OFFSET,r16
@@ -503,16 +500,8 @@ EX(.fail_efault, ld8 r14=[r33])			// r14
 
 #ifdef CONFIG_SMP
 	// __ticket_spin_unlock(r31)
-	adds r31=2,r31
-	;;
-	ld2.bias r2=[r31]
-	mov r3=65534
-	;;
-	adds r2=2,r2
-	;;
-	and r3=r3,r2
-	;;
-	st2.rel [r31]=r3
+	st2.rel [r31]=r20
+	mov r20=0					// i must not leak kernel bits...
 #endif
 	SSM_PSR_I(p0, p9, r31)
 	;;
@@ -535,16 +524,7 @@ EX(.fail_efault, (p15) st8 [r34]=r3)
 .sig_pending:
 #ifdef CONFIG_SMP
 	// __ticket_spin_unlock(r31)
-	adds r31=2,r31
-	;;
-	ld2.bias r2=[r31]
-	mov r3=65534
-	;;
-	adds r2=2,r2
-	;;
-	and r3=r3,r2
-	;;
-	st2.rel [r31]=r3
+	st2.rel [r31]=r20			// release the lock
 #endif
 	SSM_PSR_I(p0, p9, r17)
 	;;


