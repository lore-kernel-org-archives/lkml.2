Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab1AUIy7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 03:54:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265Ab1AUIy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 03:54:58 -0500
Date: Fri, 21 Jan 2011 16:57:21 +0800
From: Han Pingtian <phan@redhat.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Denis Kirjanov <dkirjanov@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org
Subject: Re: [PATCH] perftools: Fix build error
Message-ID: <20110121085721.GD2994@hpt.nay.redhat.com>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
	Denis Kirjanov <dkirjanov@kernel.org>, Ingo Molnar <mingo@elte.hu>,
	linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
	paulus@samba.org
References: <20110120093246.GA8031@hera.kernel.org>
 <20110120114719.GD23661@elte.hu>
 <4D385866.3060405@kernel.org>
 <20110120172218.GB13482@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110120172218.GB13482@ghostprotocols.net>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 03:22:18PM -0200, Arnaldo Carvalho de Melo wrote:
> Em Thu, Jan 20, 2011 at 06:44:38PM +0300, Denis Kirjanov escreveu:
> > On 01/20/2011 02:47 PM, Ingo Molnar wrote:
> > > 
> > > * Denis Kirjanov <dkirjanov@kernel.org> wrote:
> > > 
> > >> Fix perftools build error (ppc64 box) with PERF_VERSION = 2.6.38.rc1.47.g12fcdb
> > >> CC builtin-top.o
> > >> cc1: warnings being treated as errors
> > >> builtin-top.c: In function 'print_sym_table':
> > >> builtin-top.c:540: error: format '%Ld' expects type 'long long int', but argument 2 has type '__u64'
> > >>
> > >> Signed-off-by: Denis Kirjanov <dkirjanov@kernel.org>
> > >> ---
> > >>  tools/perf/builtin-top.c |    2 +-
> > >>  1 files changed, 1 insertions(+), 1 deletions(-)
> > >>
> > >> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> > >> index 05344c6..8202a2e 100644
> > >> --- a/tools/perf/builtin-top.c
> > >> +++ b/tools/perf/builtin-top.c
> > >> @@ -537,7 +537,7 @@ static void print_sym_table(void)
> > >>  	if (nr_counters == 1 || !display_weighted) {
> > >>  		struct perf_evsel *first;
> > >>  		first = list_entry(evsel_list.next, struct perf_evsel, node);
> > >> -		printf("%Ld", first->attr.sample_period);
> > >> +		printf("%Ld", (unsigned long long)first->attr.sample_period);
> > > 
> > > Wouldnt %Lu solve this in a cleaner way?
> > > 
> > > Thanks,
> > > 
> > > 	Ingo
> > > 
> > I think that cleaner way is to use PRIu64.
> 
> Fuglier, definetely, but indeed, more portable, as I noticed when trying
> to build the tools on a RHEL4/Fedora3 machine, as there are people using
> such old beasts with modern kernels.
> 
> I'll take the patch for perf/urgent, as it prevents building in .38,
> please consider going thru tools/perf and patching the other %Ld and
> %Lu instances :-)
There are also some %Lx in code, shall we change them with PRIx64?
> 
> - Arnaldo
>  
> > 
> > >From 492bf54effdf8c154e76c4ca734f27ce1db46df6 Mon Sep 17 00:00:00 2001
> > From: Denis Kirjanov <dkirjanov@kernel.org>
> > Date: Thu, 20 Jan 2011 18:34:56 +0300
> > Subject: [PATCH] perftools: Fix build error
> > 
> >     CC perf.o
> >     CC builtin-top.o
> > cc1: warnings being treated as errors
> > builtin-top.c: In function 'print_sym_table':
> > builtin-top.c:540: error: format '%Ld' expects type 'long long int', but argument 2 has type '__u64'
> > make: *** [builtin-top.o] Error 1
> > 
> > 
> > Signed-off-by: Denis Kirjanov <dkirjanov@kernel.org>
> > ---
> >  tools/perf/builtin-top.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> > index 05344c6..a7bc50b 100644
> > --- a/tools/perf/builtin-top.c
> > +++ b/tools/perf/builtin-top.c
> > @@ -40,6 +40,7 @@
> >  #include <stdio.h>
> >  #include <termios.h>
> >  #include <unistd.h>
> > +#include <inttypes.h>
> >  
> >  #include <errno.h>
> >  #include <time.h>
> > @@ -537,7 +538,7 @@ static void print_sym_table(void)
> >  	if (nr_counters == 1 || !display_weighted) {
> >  		struct perf_evsel *first;
> >  		first = list_entry(evsel_list.next, struct perf_evsel, node);
> > -		printf("%Ld", first->attr.sample_period);
> > +		printf("%" PRIu64, first->attr.sample_period);
> >  		if (freq)
> >  			printf("Hz ");
> >  		else
> > -- 
> > 1.7.3.4
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Han Pingtian
Quality Engineer
hpt @ #kernel-qe
Red Hat, Inc
Freedom ... courage ... Commitment ... ACCOUNTABILITY
