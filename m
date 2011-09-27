Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631Ab1I0N1t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 09:27:49 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:36368 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab1I0N1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 09:27:48 -0400
Date: Tue, 27 Sep 2011 18:42:13 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 3.1.0-rc4-tip 26/26]   uprobes: queue signals while
 thread is singlestepping.
Message-ID: <20110927131213.GE3685@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com>
 <20110920120517.25326.57657.sendpatchset@srdronam.in.ibm.com>
 <1317128626.15383.61.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1317128626.15383.61.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2011-09-27 15:03:46]:

> On Tue, 2011-09-20 at 17:35 +0530, Srikar Dronamraju wrote:
> > +#ifdef CONFIG_UPROBES
> > +       if (!group && t->utask && t->utask->active_uprobe)
> > +               pending = &t->utask->delayed;
> > +#endif
> > +
> >         /*
> >          * Short-circuit ignored signals and support queuing
> >          * exactly one non-rt signal, so that we can get more
> > @@ -1106,6 +1111,11 @@ static int __send_signal(int sig, struct siginfo *info, struct task_struct *t,
> >                 }
> >         }
> >  
> > +#ifdef CONFIG_UPROBES
> > +       if (!group && t->utask && t->utask->active_uprobe)
> > +               return 0;
> > +#endif
> > +
> >  out_set:
> >         signalfd_notify(t, sig);
> >         sigaddset(&pending->signal, sig);
> > @@ -1569,6 +1579,13 @@ int send_sigqueue(struct sigqueue *q, struct task_struct *t, int group)
> >         }
> >         q->info.si_overrun = 0;
> >  
> > +#ifdef CONFIG_UPROBES
> > +       if (!group && t->utask && t->utask->active_uprobe) {
> > +               pending = &t->utask->delayed;
> > +               list_add_tail(&q->list, &pending->list);
> > +               goto out;
> > +       }
> > +#endif
> >         signalfd_notify(t, sig);
> >         pending = group ? &t->signal->shared_pending : &t->pending;
> >         list_add_tail(&q->list, &pending->list);
> > @@ -2199,7 +2216,10 @@ int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka,
> >                         spin_unlock_irq(&sighand->siglock);
> >                         goto relock;
> >                 }
> > -
> > +#ifdef CONFIG_UPROBES
> > +               if (current->utask && current->utask->active_uprobe)
> > +                       break;
> > +#endif 
> 
> That's just crying for something like:
> 
> #ifdef CONFIG_UPROBES
> static inline bool uprobe_delay_signal(struct task_struct *p)
> {
> 	return p->utask && p->utask->active_uprobe;
> }
> #else
> static inline bool uprobe_delay_signal(struct task_struct *p)
> {
> 	return false;
> }
> #endif
> 
> That'll instantly kill the #ifdeffery as well as describe wtf you're
> actually doing.


Okay, 

I did a rethink and implemented this patch a little differently using
block_all_signals, unblock_all_signals. This wouldnt need the 
#ifdeffery + no changes in kernel/signal.c

Will post the same in the next patchset.

-- 
Thanks and Regards
Srikar
