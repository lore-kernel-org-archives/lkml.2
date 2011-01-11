Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666Ab1AKKaJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 05:30:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31499 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755651Ab1AKKaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 05:30:06 -0500
Message-ID: <4D2C3115.9030301@redhat.com>
Date: Tue, 11 Jan 2011 12:29:41 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill@shutemov.name>
CC: Christoph Lameter <cl@linux.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: BUG: sleeping function called from invalid context at mm/slub.c:793
References: <20110110105433.GA17881@shutemov.name> <alpine.DEB.2.00.1101101051260.12243@router.home> <20110110193117.GA20027@shutemov.name> <4D2C279D.5050309@redhat.com>
In-Reply-To: <4D2C279D.5050309@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------020201020807000707070104"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020201020807000707070104
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 01/11/2011 11:49 AM, Avi Kivity wrote:
> On 01/10/2011 09:31 PM, Kirill A. Shutemov wrote:
>> On Mon, Jan 10, 2011 at 10:52:05AM -0600, Christoph Lameter wrote:
>> >
>> >  On Mon, 10 Jan 2011, Kirill A. Shutemov wrote:
>> >
>> > >  Every time I run qemu with KVM enabled I get this in dmesg:
>> > >
>> > >  [  182.878328] BUG: sleeping function called from invalid 
>> context at mm/slub.c:793
>> > >  [  182.878339] in_atomic(): 1, irqs_disabled(): 0, pid: 4992, 
>> name: qemu
>> > >  [  182.878355] Pid: 4992, comm: qemu Not tainted 2.6.37+ #31
>> > >  [  182.878361] Call Trace:
>> > >  [  182.878381]  [<c104e317>] ? __might_sleep+0xd0/0xd7
>> > >  [  182.878394]  [<c10ec337>] ? 
>> slab_pre_alloc_hook.clone.39+0x23/0x27
>> > >  [  182.878404]  [<c10ece27>] ? kmem_cache_alloc+0x22/0xc8
>> > >  [  182.878414]  [<c1030221>] ? init_fpu+0x44/0x7b
>> >
>> >  fpu_alloc() does call kmem_cache_alloc with GFP_KERNEL although we 
>> are in
>> >  an atomic context.
>>
>> Something like this?
>>
>> ---
>>  From 7c6fbfed72e7d22cbdf7393f9711d521e0fbb4a6 Mon Sep 17 00:00:00 2001
>> From: Kirill A. Shutemov<kirill@shutemov.name>
>> Date: Mon, 10 Jan 2011 21:24:23 +0200
>> Subject: [PATCH] x86, fpu_alloc(): call kmem_cache_alloc() with 
>> GFP_ATOMIC
>>
>> [  182.878328] BUG: sleeping function called from invalid context at 
>> mm/slub.c:793
>> [  182.878339] in_atomic(): 1, irqs_disabled(): 0, pid: 4992, name: qemu
>> [  182.878355] Pid: 4992, comm: qemu Not tainted 2.6.37+ #31
>> [  182.878361] Call Trace:
>> [  182.878381]  [<c104e317>] ? __might_sleep+0xd0/0xd7
>> [  182.878394]  [<c10ec337>] ? slab_pre_alloc_hook.clone.39+0x23/0x27
>> [  182.878404]  [<c10ece27>] ? kmem_cache_alloc+0x22/0xc8
>> [  182.878414]  [<c1030221>] ? init_fpu+0x44/0x7b
>> [  182.878426]  [<c130cc29>] ? do_device_not_available+0x0/0x1b
>> [  182.878435]  [<c1030221>] ? init_fpu+0x44/0x7b
>> [  182.878444]  [<c102a588>] ? math_state_restore+0x24/0x47
>> [  182.878453]  [<c130cc39>] ? do_device_not_available+0x10/0x1b
>> [  182.878462]  [<c130c4ab>] ? error_code+0x67/0x6c
>> [  182.878475]  [<c1012340>] ? kvm_load_guest_fpu+0xa1/0xaa
>> [  182.878484]  [<c1013364>] ? kvm_arch_vcpu_ioctl_run+0x798/0xbe8
>> [  182.878496]  [<c1004523>] ? kvm_vcpu_ioctl+0x105/0x46e
>> [  182.878508]  [<c107dce0>] ? get_futex_key+0x73/0x132
>> [  182.878517]  [<c107e352>] ? futex_wake+0xb6/0xc0
>> [  182.878527]  [<c107f8d6>] ? do_futex+0x87/0x669
>> [  182.878535]  [<c100441e>] ? kvm_vcpu_ioctl+0x0/0x46e
>> [  182.878545]  [<c1101ebf>] ? do_vfs_ioctl+0x4a0/0x4d1
>> [  182.878554]  [<c130e348>] ? do_page_fault+0x2eb/0x316
>> [  182.878564]  [<c1101f36>] ? sys_ioctl+0x46/0x68
>> [  182.878572]  [<c130bdc0>] ? syscall_call+0x7/0xb
>> [  182.878585]  [<c1300000>] ? aer_probe+0x1da/0x274
>>
>> Signed-off-by: Kirill A. Shutemov<kirill@shutemov.name>
>> ---
>>   arch/x86/include/asm/i387.h |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
>> index ef32890..8b896dd 100644
>> --- a/arch/x86/include/asm/i387.h
>> +++ b/arch/x86/include/asm/i387.h
>> @@ -426,7 +426,7 @@ static inline int fpu_alloc(struct fpu *fpu)
>>   {
>>       if (fpu_allocated(fpu))
>>           return 0;
>> -    fpu->state = kmem_cache_alloc(task_xstate_cachep, GFP_KERNEL);
>> +    fpu->state = kmem_cache_alloc(task_xstate_cachep, GFP_ATOMIC);
>>       if (!fpu->state)
>>           return -ENOMEM;
>>       WARN_ON((unsigned long)fpu->state&  15);
>
> If this fails, a task will be killed.  I'll patch kvm to ensure that 
> the fpu is initialized.
>

Please try out the attached patch.

-- 
error compiling committee.c: too many arguments to function


--------------020201020807000707070104
Content-Type: text/x-patch;
 name="0001-KVM-Initialize-fpu-state-in-preemptible-context.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-KVM-Initialize-fpu-state-in-preemptible-context.patch"

>From f3a6041b5bb3bf7c88f9694a66d7f34be2f78845 Mon Sep 17 00:00:00 2001
From: Avi Kivity <avi@redhat.com>
Date: Tue, 11 Jan 2011 12:15:54 +0200
Subject: [PATCH] KVM: Initialize fpu state in preemptible context

init_fpu() (which is indirectly called by the fpu switching code) assumes
it is in process context.  Rather than makeing init_fpu() use an atomic
allocation, which can cause a task to be killed, make sure the fpu is
already initialized when we enter the run loop.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kernel/i387.c |    1 +
 arch/x86/kvm/x86.c     |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 58bb239..e60c38c 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -169,6 +169,7 @@ int init_fpu(struct task_struct *tsk)
 	set_stopped_child_used_math(tsk);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(init_fpu);
 
 /*
  * The xstateregs_active() routine is the same as the fpregs_active() routine,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8652643..fd93cda 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5351,6 +5351,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	int r;
 	sigset_t sigsaved;
 
+	if (!tsk_used_math(current) && init_fpu(current))
+		return -ENOMEM;
+
 	if (vcpu->sigset_active)
 		sigprocmask(SIG_SETMASK, &vcpu->sigset, &sigsaved);
 
-- 
1.7.1


--------------020201020807000707070104--
