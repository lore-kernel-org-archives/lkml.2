Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759449Ab2D0ARR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 20:17:17 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:43986 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520Ab2D0ARQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 20:17:16 -0400
X-AuditID: 9c930179-b7bfaae000006f69-d0-4f99e589f296
From: Namhyung Kim <namhyung.kim@lge.com>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/13] perf evlist: Fix creation of cpu map
References: <1335417327-11796-1-git-send-email-namhyung.kim@lge.com>
	<1335417327-11796-8-git-send-email-namhyung.kim@lge.com>
	<4F996433.7040003@gmail.com> <1335474778.1497.14.camel@leonhard>
	<4F99BCAF.1080309@gmail.com>
Date: Fri, 27 Apr 2012 09:16:18 +0900
In-Reply-To: <4F99BCAF.1080309@gmail.com> (David Ahern's message of "Thu, 26
	Apr 2012 15:22:55 -0600")
Message-ID: <87397qhvvx.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 26 Apr 2012 15:22:55 -0600, David Ahern wrote:
> On 4/26/12 3:12 PM, Namhyung Kim wrote:
>> Hmm.. No, I can reproduce it without any of this series. And now I think
>> that it is not related to the number of cpus. On my 4 core (no
>> hyperthreading) machine at home, the result was same.
>>
>> BTW, did you change sysctl settings?
>>
>>    $ cat /sys/devices/system/cpu/online
>>    0-3
>>    $ grep . /proc/sys/kernel/perf_event_*
>>    /proc/sys/kernel/perf_event_max_sample_rate:100000
>>    /proc/sys/kernel/perf_event_mlock_kb:516
>>    /proc/sys/kernel/perf_event_paranoid:1
>
> $ grep . /proc/sys/kernel/perf_event_*
> /proc/sys/kernel/perf_event_max_sample_rate:100000
> /proc/sys/kernel/perf_event_mlock_kb:516
> /proc/sys/kernel/perf_event_paranoid:-1
>
> That last one is the key. I have it set to not paranoid and usually
> run perf a non-root user.
>

That's exactly what I want to see :). On perf_mmap() we have:

	if ((locked > lock_limit) && perf_paranoid_tracepoint_raw() &&
		!capable(CAP_IPC_LOCK)) {
		ret = -EPERM;
		goto unlock;
	}

So as long as you set perf_event_paranoid to -1 or run perf test as
root, you cannot see the failure.

Thanks,
Namhyung


>>    $ ./perf test 7
>>     7: Validate PERF_RECORD_* events&  perf_sample fields: FAILED!
>>    $ ./perf --version
>>    perf version 3.4.rc1
>
> running 3.4-rc4 kernel + perf from tip/perf/core branch.
>
> David
