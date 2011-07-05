Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751175Ab1GENbZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 09:31:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60619 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720Ab1GENbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 09:31:24 -0400
Date: Tue, 5 Jul 2011 15:31:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Stephane Eranian <eranian@google.com>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip, final] perf, x86: Add hw_watchdog_set_attr() in a
 sake of nmi-watchdog on P4
Message-ID: <20110705133105.GB5843@elte.hu>
References: <20110705103403.GN17941@sun>
 <20110705105959.GA14435@elte.hu>
 <20110705110550.GQ17941@sun>
 <20110705112002.GA15654@elte.hu>
 <20110705113620.GS17941@sun>
 <20110705114437.GC15654@elte.hu>
 <20110705114944.GT17941@sun>
 <20110705121421.GU17941@sun>
 <20110705131005.GA5843@elte.hu>
 <1309871841.3282.148.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309871841.3282.148.camel@twins>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> > So the question is, why does the NMI watchdog prevent 'perf top' 
> > from working on a P4?
> 
> because the NMI watchdog is a pinned event, you don't want to share 
> the counter, that would be very bad, suppose you lock up when the 
> NMI watchdog was scheduled out. Unreliably debug tools are worse 
> than no tools.

Yeah, indeed that explains the symptom.

Firstly, we should fix/enhance perf top to print out an error message 
in this case, not just hang there doing nothing.

Secondly, the proper solution would be to allow the multiplexing of 
like-minded hw events. Here if we have two events:

  - pinned NMI watchdog, set to a period of 2 billion cycles
  - perf top with a default of 1 khz auto-freq cycles

We should first change the NMI watchdog to use auto-freq samples - 
the hw_nmi_get_sample_period() looks unnecessary - if we set the NMI 
watchdog to 1 Hz by default it should be more than enough.

Thus we'd have two events:

  - pinned NMI watchdog, set to 1 Hz
  - perf top, set to 1000 Hz

The 1000 Hz event could serve the 1 Hz event just fine.

Thirdly, even if we mucked the NMI event to be somewhat different 
from the real cycles event (so the P4 PMU can co-schedule it with 
perf top), the real solution there would *still* be to express this 
as a variation of a cycles event: use the same trick to allow up to 
two cycles events to be present in the PMU - but hide this from the 
generic interfaces, just allow up to two cycles events to be 
scheduled at once.

This will have the advantage of not only fixing the NMI watchdog, but 
other users as well.

Now, if there's some real behavioral difference between the two 
events (one is halted cycles the other is unhalted cycles), then i'd 
suggest to use PERF_COUNT_HW_BUS_CYCLES in the NMI watchdog - that is 
the generic 'constant frequency' cycles event.

So there's lots of options to fix/improve this more intelligently.

Thanks,

	Ingo
