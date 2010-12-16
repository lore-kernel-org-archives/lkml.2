Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab0LPXkG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 18:40:06 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34027 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767Ab0LPXkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 18:40:00 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Scary warnings from xhci_hcd on rmmod and during shutdown/suspend/resume
Date: Fri, 17 Dec 2010 00:39:15 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc6+; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Andiry Xu <andiry.xu@amd.com>, Matthew Garrett <mjg@redhat.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_kMqCN2peYRoWrRt"
Message-Id: <201012170039.16185.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_kMqCN2peYRoWrRt
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi,

The xhcd_hci driver causes some scary warnings to be printed on rmmod:

[   33.189425] xhci_hcd 0000:04:00.0: remove, state 4
[   33.189528] usb usb8: USB disconnect, address 1
[   33.225678] xhci_hcd 0000:04:00.0: Host controller not halted, aborting reset.
[   33.225678] 
[   33.225678] ======================================================
[   33.225678] [ INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected ]
[   33.225678] 2.6.37-rc6+ #12
[   33.225678] ------------------------------------------------------
[   33.225678] rmmod/6075 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
[   33.225678]  (proc_subdir_lock){+.+...}, at: [<ffffffff81152aae>] remove_proc_entry+0x2e/0x2a0
[   33.225678] 
[   33.225678] and this task is already holding:
[   33.225678]  (&(&xhci->lock)->rlock){-.....}, at: [<ffffffffa0134c9d>] xhci_stop+0x1d/0x80 [xhci_hcd]
[   33.225678] which would create a new lock dependency:
[   33.225678]  (&(&xhci->lock)->rlock){-.....} -> (proc_subdir_lock){+.+...}
[   33.225678] 
[   33.225678] but this new dependency connects a HARDIRQ-irq-safe lock:
[   33.240111]  (&(&xhci->lock)->rlock){-.....}
[   33.240111] ... which became HARDIRQ-irq-safe at:
[   33.240111]   [<ffffffff8107a462>] __lock_acquire+0xc52/0x1ca0
[   33.240111]   [<ffffffff8107b9f7>] lock_acquire+0x57/0x70
[   33.240111]   [<ffffffff81494e06>] _raw_spin_lock+0x36/0x50
[   33.240111]   [<ffffffffa013e3f4>] xhci_irq+0x34/0x1c0 [xhci_hcd]
[   33.240111]   [<ffffffffa013e594>] xhci_msi_irq+0x14/0x20 [xhci_hcd]
[   33.240111]   [<ffffffff810a3e2a>] handle_IRQ_event+0x3a/0xe0
[   33.240111]   [<ffffffff810a66ee>] handle_edge_irq+0xce/0x180
[   33.240111]   [<ffffffff810057e4>] handle_irq+0x44/0xa0
[   33.240111]   [<ffffffff8100541d>] do_IRQ+0x6d/0xf0
[   33.240111]   [<ffffffff81495c53>] ret_from_intr+0x0/0xf
[   33.240111] 
[   33.240111] to a HARDIRQ-irq-unsafe lock:
[   33.240111]  (proc_subdir_lock){+.+...}
[   33.240111] ... which became HARDIRQ-irq-unsafe at:
[   33.240111] ...  [<ffffffff81079f75>] __lock_acquire+0x765/0x1ca0
[   33.240111]   [<ffffffff8107b9f7>] lock_acquire+0x57/0x70
[   33.240111]   [<ffffffff81494e06>] _raw_spin_lock+0x36/0x50
[   33.240111]   [<ffffffff81151f31>] __proc_create+0x61/0x150
[   33.240111]   [<ffffffff811528db>] proc_symlink+0x2b/0xb0
[   33.240111]   [<ffffffff81ac3254>] proc_root_init+0x69/0xc0
[   33.240111]   [<ffffffff81aa6c55>] start_kernel+0x3ca/0x3e9
[   33.240111]   [<ffffffff81aa6322>] x86_64_start_reservations+0x132/0x136
[   33.240111]   [<ffffffff81aa641c>] x86_64_start_kernel+0xf6/0xfd
[   33.240111] 
[   33.240111] other info that might help us debug this:
[   33.240111] 
[   33.240111] 3 locks held by rmmod/6075:
[   33.240111]  #0:  (&__lockdep_no_validate__){+.+.+.}, at: [<ffffffff8132e56c>] driver_detach+0x4c/0xd0
[   33.240111]  #1:  (&__lockdep_no_validate__){+.+.+.}, at: [<ffffffff8132e57a>] driver_detach+0x5a/0xd0
[   33.240111]  #2:  (&(&xhci->lock)->rlock){-.....}, at: [<ffffffffa0134c9d>] xhci_stop+0x1d/0x80 [xhci_hcd]
[   33.240111] 
[   33.240111] the dependencies between HARDIRQ-irq-safe lock and the holding lock:
[   33.240111] -> (&(&xhci->lock)->rlock){-.....} ops: 14 {
[   33.240111]    IN-HARDIRQ-W at:
[   33.240111]                                        [<ffffffff8107a462>] __lock_acquire+0xc52/0x1ca0
[   33.240111]                                        [<ffffffff8107b9f7>] lock_acquire+0x57/0x70
[   33.240111]                                        [<ffffffff81494e06>] _raw_spin_lock+0x36/0x50
[   33.240111]                                        [<ffffffffa013e3f4>] xhci_irq+0x34/0x1c0 [xhci_hcd]
[   33.240111]                                        [<ffffffffa013e594>] xhci_msi_irq+0x14/0x20 [xhci_hcd]
[   33.240111]                                        [<ffffffff810a3e2a>] handle_IRQ_event+0x3a/0xe0
[   33.240111]                                        [<ffffffff810a66ee>] handle_edge_irq+0xce/0x180
[   33.240111]                                        [<ffffffff810057e4>] handle_irq+0x44/0xa0
[   33.240111]                                        [<ffffffff8100541d>] do_IRQ+0x6d/0xf0
[   33.240111]                                        [<ffffffff81495c53>] ret_from_intr+0x0/0xf
[   33.240111]    INITIAL USE at:
[   33.240111]                                       [<ffffffff81079bd9>] __lock_acquire+0x3c9/0x1ca0
[   33.240111]                                       [<ffffffff8107b9f7>] lock_acquire+0x57/0x70
[   33.240111]                                       [<ffffffff81494e06>] _raw_spin_lock+0x36/0x50
[   33.240111]                                       [<ffffffffa013e3f4>] xhci_irq+0x34/0x1c0 [xhci_hcd]
[   33.240111]                                       [<ffffffffa013e594>] xhci_msi_irq+0x14/0x20 [xhci_hcd]
[   33.240111]                                       [<ffffffff810a3e2a>] handle_IRQ_event+0x3a/0xe0
[   33.240111]                                       [<ffffffff810a66ee>] handle_edge_irq+0xce/0x180
[   33.240111]                                       [<ffffffff810057e4>] handle_irq+0x44/0xa0
[   33.240111]                                       [<ffffffff8100541d>] do_IRQ+0x6d/0xf0
[   33.240111]                                       [<ffffffff81495c53>] ret_from_intr+0x0/0xf
[   33.240111]  }
[   33.240111]  ... key      at: [<ffffffffa0149314>] __key.26332+0x0/0xffffffffffff649c [xhci_hcd]
[   33.240111]  ... acquired at:
[   33.240111]    [<ffffffff81079100>] check_irq_usage+0x60/0xf0
[   33.240111]    [<ffffffff8107a840>] __lock_acquire+0x1030/0x1ca0
[   33.240111]    [<ffffffff8107b9f7>] lock_acquire+0x57/0x70
[   33.240111]    [<ffffffff81494e06>] _raw_spin_lock+0x36/0x50
[   33.240111]    [<ffffffff81152aae>] remove_proc_entry+0x2e/0x2a0
[   33.240111]    [<ffffffff810a779c>] unregister_handler_proc+0x2c/0x40
[   33.240111]    [<ffffffff810a4500>] __free_irq+0x100/0x250
[   33.240111]    [<ffffffff810a4692>] free_irq+0x42/0x80
[   33.240111]    [<ffffffffa01345be>] xhci_free_irq+0x7e/0x90 [xhci_hcd]
[   33.240111]    [<ffffffffa01345f0>] xhci_cleanup_msix+0x20/0x80 [xhci_hcd]
[   33.240111]    [<ffffffffa0134cb5>] xhci_stop+0x35/0x80 [xhci_hcd]
[   33.240111]    [<ffffffff813799f6>] usb_remove_hcd+0xe6/0x160
[   33.240111]    [<ffffffff81389f01>] usb_hcd_pci_remove+0x51/0xc0
[   33.240111]    [<ffffffff811e415d>] pci_device_remove+0x4d/0x110
[   33.240111]    [<ffffffff8132dd70>] __device_release_driver+0x70/0xe0
[   33.240111]    [<ffffffff8132e5e8>] driver_detach+0xc8/0xd0
[   33.240111]    [<ffffffff8132dbe6>] bus_remove_driver+0x96/0x100
[   33.240111]    [<ffffffff8132e679>] driver_unregister+0x59/0x90
[   33.240111]    [<ffffffff811e3dbf>] pci_unregister_driver+0x3f/0xa0
[   33.240111]    [<ffffffffa013a7d0>] xhci_unregister_pci+0x10/0x20 [xhci_hcd]
[   33.240111]    [<ffffffffa013f7ae>] xhci_hcd_cleanup+0x9/0xb [xhci_hcd]
[   33.240111]    [<ffffffff81085a07>] sys_delete_module+0x167/0x250
[   33.240111]    [<ffffffff8100273b>] system_call_fastpath+0x16/0x1b
[   33.240111] 
[   33.240111] 
[   33.240111] the dependencies between the lock to be acquired and HARDIRQ-irq-unsafe lock:
[   33.240111] -> (proc_subdir_lock){+.+...} ops: 6970 {
[   33.240111]    HARDIRQ-ON-W at:
[   33.240111]                                        [<ffffffff81079f75>] __lock_acquire+0x765/0x1ca0
[   33.240111]                                        [<ffffffff8107b9f7>] lock_acquire+0x57/0x70
[   33.240111]                                        [<ffffffff81494e06>] _raw_spin_lock+0x36/0x50
[   33.240111]                                        [<ffffffff81151f31>] __proc_create+0x61/0x150
[   33.240111]                                        [<ffffffff811528db>] proc_symlink+0x2b/0xb0
[   33.240111]                                        [<ffffffff81ac3254>] proc_root_init+0x69/0xc0
[   33.240111]                                        [<ffffffff81aa6c55>] start_kernel+0x3ca/0x3e9
[   33.240111]                                        [<ffffffff81aa6322>] x86_64_start_reservations+0x132/0x136
[   33.240111]                                        [<ffffffff81aa641c>] x86_64_start_kernel+0xf6/0xfd
[   33.240111]    SOFTIRQ-ON-W at:
[   33.240111]                                        [<ffffffff81079fb0>] __lock_acquire+0x7a0/0x1ca0
[   33.240111]                                        [<ffffffff8107b9f7>] lock_acquire+0x57/0x70
[   33.240111]                                        [<ffffffff81494e06>] _raw_spin_lock+0x36/0x50
[   33.240111]                                        [<ffffffff81151f31>] __proc_create+0x61/0x150
[   33.240111]                                        [<ffffffff811528db>] proc_symlink+0x2b/0xb0
[   33.240111]                                        [<ffffffff81ac3254>] proc_root_init+0x69/0xc0
[   33.240111]                                        [<ffffffff81aa6c55>] start_kernel+0x3ca/0x3e9
[   33.240111]                                        [<ffffffff81aa6322>] x86_64_start_reservations+0x132/0x136
[   33.240111]                                        [<ffffffff81aa641c>] x86_64_start_kernel+0xf6/0xfd
[   33.240111]    INITIAL USE at:
[   33.240111]                                       [<ffffffff81079bd9>] __lock_acquire+0x3c9/0x1ca0
[   33.240111]                                       [<ffffffff8107b9f7>] lock_acquire+0x57/0x70
[   33.240111]                                       [<ffffffff81494e06>] _raw_spin_lock+0x36/0x50
[   33.240111]                                       [<ffffffff81151f31>] __proc_create+0x61/0x150
[   33.240111]                                       [<ffffffff811528db>] proc_symlink+0x2b/0xb0
[   33.240111]                                       [<ffffffff81ac3254>] proc_root_init+0x69/0xc0
[   33.240111]                                       [<ffffffff81aa6c55>] start_kernel+0x3ca/0x3e9
[   33.240111]                                       [<ffffffff81aa6322>] x86_64_start_reservations+0x132/0x136
[   33.240111]                                       [<ffffffff81aa641c>] x86_64_start_kernel+0xf6/0xfd
[   33.240111]  }
[   33.240111]  ... key      at: [<ffffffff81a443f8>] proc_subdir_lock+0x18/0x40
[   33.240111]  ... acquired at:
[   33.240111]    [<ffffffff81079100>] check_irq_usage+0x60/0xf0
[   33.240111]    [<ffffffff8107a840>] __lock_acquire+0x1030/0x1ca0
[   33.240111]    [<ffffffff8107b9f7>] lock_acquire+0x57/0x70
[   33.240111]    [<ffffffff81494e06>] _raw_spin_lock+0x36/0x50
[   33.240111]    [<ffffffff81152aae>] remove_proc_entry+0x2e/0x2a0
[   33.240111]    [<ffffffff810a779c>] unregister_handler_proc+0x2c/0x40
[   33.240111]    [<ffffffff810a4500>] __free_irq+0x100/0x250
[   33.240111]    [<ffffffff810a4692>] free_irq+0x42/0x80
[   33.240111]    [<ffffffffa01345be>] xhci_free_irq+0x7e/0x90 [xhci_hcd]
[   33.240111]    [<ffffffffa01345f0>] xhci_cleanup_msix+0x20/0x80 [xhci_hcd]
[   33.240111]    [<ffffffffa0134cb5>] xhci_stop+0x35/0x80 [xhci_hcd]
[   33.240111]    [<ffffffff813799f6>] usb_remove_hcd+0xe6/0x160
[   33.240111]    [<ffffffff81389f01>] usb_hcd_pci_remove+0x51/0xc0
[   33.240111]    [<ffffffff811e415d>] pci_device_remove+0x4d/0x110
[   33.240111]    [<ffffffff8132dd70>] __device_release_driver+0x70/0xe0
[   33.240111]    [<ffffffff8132e5e8>] driver_detach+0xc8/0xd0
[   33.240111]    [<ffffffff8132dbe6>] bus_remove_driver+0x96/0x100
[   33.240111]    [<ffffffff8132e679>] driver_unregister+0x59/0x90
[   33.240111]    [<ffffffff811e3dbf>] pci_unregister_driver+0x3f/0xa0
[   33.240111]    [<ffffffffa013a7d0>] xhci_unregister_pci+0x10/0x20 [xhci_hcd]
[   33.240111]    [<ffffffffa013f7ae>] xhci_hcd_cleanup+0x9/0xb [xhci_hcd]
[   33.240111]    [<ffffffff81085a07>] sys_delete_module+0x167/0x250
[   33.240111]    [<ffffffff8100273b>] system_call_fastpath+0x16/0x1b
[   33.240111] 
[   33.240111] 
[   33.240111] stack backtrace:
[   33.240111] Pid: 6075, comm: rmmod Not tainted 2.6.37-rc6+ #12
[   33.240111] Call Trace:
[   33.240111]  [<ffffffff81079097>] check_usage+0x497/0x4a0
[   33.240111]  [<ffffffff81079100>] check_irq_usage+0x60/0xf0
[   33.240111]  [<ffffffff8107a840>] __lock_acquire+0x1030/0x1ca0
[   33.240111]  [<ffffffff8107b9f7>] lock_acquire+0x57/0x70
[   33.240111]  [<ffffffff81152aae>] ? remove_proc_entry+0x2e/0x2a0
[   33.240111]  [<ffffffff81494e06>] _raw_spin_lock+0x36/0x50
[   33.240111]  [<ffffffff81152aae>] ? remove_proc_entry+0x2e/0x2a0
[   33.240111]  [<ffffffff81152aae>] remove_proc_entry+0x2e/0x2a0
[   33.240111]  [<ffffffff8104a939>] ? vprintk+0x2f9/0x4b0
[   33.240111]  [<ffffffff810a779c>] unregister_handler_proc+0x2c/0x40
[   33.240111]  [<ffffffff810a4500>] __free_irq+0x100/0x250
[   33.240111]  [<ffffffff810a4692>] free_irq+0x42/0x80
[   33.240111]  [<ffffffffa01345be>] xhci_free_irq+0x7e/0x90 [xhci_hcd]
[   33.240111]  [<ffffffffa01345f0>] xhci_cleanup_msix+0x20/0x80 [xhci_hcd]
[   33.240111]  [<ffffffffa0134cb5>] xhci_stop+0x35/0x80 [xhci_hcd]
[   33.240111]  [<ffffffff813799f6>] usb_remove_hcd+0xe6/0x160
[   33.240111]  [<ffffffff81389f01>] usb_hcd_pci_remove+0x51/0xc0
[   33.240111]  [<ffffffff811e415d>] pci_device_remove+0x4d/0x110
[   33.240111]  [<ffffffff8132dd70>] __device_release_driver+0x70/0xe0
[   33.240111]  [<ffffffff8132e5e8>] driver_detach+0xc8/0xd0
[   33.240111]  [<ffffffff8132dbe6>] bus_remove_driver+0x96/0x100
[   33.240111]  [<ffffffff8132e679>] driver_unregister+0x59/0x90
[   33.240111]  [<ffffffff811e3dbf>] pci_unregister_driver+0x3f/0xa0
[   33.240111]  [<ffffffffa013a7d0>] xhci_unregister_pci+0x10/0x20 [xhci_hcd]
[   33.240111]  [<ffffffffa013f7ae>] xhci_hcd_cleanup+0x9/0xb [xhci_hcd]
[   33.240111]  [<ffffffff81085a07>] sys_delete_module+0x167/0x250
[   33.240111]  [<ffffffff8100276c>] ? sysret_check+0x27/0x62
[   33.240111]  [<ffffffff8107c3bd>] ? trace_hardirqs_on_caller+0x12d/0x170
[   33.240111]  [<ffffffff8100273b>] system_call_fastpath+0x16/0x1b
[   33.240111] BUG: sleeping function called from invalid context at /home/rafael/src/linux-2.6/kernel/mutex.c:278
[   33.240111] in_atomic(): 1, irqs_disabled(): 1, pid: 6075, name: rmmod
[   33.240111] INFO: lockdep is turned off.
[   33.240111] irq event stamp: 4560
[   33.240111] hardirqs last  enabled at (4559): [<ffffffff8149571d>] _raw_spin_unlock_irqrestore+0x5d/0x70
[   33.240111] hardirqs last disabled at (4560): [<ffffffff81494e92>] _raw_spin_lock_irq+0x12/0x50
[   33.240111] softirqs last  enabled at (4494): [<ffffffff81400845>] sk_filter+0xd5/0x100
[   33.240111] softirqs last disabled at (4492): [<ffffffff814007ad>] sk_filter+0x3d/0x100
[   33.240111] Pid: 6075, comm: rmmod Not tainted 2.6.37-rc6+ #12
[   33.240111] Call Trace:
[   33.240111]  [<ffffffff81079290>] ? print_irqtrace_events+0xd0/0xe0
[   33.240111]  [<ffffffff81036783>] __might_sleep+0x103/0x130
[   33.240111]  [<ffffffff81492f73>] mutex_lock_nested+0x33/0x380
[   33.240111]  [<ffffffff814956fd>] ? _raw_spin_unlock_irqrestore+0x3d/0x70
[   33.240111]  [<ffffffff810a39de>] ? dynamic_irq_cleanup+0xde/0x100
[   33.240111]  [<ffffffff810a3a58>] irq_free_descs+0x58/0x90
[   33.240111]  [<ffffffff81022008>] destroy_irq+0x78/0x90
[   33.240111]  [<ffffffff810222c9>] native_teardown_msi_irq+0x9/0x10
[   33.240111]  [<ffffffff811ee0b0>] default_teardown_msi_irqs+0x70/0xa0
[   33.240111]  [<ffffffff811edb41>] free_msi_irqs+0xa1/0x110
[   33.240111]  [<ffffffff811eec1d>] pci_disable_msix+0x3d/0x50
[   33.240111]  [<ffffffffa0134609>] xhci_cleanup_msix+0x39/0x80 [xhci_hcd]
[   33.240111]  [<ffffffffa0134cb5>] xhci_stop+0x35/0x80 [xhci_hcd]
[   33.240111]  [<ffffffff813799f6>] usb_remove_hcd+0xe6/0x160
[   33.240111]  [<ffffffff81389f01>] usb_hcd_pci_remove+0x51/0xc0
[   33.240111]  [<ffffffff811e415d>] pci_device_remove+0x4d/0x110
[   33.240111]  [<ffffffff8132dd70>] __device_release_driver+0x70/0xe0
[   33.240111]  [<ffffffff8132e5e8>] driver_detach+0xc8/0xd0
[   33.240111]  [<ffffffff8132dbe6>] bus_remove_driver+0x96/0x100
[   33.240111]  [<ffffffff8132e679>] driver_unregister+0x59/0x90
[   33.240111]  [<ffffffff811e3dbf>] pci_unregister_driver+0x3f/0xa0
[   33.240111]  [<ffffffffa013a7d0>] xhci_unregister_pci+0x10/0x20 [xhci_hcd]
[   33.240111]  [<ffffffffa013f7ae>] xhci_hcd_cleanup+0x9/0xb [xhci_hcd]
[   33.240111]  [<ffffffff81085a07>] sys_delete_module+0x167/0x250
[   33.240111]  [<ffffffff8100276c>] ? sysret_check+0x27/0x62
[   33.240111]  [<ffffffff8107c3bd>] ? trace_hardirqs_on_caller+0x12d/0x170
[   33.240111]  [<ffffffff8100273b>] system_call_fastpath+0x16/0x1b
[   33.240111] ------------[ cut here ]------------
[   33.240111] WARNING: at /home/rafael/src/linux-2.6/kernel/smp.c:432 smp_call_function_many+0xac/0x1f0()
[   33.240111] Hardware name: MS-7640
[   33.240111] Modules linked in: nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device edd ipv6 cpufreq_conservative cpufreq_ondemand cpufreq_userspace cpufreq_powersave powernow_k8 freq_table mperf ext3 jbd dm_mod snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer snd sr_mod soundcore firewire_ohci evdev cdrom firewire_core serio_raw joydev snd_page_alloc button sg r8169 mii xhci_hcd(-) crc_itu_t ext4 jbd2 crc16 raid456 async_pq async_xor xor async_memcpy async_raid6_recov raid6_pq async_tx raid10 raid0 ohci_hcd ehci_hcd sd_mod crc_t10dif rtc_cmos rtc_core rtc_lib fan processor pata_jmicron thermal
[   33.240111] Pid: 6075, comm: rmmod Not tainted 2.6.37-rc6+ #12
[   33.240111] Call Trace:
[   33.240111]  [<ffffffff81049e5a>] warn_slowpath_common+0x7a/0xb0
[   33.240111]  [<ffffffff81030f60>] ? do_flush_tlb_all+0x0/0x50
[   33.240111]  [<ffffffff81049ea5>] warn_slowpath_null+0x15/0x20
[   33.240111]  [<ffffffff81082c5c>] smp_call_function_many+0xac/0x1f0
[   33.240111]  [<ffffffff81030f60>] ? do_flush_tlb_all+0x0/0x50
[   33.240111]  [<ffffffff81082de1>] smp_call_function+0x41/0x80
[   33.240111]  [<ffffffff81030f60>] ? do_flush_tlb_all+0x0/0x50
[   33.240111]  [<ffffffff8104fba5>] on_each_cpu+0x35/0x80
[   33.240111]  [<ffffffff810312c7>] flush_tlb_all+0x17/0x20
[   33.240111]  [<ffffffff810e0990>] remove_vm_area+0x90/0xc0
[   33.240111]  [<ffffffff8102c1a1>] iounmap+0x91/0xe0
[   33.240111]  [<ffffffff811edba9>] free_msi_irqs+0x109/0x110
[   33.240111]  [<ffffffff811eec1d>] pci_disable_msix+0x3d/0x50
[   33.240111]  [<ffffffffa0134609>] xhci_cleanup_msix+0x39/0x80 [xhci_hcd]
[   33.240111]  [<ffffffffa0134cb5>] xhci_stop+0x35/0x80 [xhci_hcd]
[   33.240111]  [<ffffffff813799f6>] usb_remove_hcd+0xe6/0x160
[   33.240111]  [<ffffffff81389f01>] usb_hcd_pci_remove+0x51/0xc0
[   33.240111]  [<ffffffff811e415d>] pci_device_remove+0x4d/0x110
[   33.240111]  [<ffffffff8132dd70>] __device_release_driver+0x70/0xe0
[   33.240111]  [<ffffffff8132e5e8>] driver_detach+0xc8/0xd0
[   33.240111]  [<ffffffff8132dbe6>] bus_remove_driver+0x96/0x100
[   33.240111]  [<ffffffff8132e679>] driver_unregister+0x59/0x90
[   33.240111]  [<ffffffff811e3dbf>] pci_unregister_driver+0x3f/0xa0
[   33.240111]  [<ffffffffa013a7d0>] xhci_unregister_pci+0x10/0x20 [xhci_hcd]
[   33.240111]  [<ffffffffa013f7ae>] xhci_hcd_cleanup+0x9/0xb [xhci_hcd]
[   33.240111]  [<ffffffff81085a07>] sys_delete_module+0x167/0x250
[   33.240111]  [<ffffffff8100276c>] ? sysret_check+0x27/0x62
[   33.240111]  [<ffffffff8107c3bd>] ? trace_hardirqs_on_caller+0x12d/0x170
[   33.240111]  [<ffffffff8100273b>] system_call_fastpath+0x16/0x1b
[   33.240111] ---[ end trace 78a8387880057ad9 ]---
[   33.269230] xhci_hcd 0000:04:00.0: USB bus 8 deregistered
[   33.486574] xhci_hcd 0000:04:00.0: PCI INT A disabled
[   69.159848] xhci_hcd 0000:04:00.0: PCI INT A -> GSI 48 (level, low) -> IRQ 48
[   69.161130] xhci_hcd 0000:04:00.0: enabling bus mastering
[   69.162281] xhci_hcd 0000:04:00.0: setting latency timer to 64
[   69.163433] xhci_hcd 0000:04:00.0: xHCI Host Controller
[   69.164848] xhci_hcd 0000:04:00.0: new USB bus registered, assigned bus number 8
[   69.193629] xhci_hcd 0000:04:00.0: enabling Mem-Wr-Inval
[   69.194848] xhci_hcd 0000:04:00.0: irq 48, io mem 0xfe5fe000
[   69.196022] xhci_hcd 0000:04:00.0: irq 81 for MSI/MSI-X
[   69.197175] xhci_hcd 0000:04:00.0: irq 82 for MSI/MSI-X
[   69.198292] xhci_hcd 0000:04:00.0: irq 83 for MSI/MSI-X
[   69.199403] xhci_hcd 0000:04:00.0: irq 84 for MSI/MSI-X
[   69.200527] xhci_hcd 0000:04:00.0: irq 85 for MSI/MSI-X
[   69.201620] xhci_hcd 0000:04:00.0: irq 86 for MSI/MSI-X
[   69.202703] xhci_hcd 0000:04:00.0: irq 87 for MSI/MSI-X
[   69.203883] usb usb8: No SuperSpeed endpoint companion for config 1  interface 0 altsetting 0 ep 129: using minimum values
[   69.205038] usb usb8: New USB device found, idVendor=1d6b, idProduct=0003
[   69.206166] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   69.207320] usb usb8: Product: xHCI Host Controller
[   69.208453] usb usb8: Manufacturer: Linux 2.6.37-rc6+ xhci_hcd
[   69.208458] usb usb8: SerialNumber: 0000:04:00.0
[   69.208789] xHCI xhci_add_endpoint called for root hub
[   69.208791] xHCI xhci_check_bandwidth called for root hub
[   69.208919] hub 8-0:1.0: USB hub found
[   69.208929] hub 8-0:1.0: 4 ports detected

