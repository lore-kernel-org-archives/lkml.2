Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab1C2LxO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 07:53:14 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:55218 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293Ab1C2LxN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 07:53:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=DRbXCmxJsEYvGvC2iuGG42I52r93wWmKrQf/Anx8IM7QFCD1B7aGC7UHtYKFw+VkSj
         RMWaoYL5YDYOKhse1BlcI6/0a4dKR3C1iwSq+Nbz9+Koy3J4h9KtIryKGCs6NQNhy3sM
         fjkYPIlwulMDifPYOU4Vnj/E3mI3JbuIlq3Dg=
MIME-Version: 1.0
In-Reply-To: <20110329061546.GA27398@elte.hu>
References: <cover.1301324270.git.luto@mit.edu> <6921987c30552b781bd96c58451169a6074f2c96.1301324270.git.luto@mit.edu>
 <20110329061546.GA27398@elte.hu>
From: Andrew Lutomirski <luto@mit.edu>
Date: Tue, 29 Mar 2011 07:52:52 -0400
X-Google-Sender-Auth: 0OGxUCzkDa44rSMQq4fEpEntzto
Message-ID: <AANLkTi=q9My0gFbKvxt-7HFN=ufQzinxphHVOeaxgm9F@mail.gmail.com>
Subject: Re: [PATCH 2/6] x86-64: Don't generate cmov in vread_tsc
To: Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 2:15 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Andy Lutomirski <luto@MIT.EDU> wrote:
>
>> -     /* This doesn't multiply 'zero' by anything, which *should*
>> -      * generate nicer code, except that gcc cleverly embeds the
>> -      * dereference into the cmp and the cmovae.  Oh, well.
>> +     /* This doesn't multiply 'zero' by anything, which generates
>> +      * very slightly nicer code than multiplying it by 8.
>>        */
>>       last = *( (cycle_t *)
>>                 ((char *)&__vsyscall_gtod_data.clock.cycle_last + zero) );
>>
>> -     return ret >= last ? ret : last;
>> +     if (likely(ret >= last))
>> +             return ret;
>> +
>> +     /* GCC likes to generate cmov here, but this branch is extremely
>> +        predictable (it's just a funciton of time and the likely is
>> +        very likely) and there's a data dependence, so force GCC
>> +        to generate a branch instead. */
>> +     asm volatile ("");
>
> barrier() would do the same, right?

Yes.  It's overkill (the memory clobber is unnecessary) but should be harmless.

I'll take a look at folding this and [1/6] together and sticking them
in a .S.  The down side is that rdtsc_barrier() expends to two
alternatives, and it has other callers.  I'll see what it looks like.

>
> Also, a nit, please use the customary (multi-line) comment style:
>
>  /*
>   * Comment .....
>   * ...... goes here.
>   */
>
> specified in Documentation/CodingStyle.

I was hoping checkpatch would warn me :)

--Andy

>
> Thanks,
>
>        Ingo
>
