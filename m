Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137Ab1ARRWg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 12:22:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753110Ab1ARRWb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 12:22:31 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Nick Piggin <npiggin@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] fs: aio fix rcu lookup
References: <AANLkTimMwZnm3UKvmrPscBeZF77vh1sW0ERO1tuv1oNW@mail.gmail.com>
	<x494o9bbkqo.fsf@segfault.boston.devel.redhat.com>
	<AANLkTimuCgn4aHzUJRmQfsXjG_UF-3W8fAWb0Y-sSPsM@mail.gmail.com>
	<x49tyh7mjr6.fsf@segfault.boston.devel.redhat.com>
	<AANLkTikgsGHJ+q6=We_zPAivyABq+z2f6Atv6ZScLYOU@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 18 Jan 2011 12:21:58 -0500
Message-ID: <x49fwsq9lft.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <npiggin@gmail.com> writes:

> On Tue, Jan 18, 2011 at 6:07 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
>> Nick Piggin <npiggin@gmail.com> writes:
>>
>>> On Sat, Jan 15, 2011 at 1:52 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
>>>> Nick Piggin <npiggin@gmail.com> writes:
>>>>
>>>>> Hi,
>>>>>
>>>>> While hunting down a bug in NFS's AIO, I believe I found this
>>>>> buggy code...
>>>>>
>>>>> fs: aio fix rcu ioctx lookup
>>>>>
>>>>> aio-dio-invalidate-failure GPFs in aio_put_req from io_submit.
>>>>>
>>>>> lookup_ioctx doesn't implement the rcu lookup pattern properly.
>>>>> rcu_read_lock does not prevent refcount going to zero, so we
>>>>> might take a refcount on a zero count ioctx.
>>>>
>>>> So, does this patch fix the problem?  You didn't actually say....
>>>
>>> No, it seemd to be an NFS AIO problem, although it was a
>>> slightly older kernel so I'll re test after -rc1 if I haven't heard
>>> back about it.
>>
>> OK.
>>
>>> Do you agree with the theoretical problem? I didn't try to
>>> write a racer to break it yet. Inserting a delay before the
>>> get_ioctx might do the trick.
>>
>> I'm not convinced, no.  The last reference to the kioctx is always the
>> process, released in the exit_aio path, or via sys_io_destroy.  In both
>> cases, we cancel all aios, then wait for them all to complete before
>> dropping the final reference to the context.
>
> That wouldn't appear to prevent a concurrent thread from doing an
> io operation that requires ioctx lookup, and taking the last reference
> after the io_cancel thread drops the ref.

io_cancel isn't of any concern here.  When io_setup is called, it
creates the ioctx and takes 2 references to it.  There are two paths to
destroying the ioctx: one is through process exit, the other is through
a call to sys_io_destroy.  The former means that you can't submit more
I/O anyway (which in turn means that there won't be any more lookups on
the ioctx), so I'll focus on the latter.

What you're asking about, then, is a race between lookup_ioctx and
io_destroy.  The first thing io_destroy does is to set ctx->dead to 1
and remove the ioctx from the list:

   spin_lock(&mm->ioctx_lock);
   was_dead = ioctx->dead;
   ioctx->dead = 1;
   hlist_del_rcu(&ioctx->list);
   spin_unlock(&mm->ioctx_lock);

   if (likely(!was_dead))
           put_ioctx(ioctx); /* twice for the list */

   aio_cancel_all(ioctx);
   wait_for_all_aios(ioctx);

   wake_up(&ioctx->wait);
   put_ioctx(ioctx);   /* once for the lookup */

The lookup code is this:

   rcu_read_lock();

   hlist_for_each_entry_rcu(ctx, n, &mm->ioctx_list, list) {
   if (ctx->user_id == ctx_id && !ctx->dead) {
           get_ioctx(ctx);
           ret = ctx;
           break;
...

In order for the race to occur, the lookup code would have to find the
ioctx on the list without the dead mark set.  Then, the io_destroy code
would have to do all of its work, including its two put_ioctx calls, and
finally the get_ioctx from the lookup would have to happen.

Possible?  Maybe.  It certainly isn't explicitly protected against.  Go
ahead and re-post the patch.  I agree that it's a theoretical race.  =)

Cheers,
Jeff
