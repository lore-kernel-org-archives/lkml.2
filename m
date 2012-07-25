Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587Ab2GYQa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 12:30:59 -0400
Received: from www.linutronix.de ([62.245.132.108]:41034 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610Ab2GYQa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 12:30:58 -0400
Date: Wed, 25 Jul 2012 18:30:41 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
cc: Alan Stern <stern@rowland.harvard.edu>, mingo@kernel.org,
        peterz@infradead.org, rusty@rustcorp.com.au,
        paulmck@linux.vnet.ibm.com, namhyung@kernel.org, tj@kernel.org,
        rjw@sisk.pl, nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] CPU hotplug: Reverse invocation of notifiers
 during CPU hotplug
In-Reply-To: <50101733.4030205@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.02.1207251758340.32033@ionos>
References: <Pine.LNX.4.44L0.1207251054420.2008-100000@iolanthe.rowland.org> <50101733.4030205@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jul 2012, Srivatsa S. Bhat wrote:
> On 07/25/2012 08:27 PM, Alan Stern wrote:
> One of the other ideas to improve the hotplug notifier stuff that came up during some
> of the discussions was to implement explicit dependency tracking between the notifiers
> and perhaps get rid of the priority numbers that are currently being used to provide
> some sort of ordering between the callbacks. Links to some of the related discussions
> are provided below.

The current code which brings up/down a CPU (mostly architecture
specific) code is comnpletely asymetric.

We really want a fully symetric state machine here, which also gives
us the proper invocation points for the other subsystems callbacks.

While I thought about having a full dependency tracking system, I'm
quite convinced by now, that hotplug is a rather linear sequence which
does not provide much room for paralell setup/teardown.

At least we should start with a simple linear chain.

The problem with the current notifiers is, that we only have ordering
for a few specific callbacks, but we don't have the faintest idea in
which order all other random stuff is brought up and torn down.

So I started experimenting with the following:

struct hotplug_event {
       int (*bring_up)(unsigned int cpu);
       int (*tear_down)(unsigned int cpu);
};

enum hotplug_events {
     CPU_HOTPLUG_START,
     CPU_HOTPLUG_CREATE_THREADS,
     CPU_HOTPLUG_INIT_TIMERS,
     ...
     CPU_HOTPLUG_KICK_CPU,
     ...
     CPU_HOTPLUG_START_THREADS,
     ...
     CPU_HOTPLUG_SET_ONLINE,
     ...
     CPU_HOTPLUG_MAX_EVENTS,
};

Now I have two arrays:

struct hotplug_event hotplug_events_bp[CPU_HOTPLUG_MAX_EVENTS];
struct hotplug_event hotplug_events_ap[CPU_HOTPLUG_MAX_EVENTS];
   
The _bp one is the list of events which are executed on the active cpu
and the _ap ones are those executed on the hotplugged cpu.

The core code advances the events in sync steps, so both BP and AP can
issue a stop on the process and cause a rollback.

Most of the callbacks can be added to the arrays at compile time, just
the stuff which is in modules requires an register/unregister
interface.

Though in any case the enum gives us a very explicit ordering of
setup/teardown, so rollback or partial online/offline should be simple
to achieve.

The only drawback is that it will prevent out of tree modules to use
the hotplug infrastructure, but I really couldn't care less.

Thoughts?

	tglx
