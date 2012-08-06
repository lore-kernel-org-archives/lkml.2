Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382Ab2HFSnr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 14:43:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932273Ab2HFSnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 14:43:45 -0400
Date: Mon, 6 Aug 2012 12:49:14 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: eparis@redhat.com, paulmck@linux.vnet.ibm.com, paul@paul-moore.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Fix sel_netnode_insert suspicious rcu dereference.
Message-ID: <20120806164914.GA25940@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, eparis@redhat.com,
	paulmck@linux.vnet.ibm.com, paul@paul-moore.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <20120605051238.GA30614@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120605051238.GA30614@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2012 at 01:12:39AM -0400, Dave Jones wrote:
 > I reported this a year ago (https://lkml.org/lkml/2011/4/20/308).
 > It's still a problem apparently ...

And another two months pass in silence.

This is happening to other people too.
https://bugzilla.redhat.com/show_bug.cgi?id=846037

Can someone please apply this patch, or at least point out what's wrong with it ?

	Dave

 
 > ===============================
 > [ INFO: suspicious RCU usage. ]
 > 3.5.0-rc1+ #63 Not tainted
 > -------------------------------
 > security/selinux/netnode.c:178 suspicious rcu_dereference_check() usage!
 > 
 > other info that might help us debug this:
 > 
 > 
 > rcu_scheduler_active = 1, debug_locks = 0
 > 1 lock held by trinity-child1/8750:
 >  #0:  (sel_netnode_lock){+.....}, at: [<ffffffff812d8f8a>] sel_netnode_sid+0x16a/0x3e0
 > 
 > stack backtrace:
 > Pid: 8750, comm: trinity-child1 Not tainted 3.5.0-rc1+ #63
 > Call Trace:
 >  [<ffffffff810cec2d>] lockdep_rcu_suspicious+0xfd/0x130
 >  [<ffffffff812d91d1>] sel_netnode_sid+0x3b1/0x3e0
 >  [<ffffffff812d8e20>] ? sel_netnode_find+0x1a0/0x1a0
 >  [<ffffffff812d24a6>] selinux_socket_bind+0xf6/0x2c0
 >  [<ffffffff810cd1dd>] ? trace_hardirqs_off+0xd/0x10
 >  [<ffffffff810cdb55>] ? lock_release_holdtime.part.9+0x15/0x1a0
 >  [<ffffffff81093841>] ? lock_hrtimer_base+0x31/0x60
 >  [<ffffffff812c9536>] security_socket_bind+0x16/0x20
 >  [<ffffffff815550ca>] sys_bind+0x7a/0x100
 >  [<ffffffff816c03d5>] ? sysret_check+0x22/0x5d
 >  [<ffffffff810d392d>] ? trace_hardirqs_on_caller+0x10d/0x1a0
 >  [<ffffffff8133b09e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 >  [<ffffffff816c03a9>] system_call_fastpath+0x16/0x1b
 > 
 > This patch below does what Paul McKenney suggested in the previous thread.
 > 
 > Signed-off-by: Dave Jones <davej@redhat.com>
 > 
 > diff --git a/security/selinux/netnode.c b/security/selinux/netnode.c
 > index 28f911c..c5454c0 100644
 > --- a/security/selinux/netnode.c
 > +++ b/security/selinux/netnode.c
 > @@ -174,7 +174,8 @@ static void sel_netnode_insert(struct sel_netnode *node)
 >  	if (sel_netnode_hash[idx].size == SEL_NETNODE_HASH_BKT_LIMIT) {
 >  		struct sel_netnode *tail;
 >  		tail = list_entry(
 > -			rcu_dereference(sel_netnode_hash[idx].list.prev),
 > +			rcu_dereference_protected(sel_netnode_hash[idx].list.prev,
 > +						  lockdep_is_held(&sel_netnode_lock)),
 >  			struct sel_netnode, list);
 >  		list_del_rcu(&tail->list);
 >  		kfree_rcu(tail, rcu);
 > --
 > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
 > the body of a message to majordomo@vger.kernel.org
 > More majordomo info at  http://vger.kernel.org/majordomo-info.html
 > Please read the FAQ at  http://www.tux.org/lkml/
---end quoted text---
