Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758309Ab1BKWaZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 17:30:25 -0500
Received: from blu0-omc1-s10.blu0.hotmail.com ([65.55.116.21]:61185 "EHLO
	blu0-omc1-s10.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756829Ab1BKWaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 17:30:24 -0500
X-Originating-IP: [174.91.193.52]
X-Originating-Email: [pdumas9@sympatico.ca]
Message-ID: <BLU0-SMTP93C16EC5C12B6902797C4896EF0@phx.gbl>
Date: Fri, 11 Feb 2011 17:30:18 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jason Baron <jbaron@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, hpa@zytor.com, rostedt@goodmis.org,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
References: <cover.1294239591.git.jbaron@redhat.com> <1297452328.5226.89.camel@laptop> <BLU0-SMTP101B686C32E10BA346B15F896EF0@phx.gbl> <1297460297.5226.99.camel@laptop> <20110211221550.GA9148@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20110211221550.GA9148@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 17:21:42 up 310 days,  8:11,  5 users,  load average: 0.31, 0.19,
	0.07
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 11 Feb 2011 22:30:23.0589 (UTC) FILETIME=[45F70950:01CBCA3B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jason Baron (jbaron@redhat.com) wrote:
> On Fri, Feb 11, 2011 at 10:38:17PM +0100, Peter Zijlstra wrote:
> > On Fri, 2011-02-11 at 16:13 -0500, Mathieu Desnoyers wrote:
> > > 
> > > Thoughts ? 
> > 
> >  #if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
> > +
> > +struct jump_label_key {
> > +       void *ptr;
> > +};
> > 
> >  struct jump_label_entry {
> >         struct hlist_node hlist;
> >         struct jump_entry *table;
> > -       int nr_entries;
> >         /* hang modules off here */
> >         struct hlist_head modules;
> >         unsigned long key;
> > +       u32 nr_entries;
> > +       int refcount;
> >  };
> > 
> > #else
> > 
> > +struct jump_label_key {
> > +       int state;
> > +};
> > 
> > #endif
> > 
> > 
> > 
> > So why can't we make that jump_label_entry::refcount and
> > jump_label_key::state an atomic_t and be done with it?
> > 
> > Then the enabled case uses if (atomic_inc_return(&key->ptr->refcount) ==
> > 1), and the disabled atomic_inc(&key->state).
> > 
> 
> a bit of history...
> 
> For the disabled jump label case, we didn't want to incur an atomic_read() to
> check if the branch was enabled.
> 
> So, I separated the API, to have one for the non-atomic case, and one
> for the atomic case. Nobody liked that.
> 
> So now, I'm proposing to leave the core API based around a non-atomic
> variable, and have any callers that want to use this atomic interface,
> to call into the non-atomic interface. If another user besides perf
> wants to use the same type of atomic interface, we can re-visit the
> decsion? 

See my other email to PeterZ. I think it might be better to keep the
interface really clean and take compiler optimization hit on the
volatile if we figure out that it is negligible. I'd love to see
benchmarks on the impact of this change to justify that we can actually
dismiss the performance impact. We have enough tracepoints in the kernel
that if we figure out that it does not make a noticeable performance
difference in !JUMP_LABEL configs with tracepoints enabled, we can as
well take the volatile. But please document these benchmarks in the
patch changelog. Also looking at the disassembly of core instrumented
kernel functions to see if the added volatile hurts the basic block
ordering, and documenting that, would be helpful.

I'd recommend a jump_label_ref()/jump_label_unref() interface (similar
to kref) intead of enable/disable through (to make it clear that we have
reference counter handling in there).

Long story short: I'm not against adding the volatile read here. I'm
against adding it without measuring and documenting the impact of this
change.

Thanks,

Mathieu

> 
> thanks,
> 
> -Jason

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
