Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758426Ab1GKSBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 14:01:22 -0400
Received: from mail.candelatech.com ([208.74.158.172]:56218 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758378Ab1GKSBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 14:01:21 -0400
Message-ID: <4E1B3A70.40600@candelatech.com>
Date: Mon, 11 Jul 2011 11:01:20 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: crash in active_task, 3.0-rc6+
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is from a lightly patched kernel (nfs related patches)
Same system sees lockdep warnings related to scheduling that
I've been posting as well...

I haven't seen anything similar in older kernels, so this may
be a regression.  We tested .38 in this setup without seeing it,
but havn't tested .39.

[root@simech2 ~]# BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
IP: [<ffffffff81231bf8>] do_raw_spin_lock+0x14/0x13c
PGD 127082067 PUD 127081067 PMD 0
Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
CPU 2
Modules linked in: 8021q garp xt_addrtype xt_TPROXY nf_tproxy_core xt_socket nf_defrag_ipv6 xt_set ip_set nfnetlink xt_connlimit ip]

Pid: 2203, comm: gnuserver Not tainted 3.0.0-rc6+ #20 Supermicro X7DBU/X7DBU
RIP: 0010:[<ffffffff81231bf8>]  [<ffffffff81231bf8>] do_raw_spin_lock+0x14/0x13c
RSP: 0018:ffff8801104e3628  EFLAGS: 00010096
RAX: ffff880126b9e7e0 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffff8801104e3668 R08: 0000000000000002 R09: 0000000000000001
R10: 000002bf7b96a212 R11: ffff880107481e30 R12: 0000000000000003
R13: 0000000000000000 R14: 0000000000000046 R15: 0000000000000002
FS:  00007f213f07c720(0000) GS:ffff88012fc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000004 CR3: 0000000110519000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process gnuserver (pid: 2203, threadinfo ffff8801104e2000, task ffff880126b9e7e0)
Stack:
  0000000000000018 0000000000000046 00000000bf3d0800 0000000000000000
  0000000000000003 0000000000000000 0000000000000046 0000000000000002
  ffff8801104e3698 ffffffff8147e459 ffffffff810a7f25 ffffffff8103d2f7
Call Trace:
  [<ffffffff8147e459>] _raw_spin_lock+0x3e/0x45
  [<ffffffff810a7f25>] ? __rcu_read_unlock+0xdc/0x24e
  [<ffffffff8103d2f7>] ? activate_task+0x30/0x30
  [<ffffffff810a7f25>] __rcu_read_unlock+0xdc/0x24e
  [<ffffffff8103d34d>] rcu_read_unlock+0x21/0x23
  [<ffffffff8103efd7>] select_task_rq_fair+0x8cc/0x8e1
  [<ffffffff81042b59>] ? finish_task_switch+0x78/0xf1
  [<ffffffff81042b1b>] ? finish_task_switch+0x3a/0xf1
  [<ffffffff810468d0>] ? try_to_wake_up+0x29/0x1a0
  [<ffffffff810468d0>] ? try_to_wake_up+0x29/0x1a0
  [<ffffffff81040c52>] select_task_rq+0x13/0x44
  [<ffffffff8104697f>] try_to_wake_up+0xd8/0x1a0
  [<ffffffff8103c783>] ? __wake_up+0x1d/0x48
  [<ffffffff81046a54>] default_wake_function+0xd/0xf
  [<ffffffff8106751a>] autoremove_wake_function+0x13/0x38
  [<ffffffff810395d0>] __wake_up_common+0x49/0x7f
  [<ffffffff8103c79a>] __wake_up+0x34/0x48
  [<ffffffff810a74a9>] rcu_report_exp_rnp+0x50/0x89
  [<ffffffff810a7f25>] ? __rcu_read_unlock+0xdc/0x24e
  [<ffffffff810a8032>] __rcu_read_unlock+0x1e9/0x24e
  [<ffffffff813fce40>] rcu_read_unlock+0x21/0x23
  [<ffffffff813fd52d>] ip_queue_xmit+0x35e/0x3b1
  [<ffffffff813fd1cf>] ? ip_send_reply+0x247/0x247
  [<ffffffff8140f5f3>] tcp_transmit_skb+0x785/0x7c3
  [<ffffffff81411e23>] tcp_write_xmit+0x806/0x8f5
  [<ffffffff810e646f>] ? might_fault+0x4e/0x9e
  [<ffffffff81403e25>] ? copy_from_user+0x2a/0x2c
  [<ffffffff81411f63>] __tcp_push_pending_frames+0x20/0x4d
  [<ffffffff8140411f>] tcp_push+0x84/0x86
  [<ffffffff81406577>] tcp_sendmsg+0x674/0x775
  [<ffffffff81423d68>] inet_sendmsg+0x61/0x6a
  [<ffffffff813af67a>] __sock_sendmsg_nosec+0x58/0x61
  [<ffffffff813b0db5>] __sock_sendmsg+0x3d/0x48
  [<ffffffff813b1631>] sock_sendmsg+0xa3/0xbc
  [<ffffffff810ea6ae>] ? handle_pte_fault+0x7fc/0x84d
  [<ffffffff81110b14>] ? mem_cgroup_get_limit+0x45/0x45
  [<ffffffff8111a4e9>] ? fget_light+0x35/0xac
  [<ffffffff813b16b2>] ? sockfd_lookup_light+0x1b/0x53
  [<ffffffff813b1bf5>] sys_sendto+0xfa/0x11f
  [<ffffffff8147f0d8>] ? retint_restore_args+0x13/0x13
  [<ffffffff8109f0a1>] ? audit_syscall_entry+0x119/0x145
  [<ffffffff81484d52>] system_call_fastpath+0x16/0x1b
Code: ff 48 c7 43 10 ff ff ff ff c7 43 08 ff ff ff ff fe 03 41 58 5b c9 c3 55 48 89 e5 41 57 41 56 41 55 41 54 53 48 89 fb 48 83 ec
  7f 04 ad 4e ad de 74 0c 48 c7 c6 47 32 7a 81 e8 a9 fe ff ff
RIP  [<ffffffff81231bf8>] do_raw_spin_lock+0x14/0x13c
  RSP <ffff8801104e3628>
CR2: 0000000000000004
---[ end trace bd9381b635ffe22e ]---

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

