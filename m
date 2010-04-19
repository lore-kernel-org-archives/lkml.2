Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab0DSXf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 19:35:26 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:33802 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753140Ab0DSXfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 19:35:25 -0400
Date: Mon, 19 Apr 2010 16:35:22 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Subject: Re: [PATCH] kvm: use the correct RCU API
Message-ID: <20100419233522.GO2564@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4BCC2543.7050104@cn.fujitsu.com>
 <4BCC2710.8090809@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BCC2710.8090809@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 19, 2010 at 12:49:04PM +0300, Avi Kivity wrote:
> On 04/19/2010 12:41 PM, Lai Jiangshan wrote:
> >The RCU/SRCU API have already changed for proving RCU usage.
> >
> >I got the following dmesg when PROVE_RCU=y because we used incorrect API.
> >This patch coverts rcu_deference() to srcu_dereference() or family API.
> >
> >===================================================
> >[ INFO: suspicious rcu_dereference_check() usage. ]
> >---------------------------------------------------
> >arch/x86/kvm/mmu.c:3020 invoked rcu_dereference_check() without protection!
> >
> >other info that might help us debug this:
> >
> >
> >rcu_scheduler_active = 1, debug_locks = 0
> >2 locks held by qemu-system-x86/8550:
> >  #0:  (&kvm->slots_lock){+.+.+.}, at: [<ffffffffa011a6ac>] kvm_set_memory_region+0x29/0x50 [kvm]
> >  #1:  (&(&kvm->mmu_lock)->rlock){+.+...}, at: [<ffffffffa012262d>] kvm_arch_commit_memory_region+0xa6/0xe2 [kvm]
> >
> >stack backtrace:
> >Pid: 8550, comm: qemu-system-x86 Not tainted 2.6.34-rc4-tip-01028-g939eab1 #27
> >Call Trace:
> >  [<ffffffff8106c59e>] lockdep_rcu_dereference+0xaa/0xb3
> >  [<ffffffffa012f6c1>] kvm_mmu_calculate_mmu_pages+0x44/0x7d [kvm]
> >  [<ffffffffa012263e>] kvm_arch_commit_memory_region+0xb7/0xe2 [kvm]
> >  [<ffffffffa011a5d7>] __kvm_set_memory_region+0x636/0x6e2 [kvm]
> >  [<ffffffffa011a6ba>] kvm_set_memory_region+0x37/0x50 [kvm]
> >  [<ffffffffa015e956>] vmx_set_tss_addr+0x46/0x5a [kvm_intel]
> >  [<ffffffffa0126592>] kvm_arch_vm_ioctl+0x17a/0xcf8 [kvm]
> >  [<ffffffff810a8692>] ? unlock_page+0x27/0x2c
> >  [<ffffffff810bf879>] ? __do_fault+0x3a9/0x3e1
> >  [<ffffffffa011b12f>] kvm_vm_ioctl+0x364/0x38d [kvm]
> >  [<ffffffff81060cfa>] ? up_read+0x23/0x3d
> >  [<ffffffff810f3587>] vfs_ioctl+0x32/0xa6
> >  [<ffffffff810f3b19>] do_vfs_ioctl+0x495/0x4db
> >  [<ffffffff810e6b2f>] ? fget_light+0xc2/0x241
> >  [<ffffffff810e416c>] ? do_sys_open+0x104/0x116
> >  [<ffffffff81382d6d>] ? retint_swapgs+0xe/0x13
> >  [<ffffffff810f3ba6>] sys_ioctl+0x47/0x6a
> >  [<ffffffff810021db>] system_call_fastpath+0x16/0x1b
> >
> >
> >
> >+static inline struct kvm_memslots *kvm_memslots(struct kvm *kvm)
> >+{
> >+	return rcu_dereference_check(kvm->memslots,
> >+			srcu_read_lock_held(&kvm->srcu)
> >+			|| lockdep_is_held(&kvm->slots_lock));
> >+}
> >+
> 
> 
> This open-codes srcu_dereference().  I guess we need an
> srcu_dereference_check().  Paul?

One is coming in Arnd's sparse-based patchset.  It is probably best
to open-code this in the meantime and clean up later, but I will
double-check with Arnd.

> btw, perhaps it is possible not to call rcu_dereference from the
> write paths.

There is an rcu_dereference_protected() on its way to mainline to handle
the case where the reference is always protected by a lock.  Why not
just access it directly?  Because if you do that, the sparse-based checks
will yell at you.

There is also an rcu_access_pointer() on its way to mainline for cases
where you only want to test the pointer itself, not dereference it.

						Thanx, Paul
