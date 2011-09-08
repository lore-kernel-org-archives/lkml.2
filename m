Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148Ab1IHAUy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 20:20:54 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52289 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756373Ab1IHAUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 20:20:52 -0400
Message-ID: <4E680A5D.7050903@gmail.com>
Date: Thu, 08 Sep 2011 10:20:45 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Lightning/1.0b2 Thunderbird/3.1.13
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Mark Salter <msalter@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "trivial@kernel.org" <trivial@kernel.org>
Subject: Re: [PATCH][REPOST] Check maxlen on strnlen_user usage
References: <4E68042A.1050406@gmail.com> <20110907170621.389b1314.akpm@linux-foundation.org>
In-Reply-To: <20110907170621.389b1314.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/11 10:06, Andrew Morton wrote:
> On Thu, 08 Sep 2011 09:54:18 +1000
> Ryan Mallon<rmallon@gmail.com>  wrote:
>
>> strnlen_user returns the length of the string including the nul
>> terminator. In the case where maxlen is reached strnlen_user returns
>> maxlen + 1. Most callsites already check for this condition. Fix the
>> call to strnlen_user in fs/exec.c to check for the maxlen case.
>>
>> diff --git a/fs/exec.c b/fs/exec.c
>> index 25dcbe5..e19588c 100644
>> --- a/fs/exec.c
>> +++ b/fs/exec.c
>> @@ -481,7 +481,7 @@ static int copy_strings(int argc, struct
>> user_arg_ptr argv,
>>    			goto out;
>>
>>    		len = strnlen_user(str, MAX_ARG_STRLEN);
>> -		if (!len)
>> +		if (!len || len>   MAX_ARG_STRLEN)
>>    			goto out;
>>
>>    		ret = -E2BIG;
> The following call to vald_arg_len() already does this?
>
> This change will cause copy_strings() to incorrectly return -EFAULT,
> rather than -E2BIG.
Hmm, missed that. How about the patch below instead which passes the 
correct length to strnlen_user?
> Your email client is wordwrapping and space-stuffing the patches, btw.
I'll try again. Hopefully it works this time.

---
Replace valid_arg_len function in fs/exec.c with max_arg_len function 
and pass the correct length to strnlen_user.

Signed-off-by: Ryan Mallon <rmallon@gmail.com>
---

diff --git a/fs/exec.c b/fs/exec.c
index e19588c..12d2f7f 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -296,9 +296,9 @@ err:
  	return err;
  }

-static bool valid_arg_len(struct linux_binprm *bprm, long len)
+static long max_arg_len(struct linux_binprm *bprm)
  {
-	return len<= MAX_ARG_STRLEN;
+	return MAX_ARG_STRLEN;
  }

  #else
@@ -354,9 +354,9 @@ static int __bprm_mm_init(struct linux_binprm *bprm)
  	return 0;
  }

-static bool valid_arg_len(struct linux_binprm *bprm, long len)
+static long max_arg_len(struct linux_binprm *bprm)
  {
-	return len<= bprm->p;
+	return bprm->p;
  }

  #endif /* CONFIG_MMU */
@@ -474,18 +474,19 @@ static int copy_strings(int argc, struct user_arg_ptr argv,
  		const char __user *str;
  		int len;
  		unsigned long pos;
+		long max_len = max_arg_len(bprm);

  		ret = -EFAULT;
  		str = get_user_arg_ptr(argv, argc);
  		if (IS_ERR(str))
  			goto out;

-		len = strnlen_user(str, MAX_ARG_STRLEN);
-		if (!len || len>  MAX_ARG_STRLEN)
+		len = strnlen_user(str, max_len);
+		if (!len)
  			goto out;

  		ret = -E2BIG;
-		if (!valid_arg_len(bprm, len))
+		if (len>  max_len)
  			goto out;

  		/* We're going to work our way backwords. */


