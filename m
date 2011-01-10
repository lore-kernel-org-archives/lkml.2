Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab1AJTbW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 14:31:22 -0500
Received: from shutemov.name ([188.40.19.243]:57541 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292Ab1AJTbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 14:31:18 -0500
Date: Mon, 10 Jan 2011 21:31:17 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Christoph Lameter <cl@linux.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: BUG: sleeping function called from invalid context at
 mm/slub.c:793
Message-ID: <20110110193117.GA20027@shutemov.name>
References: <20110110105433.GA17881@shutemov.name>
 <alpine.DEB.2.00.1101101051260.12243@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1101101051260.12243@router.home>
User-Agent: Mutt/1.5.20 (2010-08-04)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 10:52:05AM -0600, Christoph Lameter wrote:
> 
> On Mon, 10 Jan 2011, Kirill A. Shutemov wrote:
> 
> > Every time I run qemu with KVM enabled I get this in dmesg:
> >
> > [  182.878328] BUG: sleeping function called from invalid context at mm/slub.c:793
> > [  182.878339] in_atomic(): 1, irqs_disabled(): 0, pid: 4992, name: qemu
> > [  182.878355] Pid: 4992, comm: qemu Not tainted 2.6.37+ #31
> > [  182.878361] Call Trace:
> > [  182.878381]  [<c104e317>] ? __might_sleep+0xd0/0xd7
> > [  182.878394]  [<c10ec337>] ? slab_pre_alloc_hook.clone.39+0x23/0x27
> > [  182.878404]  [<c10ece27>] ? kmem_cache_alloc+0x22/0xc8
> > [  182.878414]  [<c1030221>] ? init_fpu+0x44/0x7b
> 
> fpu_alloc() does call kmem_cache_alloc with GFP_KERNEL although we are in
> an atomic context.

Something like this?

---
>From 7c6fbfed72e7d22cbdf7393f9711d521e0fbb4a6 Mon Sep 17 00:00:00 2001
From: Kirill A. Shutemov <kirill@shutemov.name>
Date: Mon, 10 Jan 2011 21:24:23 +0200
Subject: [PATCH] x86, fpu_alloc(): call kmem_cache_alloc() with GFP_ATOMIC

[  182.878328] BUG: sleeping function called from invalid context at mm/slub.c:793
[  182.878339] in_atomic(): 1, irqs_disabled(): 0, pid: 4992, name: qemu
[  182.878355] Pid: 4992, comm: qemu Not tainted 2.6.37+ #31
[  182.878361] Call Trace:
[  182.878381]  [<c104e317>] ? __might_sleep+0xd0/0xd7
[  182.878394]  [<c10ec337>] ? slab_pre_alloc_hook.clone.39+0x23/0x27
[  182.878404]  [<c10ece27>] ? kmem_cache_alloc+0x22/0xc8
[  182.878414]  [<c1030221>] ? init_fpu+0x44/0x7b
[  182.878426]  [<c130cc29>] ? do_device_not_available+0x0/0x1b
[  182.878435]  [<c1030221>] ? init_fpu+0x44/0x7b
[  182.878444]  [<c102a588>] ? math_state_restore+0x24/0x47
[  182.878453]  [<c130cc39>] ? do_device_not_available+0x10/0x1b
[  182.878462]  [<c130c4ab>] ? error_code+0x67/0x6c
[  182.878475]  [<c1012340>] ? kvm_load_guest_fpu+0xa1/0xaa
[  182.878484]  [<c1013364>] ? kvm_arch_vcpu_ioctl_run+0x798/0xbe8
[  182.878496]  [<c1004523>] ? kvm_vcpu_ioctl+0x105/0x46e
[  182.878508]  [<c107dce0>] ? get_futex_key+0x73/0x132
[  182.878517]  [<c107e352>] ? futex_wake+0xb6/0xc0
[  182.878527]  [<c107f8d6>] ? do_futex+0x87/0x669
[  182.878535]  [<c100441e>] ? kvm_vcpu_ioctl+0x0/0x46e
[  182.878545]  [<c1101ebf>] ? do_vfs_ioctl+0x4a0/0x4d1
[  182.878554]  [<c130e348>] ? do_page_fault+0x2eb/0x316
[  182.878564]  [<c1101f36>] ? sys_ioctl+0x46/0x68
[  182.878572]  [<c130bdc0>] ? syscall_call+0x7/0xb
[  182.878585]  [<c1300000>] ? aer_probe+0x1da/0x274

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
---
 arch/x86/include/asm/i387.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index ef32890..8b896dd 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -426,7 +426,7 @@ static inline int fpu_alloc(struct fpu *fpu)
 {
 	if (fpu_allocated(fpu))
 		return 0;
-	fpu->state = kmem_cache_alloc(task_xstate_cachep, GFP_KERNEL);
+	fpu->state = kmem_cache_alloc(task_xstate_cachep, GFP_ATOMIC);
 	if (!fpu->state)
 		return -ENOMEM;
 	WARN_ON((unsigned long)fpu->state & 15);
-- 
1.7.3.4

