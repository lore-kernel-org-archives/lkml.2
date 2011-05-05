Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511Ab1EEGkP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 02:40:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41880 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002Ab1EEGkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 02:40:14 -0400
Date: Thu, 5 May 2011 08:39:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Borislav Petkov <bp@amd64.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Petkov, Borislav" <Borislav.Petkov@amd.com>
Subject: Re: [PATCH 4/4] x86, mce: Have MCE persistent event off by default
 for now
Message-ID: <20110505063951.GB28015@elte.hu>
References: <1304357691-14354-1-git-send-email-bp@amd64.org>
 <1304357691-14354-5-git-send-email-bp@amd64.org>
 <20110503064505.GF7751@elte.hu>
 <20110503072302.GC18979@aftab>
 <987664A83D2D224EAE907B061CE93D5301C53670E0@orsmsx505.amr.corp.intel.com>
 <20110504065843.GC20828@elte.hu>
 <987664A83D2D224EAE907B061CE93D5301C53C9B31@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <987664A83D2D224EAE907B061CE93D5301C53C9B31@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Luck, Tony <tony.luck@intel.com> wrote:

> > Yes, i definitely think a gateway to printk would be useful, so that the system 
> > can log MCE events the syslog way as well. This probably makes sense for 
> > persistent events in general, not just MCE events.
> 
> s/as well/instead/ ??? If the persistent event mechanism is correctly feeding 
> data to a mart daemon, I don't think we need any printk() chatter. It is only 
> if this is not working that we'd want to see some console logging.

That could certainly be the default incarnation of it, but flexibly allowing 
all the variations does not look particularly bothersome either.

I have no problem with only offering the sanest variations though.

> I agree that this isn't just a property of the MCE persistent event - other 
> persistent events would very likely want a way to shout for help if the 
> events are piling up with no listener.

Yeah. Basically a fallback mechanism and would also inform users about the 
availability of a nice RAS daemon out there.

> > printk itself could become a persistent event. (Transparently and without 
> > breaking compatible syslogd/klogd functionality.)
> 
> Someone from Google was very skeptical of printk() remaining stable from 
> release to release ... [...]

Yeah, the printk messages themselves are not ABI nor will they ever be - 
although spurious changes are rare so they might provide a bridge to structured 
events.

printk events are a compatibility wrapper to allow RAS functionality to have 
easy and unified access to all system events that matter. The structure of 
printk events is obviously the log level plus a free-form ASCII string, 
something like:

 1- the printk timestamp
 2- the log level of the kernel when the message was generated
 3- the log level of the message
 4- the printk message itself, as a free-form string

> [...] a big issue when you have some heavy duty infrastructure trying to 
> parse and consume these messages.  We should really consider such stuff a 
> user visible ABI, and thus not subject to random breakage - which is a 
> radical departure from our current attitude to printk().

Indeed, turning printk into an ABI clearly wont fly upstream although i'd 
expect upstream to *care more* about good printk messages if the RAS daemon 
starts making good use of it. Any printk message that turns out to be useful 
can be turned into an ABI by defining a proper structured event out of it, via 
TRACE_EVENT() et al.

This does not mean that it's not *useful* to allow the streaming of all print 
evnts to the RAS daemon. They are available, they get generated and they 
clearly look useful to me, and it will be useful when a sysadmin looks at the 
RAS log to figure out an incident.

Consider an example of two logs, one with just pure RAS events, the other with 
printk lines (and user-space events, see my patch a couple of months ago that 
allows event injection for critical user-space events as well) embedded:

The MCE-only log:

 Subsystem  |  Time           | event
 ------------------------------------------------------------------
 [MCE]         May 5 05:23:56   correctable MCE event on memory bank X
 [MCE]         May 5 06:19:59   correctable MCE event on memory bank X

Versus a broader, unified log (all events come via the perf event mmap 
ring-buffer, ordered properly and delivered quickly and transparently):

 Subsystem  |  Time           | event
 ------------------------------------------------------------------
 [MCE]         May 5 05:23:56   correctable MCE event on memory bank X
 [printk]      May 5 06:19:53   thermal trip triggered
 [MCE]         May 5 06:19:59   correctable MCE event on memory bank X
 [fault]       May 5 06:20:00   delivered SIGSEGV to task 'httpd' 
 [httpd]       May 5 06:20:00   unexpected restart
 [printk]      May 5 06:20:01   EXT4-fs (9345): group descriptors corrupted!

As a sysadmin i might misinterpret the first one as a low and still acceptable 
rate of correctable MCE errors: roughly one event per hour.

I'd take the second log *much* more seriously and would prioritize this 
incident as it likely indicates bad (overheating?) hardware and user-visible 
crashes and possible uncorrected data corruption.

Note that we made use of printk events, fault events and user-space injected 
events as well, in addition to the primary MCE events.

And yes, some of the printk events, if they are relied on frequently and 
programmatically, will be turned into proper events - and this process is 
helped by printk events.

As i understood it, being useful in such a way is one of the main goals of the 
new RAS daemon.

Thanks,

	Ingo
