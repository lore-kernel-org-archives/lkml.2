Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab2AQPzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 10:55:45 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42649 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682Ab2AQPzn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 10:55:43 -0500
MIME-Version: 1.0
Date: Tue, 17 Jan 2012 16:55:41 +0100
Message-ID: <CAP145pjbHvhEz0938H8oS67HcBYv8MU6LshYP92wqT9aXTAzhg@mail.gmail.com>
Subject: Badness around put_cred()
From: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was fuzzing linux kernel for some time, and there seems to be a bug,
which kicks in relatively quickly (a few hours at most), which ends up
with warn() or panic() - depending on options compiled in
(CONFIG_DEBUG_CREDENTIALS, preemption mode). I was looking briefly
through kernel code, and I think it might be related to the
include/linux/cred.h::

static inline void put_cred(const struct cred *_cred)
{
        struct cred *cred = (struct cred *) _cred;

        validate_creds(cred);
        if (atomic_dec_and_test(&(cred)->usage))
                __put_cred(cred);
}

which checks whether the usage counter is different than 0, and maybe
it should be checking whether it is >0.

All in all, I don't understand the whole cred/rcu code yet, so just
dumping the data, in case somebody else can spot the problem quicker.
The kernel versions are 2.6.39 and 3.2

Config: CONFIG_DEBUG_CREDENTIALS=n, CONFIG_PREEMPT_RCU=n,
CONFIG_PREEMPT=n, kernel=3.2

