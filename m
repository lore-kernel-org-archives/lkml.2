Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791Ab1EWS2x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 14:28:53 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:46816 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215Ab1EWS2v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 14:28:51 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1105231133580.29047@router.home>
References: <BANLkTikfqV57AtCckh99jAT2O38mM6MzTA@mail.gmail.com>
	<BANLkTikey3L4doiHY=__=690TZNsXqRHUQ@mail.gmail.com>
	<alpine.DEB.2.00.1105231133580.29047@router.home>
Date: Mon, 23 May 2011 20:28:50 +0200
Message-ID: <BANLkTi=-xRRxi4CtxMLt0VgTJWSdiVQugw@mail.gmail.com>
Subject: Re: Fwd: Oops (bad memory deref) in slab_alloc() due to filp_cachep
 holding incorrect values
From: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>
To: linux-kernel@vger.kernel.org
Cc: Christoph Lameter <cl@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 6:35 PM, Christoph Lameter <cl@linux.com> wrote:
> On Mon, 23 May 2011, Robert Święcki wrote:
>
>> Hi, not sure if it's related to SLUB, in any case forwarding.
>
> Please reboot with the kernel parameter slub_debug or enable
> CONFIG_SLUB_DEBUG_ON. The kernel will then verify all operations of the
> users of the allocator and log important issues to the syslog. This is
> likely some memory corruption.

So, I ran it with CONFIG_SLUB_DEBUG_ON and got Oops in just under a
second - the important thing is that probably that instead of
2.6.39-rc4 I ran 2.6.39

It was

<1>[   77.662935] BUG: unable to handle kernel NULL pointer
dereference at 0000000000000408
<1>[   77.663002] IP: [<ffffffff8134cbdf>] cap_capable+0x18/0x67
<4>[   77.663002] PGD 120428067 PUD 120e35067 PMD 0
<0>[   77.663002] Oops: 0000 [#1] PREEMPT SMP
<0>[   77.680925] last sysfs file:
/sys/devices/system/cpu/cpu1/cache/index2/shared_cpu_map

and kdb's backtrace shows:

[1]kdb> bt
Stack traceback for pid 8419
0xffff880120e3aee0     8419     8418  1    1   R  0xffff880120e3b360 *iknowthis2
<c> ffff88011f57deb8<c> 0000000000000000<c> ffff88011f5731a0<c>
ffff88011f57def8<c>
<c> ffffffff81378bfb<c> ffff88011f57ded8<c> ffff880120e3aee0<c>
0000000000000604<c>
<c> ffff88011f540500<c> 0000000000000000<c> 0000000000000000<c>
ffff88011f57df08<c>
Call Trace:
 [<ffffffff81378bfb>] ? apparmor_capable+0x27/0x61
 [<ffffffff8134d932>] ? security_capable+0x2a/0x2c
 [<ffffffff8109d99d>] ? ns_capable+0x3a/0x4f
 [<ffffffff8109da2b>] ? nsown_capable+0x24/0x29
 [<ffffffff810a6695>] ? sys_setgid+0x43/0x8d
 [<ffffffff810c1e11>] ? sys_setgid16+0x1c/0x1e
 [<ffffffff81ed6183>] ? ia32_do_call+0x13/0x13

and kgdb shows

(gdb) target remote /dev/ttyS0
Remote debugging using /dev/ttyS0
0xffffffff8134cbdf in cap_capable (tsk=<value optimized out>,
cred=0x0, targ_ns=0x0, cap=6, audit=1) at security/commoncap.c:88
88			if (targ_ns != &init_user_ns && targ_ns->creator == cred->user)

(gdb) p cred
$1 = (const struct cred *) 0x0

(gdb) bt
#0  0xffffffff8134cbdf in cap_capable (tsk=<value optimized out>,
cred=0x0, targ_ns=0x0, cap=6, audit=1) at security/commoncap.c:88
#1  0xffffffff81378bfb in apparmor_capable (task=0xffff880120e3aee0,
cred=0xffff88011f540500, ns=<value optimized out>, cap=6, audit=1) at
security/apparmor/lsm.c:144
#2  0xffffffff8134d932 in security_capable (ns=<value optimized out>,
cred=<value optimized out>, cap=<value optimized out>) at
security/security.c:160
#3  0xffffffff8109d99d in ns_capable (ns=<value optimized out>,
cap=<value optimized out>) at kernel/capability.c:381
#4  0xffffffff8109da2b in nsown_capable (cap=<value optimized out>) at
kernel/capability.c:412
#5  0xffffffff810a6695 in sys_setgid (gid=1540) at kernel/sys.c:570
#6  0xffffffff810c1e11 in sys_setgid16 (gid=<value optimized out>) at
kernel/uid16.c:53
#7  <signal handler called>
#8  0x0000000008065952 in __brk_reservation_fn_dmi_alloc__ ()

