Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742Ab1EWOsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 10:48:20 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:58557 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407Ab1EWOsT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 10:48:19 -0400
MIME-Version: 1.0
Date: Mon, 23 May 2011 16:48:14 +0200
Message-ID: <BANLkTikfqV57AtCckh99jAT2O38mM6MzTA@mail.gmail.com>
Subject: Oops (bad memory deref) in slab_alloc() due to filp_cachep holding
 incorrect values
From: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Happens under 2.6.39-rc4.

Here's probably more readable version (without lines being wrapped):
http://alt.swiecki.net/linux_kernel/sys_open-kmem_cache_alloc-2.6.39-rc4.txt

The most interesting part is probably the KGDB one. I'm still
debugging, but in case others might figure it out faster, attaching my
analysis here. The initial observation is that values in 'filp_cachep'
are incorrect.

============================================================================
KDB:
============================================================================

Stack traceback for pid 11235
0xffff88011ae91720    11235    11878  1    1   R  0xffff88011ae91ba0 *killall
<c> ffff88011ae1dd48<c> 0000000000000018<c> ffffffff8111ed78<c>
ffff88012bc4e280<c>
<c> ffff88012bffbe00<c> 0000000000000001<c> ffff88011ae1de48<c>
ffff880107947900<c>
<c> 0000000000000001<c> ffff88011ae1df28<c> ffff88010374e000<c>
ffff88011ae1dda8<c>
Call Trace:
 [<ffffffff8111ed78>] ? release_pages+0x16f/0x181
 [<ffffffff81162e5f>] ? get_empty_filp+0x6b/0x11f
 [<ffffffff8116cca7>] ? path_openat+0x33/0x345
 [<ffffffff8116cff1>] ? do_filp_open+0x38/0x86
 [<ffffffff8108a703>] ? get_parent_ip+0x11/0x41
 [<ffffffff8108a703>] ? get_parent_ip+0x11/0x41
 [<ffffffff8108a87c>] ? sub_preempt_count+0x97/0xaa
 [<ffffffff81ed24cd>] ? _raw_spin_unlock+0x2d/0x38
 [<ffffffff811781a1>] ? alloc_fd+0x10b/0x11d
 [<ffffffff8116127b>] ? do_sys_open+0x6e/0x100
 [<ffffffff8116132d>] ? sys_open+0x20/0x22
 [<ffffffff81ed3582>] ? system_call_fastpath+0x16/0x1b

---> *killall

sysname    Linux
release    2.6.39-rc4
version    #2 SMP PREEMPT Tue May 10 20:39:51 CEST 2011
machine    x86_64
nodename   ise-test
domainname (none)
ccversion  CCVERSION
date       2011-05-22 07:01:01 tz_minuteswest -120
uptime     11 days 12:13
load avg   19.87 22.44 23.24

MemTotal:         993069 kB
MemFree:          130318 kB
Buffers:           44686 kB