(gdb) bt
#0  kgdb_breakpoint () at kernel/debug/debug_core.c:960
#1  kgdb_panic_event (self=0x286, val=0, data=0x0) at
kernel/debug/debug_core.c:766
#2  0xffffffff810c1eff in notifier_call_chain (nl=<optimized out>,
val=0, v=0xffffffff8301a9b0, nr_to_call=-1, nr_calls=<optimized out>)
at kernel/notifier.c:93
#3  0xffffffff810c1f57 in __atomic_notifier_call_chain
(nr_calls=<optimized out>, nr_to_call=<optimized out>, v=<optimized
out>, val=<optimized out>, nh=<optimized out>) at
kernel/notifier.c:190
#4  atomic_notifier_call_chain (nh=<optimized out>, val=0, v=0x0) at
kernel/notifier.c:191
#5  0xffffffff8205abc5 in panic (fmt=0xffffffff829c20f5 "CRED:
put_cred_rcu() sees %p with usage %d\n") at kernel/panic.c:100
#6  0xffffffff810c3365 in put_cred_rcu (rcu=0xffff880118552b88) at
kernel/cred.c:139
#7  0xffffffff810ffa52 in __rcu_reclaim (rn=<optimized out>,
head=<optimized out>) at kernel/rcu.h:81
#8  rcu_do_batch (rdp=<optimized out>, rsp=<optimized out>) at
kernel/rcutree.c:1292
#9  invoke_rcu_callbacks (rdp=<optimized out>, rsp=<optimized out>) at
kernel/rcutree.c:1577
#10 __rcu_process_callbacks (rsp=0xffffffff82c34500,
rdp=0xffff88012bc4e960) at kernel/rcutree.c:1549
#11 0xffffffff810ffc35 in rcu_process_callbacks (unused=<optimized
out>) at kernel/rcutree.c:1558
#12 0xffffffff810a4630 in __do_softirq () at kernel/softirq.c:238
#13 0xffffffff820602fc in ?? () at arch/x86/kernel/entry_64.S:1205
#14 0xffffffff8104c2e3 in do_softirq () at arch/x86/kernel/irq_64.c:83
#15 0xffffffff810a4304 in invoke_softirq () at kernel/softirq.c:329
#16 irq_exit () at kernel/softirq.c:348
#17 0xffffffff82060caf in smp_apic_timer_interrupt (regs=<optimized
out>) at arch/x86/kernel/apic/apic.c:882
#18 0xffffffff8205eb73 in ?? () at arch/x86/kernel/entry_64.S:973
Backtrace stopped: previous frame inner to this frame (corrupt stack?)
(gdb) up
#1  kgdb_panic_event (self=0x286, val=0, data=0x0) at
kernel/debug/debug_core.c:766
766		kgdb_breakpoint();
(gdb) up
#2  0xffffffff810c1eff in notifier_call_chain (nl=<optimized out>,
val=0, v=0xffffffff8301a9b0, nr_to_call=-1, nr_calls=<optimized out>)
at kernel/notifier.c:93
93			ret = nb->notifier_call(nb, val, v);
(gdb) up
#3  0xffffffff810c1f57 in __atomic_notifier_call_chain
(nr_calls=<optimized out>, nr_to_call=<optimized out>, v=<optimized
out>, val=<optimized out>, nh=<optimized out>) at
kernel/notifier.c:190
190	{
(gdb) up
#4  atomic_notifier_call_chain (nh=<optimized out>, val=0, v=0x0) at
kernel/notifier.c:191
191		return __atomic_notifier_call_chain(nh, val, v, -1, NULL);
(gdb)
#5  0xffffffff8205abc5 in panic (fmt=0xffffffff829c20f5 "CRED:
put_cred_rcu() sees %p with usage %d\n") at kernel/panic.c:100
100		atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
(gdb)
#6  0xffffffff810c3365 in put_cred_rcu (rcu=0xffff880118552b88) at
kernel/cred.c:139
139			panic("CRED: put_cred_rcu() sees %p with usage %d\n",
(gdb) list
134			      cred, cred->magic, cred->put_addr,
135			      atomic_read(&cred->usage),
136			      read_cred_subscribers(cred));
137	#else
138		if (atomic_read(&cred->usage) != 0)
139			panic("CRED: put_cred_rcu() sees %p with usage %d\n",
140			      cred, atomic_read(&cred->usage));
141	#endif
142	
143		security_cred_free(cred);
(gdb) p cred
$1 = (struct cred *) 0xffff880118552b00
(gdb) p *cred
$2 = {usage = {counter = -1}, uid = 1001, gid = 1001, suid = 1001,
sgid = 1001, euid = 1001, egid = 1001, fsuid = 1001, fsgid = 1001,
securebits = 0, cap_inheritable = {cap = {0, 0}}, cap_permitted = {cap
= {0, 0}}, cap_effective = {
    cap = {0, 0}}, cap_bset = {cap = {4294967295, 4294967295}},
jit_keyring = 0 '\000', thread_keyring = 0x0, request_key_auth = 0x0,
tgcred = 0xffff880116a3ed80, security = 0xffffffff8315ca10, user =
0xffff880122242a40,
  user_ns = 0xffffffff82c262f0, group_info = 0xffff88011a5d9240, rcu =
{next = 0xffff880111a4e348, func = 0xffffffff810c332e <put_cred_rcu>}}







Config: CONFIG_DEBUG_CREDENTIALS=y, CONFIG_PREEMPT_RCU=y,
CONFIG_PREEMPT=y, kernel=2.6.39

=====================================================================
KDB
=====================================================================

<3>[49754.391126] CRED: Invalid credentials
<3>[49754.394811] CRED: At include/linux/cred.h:260
<3>[49754.399181] CRED: Specified credentials: ffff8801156c8b00
<3>[49754.404676] CRED: ->magic=44656144, put_addr=ffffffff81166dc5
<3>[49754.410430] CRED: ->usage=0, subscr=0
<3>[49754.414102] CRED: ->*uid = { 65534,65534,65534,65534 }
<3>[49754.419250] CRED: ->*gid = { 65534,65534,65534,65534 }
<3>[49754.424397] CRED: ->security is ffff8801113069c0
<3>[49754.429021] CRED: ->security {1, 1}

[1]kdb> bt
Stack traceback for pid 16009
0xffff880115819770    16009     8897  1    1   R  0xffff880115819bf0 *iknowthis2
<c> ffff88012bc43e00<c> 0000000000000000<c> ffff880100000104<c>
ffffffff8267436f<c>
<c> ffffffff81b611cd<c> ffff8801156c8b00<c> ffff88012bc43e40<c>
ffffffff81166d8e<c>
<c> ffff8801156c8b00<c> ffff880121e13540<c> ffff88012bc43e60<c>
ffffffff81166db3<c>
Call Trace:
 <IRQ>  [<ffffffff81b611cd>] ? wq_free_rcu+0x12/0x14
 [<ffffffff81166d8e>] ? __validate_creds.clone.9+0x2d/0x32
 [<ffffffff81166db3>] ? file_free_rcu+0x20/0x46
 [<ffffffff810eeb82>] ? __rcu_process_callbacks+0x18d/0x2af
 [<ffffffff810eed24>] ? rcu_process_callbacks+0x80/0x87
 [<ffffffff8109c013>] ? __do_softirq+0xeb/0x1cc
 [<ffffffff81044977>] ? native_sched_clock+0x35/0x37
 [<ffffffff810b67dd>] ? sched_clock_local+0x12/0x75
 [<ffffffff81edbd9c>] ? call_softirq+0x1c/0x30
 [<ffffffff81040510>] ? do_softirq+0x4b/0x9f
 [<ffffffff8109c380>] ? irq_exit+0x5f/0xb6
 [<ffffffff81edc6d1>] ? smp_apic_timer_interrupt+0x7d/0x8b
 [<ffffffff81edb553>] ? apic_timer_interrupt+0x13/0x20
 <EOI>  [<ffffffff81093f75>] ? dup_mm+0x1f2/0x468
 [<ffffffff81151cdb>] ? arch_local_irq_restore+0x6/0xd
 [<ffffffff81154ceb>] ? __slab_alloc.clone.36+0xf0/0x38b
 [<ffffffff81093f75>] ? dup_mm+0x1f2/0x468
 [<ffffffff81155143>] ? kmem_cache_alloc+0x4a/0xe7
 [<ffffffff8135b0ce>] ? selinux_vm_enough_memory+0x48/0x4d
 [<ffffffff81093f75>] ? dup_mm+0x1f2/0x468
 [<ffffffff81094c56>] ? copy_process+0xa3e/0x1230
 [<ffffffff81095592>] ? do_fork+0x10f/0x29d
 [<ffffffff813d8dba>] ? trace_hardirqs_off_thunk+0x3a/0x6c
 [<ffffffff8107e5b9>] ? sys32_clone+0x26/0x28
 [<ffffffff81edc585>] ? ia32_ptregs_common+0x25/0x4b

[dumpcommon]kdb>   -summary

sysname    Linux
release    2.6.39
version    #3 SMP PREEMPT Fri May 27 15:27:03 CEST 2011
machine    x86_64
nodename   ise-test
domainname (none)
ccversion  CCVERSION
date       2011-05-28 03:20:03 tz_minuteswest -120
uptime     13:49
load avg   19.38 20.17 22.96

MemTotal:         993059 kB
MemFree:          458493 kB
Buffers:           23981 kB


=====================================================================
KGDB
=====================================================================

(gdb) bt
#0  __invalid_creds (cred=0xffff8801156c8b00, file=<value optimized
out>, line=<value optimized out>)
    at kernel/cred.c:812
