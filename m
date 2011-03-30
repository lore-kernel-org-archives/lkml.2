Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932479Ab1C3M2J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 08:28:09 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45523 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785Ab1C3M2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 08:28:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=s28ogquqriQTlx6ZFJAzGAn0obbLhchdGXsdc8+z7uWGKVAGp+vSuRKY4LSQ6Dn1Gn
         Te0rKHl5CfrdXtHqixzRyO6XEqU3Oxz7rQF2IHfUsd1EH4bwLqAqkQKruHJQQnvBI7it
         A7wH2wY6vG7NEpJuXAsbim/wku5ttSa9bJ0ao=
Subject: [PATCH] fib: add rtnl locking in ip_fib_net_exit
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Daniel J Blueman <daniel.blueman@gmail.com>,
        David Miller <davem@davemloft.net>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
In-Reply-To: <AANLkTimv61zJhCjj-pgOHW6UYG4XSPLkjb8Z_yEMaFWo@mail.gmail.com>
References: <AANLkTimv61zJhCjj-pgOHW6UYG4XSPLkjb8Z_yEMaFWo@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Mar 2011 14:28:02 +0200
Message-ID: <1301488082.3283.43.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 30 mars 2011 à 18:05 +0800, Daniel J Blueman a écrit :
> The loop in fib_table_flush [1] calls trie_firstleaf() which
> RCU-dereferences a structure outside a RCU read critical section,
> generating a warning [2].
> 

Hi Daniel

> Since trie_leaf_remove() uses rcu_assign_pointer(), which should be
> outside the RCU read critical section, is there any better solution
> than spitting up the loop, with the first half covered by a RCU read
> critical section lock?
> 

rcu_assign_pointer() can be done anywhere. This is done by a writer
(holding RTNL), while RCU read is used by readers.

> Daniel
> 
> --- [1]
> 
> int fib_table_flush(struct fib_table *tb)
> {
> 	struct trie *t = (struct trie *) tb->tb_data;
> 	struct leaf *l, *ll = NULL;
> 	int found = 0;
> 
> 	for (l = trie_firstleaf(t); l; l = trie_nextleaf(l)) {
> 		found += trie_flush_leaf(l);
> 
> 		if (ll && hlist_empty(&ll->list))
> 			trie_leaf_remove(t, ll);
> 		ll = l;
> 	}
> 
> --- [2]
> 
> ===================================================
> [ INFO: suspicious rcu_dereference_check() usage. ]
> ---------------------------------------------------
> net/ipv4/fib_trie.c:1777 invoked rcu_dereference_check() without protection!
> 
> other info that might help us debug this:
> 
> rcu_scheduler_active = 1, debug_locks = 1
> 3 locks held by kworker/u:5/51:
>  #0:  (netns){.+.+.+}, at: [<ffffffff8107b639>] process_one_work+0x149/0x470
>  #1:  (net_cleanup_work){+.+.+.}, at: [<ffffffff8107b639>]
> process_one_work+0x149/0x470
>  #2:  (net_mutex){+.+.+.}, at: [<ffffffff8157b4b0>] cleanup_net+0x80/0x1b0
> 
> stack backtrace:
> Pid: 51, comm: kworker/u:5 Tainted: G        W   2.6.39-rc1-350cd #1
> Call Trace:
>  [<ffffffff81094cd4>] lockdep_rcu_dereference+0xa4/0xc0
>  [<ffffffff8160aa23>] trie_firstleaf+0x93/0xa0
>  [<ffffffff8156feb8>] ? __sk_free+0x148/0x1e0
>  [<ffffffff8160d890>] fib_table_flush+0x20/0x1a0
>  [<ffffffff81606da5>] ip_fib_net_exit+0x95/0xd0
>  [<ffffffff81606e10>] fib_net_exit+0x30/0x40
>  [<ffffffff8157ab8e>] ops_exit_list+0x2e/0x70
>  [<ffffffff8157b52b>] cleanup_net+0xfb/0x1b0
>  [<ffffffff8107b69a>] process_one_work+0x1aa/0x470
>  [<ffffffff8107b639>] ? process_one_work+0x149/0x470
>  [<ffffffff8157b430>] ? net_free+0x30/0x30
>  [<ffffffff8107bd97>] worker_thread+0x157/0x3c0
>  [<ffffffff816ea484>] ? preempt_schedule+0x44/0x60
>  [<ffffffff8107bc40>] ? rescuer_thread+0x2e0/0x2e0
>  [<ffffffff81080236>] kthread+0xb6/0xc0
>  [<ffffffff81095f1d>] ? trace_hardirqs_on_caller+0x14d/0x190
>  [<ffffffff816ef094>] kernel_thread_helper+0x4/0x10
>  [<ffffffff810553f8>] ? finish_task_switch+0x78/0x110
>  [<ffffffff816ed7c4>] ? retint_restore_args+0xe/0xe
>  [<ffffffff81080180>] ? __init_kthread_worker+0x70/0x70
>  [<ffffffff816ef090>] ? gs_change+0xb/0xb

So fib_table_flush() is called (from ip_fib_net_exit) without RTNL being
held.

Here is patch to fix this.

Thanks

[PATCH] fib: add rtnl locking in ip_fib_net_exit

Daniel J Blueman reported a lockdep splat in trie_firstleaf(), caused by
RTNL being not locked before a call to fib_table_flush()

Reported-by: Daniel J Blueman <daniel.blueman@gmail.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 net/ipv4/fib_frontend.c |    2 ++
 1 files changed, 2 insertions(+)

diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index f116ce8..4510883 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -1068,6 +1068,7 @@ static void ip_fib_net_exit(struct net *net)
 	fib4_rules_exit(net);
 #endif
 
+	rtnl_lock();
 	for (i = 0; i < FIB_TABLE_HASHSZ; i++) {
 		struct fib_table *tb;
 		struct hlist_head *head;
@@ -1080,6 +1081,7 @@ static void ip_fib_net_exit(struct net *net)
 			fib_free_table(tb);
 		}
 	}
+	rtnl_unlock();
 	kfree(net->ipv4.fib_table_hash);
 }
 


