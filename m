Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758323Ab1BKW2h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 17:28:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757958Ab1BKW2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 17:28:35 -0500
Date: Fri, 11 Feb 2011 17:27:42 -0500
From: Jason Baron <jbaron@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Peter Zijlstra <peterz@infradead.org>, hpa@zytor.com, rostedt@goodmis.org,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
Message-ID: <20110211222742.GB9148@redhat.com>
References: <cover.1294239591.git.jbaron@redhat.com> <1297452328.5226.89.camel@laptop> <BLU0-SMTP101B686C32E10BA346B15F896EF0@phx.gbl> <1297460297.5226.99.camel@laptop> <BLU0-SMTP8562BA758CF8AAE5323AE296EF0@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BLU0-SMTP8562BA758CF8AAE5323AE296EF0@phx.gbl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 11, 2011 at 05:20:25PM -0500, Mathieu Desnoyers wrote:
> * Peter Zijlstra (peterz@infradead.org) wrote:
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
> > So why can't we make that jump_label_entry::refcount and
> > jump_label_key::state an atomic_t and be done with it?
> > 
> > Then the enabled case uses if (atomic_inc_return(&key->ptr->refcount) ==
> > 1), and the disabled atomic_inc(&key->state).
> > 
> 
> OK, by "enabled" you mean #if defined(CC_HAVE_ASM_GOTO) &&
> defined(CONFIG_JUMP_LABEL), and "disabled", the #else.
> 
> I guess the only downside is the extra volatile for the atomic_read for
> the fallback case, which is not really much of problem realistically
> speaking: anyway, the volatile is a good thing to have in the fallback
> case to force the compiler to re-read the variable. Let's go with your
> idea.
> 
> Thanks,
> 
> Mathieu
> 

ok, I'll try and re-spin the interface based around atomic_t, if we are all
agreed...there was also a circular dependency issue with atomic.h including
kernel.h which included jump_label.h, and that was why we had a separate,
jump_label_ref.h header file, but hopefully I can be resolve that in a clean
way.

thanks,

-Jason
