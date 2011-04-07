Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657Ab1DGLZ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 07:25:59 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64619 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755537Ab1DGLZ5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 07:25:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=NztPOWj83xrMs7sb9Vu0FEz1oCiavyVNcMnP/aQJRmnWEtFFJtRmlUFqqjXpBGHNw3
         UvY3l/Ng/j+HNMXhlGpCIglwfZ6YHeVad2tqHTagsQUr5VIDi0vHgAWe+A+ECAt/E5bH
         X9SAsv0pmpbFUEDFAlwiwGQQUwV1LY1XNftYA=
MIME-Version: 1.0
In-Reply-To: <20110407075456.GC24879@elte.hu>
References: <cover.1302137785.git.luto@mit.edu> <49856c9e1325fd1a1f1786f05a7f2befe14666d6.1302137785.git.luto@mit.edu>
 <20110407075456.GC24879@elte.hu>
From: Andrew Lutomirski <luto@mit.edu>
Date: Thu, 7 Apr 2011 07:25:37 -0400
X-Google-Sender-Auth: CpHrclMECc0tZecURCw21O1WJKo
Message-ID: <BANLkTinQEsrRfuLV7BXs815Ya47TM8UOEw@mail.gmail.com>
Subject: Re: [RFT/PATCH v2 3/6] x86-64: Don't generate cmov in vread_tsc
To: Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 7, 2011 at 3:54 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Andy Lutomirski <luto@mit.edu> wrote:
>
>> vread_tsc checks whether rdtsc returns something less than
>> cycle_last, which is an extremely predictable branch.  GCC likes
>> to generate a cmov anyway, which is several cycles slower than
>> a predicted branch.  This saves a couple of nanoseconds.
>>
>> Signed-off-by: Andy Lutomirski <luto@mit.edu>
>> ---
>>  arch/x86/kernel/tsc.c |   19 +++++++++++++++----
>>  1 files changed, 15 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
>> index 858c084..69ff619 100644
>> --- a/arch/x86/kernel/tsc.c
>> +++ b/arch/x86/kernel/tsc.c
>> @@ -794,14 +794,25 @@ static cycle_t __vsyscall_fn vread_tsc(void)
>>        */
>>
>>       /*
>> -      * This doesn't multiply 'zero' by anything, which *should*
>> -      * generate nicer code, except that gcc cleverly embeds the
>> -      * dereference into the cmp and the cmovae.  Oh, well.
>> +      * This doesn't multiply 'zero' by anything, which generates
>> +      * very slightly nicer code than multiplying it by 8.
>>        */
>>       last = *( (cycle_t *)
>>                 ((char *)&VVAR(vsyscall_gtod_data).clock.cycle_last + zero) );
>>
>> -     return ret >= last ? ret : last;
>> +     if (likely(ret >= last))
>> +             return ret;
>> +
>> +     /*
>> +      * GCC likes to generate cmov here, but this branch is extremely
>> +      * predictable (it's just a funciton of time and the likely is
>> +      * very likely) and there's a data dependence, so force GCC
>> +      * to generate a branch instead.  I don't barrier() because
>> +      * we don't actually need a barrier, and if this function
>> +      * ever gets inlined it will generate worse code.
>> +      */
>> +     asm volatile ("");
>
> Hm, you have not addressed the review feedback i gave in:
>
>  Message-ID: <20110329061546.GA27398@elte.hu>

I can change that, but if anyone ever inlines this function (and Andi
suggested that as another future optimization), then they'd want to
undo it, because it will generate worse code.  (barrier() has the
unnecessary memory clobber.)

--Andy

>
> Thanks,
>
>        Ingo
>
