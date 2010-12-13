Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099Ab0LMIdk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 03:33:40 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56383 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab0LMIdi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 03:33:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=q5aC56gfAnEkIw2f/Ha8/5N0roNi8nBDGFndc/Oebc8ORfSxp4ZqC6GoR/swywT0/c
         fNtPNVufUtfEnIJnl0i0HbsFPwYFSRffWzHvh4o6RkApo1S11EaXoX1au2NzEOuBbj4i
         4Sf57PJaKEujAmYu+1530UvTT+JKaihBkIBH8=
MIME-Version: 1.0
In-Reply-To: <1292225113.18698.22.camel@edumazet-laptop>
References: <20101213023733.GB6522@amd>
	<20101213024217.GC6522@amd>
	<1292225113.18698.22.camel@edumazet-laptop>
Date: Mon, 13 Dec 2010 19:33:36 +1100
Message-ID: <AANLkTi=9VmhTY2y06rG28Bn_m9Gu7wMx4go74OsZTJEz@mail.gmail.com>
Subject: Re: [patch] fs: scale vfsmount refcount (was Re: rcu-walk and dcache
 scaling tree update and status)
From: Nick Piggin <npiggin@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Nick Piggin <npiggin@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 6:25 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le lundi 13 décembre 2010 à 13:42 +1100, Nick Piggin a écrit :
>> + */
>> +static inline void add_mnt_count(struct vfsmount *mnt, int n)
>
> maybe name it __add_mnt_count() (should be called with preempt off)
>
>> +{
>> +#ifdef CONFIG_SMP
>> +     (*per_cpu_ptr(mnt->mnt_count, smp_processor_id())) += n;
>
> __this_cpu_add(mnt->mnt_count, n);
>
>> +#else
>> +     mnt->mnt_count += n;
>> +#endif
>> +}
>
> and define a preempt safe version :
>
> static inline void __add_mnt_count(struct vfsmount *mnt, int n)
> {
> #ifdef CONFIG_SMP
>        __this_cpu_add(mnt->mnt_count, n);
> #else
>        mnt->mnt_count += n;
> #endif
> }
>
> static inline void add_mnt_count(struct vfsmount *mnt, int n)
> {
> #ifdef CONFIG_SMP
>        this_cpu_add(mnt->mnt_count, n);
> #else
>        preempt_disable();
>        mnt->mnt_count += n;
>        preempt_enable();
> #endif
> }

That looks good, thanks.


>> +
>> +static inline void set_mnt_count(struct vfsmount *mnt, int n)
>> +{
>> +#ifdef CONFIG_SMP
>
>
>> +     preempt_disable();
>> +     (*per_cpu_ptr(mnt->mnt_count, smp_processor_id())) = n;
>> +     preempt_enable();
>
> last 3 lines can be replaced by :
>
>        this_cpu_write(mnt->mnt_count, n);

Yep, thanks.


>> +#else
>> +     mnt->mnt_count = n;
>> +#endif
>> +}
>> +
>
>>  #ifdef CONFIG_SMP
>>       int __percpu *mnt_writers;
>> +     int __percpu *mnt_count;
>>  #else
>>       int mnt_writers;
>> +     int mnt_count;
>>  #endif
>
> You could use a struct and one per cpu allocation to use one cache line
> for both objects :
>
> struct mnt_counters {
>        int writers;
>        int count;
> };
>
> ...
>
> #ifdef CONFIG_SMP
>        struct mnt_counters __percpu *mnt_counters;
> #else
>        struct mnt_counters mnt_counters;
> #endif
>
> This would use one pointer instead of two in SMP

Yes that's a good point too.

Thanks,
Nick
