Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab1HBNkU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 09:40:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:40385 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab1HBNkQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 09:40:16 -0400
Subject: Re: [PATCH RFCv2 2/8] rcu: More rcu-variants for list manipulation
From: Peter Zijlstra <peterz@infradead.org>
To: Jan =?ISO-8859-1?Q?Sch=F6nherr?= <schnhrr@cs.tu-berlin.de>
Cc: Paul Turner <pjt@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <4E327232.204@cs.tu-berlin.de>
References: <1311793825-31933-1-git-send-email-schnhrr@cs.tu-berlin.de>
	 <1311793825-31933-3-git-send-email-schnhrr@cs.tu-berlin.de>
	 <4E327232.204@cs.tu-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 02 Aug 2011 15:39:31 +0200
Message-ID: <1312292371.1147.178.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-29 at 10:41 +0200, Jan Schönherr wrote:
> Am 27.07.2011 21:10, schrieb Jan H. Schönherr:
> >  /**
> > + * list_add_tail_nobackref - add element to list without setting up
> > + *			     back references
> > + * @new: element to add
> > + * @head: list to add the element to
> > + *
> > + * @new is appended to @head.
> > + *
> > + * In contrast to list_add_tail(), this function does not maintain the
> > + * references back to @head. So, neither @new->next will be changed, nor
> > + * -- in case @new becomes the first entry of @head -- @new->pref.
> > + *
> > + * This is useful when reorganizing deleted elements of a RCU-protected
> > + * list as concurrent readers must always find their way back to the list.
> > + * When used in this context, special care must be taken in order to not
> > + * disturb concurrent readers on @head (or @new):
> > + * a) @new->next must lead back to the list
> > + * b) @new->next must not lead to any node already on @head
> > + * c) @new must be already known to existing readers on @head
> 
> This might actually race with physical deletion. Consider a list:
> 
>    HEAD --> A --> B --> C --> D --> HEAD
> 
> 1. Remove C from list, then D:
> 
>    HEAD --> A --> B --------------> HEAD
>                         C --> D ----^
> 
> 2. Attempt to physically delete D by using call_rcu() or similar.
>    This is delayed until all already running readers have finished.
> 
> 3. Let a new reader begin to traverse the list, advancing until A.
> 
> 4. Remove A.
> 
>    HEAD --------> B --------------> HEAD
>             A ----^      C --> D ----^
> 
> 5. Call list_add_tail_nobackref() for A, then C.
> 
>    HEAD --------> B --------------> HEAD
>    LIST --> A ---------> C --> D ----^
> 
> 6. Finish step 2, really deleting D.
> 
> 7. Let the new reader continue its traversal.
> 
> This reader will hit D, which is obviously bad.
> 
> 
> I think, we can avoid this by modifying the next pointers
> of the deleted elements and letting them point to HEAD.
> That is:
> 
> 5a. Call list_add_tail_nobackref() for A.
> 
>    HEAD --------> B --------------> HEAD
>                         C --> D ----^
>    LIST --> A -----------------------^
> 
> 5b. Call list_add_tail_nobackref() for C.
> 
>    HEAD --------> B --------------> HEAD
>                               D ----^
>    LIST --> A --------> C -----------^
> 
> 
> 
> However, this (and also the previous version) might
> cause readers to skip elements that are on the list
> (B in the example above). Can we tolerate that?
> 
> My current guess would be: no.
> 
> Thinking more about that, we already have that case:
> 
> 
>    HEAD --> A --> B --> C --> HEAD
> 
> 1. Let a reader traverse until A.
> 
> 2. Remove A.
> 
>    HEAD --------> B --> C --> HEAD
>             A ----^
> 
> 3. Add A after B.
> 
>    HEAD --------> B     C --> HEAD
>                   +> A -^
> 
> 4. Let reader continue traversal, skipping B.
> 
> (Similarly, if we had removed C and re-added it between A and B,
> we could have traversed B twice.)
> 
> So either the presented solution in this patch series
> is valid, or -- when we are not allowed to re-add
> elements which might still have readers -- the current
> handling of CFS leaf runqueues has an additional problem
> besides mixing up the order sometimes...
> 
> Paul? [Both of you, actually. :)]

*head still reels a little*

Right so traditional wisdom dictates not re-using entries that might
possibly still be in used. I remember us having had a lot of 'fun' with
that in kernel/smp.c..

See commit 6dc19899958e420a931274b94019e267e2396d3e and the follow ups
from Milton Miller.

Our use-case makes this hard because we need to re-insert the entry as
soon as a task wakes up again.. ho humm..

I don't think we really mind missing an entry or visiting a few twice,
as long as there's a solid termination condition for each iteration. Its
load-balancing after all, if we mess up, we'll fix up next time
round ;-)


