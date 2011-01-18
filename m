Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab1ARXA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 18:00:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440Ab1ARXAZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 18:00:25 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Nick Piggin <npiggin@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] fs: aio fix rcu lookup
References: <AANLkTimMwZnm3UKvmrPscBeZF77vh1sW0ERO1tuv1oNW@mail.gmail.com>
	<x494o9bbkqo.fsf@segfault.boston.devel.redhat.com>
	<AANLkTimuCgn4aHzUJRmQfsXjG_UF-3W8fAWb0Y-sSPsM@mail.gmail.com>
	<x49tyh7mjr6.fsf@segfault.boston.devel.redhat.com>
	<AANLkTikgsGHJ+q6=We_zPAivyABq+z2f6Atv6ZScLYOU@mail.gmail.com>
	<20110118190114.GA5070@quack.suse.cz>
	<AANLkTin1+B_1CV-weALdS8EYJO60BJd0b7AGWzc0wrWr@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 18 Jan 2011 18:00:14 -0500
In-Reply-To: <AANLkTin1+B_1CV-weALdS8EYJO60BJd0b7AGWzc0wrWr@mail.gmail.com>
	(Nick Piggin's message of "Wed, 19 Jan 2011 09:17:23 +1100")
Message-ID: <x49mxmx6cn5.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <npiggin@gmail.com> writes:

> On Wed, Jan 19, 2011 at 6:01 AM, Jan Kara <jack@suse.cz> wrote:
>>  Hi,
>>
>> On Tue 18-01-11 10:24:24, Nick Piggin wrote:
>>> On Tue, Jan 18, 2011 at 6:07 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
>>> > Nick Piggin <npiggin@gmail.com> writes:
>>> >> Do you agree with the theoretical problem? I didn't try to
>>> >> write a racer to break it yet. Inserting a delay before the
>>> >> get_ioctx might do the trick.
>>> >
>>> > I'm not convinced, no.  The last reference to the kioctx is always the
>>> > process, released in the exit_aio path, or via sys_io_destroy.  In both
>>> > cases, we cancel all aios, then wait for them all to complete before
>>> > dropping the final reference to the context.
>>>
>>> That wouldn't appear to prevent a concurrent thread from doing an
>>> io operation that requires ioctx lookup, and taking the last reference
>>> after the io_cancel thread drops the ref.
>>>
>>> > So, while I agree that what you wrote is better, I remain unconvinced of
>>> > it solving a real-world problem.  Feel free to push it in as a cleanup,
>>> > though.
>>>
>>> Well I think it has to be technically correct first. If there is indeed a
>>> guaranteed ref somehow, it just needs a comment.
>>  Hmm, the code in io_destroy() indeed looks fishy. We delete the ioctx
>> from the hash table and set ioctx->dead which is supposed to stop
>> lookup_ioctx() from finding it (see the !ctx->dead check in
>> lookup_ioctx()). There's even a comment in io_destroy() saying:
>>        /*
>>         * Wake up any waiters.  The setting of ctx->dead must be seen
>>         * by other CPUs at this point.  Right now, we rely on the
>>         * locking done by the above calls to ensure this consistency.
>>         */
>> But since lookup_ioctx() is called without any lock or barrier nothing
>> really seems to prevent the list traversal and ioctx->dead test to happen
>> before io_destroy() and get_ioctx() after io_destroy().
>>
>> But wouldn't the right fix be to call synchronize_rcu() in io_destroy()?
>> Because with your fix we could still return 'dead' ioctx and I don't think
>> we are supposed to do that...
>
> With my fix we won't oops, I was a bit concerned about ->dead,
> yes but I don't know what semantics it is attempted to have there.
>
> synchronize_rcu() in io_destroy()  does not prevent it from returning
> as soon as lookup_ioctx drops the rcu_read_lock().
>
> The dead=1 in io_destroy indeed doesn't guarantee a whole lot.
> Anyone know?

See the comment above io_destroy for starters.  Note that rcu was
bolted on later, and I believe that ->dead has nothing to do with the
rcu-ification.

Cheers,
Jeff
