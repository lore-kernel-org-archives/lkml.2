Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292Ab1ASXlx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 18:41:53 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:35933 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab1ASXlw convert rfc822-to-8bit (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 19 Jan 2011 18:41:52 -0500
Date: Wed, 19 Jan 2011 18:38:24 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: matthieu castet <castet.matthieu@free.fr>
Cc: Kees Cook <kees.cook@canonical.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        keir.fraser@eu.citrix.com, mingo@redhat.com, hpa@zytor.com,
        sliakh.lkml@gmail.com, jmorris@namei.org, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, torvalds@linux-foundation.org, ak@muc.de,
        davej@redhat.com, jiang@cs.ncsu.edu, arjan@infradead.org,
        tglx@linutronix.de, sfr@canb.auug.org.au, mingo@elte.hu,
        Stefan Bader <stefan.bader@canonical.com>
Subject: Re: [tip:x86/security] x86: Add NX protection for kernel data
Message-ID: <20110119233824.GA2869@dumpdata.com>
References: <4CE2F82E.60601@free.fr>
 <tip-5bd5a452662bc37c54fb6828db1a3faf87e6511c@git.kernel.org>
 <20110111233135.GL4979@outflux.net>
 <20110114201530.GA14339@dumpdata.com>
 <20110119211432.GA20535@dumpdata.com>
 <20110119235957.6ea35dc8@mat-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20110119235957.6ea35dc8@mat-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 11:59:57PM +0100, matthieu castet wrote:
> Le Wed, 19 Jan 2011 16:14:32 -0500,
> Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> a écrit :
> 
> > On Fri, Jan 14, 2011 at 03:15:30PM -0500, Konrad Rzeszutek Wilk wrote:
> > > On Tue, Jan 11, 2011 at 03:31:35PM -0800, Kees Cook wrote:
> > > > On Thu, Nov 18, 2010 at 02:08:22PM +0000, tip-bot for Matthieu
> > > > Castet wrote:
> > > > > Commit-ID:  5bd5a452662bc37c54fb6828db1a3faf87e6511c
> > > > > Gitweb:
> > > > > http://git.kernel.org/tip/5bd5a452662bc37c54fb6828db1a3faf87e6511c
> > > > > Author:     Matthieu Castet <castet.matthieu@free.fr>
> > > > > AuthorDate: Tue, 16 Nov 2010 22:31:26 +0100 Committer:  Ingo
> > > > > Molnar <mingo@elte.hu> CommitDate: Thu, 18 Nov 2010 12:52:04
> > > > > +0100
> > > > > 
> > > > > x86: Add NX protection for kernel data
> > > > 
> > > > [I'd sent this in reply to the wrong patch before, resending
> > > > now...]
> > > > 
> > > > Hi,
> > > > 
> > > > I was just shown this[1] on Xen from an Ubuntu bug report[2].
> > > > 
> > > > [    1.230382] NX-protecting the kernel data: 3884k
> > > > [    1.231002] BUG: unable to handle kernel paging request at
> > > > c1782ae0 ...
> > > > [    1.231145] Call Trace:
> > > > [    1.231152]  [<c0138481>] ? __change_page_attr+0x2c1/0x370
> > > > [    1.231161]  [<c02163a1>] ? __purge_vmap_area_lazy+0xc1/0x180
> > > > [    1.231169]  [<c013857c>] ?
> > > > __change_page_attr_set_clr+0x4c/0xb0 [    1.231176]
> > > > [<c0138838>] ? change_page_attr_set_clr+0x128/0x300
> > > > [    1.231183]  [<c010798e>] ?
> > > > __raw_callee_save_xen_restore_fl+0x6/0x8 [    1.231192]
> > > > [<c0159ca1>] ? vprintk+0x171/0x3f0 [    1.231198]  [<c0138bdf>] ?
> > > > set_memory_nx+0x5f/0x70
> > > 
> > > If you run it with Xen debugging enabled:
> > > 
> > > [    7.753329] NX-protecting the kernel data: 2400k
> > > (XEN) mm.c:2389:d0 Bad type (saw 3c000003 != exp 70000000) for mfn
> this happen if (x & (PGT_type_mask|PGT_pae_xen_l2)) != type)
> 
> but
> #define PGT_type_mask       (7U<<29) /* Bits 29-31. */
> #define _PGT_pae_xen_l2     26
> #define PGT_pae_xen_l2      (1U<<_PGT_pae_xen_l2)
> 
> but (exp type = 0x70000000) & (PGT_type_mask|PGT_pae_xen_l2) =
> 0x60000000
> 
> So the exp type look strange.
> #define _PGT_pinned         28
> #define PGT_pinned          (1U<<_PGT_pinned)
> 
> > > 1355a5 (pfn 15a5) (XEN) mm.c:889:d0 Error getting mfn 1355a5 (pfn
> > > 15a5) from L1 entry 80000001355a5063 for l1e_owner=0, pg_owner=0
> > > (XEN) mm.c:4958:d0 ptwr_emulate: could not get_page_from_l1e()
> > > [    7.759087] BUG: unable to handle kernel paging request at
> > > c82a4d28 [    7.759087] IP: [<c100608c>]
> > > xen_set_pte_atomic+0x21/0x2f [    7.759087] *pdpt =
> > > 0000000001663001 *pde = 00000000082db067 *pte = 80000000082a4061 ..
> > > and same stack trace.
> > > 
> > > > 
> > > > 
> > > > Does Xen have different size page table allocations or something
> > > > weird?
> > > 
> > > The same page size. Not sure actually why it is being triggered.
> > > Let me copy Keir on this. Keir, the region that is being marked as
> > > _NX is .bss one and
> > 
> > Um, it actually is from _etext -> __init_end + HPAGE_SIZE.
> > 
> > instrumenting the code a bit shows that setting of RW+NX from _etext
> > throgh __init_end works just fine. It just when you start at the PFN

