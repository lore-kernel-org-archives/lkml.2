Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab2ENHmU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 03:42:20 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:55513 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894Ab2ENHmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 03:42:19 -0400
X-AuditID: 9c930197-b7be2ae000000ebb-08-4fb0b7596d96
From: Namhyung Kim <namhyung.kim@lge.com>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf-record: Create events initially disabled -- again
References: <1336968088-11531-1-git-send-email-dsahern@gmail.com>
Date: Mon, 14 May 2012 16:40:35 +0900
In-Reply-To: <1336968088-11531-1-git-send-email-dsahern@gmail.com> (David
	Ahern's message of "Sun, 13 May 2012 22:01:28 -0600")
Message-ID: <87sjf31a8c.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, 13 May 2012 22:01:28 -0600, David Ahern wrote:
> 764e16a changed perf-record to create events disabled by default and
> enable them once perf initializations are done. This setting was dropped
> by 0f82ebc. Now perf events are once again generated during perf's
> initialization phase (e.g., generating maps).
>
> As an example, perf opens a lot of files at startup. Unpatched:
>
> perf record -e syscalls:sys_enter_open -ga -fo /tmp/perf.data -- sleep 1
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.087 MB /tmp/perf.data (~3798 samples) ]
>
> Using perf-script to look at the samples shows the perf command generating
> 563 of the 566 total events.
>
> Patched:
>
> perf record -e syscalls:sys_enter_open -ga -fo /tmp/perf.data -- sleep 1
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.028 MB /tmp/perf.data (~1206 samples) ]
>
> Using perf-script to look at the samples does not show perf command.
>
> Signed-off-by: David Ahern <dsahern@gmail.com>
> ---
>  tools/perf/util/evsel.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> index 21eaab2..6710cfe 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -70,6 +70,7 @@ void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts,
>  	struct perf_event_attr *attr = &evsel->attr;
>  	int track = !evsel->idx; /* only the first counter needs these */
>  
> +	attr->disabled = 1;
>  	attr->sample_id_all = opts->sample_id_all_missing ? 0 : 1;
>  	attr->inherit	    = !opts->no_inherit;
>  	attr->read_format   = PERF_FORMAT_TOTAL_TIME_ENABLED |
> @@ -138,7 +139,6 @@ void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts,
>  
>  	if (perf_target__none(&opts->target) &&
>  	    (!opts->group || evsel == first)) {
> -		attr->disabled = 1;
>  		attr->enable_on_exec = 1;
>  	}
>  }

A problem I see is that it'll break group handling again:

$ ./perf stat -g sleep 1

 Performance counter stats for 'sleep 1':

     <not counted> task-clock              
     <not counted> context-switches        
     <not counted> CPU-migrations          
     <not counted> page-faults             
     <not counted> cycles                  
     <not counted> stalled-cycles-frontend 
     <not counted> stalled-cycles-backend  
     <not counted> instructions            
     <not counted> branches                
     <not counted> branch-misses           

       1.000868932 seconds time elapsed

So I suggest changing perf_target__none() check to a proper one
(perf_target__no_cpu? - the name might be changed soon) for your
purpose.

Thanks,
Namhyung
