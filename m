Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759425Ab1D1SBO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 14:01:14 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64000 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103Ab1D1SBM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 14:01:12 -0400
MIME-Version: 1.0
In-Reply-To: <20110428173957.GA25940@hallyn.com>
References: <1303960136-14298-1-git-send-email-wad@chromium.org>
	<1303960136-14298-2-git-send-email-wad@chromium.org>
	<20110428165525.GB1927@hallyn.com>
	<1304010981.18763.192.camel@gandalf.stny.rr.com>
	<20110428173957.GA25940@hallyn.com>
Date: Thu, 28 Apr 2011 13:01:11 -0500
Message-ID: <BANLkTi=ukfidjHpKUr1vL67aQUFcNxXFeA@mail.gmail.com>
Subject: Re: [PATCH 3/7] seccomp_filter: Enable ftrace-based system call filtering
From: Will Drewry <wad@chromium.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        kees.cook@canonical.com, eparis@redhat.com, agl@chromium.org,
        mingo@elte.hu, jmorris@namei.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Michal Marek <mmarek@suse.cz>, Oleg Nesterov <oleg@redhat.com>,
        Roland McGrath <roland@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Slaby <jslaby@suse.cz>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 12:39 PM, Serge E. Hallyn <serge@hallyn.com> wrote:
> Quoting Steven Rostedt (rostedt@goodmis.org):
>> On Thu, 2011-04-28 at 11:55 -0500, Serge E. Hallyn wrote:
>>
>> > ...
>> >
>> > >  void __secure_computing(int this_syscall)
>> > >  {
>> > > - int mode = current->seccomp.mode;
>> > > + int mode = -1;
>> > >   int * syscall;
>> > > -
>> > > + /* Do we need an RCU read lock to access current's state? */
>> >
>> > Nope.
>>
>> Correct.
>>
>> > > - out:
>> > > + rcu_assign_pointer(current->seccomp.state, state);
>> > > + synchronize_rcu();
>> > > + put_seccomp_state(orig_state);  /* for the get */
>> > > +
>> > > +out:
>> > > + put_seccomp_state(orig_state);  /* for the task */
>> > > + return ret;
>> > > +
>> > > +free_state:
>> > > + put_seccomp_state(orig_state);  /* for the get */
>> > > + put_seccomp_state(state);  /* drop the dup */
>> > >   return ret;
>> > >  }
>> >
>> > This looks exactly right.  The only case where put_seccomp_state()
>> > might actually lead to freeing the state is where the current's
>> > state gets reassigned.  So you need to synchronize_rcu() before
>> > that (as you do).  The other cases will only decrement the usage
>> > counter, can race with a reader doing (inc; get) but not with a
>> > final free, which can only be done here.
>>
>> Technically incorrect ;)
>>
>> "final free, which can only be done here."
>>
>> This is not the only place that a free will happen. But the code is
>> correct none-the-less.
>>
>> Reader on another CPU ups the orig_state refcount under rcu_readlock,
>> but after it ups the refcount it releases the rcu_readlock and continues
>> to read this state.
>>
>> Current on this CPU calls this function does the synchronize_rcu() and
>> calls put on the state. But since the reader still has a ref count on
>> it, it does not get freed here.
>>
>> When the reader is finally done with the state it calls the put() which
>> does the final free on it.
>>
>> The code still looks correct, I'm just nitpicking your analysis.
>
> :)  I appreciate the precision.
>
>> > (Rambling above is just me pursuading myself)
>>
>> Me rambling too.
>>
>> >
>> > > diff --git a/kernel/seccomp_filter.c b/kernel/seccomp_filter.c
>> >
>> > Unfortunately your use of filters doesn't seem exactly right.
>> >
>> > > +/* seccomp_copy_all_filters - copies all filters from src to dst.
>> > > + *
>> > > + * @dst: the list_head for seccomp_filters to populate.
>> > > + * @src: the list_head for seccomp_filters to copy from.
>> > > + * Returns non-zero on failure.
>> > > + */
>> > > +int seccomp_copy_all_filters(struct list_head *dst,
>> > > +                      const struct list_head *src)
>> > > +{
>> > > + struct seccomp_filter *filter;
>> > > + int ret = 0;
>> > > + BUG_ON(!dst || !src);
>> > > + if (list_empty(src))
>> > > +         goto done;
>> > > + rcu_read_lock();
>> > > + list_for_each_entry(filter, src, list) {
>> > > +         struct seccomp_filter *new_filter = copy_seccomp_filter(filter);
>> >
>> > copy_seccomp_filter() causes kzalloc to be called.  You can't do that under
>> > rcu_read_lock().
>>
>> Unless you change the kzalloc to do GFP_ATOMIC. Not sure I'd recommend
>> doing that.

Good to know! My question (below) is if I should even be using an RCU
guard at all. I may have been a bit too overzealous.

>> >
>> > I actually thought you were going to be more extreme about the seccomp
>> > state than you are:  I thought you were going to tie a filter list to
>> > seccomp state.  So adding or removing a filter would have required
>> > duping the seccomp state, duping all the filters, making the change in
>> > the copy, and then swapping the new state into place.  Slow in the
>> > hopefully rare update case, but safe.

Hrm, I think I'm confused now!  This is exactly what I *thought* the
code was doing.

At present, seccomp_state can be shared across predecessor/ancestor
relationships using refcounting in fork.c  (get/put). However, the
only way to change a given seccomp_state or its filters is either
through the one-bit on_next_syscall change or through
prctl_set_seccomp.  In prctl_set_seccomp, it does:
state = (orig_state ? seccomp_state_dup(orig_state) :
                              seccomp_state_new());
operates on the new state and then rcu_assign_pointer()s it to the
task.  I didn't intentionally provide any way to drop filters from an
existing state object nor change the filtered syscalls on an in-use
object.  That _dup call should hit the impromperly rcu_locked
copy_all_filters returning duplicates of the original filters by
reparsing the filter_string.

Did I accidentally provide a means to mutate a state object or filter
list without dup()ing? :/

>> > You don't have to do that, but then I'm pretty sure you'll need to add
>> > reference counts to each filter and use rcu cycles to a reader from
>> > having the filter disappear mid-read.

Right now, I don't think it is possible for seccomp_copy_all_filters()
to be called with a src list that changes since every change is
guarded by a seccomp_state_dup(). If that's not true, then I violated
my own invariant :/  If that is the case, should I not treat the list
as an RCU list?  There should never be any simultaneous
reader/writers, just a single reader/writer or multiple readers.

>>
>> Or you can preallocate the new filters, call rcu_read_lock(), check if
>> the number of old filters is the same or less, if more, call
>> rcu_read_unlock, and try allocating more, and then call rcu_read_lock()
>> again and repeat. Then just copy the filters to the preallocate ones.
>> rcu_read_unlock() and then free any unused allocated filters.
>>
>> Maybe a bit messy, but not that bad.
>
> Sounds good.

I'd prefer a heavy-weight copy ;)

I think I'm a bit lost -- am I missing something obvious here?  I was
hoping by using a swapped-in-seccomp_state-pointer, locking and
consistency internal to the state objects would be a tad easier -
though expensive.

thanks!
will
