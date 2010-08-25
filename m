Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065Ab0HYB6u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 21:58:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52720 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756286Ab0HYB6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 21:58:48 -0400
Message-ID: <4C7478C2.10900@redhat.com>
Date: Wed, 25 Aug 2010 09:58:26 +0800
From: Xiaotian Feng <dfeng@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/3.0.6-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-fsdevel@vger.kernel.org, nhorman@tuxdriver.com,
        linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH v4] core_pattern: fix long parameters was truncated by
 core_pattern handler
References: <20100823141843.f177bf1f.akpm@linux-foundation.org>	<1282642966-2296-1-git-send-email-dfeng@redhat.com> <20100824154745.779ed12b.akpm@linux-foundation.org>
In-Reply-To: <20100824154745.779ed12b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2010 06:47 AM, Andrew Morton wrote:
> On Tue, 24 Aug 2010 17:42:46 +0800
> Xiaotian Feng<dfeng@redhat.com>  wrote:
>
>> We met a parameter truncated issue, consider following:
>>>> echo "|/root/core_pattern_pipe_test %p /usr/libexec/blah-blah-blah \
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
>> Changes since v3:
>> make handling of single char also uses cn_printf, suggested by Andrew Morton.
>>
>> Changes since v2:
>> Introduced generic function cn_printf and make format_corename remember the time
>> has been expanded, suggested by Olg Nesterov and Neil Horman.
>>
>> Changes since v1:
>> This patch allocates corename at runtime, if the replace doesn't have enough
>> memory, expand the corename dynamically, suggested by Neil Horman.
>>
>> I've tested with some core_pattern strings, it works fine now.
>
> cool, thanks.
>
>>
>> ...
>>
>> -static int format_corename(char *corename, long signr)
>> +static int format_corename(struct core_name *cn, long signr)
>>   {
>>   	const struct cred *cred = current_cred();
>>   	const char *pat_ptr = core_pattern;
>>   	int ispipe = (*pat_ptr == '|');
>> -	char *out_ptr = corename;
>> -	char *const out_end = corename + CORENAME_MAX_SIZE;
>> -	int rc;
>>   	int pid_in_pattern = 0;
>> +	int err = 0;
>> +
>> +	cn->size = CORENAME_MAX_SIZE * atomic_read(&call_count);
>> +	cn->corename = kmalloc(cn->size, GFP_KERNEL);
>> +	cn->used = 0;
>> +
>> +	if (!cn->corename)
>> +		return -ENOMEM;
>>
>>   	/* Repeat as long as we have more pattern to process and more output
>>   	   space */
>>   	while (*pat_ptr) {
>>   		if (*pat_ptr != '%') {
>> -			if (out_ptr == out_end)
>> -				goto out;
>> -			*out_ptr++ = *pat_ptr++;
>> +			err = cn_printf(cn, "%c", *pat_ptr++);
>>   		} else {
>>   			switch (*++pat_ptr) {
>> +			/* single % at the end, drop that */
>>   			case 0:
>> +				err = cn_printf(cn, "%c", '\0');
>
> Confused.  Doesn't this bit just add another \0 to the end of an
> already-null-terminated string?  And then make cn->used get out of sync
> with strlen(cn->corename)?
>
Good catch, I just realized the return value of vsnprintf is not 
including the trailing '\0', will follow an updated v5 patch. Thanks Andrew.


