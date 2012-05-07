Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460Ab2EGQ6R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 12:58:17 -0400
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:27378
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756796Ab2EGQ6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 12:58:16 -0400
X-SpamScore: -13
X-BigFish: VPS-13(zz936eK146fI1432N98dKzz1202hzz8275dhz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M3NWGU-01-8BJ-02
X-M-MSG: 
Date: Mon, 7 May 2012 18:58:03 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>, <mingo@elte.hu>,
        David Ahern <dsahern@gmail.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [BUG] perf stat: useless output for raw events with new event
 parser
Message-ID: <20120507165803.GL18810@erda.amd.com>
References: <CABPqkBQJU2vYLbr-=qjkpG=sB8n-8aXJ3QkWcASzy5h4rtFAig@mail.gmail.com>
 <1335178132.28150.117.camel@twins>
 <CABPqkBQ2w3RLRwq3fsaJQ_L=_=H+5kounBeuxUv_fk1ksimTOQ@mail.gmail.com>
 <1335436031.13683.6.camel@twins>
 <20120426131220.GB5046@erda.amd.com>
 <1335450273.13683.76.camel@twins>
 <20120426144514.GB18810@erda.amd.com>
 <1335454772.13683.101.camel@twins>
 <20120426173657.GC18810@erda.amd.com>
 <1336394565.27020.32.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1336394565.27020.32.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.05.12 14:42:45, Peter Zijlstra wrote:
> On Thu, 2012-04-26 at 19:36 +0200, Robert Richter wrote:
> > On 26.04.12 17:39:32, Peter Zijlstra wrote:
> > > On Thu, 2012-04-26 at 16:45 +0200, Robert Richter wrote:
> > > > It is totally ok to have parser support for this. I simply do not see
> > > > why we need to put the encoding into sysfs. We somehow know on which
> > > > hardware we run and the parser should already know how to setup the
> > > > syscall. So parsing the above finally ends in calling of something
> > > > like:
> > > > 
> > > >  setup_event_for_some_pmu(event, 0x4e2, 0xf8);
> > > > 
> > > > We don't need any description of bit masks in sysfs for this. 
> > > 
> > > Its the kernel side decoding perf_event_attr, so it seems sensible to
> > > also describe this encoding from the kernel.
> > 
> > For perfctr we have:
> > 
> >  /sys/bus/event_source/devices/cpu/format/inv: config:23
> >  /sys/bus/event_source/devices/cpu/format/edge: config:18
> >  /sys/bus/event_source/devices/cpu/format/cmask: config:24-31
> >  /sys/bus/event_source/devices/cpu/format/event: config:0-7,32-35
> >  /sys/bus/event_source/devices/cpu/format/umask: config:8-15
> > 
> > The kernel does not en- or decode anything in the config value. It is
> > directly passed to the pmu with some validation of the values.
> 
> For AMD and most Intel, yes. But there's no requirement for this to be
> so. IIRC, Intel P4 doesn't.
> 
> Furthermore, extra data required for some events doesn't have a well
> defined place in the one ::config and we use config1,2, but how do we
> tell what goes where?
> 
> > Everything else is in userland since it composes the syscall.
> 
> Dependent on what you want to achieve, but with the format/ and event/
> stuff you can get a whole way without userspace ever having to know what
> particular hardware its running on. 
> 
> Ideally we'd get all the way to where the user itself doesn't care, once
> the user starts caring he/she will have to open up the BKDG/SDM/other
> volume of arch magic. At which point they'd better be well qualified to
> deal with all that brings.
> 
> > The kernel must now contain code like this:
> > 
> >  PMU_FORMAT_ATTR(event,  "config:0-7,32-35");
> >  PMU_FORMAT_ATTR(umask,  "config:8-15"   );
> >  PMU_FORMAT_ATTR(edge,   "config:18"     );
> >  PMU_FORMAT_ATTR(inv,    "config:23"     );
> >  PMU_FORMAT_ATTR(cmask,  "config:24-31"  );
> > 
> > Which is unrelated to anything else, duplicates the effort to maintain
> > bit masks and thus is more error-prone. Besides this there is no need
> > for it because the values are fix and do not change.
> 
> If it doesn't change there's no maintenance overhead is there?
> 
> >  We simply know
> > the format of the config value already, so the format entries are of
> > no use.
> 
> And yet 'event' isn't the same for Intel and AMD, this means I'd have to
> add all kinds of cpu detection code into the parser. By having the
> kernel provide this information the parser doesn't have to care about
> it.

I think we agree that it can be done in both ways, either providing
the information in sysfs or delivering a library like function to fill
in the data into attr. It is just a matter of taste with some pro and
cons for both.

> > One could argue that feeding a generic pmu setup with the format
> > configuration reduces the need to modify userland, we have same code
> > for various archs. But if I have the choice I rather update my perf
> > tool chain than rebooting the kernel to update perf.
> 
> You'll have to reboot at some point anyway, you can always frob
> perf_event_attr::config* by hand without the aid of this sysfs stuff,
> but when the kernel cannot handle the data or otherwise doesn't know how
> to talk to the hardware you'll have to go reboot.
> 
> I really don't see the problem with reboots and wish people would stop
> using that silly argument.

Some people may not reboot their system just to get an update of their
perf environment. And the other thing is, it is much harder to get a
change into a distro kernel than in a distro's perf package.

These are the main problems a user might face with. And simply because
you and me can reboot our machines as we want we actually can't ignore
this.

> > > Currently we mostly match the hardware encoding, but there's no strict
> > > requirement to do so, we can already see some of that with the extra_reg
> > > stuff, perf_event_attr::config1 can mean different things depending on
> > > the event.
> > 
> > Of course the config values of the syscall could be translated into a
> > different hardware configuration. But its layout is always spec'ed
> > somewhere and needs no description in sysfs.
> 
> You mean there's a spec (kernel source excluded) that says that the
> offcore response msr goes in perf_event_attr::config1 ?
> 
> > > Keeping all this information in two places just seems like asking for it
> > > to get out of sync.
> > 
> > All this could reside in userland at one place too.
> 
> Userland would first have to figure out what physical hardware it was
> running on to determine if it has an offcore response msr, then it would
> have to 'know' this value is supposed to go in perf_event_attr::config1.
> 
> By hard-coding this in userspace the kernel is then never allowed to
> change it and you'd have to duplicate this knowledge everywhere you'd
> want to use the syscall. You could 'optimize' this by using a library to
> reduce the userland copies to 1, but the fact is that both kernel and
> userland need to 'know' this independently.
> 
> Yet by having it in sysfs the kernel can tell userspace than it has an
> offcore_rsp field and if we get a value for it it goes wherever it says.
> Userspace doesn't need to know anything other than to look up stuff in
> sysfs and there's only 1 copy of the knowledge needed -- in the kernel.
> 
> So if I try to set offcore_rsp on an AMD machine it'll error since they
> don't provide that field.

Once a field is defined in attr you may not change this afterwards for
abi stability reasons. Otherwise you make sysfs part of the syscall
specification. This requires sysfs itself and parsing it for using
perf_open_event(). Didn't see it this way until now. Other
applications than perf might use the perf syscall too and assume
stable config* bit fields.

-Robert

> Same with the event field, without having to have cpu checks, perf can
> deal with 'cpu/event=0x4e3/'. On Intel it can tell us this won't go
> since the event field isn't wide enough, on AMD it knows to stick that 4
> in bits 32-35 of perf_event_attr::config.
> 
> >  Also, the syscall
> > definition is sufficient as interface description and both sides must
> > handle any differences of kernel or userland implementations.
> 
> You've just posted a patch ([PATCH 4/7] perf/x86-ibs: Add support for
> IBS pseudo events) that's the very counter example.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

