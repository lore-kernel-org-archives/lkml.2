Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab2AJL5G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 06:57:06 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41213 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755896Ab2AJL5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 06:57:03 -0500
Date: Tue, 10 Jan 2012 11:56:02 +0000
From: Will Deacon <will.deacon@arm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "mingo@elte.hu" <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@suse.de" <gregkh@suse.de>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: perf event group siblings not counting in mainline
Message-ID: <20120110115602.GC24180@mudshark.cambridge.arm.com>
References: <20111224125415.GA14559@mudshark.cambridge.arm.com>
 <20120110110942.GB24180@mudshark.cambridge.arm.com>
 <1326194188.2442.106.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326194188.2442.106.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 11:16:28AM +0000, Peter Zijlstra wrote:
> On Tue, 2012-01-10 at 11:09 +0000, Will Deacon wrote:
> > On Sat, Dec 24, 2011 at 12:54:15PM +0000, Will Deacon wrote:
> > > If I try using perf with event groups on a mainline kernel, only the group
> > > leader counts:

[...]

> > Now that 3.2 is out with this regression, would it be possible to get this
> > (b79387ef ("perf: Fix enable_on_exec for sibling events")) into -stable please?
> 
> How can this be a regression? Its always been like that. At worst its a
> broken new feature.

My mistake, for some reason I thought this had always had the new behaviour.

> Also, you really shouldn't set enable_on_exec on non group leaders,
> that's just daft. But yes that patch sorts it. Something like the below
> should too.

>From a perf stat perspective, it should probably do the right thing then.

> 
> ---
>  tools/perf/builtin-stat.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
> index f5d2a63..623519f 100644
> --- a/tools/perf/builtin-stat.c
> +++ b/tools/perf/builtin-stat.c
> @@ -298,7 +298,7 @@ static int create_perf_stat_counter(struct perf_evsel *evsel,
>  						group, group_fd);
>  	if (target_pid == -1 && target_tid == -1) {
>  		attr->disabled = 1;
> -		attr->enable_on_exec = 1;
> +		attr->enable_on_exec = !group_fd;
>  	}
>  
>  	return perf_evsel__open_per_thread(evsel, evsel_list->threads,

Had to make a small change so that that the siblings don't get stuck as
disabled:


diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 955930e..a0f4b26 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -296,10 +296,9 @@ static int create_perf_stat_counter(struct perf_evsel *evsel,
        if (system_wide)
                return perf_evsel__open_per_cpu(evsel, evsel_list->cpus,
                                                group, group_fd);
-       if (target_pid == -1 && target_tid == -1) {
-               attr->disabled = 1;
-               attr->enable_on_exec = 1;
-       }
+
+       if (target_pid == -1 && target_tid == -1)
+               attr->disabled = attr->enable_on_exec = !group_fd;
 
        return perf_evsel__open_per_thread(evsel, evsel_list->threads,
                                           group, group_fd);


but that seems to do it - thanks!

Tested-by: Will Deacon <will.deacon@arm.com>

It would be nice to see this in -stable, but as it's not a regression I'll
leave it up to you.

Cheers,

Will
