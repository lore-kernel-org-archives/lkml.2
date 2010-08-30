Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab0H3MyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 08:54:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:36706 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab0H3MyX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 08:54:23 -0400
Subject: Re: [RFC][PATCH 2/5] perf: Turn the group counter values into
 delta values
From: Peter Zijlstra <peterz@infradead.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Robert Richter <robert.richter@amd.com>,
        Lin Ming <ming.m.lin@intel.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Don Zickus <dzickus@redhat.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>
In-Reply-To: <1fe2a061e566c83668312ad64800768046f3ac07.1283123521.git.matt@console-pimps.org>
References: <cover.1283123521.git.matt@console-pimps.org>
	 <1fe2a061e566c83668312ad64800768046f3ac07.1283123521.git.matt@console-pimps.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 30 Aug 2010 14:54:01 +0200
Message-ID: <1283172841.1820.895.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-30 at 13:13 +0100, Matt Fleming wrote:
> Change the semantics of the PERF_FORMAT_GROUP records and make them
> delta values, i.e. the difference in value between consecutive reads of
> the hardware counters. These delta values will be used in a subsequent
> patch to calculate weighted values (by multiplying the deltas with the
> time difference between reads of the counters). Calculating these deltas
> is easiest to do in the kernel (as opposed to the userland tools)
> because we can reset the counter whenever we read from it.
> 
> Note that even though this patch changes the semantics of
> PERF_FORMAT_GROUP records there were no users of them anyway (the tools
> didn't even understand them).

libpfmon might be using it,.. I know some people occasionally reported
bugs for this so there are users.

Also, there's no real synchonization between read,read and read,sample
so its racy to do this, simply generate deltas in post-processing.

> Signed-off-by: Matt Fleming <matt@console-pimps.org>
> ---
>  kernel/perf_event.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index 16b0476..2cda375 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -3450,7 +3450,14 @@ static void perf_output_read_group(struct perf_output_handle *handle,
>  	if (leader != event)
>  		leader->pmu->read(leader);
>  
> +	/*
> +	 * Reset the counter value so that ->count contains a delta from
> +	 * the previous value.
> +	 */
>  	values[n++] = perf_event_count(leader);
> +	local64_set(&leader->count, 0);
> +	atomic64_set(&leader->child_count, 0);
> +
>  	if (read_format & PERF_FORMAT_ID)
>  		values[n++] = primary_event_id(leader);
>  
> @@ -3463,6 +3470,9 @@ static void perf_output_read_group(struct perf_output_handle *handle,
>  			sub->pmu->read(sub);
>  
>  		values[n++] = perf_event_count(sub);
> +		local64_set(&sub->count, 0);
> +		atomic64_set(&sub->child_count, 0);
> +
>  		if (read_format & PERF_FORMAT_ID)
>  			values[n++] = primary_event_id(sub);
>  


