Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab0HWJb5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 05:31:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:45344 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122Ab0HWJby convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 05:31:54 -0400
Subject: Re: [RFC PATCH 0/3] perf: show package power consumption in perf
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Matt Fleming <matt@console-pimps.org>, Zhang Rui <rui.zhang@intel.com>,
        "Lin, Ming M" <ming.m.lin@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "robert.richter@amd.com" <robert.richter@amd.com>,
        "acme@redhat.com" <acme@redhat.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "gorcunov@gmail.com" <gorcunov@gmail.com>,
        "Brown, Len" <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>
In-Reply-To: <20100821011803.GB7959@nowhere>
References: <1282118350.5181.115.camel@rui>
	 <1282134329.1926.3918.camel@laptop>
	 <20100818124116.GA17957@console-pimps.org>
	 <1282188497.11858.94.camel@minggr.sh.intel.com>
	 <20100819075410.GA25755@console-pimps.org> <1282206714.5181.552.camel@rui>
	 <20100819083218.GB25755@console-pimps.org>
	 <1282211085.1926.4598.camel@laptop>  <20100821011803.GB7959@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 23 Aug 2010 11:31:36 +0200
Message-ID: <1282555896.2605.1534.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-08-21 at 03:18 +0200, Frederic Weisbecker wrote:
> On Thu, Aug 19, 2010 at 11:44:45AM +0200, Peter Zijlstra wrote:
> > On Thu, 2010-08-19 at 09:32 +0100, Matt Fleming wrote:
> > > 
> > > 
> > > How big is the hardware counter? The problem comes when the process is
> > > scheduled in and runs for a long time, e.g. so long that the energy
> > > hardware counter wraps. This is why it's necessary to periodically
> > > sample the counter.
> > > 
> > Long running processes aren't the only case, you could associate an
> > event with a CPU.

> I don't understand what you mean.

perf_event_open(.pid = -1, .cpu = n);

> > Right, short counters (like SH when not chained) need something to
> > accumulate deltas into the larger u64. You can indeed use timers for
> > that, hr or otherwise, but you don't need the swcounter hrtimer
> > infrastructure for that.
> 
> 
> So what is the point in simulating a PMI using an hrtimer? It won't be
> based on periods on the interesting counter but on time periods. This
> is not how we want the samples. If we want timer based samples, we can
> just launch a seperate software timer based event.

*sigh* that's exactly what we're doing, we're creating a separate
software hrtimer to create samples, the only thing that's different is
that we put this hrtimer and the hw-counter in a group and let the
hrtimer sample include the hw-counter's value.

If you then weight the samples by the hw-counter delta, you get
something that's more or less related to the thing the hw-counter is
counting.

For counter's that do no provide overflow interrupts this is the only
possible way to get anything.

> In the case of SH where we need to flush to avoid wraps, I understand, but
> oterwise?

The wrap issue it totally unrelated.


