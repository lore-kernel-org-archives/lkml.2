Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab1ATRWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 12:22:24 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33925 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab1ATRWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 12:22:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=Xahh9GuMMBVONJs/DPSvUpZ+qqx0AA/34MuazaSxiMKezKnKKWTGcPtNDbLRjjyJJm
         pNcTo+RhPjifxNO2dBUToMf/cZWmmJJy3U83xJvOUfuvuO7eDoVQpvOeIHHPzKbxUwob
         a8pn474JSweM4zGT2Z0Uufzpl/QvOzKTPK1ho=
Date: Thu, 20 Jan 2011 15:22:18 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Denis Kirjanov <dkirjanov@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, paulus@samba.org
Subject: Re: [PATCH] perftools: Fix build error
Message-ID: <20110120172218.GB13482@ghostprotocols.net>
References: <20110120093246.GA8031@hera.kernel.org>
 <20110120114719.GD23661@elte.hu>
 <4D385866.3060405@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D385866.3060405@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jan 20, 2011 at 06:44:38PM +0300, Denis Kirjanov escreveu:
> On 01/20/2011 02:47 PM, Ingo Molnar wrote:
> > 
> > * Denis Kirjanov <dkirjanov@kernel.org> wrote:
> > 
> >> Fix perftools build error (ppc64 box) with PERF_VERSION = 2.6.38.rc1.47.g12fcdb
> >> CC builtin-top.o
> >> cc1: warnings being treated as errors
> >> builtin-top.c: In function 'print_sym_table':
> >> builtin-top.c:540: error: format '%Ld' expects type 'long long int', but argument 2 has type '__u64'
> >>
> >> Signed-off-by: Denis Kirjanov <dkirjanov@kernel.org>
> >> ---
> >>  tools/perf/builtin-top.c |    2 +-
> >>  1 files changed, 1 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> >> index 05344c6..8202a2e 100644
> >> --- a/tools/perf/builtin-top.c
> >> +++ b/tools/perf/builtin-top.c
> >> @@ -537,7 +537,7 @@ static void print_sym_table(void)
> >>  	if (nr_counters == 1 || !display_weighted) {
> >>  		struct perf_evsel *first;
> >>  		first = list_entry(evsel_list.next, struct perf_evsel, node);
> >> -		printf("%Ld", first->attr.sample_period);
> >> +		printf("%Ld", (unsigned long long)first->attr.sample_period);
> > 
> > Wouldnt %Lu solve this in a cleaner way?
> > 
> > Thanks,
> > 
> > 	Ingo
> > 
> I think that cleaner way is to use PRIu64.

Fuglier, definetely, but indeed, more portable, as I noticed when trying
to build the tools on a RHEL4/Fedora3 machine, as there are people using
such old beasts with modern kernels.

I'll take the patch for perf/urgent, as it prevents building in .38,
please consider going thru tools/perf and patching the other %Ld and
%Lu instances :-)

- Arnaldo
 
> 
> >From 492bf54effdf8c154e76c4ca734f27ce1db46df6 Mon Sep 17 00:00:00 2001
> From: Denis Kirjanov <dkirjanov@kernel.org>
> Date: Thu, 20 Jan 2011 18:34:56 +0300
> Subject: [PATCH] perftools: Fix build error
> 
>     CC perf.o
>     CC builtin-top.o
> cc1: warnings being treated as errors
> builtin-top.c: In function 'print_sym_table':
> builtin-top.c:540: error: format '%Ld' expects type 'long long int', but argument 2 has type '__u64'
> make: *** [builtin-top.o] Error 1
> 
> 
> Signed-off-by: Denis Kirjanov <dkirjanov@kernel.org>
> ---
>  tools/perf/builtin-top.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> index 05344c6..a7bc50b 100644
> --- a/tools/perf/builtin-top.c
> +++ b/tools/perf/builtin-top.c
> @@ -40,6 +40,7 @@
>  #include <stdio.h>
>  #include <termios.h>
>  #include <unistd.h>
> +#include <inttypes.h>
>  
>  #include <errno.h>
>  #include <time.h>
> @@ -537,7 +538,7 @@ static void print_sym_table(void)
>  	if (nr_counters == 1 || !display_weighted) {
>  		struct perf_evsel *first;
>  		first = list_entry(evsel_list.next, struct perf_evsel, node);
> -		printf("%Ld", first->attr.sample_period);
> +		printf("%" PRIu64, first->attr.sample_period);
>  		if (freq)
>  			printf("Hz ");
>  		else
> -- 
> 1.7.3.4
