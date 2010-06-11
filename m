Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932698Ab0FKUqx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 16:46:53 -0400
Received: from mail.openrapids.net ([64.15.138.104]:45204 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932621Ab0FKUqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 16:46:51 -0400
Date: Fri, 11 Jun 2010 16:46:48 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sequence lock in Linux
Message-ID: <20100611204648.GA20360@Krystal>
References: <20100611194016.GA5213@Krystal> <20100611200700.GG2394@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100611200700.GG2394@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 16:46:06 up 139 days, 23:23,  7 users,  load average: 0.07, 0.14,
	0.16
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Fri, Jun 11, 2010 at 03:40:16PM -0400, Mathieu Desnoyers wrote:
> > Hi Paul,
> > 
> > (CCing lkml)
> > 
> > Is it just me, or the following code:
> > 
> > static __always_inline unsigned read_seqbegin(const seqlock_t *sl)
> > {
> >         unsigned ret;
> > 
> > repeat:
> >         ret = sl->sequence;
> >         smp_rmb();
> >         if (unlikely(ret & 1)) {
> >                 cpu_relax();
> >                 goto repeat;
> >         }
> > 
> >         return ret;
> > }
> > 
> > could use a ACCESS_ONCE() around the sl->sequence read ? I'm concerned about the
> > compiler generating code that reads the sequence number chunkwise.
> > 
> > The same apply to all other reads of the sequence number in seqlock.h (including
> > the retry code).
> > 
> > Thoughts ?
> 
> Doesn't gcc guarantee that accesses to aligned basic types that fit into
> a machine word are loaded and stored in one shot?  Now, gcc might choose
> to load twice (or to merge loads) due to things like register pressure,
> but given that ->sequence is an int, gcc should not be accessing it
> (say) bytewise on any platform supporting 32-bit accesses.
> 
> Or am I suffering from wishful thinking here?

Hopefully not. I might be the one suffering from extreme compiler distrust here.
;-)

Mathieu

> 
> 							Thanx, Paul

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
