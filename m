Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641Ab0DFW7k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 18:59:40 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39807 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757606Ab0DFW7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 18:59:32 -0400
Date: Wed, 7 Apr 2010 00:59:25 +0200
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux
 2.6.34-rc3)
Message-ID: <20100406225925.GA3446@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
	Nick Piggin <npiggin@suse.de>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
References: <alpine.LFD.2.00.1004060926430.3487@i5.linux-foundation.org>
 <1270572327.1711.3.camel@barrios-desktop>
 <alpine.LFD.2.00.1004060951030.3487@i5.linux-foundation.org>
 <4BBB69A9.5090906@redhat.com>
 <alpine.LFD.2.00.1004061053450.3487@i5.linux-foundation.org>
 <20100406120315.53ad7390.akpm@linux-foundation.org>
 <20100406194238.GB20357@a1.tnic>
 <alpine.LFD.2.00.1004061243240.3487@i5.linux-foundation.org>
 <20100406205123.GC20357@a1.tnic>
 <alpine.LFD.2.00.1004061403170.3487@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004061403170.3487@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, Apr 06, 2010 at 02:27:37PM -0700

> On Tue, 6 Apr 2010, Borislav Petkov wrote:
> > > So again, it's actually anon_vma.head.next that is NULL, not any of the 
> > > entries on the list itself.
> > > 
> > > Now, I can see several cases for this:
> > > 
> > >  - the obvious one: anon_vma just wasn't correctly initialized, and is 
> > >    missing a INIT_LIST_HEAD(&anon_vma->head). That's either a slab bug (we 
> > >    don't have a whole lot of coverage of constructors), or somebody 
> > >    allocated an anon_vma without using the anon_vma_cachep.
> > 
> > I've added code to verify this and am suspend/resuming now... Wait a
> > minute, Linus, you're good! :) :
> > 
> > [  873.083074] PM: Preallocating image memory... 
> > [  873.254359] NULL anon_vma->head.next, page 2182681
> 
> Yeah, I was pretty sure of that thing.
> 
> I still don't see _how_ it happens, though. That 'struct anon_vma' is very 
> simple, and contains literally just the lock and that list_head.
> 
> Now, 'head.next' is kind of magical, because it contains that magic 
> low-bit "have I been locked" thing (see "vm_lock_anon_vma()" in 
> mm/mmap.c). But I'm not seeing anything else touching it.
> 
> And if you allocate a anon_vma the proper way, the SLUB constructor should 
> have made sure that the head is initialized. And no normal list operation 
> ever sets any list pointer to zero, although a "list_del()" on the first 
> list entry could do it if that first list entry had a NULL next pointer. 
> 
> > Now, how do we track back to the place which is missing anon_vma->head
> > init? Can we use the struct page *page arg to page_referenced_anon()
> > somehow?
> 
> You might enable SLUB debugging (both SLUB_DEBUG _and_ SLUB_DEBUG_ON), and 
> then make the "object_err()" function in mm/slub.c be non-static. You 
> could call it when you see the problem, perhaps.
> 
> Or you could just add tests to both alloc_anon_vma() and free_anon_vma() 
> to check that 'list_empty(&anon_vma->head)' is true. I dunno.

