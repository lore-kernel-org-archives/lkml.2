Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758725Ab0EYTeF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 15:34:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758533Ab0EYTeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 15:34:03 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Richard Henderson <rth@twiddle.net>, wezhang@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: Q: sys_personality() && misc oddities
In-Reply-To: Oleg Nesterov's message of  Tuesday, 25 May 2010 16:17:20 +0200 <20100525141720.GA2253@redhat.com>
References: <20100525141720.GA2253@redhat.com>
Emacs: there's a reason it comes with a built-in psychotherapist.
Message-Id: <20100525193348.83F1549A54@magilla.sf.frob.com>
Date: Tue, 25 May 2010 12:33:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't have any special insight either, just poking around as you are.

I suspect that most of the logic and code in the kernel for this just
predates 64-bit stuff, and so was written with long==int and then maybe
tweaked slightly later.

I don't think we're ever going to need or want a 64-bit personality word.
(There are still 10 bits unused in the middle for more flags.)

Though the high bit might be set on 32-bit, there still should not really
be a danger of misinterpreting a value as an error code--as long as we
haven't used up all 10 of those middle bits.  The test userland (glibc)
uses is not "long < 0" but "u_long > -4095UL".  So as long as at least
one bit in 0xff00 remains clear, it won't match.

For 64-bit you want to avoid sign-extension of the old value just so it
looks valid (even though it won't look like an error code).  I think the
most sensible thing is to change the task_struct field to 'unsigned int'.
Then:

		u_long old = current->personality;

will do what:

		u_long old = (unsigned int) current->personality;

would do now, i.e. zero-extend rather than sign-extend.

I think the 0xffffffff check is intended specifically for personality(-1)
to be a no-op that returns the old value, and nothing more.  So I'd just
make that check be "((int) personality != -1)" instead.

OTOH, this:

		set_personality(personality);
		if (current->personality != personality)
			return -EINVAL;

will then both do the job in set_personality() and return -EINVAL, when
some high bits are set.  So, perhaps you are right about checking high
bits.  Then I'd make it:

	if ((int) personality != -1) {
		if (unlikely((unsigned int) personality != personality))
			return -EINVAL;
		set_personality(personality);
		if (current->personality != personality)
			return -EINVAL;
	}

> __set_personality(). What is the point to check
> ep == current_thread_info()->exec_domain ? This buys nothing afaics.
> IOW, it could be simplified:

Agreed.

> Now let's look at the caller, sys_personality()
> 
> 	set_personality(personality);
> 	if (current->personality != personality)
> 		return -EINVAL;
> 
> but __set_personality() always sets current->personality = personality,
> what is the point to check equality?

Good point.  I suspect that at some point in the past set_personality()
would sometimes refuse to make the change.

> IOW, when we should return -EINVAL? Perhaps, lookup_exec_domain() should
> return NULL instead of default_exec_domain when the search in exec_domains
> fails? And probably we shouldn't change task->personality/exec_domain in
> this case? It is really strange that sys_personality() can return -EINVAL
> but change ->personality.

Agreed.

> But this can probably break exec. alpha does set_personality(PER_OSF4)
> but I do not see the corresponding register_exec_domain(). On the other
> hand, I do not understand why it puts PER_OSF4 into PER_MASK. PER_OSF4
> is only used by sys_osf_readv/sys_osf_writev.

No idea about that.


Thanks,
Roland
