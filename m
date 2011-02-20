Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab1BTNAJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 08:00:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39874 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434Ab1BTNAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 08:00:08 -0500
Date: Sun, 20 Feb 2011 13:59:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        ananth@in.ibm.com, davem@davemloft.net, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "2nddept-manager@sdl.hitachi.co.jp" 
	<2nddept-manager@sdl.hitachi.co.jp>
Subject: Re: [PATCH] kprobes - do not allow optimized kprobes in entry code
Message-ID: <20110220125948.GC25700@elte.hu>
References: <1297696354-6990-1-git-send-email-jolsa@redhat.com>
 <4D5A4A66.4010503@hitachi.com>
 <20110215123058.GB3135@jolsa.brq.redhat.com>
 <4D5AA209.7070309@hitachi.com>
 <20110215170507.GD3135@jolsa.brq.redhat.com>
 <4D5B4654.30407@hitachi.com>
 <20110217151103.GA11156@elte.hu>
 <20110218162619.GA9425@jolsa.brq.redhat.com>
 <4D5FD04D.8020209@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D5FD04D.8020209@hitachi.com>
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


* Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> Thanks, I've also tested. (But my machine has no L1-icache-prefetches* support) 
> What I can tell is both of L1-icache-load and L1-icache-load-misses is reduced by 
> the patch. ;-)

That's actually a pretty interesting result: it means that compressing entry code 
into a single section compresses the icache footprint in a measurable way. The 
icache miss rate went down by about 6%:

>          1,234,272 L1-icache-load-misses      ( +-   0.105% )
>          1,155,816 L1-icache-load-misses      ( +-   0.113% )

Which, assuming that there's no kernel build and bootup related skew effect that is 
larger than 2-3% means that this is an improvement.

perf feature request: would be nice if it was able to do:

	perf stat --record ...
	perf diff

and it would show a comparison of the two runs.

In hindsight it makes sense: the patch probably reduced the fragmentation of the 
icache for this workload.

But it's still surprising :-)

Mind splitting the patch up into two parts, the first one that does the performance 
optimization intentionally (with numbers, explanation, etc.), the second one that 
uses the new section for kprobes exclusion?

Thanks,

	Ingo