Ok, I tried doing all you suggested and here's what came out. Please,
take this with a grain of salt because I'm almost falling asleep - even
the coffee is not working anymore so it could be just as well that I've
made a mistake somewhere (the new OOPS is a #GP, by the way), just
watch:

Source changes locally:

--
diff --git a/include/linux/slab.h b/include/linux/slab.h
index 4884462..0c11dfb 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -108,6 +108,8 @@ unsigned int kmem_cache_size(struct kmem_cache *);
 const char *kmem_cache_name(struct kmem_cache *);
 int kmem_ptr_validate(struct kmem_cache *cachep, const void *ptr);
 
+void object_err(struct kmem_cache *s, struct page *page, u8 *object, char *reason);
+
 /*
  * Please use this macro to create slab caches. Simply specify the
  * name of the structure and maybe some flags that are listed above.
diff --git a/mm/rmap.c b/mm/rmap.c
index eaa7a09..7b35b3f 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -66,11 +66,24 @@ static struct kmem_cache *anon_vma_chain_cachep;
 
 static inline struct anon_vma *anon_vma_alloc(void)
 {
-	return kmem_cache_alloc(anon_vma_cachep, GFP_KERNEL);
+	struct anon_vma *ret;
+	ret = kmem_cache_alloc(anon_vma_cachep, GFP_KERNEL);
+
+	if (!ret->head.next) {
+		printk("%s NULL anon_vma->head.next\n", __func__);
+		dump_stack();
+	}
+
+	return ret;
 }
 
 void anon_vma_free(struct anon_vma *anon_vma)
 {
+	if (!anon_vma->head.next) {
+		printk("%s NULL anon_vma->head.next\n", __func__);
+		dump_stack();
+	}
+
 	kmem_cache_free(anon_vma_cachep, anon_vma);
 }
 
@@ -494,6 +507,18 @@ static int page_referenced_anon(struct page *page,
 		return referenced;
 
 	mapcount = page_mapcount(page);
+
+	if (!anon_vma->head.next) {
+		printk(KERN_ERR "NULL anon_vma->head.next, page %lu\n",
+				page_to_pfn(page));
+
+		object_err(anon_vma_cachep, page, (u8 *)anon_vma, "NULL next");
+
+		dump_stack();
+
+		return referenced;
+	}
+
 	list_for_each_entry(avc, &anon_vma->head, same_anon_vma) {
 		struct vm_area_struct *vma = avc->vma;
 		unsigned long address = vma_address(page, vma);
diff --git a/mm/slub.c b/mm/slub.c
index b364844..bcf5416 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -477,7 +477,7 @@ static void print_trailer(struct kmem_cache *s, struct page *page, u8 *p)
 	dump_stack();
 }
 
-static void object_err(struct kmem_cache *s, struct page *page,
+void object_err(struct kmem_cache *s, struct page *page,
 			u8 *object, char *reason)
 {
 	slab_bug(s, "%s", reason);

---

do the same exercise of starting several guests and then shutting them
down, and hibernating at the same time. After having shutdown the
guests, start firefox and let it load a big html page and hibernate
while doing so, boom!

[  269.104940] Freezing user space processes ... (elapsed 0.03 seconds) done.
[  269.141953] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[  269.155115] PM: Preallocating image memory... 
[  269.423811] general protection fault: 0000 [#1] PREEMPT SMP 
[  269.424003] last sysfs file: /sys/power/state
[  269.424003] CPU 0 
[  269.424003] Modules linked in: powernow_k8 cpufreq_ondemand cpufreq_powersave cpufreq_userspace freq_table cpufreq_co
nservative binfmt_misc kvm_amd kvm ipv6 vfat fat dm_crypt dm_mod ohci_hcd pcspkr edac_core k10temp 8250_pnp 8250 serial_
core
[  269.424003] 
[  269.424003] Pid: 2617, comm: hib.sh Tainted: G        W  2.6.34-rc3-00288-gab195c5-dirty #4 M3A78 PRO/System Product 
Name
[  269.424003] RIP: 0010:[<ffffffff810c0cb4>]  [<ffffffff810c0cb4>] page_referenced+0x147/0x232
[  269.424003] RSP: 0018:ffff88022a1218b8  EFLAGS: 00010246
[  269.424003] RAX: ffff8802126fa468 RBX: ffffea000700b210 RCX: 0000000000000000
[  269.424003] RDX: ffff8802126fa429 RSI: ffff8802126fa440 RDI: ffff88022dc3cb80
[  269.424003] RBP: ffff88022a121938 R08: 0000000000000002 R09: 0000000000000000
[  269.424003] R10: 0000000000000246 R11: ffff88021a030478 R12: 0000000000000000
[  269.424003] R13: 002e2e2e002e2e0e R14: ffff8802126fa428 R15: ffff88022a121a00
[  269.424003] FS:  00007fe2799796f0(0000) GS:ffff88000a000000(0000) knlGS:0000000000000000
[  269.424003] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  269.424003] CR2: 00007fffdefb3880 CR3: 00000002171c0000 CR4: 00000000000006f0
[  269.424003] DR0: 0000000000000090 DR1: 00000000000000a4 DR2: 00000000000000ff
[  269.424003] DR3: 000000000000000f DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  269.424003] Process hib.sh (pid: 2617, threadinfo ffff88022a120000, task ffff88022dc3cb80)
[  269.424003] Stack:
[  269.424003]  ffff8802126fa468 00000000813f8cfc ffffffff8165ae28 00000000000042e7
[  269.424003] <0> ffff88022a1218f8 ffffffff810c6051 ffffea0006f968c8 ffffea0006f968c8
[  269.424003] <0> ffff88022a121938 00000002810ab275 0000000006f96890 ffffea000700b238
[  269.424003] Call Trace:
[  269.424003]  [<ffffffff810c6051>] ? swapcache_free+0x37/0x3c
[  269.424003]  [<ffffffff810ab79a>] shrink_page_list+0x14a/0x477
[  269.424003]  [<ffffffff813f8c36>] ? _raw_spin_unlock_irq+0x30/0x58
[  269.424003]  [<ffffffff810abe1e>] shrink_inactive_list+0x357/0x5e5
[  269.424003]  [<ffffffff810ac3b6>] shrink_zone+0x30a/0x3d4
[  269.424003]  [<ffffffff810acf91>] do_try_to_free_pages+0x176/0x27f
[  269.424003]  [<ffffffff810ad12f>] shrink_all_memory+0x95/0xc4
[  269.424003]  [<ffffffff810aa634>] ? isolate_pages_global+0x0/0x1f0
[  269.424003]  [<ffffffff81076e64>] ? count_data_pages+0x65/0x79
[  269.424003]  [<ffffffff810770cb>] hibernate_preallocate_memory+0x1aa/0x2cb
[  269.424003]  [<ffffffff813f5135>] ? printk+0x41/0x44
[  269.424003]  [<ffffffff81075a6b>] hibernation_snapshot+0x36/0x1e1
[  269.424003]  [<ffffffff81075ce4>] hibernate+0xce/0x172
[  269.424003]  [<ffffffff81074a51>] state_store+0x5c/0xd3
[  269.424003]  [<ffffffff81185097>] kobj_attr_store+0x17/0x19
[  269.424003]  [<ffffffff81125edb>] sysfs_write_file+0x108/0x144
[  269.424003]  [<ffffffff810d57a7>] vfs_write+0xb2/0x153
[  269.424003]  [<ffffffff81063bf1>] ? trace_hardirqs_on_caller+0x1f/0x14b
[  269.424003]  [<ffffffff810d590b>] sys_write+0x4a/0x71
[  269.424003]  [<ffffffff810021db>] system_call_fastpath+0x16/0x1b
[  269.424003] Code: 3b 56 10 73 1e 48 83 fa f2 74 18 48 8d 4d cc 4d 89 f8 48 89 df e8 1e f2 ff ff 41 01 c4 83 7d cc 00 
74 19 4d 8b 6d 20 49 83 ed 20 <49> 8b 45 20 0f 18 08 49 8d 45 20 48 39 45 80 75 aa 4c 89 f7 e8 
[  269.424003] RIP  [<ffffffff810c0cb4>] page_referenced+0x147/0x232
[  269.424003]  RSP <ffff88022a1218b8>
[  269.438405] ---[ end trace ad5b4172ee94398e ]---
[  269.438553] note: hib.sh[2617] exited with preempt_count 2
[  269.438709] BUG: scheduling while atomic: hib.sh/2617/0x10000003
[  269.438858] INFO: lockdep is turned off.
[  269.439075] Modules linked in: powernow_k8 cpufreq_ondemand cpufreq_powersave cpufreq_userspace freq_table cpufreq_co
nservative binfmt_misc kvm_amd kvm ipv6 vfat fat dm_crypt dm_mod ohci_hcd pcspkr edac_core k10temp 8250_pnp 8250 serial_core
[  269.440875] Pid: 2617, comm: hib.sh Tainted: G      D W  2.6.34-rc3-00288-gab195c5-dirty #4
[  269.441137] Call Trace:
[  269.441288]  [<ffffffff81063107>] ? __debug_show_held_locks+0x1b/0x24
[  269.441440]  [<ffffffff8102d3c0>] __schedule_bug+0x72/0x77
[  269.441590]  [<ffffffff813f553e>] schedule+0xd9/0x730
[  269.441741]  [<ffffffff8103022c>] __cond_resched+0x18/0x24
[  269.441891]  [<ffffffff813f5c62>] _cond_resched+0x2c/0x37
[  269.442045]  [<ffffffff810b7d7d>] unmap_vmas+0x6ce/0x893
[  269.442205]  [<ffffffff810bc42f>] exit_mmap+0xd7/0x182
[  269.442352]  [<ffffffff81035951>] mmput+0x48/0xb9
[  269.442502]  [<ffffffff81039c21>] exit_mm+0x110/0x11d
[  269.442652]  [<ffffffff8103b663>] do_exit+0x1c5/0x691
[  269.442802]  [<ffffffff81038d0d>] ? kmsg_dump+0x13b/0x155
[  269.442953]  [<ffffffff810060db>] ? oops_end+0x47/0x93
[  269.443107]  [<ffffffff81006122>] oops_end+0x8e/0x93
[  269.443262]  [<ffffffff81006313>] die+0x5a/0x63
[  269.443414]  [<ffffffff81003eaf>] do_general_protection+0x134/0x13c
[  269.443566]  [<ffffffff813f90f0>] ? irq_return+0x0/0x2
[  269.443716]  [<ffffffff813f92cf>] general_protection+0x1f/0x30
[  269.443867]  [<ffffffff810c0cb4>] ? page_referenced+0x147/0x232
[  269.444021]  [<ffffffff810c0bf0>] ? page_referenced+0x83/0x232
[  269.444176]  [<ffffffff810c6051>] ? swapcache_free+0x37/0x3c
[  269.444328]  [<ffffffff810ab79a>] shrink_page_list+0x14a/0x477
[  269.444479]  [<ffffffff813f8c36>] ? _raw_spin_unlock_irq+0x30/0x58
[  269.444630]  [<ffffffff810abe1e>] shrink_inactive_list+0x357/0x5e5
[  269.444782]  [<ffffffff810ac3b6>] shrink_zone+0x30a/0x3d4
[  269.444933]  [<ffffffff810acf91>] do_try_to_free_pages+0x176/0x27f
[  269.445087]  [<ffffffff810ad12f>] shrink_all_memory+0x95/0xc4
[  269.445243]  [<ffffffff810aa634>] ? isolate_pages_global+0x0/0x1f0
[  269.445396]  [<ffffffff81076e64>] ? count_data_pages+0x65/0x79
[  269.445547]  [<ffffffff810770cb>] hibernate_preallocate_memory+0x1aa/0x2cb
[  269.445698]  [<ffffffff813f5135>] ? printk+0x41/0x44
[  269.445848]  [<ffffffff81075a6b>] hibernation_snapshot+0x36/0x1e1
[  269.445999]  [<ffffffff81075ce4>] hibernate+0xce/0x172
[  269.446160]  [<ffffffff81074a51>] state_store+0x5c/0xd3
[  269.446307]  [<ffffffff81185097>] kobj_attr_store+0x17/0x19
[  269.446457]  [<ffffffff81125edb>] sysfs_write_file+0x108/0x144
[  269.446607]  [<ffffffff810d57a7>] vfs_write+0xb2/0x153
[  269.446757]  [<ffffffff81063bf1>] ? trace_hardirqs_on_caller+0x1f/0x14b
[  269.446908]  [<ffffffff810d590b>] sys_write+0x4a/0x71
[  269.447063]  [<ffffffff810021db>] system_call_fastpath+0x16/0x1b


This time we have

[  269.424003] RIP: 0010:[<ffffffff810c0cb4>]  [<ffffffff810c0cb4>] page_referenced+0x147/0x232 

which is offset 0x1104.

which is

    10eb:       48 89 df                mov    %rbx,%rdi
    10ee:       e8 00 00 00 00          callq  10f3 <page_referenced+0x136>
    10f3:       41 01 c4                add    %eax,%r12d
    10f6:       83 7d cc 00             cmpl   $0x0,-0x34(%rbp)
    10fa:       74 19                   je     1115 <page_referenced+0x158>
    10fc:       4d 8b 6d 20             mov    0x20(%r13),%r13
    1100:       49 83 ed 20             sub    $0x20,%r13
    1104:       49 8b 45 20             mov    0x20(%r13),%rax			<-------------------------
    1108:       0f 18 08                prefetcht0 (%rax)
    110b:       49 8d 45 20             lea    0x20(%r13),%rax
    110f:       48 39 45 80             cmp    %rax,-0x80(%rbp)
    1113:       75 aa                   jne    10bf <page_referenced+0x102>
    1115:       4c 89 f7                mov    %r14,%rdi

and asm is

	.loc 1 522 0
	movq	32(%r13), %r13	# <variable>.same_anon_vma.next, __mptr.454
.LVL295:
	subq	$32, %r13	#, avc
.LVL296:
.L186:
.LBE1224:
	movq	32(%r13), %rax	# <variable>.same_anon_vma.next, <variable>.same_anon_vma.next		<--------------
	prefetcht0	(%rax)	# <variable>.same_anon_vma.next
	leaq	32(%r13), %rax	#, tmp104
	cmpq	%rax, -128(%rbp)	# tmp104, %sfp
	jne	.L189	#,
.L188:
	.loc 1 540 0
	movq	%r14, %rdi	# anon_vma,
	call	page_unlock_anon_vma	#

and %r13 contains some funny stuff, could be some mangled SLUB debug
poison or something: R13: 002e2e2e002e2e0e. Maybe this is the reason for
the #GP.

But yes, even if the oopsing instruction is

movq	32(%r13), %rax	# <variable>.same_anon_vma.next, <variable>.same_anon_vma.next

this is not same_anon_vma.next because we've come to the above
instruction through the ".L186:" label, before which we have %r13
already loaded with anon_vma->head.next.

To be continued...

-- 
Regards/Gruss,
    Boris.
