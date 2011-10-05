Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935167Ab1JERqL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 13:46:11 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:33874 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935024Ab1JERqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 13:46:10 -0400
Date: Wed, 5 Oct 2011 22:58:35 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>, Shuah Khan <shuah.khan@hp.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH] x86_32: Call do_notify_resume() with interrupts
 enabled
Message-ID: <20111005172835.GA17591@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_notify_resume() gets called with interrupts disabled on x86_32. This
is different from the x86_64 behavior, where interrupts are enabled at
the time.
 
Queries on lkml on this issue hasn't yielded any clear answer. Lets make
x86_32 behave the same as x86_64, unless there is a real reason to
maintain status quo.

Please refer https://lkml.org/lkml/2011/9/27/130 for more details

My 32-bit machine works fine (tm) with the patch below

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 arch/x86/kernel/entry_32.S |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index f3f6f53..29d72ca 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -625,6 +625,7 @@ work_notifysig:				# deal with pending signals and
 	movl %esp, %eax
 	jne work_notifysig_v86		# returning to kernel-space or
 					# vm86-space
+	ENABLE_INTERRUPTS(CLBR_NONE)
 	xorl %edx, %edx
 	call do_notify_resume
 	jmp resume_userspace_sig
@@ -638,6 +639,7 @@ work_notifysig:				# deal with pending signals and
 #else
 	movl %esp, %eax
 #endif
+	ENABLE_INTERRUPTS(CLBR_NONE)
 	xorl %edx, %edx
 	call do_notify_resume
 	jmp resume_userspace_sig