<1>[994415.765292] BUG: unable to handle kernel paging request at
00000000ffffffff
<1>[994415.766002] IP: [<ffffffff81150e83>] kmem_cache_alloc+0x57/0xe7
<4>[994415.766002] PGD 10a3ba067 PUD 0
<0>[994415.766002] Oops: 0000 [#1] PREEMPT SMP
<0>[994415.766002] last sysfs file:
/sys/devices/system/cpu/cpu1/cache/index2/shared_cpu_map


Entering kdb (current=0xffff88011ae91720, pid 11235) on processor 1
due to cpu switch
[1]kdb> rd
ax: 0000000000000000  bx: ffff88011ae1de48  cx: ffff88011ae1df28
dx: 0000006c68931281  si: 0000006c68931281  di: ffffffff81162e5f
bp: ffff88011ae1dd88  sp: ffff88011ae1dd48  r8: 0000000000000041
r9: ffff88012074fa50  r10: 0000000000000000  r11: 0000000000000246
r12: 00000000ffffffff  r13: ffff88012b002300  r14: 00000000000080d0
r15: ffff88010374e000  ip: ffffffff81150e83  flags: 00010206  cs: 00000010
ss: 00000018

Code: 00 48 8b 50 08 4c 8b 20 4d 85 e4 75 16 48 89 f9 83 ca ff 44 89
f6 4c 89 ef e8 b0 fa ff ff 49 89 c4 eb 20 49 63 45 20 49 8b 75 00 <49>
8b 1c 04 48 8d 4a 40 4c 89 e0 65 48 0f c7 0e 0f 94 c0 90 84
All code
========
   0:	00 48 8b             	add    %cl,-0x75(%rax)
   3:	50                   	push   %rax
   4:	08 4c 8b 20          	or     %cl,0x20(%rbx,%rcx,4)
   8:	4d 85 e4             	test   %r12,%r12
   b:	75 16                	jne    0x23
   d:	48 89 f9             	mov    %rdi,%rcx
  10:	83 ca ff             	or     $0xffffffffffffffff,%edx
  13:	44 89 f6             	mov    %r14d,%esi
  16:	4c 89 ef             	mov    %r13,%rdi
  19:	e8 b0 fa ff ff       	callq  0xffffffffffffface
  1e:	49 89 c4             	mov    %rax,%r12
  21:	eb 20                	jmp    0x43
  23:	49 63 45 20          	movslq 0x20(%r13),%rax
  27:	49 8b 75 00          	mov    0x0(%r13),%rsi
  2b:*	49 8b 1c 04          	mov    (%r12,%rax,1),%rbx     <--
trapping instruction
  2f:	48 8d 4a 40          	lea    0x40(%rdx),%rcx
  33:	4c 89 e0             	mov    %r12,%rax
  36:	65 48 0f c7 0e       	cmpxchg16b %gs:(%rsi)
  3b:	0f 94 c0             	sete   %al
  3e:	90                   	nop
  3f:	84                   	.byte 0x84

Code starting with the faulting instruction
===========================================
   0:	49 8b 1c 04          	mov    (%r12,%rax,1),%rbx
   4:	48 8d 4a 40          	lea    0x40(%rdx),%rcx
   8:	4c 89 e0             	mov    %r12,%rax
   b:	65 48 0f c7 0e       	cmpxchg16b %gs:(%rsi)
  10:	0f 94 c0             	sete   %al
  13:	90                   	nop
  14:	84                   	.byte 0x84






============================================================================
GDB:
============================================================================
(gdb) disassemble 0xffffffff81150e83
Dump of assembler code for function kmem_cache_alloc:
   0xffffffff81150e2c <+0>:	push   rbp
   0xffffffff81150e2d <+1>:	mov    rbp,rsp
   0xffffffff81150e30 <+4>:	push   r15
   0xffffffff81150e32 <+6>:	push   r14
   0xffffffff81150e34 <+8>:	push   r13
   0xffffffff81150e36 <+10>:	push   r12
   0xffffffff81150e38 <+12>:	push   rbx
   0xffffffff81150e39 <+13>:	sub    rsp,0x18
   0xffffffff81150e3d <+17>:	call   0xffffffff81ed32c0
   0xffffffff81150e42 <+22>:	mov    r13,rdi
   0xffffffff81150e45 <+25>:	mov    r14d,esi
   0xffffffff81150e48 <+28>:	mov    rdi,QWORD PTR [rbp+0x8]
   0xffffffff81150e4c <+32>:	mov    rax,QWORD PTR [r13+0x0]
   0xffffffff81150e50 <+36>:	add    rax,QWORD PTR gs:0xdd40
   0xffffffff81150e59 <+45>:	mov    rdx,QWORD PTR [rax+0x8]
   0xffffffff81150e5d <+49>:	mov    r12,QWORD PTR [rax]
   0xffffffff81150e60 <+52>:	test   r12,r12
   0xffffffff81150e63 <+55>:	jne    0xffffffff81150e7b <kmem_cache_alloc+79>
   0xffffffff81150e65 <+57>:	mov    rcx,rdi
   0xffffffff81150e68 <+60>:	or     edx,0xffffffffffffffff
   0xffffffff81150e6b <+63>:	mov    esi,r14d
   0xffffffff81150e6e <+66>:	mov    rdi,r13
   0xffffffff81150e71 <+69>:	call   0xffffffff81150926 <__slab_alloc>
   0xffffffff81150e76 <+74>:	mov    r12,rax
   0xffffffff81150e79 <+77>:	jmp    0xffffffff81150e9b <kmem_cache_alloc+111>
   0xffffffff81150e7b <+79>:	movsxd rax,DWORD PTR [r13+0x20]
   0xffffffff81150e7f <+83>:	mov    rsi,QWORD PTR [r13+0x0]
   0xffffffff81150e83 <+87>:	mov    rbx,QWORD PTR [r12+rax*1]
   0xffffffff81150e87 <+91>:	lea    rcx,[rdx+0x40]
   0xffffffff81150e8b <+95>:	mov    rax,r12
   0xffffffff81150e8e <+98>:	call   0xffffffff813d2c70
   0xffffffff81150e93 <+103>:	nop    DWORD PTR [rax+0x0]
   0xffffffff81150e97 <+107>:	test   al,al
---Type <return> to continue, or q <return> to quit---
   0xffffffff81150e99 <+109>:	je     0xffffffff81150e4c <kmem_cache_alloc+32>
   0xffffffff81150e9b <+111>:	test   r12,r12
   0xffffffff81150e9e <+114>:	je     0xffffffff81150eb4 <kmem_cache_alloc+136>
   0xffffffff81150ea0 <+116>:	test   r14d,0x8000
   0xffffffff81150ea7 <+123>:	je     0xffffffff81150eb4 <kmem_cache_alloc+136>
   0xffffffff81150ea9 <+125>:	movsxd rcx,DWORD PTR [r13+0x1c]
   0xffffffff81150ead <+129>:	xor    eax,eax
   0xffffffff81150eaf <+131>:	mov    rdi,r12
   0xffffffff81150eb2 <+134>:	rep stos BYTE PTR es:[rdi],al
   0xffffffff81150eb4 <+136>:	movsxd rax,DWORD PTR [r13+0x18]
   0xffffffff81150eb8 <+140>:	movsxd r15,DWORD PTR [r13+0x1c]
   0xffffffff81150ebc <+144>:	mov    QWORD PTR [rbp-0x38],rax
   0xffffffff81150ec0 <+148>:	mov    r13,QWORD PTR [rbp+0x8]
   0xffffffff81150ec4 <+152>:	jmp    0xffffffff81150ec9 <kmem_cache_alloc+157>
   0xffffffff81150ec9 <+157>:	jmp    0xffffffff81150f01 <kmem_cache_alloc+213>
   0xffffffff81150ecb <+159>:	call   0xffffffff8114dacf
<rcu_read_lock_sched_notrace>
   0xffffffff81150ed0 <+164>:	mov    rbx,QWORD PTR [rip+0x1abdfc9]
   # 0xffffffff82c0eea0
   0xffffffff81150ed7 <+171>:	test   rbx,rbx
   0xffffffff81150eda <+174>:	je     0xffffffff81150efc <kmem_cache_alloc+208>
   0xffffffff81150edc <+176>:	mov    rdi,QWORD PTR [rbx+0x8]
   0xffffffff81150ee0 <+180>:	mov    r9d,r14d
   0xffffffff81150ee3 <+183>:	mov    r8,QWORD PTR [rbp-0x38]
   0xffffffff81150ee7 <+187>:	mov    rcx,r15
   0xffffffff81150eea <+190>:	mov    rdx,r12
   0xffffffff81150eed <+193>:	mov    rsi,r13
   0xffffffff81150ef0 <+196>:	call   QWORD PTR [rbx]
   0xffffffff81150ef2 <+198>:	add    rbx,0x10
   0xffffffff81150ef6 <+202>:	cmp    QWORD PTR [rbx],0x0
   0xffffffff81150efa <+206>:	jmp    0xffffffff81150eda <kmem_cache_alloc+174>
   0xffffffff81150efc <+208>:	call   0xffffffff81150cb1
<rcu_read_unlock_sched_notrace>
   0xffffffff81150f01 <+213>:	add    rsp,0x18
   0xffffffff81150f05 <+217>:	mov    rax,r12
   0xffffffff81150f08 <+220>:	pop    rbx
   0xffffffff81150f09 <+221>:	pop    r12
---Type <return> to continue, or q <return> to quit---
   0xffffffff81150f0b <+223>:	pop    r13
   0xffffffff81150f0d <+225>:	pop    r14
   0xffffffff81150f0f <+227>:	pop    r15
   0xffffffff81150f11 <+229>:	leave
   0xffffffff81150f12 <+230>:	ret







============================================================================
KGDB:
============================================================================

(gdb) set remotebaud 115200
(gdb)  target remote /dev/ttyS0
Remote debugging using /dev/ttyS0
0xffffffff81150e83 in slab_alloc (s=0xffff88012b002300,
gfpflags=32976) at mm/slub.c:1943
1943			if (unlikely(!this_cpu_cmpxchg_double(
(gdb) bt
#0  0xffffffff81150e83 in slab_alloc (s=0xffff88012b002300,
gfpflags=32976) at mm/slub.c:1943
#1  kmem_cache_alloc (s=0xffff88012b002300, gfpflags=32976) at mm/slub.c:1971
#2  0xffffffff81162e5f in kmem_cache_zalloc () at include/linux/slab.h:310
#3  get_empty_filp () at fs/file_table.c:123
#4  0xffffffff8116cca7 in path_openat (dfd=<value optimized out>,
pathname=0xffff88010374e000 "/proc/1133/stat",
    nd=0xffff88011ae1de48, op=0xffff88011ae1df28, flags=<value
optimized out>) at fs/namei.c:2324
#5  0xffffffff8116cff1 in do_filp_open (dfd=-100,
pathname=0xffff88010374e000 "/proc/1133/stat",
    op=0xffff88011ae1df28, flags=1) at fs/namei.c:2380
#6  0xffffffff8116127b in do_sys_open (dfd=-100, filename=<value
optimized out>, flags=32768,
    mode=<value optimized out>) at fs/open.c:1001
