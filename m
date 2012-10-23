Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933181Ab2JWQNj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 12:13:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:45040 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198Ab2JWQNi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 12:13:38 -0400
Message-ID: <1351008789.13456.37.camel@twins>
Subject: Re: [PATCH 02/11] perf: Do not get values from disabled counters in
 group format read
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Date: Tue, 23 Oct 2012 18:13:09 +0200
In-Reply-To: <1350743599-4805-3-git-send-email-jolsa@redhat.com>
References: <1350743599-4805-1-git-send-email-jolsa@redhat.com>
	 <1350743599-4805-3-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-10-20 at 16:33 +0200, Jiri Olsa wrote:
> It's possible some of the counters in the group could be
> disabled when sampling member of the event group is reading
> the rest via PERF_SAMPLE_READ sample type processing. Disabled
> counters could then produce wrong numbers.
> 
> Fixing that by reading only enabled counters for PERF_SAMPLE_READ
> sample type processing.
> 

However did you run into this?

> ---
>  kernel/events/core.c | 18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 32aec40..5220d01 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -4012,12 +4012,24 @@ static void perf_output_read_group(struct perf_output_handle *handle,
>  	__output_copy(handle, values, n * sizeof(u64));
>  
>  	list_for_each_entry(sub, &leader->sibling_list, group_entry) {
> +		u64 value = 0;
>  		n = 0;
>  
> -		if (sub != event)
> -			sub->pmu->read(sub);
> +		/*
> +		 * We are NOT interested in disabled counters,
> +		 * giving us strange values and keeping us from
> +		 * good night sleep!!!
> +		 */
> +		if (sub->state > PERF_EVENT_STATE_OFF) {
> +

superfluous whitespace there... ;-)

> +			if (sub != event)
> +				sub->pmu->read(sub);
> +
> +			value = perf_event_count(sub);
> +		}
> +
> +		values[n++] = value;
>  
> -		values[n++] = perf_event_count(sub);
>  		if (read_format & PERF_FORMAT_ID)
>  			values[n++] = primary_event_id(sub);
>  

