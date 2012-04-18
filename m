Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533Ab2DRDTk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 23:19:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32926 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710Ab2DRDTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 23:19:39 -0400
Date: Tue, 17 Apr 2012 23:19:35 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [3.4-rc3] Thread overran stack, or stack corrupted
Message-ID: <20120418031935.GB29828@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20120417172142.GA30237@redhat.com>
 <CA+55aFy-uhOgEoEBr-LkOjFQBVh14wwr-20jTrtsg_2EnuNY5g@mail.gmail.com>
 <20120417203223.GA31699@redhat.com>
 <CA+55aFzWzhxaVHuPY_oB5PVhw2Gxiwr46vyHCHEsU0o-HFikTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzWzhxaVHuPY_oB5PVhw2Gxiwr46vyHCHEsU0o-HFikTw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 06:36:00PM -0700, Linus Torvalds wrote:
 > On Tue, Apr 17, 2012 at 1:32 PM, Dave Jones <davej@redhat.com> wrote:
 > >
 > > Ok, this builds. I'll run with this for a while, and see what falls out.
 > 
 > So assuming that works and doesn't have some silly thinko in it, I
 > think it is a worthwhile addition to the whole stack debugging thing.
 > Right now, the message about "process xyz used most stack, x bytes
 > free" really is pretty useless. If it were to actually show "hey, this
 > was the deepest actual stack chain", that sounds quite interesting.
 > 
 > Of course, if the stack is largely used by some leaf function that
 > just has a big stack frame, that won't show up in the stack trace, but
 > that's presumably not the worst worry. And hopefully the caller of
 > that would still be pretty deep and show up without having been
 > overwritten.

So now that I'm instrumenting it, it's taking a lot longer to trigger
(how typical). Almost 6 hours in though, it's down to 72 bytes, and spewed
the traces below, which look pretty.. deep.
I'll leave it run overnight, to see if it triggers the 'overran stack' trace
again, but I suspect it'll look very similar to the ones shown below.

	Dave


