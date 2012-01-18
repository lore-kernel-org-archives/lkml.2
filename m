Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab2ARTWp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 14:22:45 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:58149 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab2ARTWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 14:22:43 -0500
Message-ID: <4F171BF8.50803@linux.vnet.ibm.com>
Date: Thu, 19 Jan 2012 00:52:32 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, horms@verge.net.au,
        "pavel@ucw.cz" <pavel@ucw.cz>, Len Brown <lenb@kernel.org>
Subject: Re: [Update][PATCH] PM / Hibernate: Fix s2disk regression related
 to unlock_system_sleep()
References: <201201172345.15010.rjw@sisk.pl> <201201180015.56510.rjw@sisk.pl> <4F16C24A.4050007@linux.vnet.ibm.com> <CAOS58YMBWrD2cMyPJG0Xf16i1vnkB8xerdeqWJ=fk7HVNpoPAw@mail.gmail.com> <4F16F94C.4020000@linux.vnet.ibm.com> <CAOS58YPW3hB3ibaYPLBqhu=2jZTAjjF7DZaXO=hK5tookAX7YA@mail.gmail.com> <4F16FF0D.1030606@linux.vnet.ibm.com> <20120118173037.GE30664@google.com>
In-Reply-To: <20120118173037.GE30664@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12011819-3864-0000-0000-000001054FB7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2012 11:00 PM, Tejun Heo wrote:

> Hello, Srivatsa.
> 
> On Wed, Jan 18, 2012 at 10:49:09PM +0530, Srivatsa S. Bhat wrote:
>> I agree, but I was trying to keep the comment from growing too long ;)
> 
> It doesn't have to be long.  It just has to give some meaning to the
> decision.  AFAICS, it is correct to call try_to_freeze() on
> unlock_system_sleep() regardless of 20sec window.  There's no
> guarantee the unlocking task is gonna hit try_to_freeze() elsewhere
> and not calling it actually makes the interface buggy.
> 


Not really -

In short, there is a *key* difference between:

freezer_do_not_count() - freezer_count()

vs

lock_system_sleep() - unlock_system_sleep()

And that is, the latter pair acquire and release pm_mutex -
and the freezer doesn't do *anything* without first acquiring the same
pm_mutex.

Which is convincing enough to start believing that try_to_freeze()
might be unnecessary in the latter pair.

Now, more explanation follows:
Consider the 2 cases below:

Some random code:

Case 1:

/* Was doing something */

freezer_do_not_count();

/* Important work */

freezer_count();

Case 2:

/* Was doing something */

lock_system_sleep();

/* Important work */

unlock_system_sleep();

In case 1, we asked the freezer to ignore us until we are done with some
"important" work. And precisely because we interfered with the freezer
trying to freeze us, it is our duty to cooperate with the freezer when
our "important" work is finished. Which is why we call try_to_freeze()
inside freezer_count().

However, in case 2, the same story as above applies, but with a catch:
After we asked the freezer to ignore us, we could not even *start* doing our
"important" work! Because, we were waiting for pm_mutex, since the freezer
had got hold of it!

So we get to do our "important work" only when the freezer and all other
PM operations after that is done. And here is another catch: Once we start
doing our "important work", no PM operation (freezing in particular) can begin,
because now *we* have acquired the pm_mutex :-)

So to summarize, calling try_to_freeze() inside some generic freezer_count()
is justified and _needed_. But in case of unlock_system_sleep(), as I depicted
in my previous post, it wouldn't buy us anything at all! (because freezing
wouldn't have even begun by then).

[ And in the case of freezer_count(), your point is right that calling
try_to_freeze() is not to help the freezer meet its 20sec deadline - the
freezer could have finished its work and gone away long before we completed
our "important" work. So the real reason why we call try_to_freeze in
freezer_count is that when some PM operation is running which requires tasks
to be frozen, we want to respect that condition and get frozen - but we
probably ended up totally bypassing the freezer by calling freezer_do_not_count,
but now that we are done with our important work, we want to manually enter
the refrigerator, to satisfy the freezing condition requested by the PM
operation in progress and hence avoid any havoc by running any further.]

> That said, it causes a problem because unlock_system_sleep() is called
> in a special context during later stage of hibernation where the usual
> expectation - that a freezable task which sees a freezing condition
> should freeze - doesn't hold.
> 
> The correct solution would be somehow marking that condition so that
> either try_to_freeze() doesn't get invoked or gets nullified -


Even I thought this would be the right solution at first, but then realized
that having try_to_freeze() inside unlock_system_sleep() is not at all
essential, to begin with.

And not having try_to_freeze() within unlock_system_sleep() automatically
solves the hibernation problem. In fact, it does even better:
Later stages of hibernation would no longer be a "special context" to watch
out for!

> e.g. making the SKIP thing a counter and ensure the hibernating task
> has it elevated throughout the whole process.  Alternatively, if the
> code path is limited enough, using a different version of the unlock
> function, unlock_system_sleep_nofreeze() or whatever, would work too -
> this is a popular approach for synchronization functions which
> interacts with scheduler and preemption.
> 
> For now, as a quick fix, maybe not calling try_to_freeze()
> unconditionally is okay, I don't know, but it's a hack.
> 


Somehow I don't think its a hack, based on my perception as described
above. But feel free to prove me wrong :-)
 
Regards,
Srivatsa S. Bhat

