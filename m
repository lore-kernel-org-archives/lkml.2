Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab2FTNL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 09:11:57 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42219 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340Ab2FTNL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 09:11:56 -0400
Subject: Re: [net-next:master 257/266]
 drivers/net/team/team_mode_loadbalance.c:99:30: sparse: incompatible types
 in comparison expression (different address spaces)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Fengguang Wu <wfg@linux.intel.com>, Jiri Pirko <jpirko@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
In-Reply-To: <20120620124913.GF2432@linux.vnet.ibm.com>
References: <20120620042743.GA7640@localhost>
	 <20120620063607.GA1491@minipsycho> <20120620065055.GA5872@localhost>
	 <20120620124913.GF2432@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jun 2012 15:11:49 +0200
Message-ID: <1340197909.4604.956.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-20 at 05:49 -0700, Paul E. McKenney wrote:
> On Wed, Jun 20, 2012 at 02:50:55PM +0800, Fengguang Wu wrote:
> > [CC Paul, the RCU maintainer]
> > 
> > On Wed, Jun 20, 2012 at 08:36:07AM +0200, Jiri Pirko wrote:
> > > Wed, Jun 20, 2012 at 06:27:43AM CEST, wfg@linux.intel.com wrote:
> > > >Hi Jiri,
> > > >
> > > >There are new sparse warnings show up in
> > > >
> > > >tree:   git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master
> > > >head:   677a3d60fb3153f786a0d28fcf0287670e7bd3c2
> > > >commit: ab8250d70063f77929fc404c02390a1f64d66416 [257/266] team: lb: introduce infrastructure for userspace driven tx loadbalancing
> > > >
> > > >All sparse warnings:
> > > >
> > > >drivers/net/team/team_mode_loadbalance.c:99:30: sparse: incompatible types in comparison expression (different address spaces)
> > > >
> > > >drivers/net/team/team_mode_loadbalance.c:99:
> > > >    96			struct lb_port_mapping *pm;
> > > >    97	
> > > >    98			pm = &lb_priv->ex->tx_hash_to_port_mapping[i];
> > > >  > 99			if (pm->port == port) {
> > > 
> > > This looks like your checker does not like
> > > (struct team_port __rcu *) == (struct team_port *)
> > > But I wonder why (or how should I fix that)
> 
> Because you said that it was an RCU-protected pointer, but then did
> not use an RCU primitive to access it.  In this case, where you are
> just using the value but not dereferencing it, you can use
> rcu_access_pointer().

Yes, and please Jiri change the 

rcu_assign_pointer(pm->port, NULL);

by

RCU_INIT_POINTER(pm->port, NULL);



