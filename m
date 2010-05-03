Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759544Ab0ECO6y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 10:58:54 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:50735 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759026Ab0ECO6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 10:58:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Jg5OXFdV/kqTkwPbm5Wd2JtfsbFs7b20dqESjmKyiPf9d6cYh9Pul+hvCXS11nHUvX
         3EeslDe2M4qjpQNBUb+AZr5GidLj54XWlM34xEedUxpST4Fw094Wta7foZ8ZTLDoc6J/
         SqfTWfOiPyCeNN6EiKEuElYIsGjtQ88JqYSuU=
Subject: Re: mmotm 2010-04-28 - RCU whinges
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <5933.1272897014@localhost>
References: <201004290021.o3T0L04Y028017@imap1.linux-foundation.org>
	 <5702.1272822394@localhost> <1272865137.2173.179.camel@edumazet-laptop>
	 <5933.1272897014@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 May 2010 16:58:46 +0200
Message-ID: <1272898726.2226.47.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 03 mai 2010 à 10:30 -0400, Valdis.Kletnieks@vt.edu a écrit :

> [    9.128899] Netfilter messages via NETLINK v0.30.
> [    9.128919] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
> [    9.129108] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
> [    9.129110] nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
> [    9.129113] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
> [    9.129135] ctnetlink v0.93: registering with nfnetlink.
> [    9.129452] ip_tables: (C) 2000-2006 Netfilter Core Team
> [    9.129506] 
> [    9.129507] ===================================================
> [    9.129683] [ INFO: suspicious rcu_dereference_check() usage. ]
> [    9.129777] ---------------------------------------------------
> [    9.129872] net/netfilter/nf_log.c:55 invoked rcu_dereference_check() without protection!
> [    9.129969] 
> [    9.129969] other info that might help us debug this:
> [    9.129970] 
> [    9.130232] 
> [    9.130232] rcu_scheduler_active = 1, debug_locks = 0
> [    9.130407] 1 lock held by swapper/1:
> [    9.130525]  #0:  (nf_log_mutex){+.+...}, at: [<ffffffff81481154>] nf_log_register+0x57/0x10f
> [    9.130955] 
> [    9.130956] stack backtrace:
> [    9.131162] Pid: 1, comm: swapper Tainted: G        W   2.6.34-rc5-mmotm0428 #2
> [    9.131259] Call Trace:
> [    9.131370]  [<ffffffff81064832>] lockdep_rcu_dereference+0xaa/0xb2
> [    9.131466]  [<ffffffff814811db>] nf_log_register+0xde/0x10f
> [    9.131579]  [<ffffffff81b5ca28>] ? log_tg_init+0x0/0x29
> [    9.131689]  [<ffffffff81b5ca4d>] log_tg_init+0x25/0x29
> [    9.131800]  [<ffffffff810001ef>] do_one_initcall+0x59/0x14e
> [    9.131912]  [<ffffffff81b2e68a>] kernel_init+0x144/0x1ce
> [    9.132033]  [<ffffffff81003414>] kernel_thread_helper+0x4/0x10
> [    9.132146]  [<ffffffff81598a40>] ? restore_args+0x0/0x30
> [    9.132257]  [<ffffffff81b2e546>] ? kernel_init+0x0/0x1ce
> [    9.132370]  [<ffffffff81003410>] ? kernel_thread_helper+0x0/0x10
> [    9.132513] TCP bic registered
> 

Thanks for the report !

[PATCH] net: nf_log RCU fixes

nf_log_register() and nf_log_unregister() use a mutex to have exclusive
access to nf_logers[]. Use appropriate rcu_dereference_protected()
lockdep annotation.

Reported-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index 015725a..7df37fd 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -52,7 +52,8 @@ int nf_log_register(u_int8_t pf, struct nf_logger *logger)
 	} else {
 		/* register at end of list to honor first register win */
 		list_add_tail(&logger->list[pf], &nf_loggers_l[pf]);
-		llog = rcu_dereference(nf_loggers[pf]);
+		llog = rcu_dereference_protected(nf_loggers[pf],
+						 lockdep_is_held(&nf_log_mutex));
 		if (llog == NULL)
 			rcu_assign_pointer(nf_loggers[pf], logger);
 	}
@@ -70,7 +71,8 @@ void nf_log_unregister(struct nf_logger *logger)
 
 	mutex_lock(&nf_log_mutex);
 	for (i = 0; i < ARRAY_SIZE(nf_loggers); i++) {
-		c_logger = rcu_dereference(nf_loggers[i]);
+		c_logger = rcu_dereference_protected(nf_loggers[i],
+						     lockdep_is_held(&nf_log_mutex));
 		if (c_logger == logger)
 			rcu_assign_pointer(nf_loggers[i], NULL);
 		list_del(&logger->list[i]);


