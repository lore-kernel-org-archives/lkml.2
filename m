Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758769Ab2EPB7K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 21:59:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47764 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757140Ab2EPB7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 21:59:08 -0400
Message-ID: <4FB309E3.10901@gmail.com>
Date: Tue, 15 May 2012 19:58:59 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com
Subject: Re: [PATCH v2 1/5] perf inject: fix broken perf inject -b
References: <1337081295-10303-1-git-send-email-eranian@google.com> <1337081295-10303-2-git-send-email-eranian@google.com>
In-Reply-To: <1337081295-10303-2-git-send-email-eranian@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/15/12 5:28 AM, Stephane Eranian wrote:
> perf inject -b was broken. It would not inject any build_id
> into the stream. Furthermore, it would strip samples from the
> stream.
>
> The reason was a missing initialization of the event attribute
> structure. The perf_tool.tool.attr() callback was pointing to
> a simple repipe. But there was no initialization of the internal
> data structures to keep track of events and event ids. That later
> caused event id lookups to fail, and sample would get removed.
>
> The patch simply adds back the call to perf_event__process_attr()
> to initialize the evlist structure and now build_ids are again
> injected.
>
> Signed-off-by: Stephane Eranian<eranian@google.com>
> ---
>   tools/perf/builtin-inject.c |    5 +++++
>   1 files changed, 5 insertions(+), 0 deletions(-)
>
> diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
> index 09c1061..3beab48 100644
> --- a/tools/perf/builtin-inject.c
> +++ b/tools/perf/builtin-inject.c
> @@ -60,6 +60,11 @@ static int perf_event__repipe_tracing_data_synth(union perf_event *event,
>   static int perf_event__repipe_attr(union perf_event *event,
>   				   struct perf_evlist **pevlist __used)

The _used can be dropped now that pevlist is used.

>   {
> +	int ret;
> +	ret = perf_event__process_attr(event, pevlist);
> +	if (ret)
> +		return ret;
> +
>   	return perf_event__repipe_synth(NULL, event, NULL);
>   }
>

The change seems right, but I could not recreate the dropped events. In 
both cases running:

perf record -o - -m 256 /tmp/a.sh | perf inject -b | perf report -i - -D

where /tmp/a.sh is:

#!/bin/sh
cd /opt/sw/ahern/kernels/kernel.git
make O=/tmp/kbuild -j 32 >/dev/null 2>&1

just to give it some "real work."

With your patch:
            TOTAL events:     284211
             MMAP events:      69236
             COMM events:      10863
             EXIT events:      22858
         THROTTLE events:         11
       UNTHROTTLE events:         11
             FORK events:      11428
           SAMPLE events:     169779
             ATTR events:          1
       EVENT_TYPE events:          1
         BUILD_ID events:         23
cycles stats:
            TOTAL events:     284186
             MMAP events:      69236
             COMM events:      10863
             EXIT events:      22858
         THROTTLE events:         11
       UNTHROTTLE events:         11
             FORK events:      11428
           SAMPLE events:     169779


Current acme/core:
            TOTAL events:     288990
             MMAP events:      69236
             COMM events:      10863
             EXIT events:      22858
         THROTTLE events:         20
       UNTHROTTLE events:         20
             FORK events:      11428
           SAMPLE events:     174538
             ATTR events:          1
       EVENT_TYPE events:          1
         BUILD_ID events:         25
cycles stats:
            TOTAL events:     288963
             MMAP events:      69236
             COMM events:      10863
             EXIT events:      22858
         THROTTLE events:         20
       UNTHROTTLE events:         20
             FORK events:      11428
           SAMPLE events:     174538


David

[1] Both tests have Namhyung's patch:
https://lkml.org/lkml/2012/5/15/280
