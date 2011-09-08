Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932614Ab1IHM0w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 08:26:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58528 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932592Ab1IHM0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 08:26:50 -0400
Date: Thu, 8 Sep 2011 08:26:30 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: dwmw2@infradead.org
Cc: Carolyn Wyborny <carolyn.wyborny@intel.com>, linux-kernel@vger.kernel.org,
        e1000-devel@lists.sourceforge.net
Subject: 3.1-rc3 iommu lockdep trace
Message-ID: <20110908122630.GL10700@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

We have a report[1] of a lockdep trace from the iommu layer when doing a
rmmod of the igb driver.  Any thoughts?

josh

[1] https://bugzilla.redhat.com/show_bug.cgi?id=736676

[  239.085163] =======================================================
[  239.093461] [ INFO: possible circular locking dependency detected ]
[  239.099997] 3.1.0-0.rc3.git0.0.fc16.x86_64 #1
[  239.104621] -------------------------------------------------------
[  239.111154] rmmod/5903 is trying to acquire lock:
[  239.116125]  (&(&iommu->lock)->rlock){......}, at: [<ffffffff813fcb18>]
domain_remove_one_dev_info+0x1c1/0x20b
[  239.126818]
[  239.126818] but task is already holding lock:
[  239.133204]  (device_domain_lock){-.-...}, at: [<ffffffff813fca89>]
domain_remove_one_dev_info+0x132/0x20b
[  239.143552]
[  239.143552] which lock already depends on the new lock.
[  239.143553]
[  239.152565]
[  239.152565] the existing dependency chain (in reverse order) is:
[  239.160595]
[  239.160596] -> #1 (device_domain_lock){-.-...}:
[  239.167355]        [<ffffffff8108eff1>] lock_acquire+0xf3/0x13e
[  239.173605]        [<ffffffff81503aa1>] _raw_spin_lock_irqsave+0x54/0x8e
[  239.180640]        [<ffffffff813fb9a1>]
domain_context_mapping_one+0x2b7/0x49a
[  239.188419]        [<ffffffff813fcedd>] domain_context_mapping+0x3d/0xe5
[  239.195445]        [<ffffffff815009aa>]
iommu_prepare_identity_map+0x18f/0x1ae
[  239.203226]        [<ffffffff81d9198b>] intel_iommu_init+0x7f0/0xa9d
[  239.209906]        [<ffffffff81d5a550>] pci_iommu_init+0x29/0x54
[  239.216243]        [<ffffffff81002099>] do_one_initcall+0x7f/0x13a
[  239.222750]        [<ffffffff81d53c8b>] kernel_init+0xdf/0x159
[  239.228914]        [<ffffffff8150d284>] kernel_thread_helper+0x4/0x10
[  239.235691]
[  239.235691] -> #0 (&(&iommu->lock)->rlock){......}:
[  239.242786]        [<ffffffff8108e81e>] __lock_acquire+0xa1a/0xcf7
[  239.249295]        [<ffffffff8108eff1>] lock_acquire+0xf3/0x13e
[  239.255544]        [<ffffffff81503aa1>] _raw_spin_lock_irqsave+0x54/0x8e
[  239.262580]        [<ffffffff813fcb18>]
domain_remove_one_dev_info+0x1c1/0x20b
[  239.270360]        [<ffffffff813fd1bf>] device_notifier+0x54/0x7e
[  239.276789]        [<ffffffff81507980>] notifier_call_chain+0x84/0xbb
[  239.283557]        [<ffffffff8107f880>]
__blocking_notifier_call_chain+0x67/0x84
[  239.291501]        [<ffffffff8107f8b1>]
blocking_notifier_call_chain+0x14/0x16
[  239.299271]        [<ffffffff81316816>] __device_release_driver+0xcd/0xd2
[  239.306394]        [<ffffffff81316ed3>] driver_detach+0x99/0xc2
[  239.312651]        [<ffffffff81316693>] bus_remove_driver+0xba/0xdf
[  239.319247]        [<ffffffff81317579>] driver_unregister+0x6a/0x75
[  239.325840]        [<ffffffff8126ce89>] pci_unregister_driver+0x44/0x8d
[  239.332781]        [<ffffffffa004c7a5>] igb_exit_module+0x1c/0x1e [igb]
[  239.339731]        [<ffffffff81098a58>] sys_delete_module+0x1dd/0x251
[  239.346499]        [<ffffffff8150b082>] system_call_fastpath+0x16/0x1b
[  239.353354]
[  239.353354] other info that might help us debug this:
[  239.353355]
[  239.362195]  Possible unsafe locking scenario:
[  239.362196]
[  239.368669]        CPU0                    CPU1
[  239.373467]        ----                    ----
[  239.378265]   lock(device_domain_lock);
[  239.382500]                                lock(&(&iommu->lock)->rlock);
[  239.389585]                                lock(device_domain_lock);
[  239.396338]   lock(&(&iommu->lock)->rlock);
[  239.400909]
[  239.400910]  *** DEADLOCK ***
[  239.400910]
[  239.407670] 4 locks held by rmmod/5903:
[  239.411776]  #0:  (&__lockdep_no_validate__){......}, at:
[<ffffffff81316eb4>] driver_detach+0x7a/0xc2
[  239.421826]  #1:  (&__lockdep_no_validate__){......}, at:
[<ffffffff81316ec2>] driver_detach+0x88/0xc2
[  239.431879]  #2:  (&(&priv->bus_notifier)->rwsem){.+.+.+}, at:
[<ffffffff8107f868>] __blocking_notifier_call_chain+0x4f/0x84
[  239.443850]  #3:  (device_domain_lock){-.-...}, at: [<ffffffff813fca89>]
domain_remove_one_dev_info+0x132/0x20b
[  239.454690]
[  239.454691] stack backtrace:
[  239.459600] Pid: 5903, comm: rmmod Tainted: G        W  
3.1.0-0.rc3.git0.0.fc16.x86_64 #1
[  239.468356] Call Trace:
[  239.471072]  [<ffffffff814f9b74>] print_circular_bug+0x1f8/0x209
[  239.477345]  [<ffffffff8108e81e>] __lock_acquire+0xa1a/0xcf7
[  239.483275]  [<ffffffff814fc4b5>] ? __slab_free+0x166/0x24c
[  239.489119]  [<ffffffff813fcb18>] ? domain_remove_one_dev_info+0x1c1/0x20b
[  239.496257]  [<ffffffff8108eff1>] lock_acquire+0xf3/0x13e
[  239.501920]  [<ffffffff813fcb18>] ? domain_remove_one_dev_info+0x1c1/0x20b
[  239.509059]  [<ffffffff81503aa1>] _raw_spin_lock_irqsave+0x54/0x8e
[  239.515506]  [<ffffffff813fcb18>] ? domain_remove_one_dev_info+0x1c1/0x20b
[  239.522645]  [<ffffffff8108b885>] ? trace_hardirqs_off+0xd/0xf
[  239.528749]  [<ffffffff813fcb18>] domain_remove_one_dev_info+0x1c1/0x20b
[  239.535716]  [<ffffffff813fd1bf>] device_notifier+0x54/0x7e
[  239.541558]  [<ffffffff81507980>] notifier_call_chain+0x84/0xbb
[  239.547747]  [<ffffffff8107f880>] __blocking_notifier_call_chain+0x67/0x84
[  239.554886]  [<ffffffff8107f8b1>] blocking_notifier_call_chain+0x14/0x16
[  239.561854]  [<ffffffff81316816>] __device_release_driver+0xcd/0xd2
[  239.568387]  [<ffffffff81316ed3>] driver_detach+0x99/0xc2
[  239.574056]  [<ffffffff81316693>] bus_remove_driver+0xba/0xdf
[  239.580073]  [<ffffffff81317579>] driver_unregister+0x6a/0x75
[  239.591871]  [<ffffffff8126ce89>] pci_unregister_driver+0x44/0x8d
[  239.598236]  [<ffffffffa004c7a5>] igb_exit_module+0x1c/0x1e [igb]
[  239.604594]  [<ffffffff81098a58>] sys_delete_module+0x1dd/0x251
[  239.610783]  [<ffffffff815046d9>] ? retint_swapgs+0x13/0x1b
[  239.616630]  [<ffffffff810b4e1b>] ? audit_syscall_entry+0x11c/0x148
[  239.623162]  [<ffffffff812536fe>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  239.629871]  [<ffffffff8110f63b>] ? pmd_offset+0x19/0x3f
[  239.635451]  [<ffffffff8150b082>] system_call_fastpath+0x16/0x1b
