Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249Ab2DQNIt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 09:08:49 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:36747 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756060Ab2DQNIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 09:08:48 -0400
Date: Tue, 17 Apr 2012 09:03:40 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] xen: enter/exit lazy_mmu_mode around m2p_override
 calls
Message-ID: <20120417130340.GA25593@phenom.dumpdata.com>
References: <1334075375-25442-1-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334075375-25442-1-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090201.4F8D6B5A.00A8,ss=1,re=-2.300,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 05:29:34PM +0100, Stefano Stabellini wrote:
> This patch is a significant performance improvement for the
> m2p_override: about 6% using the gntdev device.
> 
> Each m2p_add/remove_override call issues a MULTI_grant_table_op and a
> __flush_tlb_single if kmap_op != NULL.  Batching all the calls together
> is a great performance benefit because it means issuing one hypercall
> total rather than two hypercall per page.
> If paravirt_lazy_mode is set PARAVIRT_LAZY_MMU, all these calls are
> going to be batched together, otherwise they are issued one at a time.
> 
> Adding arch_enter_lazy_mmu_mode/arch_leave_lazy_mmu_mode around the
> m2p_add/remove_override calls forces paravirt_lazy_mode to
> PARAVIRT_LAZY_MMU, therefore makes sure that they are always batched.
> 
> 
> Changes in v3:
> - do not call arch_enter/leave_lazy_mmu_mode in xen_blkbk_unmap, that
> can be called in interrupt context.

