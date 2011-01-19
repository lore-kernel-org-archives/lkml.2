Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980Ab1ASAUt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 19:20:49 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:55287 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab1ASAUr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 19:20:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WB1+1uf+ZqocaDhAjt3Nff6K8cc1F8YZAtkwFyiW+mhd2BsXDXCjJcBLWFzQkQDJXb
         RXa37RbhhYVxTdGr0zwQFZHQTn9Mx9ktc5tIaQEdp8ENrUr6ro85jWKSbSjsqiun53uy
         TcRgsyAYeU3irTZZKf7SP/7/omyN2VBX3VWf4=
MIME-Version: 1.0
In-Reply-To: <20110118235236.GA14087@quack.suse.cz>
References: <AANLkTimMwZnm3UKvmrPscBeZF77vh1sW0ERO1tuv1oNW@mail.gmail.com>
	<x494o9bbkqo.fsf@segfault.boston.devel.redhat.com>
	<AANLkTimuCgn4aHzUJRmQfsXjG_UF-3W8fAWb0Y-sSPsM@mail.gmail.com>
	<x49tyh7mjr6.fsf@segfault.boston.devel.redhat.com>
	<AANLkTikgsGHJ+q6=We_zPAivyABq+z2f6Atv6ZScLYOU@mail.gmail.com>
	<20110118190114.GA5070@quack.suse.cz>
	<AANLkTin1+B_1CV-weALdS8EYJO60BJd0b7AGWzc0wrWr@mail.gmail.com>
	<20110118235236.GA14087@quack.suse.cz>
Date: Wed, 19 Jan 2011 11:20:45 +1100
Message-ID: <AANLkTikvCkMDM9+i=44eEkX094=ZHpnQaN+541pm1icK@mail.gmail.com>
Subject: Re: [patch] fs: aio fix rcu lookup
From: Nick Piggin <npiggin@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Jeff Moyer <jmoyer@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 10:52 AM, Jan Kara <jack@suse.cz> wrote:
> On Wed 19-01-11 09:17:23, Nick Piggin wrote:
>> On Wed, Jan 19, 2011 at 6:01 AM, Jan Kara <jack@suse.cz> wrote:
>> > On Tue 18-01-11 10:24:24, Nick Piggin wrote:
>> >> On Tue, Jan 18, 2011 at 6:07 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
>> >> > Nick Piggin <npiggin@gmail.com> writes:
>> >> >> Do you agree with the theoretical problem? I didn't try to
>> >> >> write a racer to break it yet. Inserting a delay before the
>> >> >> get_ioctx might do the trick.
>> >> >
>> >> > I'm not convinced, no.  The last reference to the kioctx is always the
>> >> > process, released in the exit_aio path, or via sys_io_destroy.  In both
>> >> > cases, we cancel all aios, then wait for them all to complete before
>> >> > dropping the final reference to the context.
>> >>
>> >> That wouldn't appear to prevent a concurrent thread from doing an
>> >> io operation that requires ioctx lookup, and taking the last reference
>> >> after the io_cancel thread drops the ref.
>> >>
>> >> > So, while I agree that what you wrote is better, I remain unconvinced of
>> >> > it solving a real-world problem.  Feel free to push it in as a cleanup,
>> >> > though.
>> >>
>> >> Well I think it has to be technically correct first. If there is indeed a
>> >> guaranteed ref somehow, it just needs a comment.
>> >  Hmm, the code in io_destroy() indeed looks fishy. We delete the ioctx
>> > from the hash table and set ioctx->dead which is supposed to stop
>> > lookup_ioctx() from finding it (see the !ctx->dead check in
>> > lookup_ioctx()). There's even a comment in io_destroy() saying:
>> >        /*
>> >         * Wake up any waiters.  The setting of ctx->dead must be seen
>> >         * by other CPUs at this point.  Right now, we rely on the
>> >         * locking done by the above calls to ensure this consistency.
>> >         */
>> > But since lookup_ioctx() is called without any lock or barrier nothing
>> > really seems to prevent the list traversal and ioctx->dead test to happen
>> > before io_destroy() and get_ioctx() after io_destroy().
>> >
>> > But wouldn't the right fix be to call synchronize_rcu() in io_destroy()?
>> > Because with your fix we could still return 'dead' ioctx and I don't think
>> > we are supposed to do that...
>>
>> With my fix we won't oops, I was a bit concerned about ->dead,
>> yes but I don't know what semantics it is attempted to have there.
>  But wouldn't it do something bad if the memory gets reallocated for
> something else and set to non-zero? E.g. memory corruption?

I don't see how it would with my patch.


>> synchronize_rcu() in io_destroy()  does not prevent it from returning
>> as soon as lookup_ioctx drops the rcu_read_lock().
>  Yes, exactly. So references obtained before synchronize_rcu() would be
> completely fine and valid references and there would be no references after
> synchronize_rcu() because they'd see 'dead' set. But looking at the code
> again it still would not be enough because we could still race with
> io_submit_one() adding new IO to the ioctx which will be freed just after
> put_ioctx() in do_io_submit().
>
> The patch below implements what I have in mind - it should be probably
> split into two but I'd like to hear comments on that before doing these
> cosmetic touches ;)

Well this seems to solve it too, but it is 2 problems here. It is changing
the semantics of io_destroy which requires the big synchronize_rcu()
hammer.

But I don't believe that's necessarily desirable, or required. In fact it is
explicitly not reuired because it only says that it _may_ cancel outstanding
requests.
