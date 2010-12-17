Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004Ab0LQI0b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 03:26:31 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:16345 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab0LQI03 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 03:26:29 -0500
X-SpamScore: -14
X-BigFish: VPS-14(z6c9Mz1432N4015Lzz1202hzzz32i668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LDKCRO-02-L2K-02
X-M-MSG: 
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Scary warnings from xhci_hcd on rmmod and during shutdown/suspend/resume
Date: Fri, 17 Dec 2010 16:26:09 +0800
Message-ID: <2DEEA3AB13739D45A22ADDB5086AEA0BC080D3@sshaexmb1.amd.com>
In-Reply-To: <201012170039.16185.rjw@sisk.pl>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Scary warnings from xhci_hcd on rmmod and during shutdown/suspend/resume
Thread-Index: AcudeqQOQ7pIDIkUSS+CrA7cCg1jQAASPe1g
References: <201012170039.16185.rjw@sisk.pl>
From: "Xu, Andiry" <Andiry.Xu@amd.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        Matthew Garrett <mjg@redhat.com>
X-OriginalArrivalTime: 17 Dec 2010 08:26:13.0675 (UTC) FILETIME=[11217FB0:01CB9DC4]
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> and during shutdown (I believe the warnings are the same or analogous
to
> the
> above).
> 
> I tested with the attached patch from Andiry applied and I got the
> following
> BUG during resume:

Does this bug occurs without the synchronize irq patch? Seems the rmmod,
shutdown and resume bugs are caused by xhci_cleanup_msix().

> 
> [   91.703778] sd 0:0:0:0: [sda] Starting disk
> [   91.704054] sd 2:0:0:0: [sdb] Starting disk
> [   91.703680] xhci_hcd 0000:04:00.0: Host controller not halted,
aborting
> reset.
> [   91.703680] BUG: sleeping function called from invalid context at
> /home/rafael/src/linux-2.6/kernel/mutex.c:278
> [   91.703680] in_atomic(): 1, irqs_disabled(): 1, pid: 1234, name:
> kworker/u:6
> [   91.703680] INFO: lockdep is turned off.
> [   91.703680] irq event stamp: 24060
> [   91.703680] hardirqs last  enabled at (24059): [<ffffffff810aa071>]
> rcu_note_context_switch+0xa1/0x1c0
> [   91.703680] hardirqs last disabled at (24060): [<ffffffff81494e92>]
> _raw_spin_lock_irq+0x12/0x50
> [   91.703680] softirqs last  enabled at (20026): [<ffffffff8105056e>]
> __do_softirq+0x11e/0x160
> [   91.703680] softirqs last disabled at (20011): [<ffffffff8100368c>]
> call_softirq+0x1c/0x30
> [   91.703680] Pid: 1234, comm: kworker/u:6 Tainted: G        W
2.6.37-
> rc6+ #12
> [   91.703680] Call Trace:
> [   91.703680]  [<ffffffff81079290>] ? print_irqtrace_events+0xd0/0xe0
> [   91.703680]  [<ffffffff81036783>] __might_sleep+0x103/0x130
> [   91.703680]  [<ffffffff81492f73>] mutex_lock_nested+0x33/0x380
> [   91.703680]  [<ffffffff81495727>] ?
> _raw_spin_unlock_irqrestore+0x67/0x70
> [   91.703680]  [<ffffffff810a39de>] ? dynamic_irq_cleanup+0xde/0x100
> [   91.703680]  [<ffffffff810a3a58>] irq_free_descs+0x58/0x90
> [   91.703680]  [<ffffffff81022008>] destroy_irq+0x78/0x90
> [   91.703680]  [<ffffffff810222c9>] native_teardown_msi_irq+0x9/0x10
> [   91.703680]  [<ffffffff811ee0b0>]
default_teardown_msi_irqs+0x70/0xa0
> [   91.703680]  [<ffffffff811edb41>] free_msi_irqs+0xa1/0x110
> [   91.703680]  [<ffffffff811eec1d>] pci_disable_msix+0x3d/0x50
> [   91.703680]  [<ffffffffa03f0609>] xhci_cleanup_msix+0x39/0x80
[xhci_hcd]
> [   91.703680]  [<ffffffffa03f111c>] xhci_resume+0x1ac/0x250
[xhci_hcd]
> [   91.703680]  [<ffffffffa03f65c4>] xhci_pci_resume+0x14/0x20
[xhci_hcd]
> [   91.703680]  [<ffffffff8138996b>] resume_common+0xbb/0x140
> [   91.703680]  [<ffffffff81389a5e>] hcd_pci_restore+0xe/0x10
> [   91.703680]  [<ffffffff811e36f3>] pci_pm_restore+0x63/0xb0
> [   91.703680]  [<ffffffff813334bd>] pm_op+0x19d/0x1c0
> [   91.703680]  [<ffffffff81333be4>] device_resume+0x94/0x220
> [   91.703680]  [<ffffffff81333d8c>] async_resume+0x1c/0x50
> [   91.703680]  [<ffffffff8106e6e6>] async_run_entry_fn+0x86/0x160
> [   91.703680]  [<ffffffff81060672>] process_one_work+0x1a2/0x450
> [   91.703680]  [<ffffffff81060614>] ? process_one_work+0x144/0x450
> [   91.703680]  [<ffffffff811d2704>] ? do_raw_spin_lock+0x104/0x170
> [   91.703680]  [<ffffffff8106e660>] ? async_run_entry_fn+0x0/0x160
> [   91.703680]  [<ffffffff81061e32>] worker_thread+0x162/0x340
> [   91.703680]  [<ffffffff81061cd0>] ? worker_thread+0x0/0x340
> [   91.703680]  [<ffffffff81066836>] kthread+0x96/0xa0
> [   91.703680]  [<ffffffff81003594>] kernel_thread_helper+0x4/0x10
> [   91.703680]  [<ffffffff81036fdb>] ? finish_task_switch+0x7b/0xe0
> [   91.703680]  [<ffffffff81495d00>] ? restore_args+0x0/0x30
> [   91.703680]  [<ffffffff810667a0>] ? kthread+0x0/0xa0
> [   91.703680]  [<ffffffff81003590>] ? kernel_thread_helper+0x0/0x10
> [   91.706248] xhci_hcd 0000:04:00.0: irq 81 for MSI/MSI-X
> [   91.706251] xhci_hcd 0000:04:00.0: irq 82 for MSI/MSI-X
> [   91.706253] xhci_hcd 0000:04:00.0: irq 83 for MSI/MSI-X
> [   91.706256] xhci_hcd 0000:04:00.0: irq 84 for MSI/MSI-X
> [   91.706258] xhci_hcd 0000:04:00.0: irq 85 for MSI/MSI-X
> [   91.706260] xhci_hcd 0000:04:00.0: irq 86 for MSI/MSI-X
> [   91.706262] xhci_hcd 0000:04:00.0: irq 87 for MSI/MSI-X
> 
> The issues appear to be 100% reproducible.
> 

I'm not able to reproduce the issue. Can you specify your kernel version
and attach your .config?

Thanks,
Andiry

