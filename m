Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914Ab2DITTS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 15:19:18 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55240 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757858Ab2DITTM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 15:19:12 -0400
MIME-Version: 1.0
In-Reply-To: <20120406141936.25d68860.akpm@linux-foundation.org>
References: <1333051320-30872-1-git-send-email-wad@chromium.org>
	<1333051320-30872-11-git-send-email-wad@chromium.org>
	<20120406141936.25d68860.akpm@linux-foundation.org>
Date: Mon, 9 Apr 2012 14:19:08 -0500
Message-ID: <CABqD9haqDr+b6rJa1=rSB6M_3mZuStFf6o3-Ar511-93bgrvHw@mail.gmail.com>
Subject: Re: [PATCH v17 10/15] seccomp: add SECCOMP_RET_ERRNO
From: Will Drewry <wad@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
        kernel-hardening@lists.openwall.com, netdev@vger.kernel.org,
        x86@kernel.org, arnd@arndb.de, davem@davemloft.net, hpa@zytor.com,
        mingo@redhat.com, oleg@redhat.com, peterz@infradead.org,
        rdunlap@xenotime.net, mcgrathr@chromium.org, tglx@linutronix.de,
        luto@mit.edu, eparis@redhat.com, serge.hallyn@canonical.com,
        djm@mindrot.org, scarybeasts@gmail.com, indan@nul.nu,
        pmoore@redhat.com, corbet@lwn.net, eric.dumazet@gmail.com,
        markus@chromium.org, coreyb@linux.vnet.ibm.com, keescook@chromium.org,
        jmorris@namei.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 6, 2012 at 4:19 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 29 Mar 2012 15:01:55 -0500
> Will Drewry <wad@chromium.org> wrote:
>
>> This change adds the SECCOMP_RET_ERRNO as a valid return value from a
>> seccomp filter.  Additionally, it makes the first use of the lower
>> 16-bits for storing a filter-supplied errno.  16-bits is more than
>> enough for the errno-base.h calls.
>>
>> Returning errors instead of immediately terminating processes that
>> violate seccomp policy allow for broader use of this functionality
>> for kernel attack surface reduction.  For example, a linux container
>> could maintain a whitelist of pre-existing system calls but drop
>> all new ones with errnos.  This would keep a logically static attack
>> surface while providing errnos that may allow for graceful failure
>> without the downside of do_exit() on a bad call.
>>
>>
>> ...
>>
>> @@ -64,11 +65,17 @@ struct seccomp {
>>       struct seccomp_filter *filter;
>>  };
>>
>> -extern void __secure_computing(int);
>> -static inline void secure_computing(int this_syscall)
>> +/*
>> + * Direct callers to __secure_computing should be updated as
>> + * CONFIG_HAVE_ARCH_SECCOMP_FILTER propagates.
>
> Are there any such callers?  There's one I see in arm, but it's called
> from assembly code.

I think just arm, but I was trying to limit the patch growth as much
as I could, practically.  ARM support is relevant to my interests, and
I need to have patches out for review quite soon (once this series
settles :).

I hesitate to ask, but should I add a patch to this series for arm?

>> + */
>> +extern void __secure_computing(int) __deprecated;
>> +extern int __secure_computing_int(int);
>> +static inline int secure_computing(int this_syscall)
>>  {
>>       if (unlikely(test_thread_flag(TIF_SECCOMP)))
>> -             __secure_computing(this_syscall);
>> +             return  __secure_computing_int(this_syscall);
>> +     return 0;
>>  }
>>
>> ...
>>
>>  void __secure_computing(int this_syscall)
>>  {
>> +     /* Filter calls should never use this function. */
>> +     BUG_ON(current->seccomp.mode == SECCOMP_MODE_FILTER);
>> +     __secure_computing_int(this_syscall);
>> +}
>> +
>> +int __secure_computing_int(int this_syscall)
>
> What the heck does "_int" mean here?  I read it as "integer" but
> perhaps it's shorthand for "internal".  Give us a better name, please.
> Or a code comment.

It meant "returns an int", but its unclear.  I definitely will add a
comment, but I'm open to better naming.  Perhaps it'd make sense to
bring it inline with the other hook call styles:
  /* <proper comment here> */
  __secure_computing_enter(int this_syscall)

I can keep the other call as 'deprecated', and then remove it once all
the callers are updated.

I'll reply to the rest of the mails shortly - thanks!
will
