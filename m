Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038Ab2DFUou (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 16:44:50 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51392 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757595Ab2DFUos convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 16:44:48 -0400
MIME-Version: 1.0
In-Reply-To: <20120406132330.457a05cf.akpm@linux-foundation.org>
References: <1333051320-30872-1-git-send-email-wad@chromium.org>
	<1333051320-30872-9-git-send-email-wad@chromium.org>
	<20120406132330.457a05cf.akpm@linux-foundation.org>
Date: Fri, 6 Apr 2012 13:44:43 -0700
X-Google-Sender-Auth: cVKVMeu41gsGahCZLTRmIe3intc
Message-ID: <CAGXu5jJVDLzCOyCo-q6+pF-_3v4Ws8jBzYXwac419uv2QQS0mA@mail.gmail.com>
Subject: Re: [PATCH v17 08/15] seccomp: add system call filtering using BPF
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com,
        netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de,
        davem@davemloft.net, hpa@zytor.com, mingo@redhat.com, oleg@redhat.com,
        peterz@infradead.org, rdunlap@xenotime.net, mcgrathr@chromium.org,
        tglx@linutronix.de, luto@mit.edu, eparis@redhat.com,
        serge.hallyn@canonical.com, djm@mindrot.org, scarybeasts@gmail.com,
        indan@nul.nu, pmoore@redhat.com, corbet@lwn.net,
        eric.dumazet@gmail.com, markus@chromium.org, coreyb@linux.vnet.ibm.com,
        jmorris@namei.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 6, 2012 at 1:23 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 29 Mar 2012 15:01:53 -0500
> Will Drewry <wad@chromium.org> wrote:
>
>> [This patch depends on luto@mit.edu's no_new_privs patch:
>>    https://lkml.org/lkml/2012/1/30/264
>>  included in this series for ease of consumption.
>> ]
>>
>> This patch adds support for seccomp mode 2.  Mode 2 introduces the
>> ability for unprivileged processes to install system call filtering
>> policy expressed in terms of a Berkeley Packet Filter (BPF) program.
>> This program will be evaluated in the kernel for each system call
>> the task makes and computes a result based on data in the format
>> of struct seccomp_data.
>> ...
>> +static void seccomp_filter_log_failure(int syscall)
>> +{
>> +     int compat = 0;
>> +#ifdef CONFIG_COMPAT
>> +     compat = is_compat_task();
>> +#endif
>
> hm, I'm surprised that we don't have a zero-returning implementation of
> is_compat_task() when CONFIG_COMPAT=n.  Seems silly.  Blames Arnd.

There is, but this chunk of the patch is removed later on in the
series. We could just drop seccomp_filter_log_failure and it's single
call entirely and depend on the later enhancement to add the logging
that is desired.

>> +static long seccomp_attach_filter(struct sock_fprog *fprog)
>> +{
>> +     struct seccomp_filter *filter;
>> +     unsigned long fp_size = fprog->len * sizeof(struct sock_filter);
>> +     unsigned long total_insns = fprog->len;
>> +     long ret;
>> +
>> +     if (fprog->len == 0 || fprog->len > BPF_MAXINSNS)
>> +             return -EINVAL;
>> +
>> +     for (filter = current->seccomp.filter; filter; filter = filter->prev)
>> +             total_insns += filter->len + 4;  /* include a 4 instr penalty */
>
> So tasks don't share filters?  We copy them by value at fork?  Do we do
> this at vfork() too?

The filter chain is shared (and refcounted).

>> +     if (total_insns > MAX_INSNS_PER_PATH)
>> +             return -ENOMEM;
>> +
>> +     /*
>> +      * Installing a seccomp filter requires that the task have
>> +      * CAP_SYS_ADMIN in its namespace or be running with no_new_privs.
>> +      * This avoids scenarios where unprivileged tasks can affect the
>> +      * behavior of privileged children.
>> +      */
>> +     if (!current->no_new_privs &&
>> +         security_capable_noaudit(current_cred(), current_user_ns(),
>> +                                  CAP_SYS_ADMIN) != 0)
>> +             return -EACCES;
>> +
>> +     /* Allocate a new seccomp_filter */
>> +     filter = kzalloc(sizeof(struct seccomp_filter) + fp_size, GFP_KERNEL);
>
> I think this gives userspace an easy way of causing page allocation
> failure warnings, by permitting large kmalloc() attempts.  Add
> __GFP_NOWARN?

This is likely mitigated by the MAX_INSNS_PER_PATH check above, but,
yeah, there's no harm in adding __GFP_NOWARN.

>> +/* put_seccomp_filter - decrements the ref count of tsk->seccomp.filter */
>> +void put_seccomp_filter(struct task_struct *tsk)
>> +{
>> +     struct seccomp_filter *orig = tsk->seccomp.filter;
>> +     /* Clean up single-reference branches iteratively. */
>> +     while (orig && atomic_dec_and_test(&orig->usage)) {
>> +             struct seccomp_filter *freeme = orig;
>> +             orig = orig->prev;
>> +             kfree(freeme);
>> +     }
>> +}
>
> So if one of the filters in the list has an elevated refcount, we bail
> out on the remainder of the list.  Seems odd.

This so that every filter in the list doesn't need to have their
refcount raised. As long as the counting up matching the counting
down, it's fine. This allows for process trees branching the filter
list at different times still being safe. IIUC, this code was based on
how namespace refcounting is handled. I spent some time proving to
myself that it was correctly refcounted a while back. More eyes is
better, of course. :)

-Kees

-- 
Kees Cook
ChromeOS Security
