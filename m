Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab2IYTIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 15:08:43 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:42813 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624Ab2IYTIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 15:08:40 -0400
MIME-Version: 1.0
In-Reply-To: <20120925184245.GA13694@liondog.tnic>
References: <1348505683.11847.111.camel@twins> <1348511193.6951.44.camel@marge.simpson.net>
 <CA+55aFxY7EPCxXqx_eKtVSOmjGKytUiAb2U-o5+=9O8nA-rYsA@mail.gmail.com>
 <20120924192056.GB4082@liondog.tnic> <1348538258.7100.23.camel@marge.simpson.net>
 <CA+55aFxw5yab4f=+KwB59RjRNXEhQZ==QEvQeLhEczKCTQK9wg@mail.gmail.com>
 <1348574286.3881.40.camel@twins> <20120925131736.GA30652@x1.osrc.amd.com>
 <20120925170058.GC30158@x1.osrc.amd.com> <CA+55aFzf=CApkYn+m5omwg+9-9i=11vj=7OMxKrCKb0qc-oBgg@mail.gmail.com>
 <20120925184245.GA13694@liondog.tnic>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 25 Sep 2012 12:08:16 -0700
X-Google-Sender-Auth: lK3I-663mAwuHA8HJx_b6lVw3QE
Message-ID: <CA+55aFxw8t5Y4HnkaTHJOuASr3QVKNoEBo98gnt0xxHyNeT7bg@mail.gmail.com>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
To: Borislav Petkov <bp@alien8.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Mel Gorman <mgorman@suse.de>,
        Nikolay Ulyanitsky <lystor@gmail.com>, linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 11:42 AM, Borislav Petkov <bp@alien8.de> wrote:
>>
>> Is this literally just removing it entirely?
>
> Basically yes:

Ok, so you make it just always select 'target'. Fine. I wondered if
you just removed the calling logic entirely.

>> How does pgbench look? That's the one that apparently really wants to
>> spread out, possibly due to user-level spinlocks. So I assume it will
>> show the reverse pattern, with "kill select_idle_sibling" being the
>> worst case.
>
> Let me run pgbench tomorrow (I had run it only on an older family 0x10
> single-node box) on Bulldozer to check that out. And we haven't started
> the multi-node measurements at all.

Ack, this clearly needs much more testing. That said, I really would
*love* to just get rid of the function entirely.

>> Sad, because it really would be lovely to just remove that thing ;)
>
> Right, so why did we need it all, in the first place? There has to be
> some reason for it.

I'm not entirely convinced.

Looking at the history of that thing, it's long and tortuous, and has
a few commits completely fixing the "logic" of it (eg see commit
99bd5e2f245d).

To the point where I don't think it necessarily even matches what the
original cause for it was. So it's *possible* that we have a case of
historical code that may have improved performance originally on at
least some machines, but that has (a) been changed due to it being
broken and (b) CPU's have changed too, so it may well be that it
simply doesn't help any more.

And we've had problems with this function before. See for example:
 - 4dcfe1025b51: sched: Avoid SMT siblings in select_idle_sibling() if possible
 - 518cd6234178: sched: Only queue remote wakeups when crossing cache boundaries

so we've basically had odd special-case "tuning" of this function from
the original. I do not think that there is any solid reason to believe
that it does what it used to do, or that what it used to do makes
sense any more.

It's entirely possible that "prev_cpu" basically ends up being the
better choice for spreading things out.

That said, my *guess* is that when you run pgbench, you'll see the
same regression that we saw due to Mike's patch too. It simply looks
like tbench wants to have minimal cpu selection and avoid moving
things around, while pgbench probably wants to spread out maximally.

             Linus
