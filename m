Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779Ab0GNSr0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 14:47:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57258 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752341Ab0GNSrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 14:47:25 -0400
Date: Wed, 14 Jul 2010 20:46:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
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
Message-ID: <20100714184642.GA9728@elte.hu>
References: <20100714154923.947138065@efficios.com>
 <20100714155804.049012415@efficios.com>
 <AANLkTiml2uwYqQayTKjMN2gI3LnjVFpwxXkv8GN3McEE@mail.gmail.com>
 <20100714170617.GB4955@Krystal>
 <AANLkTinLB3gQNKFk9QRfBS8YEfxL3qxZDFw7vWHDOnmL@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinLB3gQNKFk9QRfBS8YEfxL3qxZDFw7vWHDOnmL@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Ok. I was wondering why anybody would allocate core percpu variables so late 
> that this would ever be an issue, but I guess perf is a reasonable such 
> case. And reasonable to do from NMI.

Yeah.

Frederic (re-)discovered this problem via very hard to debug crashes when he 
extended perf call-graph tracing to have a bit larger buffer and used 
percpu_alloc() for it (which is entirely reasonable in itself).

> That said - grr. I really wish there was some other alternative than adding 
> yet more complexity to the exception return path. That "iret re-enables 
> NMI's unconditionally" thing annoys me.

Ok. We can solve it by allocating the space from the non-vmalloc percpu area - 
8K per CPU.

> In fact, I wonder if we couldn't just do a software NMI disable
> instead? Hav ea per-cpu variable (in the _core_ percpu areas that get
> allocated statically) that points to the NMI stack frame, and just
> make the NMI code itself do something like
> 
>  NMI entry:

I think at this point [NMI re-entry] we've corrupted the top of the NMI kernel 
stack already, due to entering via the IST stack mechanism, which is 
non-nesting and which enters at the same point - right?

We could solve that by copying that small stack frame off before entering the 
'generic' NMI routine - but it all feels a bit pulled in by the hair.

I feel uneasy about taking pagefaults from the NMI handler. Even if we 
implemented it all correctly, who knows what CPU erratas are waiting there to 
be discovered, etc ...

I think we should try to muddle through by preventing these situations from 
happening (and adding a WARN_ONCE() to the vmalloc page-fault handler would 
certainly help as well), and only go to more clever schemes if no other option 
looks sane anymore?

Thanks,

	Ingo
