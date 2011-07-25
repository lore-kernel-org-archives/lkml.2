Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370Ab1GYRIl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 13:08:41 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43576 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab1GYRIk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 13:08:40 -0400
Subject: Re: [patch 00/18] CFS Bandwidth Control v7.2
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Jason Baron <jbaron@redhat.com>
In-Reply-To: <20110725164619.GK2327@linux.vnet.ibm.com>
References: <20110721164325.231521704@google.com>
	 <1311605881.24752.2.camel@twins> <1311606041.24752.3.camel@twins>
	 <20110725162133.GI2327@linux.vnet.ibm.com> <1311611311.24752.5.camel@twins>
	 <20110725164619.GK2327@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 25 Jul 2011 19:08:14 +0200
Message-ID: <1311613694.24752.8.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-25 at 09:46 -0700, Paul E. McKenney wrote:
> On Mon, Jul 25, 2011 at 06:28:31PM +0200, Peter Zijlstra wrote:
> > On Mon, 2011-07-25 at 09:21 -0700, Paul E. McKenney wrote:
> > > On Mon, Jul 25, 2011 at 05:00:41PM +0200, Peter Zijlstra wrote:
> > > > On Mon, 2011-07-25 at 16:58 +0200, Peter Zijlstra wrote:
> > > > > +               rcu_read_lock();
> > > > > +               ret = walk_tg_tree_from(tg, tg_set_cfs_period_down, NULL, &period);
> > > > > +               rcu_read_unlock(); 
> > > > 
> > > > rcu over a mutex doesn't really work in mainline, bah.. 
> > > 
> > > SRCU can handle that situation, FWIW.  But yes, blocking in an RCU
> > > read-side critical section is a no-no.
> > 
> > Yeah, I know, but didn't notice until after I sent.. SRCU isn't useful
> > though, way too slow due to lacking srcu_call().
> 
> Good point.  How frequently would a call_srcu() be invoked?
> 
> In other words, would a really crude hack involving a globally locked
> per-srcu_struct callback list and a per-srcu_struct kernel thread be
> helpful, or would a slightly less-crude hack involving a per-CPU callback
> list be required?

it would be invoked every time someone kills a cgroup, which I would
consider a slow path, but some folks out there seem to think otherwise
and create/destoy these things like they're free (there was a discussion
about this some time ago about optimizing the cgroup destroy path
etc..).

Anyway, I think I can sort this particular problem by simply wrapping
the whole crap in cgroup_lock(),cgroup_unlock(). If we want to go this
way anyway.

I consider setting the cgroup paramaters an utter slow path, and if
people complain I'll simply tell them to sod off ;-)
