Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603Ab1ANPAe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 10:00:34 -0500
Received: from mail-wy0-f194.google.com ([74.125.82.194]:56283 "EHLO
	mail-wy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab1ANPA1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 10:00:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gZ4Tt8z+NmNV+PT0FeZenYrCKUBEIZFzv7QR3MM3Z7DiNyS+IP5qgJYj3MTfL5iiVM
         ETi5xWS3ERXmi2Ej3KrNUnCStU09OuVdWIaXoNGw9q5Sqx9QV26lzhsS+4W4N2RDAl7c
         Svd2Ro09afauk83+PioQkvABW5VJBnOhz6wQw=
MIME-Version: 1.0
In-Reply-To: <x494o9bbkqo.fsf@segfault.boston.devel.redhat.com>
References: <AANLkTimMwZnm3UKvmrPscBeZF77vh1sW0ERO1tuv1oNW@mail.gmail.com>
	<x494o9bbkqo.fsf@segfault.boston.devel.redhat.com>
Date: Sat, 15 Jan 2011 02:00:25 +1100
Message-ID: <AANLkTimuCgn4aHzUJRmQfsXjG_UF-3W8fAWb0Y-sSPsM@mail.gmail.com>
Subject: Re: [patch] fs: aio fix rcu lookup
From: Nick Piggin <npiggin@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 15, 2011 at 1:52 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Nick Piggin <npiggin@gmail.com> writes:
>
>> Hi,
>>
>> While hunting down a bug in NFS's AIO, I believe I found this
>> buggy code...
>>
>> fs: aio fix rcu ioctx lookup
>>
>> aio-dio-invalidate-failure GPFs in aio_put_req from io_submit.
>>
>> lookup_ioctx doesn't implement the rcu lookup pattern properly.
>> rcu_read_lock does not prevent refcount going to zero, so we
>> might take a refcount on a zero count ioctx.
>
> So, does this patch fix the problem?  You didn't actually say....

No, it seemd to be an NFS AIO problem, although it was a
slightly older kernel so I'll re test after -rc1 if I haven't heard
back about it.

Do you agree with the theoretical problem? I didn't try to
write a racer to break it yet. Inserting a delay before the
get_ioctx might do the trick.


>> Signed-off-by: Nick Piggin <npiggin@kernel.dk>
>>
>> Index: linux-2.6/fs/aio.c
>> ===================================================================
>> --- linux-2.6.orig/fs/aio.c   2011-01-14 00:29:00.000000000 +1100
>> +++ linux-2.6/fs/aio.c        2011-01-14 11:31:47.000000000 +1100
>> @@ -239,15 +239,23 @@ static void __put_ioctx(struct kioctx *c
>>       call_rcu(&ctx->rcu_head, ctx_rcu_free);
>>  }
>>
>> -#define get_ioctx(kioctx) do {                                               \
>> -     BUG_ON(atomic_read(&(kioctx)->users) <= 0);                     \
>> -     atomic_inc(&(kioctx)->users);                                   \
>> -} while (0)
>> -#define put_ioctx(kioctx) do {                                               \
>> -     BUG_ON(atomic_read(&(kioctx)->users) <= 0);                     \
>> -     if (unlikely(atomic_dec_and_test(&(kioctx)->users)))            \
>> -             __put_ioctx(kioctx);                                    \
>> -} while (0)
>> +static inline void get_ioctx(struct kioctx *kioctx)
>> +{
>> +     BUG_ON(atomic_read(&kioctx->users) <= 0);
>> +     atomic_inc(&kioctx->users);
>> +}
>> +
>> +static inline int try_get_ioctx(struct kioctx *kioctx)
>> +{
>> +     return atomic_inc_not_zero(&kioctx->users);
>> +}
>> +
>> +static inline void put_ioctx(struct kioctx *kioctx)
>> +{
>> +     BUG_ON(atomic_read(&kioctx->users) <= 0);
>> +     if (unlikely(atomic_dec_and_test(&kioctx->users)))
>> +             __put_ioctx(kioctx);
>> +}
>
> Why did you switch from macros?  Personal preference?  Can you at least
> mention it in the changelog?

Yeah, I couldn't bring myself to add another macro :) I can mention
it, sure.
