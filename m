Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758341Ab1BKWc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 17:32:56 -0500
Received: from blu0-omc1-s13.blu0.hotmail.com ([65.55.116.24]:63763 "EHLO
	blu0-omc1-s13.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757891Ab1BKWcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 17:32:55 -0500
X-Originating-IP: [174.91.193.52]
X-Originating-Email: [pdumas9@sympatico.ca]
Message-ID: <BLU0-SMTP693E1E8E9752782BC3AB1E96EF0@phx.gbl>
Date: Fri, 11 Feb 2011 17:32:49 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jason Baron <jbaron@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, hpa@zytor.com, rostedt@goodmis.org,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
References: <cover.1294239591.git.jbaron@redhat.com> <1297452328.5226.89.camel@laptop> <BLU0-SMTP101B686C32E10BA346B15F896EF0@phx.gbl> <1297460297.5226.99.camel@laptop> <BLU0-SMTP8562BA758CF8AAE5323AE296EF0@phx.gbl> <20110211222742.GB9148@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20110211222742.GB9148@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 17:30:54 up 310 days,  8:20,  6 users,  load average: 0.13, 0.14,
	0.09
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 11 Feb 2011 22:32:53.0877 (UTC) FILETIME=[9F8B2A50:01CBCA3B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jason Baron (jbaron@redhat.com) wrote:
> On Fri, Feb 11, 2011 at 05:20:25PM -0500, Mathieu Desnoyers wrote:
> > * Peter Zijlstra (peterz@infradead.org) wrote:
> > > On Fri, 2011-02-11 at 16:13 -0500, Mathieu Desnoyers wrote:
> > > > 
> > > > Thoughts ? 
> > > 
> > >  #if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
> > > +
> > > +struct jump_label_key {
> > > +       void *ptr;
> > > +};
> > > 
> > >  struct jump_label_entry {
> > >         struct hlist_node hlist;
> > >         struct jump_entry *table;
> > > -       int nr_entries;
> > >         /* hang modules off here */
> > >         struct hlist_head modules;
> > >         unsigned long key;
> > > +       u32 nr_entries;
> > > +       int refcount;
> > >  };
> > > 
> > > #else
> > > 
> > > +struct jump_label_key {
> > > +       int state;
> > > +};
> > > 
> > > #endif
> > > 
> > > So why can't we make that jump_label_entry::refcount and
> > > jump_label_key::state an atomic_t and be done with it?
> > > 
> > > Then the enabled case uses if (atomic_inc_return(&key->ptr->refcount) ==
> > > 1), and the disabled atomic_inc(&key->state).
> > > 
> > 
> > OK, by "enabled" you mean #if defined(CC_HAVE_ASM_GOTO) &&
> > defined(CONFIG_JUMP_LABEL), and "disabled", the #else.
> > 
> > I guess the only downside is the extra volatile for the atomic_read for
> > the fallback case, which is not really much of problem realistically
> > speaking: anyway, the volatile is a good thing to have in the fallback
> > case to force the compiler to re-read the variable. Let's go with your
> > idea.
> > 
> > Thanks,
> > 
> > Mathieu
> > 
> 
> ok, I'll try and re-spin the interface based around atomic_t, if we are all
> agreed...there was also a circular dependency issue with atomic.h including
> kernel.h which included jump_label.h, and that was why we had a separate,
> jump_label_ref.h header file, but hopefully I can be resolve that in a clean
> way.

See spinlocks ?

jump_label_types.h (structure definitions, includes types.h,
                    included from kernel.h)
jump_label.h (prototypes, inline functions, includes atomic.h)

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
