Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab2CVAKk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 20:10:40 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:34899 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932156Ab2CVAKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 20:10:37 -0400
Date: Thu, 22 Mar 2012 01:10:31 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] perf tools: Fix ordering with unstable tsc
Message-ID: <20120322001028.GA7024@somewhere.redhat.com>
References: <20120206132546.GA30854@quad>
 <1329583837-7469-1-git-send-email-fweisbec@gmail.com>
 <20120314195535.GB13246@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120314195535.GB13246@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 04:55:35PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Sat, Feb 18, 2012 at 05:50:37PM +0100, Frederic Weisbecker escreveu:
> > +static int alloc_cpus_timestamp_array(struct perf_session *s,
> > +				      struct perf_sample *sample,
> > +				      struct ordered_samples *os)
> > +{
> > +	int i;
> > +	int nr_cpus;
> > +
> > +	if (sample->cpu < s->nr_cpus)
> > +		return 0;
> 
> 
> Shouldn't we try to robustify this checking against HEADER_NRCPUS (if
> present)?
> 
> I just tried to see how to find that info, but unfortunately it just
> prints it when calling perf_header__fprintf_info, it can be made to
> work.
> 
> I need to work on storing those values in a struct accessible thru
> perf_session or perf_evlist, so that I can show that info on the TUI,
> perhaps at that time I can robustify this way.

Yeah I thought about that too. I can try to make that working.
I just thought this was an optimization that I could later add (ie: first
try to see if the core idea of the patch is accepted).

Of course the real long term optimization is going to have one file per
CPU. There, the ordering will be much easier and deterministically
correct.

> 
> > +
> > +	nr_cpus = sample->cpu + 1;
> > +
> > +	if (!os->last_cpu_timestamp)
> > +		os->last_cpu_timestamp = malloc(sizeof(u64) * nr_cpus);
> > +	else
> > +		os->last_cpu_timestamp = realloc(os->last_cpu_timestamp,
> > +						 sizeof(u64) * nr_cpus);
> 
> If realloc fails we return -ENOMEM, but leak the old buffer.

Doh! the common trap with realloc...

> 
> At some point we can have in the TUI/GUI a way for the user to ask for
> an specific perf.data file to be processed, if it fails to process due
> to the above realloc, we'll continue, allowing other perf.data files to
> be processed, but will have this leak.

Ok. Will fix.

Thanks.
