Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659Ab0HUJa5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 05:30:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52474 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902Ab0HUJaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 05:30:55 -0400
Date: Sat, 21 Aug 2010 11:30:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Matt Fleming <matt@console-pimps.org>, Zhang Rui <rui.zhang@intel.com>,
        "Lin, Ming M" <ming.m.lin@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "robert.richter@amd.com" <robert.richter@amd.com>,
        "acme@redhat.com" <acme@redhat.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "gorcunov@gmail.com" <gorcunov@gmail.com>,
        "Brown, Len" <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [RFC PATCH 0/3] perf: show package power consumption in perf
Message-ID: <20100821093036.GA1294@elte.hu>
References: <1282118350.5181.115.camel@rui>
 <1282134329.1926.3918.camel@laptop>
 <20100818124116.GA17957@console-pimps.org>
 <1282188497.11858.94.camel@minggr.sh.intel.com>
 <20100819075410.GA25755@console-pimps.org>
 <1282206714.5181.552.camel@rui>
 <20100819083218.GB25755@console-pimps.org>
 <1282211085.1926.4598.camel@laptop>
 <20100821011803.GB7959@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100821011803.GB7959@nowhere>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> > Right, short counters (like SH when not chained) need something to 
> > accumulate deltas into the larger u64. You can indeed use timers for 
> > that, hr or otherwise, but you don't need the swcounter hrtimer 
> > infrastructure for that.
> 
> So what is the point in simulating a PMI using an hrtimer? It won't be 
> based on periods on the interesting counter but on time periods. This 
> is not how we want the samples. If we want timer based samples, we can 
> just launch a seperate software timer based event.

If we then measure the delta of the count during that constant-time 
period, we'll get a 'weight' to consider.

So for example if we sample with a period of every 1000 cache-misses, 
regular same-counter-PMU-IRQ sampling goes like this:

   1000
   1000
   1000
   1000
   1000
   ....

While if we use a hrtimer, we get variations:

   1050
    711
   1539
   2210
    400

But using that variable period as a weight will, statistically, 
compensate for the variation.

It's similar to how the auto-freq code works - that too has variable 
periods (due to the self-adjustment) - which we compensate with weight.

Thanks,

	Ingo
