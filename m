Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab1EEHeJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 03:34:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54553 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362Ab1EEHeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 03:34:08 -0400
Date: Thu, 5 May 2011 09:33:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@amd64.org>
Cc: "Luck, Tony" <tony.luck@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] x86, mce: Have MCE persistent event off by default
 for now
Message-ID: <20110505073347.GB14391@elte.hu>
References: <1304357691-14354-1-git-send-email-bp@amd64.org>
 <1304357691-14354-5-git-send-email-bp@amd64.org>
 <20110503064505.GF7751@elte.hu>
 <20110503072302.GC18979@aftab>
 <987664A83D2D224EAE907B061CE93D5301C53670E0@orsmsx505.amr.corp.intel.com>
 <20110504065843.GC20828@elte.hu>
 <987664A83D2D224EAE907B061CE93D5301C53C9B31@orsmsx505.amr.corp.intel.com>
 <20110505063951.GB28015@elte.hu>
 <20110505071747.GA3185@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110505071747.GA3185@aftab>
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


* Borislav Petkov <bp@amd64.org> wrote:

> On Thu, May 05, 2011 at 02:39:51AM -0400, Ingo Molnar wrote:
> > printk events are a compatibility wrapper to allow RAS functionality to have 
> > easy and unified access to all system events that matter. The structure of 
> > printk events is obviously the log level plus a free-form ASCII string, 
> > something like:
> > 
> >  1- the printk timestamp
> 
> Yeah, we want here the timestamp when the event happened.
> 
> >  2- the log level of the kernel when the message was generated
> >  3- the log level of the message
> >  4- the printk message itself, as a free-form string
> > 
> > > [...] a big issue when you have some heavy duty infrastructure trying to 
> > > parse and consume these messages.  We should really consider such stuff a 
> > > user visible ABI, and thus not subject to random breakage - which is a 
> > > radical departure from our current attitude to printk().
> > 
> > Indeed, turning printk into an ABI clearly wont fly upstream although i'd 
> > expect upstream to *care more* about good printk messages if the RAS daemon 
> > starts making good use of it. Any printk message that turns out to be useful 
> > can be turned into an ABI by defining a proper structured event out of it, via 
> > TRACE_EVENT() et al.
> 
> Actually let's have the RAS printk's as TRACE_EVENT's from the start
> - it's not like we're going to convert every printk call into a RAS
> printk event. [...]

Fully agreed that printk should be a TRACE_EVENT() from the get go.

What i meant was that it also gives an opportunity for the introduction of new 
TRACE_EVENT()s: if RAS tooling sees problems with some important printk 
changing its format all the time then such problems can be addressed by 
'upgrading' that printk event to a TRACE_EVENT().

> [...] We only want relevant ones from traps.c, maybe some power management 
> events, fs, maybe some critical security stuff, etc.

Yeah. And what that 'critical stuff' is will probably be found out gradually. 
In the meanwhile we'll have printk events as a starting point.

The printk event is also useful for a practical reason: if you add it right now 
you can test the RAS daemon and provoke a steady stream of events easily by 
catching (and generating) printk events.

( We also want event injection to work, to be able to simulate real MCE
  events. )

Thanks,

	Ingo
