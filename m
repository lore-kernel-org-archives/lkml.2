Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095Ab2HVCuh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 22:50:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:4258 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271Ab2HVCuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 22:50:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,806,1336374000"; 
   d="scan'208";a="208064512"
Date: Wed, 22 Aug 2012 10:50:08 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "Tang, Feng" <feng.tang@intel.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Avi Kivity <avi@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci@vger.kernel.org
Subject: Re: pci_get_subsys: GFP_KERNEL allocations with IRQs disabled
Message-ID: <20120822025008.GA8066@localhost>
References: <5017D19B.5080806@redhat.com>
 <1343738627.27983.30.camel@gandalf.stny.rr.com>
 <5017D4AB.3090107@redhat.com>
 <1343740419.27983.33.camel@gandalf.stny.rr.com>
 <20120731234336.GA5526@localhost>
 <1343778699.27983.70.camel@gandalf.stny.rr.com>
 <20120731235705.GW2422@linux.vnet.ibm.com>
 <1343779778.27983.73.camel@gandalf.stny.rr.com>
 <20120801001811.GX2422@linux.vnet.ibm.com>
 <20120801004319.GA7043@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120801004319.GA7043@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Feng,

> I think it's pci_get_subsys() triggered this assert:
> 
>         /*
>          * Oi! Can't be having __GFP_FS allocations with IRQs disabled.
>          */
>         if (DEBUG_LOCKS_WARN_ON(irqs_disabled_flags(flags)))
>                 return;

It's bisected down to this commit:

commit 55c844a4dd16a4d1fdc0cf2a283ec631a02ec448
Author:     Feng Tang <feng.tang@intel.com>
AuthorDate: Wed May 30 23:15:41 2012 +0800
Commit:     Ingo Molnar <mingo@kernel.org>
CommitDate: Wed Jun 6 12:03:23 2012 +0200

    x86/reboot: Fix a warning message triggered by stop_other_cpus()

Thanks,
Fengguang

> [   91.282131] machine restart
> [   91.283895] ------------[ cut here ]------------
> [   91.284731] WARNING: at /c/wfg/linux/kernel/lockdep.c:2739 lockdep_trace_alloc+0x1fb/0x210()
> [   91.286132] Modules linked in:
> [   91.286703] Pid: 697, comm: reboot Not tainted 3.5.0-00024-g01ff5db-dirty #4
> [   91.287859] Call Trace:
> [   91.288289]  [<81050148>] warn_slowpath_common+0xb8/0x100
> [   91.289338]  [<8110acdb>] ? lockdep_trace_alloc+0x1fb/0x210
> [   91.290264]  [<8110acdb>] ? lockdep_trace_alloc+0x1fb/0x210
> [   91.291161]  [<810501ce>] warn_slowpath_null+0x3e/0x50
> [   91.292042]  [<8110acdb>] lockdep_trace_alloc+0x1fb/0x210
> [   91.292934]  [<81228e25>] kmem_cache_alloc_trace+0x55/0x600
> [   91.292934]  [<813025ca>] ? kobject_put+0x9a/0x160
> [   91.292934]  [<814e95e0>] ? klist_iter_exit+0x30/0x50
> [   91.292934]  [<81405881>] ? bus_find_device+0xf1/0x120
> [   91.292934]  [<81361a3c>] ? pci_get_subsys+0x11c/0x1b0
> [   91.292934]  [<81361a3c>] pci_get_subsys+0x11c/0x1b0
> [   91.292934]  [<81361afe>] pci_get_device+0x2e/0x40
> [   91.292934]  [<81033e25>] mach_reboot_fixups+0xa5/0xd0
> [   91.292934]  [<81027611>] native_machine_emergency_restart+0x1f1/0x590
> [   91.292934]  [<814f2e00>] ? printk+0x4b/0x5b
> [   91.292934]  [<810269ef>] native_machine_restart+0x6f/0x80
> [   91.292934]  [<810271cc>] machine_restart+0x1c/0x30
> [   91.292934]  [<810886e0>] kernel_restart+0x70/0xc0
> [   91.292934]  [<81088a85>] sys_reboot+0x325/0x380
> [   91.292934]  [<811f796c>] ? handle_pte_fault+0xdc/0x1740
> [   91.292934]  [<811f93e7>] ? handle_mm_fault+0x417/0x4a0
> [   91.292934]  [<8103e07b>] ? do_page_fault+0x7fb/0xb30
> [   91.292934]  [<810b33e7>] ? up_read+0x37/0x70
> [   91.292934]  [<8103e07b>] ? do_page_fault+0x7fb/0xb30
> [   91.292934]  [<8123c063>] ? do_sys_open+0x3a3/0x3f0
> [   91.292934]  [<8123c063>] ? do_sys_open+0x3a3/0x3f0
> [   91.292934]  [<810b0270>] ? update_rmtp+0xe0/0xe0
> [   91.292934]  [<8150376e>] ? restore_all+0xf/0xf
> [   91.292934]  [<8103d880>] ? vmalloc_sync_all+0x320/0x320
> [   91.292934]  [<81109fca>] ? trace_hardirqs_on_caller+0x28a/0x380
> [   91.292934]  [<81311594>] ? trace_hardirqs_on_thunk+0xc/0x10
> [   91.292934]  [<81503735>] syscall_call+0x7/0xb
> 
> Thanks,
> Fengguang
