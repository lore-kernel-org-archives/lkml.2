Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504Ab2JXFjA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 01:39:00 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:59633 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab2JXFi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 01:38:59 -0400
MIME-Version: 1.0
In-Reply-To: <20121023165651.88af399d.akpm@linux-foundation.org>
References: <1350045042-1369134-1-git-send-email-avagin@openvz.org>
	<20121023165651.88af399d.akpm@linux-foundation.org>
Date: Wed, 24 Oct 2012 09:38:57 +0400
Message-ID: <CANaxB-xVVmQaCze=4+SaLbwkbJYxBwjbzF0hWX+Js94veWxj3w@mail.gmail.com>
Subject: Re: [PATCH] pidns: limit the nesting depth of pid namespaces
From: Andrey Wagin <avagin@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/24 Andrew Morton <akpm@linux-foundation.org>:
> On Fri, 12 Oct 2012 16:30:42 +0400
> Andrew Vagin <avagin@openvz.org> wrote:
>
>> 'struct pid' is a "variable sized struct" - a header with an array
>> of upids at the end.
>>
>> A size of the array depends on a level (depth) of pid namespaces. Now
>> a level of pidns is not limited, so 'struct pid' can be more than one
>> page.
>>
>> Looks reasonable, that it should be less than a page. MAX_PIS_NS_LEVEL
>> is not calculated from PAGE_SIZE, because in this case it depends on
>> architectures, config options and it will be reduced, if someone adds a
>> new fields in struct pid or struct upid.
>>
>> I suggest to set MAX_PIS_NS_LEVEL = 32, because it saves ability to
>> expand "struct pid" and it's more than enough for all known for me
>> use-cases.  When someone finds a reasonable use case, we can add a
>> config option or a sysctl parameter.
>>
>> In addition it will reduce effect of another problem, when we have many
>> nested namespaces and the oldest one starts dying.  zap_pid_ns_processe
>> will be called for each namespace and find_vpid will be called for each
>> process in a namespace. find_vpid will be called minimum max_level^2 / 2
>> times. The reason of that is that when we found a bit in pidmap, we
>> can't determine this pidns is top for this process or it isn't.
>>
>> vpid is a heavy operation, so a fork bomb, which create many nested
>> namespace, can do a system inaccessible for a long time.
>>
>> --- a/kernel/pid_namespace.c
>> +++ b/kernel/pid_namespace.c
>> @@ -70,12 +70,18 @@ err_alloc:
>>       return NULL;
>>  }
>>
>> +/* MAX_PID_NS_LEVEL is needed for limiting size of 'struct pid' */
>> +#define MAX_PID_NS_LEVEL 32
>> +
>>  static struct pid_namespace *create_pid_namespace(struct pid_namespace *parent_pid_ns)
>>  {
>>       struct pid_namespace *ns;
>>       unsigned int level = parent_pid_ns->level + 1;
>>       int i, err = -ENOMEM;
>>
>> +     if (level > MAX_PID_NS_LEVEL)
>> +             goto out;
>> +
>>       ns = kmem_cache_zalloc(pid_ns_cachep, GFP_KERNEL);
>>       if (ns == NULL)
>>               goto out;
>
> hm, OK.  This will kind-of fix the free_pid_ns()-excessive-recursion
> issue which we already fixed by other means ;)

I caught both problems with help of an one program, which create many
nested namespaces. Actually this patch prevents another problem. A few
thousand nested namespaces is destroyed for more than one minutes and
in this period a system is inaccessible.

>
> I don't think this problem is serious enough to bother backporting into
> -stable but I guess we can/should do it in 3.7.  Agree?

Yes.

>
> I think that returning -ENOMEM in response to an excessive nesting
> attempt is misleading - the system *didn't* run out of memory.  EINVAL
> is better?

I chose ENOMEM by analogy with max_pid.  When a new PID can not be
allocated, ENOMEM is returned too.

>
>
>
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: pidns-limit-the-nesting-depth-of-pid-namespaces-fix
>
> return -EINVAL in response to excessive nesting, not -ENOMEM
>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Andrew Vagin <avagin@openvz.org>
> Cc: Cyrill Gorcunov <gorcunov@openvz.org>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Pavel Emelyanov <xemul@parallels.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  kernel/pid_namespace.c |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff -puN kernel/pid_namespace.c~pidns-limit-the-nesting-depth-of-pid-namespaces-fix kernel/pid_namespace.c
> --- a/kernel/pid_namespace.c~pidns-limit-the-nesting-depth-of-pid-namespaces-fix
> +++ a/kernel/pid_namespace.c
> @@ -78,11 +78,15 @@ static struct pid_namespace *create_pid_
>  {
>         struct pid_namespace *ns;
>         unsigned int level = parent_pid_ns->level + 1;
> -       int i, err = -ENOMEM;
> +       int i;
> +       int err;
>
> -       if (level > MAX_PID_NS_LEVEL)
> +       if (level > MAX_PID_NS_LEVEL) {
> +               err = -EINVAL;
>                 goto out;
> +       }
>
> +       err = -ENOMEM;
>         ns = kmem_cache_zalloc(pid_ns_cachep, GFP_KERNEL);
>         if (ns == NULL)
>                 goto out;
> _
>
