Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab0IQJPR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 05:15:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:39538 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab0IQJPQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 05:15:16 -0400
Subject: Re: [PATCH] perf, x86: catch spurious interrupts after disabling
 counters
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Don Zickus <dzickus@redhat.com>,
        "gorcunov@gmail.com" <gorcunov@gmail.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "eranian@google.com" <eranian@google.com>
In-Reply-To: <20100917085124.GK13563@erda.amd.com>
References: <20100910144634.GA1060@elte.hu>
	 <20100910155659.GD13563@erda.amd.com> <20100911094157.GA11521@elte.hu>
	 <20100911114404.GE13563@erda.amd.com> <20100911124537.GA22850@elte.hu>
	 <20100912095202.GF13563@erda.amd.com> <20100913143713.GK13563@erda.amd.com>
	 <20100914174132.GN13563@erda.amd.com> <20100915162034.GO13563@erda.amd.com>
	 <1284658480.2275.589.camel@laptop>  <20100917085124.GK13563@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 17 Sep 2010 11:14:58 +0200
Message-ID: <1284714898.28028.11.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-17 at 10:51 +0200, Robert Richter wrote:
> On 16.09.10 13:34:40, Peter Zijlstra wrote:
> > On Wed, 2010-09-15 at 18:20 +0200, Robert Richter wrote:
> > > Some cpus still deliver spurious interrupts after disabling a counter.
> > > This caused 'undelivered NMI' messages. This patch fixes this.
> > > 
> > I tried the below and that also seems to work.. So yeah, looks like
> > we're getting late NMIs.
> 
> I would rather prefer the fix I sent. This patch does a rdmsrl() with
> each nmi on every inactive counter.

Sure, I was just playing around trying to see if that was indeed the
problem.

>  It also changes the counter value
> of all inactive counters, thus restarting a counter by only setting
> the enable bit may start with an unexpected counter value (didn't look
> at current implementation if this could be a problem).

It actually would, pmu->stop()/->start() won't save/restore the counter
value unless you add PERF_EF_UPDATE/PERF_EF_RELOAD.

> It is also not possible to detect with hardware, which counter fired
> the interrupt. We cannot assume a counter overflowed by just reading
> the upper bit of the counter value. We must track this in software. 

Well, exactly that seemed sufficient to not get spurious NMIs.


