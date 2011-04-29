Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760808Ab1D2T3d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 15:29:33 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:34111 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567Ab1D2T3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 15:29:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=kmcyC+lo1BhNHfK2TV/wlukSCWN7Z5q+gy2vQZrSdkFxFeSiN6/UbyKVRXkBCszi4I
         pXcC2xRxg+B7LAdBWJ/sfNstWKImoyxVvtG66Xh4xZSye8uNfFAmb3yWu0gUntodq1MH
         wWJGls7hrZt9G6Cso95yAQYet6c++lyWi6uNk=
Message-ID: <4DBB1197.9010501@gmail.com>
Date: Fri, 29 Apr 2011 13:29:27 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/stat] perf stat: Fail softly on unsupported events
References: <tip-7y40wib8n006io7hjpn1dsrm@git.kernel.org> <4DBACC5C.1020502@gmail.com> <20110429192347.GA15068@elte.hu>
In-Reply-To: <20110429192347.GA15068@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/29/11 13:23, Ingo Molnar wrote:
> 
> * David Ahern <dsahern@gmail.com> wrote:
> 
>>
>>
>> On 04/29/11 08:27, tip-bot for Ingo Molnar wrote:
>>> Commit-ID:  370faf1dd0461ad811852c8abbbcd3d73b1e4fc4
>>> Gitweb:     http://git.kernel.org/tip/370faf1dd0461ad811852c8abbbcd3d73b1e4fc4
>>> Author:     Ingo Molnar <mingo@elte.hu>
>>> AuthorDate: Fri, 29 Apr 2011 16:11:03 +0200
>>> Committer:  Ingo Molnar <mingo@elte.hu>
>>> CommitDate: Fri, 29 Apr 2011 16:22:33 +0200
>>>
>>> perf stat: Fail softly on unsupported events
>>>
>>> David Ahern reported this perf stat failure:
>>>
>>>> # /tmp/build-perf/perf stat -- sleep 1
>>>>   Error: stalled-cycles-frontend event is not supported.
>>>>   Fatal: Not all events could be opened.
>>>>
>>>> This is a Dell R410 with an E5620 processor.
>>>
>>> Fail in a softer fashion on unknown/unsupported events.
>>>
>>> Reported-by: David Ahern <dsahern@gmail.com>
>>> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
>>> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
>>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>>> Link: http://lkml.kernel.org/n/tip-7y40wib8n006io7hjpn1dsrm@git.kernel.org
>>> Signed-off-by: Ingo Molnar <mingo@elte.hu>
>>> ---
>>>  tools/perf/builtin-stat.c |    4 +---
>>>  1 files changed, 1 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
>>> index 9e596ab..c8b535b 100644
>>> --- a/tools/perf/builtin-stat.c
>>> +++ b/tools/perf/builtin-stat.c
>>> @@ -377,7 +377,7 @@ static int run_perf_stat(int argc __used, const char **argv)
>>>  
>>>  	list_for_each_entry(counter, &evsel_list->entries, node) {
>>>  		if (create_perf_stat_counter(counter) < 0) {
>>> -			if (errno == EINVAL || errno == ENOSYS)
>>> +			if (errno == EINVAL || errno == ENOSYS || errno == ENOENT)
>>>  				continue;
>>>  
>>>  			if (errno == EPERM || errno == EACCES) {
>>> @@ -385,8 +385,6 @@ static int run_perf_stat(int argc __used, const char **argv)
>>>  				      "\t Consider tweaking"
>>>  				      " /proc/sys/kernel/perf_event_paranoid or running as root.",
>>>  				      system_wide ? "system-wide " : "");
>>> -			} else if (errno == ENOENT) {
>>> -				error("%s event is not supported. ", event_name(counter));
>>
>> This silently ignores events -- including ones that a user requested. I
>> think a better option is a continue here.
>>
>>  /tmp/build-perf/perf stat -- sleep 1
>>   Error: stalled-cycles-frontend event is not supported.
>>   Error: stalled-cycles-backend event is not supported.
> 
> Ok. Got time to send a patch for that, which prints whichever message you find 
> the most intuitive? Perhaps word it as:
> 
>  Info: stalled-cycles-frontend event is not supported by the kernel
> 
> to not yell 'error!' at users all the time?

Yes, Error is the wrong prefix, unless the user asked for the event.
It's also not as simple as a continue; the fd array contains 0 so the
command blocks trying to read from fd 0. e.g.:

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 2492a0e..bb1c4dc 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -318,7 +318,7 @@ static int read_counter(struct perf_evsel *counter)
 static int run_perf_stat(int argc __used, const char **argv)
 {
    unsigned long long t0, t1;
-   struct perf_evsel *counter;
+   struct perf_evsel *counter, *n;
    int status = 0;
    int child_ready_pipe[2], go_pipe[2];
    const bool forks = (argc > 0);
@@ -375,7 +375,7 @@ static int run_perf_stat(int argc __used, const char
**argv)
        close(child_ready_pipe[0]);
    }

-   list_for_each_entry(counter, &evsel_list->entries, node) {
+   list_for_each_entry_safe(counter, n, &evsel_list->entries, node) {
        if (create_perf_stat_counter(counter) < 0) {
            if (errno == EINVAL || errno == ENOSYS)
                continue;
@@ -387,6 +387,8 @@ static int run_perf_stat(int argc __used, const char
**argv)
                      system_wide ? "system-wide " : "");
            } else if (errno == ENOENT) {
                error("%s event is not supported. ", event_name(counter));
+               list_del(&counter->node);
+               continue;
            } else {
                error("open_counter returned with %d (%s). "
                      "/bin/dmesg may provide additional information.\n",


That set the xyarray to -1.

David

> 
> Thanks,
> 
> 	Ingo
