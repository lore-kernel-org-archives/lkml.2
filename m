Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757784Ab0FIQHp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 12:07:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59525 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757576Ab0FIQHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 12:07:43 -0400
Date: Wed, 9 Jun 2010 09:06:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: tytso@mit.edu
cc: Ingo Molnar <mingo@elte.hu>, Salman <sqazi@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, peterz@infradead.org,
       akpm@inux-foundation.org, linux-kernel@vger.kernel.org,
       tytso@google.com, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Fix a race in pid generation that causes pids to be
 reused immediately.
In-Reply-To: <20100609155041.GD6162@thunk.org>
Message-ID: <alpine.LFD.2.00.1006090857530.4506@i5.linux-foundation.org>
References: <20100609062438.29081.91635.stgit@bumblebee1.mtv.corp.google.com> <20100609094850.GA23292@elte.hu> <alpine.LFD.2.00.1006090830560.4506@i5.linux-foundation.org> <20100609155041.GD6162@thunk.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 9 Jun 2010, tytso@mit.edu wrote:
> 
> Salman had created a very nice ASCII art diagram of the race in the
> mail thread with the internal bug reporter who noticed the problem.
> We could include that, if you don't mind the commit description
> growing by 30-40 lines.  :-)

I don't horribly mind, but I also don't think it's necessarily all that 
useful to go that far. For the commit message, there are two real reasons:

 - explaining the patch itself upstream to make people like me understand 
   _why_ it needs to be applied.

   But then a denser explanation than a 30-40 line ASCII art diagram would 
   probably suffice.

 - explaning the code after-the-fact to people who end up seeing it in 
   log/blame output

   And then we don't care so much about the old bug per se, as about how 
   the code is supposed to work - so a lot of verbiage about what used to 
   happen is much less important than describing just what's going on with 
   the cmpxchg (where the "loop" is all the way from the original value 
   load, especially in this case where we don't have to loop all the way 
   back).

In fact, conceptually the cmpxchg loop is pretty much the whole function, 
it's just that if we know that any racing elements will be idempotent wrt 
anything but the final assignment of 'last_pid'. So we can end up just 
looping over the final part. I think _that_ is the clever part, and I 
think that is the part that needs explanation.

(And that is also why the diff itself doesn't include the "early part of 
the loop", and why I couldn't understand it purely as a patch - because it 
in this case the patch is "artificially small" because of how we don't 
need to loop all the way up)

> We do need to deal with pid wrap possibility just to be completely
> correct, although the chance of hitting _that_ are pretty remote.

That seems to be purely an artifact of the cleverness of avoiding re-doing 
the whole loop, no? If we _had_ re-done the whole loop (the "normal" 
cmpxchg model), we would have re-started the whole pid search and handled 
the overflow in the existing overflow handling code.

		Linus