This is with RHEL5 (somehow the pvops kernels don't trigger this):

[  311.247884] xen-blkback:ring-ref 8, event-channel 11, protocol 1 (x86_64-abi)
[  313.200497] ------------[ cut here ]------------
[  313.205166] kernel BUG at /home/konrad/linux/arch/x86/kernel/paravirt.cahci libahci font bitblit ttm libata softcursor scsi_mod drm_kms_helper wmi xen_blkfront xen_netfront fb_sys_fops sysimgblt sysfillrect syscopyarea xenfs xen_privcmd [last unloaded: dump_dma]
[  313.256453]
[  313.258064] Pid: 3370, comm: run_guests Tainted: G           O 3.4.0-rc3upstream-10947-g331a503 #1 System manufacturer System Product Name/F1A75-M
[  313.271667] RIP: e030:[<ffffffff8105f86e>]  [<ffffffff8105f86e>] paravirt_enter_lazy_mmu+0x1e/0x30
[  313.280977] RSP: e02b:ffff8802014549e0  EFLAGS: 00010202
[  313.286544] RAX: 0000000000000001 RBX: ffff880201454b50 RCX: 0000000000000000
[  313.293971] RDX: 0000000000000001 RSI: ffff880201454a40 RDI: 0000000000000001
[  313.301400] RBP: ffff8802014549e0 R08: ffff880000000000 R09: 0000000000000000
[  313.308829] R10: 0000000000000000 R11: 0000000000000028 R12: 0000000000000001
[  313.316257] R13: 0000000000000000 R14: 0000000000000030 R15: aaaaaaaaaaaaaaab
[  313.323691] FS:  00007fb6cc941700(0000) GS:ffff880201451000(0000) knlGS:0000000000000000
[  313.332101] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
[  313.338099] CR2: 0000000001d2a1a8 CR3: 00000001e660e000 CR4: 0000000000000660
[  313.345527] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  313.352955] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  313.360384] Process run_guests (pid: 3370, threadinfo ffff8801ecece000, task ffff8801f4e91080)
[  313.369334] Stack:
[  313.371482]  ffff880201454a10 ffffffff81310048 0000000000000001 0000000000000001
[  313.379181]  ffff8801e48c74b0 0000000000000030 ffff880201454be0 ffffffff8138d677
[  313.386877]  00000000000004b0 0000160000000000 0000000000000000 ffff880201454a40
[  313.394576] Call Trace:
[  313.397172]  <IRQ>
[  313.399411]  [<ffffffff81310048>] gnttab_unmap_refs+0x38/0x90
[  313.405410]  [<ffffffff8138d677>] xen_blkbk_unmap+0x1f7/0x220
[  313.411406]  [<ffffffff814b165b>] ? tcp_cleanup_rbuf+0x6b/0x100
[  313.417579]  [<ffffffff814b3bfb>] ? tcp_read_sock+0x1bb/0x220
[  313.423578]  [<ffffffffa030fec0>] ? iscsi_sw_tcp_state_change+0xd0/0xd0 [iscsi_tcp]
[  313.431543]  [<ffffffffa03102f3>] ? iscsi_sw_tcp_data_ready+0x73/0xe8 [iscsi_tcp]
[  313.439330]  [<ffffffff814b7ea8>] ? __tcp_ack_snd_check+0x68/0x90
[  313.445686]  [<ffffffff81032fed>] ? xen_force_evtchn_callback+0xd/0x10
[  313.439330]  [<ffffffff814b7ea8>] ? __tcp_ack_snd_check+0x68/0x90
[  313.445686]  [<ffffffff81032fed>] ? xen_force_evtchn_callback+0xd/0x10
[  313.452488]  [<ffffffff81033852>] ? check_events+0x12/0x20
[  313.458216]  [<ffffffff8103383f>] ? xen_restore_fl_direct_reloc+0x4/0x4
[  313.465110]  [<ffffffff8113d7f5>] ? kmem_cache_free+0xc5/0x2a0
[  313.471194]  [<ffffffff8138d6e8>] __end_block_io_op+0x48/0x110
[  313.477283]  [<ffffffff8138d7c5>] end_block_io_op+0x15/0x30
[  313.483099]  [<ffffffff81175dc8>] bio_endio+0x18/0x30
[  313.488381]  [<ffffffffa0316239>] dec_pending+0x189/0x290 [dm_mod]
[  313.494824]  [<ffffffffa0316569>] clone_endio+0x99/0xd0 [dm_mod]
[  313.501089]  [<ffffffff81175dc8>] bio_endio+0x18/0x30
[  313.506373]  [<ffffffff81269cf3>] req_bio_endio+0x83/0xc0
[  313.512009]  [<ffffffff8126b217>] blk_update_request+0xe7/0x450
[  313.518186]  [<ffffffff8131d9d1>] ? xen_virt_to_bus+0x11/0x20
[  313.524181]  [<ffffffff8126b5a2>] blk_update_bidi_request+0x22/0xa0
[  313.530715]  [<ffffffff8126b64a>] blk_end_bidi_request+0x2a/0x80
[  313.536981]  [<ffffffff8126b6db>] blk_end_request+0xb/0x10
[  313.542712]  [<ffffffffa005a96a>] scsi_io_completion+0xaa/0x630 [scsi_mod]
[  313.549870]  [<ffffffff815a7c69>] ? _raw_spin_unlock_irqrestore+0x19/0x30
[  313.556942]  [<ffffffffa005290f>] scsi_finish_command+0xcf/0x130 [scsi_mod]
[  313.564193]  [<ffffffffa005b03f>] scsi_softirq_done+0x13f/0x160 [scsi_mod]
[  313.571352]  [<ffffffff8127168d>] blk_done_softirq+0x7d/0x90
[  313.577260]  [<ffffffff810773a9>] __do_softirq+0xa9/0x160
[  313.582899]  [<ffffffff815afc9c>] call_softirq+0x1c/0x30
[  313.588446]  [<ffffffff81039405>] do_softirq+0x65/0xa0
[  313.593819]  [<ffffffff810771a5>] irq_exit+0xd5/0xf0
[  313.599010]  [<ffffffff8131207f>] xen_evtchn_do_upcall+0x2f/0x40
[  313.605273]  [<ffffffff815afcee>] xen_do_hypervisor_callback+0x1e/0x30
[  313.612076]  <EOI>
[  313.614313]  [<ffffffff8111d19e>] ? copy_pte_range+0x36e/0x5f0
[  313.620401]  [<ffffffff8111d6a8>] ? copy_page_range+0x288/0x490
[  313.626576]  [<ffffffff8106e643>] ? dup_mm+0x2d3/0x4a0
[  313.631946]  [<ffffffff8106f710>] ? copy_process+0xf00/0x13e0
[  313.637944]  [<ffffffff8106fe79>] ? do_fork+0x59/0x300
[  313.643314]  [<ffffffff8107e74b>] ? do_sigaction+0x13b/0x1e0
[  313.649221]  [<ffffffff8107f252>] ? __set_task_blocked+0x32/0x80
[  313.655486]  [<ffffffff8107f2f7>] ? set_current_blocked+0x57/0x80
[  313.661842]  [<ffffffff8103fd33>] ? sys_clone+0x23/0x30
[  313.667302]  [<ffffffff815aebc3>] ? stub_clone+0x13/0x20
[  313.672851]  [<ffffffff815ae8b9>] ? system_call_fastpath+0x16/0x1b
[  313.679294] Code: 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 65 8b 04 25 00 e0 00 00 85 c0 48 89 e5 75 0e 65 c7 04 25 00 e0 00 00 01 00 00 00 c9 c3 <0f> 0b eb fe 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 65 48
[  313.698805] RIP  [<ffffffff8105f86e>] paravirt_enter_lazy_mmu+0x1e/0x30
[  313.705698]  RSP <ffff8802014549e0>
[  313.709370] ---[ end trace 6d0134ded298d0e6 ]---
[  313.714201] Kernel panic - not syncing: Fatal exception in interrupt
(XEN) Domain 0 crashed: rebooting machine in 5 seconds.

