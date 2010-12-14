Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932394Ab0LNWm6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 17:42:58 -0500
Received: from mail.skyhub.de ([78.46.96.112]:44605 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932153Ab0LNWm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 17:42:56 -0500
Date: Tue, 14 Dec 2010 23:42:42 +0100
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alex Deucher <alexdeucher@gmail.com>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: BUG: sleeping function called from invalid context at
 arch/x86/mm/fault.c:1081
Message-ID: <20101214224242.GA5198@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Alex Deucher <alexdeucher@gmail.com>, x86@kernel.org,
	lkml <linux-kernel@vger.kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
References: <20101214094040.GA2790@liondog.tnic>
 <AANLkTikj1bUvwAi5deZQ5M7kZN1gnsgTPETbuH4CWiHZ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikj1bUvwAi5deZQ5M7kZN1gnsgTPETbuH4CWiHZ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 12:29:52PM -0800, Linus Torvalds wrote:
> On Tue, Dec 14, 2010 at 1:40 AM, Borislav Petkov <bp@alien8.de> wrote:
> >
> > The oops below happened today with v2.6.37-rc5-62-g6313e3c with the
> > following hpet oneline fix which should be unrelated (tglx has an
> > equivalent one in -tip/urgent already):
> 
> The "sleeping function called from invalid context" part is
> uninteresting - it's just a result of the real bug, which is the oops.
> The oops gets printed out later, because the might_sleep() test just
> happens to trigger first in the page faulting path.
> 
> So ignore the early part of the dmesg, the only thing relevant is the
> kernel paging request in __lock_acquire.

Hm, that's something I wouldn't have seen from this perspective - I
would've started chasing the reason for triggering the might_sleep()
check...

> Of course, that one is then followed rather closely by a GP fault in
> the radeon driver, which I don't know is real or not. It could easily
> be some bad interaction with the kmsg_dump() thing (a result of the
> first page fault) interacting badly with the X server getting killed
> by that bogus page fault. So it's hard to tell whether the GP fault is
> real and maybe relevant for the discussion, or whether it's a result
> of the earlier oops.

I think so too, the GP is most probably a result of the PF.

> 
> > Dec 14 10:17:26 liondog kernel: [12312.144509] BUG: unable to handle kernel paging request at 00000110850fc085
> > Dec 14 10:17:26 liondog kernel: [12312.144512] IP: [<ffffffff8106d1da>] __lock_acquire+0x19d/0x173f
> > Dec 14 10:17:26 liondog kernel: [12312.144516] PGD 0
> > Dec 14 10:17:26 liondog kernel: [12312.144518] Oops: 0000 [#1] PREEMPT SMP
> > Dec 14 10:17:26 liondog kernel: [12312.144521] last sysfs file: /sys/devices/system/cpu/cpu3/cpufreq/scaling_cur_freq
> > Dec 14 10:17:26 liondog kernel: [12312.144524] CPU 1
> > Dec 14 10:17:26 liondog kernel: [12312.144526] Modules linked in: tun ip6table_filter ip6_tables iptable_filter ip_tables x_tables powernow_k8 mperf cpufreq_ondemand cpufreq_powersave cpufreq_userspace cpufreq_conservative cpufreq_stats freq_table binfmt_misc kvm_amd kvm fuse ipv6 vfat fat 8250_pnp 8250 serial_core ohci_hcd edac_core k10temp
> > Dec 14 10:17:26 liondog kernel: [12312.144548]
> > Dec 14 10:17:26 liondog kernel: [12312.144551] Pid: 1930, comm: Xorg Not tainted 2.6.37-rc5-00063-g779049f #1 M3A78 PRO/System Product Name
> > Dec 14 10:17:26 liondog kernel: [12312.144553] RIP: 0010:[<ffffffff8106d1da>]  [<ffffffff8106d1da>] __lock_acquire+0x19d/0x173f
> > Dec 14 10:17:26 liondog kernel: [12312.144557] RSP: 0000:ffff88022d1b3cb8  EFLAGS: 00013087
> > Dec 14 10:17:26 liondog kernel: [12312.144559] RAX: ffffffff819bb000 RBX: ffff88022d09da00 RCX: ffffffff821c6b40
> > Dec 14 10:17:26 liondog kernel: [12312.144561] RDX: 00000110850fc085 RSI: 0000000000000000 RDI: 8000000000000000
> > Dec 14 10:17:26 liondog kernel: [12312.144563] RBP: ffff88022d1b3d88 R08: 0000000000000002 R09: 0000000000000000
> > Dec 14 10:17:26 liondog kernel: [12312.144564] R10: ffffffff8124f16c R11: 0000000000001128 R12: ffff88022f445b90
> > Dec 14 10:17:26 liondog kernel: [12312.144566] R13: 0000000000000000 R14: 00000110850fc085 R15: 0000000000000002
> > Dec 14 10:17:26 liondog kernel: [12312.144569] FS:  00007f2fe2941700(0000) GS:ffff8800cf000000(0000) knlGS:00000000f6a4c740
> > Dec 14 10:17:26 liondog kernel: [12312.144571] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > Dec 14 10:17:26 liondog kernel: [12312.144572] CR2: 00000110850fc085 CR3: 000000022b965000 CR4: 00000000000006e0
> > Dec 14 10:17:26 liondog kernel: [12312.144574] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > Dec 14 10:17:26 liondog kernel: [12312.144576] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > Dec 14 10:17:26 liondog kernel: [12312.144578] Process Xorg (pid: 1930, threadinfo ffff88022d1b2000, task ffff88022f445b90)
> > Dec 14 10:17:26 liondog kernel: [12312.144580] Stack:
> > Dec 14 10:17:26 liondog kernel: [12312.144581]  0000000000000046 0000000000000001 ffff88022d1b3ce8 0000000081032b75
> > Dec 14 10:17:26 liondog kernel: [12312.144585]  ffff880200000001 0000000000000001 ffff88022d1b3cf8 ffffffff81069d4a
> > Dec 14 10:17:26 liondog kernel: [12312.144589]  ffff88022d1b3d18 ffff88022f445b90 ffff88022f445b90 ffffffff8144c1ea
> > Dec 14 10:17:26 liondog kernel: [12312.144593] Call Trace:
> > Dec 14 10:17:26 liondog kernel: [12312.144596]  [<ffffffff81069d4a>] ? put_lock_stats+0xe/0x29
> > Dec 14 10:17:26 liondog kernel: [12312.144599]  [<ffffffff8144c1ea>] ? __mutex_unlock_slowpath+0x105/0x129
> > Dec 14 10:17:26 liondog kernel: [12312.144602]  [<ffffffff8106b29d>] ? trace_hardirqs_on+0xd/0xf
> > Dec 14 10:17:26 liondog kernel: [12312.144605]  [<ffffffff81021e19>] ? do_page_fault+0x170/0x3a7
> > Dec 14 10:17:26 liondog kernel: [12312.144608]  [<ffffffff8106e8c9>] lock_acquire+0x14d/0x192
> > Dec 14 10:17:26 liondog kernel: [12312.144610]  [<ffffffff81021e19>] ? do_page_fault+0x170/0x3a7
> > Dec 14 10:17:26 liondog kernel: [12312.144613]  [<ffffffff8124f16c>] ? radeon_cp_idle+0x0/0xa6
> > Dec 14 10:17:26 liondog kernel: [12312.144616]  [<ffffffff8105ea37>] down_read_trylock+0x56/0x5f
> > Dec 14 10:17:26 liondog kernel: [12312.144619]  [<ffffffff81021e19>] ? do_page_fault+0x170/0x3a7
> > Dec 14 10:17:26 liondog kernel: [12312.144621]  [<ffffffff81021e19>] do_page_fault+0x170/0x3a7
> > Dec 14 10:17:26 liondog kernel: [12312.144624]  [<ffffffff810f6159>] ? do_vfs_ioctl+0x4d0/0x51f
> > Dec 14 10:17:26 liondog kernel: [12312.144627]  [<ffffffff8144f403>] ? error_sti+0x5/0x6
> > Dec 14 10:17:26 liondog kernel: [12312.144630]  [<ffffffff8144dbfb>] ? trace_hardirqs_off_thunk+0x3a/0x3c
> > Dec 14 10:17:26 liondog kernel: [12312.144632]  [<ffffffff8144f21f>] page_fault+0x1f/0x30
> > Dec 14 10:17:26 liondog kernel: [12312.144634] Code: 01 00 00 74 33 80 3d 25 1b c7 00 01 74 2a be a6 02 00 00 48 c7 c7 d1 8b 5e 81 e8 af dc fc ff c6 05 0b 1b c7 00 01 eb 10 49 89 d6 <49> 8b 16 49 39 ce 0f 18 0a 75 bc eb 09 4d 85 f6 0f 85 2e 03 00
> > Dec 14 10:17:26 liondog kernel: [12312.144671] RIP  [<ffffffff8106d1da>] __lock_acquire+0x19d/0x173f
> > Dec 14 10:17:26 liondog kernel: [12312.144674]  RSP <ffff88022d1b3cb8>
> > Dec 14 10:17:26 liondog kernel: [12312.144676] CR2: 00000110850fc085
> > Dec 14 10:17:26 liondog kernel: [12312.144678] ---[ end trace b215ad3559f4bac0 ]---
> 
> That code disassembles to
> 
> 
>    0:	74 33                	je     0x35
>    2:	80 3d 25 1b c7 00 01 	cmpb   $0x1,0xc71b25(%rip)        # 0xc71b2e
>    9:	74 2a                	je     0x35
>    b:	be a6 02 00 00       	mov    $0x2a6,%esi
>   10:	48 c7 c7 d1 8b 5e 81 	mov    $0xffffffff815e8bd1,%rdi
>   17:	e8 af dc fc ff       	callq  0xfffffffffffcdccb
>   1c:	c6 05 0b 1b c7 00 01 	movb   $0x1,0xc71b0b(%rip)        # 0xc71b2e
>   23:	eb 10                	jmp    0x35
>   25:	49 89 d6             	mov    %rdx,%r14
>   28:*	49 8b 16             	mov    (%r14),%rdx     <-- trapping instruction
>   2b:	49 39 ce             	cmp    %rcx,%r14
>   2e:	0f 18 0a             	prefetcht0 (%rdx)
>   31:	75 bc                	jne    0xffffffffffffffef
>   33:	eb 09                	jmp    0x3e
> 
> which I think matches up with this:
> 
>         movq    (%rdx), %rsi    # class_293->hash_entry.next, D.31652
>         cmpq    %rcx, %rdx      # hash_head, class
>         prefetcht0      (%rsi)  # D.31652
>         jne     .L449   #,
>         jmp     .L560   #

yes it does, __lock_acquire+0x19d = 0x4eb6, i.e.

    4ea5:       e8 00 00 00 00          callq  4eaa <__lock_acquire+0x191>
    4eaa:       c6 05 00 00 00 00 01    movb   $0x1,0x0(%rip)        # 4eb1 <__lock_acquire+0x198>
    4eb1:       eb 10                   jmp    4ec3 <__lock_acquire+0x1aa>
    4eb3:       49 89 d6                mov    %rdx,%r14
    4eb6:       49 8b 16                mov    (%r14),%rdx		<-------------------
    4eb9:       49 39 ce                cmp    %rcx,%r14
    4ebc:       0f 18 0a                prefetcht0 (%rdx)
    4ebf:       75 bc                   jne    4e7d <__lock_acquire+0x164>
    4ec1:       eb 09                   jmp    4ecc <__lock_acquire+0x1b3>


> which looks like one of the "list_for_each_entry()" uses of that
> hash_head. In fact, building lockdep.lst and matching against that
> 0x2a6 constant (it's a warn_slowpath_null thing and is the line
> number), we can pinpoint exactly which one it seems to be.

Also true:

	hash_head = classhashentry(key);
ffffffff8106d17f:	48 89 c1             	mov    %rax,%rcx
ffffffff8106d182:	48 c1 e1 3f          	shl    $0x3f,%rcx
ffffffff8106d186:	48 01 ca             	add    %rcx,%rdx
ffffffff8106d189:	48 c1 ea 34          	shr    $0x34,%rdx
ffffffff8106d18d:	48 c1 e2 04          	shl    $0x4,%rdx
ffffffff8106d191:	48 8d 8a 00 00 00 00 	lea    0x0(%rdx),%rcx
			ffffffff8106d194: R_X86_64_32S	.bss+0x5dfeb0

	/*
	 * We can walk the hash lockfree, because the hash only
	 * grows, and we are careful when adding entries to the end:
	 */
	list_for_each_entry(class, hash_head, hash_entry) {
ffffffff8106d198:	4c 8b b2 00 00 00 00 	mov    0x0(%rdx),%r14
			ffffffff8106d19b: R_X86_64_32S	.bss+0x5dfeb0
ffffffff8106d19f:	eb 39                	jmp    ffffffff8106d1da <__lock_acquire+0x19d>
		if (class->key == key) {
ffffffff8106d1a1:	49 39 46 20          	cmp    %rax,0x20(%r14)
ffffffff8106d1a5:	75 30                	jne    ffffffff8106d1d7 <__lock_acquire+0x19a>
			WARN_ON_ONCE(class->name != lock->name);
ffffffff8106d1a7:	48 8b 43 18          	mov    0x18(%rbx),%rax
ffffffff8106d1ab:	49 39 86 a0 01 00 00 	cmp    %rax,0x1a0(%r14)
ffffffff8106d1b2:	74 33                	je     ffffffff8106d1e7 <__lock_acquire+0x1aa>
ffffffff8106d1b4:	80 3d 00 00 00 00 01 	cmpb   $0x1,0x0(%rip)        # ffffffff8106d1bb <__lock_acquire+0x17e>
			ffffffff8106d1b6: R_X86_64_PC32	.bss+0x10004b
ffffffff8106d1bb:	74 2a                	je     ffffffff8106d1e7 <__lock_acquire+0x1aa>
ffffffff8106d1bd:	be a6 02 00 00       	mov    $0x2a6,%esi
ffffffff8106d1c2:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
			ffffffff8106d1c5: R_X86_64_32S	.rodata.str1.1+0x36c
ffffffff8106d1c9:	e8 00 00 00 00       	callq  ffffffff8106d1ce <__lock_acquire+0x191>
			ffffffff8106d1ca: R_X86_64_PC32	warn_slowpath_null+0xfffffffffffffffc
ffffffff8106d1ce:	c6 05 00 00 00 00 01 	movb   $0x1,0x0(%rip)        # ffffffff8106d1d5 <__lock_acquire+0x198>
			ffffffff8106d1d0: R_X86_64_PC32	.bss+0x10004b
ffffffff8106d1d5:	eb 10                	jmp    ffffffff8106d1e7 <__lock_acquire+0x1aa>

	/*
	 * We can walk the hash lockfree, because the hash only
	 * grows, and we are careful when adding entries to the end:
	 */
	list_for_each_entry(class, hash_head, hash_entry) {
ffffffff8106d1d7:	49 89 d6             	mov    %rdx,%r14
ffffffff8106d1da:	49 8b 16             	mov    (%r14),%rdx
ffffffff8106d1dd:	49 39 ce             	cmp    %rcx,%r14
ffffffff8106d1e0:	0f 18 0a             	prefetcht0 (%rdx)
ffffffff8106d1e3:	75 bc                	jne    ffffffff8106d1a1 <__lock_acquire+0x164>
ffffffff8106d1e5:	eb 09                	jmp    ffffffff8106d1f0 <__lock_acquire+0x1b3>
	struct list_head *hash_head;
	struct lock_class *class;
	unsigned long flags;


%r14 is actually %rdx and it gets computed in classhashentry(key)
and I'd guess here that some of the elements on that hash bucket
disappears/has disappeared, thus causing the GP. Also, 00000110850fc085
doesn't look like a proper virtual address to me.

> Afaik, it seems to be this code in look_up_lock_class:
> 
>         /*
>          * We can walk the hash lockfree, because the hash only
>          * grows, and we are careful when adding entries to the end:
>          */
>         list_for_each_entry(class, hash_head, hash_entry) {
>                 if (class->key == key) {
>                         WARN_ON_ONCE(class->name != lock->name);
>                         return class;
>                 }
>         }
> 
> Maybe the RCU list use in lockdep isn't entirely safe?
> 
> Added Peter and Ingo to the cc. It does look like some lockdep race.

The problem is, I don't have a recipe for re-triggering this - I'll have
to watch out for lockups...

> Or then it's some general memory corruption, of course. That just
> happened to hit the lockdep data structures. That would explain your
> subsequent radeon GP fault too.

If it is that, it would be much harder to debug. Again, I'll have to
watch out if it repeats itself. It could very well be that it never
reappears, who knows...

Thanks.

-- 
Regards/Gruss,
    Boris.
