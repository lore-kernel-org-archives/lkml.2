Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697Ab1ADOqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 09:46:53 -0500
Received: from smtp-out.google.com ([216.239.44.51]:1396 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab1ADOqw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 09:46:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=R8NPGjysBUEQ8r67lF6A6BgVPQroIWYhXYi9r71O1bfKz2FeyP7F5jzzqCbU9n/QPG
         SANCSjMw4sF/TCIPWN3g==
MIME-Version: 1.0
In-Reply-To: <20110104143658.GF19989@ghostprotocols.net>
References: <1294112905-25325-1-git-send-email-acme@infradead.org>
	<20110104071629.GB13299@elte.hu>
	<AANLkTinjkC=4yQbiLxF7=G1izFa2pOuR=WvRXbha3wsj@mail.gmail.com>
	<20110104140338.GA19989@ghostprotocols.net>
	<AANLkTi=osr9ZB9OzPxZ_99FU1A5JzCA3rMM64fxws34S@mail.gmail.com>
	<20110104141958.GC19989@ghostprotocols.net>
	<20110104142715.GD19989@ghostprotocols.net>
	<AANLkTik93yG1e80a8MBYDfFBu1YwZ+BA6LqOh-EsLHO_@mail.gmail.com>
	<20110104143658.GF19989@ghostprotocols.net>
Date: Tue, 4 Jan 2011 15:46:48 +0100
Message-ID: <AANLkTin6udBreRt0zYcmDfCZZDwLjkwhg93-hFafy=4f@mail.gmail.com>
Subject: Re: [GIT PULL||RFC 00/11] perf library and regression testing improvements
From: Stephane Eranian <eranian@google.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Han Pingtian <phan@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        mingo@elte.hu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 4, 2011 at 3:36 PM, Arnaldo Carvalho de Melo
<acme@infradead.org> wrote:
> Em Tue, Jan 04, 2011 at 03:33:38PM +0100, Stephane Eranian escreveu:
>> No improvement with this patch.
>
> I was guessing you were using it somehow without calling
> perf_evsel__alloc_counts, now I guess you're just using what is in
> tip/perf/core, no local changes, right?
>
I am using:
git://git.eu.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-tip.git

> Next step: there are anonymous structs inside anonymous unions, what
> compiler/distro?
Yes, I am looking at those right now.
>
gcc 4.4.3 or gcc 4.2.4 (ubuntu hardy or 10.04).

> - Arnaldo
>
>> On Tue, Jan 4, 2011 at 3:27 PM, Arnaldo Carvalho de Melo
>> <acme@infradead.org> wrote:
>> > Em Tue, Jan 04, 2011 at 12:19:58PM -0200, Arnaldo Carvalho de Melo escreveu:
>> >> Em Tue, Jan 04, 2011 at 03:09:08PM +0100, Stephane Eranian escreveu:
>> >> > Arnaldo,
>> >> > Looks like what's wrong is not ps but count:
>> >> >
>> >> > Program received signal SIGSEGV, Segmentation fault.
>> >> > [Switching to Thread 0x7f96967fd6e0 (LWP 5156)]
>> >> > 0x0000000000412b58 in read_counter_aggr (counter=0x7d4820) at builtin-stat.c:206
>> >> > 206                 update_stats(&ps->res_stats[i], count[i]);
>> >> > (gdb) print ps
>> >> > $1 = (struct perf_stat *) 0x7d48a0
>> >> > (gdb) print *ps
>> >> > $2 = {res_stats = {{n = 0, mean = 0, M2 = 0}, {n = 0, mean = 0, M2 =
>> >> > 0}, {n = 0, mean = 0, M2 = 0}}}
>> >> > (gdb) print count
>> >> > $3 = (u64 *) 0x12
>> >> > (gdb) print *count
>> >> > Cannot access memory at address 0x12
>> >> > (gdb) print count
>> >> > $4 = (u64 *) 0x12
>> >>
>> >> Count is:
>> >>
>> >> u64 *count = counter->counts->aggr.values;
>> >
>> > Can you try with this patch?
>> >
>> > diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
>> > index 02b2d80..7876b11 100644
>> > --- a/tools/perf/builtin-stat.c
>> > +++ b/tools/perf/builtin-stat.c
>> > @@ -196,12 +196,14 @@ static inline int nsec_counter(struct perf_evsel *evsel)
>> >  static int read_counter_aggr(struct perf_evsel *counter)
>> >  {
>> >        struct perf_stat *ps = counter->priv;
>> > -       u64 *count = counter->counts->aggr.values;
>> > +       u64 *count;
>> >        int i;
>> >
>> >        if (__perf_evsel__read(counter, cpus->nr, threads->nr, scale) < 0)
>> >                return -1;
>> >
>> > +       count = counter->counts->aggr.values;
>> > +
>> >        for (i = 0; i < 3; i++)
>> >                update_stats(&ps->res_stats[i], count[i]);
>> >
>> > diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
>> > index d337761..26962ea 100644
>> > --- a/tools/perf/util/evsel.c
>> > +++ b/tools/perf/util/evsel.c
>> > @@ -89,8 +89,12 @@ int __perf_evsel__read(struct perf_evsel *evsel,
>> >  {
>> >        size_t nv = scale ? 3 : 1;
>> >        int cpu, thread;
>> > -       struct perf_counts_values *aggr = &evsel->counts->aggr, count;
>> > +       struct perf_counts_values *aggr, count;
>> >
>> > +       if (evsel->counts == NULL && perf_evsel__alloc_counts(evsel, ncpus) < 0)
>> > +               return -ENOMEM;
>> > +
>> > +       aggr = &evsel->counts->aggr;
>> >        aggr->val = 0;
>> >
>> >        for (cpu = 0; cpu < ncpus; cpu++) {
>> >
>
