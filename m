Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932731Ab2ISRSl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 13:18:41 -0400
Received: from mga14.intel.com ([143.182.124.37]:41512 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756636Ab2ISRSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 13:18:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,450,1344236400"; 
   d="scan'208";a="146810739"
Subject: Re: [PATCH 3/6] x86, kvm: use kernel_fpu_begin/end() in
 kvm_load/put_guest_fpu()
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: hpa@zytor.com, mingo@kernel.org, torvalds@linux-foundation.org,
        andreas.herrmann3@amd.com, bp@amd64.org, robert.richter@amd.com,
        linux-kernel@vger.kernel.org
Date: Wed, 19 Sep 2012 10:18:22 -0700
In-Reply-To: <50599AE2.80601@redhat.com>
References: <1345842782-24175-1-git-send-email-suresh.b.siddha@intel.com>
	 <1345842782-24175-4-git-send-email-suresh.b.siddha@intel.com>
	 <50599AE2.80601@redhat.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1348075103.26695.301.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-19 at 13:13 +0300, Avi Kivity wrote:
> On 08/25/2012 12:12 AM, Suresh Siddha wrote:
> > kvm's guest fpu save/restore should be wrapped around
> > kernel_fpu_begin/end(). This will avoid for example taking a DNA
> > in kvm_load_guest_fpu() when it tries to load the fpu immediately
> > after doing unlazy_fpu() on the host side.
> > 
> > More importantly this will prevent the host process fpu from being
> > corrupted.
> > 
> > Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> > Cc: Avi Kivity <avi@redhat.com>
> > ---
> >  arch/x86/kvm/x86.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 42bce48..67e773c 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -5969,7 +5969,7 @@ void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
> >  	 */
> >  	kvm_put_guest_xcr0(vcpu);
> >  	vcpu->guest_fpu_loaded = 1;
> > -	unlazy_fpu(current);
> > +	kernel_fpu_begin();
> >  	fpu_restore_checking(&vcpu->arch.guest_fpu);
> >  	trace_kvm_fpu(1);
> 
> This breaks kvm, since it disables preemption.  What we want here is to
> save the user fpu state if it was loaded, and do nothing if wasn't.
> Don't know what's the new API for that.

These routines (kvm_load/put_guest_fpu()) are already called with
preemption disabled but as you mentioned, we don't want the preemption
to be disabled completely between the kvm_load_guest_fpu() and
kvm_put_guest_fpu().

Also KVM already has the preempt notifier which is doing the
kvm_put_guest_fpu(), so something like the appended should address this.
I will test this shortly.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/include/asm/i387.h |   17 +++++++++++++++--
 arch/x86/kernel/i387.c      |   13 +++++--------
 arch/x86/kvm/x86.c          |    4 ++--
 3 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 6c3bd37..29429b1 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -24,8 +24,21 @@ extern int dump_fpu(struct pt_regs *, struct user_i387_struct *);
 extern void math_state_restore(void);
 
 extern bool irq_fpu_usable(void);
-extern void kernel_fpu_begin(void);
-extern void kernel_fpu_end(void);
+extern void __kernel_fpu_begin(void);
+extern void __kernel_fpu_end(void);
+
+static inline void kernel_fpu_begin(void)
+{
+	WARN_ON_ONCE(!irq_fpu_usable());
+	preempt_disable();
+	__kernel_fpu_begin();
+}
+
+static inline void kernel_fpu_end(void)
+{
+	__kernel_fpu_end();
+	preempt_enable();
+}
 
 /*
  * Some instructions like VIA's padlock instructions generate a spurious
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 6782e39..675a050 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -73,32 +73,29 @@ bool irq_fpu_usable(void)
 }
 EXPORT_SYMBOL(irq_fpu_usable);
 
-void kernel_fpu_begin(void)
+void __kernel_fpu_begin(void)
 {
 	struct task_struct *me = current;
 
-	WARN_ON_ONCE(!irq_fpu_usable());
-	preempt_disable();
 	if (__thread_has_fpu(me)) {
 		__save_init_fpu(me);
 		__thread_clear_has_fpu(me);
-		/* We do 'stts()' in kernel_fpu_end() */
+		/* We do 'stts()' in __kernel_fpu_end() */
 	} else if (!use_eager_fpu()) {
 		this_cpu_write(fpu_owner_task, NULL);
 		clts();
 	}
 }
-EXPORT_SYMBOL(kernel_fpu_begin);
+EXPORT_SYMBOL(__kernel_fpu_begin);
 
-void kernel_fpu_end(void)
+void __kernel_fpu_end(void)
 {
 	if (use_eager_fpu())
 		math_state_restore();
 	else
 		stts();
-	preempt_enable();
 }
-EXPORT_SYMBOL(kernel_fpu_end);
+EXPORT_SYMBOL(__kernel_fpu_end);
 
 void unlazy_fpu(struct task_struct *tsk)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3ddefb4..1f09552 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5979,7 +5979,7 @@ void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
 	 */
 	kvm_put_guest_xcr0(vcpu);
 	vcpu->guest_fpu_loaded = 1;
-	kernel_fpu_begin();
+	__kernel_fpu_begin();
 	fpu_restore_checking(&vcpu->arch.guest_fpu);
 	trace_kvm_fpu(1);
 }
@@ -5993,7 +5993,7 @@ void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 
 	vcpu->guest_fpu_loaded = 0;
 	fpu_save_init(&vcpu->arch.guest_fpu);
-	kernel_fpu_end();
+	__kernel_fpu_end();
 	++vcpu->stat.fpu_reload;
 	kvm_make_request(KVM_REQ_DEACTIVATE_FPU, vcpu);
 	trace_kvm_fpu(0);


