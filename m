Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757846Ab1EYMoP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 08:44:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40733 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757758Ab1EYMoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 08:44:13 -0400
Date: Wed, 25 May 2011 14:44:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
        acme@ghostprotocols.net
Subject: Re: [PATCH 2/2] dont commify big numbers by default, let -B do it
Message-ID: <20110525124401.GB29300@elte.hu>
References: <1305968203-14240-1-git-send-email-jim.cromie@gmail.com>
 <1305968203-14240-3-git-send-email-jim.cromie@gmail.com>
 <20110521103315.GA23651@elte.hu>
 <BANLkTikSMR7AyJi-LEr8iA2x9TxobJr9gA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikSMR7AyJi-LEr8iA2x9TxobJr9gA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jim Cromie <jim.cromie@gmail.com> wrote:

> > Also, i think for automation we'd also like to have a 'simple 
> > output' mode, would you like to add that?
> 
> OK, heres 1st cut at it, adding option --simple, for review / 
> feedback
> 
> Its based upon the csv-output code mostly, with some vestiges of 
> verbose..

Ok, we can do something like this - but please see the comments on 
the patch further below:

> > Something a bit like what you can see in 'perf stat -v true': 
> > Without the human output later on, and with elapsed time added as 
> > well.
> 
> for my part, Id like the moral equivalent of time(s)? output too, 
> though I suspect thats a separate patch..

yeah. No objection to that either: time is well known and the stddev 
output by perf stat --repeat is well liked. Wanna combine the two?

> [jimc@groucho perf]$ time ./perf stat -x'  ' -- sh -c 'sleep 3'
> task-clock-msecs6.830999
> context-switches  2
> CPU-migrations  1
> page-faults  477
> cycles  5404163  (scaled from 72.07%)
> instructions  3302699
> branches  804750
> branch-misses  51870
> cache-references  1584532  (scaled from 45.93%)
> cache-misses  36616  (scaled from 31.36%)
> 
> real	0m3.019s
> user	0m0.005s
> sys	0m0.012s
> 
> are these timings already taken by perf-stat ?
> is it a simple matter of addition and printing ?
> If not, whats involved ?

Do you mean the real/user/sys bits? Elapsed time is already measured, 
but you'd have to extract the rusage bits to get to the stime/utime 
values.

We could also add those as explicit events.

> Also, task-clock-msec doesnt quite match up with times' user number 
> Whats going on here ?

task-clock-msec is generally much more accurate than the 0.005 
printed by 'time'.

About the patch:

> -	fprintf(logfp, "   ( +- %7.3f%% )",
> -			100 * stddev_stats(&ps->res_stats[0]) / avg);
> +	if (!csv_output)
> +		fprintf(logfp, "   ( +- %7.3f%% )",
> +				100 * stddev_stats(&ps->res_stats[0]) / avg);
> +	else
> +	  fprintf(logfp, "%s%.3f%%",
> +		  csv_sep, 100 * stddev_stats(&ps->res_stats[0]) / avg);

We *really* want something cleaner here: a print_ops vector of 
function pointers which would contain a handful of helper functions 
called by the higher level code?

That way adding a new format method would not uglify the highlevel 
code but could be done by adding a new print_ops 'driver' which would 
be selected if the right option is provided.

Also, instead of adding -s/--simple we really want a single 
print-format option that knows about all the format 'drivers':

  --print simple
  --print csv
  --print default
  --print verbose

or so.

Also, please run scripts/checkpatch.pl over your patches, the above 
is i think not matching the coding style we use in the kernel (unless 
webmail mangled your patch).

Thanks,

	Ingo
