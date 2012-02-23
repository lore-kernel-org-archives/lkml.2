Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab2BWTHe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 14:07:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15366 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753529Ab2BWTHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 14:07:32 -0500
Date: Thu, 23 Feb 2012 14:07:23 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, bskeggs@redhat.com
Subject: Re: 3.3-rc4 slub debug / rcu slowness, traces.
Message-ID: <20120223190722.GA21407@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, bskeggs@redhat.com
References: <20120223181438.GC26722@redhat.com>
 <20120223184143.GD26722@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120223184143.GD26722@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 01:41:44PM -0500, Dave Jones wrote:
 > This machine has switchable graphics. It's possible that I never noticed this before
 > because I had it switched onto Intel graphics when I used to use this laptop, so it
 > may have been there for a while.
 > 
 > I'm unclear on why disabling slub_debug makes the problem go away.
 > Perhaps wherever nouveau is spinning is just allocation heavy ?
 > I'll do some profiling.

So that'll be all the ACPI allocations/free's while it parses the rom.

 modprobe        R  running task     2920  2513   2387 0x00000080
  ffff8800813954d8 0000000000000046 000000000000c8a0 ffff8800b39da4a0
  ffff880081395518 ffff880081395fd8 ffff880081395fd8 ffff880081395fd8
  ffff88008f98a4a0 ffff8800b39da4a0 ffff8800813954c8 ffff880081395fd8
 Call Trace:
  [<ffffffff81381dda>] ? acpi_os_release_object+0xe/0x12
  [<ffffffff8169c81b>] preempt_schedule_irq+0x4b/0x80
  [<ffffffff8169e6e6>] retint_kernel+0x26/0x30
  [<ffffffff8169438f>] ? free_debug_processing+0x19f/0x1d3
  [<ffffffff8169ddad>] ? _raw_spin_unlock_irqrestore+0x6d/0x90
  [<ffffffff81694b46>] __slab_free+0x2e/0x1de
  [<ffffffff8169dd8a>] ? _raw_spin_unlock_irqrestore+0x4a/0x90
  [<ffffffff81334ccf>] ? debug_check_no_obj_freed+0x17f/0x230
  [<ffffffff81381dda>] ? acpi_os_release_object+0xe/0x12
  [<ffffffff81381dda>] ? acpi_os_release_object+0xe/0x12
  [<ffffffff811a60a0>] kmem_cache_free+0x240/0x250
  [<ffffffff81381dda>] acpi_os_release_object+0xe/0x12
  [<ffffffff813a64cb>] acpi_ps_free_op+0x64/0x6b
  [<ffffffff813a62ef>] ? acpi_ps_get_arg+0x1b/0x48
  [<ffffffff813a6562>] acpi_ps_delete_parse_tree+0x3e/0x60
  [<ffffffff813a5c63>] acpi_ps_complete_this_op+0x186/0x192
  [<ffffffff813a4d26>] acpi_ps_complete_op+0x2e/0x2b4
  [<ffffffff8138f87e>] ? acpi_ds_exec_end_op+0x548/0x57a
  [<ffffffff813a5860>] acpi_ps_parse_loop+0x8b4/0xa48
  [<ffffffff813ae1ec>] ? acpi_ut_create_generic_state+0x37/0x54
  [<ffffffff813a5e6b>] acpi_ps_parse_aml+0x10c/0x381
  [<ffffffff813a6846>] acpi_ps_execute_method+0x20e/0x2f0
  [<ffffffff813a0050>] acpi_ns_evaluate+0x190/0x2d7
  [<ffffffff813a362f>] acpi_evaluate_object+0x16a/0x2ae
  [<ffffffff811a63e6>] ? kfree+0x286/0x2a0
  [<ffffffffa07b4a53>] nouveau_acpi_get_bios_chunk+0x73/0xd0 [nouveau]
  [<ffffffffa073afc7>] load_vbios_acpi+0x37/0x50 [nouveau]
  [<ffffffffa07432ce>] nouveau_bios_init+0x12e/0x1620 [nouveau]
  [<ffffffff810d147d>] ? trace_hardirqs_on_caller+0x10d/0x1a0
  [<ffffffffa0720328>] nouveau_card_init+0x918/0x1640 [nouveau]
  [<ffffffffa07215f3>] nouveau_load+0x443/0x7d0 [nouveau]
  [<ffffffffa0035669>] drm_get_pci_dev+0x199/0x2b0 [drm]
  [<ffffffffa07b4b70>] nouveau_pci_probe+0x10/0x12 [nouveau]
  [<ffffffff8134a73c>] local_pci_probe+0x5c/0xd0
  [<ffffffff8134c039>] pci_device_probe+0x109/0x130
  [<ffffffff81416dbc>] driver_probe_device+0x9c/0x300
  [<ffffffff814170cb>] __driver_attach+0xab/0xb0
  [<ffffffff81417020>] ? driver_probe_device+0x300/0x300
  [<ffffffff8141514e>] bus_for_each_dev+0x5e/0x90
  [<ffffffff814169be>] driver_attach+0x1e/0x20
  [<ffffffff814165b0>] bus_add_driver+0x1c0/0x2b0
  [<ffffffff81417646>] driver_register+0x76/0x140
  [<ffffffff81333368>] ? __raw_spin_lock_init+0x38/0x70
  [<ffffffff8134bcf6>] __pci_register_driver+0x66/0xe0
  [<ffffffffa003589a>] drm_pci_init+0x11a/0x130 [drm]
  [<ffffffff8141078c>] ? vga_switcheroo_register_handler+0x3c/0x60
  [<ffffffffa07e5000>] ? 0xffffffffa07e4fff
  [<ffffffffa07e504f>] nouveau_init+0x4f/0x1000 [nouveau]
  [<ffffffff81002129>] do_one_initcall+0x129/0x170
  [<ffffffff810de9c2>] sys_init_module+0xb92/0x20d0
  [<ffffffff816a5ea9>] system_call_fastpath+0x16/0x1b
 
I suspect the way out of this would be to move the bios parsing out of the
module init path.  No idea why it's such an unbearably slow operation
on this machine though. Blame Sony I guess.

thoughts?

	Dave

