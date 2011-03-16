Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058Ab1CPHwu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 03:52:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47791 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab1CPHwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 03:52:44 -0400
Subject: Re: [PATCH v2 2.6.38-rc8-tip 4/20] 4: uprobes: Adding and remove a
 uprobe in a rb tree.
From: Peter Zijlstra <peterz@infradead.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        SystemTap <systemtap@sources.redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1300228944.2565.19.camel@edumazet-laptop>
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6>
	 <20110314133444.27435.50684.sendpatchset@localhost6.localdomain6>
	 <alpine.LFD.2.00.1103151425060.2787@localhost6.localdomain6>
	 <20110315173041.GB24254@linux.vnet.ibm.com>
	 <alpine.LFD.2.00.1103151916120.2787@localhost6.localdomain6>
	 <1300218499.2250.12.camel@laptop>
	 <1300228944.2565.19.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Mar 2011 08:54:27 +0100
Message-ID: <1300262067.2250.49.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-15 at 23:42 +0100, Eric Dumazet wrote:
> Le mardi 15 mars 2011 à 20:48 +0100, Peter Zijlstra a écrit :
> > On Tue, 2011-03-15 at 20:22 +0100, Thomas Gleixner wrote:
> > > I am not sure if its a good idea to walk the tree
> > > > as and when the tree is changing either because of a insertion or
> > > > deletion of a probe.
> > > 
> > > I know that you cannot walk the tree lockless except you would use
> > > some rcu based container for your probes. 
> > 
> > You can in fact combine a seqlock, rb-trees and RCU to do lockless
> > walks.
> > 
> >   https://lkml.org/lkml/2010/10/20/160
> > 
> > and
> > 
> >   https://lkml.org/lkml/2010/10/20/437
> > 
> > But doing that would be an optimization best done once we get all this
> > working nicely.
> > 
> 
> We have such schem in net/ipv4/inetpeer.c function inet_getpeer() (using
> a seqlock on latest net-next-2.6 tree), but we added a counter to make
> sure a reader could not enter an infinite loop while traversing tree

Right, Linus suggested a single lockless iteration, but a limited count
works too.

> (AVL tree in inetpeer case).

Ooh, there's an AVL implementation in the kernel? I have to ask, why not
use the RB-tree? (I know AVL has a slightly stronger balancing condition
which reduces the max depth from 2*log(n) to 1+log(n)).

Also, if it does make sense to have both and AVL and RB implementation,
does it then also make sense to lift the AVL thing to generic code into
lib/ ?

