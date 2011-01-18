Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab1ARXFR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 18:05:17 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:36270 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab1ARXFO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 18:05:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sZECxXxfFEHyXEAdZutAyVlxz8fgrLgoMy5JQMIXfWZJK0rXCuuhRdPtutjFjDT5sI
         uvyscbnIAOPeCWi466Iw4lB03gVoaDo2EaKX48VMqi458KWRPrP6vfLECOPnqbNr1g1C
         Hp/G4gTwjZKH2iGVDrf27t+F0vNByg9QozPsM=
MIME-Version: 1.0
In-Reply-To: <x49mxmx6cn5.fsf@segfault.boston.devel.redhat.com>
References: <AANLkTimMwZnm3UKvmrPscBeZF77vh1sW0ERO1tuv1oNW@mail.gmail.com>
	<x494o9bbkqo.fsf@segfault.boston.devel.redhat.com>
	<AANLkTimuCgn4aHzUJRmQfsXjG_UF-3W8fAWb0Y-sSPsM@mail.gmail.com>
	<x49tyh7mjr6.fsf@segfault.boston.devel.redhat.com>
	<AANLkTikgsGHJ+q6=We_zPAivyABq+z2f6Atv6ZScLYOU@mail.gmail.com>
	<20110118190114.GA5070@quack.suse.cz>
	<AANLkTin1+B_1CV-weALdS8EYJO60BJd0b7AGWzc0wrWr@mail.gmail.com>
	<x49mxmx6cn5.fsf@segfault.boston.devel.redhat.com>
Date: Wed, 19 Jan 2011 10:05:12 +1100
Message-ID: <AANLkTi=jRZzrZO3_5ZQ+tt8qS=rYzrntLXrUoHq+8hnC@mail.gmail.com>
Subject: Re: [patch] fs: aio fix rcu lookup
From: Nick Piggin <npiggin@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 10:00 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Nick Piggin <npiggin@gmail.com> writes:
>
>> On Wed, Jan 19, 2011 at 6:01 AM, Jan Kara <jack@suse.cz> wrote:
>>>  Hi,
>>>
>>> On Tue 18-01-11 10:24:24, Nick Piggin wrote:
>>>> On Tue, Jan 18, 2011 at 6:07 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
>>>> > Nick Piggin <npiggin@gmail.com> writes:
>>>> >> Do you agree with the theoretical problem? I didn't try to
>>>> >> write a racer to break it yet. Inserting a delay before the
>>>> >> get_ioctx might do the trick.
>>>> >
>>>> > I'm not convinced, no.  The last reference to the kioctx is always the
>>>> > process, released in the exit_aio path, or via sys_io_destroy.  In both
>>>> > cases, we cancel all aios, then wait for them all to complete before
>>>> > dropping the final reference to the context.
>>>>
>>>> That wouldn't appear to prevent a concurrent thread from doing an
>>>> io operation that requires ioctx lookup, and taking the last reference
>>>> after the io_cancel thread drops the ref.
>>>>
>>>> > So, while I agree that what you wrote is better, I remain unconvinced of
>>>> > it solving a real-world problem.  Feel free to push it in as a cleanup,
>>>> > though.
>>>>
>>>> Well I think it has to be technically correct first. If there is indeed a
>>>> guaranteed ref somehow, it just needs a comment.
>>>  Hmm, the code in io_destroy() indeed looks fishy. We delete the ioctx
>>> from the hash table and set ioctx->dead which is supposed to stop
>>> lookup_ioctx() from finding it (see the !ctx->dead check in
>>> lookup_ioctx()). There's even a comment in io_destroy() saying:
>>>        /*
>>>         * Wake up any waiters.  The setting of ctx->dead must be seen
>>>         * by other CPUs at this point.  Right now, we rely on the
>>>         * locking done by the above calls to ensure this consistency.
>>>         */
>>> But since lookup_ioctx() is called without any lock or barrier nothing
>>> really seems to prevent the list traversal and ioctx->dead test to happen
>>> before io_destroy() and get_ioctx() after io_destroy().
>>>
>>> But wouldn't the right fix be to call synchronize_rcu() in io_destroy()?
>>> Because with your fix we could still return 'dead' ioctx and I don't think
>>> we are supposed to do that...
>>
>> With my fix we won't oops, I was a bit concerned about ->dead,
>> yes but I don't know what semantics it is attempted to have there.
>>
>> synchronize_rcu() in io_destroy()  does not prevent it from returning
>> as soon as lookup_ioctx drops the rcu_read_lock().
>>
>> The dead=1 in io_destroy indeed doesn't guarantee a whole lot.
>> Anyone know?
>
> See the comment above io_destroy for starters.  Note that rcu was
> bolted on later, and I believe that ->dead has nothing to do with the
> rcu-ification.

Ah, yep, that makes sense indeed.
