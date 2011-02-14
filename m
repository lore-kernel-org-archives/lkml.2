Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab1BNX35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 18:29:57 -0500
Received: from blu0-omc1-s18.blu0.hotmail.com ([65.55.116.29]:21860 "EHLO
	blu0-omc1-s18.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751456Ab1BNX3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 18:29:54 -0500
X-Originating-IP: [174.91.193.52]
X-Originating-Email: [pdumas9@sympatico.ca]
Message-ID: <BLU0-SMTP5339CE773666C101DDC39A96D00@phx.gbl>
Date: Mon, 14 Feb 2011 18:29:47 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Matt Fleming <matt@console-pimps.org>, David Miller <davem@davemloft.net>,
        rostedt@goodmis.org, peterz@infradead.org, will.newton@gmail.com,
        jbaron@redhat.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org, vapier@gentoo.org, cmetcalf@tilera.com,
        dhowells@redhat.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        benh@kernel.crashing.org,
        Segher Boessenkool <segher@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
References: <1297707868.5226.189.camel@laptop> <1297718964.23343.75.camel@gandalf.stny.rr.com> <1297719576.23343.80.camel@gandalf.stny.rr.com> <20110214.134600.179933733.davem@davemloft.net> <20110214223755.436e7cf4@mfleming-mobl1.ger.corp.intel.com> <BLU0-SMTP166A8555C791786059B0FF96D00@phx.gbl> <20110214230902.GM2256@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20110214230902.GM2256@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 18:26:02 up 313 days,  9:15,  6 users,  load average: 1.78, 1.51,
	1.41
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 14 Feb 2011 23:29:53.0118 (UTC) FILETIME=[14CF2FE0:01CBCC9F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ added Segher Boessenkool and Paul Mackerras to CC list ]

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Mon, Feb 14, 2011 at 06:03:01PM -0500, Mathieu Desnoyers wrote:
> > * Matt Fleming (matt@console-pimps.org) wrote:
> > > On Mon, 14 Feb 2011 13:46:00 -0800 (PST)
> > > David Miller <davem@davemloft.net> wrote:
> > > 
> > > > From: Steven Rostedt <rostedt@goodmis.org>
> > > > Date: Mon, 14 Feb 2011 16:39:36 -0500
> > > > 
> > > > > Thus it is not about global, as global is updated by normal means
> > > > > and will update the caches. atomic_t is updated via the ll/sc that
> > > > > ignores the cache and causes all this to break down. IOW... broken
> > > > > hardware ;)
> > > > 
> > > > I don't see how cache coherency can possibly work if the hardware
> > > > behaves this way.
> > > 
> > > Cache coherency is still maintained provided writes/reads both go
> > > through the cache ;-)
> > > 
> > > The problem is that for read-modify-write operations the arbitration
> > > logic that decides who "wins" and is allowed to actually perform the
> > > write, assuming two or more CPUs are competing for a single memory
> > > address, is not implemented in the cache controller, I think. I'm not a
> > > hardware engineer and I never understood how the arbitration logic
> > > worked but I'm guessing that's the reason that the ll/sc instructions
> > > bypass the cache.
> > > 
> > > Which is why the atomic_t functions worked out really well for that
> > > arch, such that any accesses to an atomic_t * had to go through the
> > > wrapper functions.
> 
> ???
> 
> What CPU family are we talking about here?  For cache coherent CPUs,
> cache coherence really is supposed to work, even for mixed atomic and
> non-atomic instructions to the same variable.
> 

I'm really curious to know which CPU families too. I've used git blame
to see where these lwz/stw instructions were added to powerpc, and it
points to:

commit 9f0cbea0d8cc47801b853d3c61d0e17475b0cc89
Author: Segher Boessenkool <segher@kernel.crashing.org>
Date:   Sat Aug 11 10:15:30 2007 +1000

    [POWERPC] Implement atomic{, 64}_{read, write}() without volatile
    
    Instead, use asm() like all other atomic operations already do.
    
    Also use inline functions instead of macros; this actually
    improves code generation (some code becomes a little smaller,
    probably because of improved alias information -- just a few
    hundred bytes total on a default kernel build, nothing shocking).
    
    Signed-off-by: Segher Boessenkool <segher@kernel.crashing.org>
    Signed-off-by: Paul Mackerras <paulus@samba.org>

So let's ping the relevant people to see if there was any reason for
making these atomic read/set operations different from other
architectures in the first place.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
