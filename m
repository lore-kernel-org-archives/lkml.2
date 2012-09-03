Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab2ICFV5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 01:21:57 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:51900 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656Ab2ICFVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 01:21:10 -0400
MIME-Version: 1.0
In-Reply-To: <87txvfev6o.fsf@sejong.aot.lge.com>
References: <CANg8OWLL6gzUpZuq8YT2bSbT5=EVWejbpCX0TM8dt7mKXyZ9Yg@mail.gmail.com>
	<87txvfev6o.fsf@sejong.aot.lge.com>
Date: Mon, 3 Sep 2012 08:21:08 +0300
X-Google-Sender-Auth: bRIEGmj1EPYLbp5lrsjOxW3Gjb8
Message-ID: <CAOJsxLESFr7BmyYQGxNSaS3JXVziZ=z_q7OUj-LoEJc367rcYQ@mail.gmail.com>
Subject: Re: [PATCH] perf bench: fix assert when NDEBUG is defined
From: Pekka Enberg <penberg@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Irina Tirdea <irina.tirdea@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 3, 2012 at 4:45 AM, Namhyung Kim <namhyung@kernel.org> wrote:
> On Mon, 3 Sep 2012 03:04:32 +0300, Irina Tirdea wrote:
>> From: Irina Tirdea <irina.tirdea@intel.com>
>>
>> When NDEBUG is defined, the assert macro will be expanded to nothing.
>> Some assert calls used in perf are also including some functionality
>> (e.g. system calls), not only validity checks. Therefore, if NDEBUG is
>> defined, these functionality will be removed along with the assert.
>>
>> The functionality of the program needs to be separated from the assert checks.
>> In perf, BUG_ON is also defined on assert, so we need to fix these statements
>> too.
>>
>> Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
>> ---
>>  tools/perf/bench/mem-memcpy.c |    8 +++++---
>>  tools/perf/bench/mem-memset.c |    8 +++++---
>>  tools/perf/bench/sched-pipe.c |    6 ++++--
>>  3 files changed, 14 insertions(+), 8 deletions(-)
>>
>> diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
>> index 02dad5d..bccb783 100644
>> --- a/tools/perf/bench/mem-memcpy.c
>> +++ b/tools/perf/bench/mem-memcpy.c
>> @@ -144,17 +144,19 @@ static double do_memcpy_gettimeofday(memcpy_t
>> fn, size_t len, bool prefault)
>>  {
>>       struct timeval tv_start, tv_end, tv_diff;
>>       void *src = NULL, *dst = NULL;
>> -     int i;
>> +     int i, ret;
>>
>>       alloc_mem(&src, &dst, len);
>>
>>       if (prefault)
>>               fn(dst, src, len);
>>
>> -     BUG_ON(gettimeofday(&tv_start, NULL));
>> +     ret = gettimeofday(&tv_start, NULL);
>> +     BUG_ON(ret);
>
> I think one of good thing of assert is that it outputs the exact failure
> condition when it fails.  So with patch, it will convert
>
>   Assertion `gettimeofday(&tv_start, NULL)' failed.
>
> into
>
>   Assertion `ret' failed.
>
> which is not so informative.
>
> So I'd rather suggest using more descriptive names like ret_gtod ?

No, please don't do that. That'll make the code ugly and it's really
just papering over the fact that the assertions should be converted to
proper error handling.
