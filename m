Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116Ab0DTCOR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 22:14:17 -0400
Received: from mga05.intel.com ([192.55.52.89]:42530 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751138Ab0DTCOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 22:14:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,239,1270450800"; 
   d="scan'208";a="559512522"
Subject: Re: [PATCH V5 1/3] perf & kvm: Enhance perf to collect KVM guest
 os statistics from host side
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       zhiteng.huang@intel.com, tim.c.chen@intel.com,
       Arnaldo Carvalho de Melo <acme@infradead.org>
In-Reply-To: <20100419181154.GA14631@elte.hu>
References: <1271655161.2078.603.camel@ymzhang.sh.intel.com>
	 <20100419181154.GA14631@elte.hu>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 20 Apr 2010 10:13:58 +0800
Message-Id: <1271729638.2078.624.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-19 at 20:11 +0200, Ingo Molnar wrote:
> FYI, i found a few problems that need fixing:
> 
> > +	unsigned long ip;
> > +	if (perf_guest_cbs && perf_guest_cbs->is_in_guest())
> 
> missing newline.
> 
> > +	int misc = 0;
> > +	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
> 
> ditto.
> 
> > +			PERF_RECORD_MISC_GUEST_KERNEL;
> > +	} else
> > +		misc |= user_mode(regs) ? PERF_RECORD_MISC_USER :
> > +			PERF_RECORD_MISC_KERNEL;
> 
> - unbalanced curly braces
> - missing curly brace for multi-line statement.
> - unnecessary line-break due to col80 warning from checkpatch
> 
> > +extern struct perf_guest_info_callbacks *perf_guest_cbs;
> > +extern int perf_register_guest_info_callbacks(
> > +		struct perf_guest_info_callbacks *);
> > +extern int perf_unregister_guest_info_callbacks(
> > +		struct perf_guest_info_callbacks *);
> 
> - unnecessary line-break due to col80 warning from checkpatch
> 
> > +static inline int perf_register_guest_info_callbacks
> > +(struct perf_guest_info_callbacks *) {return 0; }
> > +static inline int perf_unregister_guest_info_callbacks
> > +(struct perf_guest_info_callbacks *) {return 0; }
> 
> - invalid C: function parameter needs name even if unused
> - missing space after opening curly brace
> 
> Please provide delta fixes.

Here is the fix on the top of the prior 3 patches of V5.

From: Zhang, Yanmin <yanmin_zhang@linux.intel.com>

Fix some programming style issues on the top of perf kvm
enhancement V5.

Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>

---

diff -Nraup linux-2.6_tip0417_perfkvm/arch/x86/kernel/cpu/perf_event.c linux-2.6_tip0417_perfkvmstyle/arch/x86/kernel/cpu/perf_event.c
--- linux-2.6_tip0417_perfkvm/arch/x86/kernel/cpu/perf_event.c	2010-04-19 09:53:59.689452915 +0800
+++ linux-2.6_tip0417_perfkvmstyle/arch/x86/kernel/cpu/perf_event.c	2010-04-20 10:48:18.500999849 +0800
@@ -1752,23 +1752,29 @@ void perf_arch_fetch_caller_regs(struct 
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
+	} else if (user_mode(regs))
+		misc |= PERF_RECORD_MISC_USER;
+	else
+		misc |= PERF_RECORD_MISC_KERNEL;
+
 	if (regs->flags & PERF_EFLAGS_EXACT)
 		misc |= PERF_RECORD_MISC_EXACT;
 
diff -Nraup linux-2.6_tip0417_perfkvm/arch/x86/kvm/x86.c linux-2.6_tip0417_perfkvmstyle/arch/x86/kvm/x86.c
--- linux-2.6_tip0417_perfkvm/arch/x86/kvm/x86.c	2010-04-19 09:53:59.691378953 +0800
+++ linux-2.6_tip0417_perfkvmstyle/arch/x86/kvm/x86.c	2010-04-20 10:11:40.507545564 +0800
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
 
diff -Nraup linux-2.6_tip0417_perfkvm/include/linux/perf_event.h linux-2.6_tip0417_perfkvmstyle/include/linux/perf_event.h
--- linux-2.6_tip0417_perfkvm/include/linux/perf_event.h	2010-04-19 09:53:59.691378953 +0800
+++ linux-2.6_tip0417_perfkvmstyle/include/linux/perf_event.h	2010-04-20 10:08:03.531551890 +0800
@@ -941,10 +941,8 @@ static inline void perf_event_mmap(struc
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