and during shutdown (I believe the warnings are the same or analogous to the
above).

I tested with the attached patch from Andiry applied and I got the following
BUG during resume:

[   91.703778] sd 0:0:0:0: [sda] Starting disk
[   91.704054] sd 2:0:0:0: [sdb] Starting disk
[   91.703680] xhci_hcd 0000:04:00.0: Host controller not halted, aborting reset.
[   91.703680] BUG: sleeping function called from invalid context at /home/rafael/src/linux-2.6/kernel/mutex.c:278
[   91.703680] in_atomic(): 1, irqs_disabled(): 1, pid: 1234, name: kworker/u:6
[   91.703680] INFO: lockdep is turned off.
[   91.703680] irq event stamp: 24060
[   91.703680] hardirqs last  enabled at (24059): [<ffffffff810aa071>] rcu_note_context_switch+0xa1/0x1c0
[   91.703680] hardirqs last disabled at (24060): [<ffffffff81494e92>] _raw_spin_lock_irq+0x12/0x50
[   91.703680] softirqs last  enabled at (20026): [<ffffffff8105056e>] __do_softirq+0x11e/0x160
[   91.703680] softirqs last disabled at (20011): [<ffffffff8100368c>] call_softirq+0x1c/0x30
[   91.703680] Pid: 1234, comm: kworker/u:6 Tainted: G        W   2.6.37-rc6+ #12
[   91.703680] Call Trace:
[   91.703680]  [<ffffffff81079290>] ? print_irqtrace_events+0xd0/0xe0
[   91.703680]  [<ffffffff81036783>] __might_sleep+0x103/0x130
[   91.703680]  [<ffffffff81492f73>] mutex_lock_nested+0x33/0x380
[   91.703680]  [<ffffffff81495727>] ? _raw_spin_unlock_irqrestore+0x67/0x70
[   91.703680]  [<ffffffff810a39de>] ? dynamic_irq_cleanup+0xde/0x100
[   91.703680]  [<ffffffff810a3a58>] irq_free_descs+0x58/0x90
[   91.703680]  [<ffffffff81022008>] destroy_irq+0x78/0x90
[   91.703680]  [<ffffffff810222c9>] native_teardown_msi_irq+0x9/0x10
[   91.703680]  [<ffffffff811ee0b0>] default_teardown_msi_irqs+0x70/0xa0
[   91.703680]  [<ffffffff811edb41>] free_msi_irqs+0xa1/0x110
[   91.703680]  [<ffffffff811eec1d>] pci_disable_msix+0x3d/0x50
[   91.703680]  [<ffffffffa03f0609>] xhci_cleanup_msix+0x39/0x80 [xhci_hcd]
[   91.703680]  [<ffffffffa03f111c>] xhci_resume+0x1ac/0x250 [xhci_hcd]
[   91.703680]  [<ffffffffa03f65c4>] xhci_pci_resume+0x14/0x20 [xhci_hcd]
[   91.703680]  [<ffffffff8138996b>] resume_common+0xbb/0x140
[   91.703680]  [<ffffffff81389a5e>] hcd_pci_restore+0xe/0x10
[   91.703680]  [<ffffffff811e36f3>] pci_pm_restore+0x63/0xb0
[   91.703680]  [<ffffffff813334bd>] pm_op+0x19d/0x1c0
[   91.703680]  [<ffffffff81333be4>] device_resume+0x94/0x220
[   91.703680]  [<ffffffff81333d8c>] async_resume+0x1c/0x50
[   91.703680]  [<ffffffff8106e6e6>] async_run_entry_fn+0x86/0x160
[   91.703680]  [<ffffffff81060672>] process_one_work+0x1a2/0x450
[   91.703680]  [<ffffffff81060614>] ? process_one_work+0x144/0x450
[   91.703680]  [<ffffffff811d2704>] ? do_raw_spin_lock+0x104/0x170
[   91.703680]  [<ffffffff8106e660>] ? async_run_entry_fn+0x0/0x160
[   91.703680]  [<ffffffff81061e32>] worker_thread+0x162/0x340
[   91.703680]  [<ffffffff81061cd0>] ? worker_thread+0x0/0x340
[   91.703680]  [<ffffffff81066836>] kthread+0x96/0xa0
[   91.703680]  [<ffffffff81003594>] kernel_thread_helper+0x4/0x10
[   91.703680]  [<ffffffff81036fdb>] ? finish_task_switch+0x7b/0xe0
[   91.703680]  [<ffffffff81495d00>] ? restore_args+0x0/0x30
[   91.703680]  [<ffffffff810667a0>] ? kthread+0x0/0xa0
[   91.703680]  [<ffffffff81003590>] ? kernel_thread_helper+0x0/0x10
[   91.706248] xhci_hcd 0000:04:00.0: irq 81 for MSI/MSI-X
[   91.706251] xhci_hcd 0000:04:00.0: irq 82 for MSI/MSI-X
[   91.706253] xhci_hcd 0000:04:00.0: irq 83 for MSI/MSI-X
[   91.706256] xhci_hcd 0000:04:00.0: irq 84 for MSI/MSI-X
[   91.706258] xhci_hcd 0000:04:00.0: irq 85 for MSI/MSI-X
[   91.706260] xhci_hcd 0000:04:00.0: irq 86 for MSI/MSI-X
[   91.706262] xhci_hcd 0000:04:00.0: irq 87 for MSI/MSI-X