I looked through  apparmor_capable and cap_capable and there's nothing
that could change value of 'cred' from 0xffff880120e3aee0 to 0 between
apparmor_capable() and cap_capable()  (i.e. no buffer-overflow causing
functions, in fact no functions or no interesting operations at all).

Out of curiosity I looked at what runs on the other CPU, and it was:

[0]kdb> bt
Stack traceback for pid 23087
0xffff880120df8000    23087    16945  1    0   R  0xffff880120df8480 *iknowthis
<c> ffff880120d61c58<c> 0000000000000018<c>
Call Trace:
 <NMI>  <<EOE>>  [<ffffffff814feb2d>] ? extract_buf+0x5e/0x105
 [<ffffffff81ed3f85>] ? retint_restore_args+0x13/0x13
 [<ffffffff814fee11>] ? extract_entropy_user+0xb5/0x124
 [<ffffffff814fee95>] ? urandom_read+0x15/0x17
 [<ffffffff8116200b>] ? vfs_read+0xa9/0xfc
 [<ffffffff811633f5>] ? fget_light+0x42/0xa2
 [<ffffffff811622a6>] ? sys_read+0x4a/0x6e
 [<ffffffff81ed4902>] ? system_call_fastpath+0x16/0x1b

It's very strange, cause in the first case (the problem with SLUB),
the second CPU was also stuck in this routine, and I'm kinda certain
it is the real cause of the problem (it overwrites another CPU's
stack?). My config is here:
http://alt.swiecki.net/linux_kernel/ise-test-2.6.39-kernel-config.txt
- so the question is; could somebody more familiar with kernel
internals look into /dev/urandom sys_read routines. I think they don't
play nicely with SMP PREEMPT kernel (or maybe it just runs out of
kernel stack in there and overwrites another one). Some more data
about the second thread:

(gdb) thread 1
[Switching to thread 1 (Thread 23087)]#0  sha_transform
(digest=0xffff880120d61de8,
    in=0xffff880120d61ca8
"\372\223;4<;\030L\351\331_\345lI\206\362\202\364\373J\277\337\231ӌ!_(\206^\267\366\311\306\061R\001\v\b\322\312ګ\301\334:V\314p\226\253@\332m\206\271\025\361-\255f\027\340",
<incomplete sequence \364>, W=0xffff880120d61ca8) at lib/sha1.c:47
47			W[i+16] = rol32(W[i+13] ^ W[i+8] ^ W[i+2] ^ W[i], 1);

(gdb) bt
#0  sha_transform (digest=0xffff880120d61de8, in=0xffff880120d61ca8
"\372\223;4<;\030L\351\331_\345lI\206\362\202\364\373J\277\337\231ӌ!_(\206^\267\366\311\306\061R\001\v\b\322\312ګ\301\334:V\314p\226\253@\332m\206\271\025\361-\255f\027\340",
<incomplete sequence \364>,
    W=0xffff880120d61ca8) at lib/sha1.c:47
#1  0xffffffff814feb2d in extract_buf (r=0xffffffff82a88670,
out=0xffff880120d61e98 "\320S\032|\201\f7\215\333$") at
drivers/char/random.c:825
#2  0xffffffff814fee11 in extract_entropy_user (r=0xffffffff82a88670,
buf=0x7fec871ced98, nbytes=616) at drivers/char/random.c:910
#3  0xffffffff814fee95 in urandom_read (file=<value optimized out>,
buf=<value optimized out>, nbytes=<value optimized out>, ppos=<value
optimized out>) at drivers/char/random.c:1063
#4  0xffffffff8116200b in vfs_read (file=0xffff880121f13900,
    buf=0x7fec871ce000 ",\027\372\061\213L\224
