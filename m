Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab0DTRz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 13:55:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:47207 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753728Ab0DTRzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 13:55:25 -0400
Date: Tue, 20 Apr 2010 17:54:41 GMT
From: "tip-bot for Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       Jes.Sorensen@redhat.com, a.p.zijlstra@chello.nl, joro@8bytes.org,
       yanmin_zhang@linux.intel.com, zamsden@redhat.com, gleb@redhat.com,
       acme@infradead.org, mtosatti@redhat.com, tglx@linutronix.de,
       sheng@linux.intel.com, mingo@elte.hu, avi@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, Jes.Sorensen@redhat.com,
       yanmin_zhang@linux.intel.com, joro@8bytes.org, zamsden@redhat.com,
       gleb@redhat.com, acme@infradead.org, mtosatti@redhat.com,
       sheng@linux.intel.com, tglx@linutronix.de, avi@redhat.com,
       mingo@elte.hu
In-Reply-To: <1271729638.2078.624.camel@ymzhang.sh.intel.com>
References: <1271729638.2078.624.camel@ymzhang.sh.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf & kvm: Clean up some of the guest profiling callback API details
Message-ID: <tip-dcf46b9443ad48a227a61713adea001228925adf@git.kernel.org>
Git-Commit-ID: dcf46b9443ad48a227a61713adea001228925adf
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 20 Apr 2010 17:54:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dcf46b9443ad48a227a61713adea001228925adf
Gitweb:     http://git.kernel.org/tip/dcf46b9443ad48a227a61713adea001228925adf
Author:     Zhang, Yanmin <yanmin_zhang@linux.intel.com>
AuthorDate: Tue, 20 Apr 2010 10:13:58 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 20 Apr 2010 08:08:28 +0200

perf & kvm: Clean up some of the guest profiling callback API details

Fix some build bug and programming style issues:

 - use valid C
 - fix up various style details

Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sheng Yang <sheng@linux.intel.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: oerg Roedel <joro@8bytes.org>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: Zachary Amsden <zamsden@redhat.com>
Cc: zhiteng.huang@intel.com
Cc: tim.c.chen@intel.com
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
LKML-Reference: <1271729638.2078.624.camel@ymzhang.sh.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |   20 ++++++++++++++------
 arch/x86/kvm/x86.c               |    4 ++++
 include/linux/perf_event.h       |   10 ++++------
 3 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 2ea78ab..7de7061 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1752,23 +1752,31 @@ void perf_arch_fetch_caller_regs(struct pt_regs *regs, unsigned long ip, int ski
 unsigned long perf_instruction_pointer(struct pt_regs *regs)
 {
 	unsigned long ip;
+
 	if (perf_guest_cbs && perf_guest_cbs->is_in_guest())
 		ip = perf_guest_cbs->get_guest_ip();
 	else
 		ip = instruction_pointer(regs);
+
 	return ip;
 }
 
 unsigned long perf_misc_flags(struct pt_regs *regs)
 {
 	int misc = 0;
+
 	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
-		misc |= perf_guest_cbs->is_user_mode() ?
-			PERF_RECORD_MISC_GUEST_USER :
-			PERF_RECORD_MISC_GUEST_KERNEL;
-	} else
-		misc |= user_mode(regs) ? PERF_RECORD_MISC_USER :
-			PERF_RECORD_MISC_KERNEL;
+		if (perf_guest_cbs->is_user_mode())
+			misc |= PERF_RECORD_MISC_GUEST_USER;
+		else
+			misc |= PERF_RECORD_MISC_GUEST_KERNEL;
+	} else {
+		if (user_mode(regs))
+			misc |= PERF_RECORD_MISC_USER;
+		else
+			misc |= PERF_RECORD_MISC_KERNEL;
+	}
+
 	if (regs->flags & PERF_EFLAGS_EXACT)
 		misc |= PERF_RECORD_MISC_EXACT;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c3a33b2..21b9b6a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3776,16 +3776,20 @@ static int kvm_is_in_guest(void)
 static int kvm_is_user_mode(void)
 {
 	int user_mode = 3;
+
 	if (percpu_read(current_vcpu))
 		user_mode = kvm_x86_ops->get_cpl(percpu_read(current_vcpu));
+
 	return user_mode != 0;
 }
 
 static unsigned long kvm_get_guest_ip(void)
 {
 	unsigned long ip = 0;
+
 	if (percpu_read(current_vcpu))
 		ip = kvm_rip_read(percpu_read(current_vcpu));
+
 	return ip;
 }
 
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 24de5f1..ace31fb 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -941,10 +941,8 @@ static inline void perf_event_mmap(struct vm_area_struct *vma)
 }
 
 extern struct perf_guest_info_callbacks *perf_guest_cbs;
-extern int perf_register_guest_info_callbacks(
-		struct perf_guest_info_callbacks *);
-extern int perf_unregister_guest_info_callbacks(
-		struct perf_guest_info_callbacks *);
+extern int perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *callbacks);
+extern int perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *callbacks);
 
 extern void perf_event_comm(struct task_struct *tsk);
 extern void perf_event_fork(struct task_struct *tsk);
@@ -1016,9 +1014,9 @@ static inline void
 perf_bp_event(struct perf_event *event, void *data)			{ }
 
 static inline int perf_register_guest_info_callbacks
-(struct perf_guest_info_callbacks *) {return 0; }
+(struct perf_guest_info_callbacks *callbacks) { return 0; }
 static inline int perf_unregister_guest_info_callbacks
-(struct perf_guest_info_callbacks *) {return 0; }
+(struct perf_guest_info_callbacks *callbacks) { return 0; }
 
 static inline void perf_event_mmap(struct vm_area_struct *vma)		{ }
 static inline void perf_event_comm(struct task_struct *tsk)		{ }
