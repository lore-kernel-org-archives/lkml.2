Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487Ab2BIIIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 03:08:18 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43832 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab2BIIIR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 03:08:17 -0500
MIME-Version: 1.0
X-Originating-IP: [109.64.24.177]
In-Reply-To: <20120208160344.88d187e5.akpm@linux-foundation.org>
References: <1328448800-15794-1-git-send-email-gilad@benyossef.com>
	<1328449722-15959-3-git-send-email-gilad@benyossef.com>
	<op.v9csppvv3l0zgt@mpn-glaptop>
	<20120208160344.88d187e5.akpm@linux-foundation.org>
Date: Thu, 9 Feb 2012 10:08:16 +0200
Message-ID: <CAOtvUMebLNtMcrxuxRq_U5UbwNt-9mE0-0z7Zg79abRTbHE4MQ@mail.gmail.com>
Subject: Re: [PATCH v8 4/8] smp: add func to IPI cpus based on parameter func
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Nazarewicz <mina86@mina86.com>, linux-kernel@vger.kernel.org,
        Chris Metcalf <cmetcalf@tilera.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Kosaki Motohiro <kosaki.motohiro@gmail.com>,
        Milton Miller <miltonm@bga.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 9, 2012 at 2:03 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 08 Feb 2012 10:30:51 +0100
> "Michal Nazarewicz" <mina86@mina86.com> wrote:
>
>> >     } while (0)
>> > +/*
>> > + * Preemption is disabled here to make sure the
>> > + * cond_func is called under the same condtions in UP
>> > + * and SMP.
>> > + */
>> > +#define on_each_cpu_cond(cond_func, func, info, wait, gfp_flags) \
>> > +   do {                                            \
>>
>> How about:
>>
>>               void *__info = (info);
>>
>> as to avoid double execution.
>
> Yup.  How does this look?
>
>
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: smp-add-func-to-ipi-cpus-based-on-parameter-func-update-fix
>
> - avoid double-evaluation of `info' (per Michal)
> - parenthesise evaluation of `cond_func'
>
> Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
> Cc: Gilad Ben-Yossef <gilad@benyossef.com>
> Cc: Michal Nazarewicz <mina86@mina86.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  include/linux/smp.h |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> --- a/include/linux/smp.h~smp-add-func-to-ipi-cpus-based-on-parameter-func-update-fix
> +++ a/include/linux/smp.h
> @@ -168,10 +168,11 @@ static inline int up_smp_call_function(s
>  */
>  #define on_each_cpu_cond(cond_func, func, info, wait, gfp_flags)\
>        do {                                                    \
> +               void *__info = (info);                          \
>                preempt_disable();                              \
> -               if (cond_func(0, info)) {                       \
> +               if ((cond_func)(0, __info)) {                   \
>                        local_irq_disable();                    \
> -                       (func)(info);                           \
> +                       (func)(__info);                         \
>                        local_irq_enable();                     \
>                }                                               \
>                preempt_enable();                               \
> _
>

Right, I missed that. I hate macros.

As I was requested to correct some comments I'll send a re-spin.
I folded your patch into the original one (and kept the Signed-off-by,
I hope it's OK).

BTW -  I used a macro since I imitated the rest of the code in smp.h
but is there any
reason not to use an inline macro here?

Thanks!
Gilad

-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
