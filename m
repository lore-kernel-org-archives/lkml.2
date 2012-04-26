Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756963Ab2DZOYs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 10:24:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:52917 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab2DZOYr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 10:24:47 -0400
Message-ID: <1335450273.13683.76.camel@twins>
Subject: Re: [BUG] perf stat: useless output for raw events with new event
 parser
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>, mingo@elte.hu,
        David Ahern <dsahern@gmail.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Date: Thu, 26 Apr 2012 16:24:33 +0200
In-Reply-To: <20120426131220.GB5046@erda.amd.com>
References: <CABPqkBQJU2vYLbr-=qjkpG=sB8n-8aXJ3QkWcASzy5h4rtFAig@mail.gmail.com>
	 <1335178132.28150.117.camel@twins>
	 <CABPqkBQ2w3RLRwq3fsaJQ_L=_=H+5kounBeuxUv_fk1ksimTOQ@mail.gmail.com>
	 <1335436031.13683.6.camel@twins> <20120426131220.GB5046@erda.amd.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-04-26 at 15:12 +0200, Robert Richter wrote:
> On 26.04.12 12:27:11, Peter Zijlstra wrote:
> > Furthermore, once we have a common format, we could even ask Intel/AMD
> > (and other vendors) to provide their data in this format.
> 
> I don't think that can be done with a reasonable effort. 

I'm thinking you mis-understand, all we're talking about is a copy of
your event list (BKDG Fam 10h Rev 3.48, section 3.14) in a usable
format.

> Why not simply pass an identifier for each kind of pmu and then only
> add pmu specific code in userland? Much easier than all this sysfs
> format thing, where the kernel tries to tell userland what to do,
> which the kernel never can do exactly. And even if we can describe
> everything with sysfs, kernel and userland code becomes bloated, it
> actually is already, looking at the recent perf tool and kernel
> updates.

The format is only about encoding rules, it doesn't do constraints. All
it wants to convey is if you have an event-code of: 0x4E2 where to stick
it in perf_event_attr::config*. It doesn't want to tell you if that
event exists and if there's a particular umask that ought to go with it.

Its an aid to simplify constructing raw events, nothing more.

When I want to use funny events I'm staring at the Intel-SDM/AMD-BKDG
anyway and I find writing:

  cpu/event=0x4e2,umask=0xf8/

A lot easier than:

  r40000f8e2

because while I like numbers I cannot actually count and would get that
4 wrong half the time, furthermore I'd have to actually remember the
encoding rules; or something like:

  cpu/event=L3_fills_caused_by_L2_evictions.modified_any_core/

Then again, some people are scared of numbers and prefer to wear down
their finger-tips writing silly names.

That said, a unique identifier in there might make sense, esp on things
like ARM that don't have CPUID and even if they do it doesn't actually
correlate to the PMU :-)

So I'd be perfectly ok with adding something
like /sys/bus/events/device/*/name or so.