\263\371\alx\304k\312O#\362\233\022\027\217\216\016\316
\212\022A`\213\264\246z$0=\313L<\253\221\367\264\246VF\350\336[a\372\v\367'\233\375\350\356\350\366\016\243wS\255fʦ\217\r\346k\354\235\335\031\333\335\030\246\061\332\312\020v\333\376\b\177-R]P\277\367\067M\230\324\235\026\264}\273Ƣ\264g\236\025\373\371\021a7tm\"f\313>I\003\346\214\006\255\"A\035\070\256\216\270t\002i\327\275\327G\031\227\017\337*\230H\376\256\a\376\t1XY\355*?{a\201s\272\023\060n\246\267\374\241/\205\037\330X\273\a[\300\220_\004#e\252B\326\370Kt(\306.D.\314\027"...,
count=<value optimized out>, pos=0xffff880120d61f58) at
fs/read_write.c:321
#5  0xffffffff811622a6 in sys_read (fd=<value optimized out>,
    buf=0x7fec871ce000 ",\027\372\061\213L\224
\263\371\alx\304k\312O#\362\233\022\027\217\216\016\316
\212\022A`\213\264\246z$0=\313L<\253\221\367\264\246VF\350\336[a\372\v\367'\233\375\350\356\350\366\016\243wS\255fʦ\217\r\346k\354\235\335\031\333\335\030\246\061\332\312\020v\333\376\b\177-R]P\277\367\067M\230\324\235\026\264}\273Ƣ\264g\236\025\373\371\021a7tm\"f\313>I\003\346\214\006\255\"A\035\070\256\216\270t\002i\327\275\327G\031\227\017\337*\230H\376\256\a\376\t1XY\355*?{a\201s\272\023\060n\246\267\374\241/\205\037\330X\273\a[\300\220_\004#e\252B\326\370Kt(\306.D.\314\027"...,
count=<value optimized out>) at fs/read_write.c:411
#6  <signal handler called>
#7  0x00007fec865e4340 in __brk_reservation_fn_dmi_alloc__ ()
#8  0xffff880120dc1770 in __brk_reservation_fn_dmi_alloc__ ()
#9  0xffffffff82a1bb50 in ?? ()
#10 0x0000000200020000 in __brk_reservation_fn_dmi_alloc__ ()
#11 0x0000000300000001 in __brk_reservation_fn_dmi_alloc__ ()
#12 0x00007ffffffff000 in __brk_reservation_fn_dmi_alloc__ ()
#13 0xffffffff810a4c3d in sys_restart_syscall () at kernel/signal.c:2085
#14 0x0000000000000000 in ?? ()

(gdb) info registers
rax            0xf21ac03a	4061839418
rbx            0xffff880120d61de8	-131936549462552
rcx            0x80	128
rdx            0xffff880120d61ca8	-131936549462872
rsi            0xffff880120d61ca8	-131936549462872
rdi            0xffff880120d61de8	-131936549462552
rbp            0xffff880120d61c98	0xffff880120d61c98
rsp            0xffff880120d61c58	0xffff880120d61c58
r8             0xbcc035f2	3166713330
r9             0x50	80
r10            0xffff880120d61cfc	-131936549462788
r11            0x47013d0b	1191263499
r12            0x10	16
r13            0xffffffff82a88670	-2102884752
r14            0xffff880120d61e98	-131936549462376
r15            0xa	10
rip            0xffffffff813d0297	0xffffffff813d0297 <sha_transform+39>
eflags         0x283	[ CF SF IF ]
cs             0x10	16
ss             0x18	24
ds             Could not fetch register "ds"; remote failure reply 'E22'

(gdb) disassemble $pc
Dump of assembler code for function sha_transform:
   0xffffffff813d0270 <+0>:	push   rbp
   0xffffffff813d0271 <+1>:	xor    eax,eax
   0xffffffff813d0273 <+3>:	mov    rbp,rsp
   0xffffffff813d0276 <+6>:	push   r15
   0xffffffff813d0278 <+8>:	push   r14
   0xffffffff813d027a <+10>:	push   r13
   0xffffffff813d027c <+12>:	push   r12
   0xffffffff813d027e <+14>:	push   rbx
   0xffffffff813d027f <+15>:	sub    rsp,0x18
   0xffffffff813d0283 <+19>:	mov    ecx,DWORD PTR [rsi+rax*1]
   0xffffffff813d0286 <+22>:	bswap  ecx
   0xffffffff813d0288 <+24>:	mov    DWORD PTR [rdx+rax*1],ecx
   0xffffffff813d028b <+27>:	add    rax,0x4
   0xffffffff813d028f <+31>:	cmp    rax,0x40
   0xffffffff813d0293 <+35>:	jne    0xffffffff813d0283 <sha_transform+19>
   0xffffffff813d0295 <+37>:	xor    ecx,ecx
=> 0xffffffff813d0297 <+39>:	mov    eax,DWORD PTR [rdx+rcx*1+0x20]
   0xffffffff813d029b <+43>:	xor    eax,DWORD PTR [rdx+rcx*1+0x34]
   0xffffffff813d029f <+47>:	xor    eax,DWORD PTR [rdx+rcx*1+0x8]
   0xffffffff813d02a3 <+51>:	xor    eax,DWORD PTR [rdx+rcx*1]
   0xffffffff813d02a6 <+54>:	ror    eax,0x1f
   0xffffffff813d02a9 <+57>:	mov    DWORD PTR [rdx+rcx*1+0x40],eax
   0xffffffff813d02ad <+61>:	add    rcx,0x4


-- 
Robert Święcki
