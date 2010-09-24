Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933076Ab0IXQmo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:42:44 -0400
Received: from kroah.org ([198.145.64.141]:37218 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933038Ab0IXQfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:35:23 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:33:47 2010
Message-Id: <20100924163347.131029066@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:31:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tony Luck <tony.luck@intel.com>
Subject: [35/68] IA64: fix siglock
In-Reply-To: <20100924163357.GA15741@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tony Luck <tony.luck@intel.com>

commit f574c843191728d9407b766a027f779dcd27b272 upstream.

When ia64 converted to using ticket locks, an inline implementation
of trylock/unlock in fsys.S was missed.  This was not noticed because
in most circumstances it simply resulted in using the slow path because
the siglock was apparently not available (under old spinlock rules).

Problems occur when the ticket spinlock has value 0x0 (when first
initialised, or when it wraps around). At this point the fsys.S
code acquires the lock (changing the 0x0 to 0x1. If another process
attempts to get the lock at this point, it will change the value from
0x1 to 0x2 (using new ticket lock rules). Then the fsys.S code will
free the lock using old spinlock rules by writing 0x0 to it. From
here a variety of bad things can happen.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/ia64/kernel/fsys.S |   46 +++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 39 insertions(+), 7 deletions(-)

--- a/arch/ia64/kernel/fsys.S
+++ b/arch/ia64/kernel/fsys.S
@@ -424,14 +424,26 @@ EX(.fail_efault, ld8 r14=[r33])			// r14
 	andcm r14=r14,r17			// filter out SIGKILL & SIGSTOP
 
 #ifdef CONFIG_SMP
-	mov r17=1
-	;;
-	cmpxchg4.acq r18=[r31],r17,ar.ccv	// try to acquire the lock
+	// __ticket_spin_trylock(r31)
+	ld4 r17=[r31]
 	mov r8=EINVAL			// default to EINVAL
 	;;
+	extr r9=r17,17,15
+	;;
+	xor r18=r17,r9
+	adds r19=1,r17
+	;;
+	extr.u r18=r18,0,15
+	;;
+	cmp.eq p0,p7=0,r18
+(p7)	br.cond.spnt.many .lock_contention
+	mov.m ar.ccv=r17
+	;;
+	cmpxchg4.acq r9=[r31],r19,ar.ccv
+	;;
+	cmp4.eq p0,p7=r9,r17
+(p7)	br.cond.spnt.many .lock_contention
 	ld8 r3=[r2]			// re-read current->blocked now that we hold the lock
-	cmp4.ne p6,p0=r18,r0
-(p6)	br.cond.spnt.many .lock_contention
 	;;
 #else
 	ld8 r3=[r2]			// re-read current->blocked now that we hold the lock
@@ -490,7 +502,17 @@ EX(.fail_efault, ld8 r14=[r33])			// r14
 (p6)	br.cond.spnt.few 1b			// yes -> retry
 
 #ifdef CONFIG_SMP
-	st4.rel [r31]=r0			// release the lock
+	// __ticket_spin_unlock(r31)
+	adds r31=2,r31
+	;;
+	ld2.bias r2=[r31]
+	mov r3=65534
+	;;
+	adds r2=2,r2
+	;;
+	and r3=r3,r2
+	;;
+	st2.rel [r31]=r3
 #endif
 	SSM_PSR_I(p0, p9, r31)
 	;;
@@ -512,7 +534,17 @@ EX(.fail_efault, (p15) st8 [r34]=r3)
 
 .sig_pending:
 #ifdef CONFIG_SMP
-	st4.rel [r31]=r0			// release the lock
+	// __ticket_spin_unlock(r31)
+	adds r31=2,r31
+	;;
+	ld2.bias r2=[r31]
+	mov r3=65534
+	;;
+	adds r2=2,r2
+	;;
+	and r3=r3,r2
+	;;
+	st2.rel [r31]=r3
 #endif
 	SSM_PSR_I(p0, p9, r17)
 	;;


