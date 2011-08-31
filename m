Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176Ab1HaRKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 13:10:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56785 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753736Ab1HaRK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 13:10:29 -0400
Message-ID: <4E5E6AC0.60000@zytor.com>
Date: Wed, 31 Aug 2011 10:09:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Richard Kuo <rkuo@codeaurora.org>, Mark Salter <msalter@redhat.com>,
        Jonas Bonn <jonas@southpole.se>, Tobias Klauser <tklauser@distanz.ch>
Subject: Re: RFD: x32 ABI system call numbers
References: <4E582577.2060805@zytor.com> <201108301409.27527.arnd@arndb.de> <4E5D1153.5030908@zytor.com> <201108311814.54906.arnd@arndb.de> <CA+55aFxfmwfB7jbbrXxa=K7VBYPfAvmu3XOkGrLbB1UFjX1+Ew@mail.gmail.com>
In-Reply-To: <CA+55aFxfmwfB7jbbrXxa=K7VBYPfAvmu3XOkGrLbB1UFjX1+Ew@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2011 09:46 AM, Linus Torvalds wrote:
> On Wed, Aug 31, 2011 at 9:14 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>>
>> * padding in struct timespec when you have a long long tv_sec and
>>  32-bit long tv_nsec. This might cause kernel stack data leakage
>>  in some kernel interfaces when they don't clear the padding.
> 
> I suspect only sane solution to this (having thought about it some
> more) is to just say "POSIX is f*^&ing wrong".
> 

Urk.  Someone had the bright idea of defining tv_nsec as "long" in the
standard, whereas tv_usec is suseconds_t.  F**** brilliant, and more
than a little bit stupid.

Logically one could work around it by having "struct timespec" contain a
padding member in the endian-appropriate place I guess, and make sure to
clear it in the kernel, but it's rather ugly.  It might have performance
advantages to doing it that way, though.

> I really think that "x32" should try to aim *VERY* hard at using the
> 64-bit system calls, and seeing itself as being a "32-bit application
> in a 64-bit world".  That's not just true for time_t (which I think
> should be 64-bit on anything new that expects to survive for any
> amount of time), but in general.

We're trying for it.  The things we're trying to avoid is to muck (too
much) with the compat layer for the mega-multiplex system calls like
ioctl.  We can't just use the 64-bit ioctl because ioctl structures
generally contain pointers.

	-hpa

