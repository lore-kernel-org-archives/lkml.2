Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377Ab0HGMZR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 08:25:17 -0400
Received: from lo.gmane.org ([80.91.229.12]:35271 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752996Ab0HGMZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 08:25:13 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Alexander Clouter <alex@digriz.org.uk>
Subject: Re: [PATCH]exit.c: support larger exit code
Date: Sat, 7 Aug 2010 11:41:33 +0100
Message-ID: <trpvi7-qh6.ln1@chipmunk.wormnet.eu>
References: <14414B36FFA0F1418CB707361EAA199A0194F7D2@CNBEEXC006.nsn-intra.net> <20100806124456.GA9107@redhat.com>
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: chipmunk.wormnet.eu
User-Agent: tin/1.9.3-20080506 ("Dalintober") (UNIX) (Linux/2.6.26-2-sparc64-smp (sparc64))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:
>>
>> Nowadays userspace application use systemcall exit/exit_group only
>> support one byte exit code.
>> In some cases this exit code range is too small for some "big
>> application"(like telecom software, 255 is not enough).
>>
>> So we can give some "big application" a chance to get larger exit code
>> from child process.
>> For other application don't want use larger exit code, they can use
>> marco WEXITSTATUS to get lower one byte exit code.
>>
>> #define WEXITSTATUS(status)   __WEXITSTATUS (__WAIT_INT (status))
>> --- stdlib.h
>> #define       __WEXITSTATUS(status)   (((status) & 0xff00) >> 8)
>> --- usrbits/waitstatus.h
>>
>>
>> diff --git a/kernel/exit.c b/kernel/exit.c
>> index ceffc67..8b13676 100644
>> --- a/kernel/exit.c
>> +++ b/kernel/exit.c
>> @@ -1045,7 +1045,7 @@ EXPORT_SYMBOL(complete_and_exit);
>>
>>  SYSCALL_DEFINE1(exit, int, error_code)
>>  {
>> -       do_exit((error_code&0xff)<<8);
>> +       do_exit(error_code << 8);
>>  }
>>
>>  /*
>> @@ -1086,7 +1086,7 @@ do_group_exit(int exit_code)
>>   */
>>  SYSCALL_DEFINE1(exit_group, int, error_code)
>>  {
>> -       do_group_exit((error_code & 0xff) << 8);
>> +       do_group_exit(error_code << 8);
>>         /* NOTREACHED */
>>         return 0;
>>  }
> 
> Hmm. Looking at this patch, I am wondering what was the reason for the
> current one-byte limitation.
>
The one byte limitation I think is all that is needed to give an 
impression and *hint* of what went wrong, it was not ever meant to cover 
every possible error that the child process could report.  Even "small 
programs" could generate $BIGNUM error codes it could be argued.

Looking at the list for reserved exitcodes[1] everything covers 
operational use and then if you look to /usr/include/sysexits.h for an 
idea of the 'spirit' behind exitcodes, it is pretty clear it is all 
rather 'generic' and vague to the precise reason, but it categorises 
the type of error to maybe something the parent could gracefully handle.  
It is not a freetext communications channel :)

If you have $BIGNUM outcomes of errors, you probably should not be using 
the exitcode path to communicate this information back up, although I 
would agree it looks like very natural solution.  I would be more 
inclined to pass up to the parent this information via a pipe (whether 
that is via stdout, stderr or even a filesystem located pipe).  No doubt 
if you are trying to return $BIGNUM error codes, you probably want to 
look more to an approach based on the one covered in RFC3463; there if 
you return a sysexits.h type code then the child's STDOUT is consulted 
for the extended error code reason...I think this approach is *very* 
nice.

Cheers

[1] http://tldp.org/LDP/abs/html/exitcodes.html#EXITCODESREF
[2] http://tools.ietf.org/html/rfc3463

-- 
Alexander Clouter
.sigmonster says: If in doubt, mumble.

