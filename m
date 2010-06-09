Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015Ab0FIRYV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 13:24:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45348 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752679Ab0FIRYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 13:24:20 -0400
Date: Wed, 9 Jun 2010 10:23:16 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: tytso@mit.edu
cc: Ingo Molnar <mingo@elte.hu>, Salman <sqazi@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, peterz@infradead.org,
       akpm@inux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       tytso@google.com, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Fix a race in pid generation that causes pids to be
 reused immediately.
In-Reply-To: <20100609171015.GE6162@thunk.org>
Message-ID: <alpine.LFD.2.00.1006091013340.4506@i5.linux-foundation.org>
References: <20100609062438.29081.91635.stgit@bumblebee1.mtv.corp.google.com> <20100609094850.GA23292@elte.hu> <alpine.LFD.2.00.1006090830560.4506@i5.linux-foundation.org> <20100609155041.GD6162@thunk.org> <alpine.LFD.2.00.1006090857530.4506@i5.linux-foundation.org>
 <20100609171015.GE6162@thunk.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 9 Jun 2010, tytso@mit.edu wrote:
> 
> This brings up a question.  If we're going to use a cmpxchg() loop, is
> there any point to doing the test-and-set game with the bitmap?

I think there very much is.

Otherwise you have three threads, two of which pick the same pid (because 
the test-and-set isn't atomic), and a third of which picks a new one. The 
cmpxchg succeeds (the third one wins, and everybody picks that winner), 
but you only expanded the map by two entries, and you're going to return 
the same pid nr to two people.

So the cmpxchg only protects "last_pid". It does _not_ in any way protect 
the pid we're actually going to return.

Or am I missing something?

			Linus
