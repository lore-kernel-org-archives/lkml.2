Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab2KJEZW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 23:25:22 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:27280 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593Ab2KJEZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 23:25:18 -0500
Message-ID: <1352521515.7611.16.camel@lorien2>
Subject: NULL pointer dereference at task_numa_fault+0x36/0x140
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: a.p.zijlstra@chello.nl
Cc: LKML <linux-kernel@vger.kernel.org>, shuahkhan@gmail.com
Date: Fri, 09 Nov 2012 21:25:15 -0700
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I ran into NULL pointer dereference at task_numa_fault+0x36/0x140 when I
was installing guest OS in a vm in kvm virt env.

My test system doesn't have NUMA config and runs with Fake NUMA node:

[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem
0x0000000000000000-0x000000007fdfffff]

Sharing my analysis of the problem and offer to help with re-test of any
fixes.

Further debugging narrowed the NULL pointer dereference to line 844 of
"kernel/sched/fair.c: int seq = ACCESS_ONCE(p->mm->numa_scan_seq);

(gdb) x/10i task_numa_fault+0x36
   0xffffffff81093f36 <task_numa_fault+54>:     mov    0x358(%rax),%r8d
   0xffffffff81093f3d <task_numa_fault+61>:     cmp    0x768(%rbx),%r8d
   0xffffffff81093f44 <task_numa_fault+68>:
    je     0xffffffff81093fc0 <task_numa_fault+192>
   0xffffffff81093f46 <task_numa_fault+70>:
    mov    0xc48ba0(%rip),%esi        # 0xffffffff81cdcaec
   0xffffffff81093f4c <task_numa_fault+76>:     mov    %r8d,0x768(%rbx)
   0xffffffff81093f53 <task_numa_fault+83>:     test   %esi,%esi
   0xffffffff81093f55 <task_numa_fault+85>:
    jle    0xffffffff81093fc0 <task_numa_fault+192>
   0xffffffff81093f57 <task_numa_fault+87>:     mov    $0xffffffff,%esi
   0xffffffff81093f5c <task_numa_fault+92>:     xor    %edi,%edi
   0xffffffff81093f5e <task_numa_fault+94>:     xor    %edx,%edx
(gdb) info line *0xffffffff81093f36
Line 844 of "kernel/sched/fair.c"
   starts at address 0xffffffff81093f2f <task_numa_fault+47>
   and ends at 0xffffffff81093f3d <task_numa_fault+61>.

The following two commits change the way this code is structured and the
second commit looks like is the one that introduced the numm pointer
access possibly by removing struct task_struct *p = current;

