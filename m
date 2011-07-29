Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574Ab1G2Ilj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 04:41:39 -0400
Received: from mail.cs.tu-berlin.de ([130.149.17.13]:37003 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034Ab1G2Ili (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 04:41:38 -0400
Message-ID: <4E327232.204@cs.tu-berlin.de>
Date: Fri, 29 Jul 2011 10:41:22 +0200
From: =?UTF-8?B?SmFuIFNjaMO2bmhlcnI=?= <schnhrr@cs.tu-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110711 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFCv2 2/8] rcu: More rcu-variants for list manipulation
References: <1311793825-31933-1-git-send-email-schnhrr@cs.tu-berlin.de> <1311793825-31933-3-git-send-email-schnhrr@cs.tu-berlin.de>
In-Reply-To: <1311793825-31933-3-git-send-email-schnhrr@cs.tu-berlin.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 27.07.2011 21:10, schrieb Jan H. Schönherr:
>  /**
> + * list_add_tail_nobackref - add element to list without setting up
> + *			     back references
> + * @new: element to add
> + * @head: list to add the element to
> + *
> + * @new is appended to @head.
> + *
> + * In contrast to list_add_tail(), this function does not maintain the
> + * references back to @head. So, neither @new->next will be changed, nor
> + * -- in case @new becomes the first entry of @head -- @new->pref.
> + *
> + * This is useful when reorganizing deleted elements of a RCU-protected
> + * list as concurrent readers must always find their way back to the list.
> + * When used in this context, special care must be taken in order to not
> + * disturb concurrent readers on @head (or @new):
> + * a) @new->next must lead back to the list
> + * b) @new->next must not lead to any node already on @head
> + * c) @new must be already known to existing readers on @head

This might actually race with physical deletion. Consider a list:

   HEAD --> A --> B --> C --> D --> HEAD

1. Remove C from list, then D:

   HEAD --> A --> B --------------> HEAD
                        C --> D ----^

2. Attempt to physically delete D by using call_rcu() or similar.
   This is delayed until all already running readers have finished.

3. Let a new reader begin to traverse the list, advancing until A.

4. Remove A.

   HEAD --------> B --------------> HEAD
            A ----^      C --> D ----^

5. Call list_add_tail_nobackref() for A, then C.

   HEAD --------> B --------------> HEAD
   LIST --> A ---------> C --> D ----^

6. Finish step 2, really deleting D.

7. Let the new reader continue its traversal.

This reader will hit D, which is obviously bad.


I think, we can avoid this by modifying the next pointers
of the deleted elements and letting them point to HEAD.
That is:

5a. Call list_add_tail_nobackref() for A.

   HEAD --------> B --------------> HEAD
                        C --> D ----^
   LIST --> A -----------------------^

5b. Call list_add_tail_nobackref() for C.

   HEAD --------> B --------------> HEAD
                              D ----^
   LIST --> A --------> C -----------^



However, this (and also the previous version) might
cause readers to skip elements that are on the list
(B in the example above). Can we tolerate that?

My current guess would be: no.

Thinking more about that, we already have that case:


   HEAD --> A --> B --> C --> HEAD

1. Let a reader traverse until A.

2. Remove A.

   HEAD --------> B --> C --> HEAD
            A ----^

3. Add A after B.

   HEAD --------> B     C --> HEAD
                  +> A -^

4. Let reader continue traversal, skipping B.

(Similarly, if we had removed C and re-added it between A and B,
we could have traversed B twice.)

So either the presented solution in this patch series
is valid, or -- when we are not allowed to re-add
elements which might still have readers -- the current
handling of CFS leaf runqueues has an additional problem
besides mixing up the order sometimes...

Paul? [Both of you, actually. :)]

Regards
Jan
