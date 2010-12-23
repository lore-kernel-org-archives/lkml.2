Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706Ab0LWKsC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 05:48:02 -0500
Received: from casper.infradead.org ([85.118.1.10]:38902 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615Ab0LWKsA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 05:48:00 -0500
Subject: Re: [RFC PATCH] perf: Add load latency monitoring on Intel
 Nehalem/Westmere
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, paulus <paulus@samba.org>
In-Reply-To: <AANLkTi=LJB1zA-Kt8KE_qaSNga9iJqnR=FMDRq38Zq5_@mail.gmail.com>
References: <1293005543.2565.156.camel@minggr.sh.intel.com>
	 <1293008431.2170.63.camel@laptop>
	 <AANLkTintfpyvx=Pj1+uu8kCkFn3zT6b36h27Hb7pm=ZF@mail.gmail.com>
	 <1293014701.2170.111.camel@laptop> <1293014967.2170.114.camel@laptop>
	 <1293094781.2565.197.camel@minggr.sh.intel.com>
	 <1293099498.2170.452.camel@laptop>
	 <AANLkTi=LJB1zA-Kt8KE_qaSNga9iJqnR=FMDRq38Zq5_@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 23 Dec 2010 11:48:00 +0100
Message-ID: <1293101280.2170.501.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-23 at 11:31 +0100, Stephane Eranian wrote:
> On Thu, Dec 23, 2010 at 11:18 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Thu, 2010-12-23 at 16:59 +0800, Lin Ming wrote:
> >> > {L1, L2, L3, RAM}x{snoop, local, remote}x{shared, exclusive} + {unknown,
> >> > uncached, IO}
> >> >
> >> > Which takes all of 5 bits to encode.
> >>
> >> Do you mean below encoding?
> >>
> >> bits4 3 2 1 0
> >>     + + + + +
> >>     | | | | |
> >>     | | | {L1, L2, L3, RAM} or {unknown, uncached, IO}
> >>     | | |
> >>     | {snoop, local, remote, OTHER}
> >>     |
> >>     {shared, exclusive}
> >>
> >> If bits(2-3) is OTHER, then bits(0-1) is the encoding of {unknown,
> >> uncached, IO}.
> >
> > That is most certainly a very valid encoding, and a rather nice one at
> > that. I hadn't really gone further than: 4*3*2 + 3 < 2^5 :-)
> >
> > If you also make OTHER=0, then a valid encoding for unknown is also 0,
> > which is a nice meaning for 0...
> >
> I am not sure how you would cover the 9 possibilities for data source as
> shown in Table 10-13 using this encoding. Could you show me?

Ah, I think I see the problem, there's multiple L3-snoops, I guess we
can fix that by extending the {shared, exclusive} to full MESI, growing
us to 6 bits.

I'm assuming you mean "Table 30-13. Data Source Encoding for Load
Latency Record", which has 14 values defined.

Value	Intel				Perf
0x0	Unknown L3			Unknown

0x1	L1				L1-local

0x2	Pending core cache HIT		L2-snoop
	Outstanding core cache miss to
	the same line was underway
0x3	L2				L2-local

0x4	L3-snoop, no coherency actions	L3-snoop-I
0x5	L3-snoop, found no M		L3-snoop-S
0x6	L3-snoop, found M		L3-snoop-M

0x8     L3-miss, snoop, shared		RAM-snoop-S
0xA	L3-miss, local, shared		RAM-local-S
0xB	L3-miss, remote, shared		RAM-remote-S

0xC	L3-miss, local, exclusive	RAM-local-E
0xD	L3-miss, remote, exclusive	RAM-remote-E

0xE	IO				IO
0xF	uncached			uncached


Leaving us with: 

{L1, L2, L3, RAM}x{snoop, local, remote}x{modified, exclusive, shared, invalid} + {unknown, uncached, IO}

Now the question is, is this sufficient to map all data sources from
other archs as well?
