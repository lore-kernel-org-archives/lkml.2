Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab0G3VdE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 17:33:04 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:59729 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342Ab0G3Vc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 17:32:59 -0400
Date: Fri, 30 Jul 2010 14:32:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] cred - synchronize rcu before releasing cred
Message-ID: <20100730213256.GA2470@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100729060004.GD2447@linux.vnet.ibm.com>
 <18537.1280318862@redhat.com>
 <AANLkTikB9Msot4m_oaw+V+dvEg+SzyXHb0cqhKQqUtC2@mail.gmail.com>
 <20100727155023.GF1967@jolsa.brq.redhat.com>
 <AANLkTineVrcffFWGxQ+EzYno6xvcNS9=M7hn_KddASnQ@mail.gmail.com>
 <24865.1280249187@redhat.com>
 <32758.1280321226@redhat.com>
 <30107.1280392460@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30107.1280392460@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 09:34:20AM +0100, David Howells wrote:
> Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > It is perfectly legal for an RCU callback to invoke call_rcu().  However,
> > this should be used -only- to wait for RCU readers.  If there are no
> > RCU readers, the callback might be re-invoked in very short order,
> > expecially on UP systems.
> > 
> > Or am I misunderstanding what you mean by "require call_rcu() to be
> > able to cope iwth requeueing"?
> 
> I mean for call_rcu() to be called on an object that's already been
> call_rcu()'d but not yet processed.

That would indeed be very bad!!!

> For example if struct cred gets its usage count reduced to 0, __put_cred()
> will call_rcu() it, but what happens if someone comes along and resurrects it
> by increasing its usage count again?  And what happens if the usage count is
> reduced back to zero and __put_cred() calls call_rcu() again before
> put_cred_rcu() has a chance to run?

Doing this would mess up RCU's internal data structures.  Mathieu
Desnoyers's recent debug changes (DEBUG_OBJECTS_RCU_HEAD) would catch
this sort of error.

							Thanx, Paul
