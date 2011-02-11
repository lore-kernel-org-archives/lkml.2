Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757039Ab1BKVUP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 16:20:15 -0500
Received: from blu0-omc1-s15.blu0.hotmail.com ([65.55.116.26]:42590 "EHLO
	blu0-omc1-s15.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755595Ab1BKVUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 16:20:13 -0500
X-Greylist: delayed 371 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Feb 2011 16:20:13 EST
X-Originating-IP: [174.91.193.52]
X-Originating-Email: [pdumas9@sympatico.ca]
Message-ID: <BLU0-SMTP334BCE5197D30089989ECB96EF0@phx.gbl>
Date: Fri, 11 Feb 2011 16:13:56 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <peterz@infradead.org>
CC: Jason Baron <jbaron@redhat.com>, hpa@zytor.com, rostedt@goodmis.org,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
References: <cover.1294239591.git.jbaron@redhat.com> <1297452328.5226.89.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1297452328.5226.89.camel@laptop>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 15:50:59 up 310 days,  6:40,  4 users,  load average: 0.16, 0.12,
	0.04
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 11 Feb 2011 21:14:01.0612 (UTC) FILETIME=[9AE4D4C0:01CBCA30]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Wed, 2011-01-05 at 10:43 -0500, Jason Baron wrote:
> > Hi,
> > 
> > The first patch uses the storage space of the jump label key address
> > as a pointer into the update table. In this way, we can find all
> > the addresses that need to be updated without hashing.
> > 
> > The second patch introduces:
> > 
> > static __always_inline bool static_branch(struct jump_label_key *key);
> > 
> > instead of the old JUMP_LABEL(key, label) macro.
> > 
> > In this way, jump labels become really easy to use:
> > 
> > Define:
> > 
> >         struct jump_label_key jump_key;
> > 
> > Can be used as:
> > 
> >         if (static_branch(&jump_key))
> >                 do unlikely code
> > 
> > enable/disale via:
> > 
> >         jump_label_enable(&jump_key);
> >         jump_label_disable(&jump_key);
> > 
> > that's it!
> > 
> > For perf, which also uses jump labels, I've left the reference counting
> > out of the jump label layer, thus removing the 'jump_label_inc()' and
> > 'jump_label_dec()' interface. Hopefully, this is a more palatable solution.
> 
> Right, lets go with this. Maybe we'll manage to come up with something
> saner than _else_atomic_read(), but for now its an improvement over what
> we have.

I agree that keeping jump_label.h with the minimal clean API is a good
goal, and this patchset is almost there (maybe except for the
_else_atomic_read() part).

Hrm, given that the atomic inc/dec return and test for 1/0 is moved into
the Perf code, I wonder if it would make sense to move the
"_else_atomic_read()" oddness into the perf code too ? Perf could
declare, in its own header, a wrapper over __static_branch, e.g. put in
perf_event.h:

#ifdef HAVE_JUMP_LABEL
static __always_inline
bool perf_sw_event_static_branch_refcount(struct jump_label_key *key,
                                          atomic_t *ref)
{
	return __static_branch(key);
}
#else
static __always_inline
bool perf_sw_event_static_branch_refcount(struct jump_label_key *key,
                                          atomic_t *ref)
{
	if (unlikely(atomic_read(ref)))
		return true;
	return false;
}
#endif

Otherwise, jump_label_ref.h looks like an half-baked interface that only
provides the "test" API but not the ref/unref. If we have only a single
user interested in refcounting, it might make more sense to put the code
in perf_event.h. If we have many users using an atomic refcount like
this, then we should extend jump_label_ref.h to also provide the
ref/unref API too. I don't care much about where it ends up, as long as
it's a consistent choice.

Thoughts ?

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
