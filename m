Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab2DZRhL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 13:37:11 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:33691
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751255Ab2DZRhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 13:37:09 -0400
X-SpamScore: -12
X-BigFish: VPS-12(zz936eK1432N98dKzz1202hzzz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M33KXP-01-AMN-02
X-M-MSG: 
Date: Thu, 26 Apr 2012 19:36:57 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>, <mingo@elte.hu>,
        David Ahern <dsahern@gmail.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [BUG] perf stat: useless output for raw events with new event
 parser
Message-ID: <20120426173657.GC18810@erda.amd.com>
References: <CABPqkBQJU2vYLbr-=qjkpG=sB8n-8aXJ3QkWcASzy5h4rtFAig@mail.gmail.com>
 <1335178132.28150.117.camel@twins>
 <CABPqkBQ2w3RLRwq3fsaJQ_L=_=H+5kounBeuxUv_fk1ksimTOQ@mail.gmail.com>
 <1335436031.13683.6.camel@twins>
 <20120426131220.GB5046@erda.amd.com>
 <1335450273.13683.76.camel@twins>
 <20120426144514.GB18810@erda.amd.com>
 <1335454772.13683.101.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1335454772.13683.101.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.04.12 17:39:32, Peter Zijlstra wrote:
> On Thu, 2012-04-26 at 16:45 +0200, Robert Richter wrote:
> > It is totally ok to have parser support for this. I simply do not see
> > why we need to put the encoding into sysfs. We somehow know on which
> > hardware we run and the parser should already know how to setup the
> > syscall. So parsing the above finally ends in calling of something
> > like:
> > 
> >  setup_event_for_some_pmu(event, 0x4e2, 0xf8);
> > 
> > We don't need any description of bit masks in sysfs for this. 
> 
> Its the kernel side decoding perf_event_attr, so it seems sensible to
> also describe this encoding from the kernel.

For perfctr we have:

 /sys/bus/event_source/devices/cpu/format/inv: config:23
 /sys/bus/event_source/devices/cpu/format/edge: config:18
 /sys/bus/event_source/devices/cpu/format/cmask: config:24-31
 /sys/bus/event_source/devices/cpu/format/event: config:0-7,32-35
 /sys/bus/event_source/devices/cpu/format/umask: config:8-15

The kernel does not en- or decode anything in the config value. It is
directly passed to the pmu with some validation of the values.
Everything else is in userland since it composes the syscall.

The kernel must now contain code like this:

 PMU_FORMAT_ATTR(event,  "config:0-7,32-35");
 PMU_FORMAT_ATTR(umask,  "config:8-15"   );
 PMU_FORMAT_ATTR(edge,   "config:18"     );
 PMU_FORMAT_ATTR(inv,    "config:23"     );
 PMU_FORMAT_ATTR(cmask,  "config:24-31"  );

Which is unrelated to anything else, duplicates the effort to maintain
bit masks and thus is more error-prone. Besides this there is no need
for it because the values are fix and do not change. We simply know
the format of the config value already, so the format entries are of
no use.

One could argue that feeding a generic pmu setup with the format
configuration reduces the need to modify userland, we have same code
for various archs. But if I have the choice I rather update my perf
tool chain than rebooting the kernel to update perf.

> Currently we mostly match the hardware encoding, but there's no strict
> requirement to do so, we can already see some of that with the extra_reg
> stuff, perf_event_attr::config1 can mean different things depending on
> the event.

Of course the config values of the syscall could be translated into a
different hardware configuration. But its layout is always spec'ed
somewhere and needs no description in sysfs.

> Keeping all this information in two places just seems like asking for it
> to get out of sync.

All this could reside in userland at one place too. Also, the syscall
definition is sufficient as interface description and both sides must
handle any differences of kernel or userland implementations.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

