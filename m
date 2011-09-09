Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688Ab1IIACU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 20:02:20 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42146 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756522Ab1IIACS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 20:02:18 -0400
Message-ID: <4E695784.7020303@gmail.com>
Date: Fri, 09 Sep 2011 10:02:12 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Lightning/1.0b2 Thunderbird/3.1.13
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Mark Salter <msalter@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Pass correct length to strnlen_user in fs/exec.c
References: <4E680EBC.4000804@gmail.com> <20110908165213.6ebd844f.akpm@linux-foundation.org>
In-Reply-To: <20110908165213.6ebd844f.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/11 09:52, Andrew Morton wrote:
> On Thu, 08 Sep 2011 10:39:24 +1000
> Ryan Mallon <rmallon@gmail.com> wrote:
>
>> Replace valid_arg_len function in fs/exec.c with max_arg_len function
>> and pass the correct length to strnlen_user.
>>
>> --- a/fs/exec.c
>> +++ b/fs/exec.c
>> @@ -296,9 +296,9 @@ err:
>>  	return err;
>>  }
>>  
>> -static bool valid_arg_len(struct linux_binprm *bprm, long len)
>> +static long max_arg_len(struct linux_binprm *bprm)
>>  {
>> -	return len <= MAX_ARG_STRLEN;
>> +	return MAX_ARG_STRLEN;
>>  }
>>  
>>  #else
>> @@ -354,9 +354,9 @@ static int __bprm_mm_init(struct linux_binprm *bprm)
>>  	return 0;
>>  }
>>  
>> -static bool valid_arg_len(struct linux_binprm *bprm, long len)
>> +static long max_arg_len(struct linux_binprm *bprm)
>>  {
>> -	return len <= bprm->p;
>> +	return bprm->p;
>>  }
>>  
>>  #endif /* CONFIG_MMU */
>> @@ -474,18 +474,19 @@ static int copy_strings(int argc, struct user_arg_ptr argv,
>>  		const char __user *str;
>>  		int len;
>>  		unsigned long pos;
>> +		long max_len = max_arg_len(bprm);
>>  
>>  		ret = -EFAULT;
>>  		str = get_user_arg_ptr(argv, argc);
>>  		if (IS_ERR(str))
>>  			goto out;
>>  
>> -		len = strnlen_user(str, MAX_ARG_STRLEN);
>> -		if (!len || len > MAX_ARG_STRLEN)
>> +		len = strnlen_user(str, max_len);
>> +		if (!len)
>>  			goto out;
>>  
>>  		ret = -E2BIG;
>> -		if (!valid_arg_len(bprm, len))
>> +		if (len > max_len)
>>  			goto out;
>>  
>>  		/* We're going to work our way backwords. */
> I'm struggling to find a reason to merge this - it churns code around
> rather pointlessly?
>
That's fine. I originally went looking after a discussion with Mark
about the weird strnlen_user semantics  and this usage looked incorrect
to me because it wasn't obviously checking >= MAX_ARG_STRLEN.

The rework I think makes it a bit more clear and passes the correct max
length to strnlen_user. Its a bit odd to pass MAX_ARG_STRLEN and then
check if it is longer than bprm->len, and I guess assumes that bprm->len
is less than MAX_ARG_STRLEN.

Feel free to drop the patch if you think it is just churn.

~Ryan


