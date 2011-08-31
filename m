Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125Ab1HaQrn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 12:47:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40685 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932100Ab1HaQrl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 12:47:41 -0400
MIME-Version: 1.0
In-Reply-To: <201108311814.54906.arnd@arndb.de>
References: <4E582577.2060805@zytor.com> <201108301409.27527.arnd@arndb.de>
 <4E5D1153.5030908@zytor.com> <201108311814.54906.arnd@arndb.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 31 Aug 2011 09:46:39 -0700
Message-ID: <CA+55aFxfmwfB7jbbrXxa=K7VBYPfAvmu3XOkGrLbB1UFjX1+Ew@mail.gmail.com>
Subject: Re: RFD: x32 ABI system call numbers
To: Arnd Bergmann <arnd@arndb.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Richard Kuo <rkuo@codeaurora.org>, Mark Salter <msalter@redhat.com>,
        Jonas Bonn <jonas@southpole.se>, Tobias Klauser <tklauser@distanz.ch>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 31, 2011 at 9:14 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>
> * padding in struct timespec when you have a long long tv_sec and
>  32-bit long tv_nsec. This might cause kernel stack data leakage
>  in some kernel interfaces when they don't clear the padding.

I suspect only sane solution to this (having thought about it some
more) is to just say "POSIX is f*^&ing wrong".

I think everybody agrees that time_t *needs* to be 64-bit. That is
only getting more and more clear the closer we get to 2038. There may
be excuses for it for some random crappy 32-bit embedded platform that
nobody really expects to survive for many more years, but it's simply
not debatable for anything else.

And if time_t is 64-bit, then timespec and timeval practically needs
to have a 64-bit tv_usec/tv_nsec because anything else causes problems
with packing etc. And that's doubly true in a 64-bit environment with
a 32-bit "sub-environment".

POSIX has been wrong before. Sometimes the solution really is to say
"sorry, you wrote that 20 years ago, and things have changed".

> * random broken applications assuming that timespec/timeval has
>  two 'long' members, instead of using the proper header files.

Those applications are already broken.

I just googled for these kinds of issues, and found this text: "A
timeval has two components, both ints".  Does that happen to work
often? Yes. Does it make it any more correct? Hell no. But people
really used to believe that, and it even used to be true. AND THEY GOT
FIXED.

If you assume two 'long' members, you're already incorrect, because
'time_t' is not at all guaranteed to be 'long'. And if you assume that
'tv_nsec' is "long", you may be correct wrt POSIX, but given the
realities I think it's still perfectly valid to say "you're a moron,
and we need to fix it".

Because paper is what we use to wipe after we've used the toilet. At
some point, "reality" just hits a hell of a lot harder than any paper
ever will.

I really think that "x32" should try to aim *VERY* hard at using the
64-bit system calls, and seeing itself as being a "32-bit application
in a 64-bit world".  That's not just true for time_t (which I think
should be 64-bit on anything new that expects to survive for any
amount of time), but in general.

I could well imagine, for example, that you might have x32
applications that wanted to access huge datasets, and then use special
"accessor" functions for that (think "HIGHMEM.SYS" except within the
application). That really says "think of it as a 64-bit process, but
with a short pointer mode for density" to me.

                         Linus
