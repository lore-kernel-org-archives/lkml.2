Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab1HCTTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 15:19:33 -0400
Received: from na3sys010aog108.obsmtp.com ([74.125.245.84]:57017 "HELO
	na3sys010aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755422Ab1HCTTY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 15:19:24 -0400
MIME-Version: 1.0
In-Reply-To: <20110803191217.GA8720@redhat.com>
References: <20110803191217.GA8720@redhat.com>
From: Roland Dreier <roland@purestorage.com>
Date: Wed, 3 Aug 2011 12:19:03 -0700
Message-ID: <CAL1RGDVP+DnXdk9mMXbd6UrHdmq0kY9dv9EEi2M0fmszZoukSg@mail.gmail.com>
Subject: Re: iommu lockdep trace on 3.0.0
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        dwmw2@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like the same thing I hit.  I've sent a patch that fixes it for
me a couple of times:

https://lists.linux-foundation.org/pipermail/iommu/2011-July/002784.html

On Wed, Aug 3, 2011 at 12:12 PM, Dave Jones <davej@redhat.com> wrote:
> (it says 2.6.40, but it's 3.0.0 in all but name)
>
> Hit this while booting.
>
>        Dave
>
> [  706.848926] =======================================================
> [  706.857477] [ INFO: possible circular locking dependency detected ]
> [  706.863738] 2.6.40-4.fc15.x86_64.debug #1
> [  706.867746] -------------------------------------------------------
> [  706.874058] modprobe/1702 is trying to acquire lock:
> [  706.879047]  (&(&iommu->lock)->rlock){......}, at: [<ffffffff8128d308>] domain_remove_one_dev_info+0x1c1/0x20b
> [  706.889143]
> [  706.889144] but task is already holding lock:
> [  706.895029]  (device_domain_lock){..-...}, at: [<ffffffff8128d279>] domain_remove_one_dev_info+0x132/0x20b
> [  706.904795]
> [  706.904796] which lock already depends on the new lock.
> [  706.904798]
> [  706.913062]
> [  706.913063] the existing dependency chain (in reverse order) is:
> [  706.920608]
> [  706.920609] -> #1 (device_domain_lock){..-...}:
> [  706.926744]        [<ffffffff8108ab96>] lock_acquire+0xbf/0x103
> [  706.932684]        [<ffffffff814f6c77>] _raw_spin_lock_irqsave+0x45/0x7f
> [  706.939408]        [<ffffffff8128c16b>] domain_context_mapping_one+0x2b7/0x49a
> [  706.946695]        [<ffffffff8128d6c8>] domain_context_mapping+0x3d/0xe5
> [  706.953437]        [<ffffffff814f2097>] iommu_prepare_identity_map+0x18f/0x1ae
> [  706.960718]        [<ffffffff81d74d18>] intel_iommu_init+0x7f0/0xa9d
> [  706.967132]        [<ffffffff81d4c0d0>] pci_iommu_init+0x29/0x54
> [  706.973166]        [<ffffffff81002099>] do_one_initcall+0x7f/0x13a
> [  706.979372]        [<ffffffff81d44c98>] kernel_init+0xdf/0x159
> [  706.985266]        [<ffffffff814ff0a4>] kernel_thread_helper+0x4/0x10
> [  707.054277]
> [  707.054278] -> #0 (&(&iommu->lock)->rlock){......}:
> [  707.061381]        [<ffffffff8108a42c>] __lock_acquire+0xa1a/0xcf7
> [  707.067580]        [<ffffffff8108ab96>] lock_acquire+0xbf/0x103
> [  707.074883]        [<ffffffff814f6c77>] _raw_spin_lock_irqsave+0x45/0x7f
> [  707.081583]        [<ffffffff8128d308>] domain_remove_one_dev_info+0x1c1/0x20b
> [  707.090185]        [<ffffffff8128d9aa>] device_notifier+0x54/0x7e
> [  707.097489]        [<ffffffff814fa9a4>] notifier_call_chain+0x84/0xbb
> [  707.103938]        [<ffffffff8107b16c>] __blocking_notifier_call_chain+0x67/0x84
> [  707.111380]        [<ffffffff8107b19d>] blocking_notifier_call_chain+0x14/0x16
> [  707.119981]        [<ffffffff81326492>] __device_release_driver+0xcd/0xd2
> [  707.127814]        [<ffffffff81326b4f>] driver_detach+0x99/0xc2
> [  707.133769]        [<ffffffff8132630f>] bus_remove_driver+0xba/0xdf
> [  707.140200]        [<ffffffff813271f5>] driver_unregister+0x6a/0x75
> [  707.146468]        [<ffffffff81279592>] pci_unregister_driver+0x44/0x8d
> [  707.163869]        [<ffffffff81094039>] sys_delete_module+0x1dd/0x251
> [  707.170319]        [<ffffffff814fdf02>] system_call_fastpath+0x16/0x1b
> [  707.177535]
> [  707.177536] other info that might help us debug this:
> [  707.177537]
> [  707.185549]  Possible unsafe locking scenario:
> [  707.185550]
> [  707.191498]        CPU0                    CPU1
> [  707.196043]        ----                    ----
> [  707.200574]   lock(device_domain_lock);
> [  707.204505]                                lock(&(&iommu->lock)->rlock);
> [  707.211266]                                lock(device_domain_lock);
> [  707.217679]   lock(&(&iommu->lock)->rlock);
> [  707.221933]
> [  707.221934]  *** DEADLOCK ***
> [  707.221935]
> [  707.227943] 4 locks held by modprobe/1702:
> [  707.232066]  #0:  (&__lockdep_no_validate__){+.+.+.}, at: [<ffffffff81326b30>] driver_detach+0x7a/0xc2
> [  707.241488]  #1:  (&__lockdep_no_validate__){+.+.+.}, at: [<ffffffff81326b3e>] driver_detach+0x88/0xc2
> [  707.250961]  #2:  (&(&priv->bus_notifier)->rwsem){.+.+.+}, at: [<ffffffff8107b154>] __blocking_notifier_call_chain+0x4f/0x84
> [  707.262303]  #3:  (device_domain_lock){..-...}, at: [<ffffffff8128d279>] domain_remove_one_dev_info+0x132/0x20b
> [  707.272494]
> [  707.272495] stack backtrace:
> [  707.276915] Pid: 1702, comm: modprobe Not tainted 2.6.40-4.fc15.x86_64.debug #1
> [  707.284208] Call Trace:
> [  707.286697]  [<ffffffff814ed313>] print_circular_bug+0x1f8/0x209
> [  707.292692]  [<ffffffff8108a42c>] __lock_acquire+0xa1a/0xcf7
> [  707.298363]  [<ffffffff8128d308>] ? domain_remove_one_dev_info+0x1c1/0x20b
> [  707.305226]  [<ffffffff8108ab96>] lock_acquire+0xbf/0x103
> [  707.310619]  [<ffffffff8128d308>] ? domain_remove_one_dev_info+0x1c1/0x20b
> [  707.324019]  [<ffffffff814f6c77>] _raw_spin_lock_irqsave+0x45/0x7f
> [  707.330219]  [<ffffffff8128d308>] ? domain_remove_one_dev_info+0x1c1/0x20b
> [  707.337082]  [<ffffffff810874ea>] ? trace_hardirqs_off+0xd/0xf
> [  707.342933]  [<ffffffff8128d308>] domain_remove_one_dev_info+0x1c1/0x20b
> [  707.349624]  [<ffffffff8128d9aa>] device_notifier+0x54/0x7e
> [  707.355216]  [<ffffffff814fa9a4>] notifier_call_chain+0x84/0xbb
> [  707.361129]  [<ffffffff8107b16c>] __blocking_notifier_call_chain+0x67/0x84
> [  707.368021]  [<ffffffff8107b19d>] blocking_notifier_call_chain+0x14/0x16
> [  707.374710]  [<ffffffff81326492>] __device_release_driver+0xcd/0xd2
> [  707.380995]  [<ffffffff81326b4f>] driver_detach+0x99/0xc2
> [  707.386390]  [<ffffffff8132630f>] bus_remove_driver+0xba/0xdf
> [  707.392163]  [<ffffffff813271f5>] driver_unregister+0x6a/0x75
> [  707.397904]  [<ffffffff81279592>] pci_unregister_driver+0x44/0x8d
> [  707.410102]  [<ffffffff81094039>] sys_delete_module+0x1dd/0x251
> [  707.416014]  [<ffffffff814f7739>] ? retint_swapgs+0x13/0x1b
> [  707.421582]  [<ffffffff810aff1d>] ? audit_syscall_entry+0x11c/0x148
> [  707.427840]  [<ffffffff8126089e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [  707.434297]  [<ffffffff814fdf02>] system_call_fastpath+0x16/0x1b
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
