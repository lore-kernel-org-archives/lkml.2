Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933800Ab1ERTkj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 15:40:39 -0400
Received: from smtp-out.google.com ([216.239.44.51]:27040 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933620Ab1ERTki convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 15:40:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=p2zBWMTy2gTd/taJCq61GdnXJbP936bSLf85BD1NZSso15DOyzJr/QjHdlSQIG/TV3
         i0/yF44Z0j5iMVlf0ctw==
MIME-Version: 1.0
In-Reply-To: <20110518182519.GB25881@elte.hu>
References: <1305738580-9924-1-git-send-email-ncrao@google.com>
 <1305738580-9924-4-git-send-email-ncrao@google.com> <20110518182519.GB25881@elte.hu>
From: Nikhil Rao <ncrao@google.com>
Date: Wed, 18 May 2011 12:39:55 -0700
Message-ID: <BANLkTinHZpgqe0DjBrya--J+xFE=ksv9CQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] sched: increase SCHED_LOAD_SCALE resolution
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Stephan Barwolf <stephan.baerwolf@tu-ilmenau.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 11:25 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Nikhil Rao <ncrao@google.com> wrote:
>
>> -#define SCHED_LOAD_SHIFT     10
>> +#if BITS_PER_LONG > 32
>> +#define SCHED_LOAD_RESOLUTION        10
>> +#define scale_load(w)                (w << SCHED_LOAD_RESOLUTION)
>> +#define scale_load_down(w)   (w >> SCHED_LOAD_RESOLUTION)
>> +#else
>> +#define SCHED_LOAD_RESOLUTION        0
>> +#define scale_load(w)                w
>> +#define scale_load_down(w)   w
>> +#endif
>
> Please use the:
>
> #if X
> # define Y A
> #else
> # define Y B
> #endif
>
> type of nested CPP branching style.
>
> Also, the 'w' probably wants to be '(w)', just in case.

Thanks for the review. Will fix the macros.

>
>>       if (!lw->inv_weight) {
>> -             if (BITS_PER_LONG > 32 && unlikely(lw->weight >= WMULT_CONST))
>> +             unsigned long w = scale_load_down(lw->weight);
>> +             if (BITS_PER_LONG > 32 && unlikely(w >= WMULT_CONST))
>>                       lw->inv_weight = 1;
>
> Please separate local variable declarations and the first statement following
> it by an extra empty line.
>

Yes, will do.

> Could you also put all the performance measurement description into the
> changelog of this third commit - so that people can see (and enjoy) the
> extensive testing you have done on this topic?
>

Yes, will add the performance changes to the commit description.

>>  /*
>> - * Increase resolution of nice-level calculations:
>> + * Increase resolution of nice-level calculations for 64-bit architectures.
>>   */
>> -#define SCHED_LOAD_SHIFT     10
>> +#if BITS_PER_LONG > 32
>> +#define SCHED_LOAD_RESOLUTION        10
>> +#define scale_load(w)                (w << SCHED_LOAD_RESOLUTION)
>> +#define scale_load_down(w)   (w >> SCHED_LOAD_RESOLUTION)
>> +#else
>> +#define SCHED_LOAD_RESOLUTION        0
>> +#define scale_load(w)                w
>> +#define scale_load_down(w)   w
>> +#endif
>
> Please also be a bit more verbose in the comment above why we treat 64-bit
> architectures differently - it's not obvious.

Added a more descriptive comment.


Thanks for the review. I'll refresh the patch and send it with the fixes.

-Thanks,
Nikhil