The issues appear to be 100% reproducible.

Thanks,
Rafael

--Boundary-00=_kMqCN2peYRoWrRt
Content-Type: text/x-patch;
  charset="UTF-8";
  name="xHCI-synchronize-interrupts-in-xhci_suspend.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="xHCI-synchronize-interrupts-in-xhci_suspend.patch"

Matthew,

Can you help to test if this patch fix your xhci suspend and remove issue? Thanks.

From: Andiry Xu <andiry.xu@amd.com>
Date: Mon, 6 Dec 2010 16:58:16 +0800
Subject: [PATCH] xHCI: synchronize interrupts in xhci_suspend()

Matthew Garrett reports a interrupt double free in xHCI code when the
host is suspended and then the card removed.

Synchronize the interrupts instead of free them in xhci_suspned().

Reported-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andiry Xu <andiry.xu@amd.com>
---
 drivers/usb/host/xhci.c |   37 +++++++++----------------------------
 1 file changed, 9 insertions(+), 28 deletions(-)

Index: linux-2.6/drivers/usb/host/xhci.c
===================================================================
--- linux-2.6.orig/drivers/usb/host/xhci.c
+++ linux-2.6/drivers/usb/host/xhci.c
@@ -646,7 +646,9 @@ int xhci_suspend(struct xhci_hcd *xhci)
 {
 	int			rc = 0;
 	struct usb_hcd		*hcd = xhci_to_hcd(xhci);
+	struct pci_dev		*pdev = to_pci_dev(hcd->self.controller);
 	u32			command;
+	int			i;
 
 	spin_lock_irq(&xhci->lock);
 	clear_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
@@ -678,9 +680,14 @@ int xhci_suspend(struct xhci_hcd *xhci)
 		return -ETIMEDOUT;
 	}
 	/* step 5: remove core well power */
