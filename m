Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330Ab1C3KFF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 06:05:05 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55322 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755073Ab1C3KFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 06:05:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=DsCP5iJkh0kY13iV95W/t+P78rVFZZed1wNkMJ8i3lU/5YZjiknx4/b08OJBvhgylZ
         Wud7AdwS0HHsrokLKOKJhq8s9r7TUeHZ4okLobH0ISK7BQrIsDiPp2ubcPAKoyvrDAGM
         lDVbOYAFR4gISD402SfhdcGgmpCdUMvBOYa3o=
MIME-Version: 1.0
Date: Wed, 30 Mar 2011 18:05:01 +0800
Message-ID: <AANLkTimv61zJhCjj-pgOHW6UYG4XSPLkjb8Z_yEMaFWo@mail.gmail.com>
Subject: [2.6.39-rc1] trie: RCU deref outside critical section
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Networking <linux-net@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The loop in fib_table_flush [1] calls trie_firstleaf() which
RCU-dereferences a structure outside a RCU read critical section,
generating a warning [2].

Since trie_leaf_remove() uses rcu_assign_pointer(), which should be
outside the RCU read critical section, is there any better solution
than spitting up the loop, with the first half covered by a RCU read
critical section lock?

Daniel

--- [1]

int fib_table_flush(struct fib_table *tb)
{
	struct trie *t = (struct trie *) tb->tb_data;
	struct leaf *l, *ll = NULL;
	int found = 0;

	for (l = trie_firstleaf(t); l; l = trie_nextleaf(l)) {
		found += trie_flush_leaf(l);

		if (ll && hlist_empty(&ll->list))
			trie_leaf_remove(t, ll);
		ll = l;
	}

--- [2]

===================================================
[ INFO: suspicious rcu_dereference_check() usage. ]
---------------------------------------------------
net/ipv4/fib_trie.c:1777 invoked rcu_dereference_check() without protection!

other info that might help us debug this:

rcu_scheduler_active = 1, debug_locks = 1
3 locks held by kworker/u:5/51:
 #0:  (netns){.+.+.+}, at: [<ffffffff8107b639>] process_one_work+0x149/0x470
 #1:  (net_cleanup_work){+.+.+.}, at: [<ffffffff8107b639>]
process_one_work+0x149/0x470
 #2:  (net_mutex){+.+.+.}, at: [<ffffffff8157b4b0>] cleanup_net+0x80/0x1b0

stack backtrace:
Pid: 51, comm: kworker/u:5 Tainted: G        W   2.6.39-rc1-350cd #1
Call Trace:
 [<ffffffff81094cd4>] lockdep_rcu_dereference+0xa4/0xc0
 [<ffffffff8160aa23>] trie_firstleaf+0x93/0xa0
 [<ffffffff8156feb8>] ? __sk_free+0x148/0x1e0
 [<ffffffff8160d890>] fib_table_flush+0x20/0x1a0
 [<ffffffff81606da5>] ip_fib_net_exit+0x95/0xd0
 [<ffffffff81606e10>] fib_net_exit+0x30/0x40
 [<ffffffff8157ab8e>] ops_exit_list+0x2e/0x70
 [<ffffffff8157b52b>] cleanup_net+0xfb/0x1b0
 [<ffffffff8107b69a>] process_one_work+0x1aa/0x470
 [<ffffffff8107b639>] ? process_one_work+0x149/0x470
 [<ffffffff8157b430>] ? net_free+0x30/0x30
 [<ffffffff8107bd97>] worker_thread+0x157/0x3c0
 [<ffffffff816ea484>] ? preempt_schedule+0x44/0x60
 [<ffffffff8107bc40>] ? rescuer_thread+0x2e0/0x2e0
 [<ffffffff81080236>] kthread+0xb6/0xc0
 [<ffffffff81095f1d>] ? trace_hardirqs_on_caller+0x14d/0x190
 [<ffffffff816ef094>] kernel_thread_helper+0x4/0x10
 [<ffffffff810553f8>] ? finish_task_switch+0x78/0x110
 [<ffffffff816ed7c4>] ? retint_restore_args+0xe/0xe
 [<ffffffff81080180>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff816ef090>] ? gs_change+0xb/0xb
-- 
Daniel J Blueman
