Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933929Ab0EZUbQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 16:31:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14740 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755093Ab0EZUbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 16:31:13 -0400
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
In-Reply-To: Oleg Nesterov's message of  Wednesday, 26 May 2010 14:36:22 +0200 <20100526123622.GA26033@redhat.com>
References: <20100525141720.GA2253@redhat.com>
	<20100525193348.83F1549A54@magilla.sf.frob.com>
	<20100526123622.GA26033@redhat.com>
X-Zippy-Says: CHUBBY CHECKER just had a CHICKEN SANDWICH in downtown DULUTH!
Message-Id: <20100526203105.59D7849A56@magilla.sf.frob.com>
Date: Wed, 26 May 2010 13:31:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Though the high bit might be set on 32-bit, there still should not really
> > be a danger of misinterpreting a value as an error code--as long as we
> > haven't used up all 10 of those middle bits.  The test userland (glibc)
> > uses is not "long < 0" but "u_long > -4095UL".  So as long as at least
> > one bit in 0xff00 remains clear, it won't match.
> 
> Yes, libc itself is fine. But from the application's pov, personality()
> returns int, not long.

That doesn't really matter to error/success ambiguity.  Since what I said
is true, it won't ever return exactly -1 for a non-error.  But even if it
did, the application can use errno=0;personality(x);errno!=0 checking.

> > For 64-bit you want to avoid sign-extension of the old value just so it
> > looks valid (even though it won't look like an error code).  I think the
> > most sensible thing is to change the task_struct field to 'unsigned int'.
> 
> it is already 'unsigned int' ;)

Ok, then there is no bug right now, is there?

> Yes! and despite the fact it returns -EINVAL, current->personality was
> changed. This can't be right.

Agreed.

> > So, perhaps you are right about checking high
> > bits.  Then I'd make it:
> >
> > 	if ((int) personality != -1) {
> > 		if (unlikely((unsigned int) personality != personality))
> > 			return -EINVAL;
> 
> Well. Think about personality(0xffffffff - 1). It passes both checks
> and we change current->personality. Then the application calls
> personality() again, we return the old value, and since the user-space
> expects "int" it gets -2.

Yes, it never really made any sense to me that it doesn't validate any of
the flag bits.

> How about
> 
> 	if (personality != 0xffffffff) {
> 		if (personality >= 0x7fffffff)
> 			return -EINVAL;
> 		set_personality(personality);
> 	}
> 
> ? Now that personality always fits into "insigned int" we don't need
> to recheck current->personality == personality, and "< 0x7fffffff"
> gurantees that "int old_personality = personality(whatever)" in user
> space can be never misinterpeted as error.

Sure.

> As for the other oddities, they need the separate patches. Or we can
> just leave this code alone ;)

I can't see any sign that anybody cares.


Thanks,
Roland
