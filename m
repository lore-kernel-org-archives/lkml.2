Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536Ab2CICiJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 21:38:09 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:52691 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab2CICiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 21:38:07 -0500
X-AuditID: 9c930179-b7c4fae0000073fb-9a-4f596d0c98fc
Message-ID: <4F596D0A.9050009@lge.com>
Date: Fri, 09 Mar 2012 11:38:02 +0900
From: Namhyung Kim <namhyung.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@gmail.com>,
        Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RFC] perf tools: Handle old kernels when opening perf
 event
References: <1331191731-29541-1-git-send-email-namhyung.kim@lge.com> <20120308145024.GA1764@infradead.org>
In-Reply-To: <20120308145024.GA1764@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2012-03-08 11:50 PM, Arnaldo Carvalho de Melo wrote:
> Em Thu, Mar 08, 2012 at 04:28:51 PM +0900, Namhyung Kim escreveu:
>> Changing default value of perf_guest back to false caused problems on old
>> kernels and its fix bc76efe64533 ("perf tools: Handle kernels that don't
>> support attr.exclude_{guest,host}") worked well for perf record/top.
>>
>> But I've just realized that using specific events on perf stat makes same
>> kind of troubles too. It's because the parse_events calls event_attr_init
>> for all events so that it would have exclude_guest set.
>>
>> Instead of fixing perf stat, I thought that changing perf_evsel__open()
>> is more appropriate. Please take a look and give comments - especially
>> on ->time_not_needed handling in builtin-record.c (I guess the original
>> code had a bug) and checking ->sample_id_all_missing inside of
>> perf_evsel__config (I believe checking it before perf_evsel__open is
>> meaningless since it will always have the same value - so I dropped it).
>
> One problem here is to have all those pr_debug calls down in the
> perf_evlist class, they need to be better conveyed to the user, and that
> depends on the kind of interface being used (stdio, TUI, GTK).
>
> One approach tried till the GTK patch was proposed was to just check the
> value of perf_browser or some UI fops table to do it at that level.
>
> But Pekka argued that we should allow tool writers to have more freedom
> than that, i.e. handle things as flexibly as possible.
>

Agreed.


> The way to do that, that I discussed with David Ahern some time ago, was
> to have per class errno enums, and then a per class strerror (really an
> strerror_r) that would map the integer error number to an string.
>
> Doing that we would also avoid having to bloat the python binding (or
> libperf at some point) with the pr_debug, etc machinery.
>

I remember that discussion. Yes, it'll show more verbose and helpful messages 
when user got in trouble. But I don't have an idea how it helps in this 
particular case - we anyway want to show user some message and keep going on. 
Could you explain your idea in little more detail?


> For instance, with your patch applied, try running
> tools/perf/python/twatch.py :-)
>

Oops, I didn't noticed, sorry. I'll check twatch.py next time I touch python 
binding codes.

BTW, how about simply adding its own eprintf implementation?


> Other than that, yeah, I think perf_attr_conf is needed and the rest of
> the patch looks ok, will look again after you address the above
> comments,
>
> Thanks!
>
> - Arnaldo
>

Thanks for your review,
Namhyung

