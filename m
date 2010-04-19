Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab0DSJ7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 05:59:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62775 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753096Ab0DSJ7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 05:59:14 -0400
Message-ID: <4BCC295D.1040807@cn.fujitsu.com>
Date: Mon, 19 Apr 2010 17:58:53 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Subject: [BUG] kvm: dereference srcu-protected pointer without srcu_read_lock()
 held
References: <4BCC2543.7050104@cn.fujitsu.com>
In-Reply-To: <4BCC2543.7050104@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied the patch I just sent and let CONFIG_PROVE_RCU=y,
we can got the following dmesg. And we found that it is
because some codes in KVM dereferences srcu-protected pointer without
srcu_read_lock() held or update-side lock held.

It is not hard to fix, the problem is that:
Where is the most proper place to put a srcu_read_lock()?

I can not determine the answer, so I report this bug
instead of fixing it.

Thanks.
Lai.

Reported-by: Lai Jiangshan <laijs@cn.fujitsu.com>


===================================================
[ INFO: suspicious rcu_dereference_check() usage. ]
---------------------------------------------------
arch/x86/kvm/x86.h:72 invoked rcu_dereference_check() without protection!

other info that might help us debug this:


rcu_scheduler_active = 1, debug_locks = 0
1 lock held by qemu-system-x86/3027:
 #0:  (&vcpu->mutex){+.+.+.}, at: [<ffffffffa011b6ff>] vcpu_load+0x1a/0x66 [kvm]

stack backtrace:
Pid: 3027, comm: qemu-system-x86 Not tainted 2.6.34-rc4-tip-01028-g939eab1-dirty #28
Call Trace:
 [<ffffffff8106c59e>] lockdep_rcu_dereference+0xaa/0xb3
 [<ffffffffa0123654>] unalias_gfn_instantiation+0x56/0xaf [kvm]
 [<ffffffffa01198de>] gfn_to_hva+0x14/0x4c [kvm]
 [<ffffffffa01199ca>] kvm_write_guest_page+0x2a/0x7f [kvm]
 [<ffffffffa0119afb>] kvm_write_guest+0x41/0x83 [kvm]
 [<ffffffffa01243b5>] kvm_write_guest_virt+0x78/0xa1 [kvm]
 [<ffffffffa012479a>] pio_copy_data+0x46/0x75 [kvm]
 [<ffffffff81385a0f>] ? sub_preempt_count+0x9/0x83
 [<ffffffffa012485a>] complete_pio+0x91/0x1b9 [kvm]
 [<ffffffffa0128728>] kvm_arch_vcpu_ioctl_run+0x93/0xd2b [kvm]
 [<ffffffffa0128f7a>] ? kvm_arch_vcpu_ioctl_run+0x8e5/0xd2b [kvm]
 [<ffffffff8106e590>] ? __lock_acquire+0x7b4/0x16d5
 [<ffffffffa0117ecd>] kvm_vcpu_ioctl+0x103/0x97b [kvm]
 [<ffffffffa011b15b>] ? kvm_vm_ioctl+0x364/0x38d [kvm]
 [<ffffffff810e6b5e>] ? fget_light+0xf1/0x241
 [<ffffffff810f3587>] vfs_ioctl+0x32/0xa6
 [<ffffffff810f3b19>] do_vfs_ioctl+0x495/0x4db
 [<ffffffff810e6c9e>] ? fget_light+0x231/0x241
 [<ffffffff810e6b5e>] ? fget_light+0xf1/0x241
 [<ffffffff810f3ba6>] sys_ioctl+0x47/0x6a
 [<ffffffff810021db>] system_call_fastpath+0x16/0x1b
