Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab1KGSBr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 13:01:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41716 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755838Ab1KGSBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 13:01:45 -0500
X-Greylist: delayed 21720 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Nov 2011 13:01:44 EST
Date: Mon, 7 Nov 2011 18:59:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Vince Weaver <vince@deater.net>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, "Ted Ts'o" <tytso@mit.edu>,
        Pekka Enberg <penberg@kernel.org>,
        Anthony Liguori <anthony@codemonkey.ws>, Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [Qemu-devel] [PATCH] KVM: Add wrapper script around QEMU to test
 kernels
Message-ID: <20111107175942.GA9395@elte.hu>
References: <4EB6AE34.2000907@redhat.com>
 <CAOJsxLFGAnNL9uA=WHD8eJVs5V2+BSrtC+3ff2FsPi326dtjZw@mail.gmail.com>
 <4EB6BAED.2030400@redhat.com>
 <4EB6BEFA.6000303@codemonkey.ws>
 <20111106183132.GA4500@thunk.org>
 <CAOJsxLHvYo5zA+_m-AXuZHjAcGKE5q0ytmPCZ0Gye52LWq1p9Q@mail.gmail.com>
 <CAOJsxLG6kyq-RoQiBj0B_tThvOy1AxJf6XB2VfQFQJkwQ5cHcQ@mail.gmail.com>
 <20111106231953.GD4500@thunk.org>
 <alpine.LFD.2.02.1111070838520.1823@tux.localdomain>
 <alpine.DEB.2.02.1111071156230.28615@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1111071156230.28615@pianoman.cluster.toy>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vince Weaver <vince@deater.net> wrote:

> On Mon, 7 Nov 2011, Pekka Enberg wrote:
> 
> > I've never heard ABI incompatibility used as an argument for 
> > perf. Ingo?

Correct, the ABI has been designed in a way to make it really hard to 
break the ABI via either directed backports or other mess-ups.

The ABI is both backwards *and* forwards ABI compatible, which is 
very rare amongst Linux ABIs.

For frequently used tools, such as perf, there's no ABI compatibility 
problem in practice: using newer perf on older kernels is pretty 
common. Using older perf on new kernels is rarer, but that generally 
works too.

In hindsight being in the kernel repo made it *easier* for perf to 
implement a good, stable ABI while also keeping a very high rate of 
change of the subsystem: changes are more 'concentrated' and people 
can stay focused on the ball to extend the ABI in sensible ways 
instead of struggling with project boundary artifacts.

I think we needed to do only one revert along the way in the past two 
years, to fix an unintended ABI breakage in PowerTop. Considering the 
total complexity of the perf ABI our compatibility track record is 
*very* good.

> Never overtly.  They're too clever for that.

Pekka, Vince has meanwhile become the resident perf critic on lkml, 
always in it when it comes to some perf-bashing:

> In any case, as a primary developer of a library (PAPI) that uses 
> the perf_events ABI I have to say that having perf in the kernel 
> has been a *major* pain for us.

... and you have argued against perf from the very first day on, when 
you were one of the perfmon developers - and IMO in hindsight you've 
been repeatedly wrong about most of your design arguments.

> Unlike the perf developers, we *do* have to maintain backwards 
> compatability. [...]

We do too, i use new perf on older distro kernels all the time. If 
you see a breakage of functionality that tools use and report in a 
timely fashion then please report it.

> [...] And we have a lot of nasty code in PAPI to handle this. 
> Entirely because the perf_events ABI is not stable.  It's mostly 
> stable, but there are enough regressions to be a pain.

You are blaming the wrong guys really.

The PAPI project has the (fundamental) problem that you are still 
doing it in the old-style sw design fashion, with many months long 
delays in testing, and then you are blaming the problems you 
inevitably meet with that model on *us*.
 
There was one PAPI incident i remember where it took you several 
*months* to report a regression in a regular PAPI test-case (no 
actual app affected as far as i know). No other tester ever ran the 
PAPI testcases so nobody else reported it.

Moving perf out of the kernel would make that particular situation 
*worse*, by further increasing the latency of fixes and by further 
increasing the risk of breakages.

Sorry, but you are trying to "fix" perf by dragging it down to your 
bad level of design and we will understandably resist that ...

> It's problem enough that there's no way to know what version of the 
> perf_event abi you are running against and we have to guess based 
> on kernel version.  This gets "fun" because all of the vendors have 
> backported seemingly random chunks of perf_event code to their 
> older kernels.

The ABI design allows for that kind of flexible extensibility, and 
it's one of its major advantages.

What we *cannot* protect against is you relying on obscure details of 
the ABI without adding it to 'perf test' and then not testing the 
upstream kernel in a timely enough fashion either ...

Nobody but you tests PAPI so you need to become *part* of the 
upstream development process, which releases a new upstream kernel 
every 3 months.

> And it often does seem as the perf developers don't care when 
> something breaks in perf_events if it doesn't affect perf users.

I have to reject your slander, both Peter, Arnaldo and me care deeply 
about fixing regressions and i've personally applied fixes out of 
order that addressed some sort of PAPI problem - whenever you chose 
to report them.

Vince, you are wrong and you have also become somewhat malicious in 
your arguments - please stop it.

> For example, the new NMI watchdog severely breaks perf_event event 
> allocation if you are using FORMAT_GROUP.  perf doesn't use this 
> though, so none of the kernel developers seem to care.  And unless 
> I can quickly come up with a patch as an outsider, a few kernel 
> versions will go by and the kernel devs will declare "well it was 
> broken so long, now we don't have to fix it".  Fun.

Face it, the *real* problem is that beyond yourself very few people 
who use a new kernel use PAPI and your long latency of testing 
exposes you to breakages in a much more agile subsystem such as perf. 
Please fix that instead of blaming it on others.

Also, as i mentioned it several times before, you are free to add an 
arbitrary number of ABI test-cases to 'perf test' and we can promise 
that we run that. Right now it consists of a few tests:

 $ perf test
 1: vmlinux symtab matches kallsyms: Ok

 2: detect open syscall event: Ok
 3: detect open syscall event on all cpus: Ok
 4: read samples using the mmap interface: Ok

... but we do not object to adding testcases for functionality used 
by PAPI.

The usual ABI rules also apply: we'll revert everything that breaks 
the ABI - but for that you need to report it *in time*, not timed one 
day before the next -stable release like you did it last time around 
...

So there's several ways of how you could help push your own interests 
into the kernel project.

Thanks,

	Ingo
