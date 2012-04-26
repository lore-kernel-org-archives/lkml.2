Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903Ab2DZK10 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 06:27:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:50003 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883Ab2DZK1Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 06:27:24 -0400
Message-ID: <1335436031.13683.6.camel@twins>
Subject: Re: [BUG] perf stat: useless output for raw events with new event
 parser
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>, mingo@elte.hu,
        David Ahern <dsahern@gmail.com>,
        Robert Richter <robert.richter@amd.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Date: Thu, 26 Apr 2012 12:27:11 +0200
In-Reply-To: <CABPqkBQ2w3RLRwq3fsaJQ_L=_=H+5kounBeuxUv_fk1ksimTOQ@mail.gmail.com>
References: <CABPqkBQJU2vYLbr-=qjkpG=sB8n-8aXJ3QkWcASzy5h4rtFAig@mail.gmail.com>
	 <1335178132.28150.117.camel@twins>
	 <CABPqkBQ2w3RLRwq3fsaJQ_L=_=H+5kounBeuxUv_fk1ksimTOQ@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-23 at 13:17 +0200, Stephane Eranian wrote:
> On Mon, Apr 23, 2012 at 12:48 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Mon, 2012-04-23 at 12:45 +0200, Stephane Eranian wrote:
> >> Hi,
> >>
> >> With the new event parser, one can express raw events field by field:
> >>
> >> $ perf stat -e cpu/event=0x3c,umask=0x0/,cpu/event=0xc5,umask=0x0/ noploop 1
> >>
> >> The problem with this is that the output of perf stat becomes useless:
> >>
> >> $ perf stat -e cpu/event=0x3c,umask=0x0/,cpu/event=0xc5,umask=0x0/ noploop 1
> >> noploop for 1 seconds
> >>
> >>  Performance counter stats for 'noploop 1':
> >>
> >>         2395038678 pmu
> >>             10787 pmu
> >>                        ^^^^^^
> >>        1.000802603 seconds time elapsed
> >
> > Yeah, I already complained about that.. Jolsa proposed adding a name=
> > parameter so you could explicitly name your events. I think I've seen a
> > patch adding that, but can't atm seem to locate it.
> >
> If the proposed solution is to add a pseudo field called "name", then I don't
> see the point of this new parser compared to directly using my libpfm4
> library which already allows:
> 
>  perf stat -e inst_retired:any,wsm_unc:unc_cycles:u ...
> And
>  perf record -e instr_retired:period=200000,cpu_clk_unhalted:freq=100 ...
> 
> If you have to make up names, you might as well, use the actual PMU
> event names, but if you do so, why would you have to bother breaking
> down the encoding into fields?

I'd like to use the event names, but really, when you do:

 cpu/event=instructions_retired,inv,cmask=16/

is it still instructions_retired?

In SFO we spoke about exporting those event tables you have in libpfm4
in some structured file format so that we both might use them, the
primary difficulty in that (IIRC) was the umask constraints per event.

I'm not too overly bothered by people specifying wrong events (at some
point they really had better know wth they're doing anyway), so can we
start with something that mostly works?

I've already spoken with Jiri about adding this before all this parser
stuff got implemented, so it should all be quite possible to add.

Furthermore, once we have a common format, we could even ask Intel/AMD
(and other vendors) to provide their data in this format.


