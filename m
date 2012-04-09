Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270Ab2DIT7F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 15:59:05 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40922 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab2DIT7B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 15:59:01 -0400
MIME-Version: 1.0
In-Reply-To: <67e30a0c8655fc53a92e8138bba9de66.squirrel@webmail.greenhost.nl>
References: <1333051320-30872-1-git-send-email-wad@chromium.org>
	<1333051320-30872-9-git-send-email-wad@chromium.org>
	<20120406132330.457a05cf.akpm@linux-foundation.org>
	<67e30a0c8655fc53a92e8138bba9de66.squirrel@webmail.greenhost.nl>
Date: Mon, 9 Apr 2012 14:59:00 -0500
Message-ID: <CABqD9hYE0S4EL6yH-57SfNs+D8GFKJgWVN21VzXpQmRuh2ow=w@mail.gmail.com>
Subject: Re: [PATCH v17 08/15] seccomp: add system call filtering using BPF
From: Will Drewry <wad@chromium.org>
To: Indan Zupancic <indan@nul.nu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com,
        netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de,
        davem@davemloft.net, hpa@zytor.com, mingo@redhat.com, oleg@redhat.com,
        peterz@infradead.org, rdunlap@xenotime.net, mcgrathr@chromium.org,
        tglx@linutronix.de, luto@mit.edu, eparis@redhat.com,
        serge.hallyn@canonical.com, djm@mindrot.org, scarybeasts@gmail.com,
        pmoore@redhat.com, corbet@lwn.net, eric.dumazet@gmail.com,
        markus@chromium.org, coreyb@linux.vnet.ibm.com, keescook@chromium.org,
        jmorris@namei.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 8, 2012 at 1:22 PM, Indan Zupancic <indan@nul.nu> wrote:
> On Sat, April 7, 2012 06:23, Andrew Morton wrote:
>> hm, I'm surprised that we don't have a zero-returning implementation of
>> is_compat_task() when CONFIG_COMPAT=n.  Seems silly.  Blames Arnd.
>
> It's sneakily hidden at the end of compat.h.
>
>>> +/**
>>> + * get_u32 - returns a u32 offset into data
>>> + * @data: a unsigned 64 bit value
>>> + * @index: 0 or 1 to return the first or second 32-bits
>>> + *
>>> + * This inline exists to hide the length of unsigned long.
>>> + * If a 32-bit unsigned long is passed in, it will be extended
>>> + * and the top 32-bits will be 0. If it is a 64-bit unsigned
>>> + * long, then whatever data is resident will be properly returned.
>>> + */
>>> +static inline u32 get_u32(u64 data, int index)
>>> +{
>>> +    return ((u32 *)&data)[index];
>>> +}
>>
>> This seems utterly broken on big-endian machines.  If so: fix.  If not:
>> add comment explaining why?
>
> It's not a bug, it's intentional.
>
> I tried to convince them to have a stable ABI for all archs, but they
> didn't want to make the ABI endianness independent, because it looks
> uglier. The argument being that system call numbers are arch dependent
> anyway.
>
> So a filter for a little endian arch needs to check a different offset
> than one for a big endian archs.

Awkward, but in practice it doesn't seem to matter either way --
especially since properly written filters should check the @arch which
indicates the calling convention, endianness, etc.

>>> +static u32 seccomp_run_filters(int syscall)
>>> +{
>>> +    struct seccomp_filter *f;
>>> +    u32 ret = SECCOMP_RET_KILL;
>>> +    /*
>>> +     * All filters are evaluated in order of youngest to oldest. The lowest
>>> +     * BPF return value always takes priority.
>>> +     */
>>
>> The youngest-first design surprised me.  It wasn't mentioned at all in
>> the changelog.  Thinking about it, I guess it just doesn't matter.  But
>> some description of the reasons for and implications of this decision
>> for the uninitiated would be welcome.
>
> I think it's less confusing to not mention the order at all, exactly
> because it doesn't matter. It has been like this from the start, so
> that's why it's not mentioned in the changelog I guess.

Good call - I will remove that comment.  The only relevant information
is that the lowest return value wins.  I did add a comment up near
struct seccomp_filter with my attempt at explaining the tree
structure, but I didn't detail evaluation order.  In this case, it
only is relevant because our only link to the tree is via our local
pointer which happens to be the "youngest".

> The reason to check the youngest first is because the filters are shared
> between processes: childs inherit it. If later on additional filters are
> added, the only way of adding them without modifying an older filter is
> by adding them to the head of the list. This way no locking is needed,
> because filters are only added and removed single-threadedly, and never
> modified when being shared.

I tried a handful of other strategies, but in practice this seemed to
meet the needs with the least complexity/overhead.

>>> +/**
>>> + * seccomp_attach_filter: Attaches a seccomp filter to current.
>>> + * @fprog: BPF program to install
>>> + *
>>> + * Returns 0 on success or an errno on failure.
>>> + */
>>> +static long seccomp_attach_filter(struct sock_fprog *fprog)
>>> +{
>>> +    struct seccomp_filter *filter;
>>> +    unsigned long fp_size = fprog->len * sizeof(struct sock_filter);
>>> +    unsigned long total_insns = fprog->len;
>>> +    long ret;
>>> +
>>> +    if (fprog->len == 0 || fprog->len > BPF_MAXINSNS)
>>> +            return -EINVAL;
>>> +
>>> +    for (filter = current->seccomp.filter; filter; filter = filter->prev)
>>> +            total_insns += filter->len + 4;  /* include a 4 instr penalty */
>>
>> So tasks don't share filters?  We copy them by value at fork?  Do we do
>> this at vfork() too?
>
> Yes they do. But shared filters are never modified, except for the refcount.
>
>>
>>> +    if (total_insns > MAX_INSNS_PER_PATH)
>>> +            return -ENOMEM;
>>> +
>>> +    /*
>>> +     * Installing a seccomp filter requires that the task have
>>> +     * CAP_SYS_ADMIN in its namespace or be running with no_new_privs.
>>> +     * This avoids scenarios where unprivileged tasks can affect the
>>> +     * behavior of privileged children.
>>> +     */
>>> +    if (!current->no_new_privs &&
>>> +        security_capable_noaudit(current_cred(), current_user_ns(),
>>> +                                 CAP_SYS_ADMIN) != 0)
>>> +            return -EACCES;
>>> +
>>> +    /* Allocate a new seccomp_filter */
>>> +    filter = kzalloc(sizeof(struct seccomp_filter) + fp_size, GFP_KERNEL);
>>
>> I think this gives userspace an easy way of causing page allocation
>> failure warnings, by permitting large kmalloc() attempts.  Add
>> __GFP_NOWARN?
>
> Max is 32kb. sk_attach_filter() in net/core/filter.c is worse,
> it allocates up to 512kb before even checking the length.
>
> What about using GFP_USER (and adding __GFP_NOWARN to GFP_USER) instead?

It looks like GFP_USER|__GFP_NOWARN would make sense here.  I'll change it.

>>> +    /* Check and rewrite the fprog via the skb checker */
>>> +    ret = sk_chk_filter(filter->insns, filter->len);
>>> +    if (ret)
>>> +            goto fail;
>>> +
>>> +    /* Check and rewrite the fprog for seccomp use */
>>> +    ret = seccomp_chk_filter(filter->insns, filter->len);
>>
>> "check" is spelled "check"!
>
> Yes, it is and he did spell "check" as "Check".
>
> seccomp_chk_filter() mirrors sk_chk_filter(). So it refers to
> "chk", not "check".

I can change it to be written out or leave it matching the networking
code.  Any preferences?

Thanks!
will
