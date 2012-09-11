Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506Ab2IKNWm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 09:22:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47638 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128Ab2IKNWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 09:22:40 -0400
Message-ID: <504F3B18.90403@gmail.com>
Date: Tue, 11 Sep 2012 07:22:32 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        peterz@infradead.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 3/3] perf tool: give user better message if precise is
 not supported
References: <1347295216-1202-1-git-send-email-dsahern@gmail.com> <1347295216-1202-4-git-send-email-dsahern@gmail.com> <20120911092026.GU8285@erda.amd.com>
In-Reply-To: <20120911092026.GU8285@erda.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/11/12 3:20 AM, Robert Richter wrote:
> On 10.09.12 10:40:16, David Ahern wrote:
>> --- a/tools/perf/builtin-record.c
>> +++ b/tools/perf/builtin-record.c
>> @@ -294,6 +294,11 @@ try_again:
>>   					  perf_evsel__name(pos));
>>   				rc = -err;
>>   				goto out;
>> +			} else if ((err == ENOTSUP) && (attr->precise_ip)) {
>
> It is EOPNOTSUPP, did you test this?

I do not post patches without testing them. This particular patch was 
verified in a Virtual Machine (no PEBS) and using :pG modifier.

'egrep -r ENOTSUP tools/perf' shows hits in 3 other files, so I am not 
the only one using the shortcut. I'll change it in the follow up with 
better commit messages to make it consistent with patch 2.

>
>> +				ui__error("\'precise\' request not supported. "
>> +					  "Try removing 'p' modifier\n");
>
> I would better print "... request may not be supported.", since you
> don't know for sure if this is the real cause.

Sure I'll add the 'may not be'.

>
>> +				rc = -err;
>> +				goto out;
>>   			}
>>
>>   			printf("\n");
>> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
>> index 0513aaa..0d3653b 100644
>> --- a/tools/perf/builtin-top.c
>> +++ b/tools/perf/builtin-top.c
>> @@ -975,6 +975,10 @@ try_again:
>>   				ui__error("Too many events are opened.\n"
>>   					    "Try again after reducing the number of events\n");
>>   				goto out_err;
>> +			} else if ((err == ENOTSUP) && (attr->precise_ip)) {
>> +				ui__error("\'precise\' request not supported. "
>> +					  "Try removing 'p' modifier\n");
>
> Same here.
>
>> +				goto out_err;
>
> To avoid adding more duplicate code, maybe we should start to unify
> the code by implementing this in a shared helper function.

Doing that requires additional modifications to not break perl and 
python scripts. Adding it in both commands here is consistent with all 
other open counter failures. Consolidation of those loops into a common 
base is known to do item.

David
