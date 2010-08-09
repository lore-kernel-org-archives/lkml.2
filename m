Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab0HIDPj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 23:15:39 -0400
Received: from demumfd001.nsn-inter.net ([93.183.12.32]:10376 "EHLO
	demumfd001.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755266Ab0HIDPi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 23:15:38 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Re: [PATCH]exit.c: support larger exit code
Date: Mon, 9 Aug 2010 11:14:28 +0800
Message-ID: <14414B36FFA0F1418CB707361EAA199A0194FB16@CNBEEXC006.nsn-intra.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Re: [PATCH]exit.c: support larger exit code
Thread-Index: Acs3cPoB1513LrshSbmqMTRH9ZtLyg==
From: "Zhang, Wei-Jovi (NSN - CN/Hangzhou)" <wei-jovi.zhang@nsn.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 09 Aug 2010 03:15:35.0567 (UTC) FILETIME=[224069F0:01CB3771]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Alexander Clouter <alex <at> digriz.org.uk> wrote:
>>Oleg Nesterov <oleg <at> redhat.com> wrote:
>>>
>>> Nowadays userspace application use systemcall exit/exit_group only
>>> support one byte exit code.
>>> In some cases this exit code range is too small for some "big
>>> application"(like telecom software, 255 is not enough).
>>>
>>> So we can give some "big application" a chance to get larger exit
code
>>> from child process.
>>> For other application don't want use larger exit code, they can use
>>> marco WEXITSTATUS to get lower one byte exit code.
>>>
>>> #define WEXITSTATUS(status)   __WEXITSTATUS (__WAIT_INT (status))
>>> --- stdlib.h
>>> #define       __WEXITSTATUS(status)   (((status) & 0xff00) >> 8)
>>> --- usrbits/waitstatus.h
>>>
>>>
>>> diff --git a/kernel/exit.c b/kernel/exit.c
>>> index ceffc67..8b13676 100644
>>> --- a/kernel/exit.c
>>> +++ b/kernel/exit.c
>>> @@ -1045,7 +1045,7 @@ EXPORT_SYMBOL(complete_and_exit);
>>>
>>>  SYSCALL_DEFINE1(exit, int, error_code)
>>>  {
>>> -       do_exit((error_code&0xff)<<8);
>>> +       do_exit(error_code << 8);
>>>  }
>>>
>>>  /*
>>> @@ -1086,7 +1086,7 @@ do_group_exit(int exit_code)
>>>   */
>>>  SYSCALL_DEFINE1(exit_group, int, error_code)
>>>  {
>>> -       do_group_exit((error_code & 0xff) << 8);
>>> +       do_group_exit(error_code << 8);
>>>         /* NOTREACHED */
>>>         return 0;
>>>  }
>> 
>> Hmm. Looking at this patch, I am wondering what was the reason for
the
>> current one-byte limitation.
>>

>The one byte limitation I think is all that is needed to give an 
>impression and *hint* of what went wrong, it was not ever meant to
cover 
>every possible error that the child process could report.  Even "small 
>programs" could generate $BIGNUM error codes it could be argued.

>Looking at the list for reserved exitcodes[1] everything covers 
>operational use and then if you look to /usr/include/sysexits.h for an 
>idea of the 'spirit' behind exitcodes, it is pretty clear it is all 
>rather 'generic' and vague to the precise reason, but it categorises 
>the type of error to maybe something the parent could gracefully
handle.  
>It is not a freetext communications channel :)

>If you have $BIGNUM outcomes of errors, you probably should not be
using 
>the exitcode path to communicate this information back up, although I 
>would agree it looks like very natural solution.  I would be more 
>inclined to pass up to the parent this information via a pipe (whether 
>that is via stdout, stderr or even a filesystem located pipe).  No
doubt 
>if you are trying to return $BIGNUM error codes, you probably want to 
>look more to an approach based on the one covered in RFC3463; there if 
>you return a sysexits.h type code then the child's STDOUT is consulted 
>for the extended error code reason...I think this approach is *very* 
>nice.


> The one byte limitation I think is all that is needed to give an
impression and *hint* of what went wrong, it was not ever meant to cover
every possible error that the child process could report.

I think this is just a convention of userspace program. if program want
to obey this convention, it should be use one-byte limition exit code, I
agree this.
so this mail thread's subject should change to "if program use exit code
with not want to obey the convention, kernel should return which value?"

so the key is:	from kernel point of view, kernel should don't care any
userspace program's convention.
how to use exit code is program's business, kernel should not to force
userspace program to obey some convention, it's not a good idea for
kernel.

if program use exit(43), kernel return 43; if program use exit(11111),
kernel should return 11111, not return 43. Apparently, program don't
want 43, it just want 11111. 
program is very hard to understand to get 43. program maybe don't
understand why she give kernel a int exit code, but kernel give her a
byte back. she don't know any convention, she just want program works.
So kernel can make more smooth for userspace program. 

This is my 2 cents. Pls give your comments freely. :-) 


.jovi
