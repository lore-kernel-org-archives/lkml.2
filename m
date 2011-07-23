Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab1GWSlx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 14:41:53 -0400
Received: from mail.cs.tu-berlin.de ([130.149.17.13]:63607 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265Ab1GWSlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 14:41:47 -0400
Message-ID: <4E2B15CF.8020700@cs.tu-berlin.de>
Date: Sat, 23 Jul 2011 20:41:19 +0200
From: =?ISO-8859-1?Q?Jan_Sch=F6nherr?= <schnhrr@cs.tu-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; de; rv:1.9.1.5) Gecko/20091204 Lightning/1.0b1 Thunderbird/3.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Paul Turner <pjt@google.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 2/3] rcu: More rcu-variants for list manipulation
References: <CAPM31RLqq0hgdhoh3GA-38petKeE1zxcL=uJYba9o3yd+_7jjw@mail.gmail.com> <1311254423-25484-1-git-send-email-schnhrr@cs.tu-berlin.de> <1311254423-25484-3-git-send-email-schnhrr@cs.tu-berlin.de> <20110722162149.GE2382@linux.vnet.ibm.com>
In-Reply-To: <20110722162149.GE2382@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 22.07.2011 18:21, schrieb Paul E. McKenney:
> Please see below for some comments on issues you are probably already
> well aware of -- just commenting, the code itself looks OK.

Nice to hear.

> Once this
> patch is in good shape, it should probably go with the following patch
> (which uses it) rather than up -rcu.

Okay. Whether I'll put this code into good shape or not depends
a bit on the last patch using this functionality.

You are of course right with the missing comments, but if this way of solving
the problem is rejected (or has some other problems that I might have
overlooked), then there is no point in writing all the comments...
(That is also why I did not put you on CC yet.)

If we decide to do it that way, you will get an updated version, hopefully
with all the comments you want to see in there. :)


>> +static inline void __list_link_rcu(struct list_head *prev,
>> +					struct list_head *next)
>> +{
>> +	rcu_assign_pointer(list_next_rcu(prev), next);
>> +	next->prev = prev;
>> +}
>
> OK, so this one links a single list element to another single list
> element.  You therefore need two calls to this to splice a pair of list
> together, right?

Yes (or to the non-rcu version).

> If so, there will be a time when you have a "6" shaped
> list, so that readers from one of the list heads will never come back
> to that list head.  This is probably what you are getting at with your
> "require that there are either no concurrent readers on the list to be
> spliced or that these readers are still from the list where the list is
> spliced into".

Exactly. No reader must get trapped in a circle. They all must be able
to return to their list head.

> However, this is quite subtle and needs to be spelled out carefully.

I will try to do that.


> Really badly need a header comment here!!!  Which of these lists can
> tolerate concurrent readers?  Why are there three arguments?  My guess
> from the code is that "list" is the list being spliced, and it cannot
> tolerate concurrent readers, while "prev" is one end of the place to
> splice into the list and "next" is the other.  I believe that both "prev"
> and "next" can tolerate concurrent readers.
>
> Did I get it right?

Everything. :)

Regarding the function arguments, I tried to mimic those of the non-rcu
variants.


>> +static inline void __list_splice_rcu(struct list_head *list,
>> +					struct list_head *prev,
>> +					struct list_head *next)
>> +{
>> +	__list_link(list->prev, next);
>
> At this point, RCU readers traversing the list containing "prev" and
> "next" see no change, which is why it is OK to use __list_link() rather
> than __list_link_rcu().  If there are readers traversing "list", they
> will loop infinitely failing to find the old list header.

Either that, or they do something worse as they mistake the new list
header for a normal node and try to access some of the elements of the
surrounding struct, which does not exist in this case.

>
>> +	__list_link_rcu(prev, list->next);
>
> At this point, new RCU readers traversing the list containing
> "next" and "prev" suddenly see the new elements from "list".  The
> rcu_assign_pointer() in __lists_link_rcu() should force proper ordering.
>
> OK, so looks reasonable.  Assuming that my guesses about what this is
> supposed to do are correct, anyway.

I should probably say something about possible the use cases of this:

One could of course rewrite the already existing rcu-splice function to use
this low level funtionality.

But it gets more interesting if you want to add multiple elements to an
rcu-protected list: Instead of doing that one by one with list_add_rcu()
you can assemble them in a non-rcu list and splice them (avoiding quite
a few memory barriers).

The use case in the 3rd patch is even more special: The elements that
are spliced were removed from the very same list previously and there
might still be readers on them from before the removal. Due to this we
cannot collect this batch in a new list. But we can link one deleted
entry to the next (using the non-rcu(!) __list_link) building up a chain
of deleted entries. If there was a reader, it will find its way back
to the list over the last element in that chain. That chain is then
passed to the splice function.

(That chain-handling is currently in the third patch. I wonder whether
we should move that to one of the header files, too?!)

Regards
Jan
