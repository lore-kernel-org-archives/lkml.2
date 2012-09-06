Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759491Ab2IFTR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 15:17:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65002 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab2IFTRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 15:17:24 -0400
Message-ID: <5048F6BF.70106@gmail.com>
Date: Thu, 06 Sep 2012 13:17:19 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH 08/11] perf tool: precise mode requires exclude_guest
References: <1342826756-64663-1-git-send-email-dsahern@gmail.com> <1342826756-64663-9-git-send-email-dsahern@gmail.com> <20120906190238.GA29278@erda.amd.com>
In-Reply-To: <20120906190238.GA29278@erda.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/6/12 1:02 PM, Robert Richter wrote:
> David,
>
> just found your patch...
>
> On 20.07.12 17:25:53, David Ahern wrote:
>> PEBS cannot be used with guest mode. If user adds :p modifier set
>> exclude_guest as well.
>
>> @@ -653,6 +653,9 @@ int parse_events_modifier(struct list_head *list, char *str)
>>   			eH = 0;
>>   		} else if (*str == 'p') {
>>   			precise++;
>> +			/* use of precise requires exclude_guest */
>> +			if (!exclude_GH)
>> +				eG = 1;
>
> We should only enable exclude_guest if no G/H modifiers are given on
> the command line. If I correctly read the code this is indicated by
> exclude_GH and correctly implemented.

yes.

>
> To summarize how I think it should work:
>
>   -e cycles:p ..... Enable exclude_guest bit. If the syscall fails,
>                     fall back by disabling the guest bit and send
>                     syscall again

I think the fallback scenarios are getting out of hand -- too many and 
too many combinations. For this case (:p only) I proposed setting 
exclude_guest. It should not fail if the pebs/ibs is supported. If so, 
give the user a helpful message. e.g., https://lkml.org/lkml/2012/7/20/440


>
>   -e cycles:pGH ... Do not enable exclude_guest/_host. Do not fall back
>                     on syscall errors.

In this case give the user a message that the requested combination is 
invalid. I have a patch similar to the one above for this.

>
> Same for the case the p modifier is not set.
>
> So we have the following:
>
>   G           ... set exclude_host bit, clear exclude_guest
>   H           ... set exclude_guest bit, clear exclude_host
>   GH          ... clear both exclude_guest/_host
>   <no G or H> ... default (set exclude_host bit, clear exclude_guest),
>                   but fall back on syscall errors to clear both
>                   exclude_guest/_host

you lost me on the last one. If the user specifies no attributes on the 
events then exclude_host/exclude_guest is controlled by the 
perf_host/perf_guest variables - see event_attr_init().

>
> The modifier parser should be correctly implemented and should work
> with ibs. Will test this patch.

Thanks!

David