[ 2496.639872] trinity used greatest stack depth: 1560 bytes left
[ 3604.156895] trinity used greatest stack depth: 1352 bytes left
[ 5448.499455] trinity used greatest stack depth: 1264 bytes left
[ 9751.238389] trinity used greatest stack depth: 864 bytes left
[15000.946998] trinity used greatest stack depth: 800 bytes left
[15079.438172] trinity used greatest stack depth: 656 bytes left
[21137.019557] trinity used greatest stack depth: 456 bytes left
[21137.019982] Call Trace:
[21137.020353]  [<ffffffff8115a5d5>] ? mempool_alloc_slab+0x15/0x20
[21137.020765]  [<ffffffff8115a5d5>] ? mempool_alloc_slab+0x15/0x20
[21137.021718]  [<ffffffff8108ba29>] ? debug_lockdep_rcu_enabled+0x9/0x40
[21137.022231]  [<ffffffff810de7b0>] ? __module_address+0x10/0x160
[21137.023327]  [<ffffffff811a9eae>] ? deactivate_slab+0x3ce/0x5f0
[21137.023954]  [<ffffffff8108c230>] ? __kernel_text_address+0x60/0x90
[21137.024989]  [<ffffffff8101e861>] ? print_context_stack+0x81/0x140
[21137.025704]  [<ffffffff816b301e>] ? sub_preempt_count+0xe/0xd0
[21137.026157]  [<ffffffff816aeca5>] ? _raw_spin_unlock+0x35/0x60
[21137.027200]  [<ffffffff811aa02c>] ? deactivate_slab+0x54c/0x5f0
[21137.027710]  [<ffffffff8115a5d5>] ? mempool_alloc_slab+0x15/0x20
[21137.028708]  [<ffffffff8115a5d5>] ? mempool_alloc_slab+0x15/0x20
[21137.029558]  [<ffffffff8115a5d5>] ? mempool_alloc_slab+0x15/0x20
[21137.030053]  [<ffffffff811a7fcc>] ? set_track+0xac/0x1a0
[21137.031017]  [<ffffffff8115a5d5>] ? mempool_alloc_slab+0x15/0x20
[21137.031669]  [<ffffffff810a847a>] ? cpuacct_charge+0x2a/0x240
[21137.032782]  [<ffffffff8109c04f>] ? finish_task_switch+0x3f/0x120
[21137.033295]  [<ffffffff816b301e>] ? sub_preempt_count+0xe/0xd0
[21137.033967]  [<ffffffff816aebb1>] ? _raw_spin_unlock_irq+0x41/0x70
[21137.035386]  [<ffffffff8108ba29>] ? debug_lockdep_rcu_enabled+0x9/0x40
[21137.035872]  [<ffffffff810de7b0>] ? __module_address+0x10/0x160
[21137.036376]  [<ffffffff8108ba29>] ? debug_lockdep_rcu_enabled+0x9/0x40
[21137.037401]  [<ffffffff810de7b0>] ? __module_address+0x10/0x160
[21137.039119]  [<ffffffff811a9eae>] ? deactivate_slab+0x3ce/0x5f0
[21137.040116]  [<ffffffff8108c230>] ? __kernel_text_address+0x60/0x90
[21137.041752]  [<ffffffff8101e861>] ? print_context_stack+0x81/0x140
[21137.042494]  [<ffffffff810a2981>] ? get_parent_ip+0x11/0x50
[21137.043751]  [<ffffffff816b30ad>] ? sub_preempt_count+0x9d/0xd0
[21137.044302]  [<ffffffff816aeca5>] ? _raw_spin_unlock+0x35/0x60
[21137.044796]  [<ffffffff811aa02c>] ? deactivate_slab+0x54c/0x5f0
[21137.045883]  [<ffffffffa037d202>] ? alloc_extent_state+0x32/0x1c0 [btrfs]
[21137.046391]  [<ffffffffa037d202>] ? alloc_extent_state+0x32/0x1c0 [btrfs]
[21137.046838]  [<ffffffffa037d202>] ? alloc_extent_state+0x32/0x1c0 [btrfs]
[21137.047369]  [<ffffffff811a7fcc>] ? set_track+0xac/0x1a0
[21137.048232]  [<ffffffffa037d202>] ? alloc_extent_state+0x32/0x1c0 [btrfs]
[21137.049577]  [<ffffffff8108ba29>] ? debug_lockdep_rcu_enabled+0x9/0x40
[21137.050115]  [<ffffffff810de7b0>] ? __module_address+0x10/0x160
[21137.050879]  [<ffffffff816b301e>] ? sub_preempt_count+0xe/0xd0
[21137.051399]  [<ffffffff8108ba29>] ? debug_lockdep_rcu_enabled+0x9/0x40
[21137.052206]  [<ffffffff816b301e>] ? sub_preempt_count+0xe/0xd0
[21137.053551]  [<ffffffff816ac00f>] ? __mutex_unlock_slowpath+0x14f/0x190
[21137.054026]  [<ffffffff8101e861>] ? print_context_stack+0x81/0x140
[21137.055167]  [<ffffffff816ac05e>] ? mutex_unlock+0xe/0x10
[21137.055655]  [<ffffffff816b301e>] ? sub_preempt_count+0xe/0xd0
[21137.056156]  [<ffffffff81380165>] ? bit_putcs+0x2e5/0x560
[21137.057035]  [<ffffffff814ae4cc>] ? qtd_fill+0xc/0xc0
[21137.058041]  [<ffffffff816ac05e>] ? mutex_unlock+0xe/0x10
[21137.058644]  [<ffffffff814b5609>] ? qh_append_tds+0xf9/0x690
[21137.059789]  [<ffffffff816b301e>] ? sub_preempt_count+0xe/0xd0
[21137.060326]  [<ffffffff816b301e>] ? sub_preempt_count+0xe/0xd0
[21137.061115]  [<ffffffff816aec5e>] ? _raw_spin_unlock_irqrestore+0x7e/0x90
[21137.062180]  [<ffffffff816ac00f>] ? __mutex_unlock_slowpath+0x14f/0x190
[21137.062731]  [<ffffffff81050869>] ? __phys_addr+0x9/0x50
[21137.063832]  [<ffffffff81345fb8>] ? swiotlb_dma_mapping_error+0x18/0x30
[21137.064337]  [<ffffffff81499101>] ? usb_hcd_map_urb_for_dma+0x531/0x5b0
[21137.065074]  [<ffffffff813806be>] ? soft_cursor+0x1ce/0x270
[21137.065919]  [<ffffffffa00c73d2>] ? nouveau_fbcon_fillrect+0xc2/0x110 [nouveau]
[21137.066758]  [<ffffffff8149922f>] ? usb_hcd_submit_urb+0xaf/0x860
[21137.068183]  [<ffffffff8137fe3b>] ? bit_cursor+0x60b/0x650
[21137.068702]  [<ffffffff816b301e>] ? sub_preempt_count+0xe/0xd0
[21137.069802]  [<ffffffff816aec5e>] ? _raw_spin_unlock_irqrestore+0x7e/0x90
[21137.070531]  [<ffffffff814d336e>] ? usb_serial_generic_write_start+0x22e/0x270
[21137.071113]  [<ffffffff81090667>] ? kfifo_copy_in+0x77/0x90
[21137.071588]  [<ffffffff816b301e>] ? sub_preempt_count+0xe/0xd0
[21137.072813]  [<ffffffff814d3664>] ? usb_serial_generic_write+0x84/0xd0
[21137.073346]  [<ffffffff814d4220>] ? usb_console_write+0x110/0x250
[21137.074210]  [<ffffffff81335fae>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[21137.075545]  [<ffffffff816af5b4>] ? retint_restore_args+0x13/0x13
[21137.076036]  [<ffffffff81066ed9>] ? vprintk+0x389/0x600
[21137.076738]  [<ffffffff810d375d>] ? trace_hardirqs_on+0xd/0x10
[21137.078066]  [<ffffffff810d375d>] ? trace_hardirqs_on+0xd/0x10
[21137.078542]  [<ffffffff810d375d>] ? trace_hardirqs_on+0xd/0x10
[21137.079263]  [<ffffffff816a1b67>] ? printk+0x51/0x53
[21137.080295]  [<ffffffff810de7b0>] ? __module_address+0x10/0x160
[21137.080839]  [<ffffffff816b301e>] ? sub_preempt_count+0xe/0xd0
[21137.082013]  [<ffffffff810e3145>] ? is_module_text_address+0x55/0x60
[21137.082566]  [<ffffffff8108c230>] ? __kernel_text_address+0x60/0x90
[21137.083458]  [<ffffffff8101e861>] ? print_context_stack+0x81/0x140
[21137.084787]  [<ffffffff8101d54f>] ? dump_trace+0x17f/0x2f0
[21137.085246]  [<ffffffff8101ea0c>] show_trace_log_lvl+0x5c/0x80
[21137.085962]  [<ffffffff8101ea45>] show_trace+0x15/0x20
[21137.087188]  [<ffffffff8106bbaf>] do_exit+0xb7f/0xb90
[21137.087629]  [<ffffffff8106bf0f>] do_group_exit+0x4f/0xc0
[21137.088388]  [<ffffffff8107eade>] get_signal_to_deliver+0x20e/0x880
[21137.089757]  [<ffffffff8107bdb0>] ? __send_signal+0x150/0x7f0
[21137.090202]  [<ffffffff811177de>] ? __rcu_read_unlock+0xe/0xa0
[21137.091126]  [<ffffffff8108b830>] ? task_tgid_nr_ns+0x20/0x20
[21137.091701]  [<ffffffff8101b315>] do_signal+0x65/0x5d0
[21137.092560]  [<ffffffff816aebb1>] ? _raw_spin_unlock_irq+0x41/0x70
[21137.094242]  [<ffffffff8107f322>] ? set_current_blocked+0x52/0x60
[21137.095524]  [<ffffffff81335fae>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[21137.096777]  [<ffffffff816aebb1>] ? _raw_spin_unlock_irq+0x41/0x70
[21137.098541]  [<ffffffff8101b905>] do_notify_resume+0x65/0x80
[21137.099113]  [<ffffffff81335fae>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[21137.099686]  [<ffffffff816b73a2>] int_signal+0x12/0x17
[21162.880562] trinity used greatest stack depth: 280 bytes left
[21162.881249] Call Trace:
[21162.883712]  [<ffffffff811605d4>] ? free_pages_prepare+0x1b4/0x290
[21162.884545]  [<ffffffff811b8e20>] ? mem_cgroup_recursive_stat+0x70/0x70
[21162.885217]  [<ffffffff810d375d>] ? trace_hardirqs_on+0xd/0x10
[21162.885673]  [<ffffffff8108ba29>] ? debug_lockdep_rcu_enabled+0x9/0x40
[21162.886320]  [<ffffffff810de7b0>] ? __module_address+0x10/0x160
[21162.887113]  [<ffffffff8108ba29>] ? debug_lockdep_rcu_enabled+0x9/0x40
[21162.887736]  [<ffffffff810de7b0>] ? __module_address+0x10/0x160
[21162.888600]  [<ffffffff811a9eae>] ? deactivate_slab+0x3ce/0x5f0
[21162.889674]  [<ffffffff8108c230>] ? __kernel_text_address+0x60/0x90
[21162.890501]  [<ffffffff8101e861>] ? print_context_stack+0x81/0x140
[21162.891421]  [<ffffffff816b301e>] ? sub_preempt_count+0xe/0xd0
[21162.892022]  [<ffffffff816aeca5>] ? _raw_spin_unlock+0x35/0x60
[21162.893069]  [<ffffffff811aa02c>] ? deactivate_slab+0x54c/0x5f0
[21162.893717]  [<ffffffff8115a5d5>] ? mempool_alloc_slab+0x15/0x20
[21162.895053]  [<ffffffff8115a5d5>] ? mempool_alloc_slab+0x15/0x20
[21162.895490]  [<ffffffff8115a5d5>] ? mempool_alloc_slab+0x15/0x20
[21162.896200]  [<ffffffff811a7fcc>] ? set_track+0xac/0x1a0
[21162.897624]  [<ffffffff8115a5d5>] ? mempool_alloc_slab+0x15/0x20
[21162.898462]  [<ffffffff8108ba29>] ? debug_lockdep_rcu_enabled+0x9/0x40
[21162.899162]  [<ffffffff810de7b0>] ? __module_address+0x10/0x160
[21162.899775]  [<ffffffff811a9eae>] ? deactivate_slab+0x3ce/0x5f0
[21162.900428]  [<ffffffff8108c230>] ? __kernel_text_address+0x60/0x90
[21162.901518]  [<ffffffff8101e861>] ? print_context_stack+0x81/0x140
[21162.902104]  [<ffffffff810a2981>] ? get_parent_ip+0x11/0x50
[21162.902917]  [<ffffffff816b30ad>] ? sub_preempt_count+0x9d/0xd0
[21162.904239]  [<ffffffff816aeca5>] ? _raw_spin_unlock+0x35/0x60
[21162.904675]  [<ffffffff811aa02c>] ? deactivate_slab+0x54c/0x5f0
[21162.905402]  [<ffffffff8115a5d5>] ? mempool_alloc_slab+0x15/0x20
[21162.906195]  [<ffffffff8115a5d5>] ? mempool_alloc_slab+0x15/0x20
[21162.907352]  [<ffffffff8108ba29>] ? debug_lockdep_rcu_enabled+0x9/0x40
[21162.907863]  [<ffffffff810de7b0>] ? __module_address+0x10/0x160
[21162.908965]  [<ffffffff811a9eae>] ? deactivate_slab+0x3ce/0x5f0
[21162.909507]  [<ffffffff8108c230>] ? __kernel_text_address+0x60/0x90
[21162.910322]  [<ffffffff8101e861>] ? print_context_stack+0x81/0x140
[21162.911307]  [<ffffffff816b301e>] ? sub_preempt_count+0xe/0xd0
[21162.911875]  [<ffffffff816aeca5>] ? _raw_spin_unlock+0x35/0x60
[21162.912953]  [<ffffffff811aa02c>] ? deactivate_slab+0x54c/0x5f0
[21162.913528]  [<ffffffff8115a5d5>] ? mempool_alloc_slab+0x15/0x20
[21162.914363]  [<ffffffff8115a5d5>] ? mempool_alloc_slab+0x15/0x20
[21162.915689]  [<ffffffff8115a5d5>] ? mempool_alloc_slab+0x15/0x20
[21162.916138]  [<ffffffff811a7fcc>] ? set_track+0xac/0x1a0
[21162.916812]  [<ffffffff8115a5d5>] ? mempool_alloc_slab+0x15/0x20
[21162.918125]  [<ffffffff810de7b0>] ? __module_address+0x10/0x160
[21162.918571]  [<ffffffff810ccf2d>] ? trace_hardirqs_off+0xd/0x10
[21162.919272]  [<ffffffff811a9eae>] ? deactivate_slab+0x3ce/0x5f0
[21162.920287]  [<ffffffff8108c230>] ? __kernel_text_address+0x60/0x90
[21162.920898]  [<ffffffff8101e861>] ? print_context_stack+0x81/0x140
[21162.921917]  [<ffffffff816b301e>] ? sub_preempt_count+0xe/0xd0
[21162.922564]  [<ffffffff816aeca5>] ? _raw_spin_unlock+0x35/0x60
[21162.923857]  [<ffffffff811aa02c>] ? deactivate_slab+0x54c/0x5f0
[21162.924318]  [<ffffffff8115a5d5>] ? mempool_alloc_slab+0x15/0x20
[21162.925040]  [<ffffffff8115a5d5>] ? mempool_alloc_slab+0x15/0x20
[21162.926251]  [<ffffffff8115a5d5>] ? mempool_alloc_slab+0x15/0x20
[21162.926741]  [<ffffffff811a7fcc>] ? set_track+0xac/0x1a0
[21162.927492]  [<ffffffff8115a5d5>] ? mempool_alloc_slab+0x15/0x20
[21162.928929]  [<ffffffff8108ba29>] ? debug_lockdep_rcu_enabled+0x9/0x40
[21162.929416]  [<ffffffff810de7b0>] ? __module_address+0x10/0x160
[21162.930157]  [<ffffffff8143d66a>] ? scsi_pool_alloc_command+0x4a/0x80
[21162.930697]  [<ffffffff8108ba29>] ? debug_lockdep_rcu_enabled+0x9/0x40
[21162.931644]  [<ffffffff810de7b0>] ? __module_address+0x10/0x160
[21162.932587]  [<ffffffff811a9eae>] ? deactivate_slab+0x3ce/0x5f0
[21162.933116]  [<ffffffff8108c230>] ? __kernel_text_address+0x60/0x90
[21162.934177]  [<ffffffff8101e861>] ? print_context_stack+0x81/0x140
[21162.934712]  [<ffffffff810a2981>] ? get_parent_ip+0x11/0x50
[21162.935736]  [<ffffffff816b30ad>] ? sub_preempt_count+0x9d/0xd0
[21162.936318]  [<ffffffff816aeca5>] ? _raw_spin_unlock+0x35/0x60
[21162.937110]  [<ffffffff811aa02c>] ? deactivate_slab+0x54c/0x5f0
[21162.938422]  [<ffffffffa037d202>] ? alloc_extent_state+0x32/0x1c0 [btrfs]
[21162.938888]  [<ffffffffa037d202>] ? alloc_extent_state+0x32/0x1c0 [btrfs]
[21162.939999]  [<ffffffffa037d202>] ? alloc_extent_state+0x32/0x1c0 [btrfs]
[21162.940457]  [<ffffffff811a7fcc>] ? set_track+0xac/0x1a0
[21162.941461]  [<ffffffffa037d202>] ? alloc_extent_state+0x32/0x1c0 [btrfs]
[21162.941912]  [<ffffffff8108ba29>] ? debug_lockdep_rcu_enabled+0x9/0x40
[21162.942806]  [<ffffffff810de7b0>] ? __module_address+0x10/0x160
[21162.943406]  [<ffffffff816b301e>] ? sub_preempt_count+0xe/0xd0
[21162.944445]  [<ffffffff8108ba29>] ? debug_lockdep_rcu_enabled+0x9/0x40
[21162.944898]  [<ffffffff816b301e>] ? sub_preempt_count+0xe/0xd0
[21162.945692]  [<ffffffff816aec5e>] ? _raw_spin_unlock_irqrestore+0x7e/0x90
[21162.946692]  [<ffffffff816ac00f>] ? __mutex_unlock_slowpath+0x14f/0x190
[21162.947319]  [<ffffffff8101e861>] ? print_context_stack+0x81/0x140
[21162.948440]  [<ffffffff816ac05e>] ? mutex_unlock+0xe/0x10
[21162.948933]  [<ffffffff816b301e>] ? sub_preempt_count+0xe/0xd0
[21162.949744]  [<ffffffff814ae4cc>] ? qtd_fill+0xc/0xc0
[21162.950960]  [<ffffffff816ac05e>] ? mutex_unlock+0xe/0x10
[21162.951404]  [<ffffffff814b5609>] ? qh_append_tds+0xf9/0x690
[21162.952143]  [<ffffffff816b301e>] ? sub_preempt_count+0xe/0xd0
[21162.953576]  [<ffffffffa00a5e86>] ? nouveau_dma_wait+0x16/0x5b0 [nouveau]
[21162.954397]  [<ffffffff816b301e>] ? sub_preempt_count+0xe/0xd0
[21162.955171]  [<ffffffff816aec5e>] ? _raw_spin_unlock_irqrestore+0x7e/0x90
[21162.955803]  [<ffffffff816ac00f>] ? __mutex_unlock_slowpath+0x14f/0x190
[21162.956249]  [<ffffffffa00c7180>] ? nouveau_fbcon_imageblit+0x90/0x110 [nouveau]
[21162.957053]  [<ffffffff81050869>] ? __phys_addr+0x9/0x50
[21162.958037]  [<ffffffff81345fb8>] ? swiotlb_dma_mapping_error+0x18/0x30
[21162.958692]  [<ffffffff81499101>] ? usb_hcd_map_urb_for_dma+0x531/0x5b0
[21162.960092]  [<ffffffffa00c73d2>] ? nouveau_fbcon_fillrect+0xc2/0x110 [nouveau]
[21162.961206]  [<ffffffff8149922f>] ? usb_hcd_submit_urb+0xaf/0x860
[21162.962185]  [<ffffffff816b301e>] ? sub_preempt_count+0xe/0xd0
[21162.962649]  [<ffffffff816aec5e>] ? _raw_spin_unlock_irqrestore+0x7e/0x90
[21162.963072]  [<ffffffff814d336e>] ? usb_serial_generic_write_start+0x22e/0x270
[21162.963640]  [<ffffffff81090667>] ? kfifo_copy_in+0x77/0x90
[21162.964801]  [<ffffffff814d3664>] ? usb_serial_generic_write+0x84/0xd0
[21162.965701]  [<ffffffff814d4220>] ? usb_console_write+0x110/0x250
[21162.966264]  [<ffffffff81335fae>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[21162.967431]  [<ffffffff816af5b4>] ? retint_restore_args+0x13/0x13
[21162.967995]  [<ffffffff816aec5e>] ? _raw_spin_unlock_irqrestore+0x7e/0x90
[21162.969424]  [<ffffffff81066ed9>] ? vprintk+0x389/0x600
[21162.969877]  [<ffffffff810d375d>] ? trace_hardirqs_on+0xd/0x10
[21162.970836]  [<ffffffff810d375d>] ? trace_hardirqs_on+0xd/0x10
[21162.971524]  [<ffffffff810d375d>] ? trace_hardirqs_on+0xd/0x10
[21162.972502]  [<ffffffff816a1b67>] ? printk+0x51/0x53
[21162.973192]  [<ffffffff810de7b0>] ? __module_address+0x10/0x160
[21162.974558]  [<ffffffff816b301e>] ? sub_preempt_count+0xe/0xd0
[21162.975000]  [<ffffffff810e3145>] ? is_module_text_address+0x55/0x60
[21162.976554]  [<ffffffff8108c230>] ? __kernel_text_address+0x60/0x90
[21162.978461]  [<ffffffff8101e861>] ? print_context_stack+0x81/0x140
[21162.978907]  [<ffffffff8101d54f>] ? dump_trace+0x17f/0x2f0
[21162.979574]  [<ffffffff8101ea0c>] show_trace_log_lvl+0x5c/0x80
[21162.979977]  [<ffffffff8101ea45>] show_trace+0x15/0x20
[21162.980819]  [<ffffffff8106bbaf>] do_exit+0xb7f/0xb90
[21162.982280]  [<ffffffff8106bf0f>] do_group_exit+0x4f/0xc0
[21162.982729]  [<ffffffff8107eade>] get_signal_to_deliver+0x20e/0x880
[21162.983859]  [<ffffffff8107bdb0>] ? __send_signal+0x150/0x7f0
[21162.984789]  [<ffffffff811177de>] ? __rcu_read_unlock+0xe/0xa0
[21162.986147]  [<ffffffff8108b830>] ? task_tgid_nr_ns+0x20/0x20
[21162.986616]  [<ffffffff8101b315>] do_signal+0x65/0x5d0
[21162.987316]  [<ffffffff816aebb1>] ? _raw_spin_unlock_irq+0x41/0x70
[21162.987761]  [<ffffffff8107f322>] ? set_current_blocked+0x52/0x60
[21162.988680]  [<ffffffff81335fae>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[21162.989521]  [<ffffffff816aebb1>] ? _raw_spin_unlock_irq+0x41/0x70
[21162.990238]  [<ffffffff8101b905>] do_notify_resume+0x65/0x80
[21162.991283]  [<ffffffff81335fae>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[21162.992209]  [<ffffffff816b73a2>] int_signal+0x12/0x17
[21171.661403] trinity used greatest stack depth: 72 bytes left
[21171.661978] Call Trace:
[21171.662403]  [<ffffffff8108c230>] ? __kernel_text_address+0x60/0x90
[21171.663400]  [<ffffffff8101e861>] ? print_context_stack+0x81/0x140
[21171.663856]  [<ffffffff816b301e>] ? sub_preempt_count+0xe/0xd0
[21171.664895]  [<ffffffff8101d559>] ? dump_trace+0x189/0x2f0
[21171.665647]  [<ffffffffa037d5aa>] ? free_extent_state+0x5a/0x1b0 [btrfs]
[21171.666475]  [<ffffffffa037d5aa>] ? free_extent_state+0x5a/0x1b0 [btrfs]
[21171.667570]  [<ffffffffa037d5aa>] ? free_extent_state+0x5a/0x1b0 [btrfs]
[21171.668140]  [<ffffffff810a2981>] ? get_parent_ip+0x11/0x50
[21171.669035]  [<ffffffff810a2981>] ? get_parent_ip+0x11/0x50
[21171.670080]  [<ffffffff810d375d>] ? trace_hardirqs_on+0xd/0x10
[21171.670728]  [<ffffffff8133db38>] ? debug_check_no_obj_freed+0x88/0x230
[21171.671778]  [<ffffffff810a2981>] ? get_parent_ip+0x11/0x50
[21171.672654]  [<ffffffff816b30ad>] ? sub_preempt_count+0x9d/0xd0
[21171.673285]  [<ffffffff816aec2a>] ? _raw_spin_unlock_irqrestore+0x4a/0x90
[21171.674667]  [<ffffffff8133dc2f>] ? debug_check_no_obj_freed+0x17f/0x230
[21171.675138]  [<ffffffff811605d4>] ? free_pages_prepare+0x1b4/0x290
[21171.675722]  [<ffffffff810d375d>] ? trace_hardirqs_on+0xd/0x10
[21171.676895]  [<ffffffff81160c0e>] ? free_hot_cold_page_list+0x5e/0x1a0
[21171.677493]  [<ffffffff811bd0be>] ? mem_cgroup_uncharge_cache_page+0x1e/0x30
[21171.678457]  [<ffffffff8116d2da>] ? shrink_page_list+0x69a/0xac0
[21171.679757]  [<ffffffffa0090205>] ? ttm_dma_pool_mm_shrink+0x105/0x190 [ttm]
[21171.680287]  [<ffffffff810a2981>] ? get_parent_ip+0x11/0x50
[21171.680886]  [<ffffffff816b30ad>] ? sub_preempt_count+0x9d/0xd0
[21171.682085]  [<ffffffff811c668d>] ? put_super+0x1d/0x40
[21171.682662]  [<ffffffffa0090205>] ? ttm_dma_pool_mm_shrink+0x105/0x190 [ttm]
[21171.684097]  [<ffffffff810a2981>] ? get_parent_ip+0x11/0x50
[21171.684555]  [<ffffffff816b30ad>] ? sub_preempt_count+0x9d/0xd0
[21171.685408]  [<ffffffff816aeca5>] ? _raw_spin_unlock+0x35/0x60
[21171.685982]  [<ffffffff811c66a1>] ? put_super+0x31/0x40
[21171.687135]  [<ffffffff8111d081>] ? delayacct_end+0x71/0xa0
[21171.687675]  [<ffffffff8108ba29>] ? debug_lockdep_rcu_enabled+0x9/0x40
[21171.688548]  [<ffffffff810de7b0>] ? __module_address+0x10/0x160
[21171.689918]  [<ffffffff811a9eae>] ? deactivate_slab+0x3ce/0x5f0
[21171.690414]  [<ffffffff8108c230>] ? __kernel_text_address+0x60/0x90
[21171.690989]  [<ffffffff8101e861>] ? print_context_stack+0x81/0x140
[21171.691842]  [<ffffffff816b301e>] ? sub_preempt_count+0xe/0xd0
[21171.693212]  [<ffffffff816aeca5>] ? _raw_spin_unlock+0x35/0x60
[21171.693704]  [<ffffffff811aa02c>] ? deactivate_slab+0x54c/0x5f0
[21171.694509]  [<ffffffff8108ba29>] ? debug_lockdep_rcu_enabled+0x9/0x40
[21171.695534]  [<ffffffff810de7b0>] ? __module_address+0x10/0x160
[21171.696104]  [<ffffffff811a9eae>] ? deactivate_slab+0x3ce/0x5f0
[21171.697232]  [<ffffffff8108c230>] ? __kernel_text_address+0x60/0x90
[21171.697821]  [<ffffffff8101e861>] ? print_context_stack+0x81/0x140
[21171.699117]  [<ffffffff810a2981>] ? get_parent_ip+0x11/0x50
[21171.699618]  [<ffffffff816b30ad>] ? sub_preempt_count+0x9d/0xd0
[21171.700421]  [<ffffffff816aeca5>] ? _raw_spin_unlock+0x35/0x60
[21171.701746]  [<ffffffff811aa02c>] ? deactivate_slab+0x54c/0x5f0
[21171.702219]  [<ffffffff8115a5d5>] ? mempool_alloc_slab+0x15/0x20
[21171.703277]  [<ffffffff8115a5d5>] ? mempool_alloc_slab+0x15/0x20
[21171.703880]  [<ffffffff8115a5d5>] ? mempool_alloc_slab+0x15/0x20
[21171.704810]  [<ffffffff811a7fcc>] ? set_track+0xac/0x1a0
[21171.706108]  [<ffffffff8115a5d5>] ? mempool_alloc_slab+0x15/0x20
[21171.706581]  [<ffffffff810d375d>] ? trace_hardirqs_on+0xd/0x10
[21171.707560]  [<ffffffff8115a5d5>] ? mempool_alloc_slab+0x15/0x20
[21171.708156]  [<ffffffff8108ba29>] ? debug_lockdep_rcu_enabled+0x9/0x40
[21171.709302]  [<ffffffff810de7b0>] ? __module_address+0x10/0x160
[21171.709803]  [<ffffffff811a9eae>] ? deactivate_slab+0x3ce/0x5f0
[21171.710925]  [<ffffffff8108c230>] ? __kernel_text_address+0x60/0x90
[21171.711544]  [<ffffffff8101e861>] ? print_context_stack+0x81/0x140
[21171.712409]  [<ffffffff810a2981>] ? get_parent_ip+0x11/0x50
[21171.713734]  [<ffffffff8108ba29>] ? debug_lockdep_rcu_enabled+0x9/0x40
[21171.714231]  [<ffffffff810de7b0>] ? __module_address+0x10/0x160
[21171.715304]  [<ffffffff8108ba29>] ? debug_lockdep_rcu_enabled+0x9/0x40
[21171.716149]  [<ffffffff810de7b0>] ? __module_address+0x10/0x160
[21171.716902]  [<ffffffff811a9eae>] ? deactivate_slab+0x3ce/0x5f0
[21171.717513]  [<ffffffff8108c230>] ? __kernel_text_address+0x60/0x90
[21171.718660]  [<ffffffff8101e861>] ? print_context_stack+0x81/0x140
[21171.719208]  [<ffffffff810a2981>] ? get_parent_ip+0x11/0x50
[21171.720049]  [<ffffffff816b30ad>] ? sub_preempt_count+0x9d/0xd0
[21171.721357]  [<ffffffff816aeca5>] ? _raw_spin_unlock+0x35/0x60
[21171.721902]  [<ffffffff811aa02c>] ? deactivate_slab+0x54c/0x5f0
[21171.722939]  [<ffffffffa03a312e>] ? btrfs_add_delayed_tree_ref+0x8e/0x1d0 [btrfs]
[21171.723535]  [<ffffffffa03a312e>] ? btrfs_add_delayed_tree_ref+0x8e/0x1d0 [btrfs]
[21171.724412]  [<ffffffffa03a312e>] ? btrfs_add_delayed_tree_ref+0x8e/0x1d0 [btrfs]
[21171.725889]  [<ffffffff811a7fcc>] ? set_track+0xac/0x1a0
[21171.726373]  [<ffffffffa03a312e>] ? btrfs_add_delayed_tree_ref+0x8e/0x1d0 [btrfs]
[21171.726906]  [<ffffffff8108ba29>] ? debug_lockdep_rcu_enabled+0x9/0x40
[21171.728478]  [<ffffffff8133d384>] ? debug_object_activate+0x84/0x1a0
[21171.729179]  [<ffffffff8133cf32>] ? __debug_object_init+0xa2/0x410
[21171.729714]  [<ffffffff8133d9d7>] ? debug_object_active_state+0x67/0x140
[21171.730938]  [<ffffffff811630fb>] ? __set_page_dirty_nobuffers+0x7b/0x1a0
[21171.731420]  [<ffffffff8109c04f>] ? finish_task_switch+0x3f/0x120
[21171.732387]  [<ffffffff816b301e>] ? sub_preempt_count+0xe/0xd0
[21171.732991]  [<ffffffff816aebb1>] ? _raw_spin_unlock_irq+0x41/0x70
[21171.734109]  [<ffffffff8109c08c>] ? finish_task_switch+0x7c/0x120
[21171.734748]  [<ffffffff8109c04f>] ? finish_task_switch+0x3f/0x120
[21171.735648]  [<ffffffff8108ba29>] ? debug_lockdep_rcu_enabled+0x9/0x40
[21171.737086]  [<ffffffff810de7b0>] ? __module_address+0x10/0x160
[21171.737554]  [<ffffffff8108ba29>] ? debug_lockdep_rcu_enabled+0x9/0x40
[21171.738120]  [<ffffffff810de7b0>] ? __module_address+0x10/0x160
[21171.739435]  [<ffffffff816b301e>] ? sub_preempt_count+0xe/0xd0
[21171.739889]  [<ffffffff810e3123>] ? is_module_text_address+0x33/0x60
[21171.740964]  [<ffffffff8108c230>] ? __kernel_text_address+0x60/0x90
[21171.741509]  [<ffffffff8101e861>] ? print_context_stack+0x81/0x140
[21171.742293]  [<ffffffff816b301e>] ? sub_preempt_count+0xe/0xd0
[21171.743706]  [<ffffffff8101d559>] ? dump_trace+0x189/0x2f0
[21171.744207]  [<ffffffffa037d5aa>] ? free_extent_state+0x5a/0x1b0 [btrfs]
[21171.744857]  [<ffffffffa037d5aa>] ? free_extent_state+0x5a/0x1b0 [btrfs]
[21171.746371]  [<ffffffffa037d5aa>] ? free_extent_state+0x5a/0x1b0 [btrfs]
[21171.746883]  [<ffffffff811a7fcc>] ? set_track+0xac/0x1a0
[21171.747827]  [<ffffffff816b301e>] ? sub_preempt_count+0xe/0xd0
[21171.748485]  [<ffffffff810d375d>] ? trace_hardirqs_on+0xd/0x10
[21171.749276]  [<ffffffff8108ba29>] ? debug_lockdep_rcu_enabled+0x9/0x40
[21171.749859]  [<ffffffff810de7b0>] ? __module_address+0x10/0x160
[21171.750886]  [<ffffffff816b301e>] ? sub_preempt_count+0xe/0xd0
[21171.751523]  [<ffffffff8108ba29>] ? debug_lockdep_rcu_enabled+0x9/0x40
[21171.752646]  [<ffffffff816b301e>] ? sub_preempt_count+0xe/0xd0
[21171.753201]  [<ffffffff816aec5e>] ? _raw_spin_unlock_irqrestore+0x7e/0x90
[21171.754044]  [<ffffffff81198c0e>] ? dma_pool_alloc+0x22e/0x340
[21171.755396]  [<ffffffffa00c7180>] ? nouveau_fbcon_imageblit+0x90/0x110 [nouveau]
[21171.755872]  [<ffffffff8101e861>] ? print_context_stack+0x81/0x140
[21171.756904]  [<ffffffff816b301e>] ? sub_preempt_count+0xe/0xd0
[21171.757514]  [<ffffffff814ae4cc>] ? qtd_fill+0xc/0xc0
[21171.758338]  [<ffffffff814b5609>] ? qh_append_tds+0xf9/0x690
[21171.759728]  [<ffffffffa00a5e86>] ? nouveau_dma_wait+0x16/0x5b0 [nouveau]
[21171.760393]  [<ffffffff816b301e>] ? sub_preempt_count+0xe/0xd0
[21171.761031]  [<ffffffff816aec5e>] ? _raw_spin_unlock_irqrestore+0x7e/0x90
[21171.762309]  [<ffffffff816ac00f>] ? __mutex_unlock_slowpath+0x14f/0x190
[21171.762794]  [<ffffffff81050869>] ? __phys_addr+0x9/0x50
[21171.763690]  [<ffffffff81345fb8>] ? swiotlb_dma_mapping_error+0x18/0x30
[21171.764358]  [<ffffffff81499101>] ? usb_hcd_map_urb_for_dma+0x531/0x5b0
[21171.765536]  [<ffffffffa00c73d2>] ? nouveau_fbcon_fillrect+0xc2/0x110 [nouveau]
[21171.766134]  [<ffffffff8149922f>] ? usb_hcd_submit_urb+0xaf/0x860
[21171.766992]  [<ffffffff816b301e>] ? sub_preempt_count+0xe/0xd0
[21171.768393]  [<ffffffff816aec5e>] ? _raw_spin_unlock_irqrestore+0x7e/0x90
[21171.768864]  [<ffffffff814d336e>] ? usb_serial_generic_write_start+0x22e/0x270
[21171.769721]  [<ffffffff81090667>] ? kfifo_copy_in+0x77/0x90
[21171.771230]  [<ffffffff814d3664>] ? usb_serial_generic_write+0x84/0xd0
[21171.771902]  [<ffffffff814d4220>] ? usb_console_write+0x110/0x250
[21171.772388]  [<ffffffff81335fae>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[21171.773510]  [<ffffffff816af5b4>] ? retint_restore_args+0x13/0x13
[21171.774121]  [<ffffffff81066ed9>] ? vprintk+0x389/0x600
[21171.774964]  [<ffffffff810d375d>] ? trace_hardirqs_on+0xd/0x10
[21171.776294]  [<ffffffff810d375d>] ? trace_hardirqs_on+0xd/0x10
[21171.776891]  [<ffffffff810d375d>] ? trace_hardirqs_on+0xd/0x10
[21171.777601]  [<ffffffff816a1b67>] ? printk+0x51/0x53
[21171.779000]  [<ffffffff810de7b0>] ? __module_address+0x10/0x160
[21171.779666]  [<ffffffff816b301e>] ? sub_preempt_count+0xe/0xd0
[21171.780288]  [<ffffffff810e3145>] ? is_module_text_address+0x55/0x60
[21171.781622]  [<ffffffff8108c230>] ? __kernel_text_address+0x60/0x90
[21171.782202]  [<ffffffff8101e861>] ? print_context_stack+0x81/0x140
[21171.782763]  [<ffffffff8101d54f>] ? dump_trace+0x17f/0x2f0
[21171.784109]  [<ffffffff8101ea0c>] show_trace_log_lvl+0x5c/0x80
[21171.784571]  [<ffffffff8101ea45>] show_trace+0x15/0x20
[21171.785503]  [<ffffffff8106bbaf>] do_exit+0xb7f/0xb90
[21171.786201]  [<ffffffff8106bf0f>] do_group_exit+0x4f/0xc0
[21171.787277]  [<ffffffff8107eade>] get_signal_to_deliver+0x20e/0x880
[21171.787886]  [<ffffffff8107bdb0>] ? __send_signal+0x150/0x7f0
[21171.788749]  [<ffffffff811177de>] ? __rcu_read_unlock+0xe/0xa0
[21171.790075]  [<ffffffff8108b830>] ? task_tgid_nr_ns+0x20/0x20
[21171.790520]  [<ffffffff8101b315>] do_signal+0x65/0x5d0
[21171.791316]  [<ffffffff816aebb1>] ? _raw_spin_unlock_irq+0x41/0x70
[21171.792624]  [<ffffffff8107f322>] ? set_current_blocked+0x52/0x60
[21171.793206]  [<ffffffff81335fae>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[21171.793784]  [<ffffffff816aebb1>] ? _raw_spin_unlock_irq+0x41/0x70
[21171.795181]  [<ffffffff8101b905>] do_notify_resume+0x65/0x80
[21171.795614]  [<ffffffff81335fae>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[21171.796675]  [<ffffffff816b73a2>] int_signal+0x12/0x17
