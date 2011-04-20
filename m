Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740Ab1DTTaG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 15:30:06 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:40707 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847Ab1DTTaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 15:30:05 -0400
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: Eric Paris <eparis@redhat.com>
Subject: Re: suspicious rcu_dereference_check in security/selinux/netnode.c
Date: Wed, 20 Apr 2011 15:29:59 -0400
User-Agent: KMail/1.13.6 (Linux/2.6.38-gentoo-r2; KDE/4.6.2; x86_64; ; )
Cc: Dave Jones <davej@redhat.com>, sds@tycho.nsa.gov, jmorris@namei.org,
        eparis@parisplace.org, Linux Kernel <linux-kernel@vger.kernel.org>,
        selinux@tycho.nsa.gov
References: <20110420183543.GA11965@redhat.com> <1303324924.1708.31.camel@unknown001a4b0c2895>
In-Reply-To: <1303324924.1708.31.camel@unknown001a4b0c2895>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201104201530.00140.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 20, 2011 2:42:04 PM Eric Paris wrote:
> [added paul] EOM
> 
> On Wed, 2011-04-20 at 14:35 -0400, Dave Jones wrote:
> > ===================================================
> > 
> >  [ INFO: suspicious rcu_dereference_check() usage. ]
> >  ---------------------------------------------------
> >  security/selinux/netnode.c:193 invoked rcu_dereference_check() without
> >  protection!
> >  
> >  other info that might help us debug this:
> >  
> >  rcu_scheduler_active = 1, debug_locks = 0
> >  
> >  1 lock held by a.out/2018:
> >   #0:  (sel_netnode_lock){+.....}, at: [<ffffffff81212ab7>]
> >   sel_netnode_sid+0x9e/0x267
> >  
> >  stack backtrace:
> >  Pid: 2018, comm: a.out Not tainted 2.6.39-rc4+ #3
> >  
> >  Call Trace:
> >   [<ffffffff81084908>] lockdep_rcu_dereference+0xa8/0xb0
> >   [<ffffffff81212c0d>] sel_netnode_sid+0x1f4/0x267
> >   [<ffffffff81212a19>] ? sel_netnode_find+0xe3/0xe3
> >   [<ffffffff8120d564>] selinux_socket_bind+0x1cf/0x26f
> >   [<ffffffff81086c08>] ? lock_release+0x181/0x18e
> >   [<ffffffff81100db8>] ? might_fault+0xa5/0xac
> >   [<ffffffff81100d6f>] ? might_fault+0x5c/0xac
> >   [<ffffffff812073f1>] security_socket_bind+0x16/0x18
> >   [<ffffffff813ee0e9>] sys_bind+0x73/0xcf
> >   [<ffffffff814c5d7a>] ? sysret_check+0x2e/0x69
> >   [<ffffffff810870cf>] ? trace_hardirqs_on_caller+0x10b/0x12f
> >   [<ffffffff810a9efb>] ? audit_syscall_entry+0x11c/0x148
> >   [<ffffffff81255e2e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> >   [<ffffffff814c5d42>] system_call_fastpath+0x16/0x1b
> > 
> > something like this perhaps ?
> > 
> > 	Dave
> > 
> > diff --git a/security/selinux/netnode.c b/security/selinux/netnode.c
> > index 65ebfe9..d0c38ba 100644
> > --- a/security/selinux/netnode.c
> > +++ b/security/selinux/netnode.c
> > @@ -188,9 +188,11 @@ static void sel_netnode_insert(struct sel_netnode
> > *node)
> > 
> >  	list_add_rcu(&node->list, &sel_netnode_hash[idx].list);
> >  	if (sel_netnode_hash[idx].size == SEL_NETNODE_HASH_BKT_LIMIT) {
> >  	
> >  		struct sel_netnode *tail;
> > 
> > +		rcu_read_lock();
> > 
> >  		tail = list_entry(
> >  		
> >  			rcu_dereference(sel_netnode_hash[idx].list.prev),
> >  			struct sel_netnode, list);
> > 
> > +		rcu_read_unlock();
> > 
> >  		list_del_rcu(&tail->list);
> >  		call_rcu(&tail->rcu, sel_netnode_free);
> >  	
> >  	} else

[Ooops, forgot to hit reply-all on the first attempt]

Hmm, I think the correct fix might be to just remove the rcu_dereference() 
call since this is protected by a spin lock (see sel_netnode_sid_slow()).  I 
may be wrong, but I thought rcu locks/derefs were not needed when a spin lock 
was held, yes?

Regardless of the fix, the same thing should probably be done to the 
sel_netport_* versions of these functions.

--
paul moore
linux @ hp