#1  0xffffffff81166d8e in __validate_creds (cred=0xffff8801156c8b00, line=260,
    file=0xffffffff8267436f "include/linux/cred.h") at include/linux/cred.h:186
#2  0xffffffff81166db3 in put_cred (head=<value optimized out>) at
include/linux/cred.h:260
#3  file_free_rcu (head=<value optimized out>) at fs/file_table.c:49
#4  0xffffffff810eeb82 in rcu_do_batch (rsp=0xffffffff82a2f500,
rdp=0xffff88012bc502f0) at kernel/rcutree.c:1146
#5  __rcu_process_callbacks (rsp=0xffffffff82a2f500,
rdp=0xffff88012bc502f0) at kernel/rcutree.c:1386
#6  0xffffffff810eed24 in rcu_preempt_process_callbacks (unused=<value
optimized out>) at kernel/rcutree_plugin.h:544
#7  rcu_process_callbacks (unused=<value optimized out>) at
kernel/rcutree.c:1404
#8  0xffffffff8109c013 in __do_softirq () at kernel/softirq.c:238
#9  0xffffffff81edbd9c in ?? () at arch/x86/kernel/entry_64.S:1210
#10 0xffffffff81040510 in do_softirq () at arch/x86/kernel/irq_64.c:80
#11 0xffffffff8109c380 in invoke_softirq () at kernel/softirq.c:325
#12 irq_exit () at kernel/softirq.c:340
#13 0xffffffff81edc6d1 in smp_apic_timer_interrupt (regs=<value
optimized out>) at arch/x86/kernel/apic/apic.c:861
#14 <signal handler called>
#15 0x00cf9b000000ffff in __brk_reservation_fn_dmi_alloc__ ()
Cannot access memory at address 0xcffb000000ffff

Cannot access memory at address 0xcffb000000ffff
(gdb) up
#1  0xffffffff81166d8e in __validate_creds (cred=0xffff8801156c8b00, line=260,
    file=0xffffffff8267436f "include/linux/cred.h") at include/linux/cred.h:186
186			__invalid_creds(cred, file, line);
(gdb) p *cred
$1 = {usage = {counter = 0}, subscribers = {counter = 0}, put_addr =
0xffffffff81166dc5, magic = 1147494724,
  uid = 65534, gid = 65534, suid = 65534, sgid = 65534, euid = 65534,
egid = 65534, fsuid = 65534, fsgid = 65534,
  securebits = 0, cap_inheritable = {cap = {0, 0}}, cap_permitted =
{cap = {0, 0}}, cap_effective = {cap = {0, 0}},
  cap_bset = {cap = {4294967295, 4294967295}}, jit_keyring = 0 '\000',
thread_keyring = 0x0, request_key_auth = 0x0,
  tgcred = 0xffff88011492b088, security = 0xffff8801113069c0, user =
0xffff880121c4b000, user_ns = 0xffffffff82a21a80,
  group_info = 0xffff880104cec420, rcu = {next = 0x0, func =
0xffffffff810b6c97 <put_cred_rcu>}}

(gdb) p (char[4])cred->magic
$8 = "DaeD"



-- 
Robert Święcki
