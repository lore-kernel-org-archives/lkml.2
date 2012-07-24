Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab2GXOC5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 10:02:57 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51382 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342Ab2GXOC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 10:02:56 -0400
Message-ID: <500EAB0C.8090504@gmail.com>
Date: Tue, 24 Jul 2012 08:02:52 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 11/11] perf kvm top: limit guest kernel info message to
 once
References: <1342826756-64663-1-git-send-email-dsahern@gmail.com> <1342826756-64663-12-git-send-email-dsahern@gmail.com> <20120723181708.GE6717@infradead.org>
In-Reply-To: <20120723181708.GE6717@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/23/12 12:17 PM, Arnaldo Carvalho de Melo wrote:
> Em Fri, Jul 20, 2012 at 05:25:56PM -0600, David Ahern escreveu:
>> 'perf kvm top' shows a continual flurry of:
>>      Can't find guest [5201]'s kernel information
>>
>> if it can't find the guest info and with a lot of VMs running a user
>> has no chance of reading them all. Limit message to once per guest.
>>
>> Signed-off-by: David Ahern <dsahern@gmail.com>
>> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
>> Cc: Ingo Molnar <mingo@kernel.org>
>> Cc: Jiri Olsa <jolsa@redhat.com>
>> Cc: Namhyung Kim <namhyung@kernel.org>
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> ---
>>   tools/perf/builtin-top.c |   14 ++++++++++++--
>>   1 file changed, 12 insertions(+), 2 deletions(-)
>>
>> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
>> index 1706dc9..6285374 100644
>> --- a/tools/perf/builtin-top.c
>> +++ b/tools/perf/builtin-top.c
>> @@ -706,8 +706,18 @@ static void perf_event__process_sample(struct perf_tool *tool,
>>   	int err;
>>
>>   	if (!machine && perf_guest) {
>> -		pr_err("Can't find guest [%d]'s kernel information\n",
>> -			event->ip.pid);
>> +		static struct strlist *seen;
>> +		char pidstr[8];
>> +
>> +		if (!seen)
>> +			seen = strlist__new(true, NULL);
>> +
>> +		scnprintf(pidstr, sizeof(pidstr), "%d", event->ip.pid);
>> +		if (!strlist__has_entry(seen, pidstr)) {
>> +			pr_err("Can't find guest [%d]'s kernel information\n",
>> +				event->ip.pid);
>> +			strlist__add(seen, pidstr);
>> +		}
>
> Abuse of strlist? Can't we have an intlist?

Use of existing facility. :-) I'll look at adding an intlist facility.

David

