Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933374Ab1D1SeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 14:34:19 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40545 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933110Ab1D1SeS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 14:34:18 -0400
MIME-Version: 1.0
In-Reply-To: <1304014874.18763.201.camel@gandalf.stny.rr.com>
References: <1303960136-14298-1-git-send-email-wad@chromium.org>
	<1303960136-14298-2-git-send-email-wad@chromium.org>
	<20110428165525.GB1927@hallyn.com>
	<1304010981.18763.192.camel@gandalf.stny.rr.com>
	<20110428173957.GA25940@hallyn.com>
	<BANLkTi=ukfidjHpKUr1vL67aQUFcNxXFeA@mail.gmail.com>
	<1304014874.18763.201.camel@gandalf.stny.rr.com>
Date: Thu, 28 Apr 2011 13:34:16 -0500
Message-ID: <BANLkTimg==qTO2=1VaeXFM8Gt5R_VFYLCA@mail.gmail.com>
Subject: Re: [PATCH 3/7] seccomp_filter: Enable ftrace-based system call filtering
From: Will Drewry <wad@chromium.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
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

On Thu, Apr 28, 2011 at 1:21 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Thu, 2011-04-28 at 13:01 -0500, Will Drewry wrote:
>
>> Good to know! My question (below) is if I should even be using an RCU
>> guard at all. I may have been a bit too overzealous.
>>
>> >> >
>> >> > I actually thought you were going to be more extreme about the seccomp
>> >> > state than you are:  I thought you were going to tie a filter list to
>> >> > seccomp state.  So adding or removing a filter would have required
>> >> > duping the seccomp state, duping all the filters, making the change in
>> >> > the copy, and then swapping the new state into place.  Slow in the
>> >> > hopefully rare update case, but safe.
>>
>> Hrm, I think I'm confused now!  This is exactly what I *thought* the
>> code was doing.
>
> I guess my thought by looking at the code is the call_rcu() to free the
> filters in drop_matching_filters().
>
> Also, you have seccomp_drop_all_filters() as a standalone function that
> is even exported to modules.
>
> This to me, seems that the filters can disappear at any time. Because
> the freeing is done with a rcu_call() the access to the filters needs a
> ref count.
>
>>
>> At present, seccomp_state can be shared across predecessor/ancestor
>> relationships using refcounting in fork.c  (get/put). However, the
>> only way to change a given seccomp_state or its filters is either
>> through the one-bit on_next_syscall change or through
>> prctl_set_seccomp.  In prctl_set_seccomp, it does:
>> state = (orig_state ? seccomp_state_dup(orig_state) :
>>                               seccomp_state_new());
>> operates on the new state and then rcu_assign_pointer()s it to the
>> task.  I didn't intentionally provide any way to drop filters from an
>> existing state object nor change the filtered syscalls on an in-use
>> object.  That _dup call should hit the impromperly rcu_locked
>> copy_all_filters returning duplicates of the original filters by
>> reparsing the filter_string.
>>
>> Did I accidentally provide a means to mutate a state object or filter
>> list without dup()ing? :/
>
> That seccomp_drop_all_filters() looks like you can.
>
>>
>> >> > You don't have to do that, but then I'm pretty sure you'll need to add
>> >> > reference counts to each filter and use rcu cycles to a reader from
>> >> > having the filter disappear mid-read.
>>
>> Right now, I don't think it is possible for seccomp_copy_all_filters()
>> to be called with a src list that changes since every change is
>> guarded by a seccomp_state_dup(). If that's not true, then I violated
>> my own invariant :/  If that is the case, should I not treat the list
>> as an RCU list?  There should never be any simultaneous
>> reader/writers, just a single reader/writer or multiple readers.
>
> Again, that seccomp_copy_all_filters() is called free standing (exported
> to modules). Which to me means that it can be called by anyone at
> anytime. There is no protection of this src list.
>
>>
>> >>
>> >> Or you can preallocate the new filters, call rcu_read_lock(), check if
>> >> the number of old filters is the same or less, if more, call
>> >> rcu_read_unlock, and try allocating more, and then call rcu_read_lock()
>> >> again and repeat. Then just copy the filters to the preallocate ones.
>> >> rcu_read_unlock() and then free any unused allocated filters.
>> >>
>> >> Maybe a bit messy, but not that bad.
>> >
>> > Sounds good.
>>
>> I'd prefer a heavy-weight copy ;)
>>
>> I think I'm a bit lost -- am I missing something obvious here?  I was
>> hoping by using a swapped-in-seccomp_state-pointer, locking and
>> consistency internal to the state objects would be a tad easier -
>> though expensive.
>
> Perhaps, but those free standing functions (the ones that are exported
> to modules) seem like they can destroy state.

My intent was to make them available for use by seccomp.c during state
teardown/dup.  I don't think there's benefit to exposing them outside
of that.  Would dropping the export, and adding an local seccomp.h
with the shared functions in them resolve that more cleanly?

> Your code would have been correct if you could call kzalloc under
> rcu_read_lock() (which you can on some kernel configurations but not
> all). The issue is that you need to pull out that allocation from the
> rcu_read_lock() because rcu_read_lock assumes you can't preempt, and
> that allocation can schedule out. The access to the filters must be done
> under rcu_read_lock(), other than that, you're fine.

That makes sense.  I think I'd prefer to not share those functions
rather than guard the list just in case a future consumer of the
interface comes along.  Would that make sense to you?  Since I don't
see any other users right now other than seccomp.c, it might make
sense to tackle the impact when an actual need arises.

I'll go whichever way pointed on this, though.
thanks again,
will
