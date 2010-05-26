Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab0EZMiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 08:38:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9695 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753958Ab0EZMiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 08:38:11 -0400
Date: Wed, 26 May 2010 14:36:22 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Richard Henderson <rth@twiddle.net>, wezhang@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: Q: sys_personality() && misc oddities
Message-ID: <20100526123622.GA26033@redhat.com>
References: <20100525141720.GA2253@redhat.com> <20100525193348.83F1549A54@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100525193348.83F1549A54@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25, Roland McGrath wrote:
>
> I don't think we're ever going to need or want a 64-bit personality word.
> (There are still 10 bits unused in the middle for more flags.)

OK,

> Though the high bit might be set on 32-bit, there still should not really
> be a danger of misinterpreting a value as an error code--as long as we
> haven't used up all 10 of those middle bits.  The test userland (glibc)
> uses is not "long < 0" but "u_long > -4095UL".  So as long as at least
> one bit in 0xff00 remains clear, it won't match.

Yes, libc itself is fine. But from the application's pov, personality()
returns int, not long.

> For 64-bit you want to avoid sign-extension of the old value just so it
> looks valid (even though it won't look like an error code).  I think the
> most sensible thing is to change the task_struct field to 'unsigned int'.

it is already 'unsigned int' ;)

> I think the 0xffffffff check is intended specifically for personality(-1)
> to be a no-op that returns the old value, and nothing more.

I think the same.

> OTOH, this:
>
> 		set_personality(personality);
> 		if (current->personality != personality)
> 			return -EINVAL;
>
> will then both do the job in set_personality() and return -EINVAL, when
> some high bits are set.

Yes! and despite the fact it returns -EINVAL, current->personality was
changed. This can't be right.

> So, perhaps you are right about checking high
> bits.  Then I'd make it:
>
> 	if ((int) personality != -1) {
> 		if (unlikely((unsigned int) personality != personality))
> 			return -EINVAL;

Well. Think about personality(0xffffffff - 1). It passes both checks
and we change current->personality. Then the application calls
personality() again, we return the old value, and since the user-space
expects "int" it gets -2.

How about

	if (personality != 0xffffffff) {
		if (personality >= 0x7fffffff)
			return -EINVAL;
		set_personality(personality);
	}

? Now that personality always fits into "insigned int" we don't need
to recheck current->personality == personality, and "< 0x7fffffff"
gurantees that "int old_personality = personality(whatever)" in user
space can be never misinterpeted as error.

As for the other oddities, they need the separate patches. Or we can
just leave this code alone ;)

Oleg.