> 
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  drivers/block/xen-blkback/blkback.c |    2 ++
>  drivers/xen/grant-table.c           |    8 ++++++++
>  2 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
> index 0088bf6..0453695 100644
> --- a/drivers/block/xen-blkback/blkback.c
> +++ b/drivers/block/xen-blkback/blkback.c
> @@ -386,6 +386,7 @@ static int xen_blkbk_map(struct blkif_request *req,
>  	 * so that when we access vaddr(pending_req,i) it has the contents of
>  	 * the page from the other domain.
>  	 */
> +	arch_enter_lazy_mmu_mode();
>  	for (i = 0; i < nseg; i++) {
>  		if (unlikely(map[i].status != 0)) {
>  			pr_debug(DRV_PFX "invalid buffer -- could not remap it\n");
> @@ -410,6 +411,7 @@ static int xen_blkbk_map(struct blkif_request *req,
>  		seg[i].buf  = map[i].dev_bus_addr |
>  			(req->u.rw.seg[i].first_sect << 9);
>  	}
> +	arch_leave_lazy_mmu_mode();
>  	return ret;
>  }
>  
> diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
> index b4d4eac..c7dc2d6 100644
> --- a/drivers/xen/grant-table.c
> +++ b/drivers/xen/grant-table.c
> @@ -751,6 +751,8 @@ int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
>  	if (xen_feature(XENFEAT_auto_translated_physmap))
>  		return ret;
>  
> +	arch_enter_lazy_mmu_mode();
> +
>  	for (i = 0; i < count; i++) {
>  		/* Do not add to override if the map failed. */
>  		if (map_ops[i].status)
> @@ -769,6 +771,8 @@ int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
>  			return ret;
>  	}
>  
> +	arch_leave_lazy_mmu_mode();
> +
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(gnttab_map_refs);
> @@ -785,12 +789,16 @@ int gnttab_unmap_refs(struct gnttab_unmap_grant_ref *unmap_ops,
>  	if (xen_feature(XENFEAT_auto_translated_physmap))
>  		return ret;
>  
> +	arch_enter_lazy_mmu_mode();
> +
>  	for (i = 0; i < count; i++) {
>  		ret = m2p_remove_override(pages[i], clear_pte);
>  		if (ret)
>  			return ret;
>  	}
>  
> +	arch_leave_lazy_mmu_mode();
> +
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(gnttab_unmap_refs);
> -- 
> 1.7.2.5