-	xhci_cleanup_msix(xhci);
 	spin_unlock_irq(&xhci->lock);
 
+	if (xhci->msix_entries) {
+		for (i = 0; i < xhci->msix_count; i++)
+			synchronize_irq(xhci->msix_entries[i].vector);
+	} else if (pdev->irq >= 0)
+		synchronize_irq(pdev->irq);
+
 	return rc;
 }
 
@@ -694,7 +701,6 @@ int xhci_resume(struct xhci_hcd *xhci, b
 {
 	u32			command, temp = 0;
 	struct usb_hcd		*hcd = xhci_to_hcd(xhci);
-	struct pci_dev		*pdev = to_pci_dev(hcd->self.controller);
 	int	old_state, retval;
 
 	old_state = hcd->state;
@@ -729,8 +735,7 @@ int xhci_resume(struct xhci_hcd *xhci, b
 		xhci_dbg(xhci, "Stop HCD\n");
 		xhci_halt(xhci);
 		xhci_reset(xhci);
-		if (hibernated)
-			xhci_cleanup_msix(xhci);
+		xhci_cleanup_msix(xhci);
 		spin_unlock_irq(&xhci->lock);
 
 #ifdef CONFIG_USB_XHCI_HCD_DEBUGGING
@@ -765,30 +770,6 @@ int xhci_resume(struct xhci_hcd *xhci, b
 		return retval;
 	}
 
-	spin_unlock_irq(&xhci->lock);
-	/* Re-setup MSI-X */
-	if (hcd->irq)
-		free_irq(hcd->irq, hcd);
-	hcd->irq = -1;
-
-	retval = xhci_setup_msix(xhci);
-	if (retval)
-		/* fall back to msi*/
-		retval = xhci_setup_msi(xhci);
-
-	if (retval) {
-		/* fall back to legacy interrupt*/
-		retval = request_irq(pdev->irq, &usb_hcd_irq, IRQF_SHARED,
-					hcd->irq_descr, hcd);
-		if (retval) {
-			xhci_err(xhci, "request interrupt %d failed\n",
-					pdev->irq);
-			return retval;
-		}
-		hcd->irq = pdev->irq;
-	}
-
-	spin_lock_irq(&xhci->lock);
 	/* step 4: set Run/Stop bit */
 	command = xhci_readl(xhci, &xhci->op_regs->command);
 	command |= CMD_RUN;

--Boundary-00=_kMqCN2peYRoWrRt--