+static void task_numa_placement(struct task_struct *p)
 {
 	unsigned long faults, max_faults = 0;
-	struct task_struct *p = current;
 	int node, max_node = -1;
 	int seq = ACCESS_ONCE(p->mm->numa_scan_seq);
 

commit f3bd8842a897685269b3fa48ad6f9d5590be67ab
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Wed Oct 10 14:13:15 2012 +0200

    sched/numa: Simplify task_numa_fault()


commit 617fe041711635713ec52ed5f36d6f46f38d83f2
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Sun Oct 14 21:30:07 2012 +0200

    sched/numa/mm: Fix and further simplify fault accounting

    The THP alloc failure path did double accounting .. fix this.

    While we're at it, merge task_numa_placement() into
task_numa_fault()
    so that there's only a single call from the fault path.

    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Link:
http://lkml.kernel.org/n/tip-hz6rnixgr665fv0offesjofb@git.kernel.org
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

    Also fix numa_scan_seq off by one.

    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Link:
http://lkml.kernel.org/n/tip-dvswxo34oaiibm06zyvrv0q5@git.kernel.org
    Signed-off-by: Ingo Molnar <mingo@kernel.org>



Panic log:

[30155.084514] BUG: unable to handle kernel NULL pointer dereference at
0000000000000358
[30155.084568] IP: [<ffffffff81093f36>] task_numa_fault+0x36/0x140
[30155.084597] PGD 0
[30155.084611] Oops: 0000 [#1] SMP
[30155.084635] Modules linked in: ip6table_filter ip6_tables ebtable_nat
ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack
ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables
x_tables bridge stp llc bnep rfcomm bluetooth arc4 iwldvm
snd_hda_codec_analog mac80211 snd_hda_intel snd_hda_codec radeon
snd_hwdep coretemp snd_pcm kvm_intel snd_seq_midi iwlwifi kvm
snd_rawmidi snd_seq_midi_event cfg80211 snd_seq ttm pata_pcmcia
drm_kms_helper drm snd_timer pcmcia snd_seq_device binfmt_misc snd
psmouse tpm_infineon yenta_socket ppdev joydev soundcore hp_wmi
snd_page_alloc dm_multipath hp_accel lpc_ich parport_pc pcmcia_rsrc
pcmcia_core video sparse_keymap serio_raw i2c_algo_bit wmi mac_hid
tpm_tis lis3lv02d input_polldev microcode lp parport firewire_ohci
firewire_core crc_itu_t sdhci_pci sdhci e1000e
[30155.085191] CPU 1
[30155.085204] Pid: 33, comm: ksmd Not tainted 3.7.0-rc2-next-20121026+
#5 Hewlett-Packard HP EliteBook 6930p/30DC
[30155.085241] RIP: 0010:[<ffffffff81093f36>]  [<ffffffff81093f36>]
task_numa_fault+0x36/0x140
[30155.085274] RSP: 0018:ffff88003076fc68  EFLAGS: 00010286
[30155.085297] RAX: 0000000000000000 RBX: ffff880030761730 RCX:
0000000000000000
[30155.085323] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
ffff88002fa89fe0
[30155.085349] RBP: ffff88003076fc88 R08: ffff88007fa96b80 R09:
0000000000000000
[30155.086737] R10: ffff88002fa89fd8 R11: ffffffffffffffff R12:
0000000000000001
[30155.088006] R13: 0000000000000000 R14: ffff880064a2a868 R15:
00007fd1e1a47000
[30155.088006] FS:  0000000000000000(0000) GS:ffff88007fa80000(0000)
knlGS:0000000000000000
[30155.088006] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[30155.088006] CR2: 0000000000000358 CR3: 0000000001c0b000 CR4:
00000000000427e0
[30155.088006] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[30155.088006] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[30155.088006] Process ksmd (pid: 33, threadinfo ffff88003076e000, task
ffff880030761730)
[30155.088006] Stack:
[30155.088006]  ffff880078276f20 00000000051fb120 ffff880078276f20
0000000000000000
[30155.088006]  ffff88003076fd48 ffffffff81154c59 80000000051fb025
ffff880064a40000
[30155.088006]  ffff880064a40038 0000000000000000 ffff880064a42b78
00007fd1e1a44000
[30155.088006] Call Trace:
[30155.088006]  [<ffffffff81154c59>] handle_pte_fault+0x309/0xc40
[30155.088006]  [<ffffffff811567f9>] handle_mm_fault+0x289/0x350
[30155.088006]  [<ffffffff81172dc4>] break_ksm+0x74/0xa0
[30155.088006]  [<ffffffff8117385c>] break_cow+0x5c/0x80
[30155.109969]  [<ffffffff81174939>] ksm_scan_thread+0xc39/0xd60
[30155.109969]  [<ffffffff8107d350>] ? add_wait_queue+0x60/0x60
[30155.109969]  [<ffffffff81173d00>] ? run_store+0x2d0/0x2d0
[30155.109969]  [<ffffffff8107c760>] kthread+0xc0/0xd0
[30155.109969]  [<ffffffff8107c6a0>] ? flush_kthread_worker+0xb0/0xb0
[30155.109969]  [<ffffffff8169da6c>] ret_from_fork+0x7c/0xb0
[30155.109969]  [<ffffffff8107c6a0>] ? flush_kthread_worker+0xb0/0xb0
[30155.109969] Code: 41 89 fd 41 54 41 89 f4 53 65 48 8b 1c 25 40 c7 00
00 48 83 ec 08 48 83 bb 88 07 00 00 00 0f 84 e4 00 00 00 48 8b 83 98 02
00 00 <44> 8b 80 58 03 00 00 44 3b 83 68 07 00 00 74 7a 8b 35 a0 8b c4
[30155.109969] RIP  [<ffffffff81093f36>] task_numa_fault+0x36/0x140
[30155.109969]  RSP <ffff88003076fc68>
[30155.109969] CR2: 0000000000000358
[30155.135075] ---[ end trace 12c90d4da10f890d ]---

-- Shuah


