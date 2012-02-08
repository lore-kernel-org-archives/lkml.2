Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364Ab2BHVhZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 16:37:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50001 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755518Ab2BHVhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 16:37:23 -0500
Message-ID: <4F32EAD8.6020504@zytor.com>
Date: Wed, 08 Feb 2012 13:36:24 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, "H.J. Lu" <hjl.tools@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Richard Kuo <rkuo@codeaurora.org>, Mark Salter <msalter@redhat.com>,
        Jonas Bonn <jonas@southpole.se>, Tobias Klauser <tklauser@distanz.ch>,
        "David S. Miller" <davem@davemloft.net>,
        "H.J. Lu" <hjl.tools@gmail.com>
Subject: 64-bit time on 32-bit systems
References: <4E582577.2060805@zytor.com> <201108301409.27527.arnd@arndb.de> <4E5D1153.5030908@zytor.com> <201108311814.54906.arnd@arndb.de> <CA+55aFxfmwfB7jbbrXxa=K7VBYPfAvmu3XOkGrLbB1UFjX1+Ew@mail.gmail.com> <4E5E6AC0.60000@zytor.com> <CA+55aFzEnGb3G2WeVNoS5e2D4poY5O6gJucnVnFRF51NUYkW8A@mail.gmail.com>
In-Reply-To: <CA+55aFzEnGb3G2WeVNoS5e2D4poY5O6gJucnVnFRF51NUYkW8A@mail.gmail.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resuming a long-stuck discussion...

On 08/31/2011 10:19 AM, Linus Torvalds wrote:
> On Wed, Aug 31, 2011 at 10:09 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>>
>>> I suspect only sane solution to this (having thought about it some
>>> more) is to just say "POSIX is f*^&ing wrong".
>>
>> Urk.  Someone had the bright idea of defining tv_nsec as "long" in the
>> standard, whereas tv_usec is suseconds_t.  F**** brilliant, and more
>> than a little bit stupid.
> 
> I think tv_nsec was just overlooked, and people thought "it has no
> legacy users that were 'int', so we'll just leave it at 'long', which
> is guaranteed to be enough for nanoseconds that only needs a range of
> 32 bits".
> 
> In contrast, tv_usec probably *does* have legacy users that are "int".
> 
> So POSIX almost certainly only looked backwards, and never thought
> about users who would need to make it "long long" for compatibility
> reasons.
> 
> The fact that *every*other*related*field* in POSIX/SuS has a typedef
> exactly for these kinds of reasons just shows how stupid that "long
> tv_nsec" thing is.
> 
> I suspect that on Linux we can just say "tv_nsec" is suseconds_t too.
> Then we can make time_t and suseconds_t just match, and be "__s64" on
> all new platforms.
> 

So I somewhat accidentally stumbled onto what appears to the the reason
for this while cleaning up posix_types.h last night.

The problem at hand seems to be that suseconds_t is 32 bits on SPARC64.
 This appears to be the case in both Linux and Solaris, which is
probably why struct timespec has "long" instead of suseconds_t (Sun
always have been prominent on the POSIX committee.)

As such, I don't think we can redefine struct timespec to have
suseconds_t for the nanosecond field, even on Linux.  We could define
snseconds_t, or we would have to do something really ugly like define a
padding field when on a 32-bit platform (which the kernel would then
have to ignore when reading from userspace by truncating the 64-bit
value rather than signaling an error if the upper 32 bits are set.)

snseconds_t seems semi-reasonable to me... I guess we'd have to push
that at the POSIX people.  Fortunately it shouldn't break anything to
have it be a wider type than is otherwise necessary.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

