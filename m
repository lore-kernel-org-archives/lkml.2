Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab2BHSNi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 13:13:38 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62462 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824Ab2BHSNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 13:13:36 -0500
Message-ID: <4F32BB5B.3010201@gmail.com>
Date: Wed, 08 Feb 2012 13:13:47 -0500
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: Oleg Nesterov <oleg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        San Mehat <san@google.com>, Colin Cross <ccross@android.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v2 2/6] oom: Get rid of sparse warnings
References: <20120203163056.GA4190@redhat.com> <20120206162935.GB5117@oksana.dev.rtsoft.ru> <CAHGf_=oVQQRdfNYm0gOwzjxbUqPB5jMdsibLATCrt718-sMm7w@mail.gmail.com> <20120207042026.GA25524@oksana.dev.rtsoft.ru> <CAHGf_=rW-EJvj-hsKgEGw4F4uAKMv-U-iG6aROzw2rN4tXPFFQ@mail.gmail.com> <20120207062353.GA24687@oksana.dev.rtsoft.ru>
In-Reply-To: <20120207062353.GA24687@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2/7/12 1:23 AM), Anton Vorontsov wrote:
> On Tue, Feb 07, 2012 at 12:38:58AM -0500, KOSAKI Motohiro wrote:
>>>> task struct only have allock_lock, not alloc_loc.
>>>
>>> Funnily, but sparse does not care. :-) __release(foo) will work as
>>> well. Seems like sparse counts locking balance globally.
>>>
>>> This is now fixed in the patch down below, thanks for catching.
>>>
>>>> Moreover we don't release
>>>> the lock in this code path. Seems odd.
>>>
>>> Indeed. That's exactly what sparse seeing is as well. We exit
>>> without releasing the lock, which is bad (in sparse' eyes). So
>>> we lie to sparse, telling it that we do release, so it shut ups.
>>
>> Hmmm....
>>
>> To be honest, I really dislike any lie annotation. Why? It is very
>> fragile and easily
>> become broken from unrelated but near line changes. Please consider to
>> enhance sparse at first.
>
> I somewhat doubt that it is possible to "enhance it". We keep the
> lock held conditionaly, so we need too place the hint in the
> code itself. I believe the best we can do would be something like
> this:
>
> diff --git a/include/linux/compiler.h b/include/linux/compiler.h
> index 4a24354..61d91f2 100644
> --- a/include/linux/compiler.h
> +++ b/include/linux/compiler.h
> @@ -14,6 +14,7 @@
>   # define __releases(x)	__attribute__((context(x,1,0)))
>   # define __acquire(x)	__context__(x,1)
>   # define __release(x)	__context__(x,-1)
> +# define __ret_with_lock(x)	__context__(x,-1)
>   # define __cond_lock(x,c)	((c) ? ({ __acquire(x); 1; }) : 0)
>   # define __percpu	__attribute__((noderef, address_space(3)))
>   #ifdef CONFIG_SPARSE_RCU_POINTER
> @@ -37,6 +38,7 @@ extern void __chk_io_ptr(const volatile void __iomem *);
>   # define __releases(x)
>   # define __acquire(x) (void)0
>   # define __release(x) (void)0
> +# define __ret_with_lock(x)
>   # define __cond_lock(x,c) (c)
>   # define __percpu
>   # define __rcu
>
> And then use it instead of __release().

Hmmm...

I still dislike this lie annotation. But maybe it's better than nothing
(dunno, just guess). Go ahead.






