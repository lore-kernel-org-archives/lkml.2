Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab0GLVZK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 17:25:10 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38170 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858Ab0GLVZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 17:25:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=joKzNeb79w/YIOVoyCnRJxz8+me3ese6rRbGUImXw1rhBINhloFVVDVAWteNAdUDtD
         bjHPY4NesOPjzEtAzuktygz6k8REcnwDGeWbVjs21iMJswdKUCyq5pzbU1U9kxQuBq5N
         RNMkqxNdqYHOK92sHhW1IfYLBO72cK8Zcpaxg=
Date: Mon, 12 Jul 2010 23:25:02 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost
To: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
cc: Clark Williams <williams@redhat.com>, John Stultz <johnstul@us.ibm.com>,
        Nick Piggin <npiggin@suse.de>, Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: rt - BUG: bad unlock balance detected!
Message-ID: <alpine.LFD.2.00.1007122305340.21145@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following occurred on a tip/rt/2.6.33 kernel
(last sha1 42edbcbc3240b56cf89a426cbfe9c8d9051459c4)
plus two patches from John Stultz
https://patchwork.kernel.org/patch/108928/
https://patchwork.kernel.org/patch/108927/

[ BUG: bad unlock balance detected! ]
-------------------------------------
sirq-net-rx/5/78 is trying to release lock (&lock->lock) at:
[<ffffffffa0650420>] ipt_do_table+0x8e8/0x968 [ip_tables]
but there are no more locks to release!

other info that might help us debug this:
3 locks held by sirq-net-rx/5/78:
 #0:  (rcu_read_lock){......}, at: [<ffffffff8141d2ae>] 
rcu_read_lock+0x0/0x3a
 #1:  (rcu_read_lock){......}, at: [<ffffffff8141d2ae>] 
rcu_read_lock+0x0/0x3a
 #2:  (rcu_read_lock){......}, at: [<ffffffff81452bf7>] 
rcu_read_lock+0x0/0x3a

stack backtrace:
Pid: 78, comm: sirq-net-rx/5 Not tainted 2.6.33.5-rt23-tracing-dcachefix 
#1
Call Trace:
 [<ffffffffa0650420>] ? ipt_do_table+0x8e8/0x968 [ip_tables]
 [<ffffffff810a30de>] print_unlock_inbalance_bug+0xd6/0xe0
 [<ffffffff810a3937>] lock_release_non_nested+0xbe/0x23b
 [<ffffffff810acd7c>] ? rt_spin_lock_fastunlock.clone.2+0x9b/0xc0
 [<ffffffffa0650420>] ? ipt_do_table+0x8e8/0x968 [ip_tables]
 [<ffffffffa0650420>] ? ipt_do_table+0x8e8/0x968 [ip_tables]
 [<ffffffff810a41e6>] lock_release+0x17d/0x19f
 [<ffffffff8150eff0>] rt_spin_unlock+0x23/0x30
 [<ffffffffa0650420>] ipt_do_table+0x8e8/0x968 [ip_tables]
 [<ffffffff8100bff3>] ? native_sched_clock+0x25/0x92
 [<ffffffff81094abf>] ? sched_clock_cpu+0xdb/0x234
 [<ffffffff81094c61>] ? cpu_clock+0x49/0x5c
 [<ffffffffa0660130>] ipt_local_in_hook+0x23/0x27 [iptable_filter]
 [<ffffffff81452eda>] nf_iterate+0x8a/0x10d
 [<ffffffff81466a31>] ? ip_local_deliver_finish+0x0/0x380
 [<ffffffff81452fde>] nf_hook_slow+0x81/0x177
 [<ffffffff81466a31>] ? ip_local_deliver_finish+0x0/0x380
 [<ffffffff81466e0c>] nf_hook_thresh.clone.1+0x5b/0x5d
 [<ffffffff81466e8a>] ip_local_deliver+0x7c/0xa3
 [<ffffffff814667d0>] ip_rcv_finish+0x5be/0x5e2
 [<ffffffff814672c5>] ip_rcv+0x414/0x443
 [<ffffffff81420984>] netif_receive_skb+0x7bf/0x7e9
 [<ffffffffa02fdefb>] rtl8169_rx_interrupt+0x560/0x68c [r8169]
 [<ffffffffa03013f4>] rtl8169_poll+0x3c/0x23b [r8169]
 [<ffffffff814214ba>] net_rx_action+0x15e/0x3fc
 [<ffffffff8104f0ce>] ? get_parent_ip+0x11/0x6f
 [<ffffffff8106ae2e>] run_ksoftirqd+0x249/0x3be
 [<ffffffff81044b06>] ? need_resched+0x3f/0x46
 [<ffffffff8106abe5>] ? run_ksoftirqd+0x0/0x3be
 [<ffffffff8108b816>] kthread+0xa4/0xac
 [<ffffffff81004594>] kernel_thread_helper+0x4/0x10
 [<ffffffff815100c0>] ? restore_args+0x0/0x30
 [<ffffffff8108b772>] ? kthread+0x0/0xac
 [<ffffffff81004590>] ? kernel_thread_helper+0x0/0x10

I've started to do a little debugging, some other info that might be 
useful:
#0:  (rcu_read_lock){......}, at: [<ffffffff8141d2ae>]
ffffffff8141d2ae /home/jkacur/jk-2.6/net/core/datagram.c:230
function skb_free_datagram_locked lock_sock(sk);

#2:  (rcu_read_lock){......}, at: [<ffffffff81452bf7>] 
rcu_read_lock+0x0/0x3a
ffffffff81452bf7 /home/jkacur/jk-2.6/net/netlink/af_netlink.c:878
function netlink_rcv_wake wake_up_interruptible(&nlk->wait);

