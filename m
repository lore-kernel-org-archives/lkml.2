Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935094Ab2C3VGi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:06:38 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:41969 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935005Ab2C3VG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:06:28 -0400
Message-Id: <201203302105.q2UL5AuV006314@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 30 Mar 2012 16:29:06 -0400
Subject: [PATCH] arch/tile: avoid accidentally unmasking NMI-type interrupt accidentally
In-Reply-To: <4F761E1C.80808.com>
References: <4F761E1C.80808.com>
To: Chris Metcalf <cmetcalf@tilera.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>, Arun Sharma <asharma@fb.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 30 Mar 2012 21:05:11.0038 (UTC) FILETIME=[CB4069E0:01CD0EB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return path as we reload registers and core state requires that r30
hold a boolean indicating whether we are returning from an NMI, but in a
couple of cases we weren't setting this properly, with the result that we
could accidentally unmask the NMI interrupt(s), which could cause confusion.
Now we set r30 in every place where we jump into the interrupt return path.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/intvec_32.S |   24 ++++++++++++++++++++----
 arch/tile/kernel/intvec_64.S |   19 ++++++++++++++++---
 2 files changed, 36 insertions(+), 7 deletions(-)

diff --git a/arch/tile/kernel/intvec_32.S b/arch/tile/kernel/intvec_32.S
index aecc8ed..5d56a1e 100644
--- a/arch/tile/kernel/intvec_32.S
+++ b/arch/tile/kernel/intvec_32.S
@@ -799,6 +799,10 @@ handle_interrupt:
  * This routine takes a boolean in r30 indicating if this is an NMI.
  * If so, we also expect a boolean in r31 indicating whether to
  * re-enable the oprofile interrupts.
+ *
+ * Note that .Lresume_userspace is jumped to directly in several
+ * places, and we need to make sure r30 is set correctly in those
+ * callers as well.
  */
 STD_ENTRY(interrupt_return)
 	/* If we're resuming to kernel space, don't check thread flags. */
@@ -1237,7 +1241,10 @@ handle_syscall:
 	bzt     r30, 1f
 	jal	do_syscall_trace
 	FEEDBACK_REENTER(handle_syscall)
-1:	j       .Lresume_userspace   /* jump into middle of interrupt_return */
+1:	{
+	 movei  r30, 0               /* not an NMI */
+	 j      .Lresume_userspace   /* jump into middle of interrupt_return */
+	}
 
 .Linvalid_syscall:
 	/* Report an invalid syscall back to the user program */
@@ -1246,7 +1253,10 @@ handle_syscall:
 	 movei  r28, -ENOSYS
 	}
 	sw      r29, r28
-	j       .Lresume_userspace   /* jump into middle of interrupt_return */
+	{
+	 movei  r30, 0               /* not an NMI */
+	 j      .Lresume_userspace   /* jump into middle of interrupt_return */
+	}
 	STD_ENDPROC(handle_syscall)
 
 	/* Return the address for oprofile to suppress in backtraces. */
@@ -1262,7 +1272,10 @@ STD_ENTRY(ret_from_fork)
 	jal     sim_notify_fork
 	jal     schedule_tail
 	FEEDBACK_REENTER(ret_from_fork)
-	j       .Lresume_userspace   /* jump into middle of interrupt_return */
+	{
+	 movei  r30, 0               /* not an NMI */
+	 j      .Lresume_userspace   /* jump into middle of interrupt_return */
+	}
 	STD_ENDPROC(ret_from_fork)
 
 	/*
@@ -1376,7 +1389,10 @@ handle_ill:
 
 	jal     send_sigtrap    /* issue a SIGTRAP */
 	FEEDBACK_REENTER(handle_ill)
-	j       .Lresume_userspace   /* jump into middle of interrupt_return */
+	{
+	 movei  r30, 0               /* not an NMI */
+	 j      .Lresume_userspace   /* jump into middle of interrupt_return */
+	}
 
 .Ldispatch_normal_ill:
 	{
diff --git a/arch/tile/kernel/intvec_64.S b/arch/tile/kernel/intvec_64.S
index 7fa656a..8b5daed 100644
--- a/arch/tile/kernel/intvec_64.S
+++ b/arch/tile/kernel/intvec_64.S
@@ -614,6 +614,10 @@ handle_interrupt:
  * This routine takes a boolean in r30 indicating if this is an NMI.
  * If so, we also expect a boolean in r31 indicating whether to
  * re-enable the oprofile interrupts.
+ *
+ * Note that .Lresume_userspace is jumped to directly in several
+ * places, and we need to make sure r30 is set correctly in those
+ * callers as well.
  */
 STD_ENTRY(interrupt_return)
 	/* If we're resuming to kernel space, don't check thread flags. */
@@ -1066,7 +1070,10 @@ handle_syscall:
 	}
 	FEEDBACK_REENTER(handle_syscall)
 
-2:	j       .Lresume_userspace   /* jump into middle of interrupt_return */
+2:	{
+	 movei  r30, 0               /* not an NMI */
+	 j      .Lresume_userspace   /* jump into middle of interrupt_return */
+	}
 
 .Lcompat_syscall:
 	/*
@@ -1100,7 +1107,10 @@ handle_syscall:
 	 movei  r28, -ENOSYS
 	}
 	st      r29, r28
-	j       .Lresume_userspace   /* jump into middle of interrupt_return */
+	{
+	 movei  r30, 0               /* not an NMI */
+	 j      .Lresume_userspace   /* jump into middle of interrupt_return */
+	}
 	STD_ENDPROC(handle_syscall)
 
 	/* Return the address for oprofile to suppress in backtraces. */
@@ -1116,7 +1126,10 @@ STD_ENTRY(ret_from_fork)
 	jal     sim_notify_fork
 	jal     schedule_tail
 	FEEDBACK_REENTER(ret_from_fork)
-	j       .Lresume_userspace
+	{
+	 movei  r30, 0               /* not an NMI */
+	 j      .Lresume_userspace   /* jump into middle of interrupt_return */
+	}
 	STD_ENDPROC(ret_from_fork)
 
 /* Various stub interrupt handlers and syscall handlers */
-- 
1.6.5.2

