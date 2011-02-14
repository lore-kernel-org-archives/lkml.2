Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab1BNXDN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 18:03:13 -0500
Received: from blu0-omc1-s6.blu0.hotmail.com ([65.55.116.17]:31488 "EHLO
	blu0-omc1-s6.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751312Ab1BNXDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 18:03:09 -0500
X-Originating-IP: [174.91.193.52]
X-Originating-Email: [pdumas9@sympatico.ca]
Message-ID: <BLU0-SMTP35EF654A11660330F0AFA196D00@phx.gbl>
Date: Mon, 14 Feb 2011 18:03:01 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Matt Fleming <matt@console-pimps.org>
CC: David Miller <davem@davemloft.net>, rostedt@goodmis.org,
        peterz@infradead.org, will.newton@gmail.com, jbaron@redhat.com,
        hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, sam@ravnborg.org,
        ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org, vapier@gentoo.org, cmetcalf@tilera.com,
        dhowells@redhat.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        benh@kernel.crashing.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
References: <1297707868.5226.189.camel@laptop> <1297718964.23343.75.camel@gandalf.stny.rr.com> <1297719576.23343.80.camel@gandalf.stny.rr.com> <20110214.134600.179933733.davem@davemloft.net> <20110214223755.436e7cf4@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20110214223755.436e7cf4@mfleming-mobl1.ger.corp.intel.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 17:55:46 up 313 days,  8:45,  7 users,  load average: 1.16, 1.41,
	1.42
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 14 Feb 2011 23:03:07.0821 (UTC) FILETIME=[57FA4DD0:01CBCC9B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matt Fleming (matt@console-pimps.org) wrote:
> On Mon, 14 Feb 2011 13:46:00 -0800 (PST)
> David Miller <davem@davemloft.net> wrote:
> 
> > From: Steven Rostedt <rostedt@goodmis.org>
> > Date: Mon, 14 Feb 2011 16:39:36 -0500
> > 
> > > Thus it is not about global, as global is updated by normal means
> > > and will update the caches. atomic_t is updated via the ll/sc that
> > > ignores the cache and causes all this to break down. IOW... broken
> > > hardware ;)
> > 
> > I don't see how cache coherency can possibly work if the hardware
> > behaves this way.
> 
> Cache coherency is still maintained provided writes/reads both go
> through the cache ;-)
> 
> The problem is that for read-modify-write operations the arbitration
> logic that decides who "wins" and is allowed to actually perform the
> write, assuming two or more CPUs are competing for a single memory
> address, is not implemented in the cache controller, I think. I'm not a
> hardware engineer and I never understood how the arbitration logic
> worked but I'm guessing that's the reason that the ll/sc instructions
> bypass the cache.
> 
> Which is why the atomic_t functions worked out really well for that
> arch, such that any accesses to an atomic_t * had to go through the
> wrapper functions.

If this is true, then we have bugs in lots of xchg/cmpxchg users (which
do not reside in atomic.h), e.g.:

fs/fs_struct.c:
int current_umask(void)
{
        return current->fs->umask;
}
EXPORT_SYMBOL(current_umask);

kernel/sys.c:
SYSCALL_DEFINE1(umask, int, mask)
{
        mask = xchg(&current->fs->umask, mask & S_IRWXUGO);
        return mask;
}

The solution to this would be to force all xchg/cmpxchg users to swap to
atomic.h variables, which would force the ll semantic on read. But I'd
really like to see where this is documented first -- or which PowerPC
engineer we should talk to.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
