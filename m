Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268Ab0EMCAQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 22:00:16 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:51868 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754723Ab0EMCAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 22:00:14 -0400
Date: Wed, 12 May 2010 19:00:08 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       eric.dumazet@gmail.com, Arnd Bergmann <arnd@arndb.de>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH RFC tip/core/rcu 04/23] net: Make accesses to ->br_port
 safe for sparse RCU
Message-ID: <20100513020008.GA2704@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100512213317.GA15085@linux.vnet.ibm.com>
 <1273700022-16523-4-git-send-email-paulmck@linux.vnet.ibm.com>
 <20100512144453.4df81bdd@nehalam>
 <20100512223525.GG2303@linux.vnet.ibm.com>
 <20100512183359.4829ff0e@nehalam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100512183359.4829ff0e@nehalam>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 06:33:59PM -0700, Stephen Hemminger wrote:
> On Wed, 12 May 2010 15:35:25 -0700
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> > On Wed, May 12, 2010 at 02:44:53PM -0700, Stephen Hemminger wrote:
> > > On Wed, 12 May 2010 14:33:23 -0700
> > > "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> > > 
> > > > diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
> > > > index 9101a4e..3f66cd1 100644
> > > > --- a/net/bridge/br_fdb.c
> > > > +++ b/net/bridge/br_fdb.c
> > > > @@ -246,7 +246,7 @@ int br_fdb_test_addr(struct net_device *dev, unsigned char *addr)
> > > >  		return 0;
> > > >  
> > > >  	rcu_read_lock();
> > > > -	fdb = __br_fdb_get(dev->br_port->br, addr);
> > > > +	fdb = __br_fdb_get(br_port(dev)->br, addr);
> > > >  	ret = fdb && fdb->dst->dev != dev &&
> > > >  		fdb->dst->state == BR_STATE_FORWARDING;
> > > >  	rcu_read_unlock();
> > > > diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> > > > index 846d7d1..4fedb60 100644
> > > > --- a/net/bridge/br_private.h
> > > > +++ b/net/bridge/br_private.h
> > > > @@ -229,6 +229,14 @@ static inline int br_is_root_bridge(const struct net_bridge *br)
> > > >  	return !memcmp(&br->bridge_id, &br->designated_root, 8);
> > > >  }
> > > >  
> > > > +static inline struct net_bridge_port *br_port(const struct net_device *dev)
> > > > +{
> > > > +	if (!dev)
> > > > +		return NULL;
> > > > +
> > > > +	return rcu_dereference(dev->br_port);
> > > > +}
> > > 
> > > Looks like this is wrapping existing problems, and hurting not helping.
> > > 
> > > Why introduce a wrapper that could return NULL and not check the
> > > result?
> > 
> > Fair point!
> > 
> > > I would rather that:
> > >    1. dev should never be null in this cases so the first if() is 
> > >       unnecessary, and confuses the semantics.
> > >    2. don't use wrapper br_port()
> > >    3. have callers check that rcu_dereference(dev->br_port) did not
> > >       return NULL.
> > >       If they derefernce does return NULL, then it means other CPU
> > >       has started tear down and this CPU should just go home quietly.
> > 
> > OK.
> > 
> > The reason for br_port() is to allow ->br_port to be a void*.  If we
> > eliminate br_port(), then it is necessary to make the definition of the
> > struct net_bridge_port available everywhere that ->br_port is given to
> > rcu_dereference().  The reason for this is that Arnd's sparse-based RCU
> > checking code uses __rcu to tag the data pointed to by an RCU-protected
> > pointer.  This in turn means that rcu_dereference() and friends must
> > now have access to the pointed-to type, as is done in patch 6 in this
> > series.
> 
> Then ok. leave the wrapper, but get rid of the !dev part.
> 
> I can do it if you want.

Done!

I would normally accept your offer in a heartbeat, but there are
dependencies among the patches.  :-(

> Still don't like changing working code to conform to code checking tools.
> Especially when code checking tool is missing bad RCU usage that already
> exists (like this case). It is a big problem if code assumes rcu_deref
> always returns non NULL.

Indeed, I would have liked some way of making this work without having
to make rcu_dereference() know about the pointed-too type.  I have not
yet been able to find one, though.  :-(

							Thanx, Paul
