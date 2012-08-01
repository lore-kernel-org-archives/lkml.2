Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab2HAHKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 03:10:23 -0400
Received: from www.linutronix.de ([62.245.132.108]:48524 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473Ab2HAHKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 03:10:21 -0400
Date: Wed, 1 Aug 2012 09:10:09 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Alan Stern <stern@rowland.harvard.edu>, mingo@kernel.org,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com, namhyung@kernel.org,
        tj@kernel.org, rjw@sisk.pl, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] CPU hotplug: Reverse invocation of notifiers
 during CPU hotplug
In-Reply-To: <87wr1pmz2q.fsf@rustcorp.com.au>
Message-ID: <alpine.LFD.2.02.1208010907210.32033@ionos>
References: <Pine.LNX.4.44L0.1207251054420.2008-100000@iolanthe.rowland.org> <50101733.4030205@linux.vnet.ibm.com> <alpine.LFD.2.02.1207251758340.32033@ionos> <87wr1pmz2q.fsf@rustcorp.com.au>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jul 2012, Rusty Russell wrote:

> On Wed, 25 Jul 2012 18:30:41 +0200 (CEST), Thomas Gleixner <tglx@linutronix.de> wrote:
> > The problem with the current notifiers is, that we only have ordering
> > for a few specific callbacks, but we don't have the faintest idea in
> > which order all other random stuff is brought up and torn down.
> > 
> > So I started experimenting with the following:
> > 
> > struct hotplug_event {
> >        int (*bring_up)(unsigned int cpu);
> >        int (*tear_down)(unsigned int cpu);
> > };
> > 
> > enum hotplug_events {
> >      CPU_HOTPLUG_START,
> >      CPU_HOTPLUG_CREATE_THREADS,
> >      CPU_HOTPLUG_INIT_TIMERS,
> >      ...
> >      CPU_HOTPLUG_KICK_CPU,
> >      ...
> >      CPU_HOTPLUG_START_THREADS,
> >      ...
> >      CPU_HOTPLUG_SET_ONLINE,
> >      ...
> >      CPU_HOTPLUG_MAX_EVENTS,
> > };
> 
> This looks awfully like hardcoded a list of calls, without the
> readability :)

I'd love to make it a list of calls, though we have module users of
cpu hotplug which makes a list of calls a tad hard.
 
> OK, I finally got off my ass and looked at the different users of cpu
> hotplug.  Some are just doing crazy stuff, but most seem to fall into
> two types:
> 
> 1) Hardware-style cpu callbacks (CPU_UP_PREPARE & CPU_DEAD)
> 2) Live cpu callbacks (CPU_ONLINE & CPU_DOWN_PREPARE)
> 
> I think this is what Srivatsa was referring to with "physical" and
> "logical" parts.  Maybe we should explicitly split them, with the idea
> that we'd automatically call the other one if we hit an error.
> 
> struct cpu_hotplug_physical {
>        int (*coming)(unsigned int cpu);
>        void (*gone)(unsigned int cpu);
> };
> 
> struct cpu_hotplug_logical {
>        void (*arrived)(unsigned int cpu);
>        int (*going)(unsigned int cpu);
> };
> 
> Several of the live cpu callbacks seem racy to me, since we could be
> running userspace tasks before CPU_ONLINE.  It'd be nice to fix this,
> too.

Yes, I know. I wan't to change that as well. The trick here is that we
can schedule per cpu stuff on a not fully online cpu and only when all
the callbacks have been executed allow user space tasks to be
scheduled on that newly online cpu.
 
Thanks,

	tglx
