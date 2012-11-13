Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302Ab2KMB34 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 20:29:56 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:63019 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968Ab2KMB3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 20:29:55 -0500
X-AuditID: 9c930197-b7b45ae000000e9e-62-50a1a291b91e
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 01/12] perf tools: Keep group information
References: <1352479414-2324-1-git-send-email-namhyung@kernel.org>
	<1352479414-2324-2-git-send-email-namhyung@kernel.org>
	<20121112170833.GE18978@ghostprotocols.net>
Date: Tue, 13 Nov 2012 10:29:53 +0900
In-Reply-To: <20121112170833.GE18978@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Mon, 12 Nov 2012 14:08:33 -0300")
Message-ID: <87pq3imgry.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Nov 2012 14:08:33 -0300, Arnaldo Carvalho de Melo wrote:
> Em Sat, Nov 10, 2012 at 01:43:23AM +0900, Namhyung Kim escreveu:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> Add a few of group-related field in struct perf_{evlist,evsel} so that
>> the group information in a evlist can be known easily.  It only counts
>> groups which have more than 1 members since leader-only groups are
>> treated as non-group events.
>
> We don't need to add a group_idx, we can get it using evsel->idx -
> evsel->leader->idx, interdiff of this patch to what I think is
> equivalent:

Looks good to me.  Just a comment below..

>
> diff -u b/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
> --- b/tools/perf/util/evlist.c
> +++ b/tools/perf/util/evlist.c
> @@ -111,18 +111,16 @@
>  void __perf_evlist__set_leader(struct list_head *list)
>  {
>  	struct perf_evsel *evsel, *leader;
> -	int count = 0;
>  
>  	leader = list_entry(list->next, struct perf_evsel, node);
> +	evsel = list_entry(list->prev, struct perf_evsel, node);
>  	leader->leader = NULL;
> +	leader->nr_members = evsel->idx - leader->idx + 1;

This will lead a off-by-one difference with my patches.  I chose to use
0 nr_members for leader-only group.  It was used for an additional
allocation of group stats but it seems that it's not needed anymore
with the hist_link change.

Thanks,
Namhyung