#7  0xffffffff8116132d in sys_open (filename=<value optimized out>,
flags=<value optimized out>,
    mode=<value optimized out>) at fs/open.c:1022
#8  <signal handler called>
#9  0x00007f17ee73bff0 in __brk_reservation_fn_dmi_alloc__ ()
#10 0xffff880101141720 in __brk_reservation_fn_dmi_alloc__ ()
#11 0xffffffff82a1bb50 in ?? ()
#12 0x0000000200020000 in __brk_reservation_fn_dmi_alloc__ ()
#13 0x0000000300000001 in __brk_reservation_fn_dmi_alloc__ ()
#14 0x00007ffffffff000 in __brk_reservation_fn_dmi_alloc__ ()
#15 0xffffffff810a4b51 in sys_restart_syscall () at kernel/signal.c:2085
#16 0x0000000000000000 in ?? ()

(gdb) frame 0
#0  0xffffffff81150e83 in slab_alloc (s=0xffff88012b002300,
gfpflags=32976) at mm/slub.c:1943
1943			if (unlikely(!this_cpu_cmpxchg_double(
(gdb) list
1938			 * 3. If they were not changed replace tid and freelist
1939			 *
1940			 * Since this is without lock semantics the protection is only against
1941			 * code executing on this cpu *not* from access by other cpus.
1942			 */
1943			if (unlikely(!this_cpu_cmpxchg_double(
1944					s->cpu_slab->freelist, s->cpu_slab->tid,
1945					object, tid,
1946					get_freepointer(s, object), next_tid(tid)))) {
1947	

(gdb) x/i $pc
=> 0xffffffff81150e83 <kmem_cache_alloc+87>:	mov    rbx,QWORD PTR [r12+rax*1]

(gdb) info registers
rax            0x0	0
rbx            0xffff88011ae1de48	-131936649355704
rcx            0xffff88011ae1df28	-131936649355480
rdx            0x6c68931281	465610936961
rsi            0x6c68931281	465610936961
rdi            0xffffffff81162e5f	-2129252769
rbp            0xffff88011ae1dd88	0xffff88011ae1dd88
rsp            0xffff88011ae1dd48	0xffff88011ae1dd48
r8             0x41	65
r9             0xffff88012074fa50	-131936555828656
r10            0x0	0
r11            0x246	582
r12            0xffffffff	4294967295
r13            0xffff88012b002300	-131936378936576
r14            0x80d0	32976
r15            0xffff88010374e000	-131937042374656
rip            0xffffffff81150e83	0xffffffff81150e83 <kmem_cache_alloc+87>
eflags         0x10206	[ PF IF RF ]
cs             0x10	16
ss             0x18	24
ds             Could not fetch register "ds"; remote failure reply 'E22'

(gdb) p object
$36 = (void **) 0xffffffff

(gdb) p s
$1 = (struct kmem_cache *) 0xffff88012b002300
(gdb) p s->cpu_slab
$2 = (struct kmem_cache_cpu *) 0x15300

(gdb) p *s
$17 = {cpu_slab = 0x15300, flags = 0, min_partial = 7, size = 192,
objsize = 192, offset = 0, oo = {x = 21}, max = {
    x = 21}, min = {x = 21}, allocflags = 0, refcount = 13, ctor = 0,
inuse = 192, align = 8, reserved = 0,
  name = 0xffff88012b000010 "kmalloc-192", list = {next =
0xffff88012b002268, prev = 0xffff88012b002468}, kobj = {
    name = 0xffff880123c7c830 ":t-0000192", entry = {next =
0xffff88012b002280, prev = 0xffff88012b002480},
    parent = 0xffff8801249a74f8, kset = 0xffff8801249a74e0, ktype =
0xffffffff82a37790, sd = 0xffff880123ca6fa0,
    kref = {refcount = {counter = 1}}, state_initialized = 1,
state_in_sysfs = 1, state_add_uevent_sent = 1,
    state_remove_uevent_sent = 0, uevent_suppress = 0},
remote_node_defrag_ratio = 1000, node = {0xffff88012b0010c0,
    0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x15320, 0x0, 0x5, 0x800000008,
0x0, 0x200, 0x200, 0x200, 0x100000000, 0x0,
    0x800000008, 0x0, 0xffff88012b000020, 0xffff88012b002368,
0xffff88012b002568, 0xffff880123c7c800,
    0xffff88012b002380, 0xffff88012b002580, 0xffff8801249a74f8,
0xffff8801249a74e0, 0xffffffff82a37790,
    0xffff880123ca65f0, 0x700000001, 0x3e8, 0xffff88012b001100, 0x0,
0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x15340, 0x0, 0x5,
    0x1000000010, 0x0, 0x100, 0x100, 0x100, 0x500000000, 0x0,
0x800000010, 0x0, 0xffff88012b000030,
    0xffff88012b002468, 0xffff88012b002668, 0xffff880123c7c7d0,
0xffff88012b002480, 0xffff88012b002680,
    0xffff8801249a74f8, 0xffff8801249a74e0, 0xffffffff82a37790,
0xffff880123ca5c30, 0x700000001, 0x3e8}}

(gdb) p/x tid
$20 = 0x6c68931281

(gdb) up
#1  kmem_cache_alloc (s=0xffff88012b002300, gfpflags=32976) at mm/slub.c:1971
1971		void *ret = slab_alloc(s, gfpflags, NUMA_NO_NODE, _RET_IP_);
(gdb) up
#2  0xffffffff81162e5f in kmem_cache_zalloc () at include/linux/slab.h:310
310		return kmem_cache_alloc(k, flags | __GFP_ZERO);
(gdb) up
#3  get_empty_filp () at fs/file_table.c:123
123		f = kmem_cache_zalloc(filp_cachep, GFP_KERNEL);

(gdb) p filp_cachep             (/note/ filp_cachep == 's' from slab_alloc())
$37 = (struct kmem_cache *) 0xffff88012b002300
(gdb) p *filp_cachep
$38 = {cpu_slab = 0x15300, flags = 0, min_partial = 7, size = 192,
objsize = 192, offset = 0, oo = {x = 21}, max = {
    x = 21}, min = {x = 21}, allocflags = 0, refcount = 13, ctor = 0,
inuse = 192, align = 8, reserved = 0,
  name = 0xffff88012b000010 "kmalloc-192", list = {next =
0xffff88012b002268, prev = 0xffff88012b002468}, kobj = {
    name = 0xffff880123c7c830 ":t-0000192", entry = {next =
0xffff88012b002280, prev = 0xffff88012b002480},
    parent = 0xffff8801249a74f8, kset = 0xffff8801249a74e0, ktype =
0xffffffff82a37790, sd = 0xffff880123ca6fa0,
    kref = {refcount = {counter = 1}}, state_initialized = 1,
state_in_sysfs = 1, state_add_uevent_sent = 1,
    state_remove_uevent_sent = 0, uevent_suppress = 0},
remote_node_defrag_ratio = 1000, node = {0xffff88012b0010c0,
    0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x15320, 0x0, 0x5, 0x800000008,
0x0, 0x200, 0x200, 0x200, 0x100000000, 0x0,
    0x800000008, 0x0, 0xffff88012b000020, 0xffff88012b002368,
0xffff88012b002568, 0xffff880123c7c800,
    0xffff88012b002380, 0xffff88012b002580, 0xffff8801249a74f8,
0xffff8801249a74e0, 0xffffffff82a37790,
    0xffff880123ca65f0, 0x700000001, 0x3e8, 0xffff88012b001100, 0x0,
0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x15340, 0x0, 0x5,
    0x1000000010, 0x0, 0x100, 0x100, 0x100, 0x500000000, 0x0,
0x800000010, 0x0, 0xffff88012b000030,
    0xffff88012b002468, 0xffff88012b002668, 0xffff880123c7c7d0,
0xffff88012b002480, 0xffff88012b002680,
    0xffff8801249a74f8, 0xffff8801249a74e0, 0xffffffff82a37790,
0xffff880123ca5c30, 0x700000001, 0x3e8}}

(gdb) p *cred  (it's 'killall' running from uid 0)
$46 = {usage = {counter = 116}, uid = 0, gid = 0, suid = 0, sgid = 0,
euid = 0, egid = 0, fsuid = 0, fsgid = 0,
  securebits = 0, cap_inheritable = {cap = {0, 0}}, cap_permitted =
{cap = {4294967295, 4294967295}}, cap_effective = {
    cap = {4294967295, 4294967295}}, cap_bset = {cap = {4294967295,
4294967295}}, jit_keyring = 0 '\000',
  thread_keyring = 0x0, request_key_auth = 0x0, tgcred =
0xffff88011c49f040, security = 0xffff8801076cc0c0,
  user = 0xffffffff82a21b20, group_info = 0xffff88009fb61540, rcu =
{next = 0x0, func = 0}}

-- 
Robert Święcki
