Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab0HXGSz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 02:18:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283Ab0HXGSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 02:18:53 -0400
Message-ID: <4C736438.8010206@redhat.com>
Date: Tue, 24 Aug 2010 14:18:32 +0800
From: Xiaotian Feng <dfeng@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/3.0.6-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Roland McGrath <roland@redhat.com>
Subject: Re: [RFC PATCH v3] core_pattern: fix long parameters was truncated
 by core_pattern handler
References: <20100803105941.GA2996@hmsreliant.think-freely.org>	<1282296958-2427-1-git-send-email-dfeng@redhat.com> <20100823141843.f177bf1f.akpm@linux-foundation.org>
In-Reply-To: <20100823141843.f177bf1f.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2010 05:18 AM, Andrew Morton wrote:
> On Fri, 20 Aug 2010 17:35:58 +0800
> Xiaotian Feng<dfeng@redhat.com>  wrote:
>
>> We met a parameter truncated issue, consider following:
>>> echo "|/root/core_pattern_pipe_test %p /usr/libexec/blah-blah-blah \
>> %s %c %p %u %g 11 12345678901234567890123456789012345678 %t">  \
>> /proc/sys/kernel/core_pattern
>>
>> This is okay because the strings is less than CORENAME_MAX_SIZE.
>> "cat /proc/sys/kernel/core_pattern" shows the whole string. but
>> after we run core_pattern_pipe_test in man page, we found last
>> parameter was truncated like below:
>>          argc[10]=<12807486>
>>
>> The root cause is core_pattern allows % specifiers, which need to be
>> replaced during parse time, but the replace may expand the strings
>> to larger than CORENAME_MAX_SIZE. So if the last parameter is %
>> specifiers, the replace code is using snprintf(out_ptr, out_end - out_ptr, ...),
>> this will write out of corename array.
>>
>> Changes since v2:
>> Introduced generic function cn_printf and make format_corename remember the time
>> has been expanded.
>>
>> Changes since v1:
>> This patch allocates corename at runtime, if the replace doesn't have enough
>> memory, expand the corename dynamically.
>
>
>> +			if (cn->used == cn->size)
>> +				if (expand_corename(cn))
>> +					goto out_fail;
>> +
>> +			out_ptr = cn->corename + cn->used;
>> +			*out_ptr = *pat_ptr++;
>> +			cn->used++;
>
>
>> -				if (out_ptr == out_end)
>> -					goto out;
>> -				*out_ptr++ = '%';
>> +				if (cn->used == cn->size)
>> +					if (expand_corename(cn))
>> +						goto out_fail;
>> +
>> +				out_ptr = cn->corename + cn->used;
>> +				*out_ptr = '%';
>> +				cn->used++;
>
>
>> +	out_ptr = cn->corename + cn->used;
>> +	if (cn->used == cn->size)
>> +		if (expand_corename(cn))
>> +			goto out_fail;
>> +
>> +	out_ptr = cn->corename + cn->used;
>>   	*out_ptr = 0;
>
> Quite a bit of code duplication there.  A little helper function which
> adds a single char to the output would tidy that up.
Yep, this would be much more cleaner ;-)
>
> However I think that if the % and %% handers are converted to call
> cn_printf() then the output is always null-terninated and the third
> hunk of code above simply becomes unneeded?
You are absolutely right ;-)
>
> Something like this, although I didn't try very hard.  Just a
> suggestion to work with ;)
>
Yep,  we just need change a little on your patch

	- err = cn_printf(cn, "%%");
	+ err = cn_printf(cn, "%");

Do you need me to resend a v4 patch?

