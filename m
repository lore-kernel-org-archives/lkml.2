Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522Ab0FIPj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 11:39:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34413 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751131Ab0FIPjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 11:39:55 -0400
Date: Wed, 9 Jun 2010 08:39:00 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Salman <sqazi@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       peterz@infradead.org, akpm@inux-foundation.org,
       linux-kernel@vger.kernel.org, tytso@google.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Fix a race in pid generation that causes pids to be
 reused immediately.
In-Reply-To: <20100609094850.GA23292@elte.hu>
Message-ID: <alpine.LFD.2.00.1006090830560.4506@i5.linux-foundation.org>
References: <20100609062438.29081.91635.stgit@bumblebee1.mtv.corp.google.com> <20100609094850.GA23292@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 9 Jun 2010, Ingo Molnar wrote:

> 
> * Salman <sqazi@google.com> wrote:
> > 
> > A program that repeatedly forks and waits is susceptible to having the
> > same pid repeated, especially when it competes with another instance of the
> > same program.  This is really bad for bash implementation.  Furthermore, many shell
> > scripts assume that pid numbers will not be used for some length of time.
> > 
> > Thanks to Ted Tso for the key ideas of this implementation.
> 
> Looks rather interesting. (Cleanliness-wise i'd suggest to split out the while 
> loop into a helper function.)

I have to say that usually I can look at a patch and see what it does.

This time I had absolutely no clue.

There was a whole big context missing: that original load of "last_pid" 
into "last" at the top of the function, far outside the patch.  And in 
this case I don't think splitting out the trivial cmpxchg() loop would 
help that problem - that would just make the "load original" part of the 
big picture be even further away from the final "replace if same" part, 
and I think _that_ is a much more critical part of the subtleties there.

So I had to read the patch _and_ go read the code it patched, in order to 
at all understand what it did. I think the patch explanation should have 
done it, and I also think this would need a bit comment at the top.

[ In fact, I'd argue that the _old_ code would have needed a big comment 
  at the top about last_pid usage, but i somebody had done that, they'd 
  probably also have seen the race while explaning how the code worked ;]

So having looked at the patch and the code, I agree with the patch, but 
I'd like some more explanation to go with it.

[ Or Ted's version: as mentioned, I don't think the complexity is actually 
  in the final cmpxchg loop itself, but in the bigger picture, so I don't 
  think the differences between Ted's and Salman's versions are that big ]

			Linus