It was actually the thrid PFN, and if I looked at the objdump linux -x
output it fall right on .bss and it was swapper_pg_dir..

> > _past_ the __init_end it dies. Any ideas? 
> > 
> Does this happen if you add ". = ALIGN(HPAGE_SIZE);" before bss section
> in arch/x86/kernel/vmlinux.lds.S ?

Like this?

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index b34ab80..e37d10f 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -341,7 +341,7 @@ SECTIONS
 #endif
 
 	/* BSS */
-	. = ALIGN(PAGE_SIZE);
+	. = ALIGN(HPAGE_SIZE);
 	.bss : AT(ADDR(.bss) - LOAD_OFFSET) {
 		__bss_start = .;
 		*(.bss..page_aligned)

yeeeey...That made it boot.

> 
> Does it happen if you call set_pages_rw instead of set_pages_nx in
> mark_nxdata_nx ?

Did not make a difference (tried before the aligment).
> 
> 
> What's the output of kernel_page_tables debugfs ?

Shees.. I get

[   73.723105] BUG: unable to handle kernel paging request at 15555000
[   73.724061] IP: [<c102bef3>] ptdump_show+0x143/0x214 SMP 
[   73.724061] last sysfs file: /sys/devices/pci0000:00/0000:00:18.4/class
[   73.724061] Modules linked in: xen_evtchn sg sd_mod fbcon tileblit ata_generic font bitblit softcursor ttm sata_nv drm_kms_helper video libata scsi_mod xen_blkfront xen_netfront fb_sys_fops sysimgblt sysfillrect syscopyarea xenfs [last unloaded: dump_dma]
[   73.724061] 
[   73.724061] Pid: 2843, comm: cat Tainted: G      D W   2.6.38-rc1test-00126-g9b66acf-dirty #55 N61PB-M2S/N61PB-M2S
[   73.724061] EIP: 0061:[<c102bef3>] EFLAGS: 00010206 CPU: 0
[   73.724061] EIP is at ptdump_show+0x143/0x214
[   73.724061] EAX: 15556000 EBX: 15555000 ECX: fe800000 EDX: 00000555
[   73.724061] ESI: 00000003 EDI: c16c0fa0 EBP: cd057f34 ESP: cd057ef0
[   73.724061]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0069
[   73.724061] Process cat (pid: 2843, ti=cd056000 task=cea81400 task.ti=cd056000)
[   73.724061] Stack:
[   73.724061]  fdfff000 00000000 00000555 c16c0ff8 15556000 c0000000 fe800000 caee1cc0
[   73.724061]  00000003 00000000 00000000 fe000000 fe800000 c14fa040 00000001 caee1cc0
[   73.724061]  00000001 cd057f70 c10dd83a caee1ce8 c116de08 ce6a8b40 08628000 00008000
[   73.724061] Call Trace:
[   73.724061]  [<c10dd83a>] seq_read+0x16b/0x321
[   73.724061]  [<c116de08>] ? security_file_permission+0x22/0x26
[   73.724061]  [<c10dd6cf>] ? seq_read+0x0/0x321
[   73.724061]  [<c10c858c>] vfs_read+0x7d/0xdb
[   73.724061]  [<c10c8681>] sys_read+0x3b/0x60
[   73.724061]  [<c13a4009>] syscall_call+0x7/0xb
[   73.724061] Code: 25 ff 0f 00 00 81 e2 00 f0 ff ff 52 50 eb 68 ff 15 2c 9e 4f c1 8b 4d d4 25 00 f0 ff ff 8d 98 00 00 00 c0 2d 00 f0 ff 3f 89 45 cc <8b> 13 8b 43 04 83 c3 08 6a 04 89 55 c4 89 45 c0 89 d0 8b 55 c0 
[   73.724061] EIP: [<c102bef3>] ptdump_show+0x143/0x214 SS:ESP 0069:cd057ef0
[   73.724061] CR2: 0000000015555000
[   73.724061] ---[ end trace 4eaa2a86a8e2da25 ]---

with the patch and if I revert 5bd5a452662bc37c54fb6828db1a3faf87e6511c.. 

That looks to be another bug to hunt down.
