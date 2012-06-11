Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836Ab2FKEYw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 00:24:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54973 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab2FKEYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 00:24:51 -0400
Date: Sun, 10 Jun 2012 21:24:37 -0700
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Message-ID: <tip-70fb74a5420f9caa3e001d65004e4b669124283e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, rostedt@goodmis.org,
        srostedt@redhat.com, tglx@linutronix.de, avi@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, torvalds@linux-foundation.org,
        srostedt@redhat.com, tglx@linutronix.de, avi@redhat.com
In-Reply-To: <4FBB8C40.6080304@redhat.com>
References: <4FBB8C40.6080304@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86:
  Save cr2 in NMI in case NMIs take a page fault (for i386)
Git-Commit-ID: 70fb74a5420f9caa3e001d65004e4b669124283e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 10 Jun 2012 21:24:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  70fb74a5420f9caa3e001d65004e4b669124283e
Gitweb:     http://git.kernel.org/tip/70fb74a5420f9caa3e001d65004e4b669124283e
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Thu, 7 Jun 2012 11:54:37 -0400
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Fri, 8 Jun 2012 18:51:12 -0400

x86: Save cr2 in NMI in case NMIs take a page fault (for i386)

Avi Kivity reported that page faults in NMIs could cause havic if
the NMI preempted another page fault handler:

   The recent changes to NMI allow exceptions to take place in NMI
   handlers, but I think that a #PF (say, due to access to vmalloc space)
   is still problematic.  Consider the sequence

    #PF  (cr2 set by processor)
      NMI
        ...
        #PF (cr2 clobbered)
          do_page_fault()
          IRET
        ...
        IRET
      do_page_fault()
        address = read_cr2()

   The last line reads the overwritten cr2 value.

This is the i386 version, which has the luxury of doing the work
in C code.

Link: http://lkml.kernel.org/r/4FBB8C40.6080304@redhat.com

Reported-by: Avi Kivity <avi@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/nmi.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index a15a888..f84f5c5 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -395,6 +395,14 @@ static __kprobes void default_do_nmi(struct pt_regs *regs)
  * thus there is no race between the first check of state for NOT_RUNNING
  * and setting it to NMI_EXECUTING. The HW will prevent nested NMIs
  * at this point.
+ *
+ * In case the NMI takes a page fault, we need to save off the CR2
+ * because the NMI could have preempted another page fault and corrupt
+ * the CR2 that is about to be read. As nested NMIs must be restarted
+ * and they can not take breakpoints or page faults, the update of the
+ * CR2 must be done before converting the nmi state back to NOT_RUNNING.
+ * Otherwise, there would be a race of another nested NMI coming in
+ * after setting state to NOT_RUNNING but before updating the nmi_cr2.
  */
 enum nmi_states {
 	NMI_NOT_RUNNING = 0,
@@ -402,6 +410,7 @@ enum nmi_states {
 	NMI_LATCHED,
 };
 static DEFINE_PER_CPU(enum nmi_states, nmi_state);
+static DEFINE_PER_CPU(unsigned long, nmi_cr2);
 
 #define nmi_nesting_preprocess(regs)					\
 	do {								\
@@ -410,11 +419,14 @@ static DEFINE_PER_CPU(enum nmi_states, nmi_state);
 			return;						\
 		}							\
 		this_cpu_write(nmi_state, NMI_EXECUTING);		\
+		this_cpu_write(nmi_cr2, read_cr2());			\
 	} while (0);							\
 	nmi_restart:
 
 #define nmi_nesting_postprocess()					\
 	do {								\
+		if (unlikely(this_cpu_read(nmi_cr2) != read_cr2()))	\
+			write_cr2(this_cpu_read(nmi_cr2));		\
 		if (this_cpu_dec_return(nmi_state))			\
 			goto nmi_restart;				\
 	} while (0)
