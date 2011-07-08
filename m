Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab1GHMor (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 08:44:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36829 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245Ab1GHMop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 08:44:45 -0400
Date: Fri, 8 Jul 2011 14:44:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Don Zickus <dzickus@redhat.com>,
        Stephane Eranian <eranian@google.com>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip, final] perf, x86: Add hw_watchdog_set_attr() in a
 sake of nmi-watchdog on P4
Message-ID: <20110708124435.GC4303@elte.hu>
References: <20110705110550.GQ17941@sun>
 <20110705112002.GA15654@elte.hu>
 <20110705113620.GS17941@sun>
 <20110705114437.GC15654@elte.hu>
 <20110705114944.GT17941@sun>
 <20110705121421.GU17941@sun>
 <20110705131005.GA5843@elte.hu>
 <1309871841.3282.148.camel@twins>
 <20110705133105.GB5843@elte.hu>
 <20110705141913.GD4060@sun>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110705141913.GD4060@sun>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> On Tue, Jul 05, 2011 at 03:31:05PM +0200, Ingo Molnar wrote:
> > 
> > * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > 
> > > > So the question is, why does the NMI watchdog prevent 'perf top' 
> > > > from working on a P4?
> > > 
> > > because the NMI watchdog is a pinned event, you don't want to share 
> > > the counter, that would be very bad, suppose you lock up when the 
> > > NMI watchdog was scheduled out. Unreliably debug tools are worse 
> > > than no tools.
> > 
> > Yeah, indeed that explains the symptom.
> > 
> > Firstly, we should fix/enhance perf top to print out an error message 
> > in this case, not just hang there doing nothing.
> 
> It waits for event to be scheduled, so seems first the kernel 
> should have top level context-schedule-in functions changed from 
> void to int (so I have admit I might be missin something here).
> 
> > 
> > Secondly, the proper solution would be to allow the multiplexing of 
> > like-minded hw events. Here if we have two events:
> > 
> >   - pinned NMI watchdog, set to a period of 2 billion cycles
> >   - perf top with a default of 1 khz auto-freq cycles
> > 
> > We should first change the NMI watchdog to use auto-freq samples - 
> > the hw_nmi_get_sample_period() looks unnecessary - if we set the NMI 
> > watchdog to 1 Hz by default it should be more than enough.
> 
> Should we drop tunability of watchdog period as well? At moment
> there is a way to setup period via /sys.

Well, the tunable can remain - there's some real usecases that want 
to increased/decrease the frequency.

Thanks,

	Ingo
