Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab2A3Szo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 13:55:44 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45333 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946Ab2A3Szl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 13:55:41 -0500
Date: Mon, 30 Jan 2012 16:55:32 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] perf top: Use active evsel for non-sample events on
 old kernel
Message-ID: <20120130185532.GC15935@infradead.org>
References: <1327827356-8786-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327827356-8786-1-git-send-email-namhyung@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Jan 29, 2012 at 05:55:52PM +0900, Namhyung Kim escreveu:
> If multiple events are specified on old kernel,
> perf_evlist__id2evsel() returns NULL for non-sampling events
> since the sample.id doesn't contain valid value, and it triggers
> assert below. If only one event is given, the function returns
> the evsel regardless of sample.id, this is why most case cause
> no problem on old kernel.
> 
> Fix it by using active evsel.

How about this one instead:

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index a6d50e3..3ffb320 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -349,6 +349,10 @@ struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id)
 	hlist_for_each_entry(sid, pos, head, node)
 		if (sid->id == id)
 			return sid->evsel;
+
+	if (!perf_evlist__sample_id_all(evlist))
+		return list_entry(evlist->entries.next, struct perf_evsel, node);
+
 	return NULL;
 }

That way we won't have to patch other tools that would get the same
problem in such new tool/old kernel combos, right?

Do you see any problem with not checking the header type?

Also please try to avoid using perf_session fields, prefer to use
perf_{evlist,evsel} when possible, in this case you could use
perf_evlist__sample_id_all(evlist), for instance.

- Arnaldo

> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  tools/perf/builtin-top.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> index e8b033c074f9..f68fba52c8d8 100644
> --- a/tools/perf/builtin-top.c
> +++ b/tools/perf/builtin-top.c
> @@ -771,6 +771,14 @@ static void perf_top__mmap_read_idx(struct perf_top *top, int idx)
>  		}
>  
>  		evsel = perf_evlist__id2evsel(session->evlist, sample.id);
> +		if (evsel == NULL && !session->sample_id_all &&
> +		    event->header.type != PERF_RECORD_SAMPLE) {
> +			/*
> +			 * Old kernel, no sample_id_all field.
> +			 * Just use active evsel.
> +			 */
> +			evsel = top->sym_evsel;
> +		}
>  		assert(evsel != NULL);
>  
>  		origin = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
> -- 
> 1.7.8.2
