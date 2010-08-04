Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932583Ab0HDHPL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 03:15:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51655 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512Ab0HDHPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 03:15:08 -0400
Date: Wed, 4 Aug 2010 09:14:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
Message-ID: <20100804071405.GA28183@elte.hu>
References: <AANLkTilD4aYej_36lOCEvMNCdYc4jBIupi5-77oD9vD2@mail.gmail.com>
 <20100714221418.GA14533@nowhere>
 <20100714223107.GA2350@Krystal>
 <20100714224853.GC14533@nowhere>
 <20100714231117.GA22341@Krystal>
 <20100714233843.GD14533@nowhere>
 <20100715162631.GB30989@Krystal>
 <1280855904.1923.675.camel@laptop>
 <20100803182556.GA13798@Krystal>
 <1280904410.1923.700.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280904410.1923.700.camel@laptop>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> > What I am proposing does not even involve a copy: when we want to take a 
> > snapshot, we just have to force a sub-buffer switch on the ring buffer. 
> > The "returns" happening at the beginning of the next (empty) sub-buffer 
> > would clearly fail to discard records (expecting non-existing entry 
> > records). We would then have to save a small record saying that a function 
> > return occurred. The current stack frame at the end of the next sub-buffer 
> > could be deduced from the complete collection of stack frame samples.
> 
> And suppose the stack-trace was all of 16 entries (not uncommon for a kernel 
> stack), then you waste a whole page for 128 bytes (assuming your sub-buffer 
> is page sized). I'll take the memcopy, thank you.

To throw some hard numbers into the discussion, i found two random callgraph 
perf.data's on my boxes (both created prior the start of this discussion) and 
here is the distribution of their call-chain length:

aldebaran:~> perf report -D | grep 'chain: nr:' | cut -d: -f3- | sort -n | uniq -c
      2 4
     21 6
     23 8
     13 9
     20 10
     29 11
     21 12
     25 13
     54 14
    112 15
     72 16
     77 17
     35 18
     38 19
     48 20
     29 21
     10 22
     97 23
      3 24
      1 25
      2 26
      2 28
      2 29
      1 30
      2 31

So the peak/average here is around 15 entries.

The other one:

phoenix:~> perf report -D | grep 'chain: nr:' | cut -d: -f3- | sort -n | uniq -c
      1 2
     70 3
    222 4
    112 5
    116 6
    329 7
    241 8
    163 9
    203 10
    287 11
    159 12
      4 13
      6 14
     22 15
      2 16
     11 17
      5 18

Here the average is even lower - around 8 entries.

Thanks,

	Ingo
