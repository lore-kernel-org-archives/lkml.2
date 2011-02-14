Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920Ab1BNSyB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 13:54:01 -0500
Received: from blu0-omc1-s37.blu0.hotmail.com ([65.55.116.48]:44484 "EHLO
	blu0-omc1-s37.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751655Ab1BNSx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 13:53:56 -0500
X-Originating-IP: [174.91.193.52]
X-Originating-Email: [pdumas9@sympatico.ca]
Message-ID: <BLU0-SMTP7304A1572FCB87F54CCCFA96D00@phx.gbl>
Date: Mon, 14 Feb 2011 13:53:49 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <peterz@infradead.org>
CC: Will Newton <will.newton@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Jason Baron <jbaron@redhat.com>, hpa@zytor.com, mingo@elte.hu,
        tglx@linutronix.de, andi@firstfloor.org, roland@redhat.com,
        rth@redhat.com, masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        avi@redhat.com, davem@davemloft.net, sam@ravnborg.org,
        ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org, Mike Frysinger <vapier@gentoo.org>,
        Chris Metcalf <cmetcalf@tilera.com>, dhowells <dhowells@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        "heiko.carstens" <heiko.carstens@de.ibm.com>,
        benh <benh@kernel.crashing.org>
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
References: <1297700754.5226.110.camel@laptop> <20110214162947.GA3449@redhat.com> <1297701438.5226.113.camel@laptop> <1297702013.23343.51.camel@gandalf.stny.rr.com> <1297703892.23343.71.camel@gandalf.stny.rr.com> <1297704447.5226.127.camel@laptop> <AANLkTi=pXqya2vaUv2XNwRr6T==MW8ZtQ_yg6V9sipcy@mail.gmail.com> <1297705428.5226.142.camel@laptop> <AANLkTi=jz+mGru--+YA62EeER17Tuq2DocrkKNaU2k+1@mail.gmail.com> <1297707868.5226.189.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1297707868.5226.189.camel@laptop>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 13:48:08 up 313 days,  4:37,  7 users,  load average: 2.08, 1.94,
	1.83
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 14 Feb 2011 18:53:54.0957 (UTC) FILETIME=[876053D0:01CBCC78]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Mon, 2011-02-14 at 17:50 +0000, Will Newton wrote:
> > 
> > It would observe a stale value, but that value would only be updated
> > when the cache line was reloaded from main memory which would have to
> > be triggered by either eviction or cache flushing. So it could get
> > pretty stale. Whilst that's probably within the spec. of atomic_read I
> > suspect it would lead to problems in practice. I could be wrong
> > though. 
> 
> Right, so the typical scenario that could cause pain is something like:
> 
> while (atomic_read(&foo) != n)
>   cpu_relax();
> 
> and the problem is that cpu_relax() doesn't know which particular
> cacheline to flush in order to make things go faster, hm?

As an information point, this is why I mapped "uatomic_read()" to
"CMM_LOAD_SHARED" in my userspace RCU library rather than just doing a
volatile access. On cache-coherent architectures, the arch-specific code
turns CMM_LOAD_SHARED into a simple volatile access, but for
non-cache-coherent architectures, it can call the required
architecture-level primitives to fetch the stale data.

FWIW, I also have "CMM_STORE_SHARED" which does pretty much the same
thing. I use these for rcu_assign_pointer() and rcu_dereference() (thus
replacing "ACCESS_ONCE()").

The more detailed comment and macros are found at
http://git.lttng.org/?p=userspace-rcu.git;a=blob;f=urcu/system.h

I hope this helps,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
