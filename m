Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037Ab2ARSRP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 13:17:15 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51199 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841Ab2ARSRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 13:17:14 -0500
MIME-Version: 1.0
In-Reply-To: <4F16AFB1020000780006D671@nat28.tlf.novell.com>
References: <4F05D992020000780006AA09@nat28.tlf.novell.com>
 <20120106110519.GA32673@elte.hu> <4F16AFB1020000780006D671@nat28.tlf.novell.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 18 Jan 2012 10:16:51 -0800
X-Google-Sender-Auth: gxFpBTQmT-8SE0J3lfosYDJNUeI
Message-ID: <CA+55aFxKkfKNKqt4rWanWXX3g2p0-K+=SVeAR8H-TLAXTqTZjg@mail.gmail.com>
Subject: Re: [PATCH] x86-64: fix memset() to support sizes of 4Gb and above
To: Jan Beulich <JBeulich@suse.com>
Cc: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 2:40 AM, Jan Beulich <JBeulich@suse.com> wrote:
>
>> For example the kernel's memcpy routine in slightly faster than
>> glibc's:
>
> This is an illusion - since the kernel's memcpy_64.S also defines a
> "memcpy" (not just "__memcpy"), the static linker resolves the
> reference from mem-memcpy.c against this one. Apparent
> performance differences rather point at effects like (guessing)
> branch prediction (using the second vs the first entry of
> routines[]). After fixing this, on my Westmere box glibc's is quite
> a bit slower than the unrolled kernel variant (4% fewer
> instructions, but about 15% more cycles).

Please don't bother doing memcpy performance analysis using hot-cache
cases (or entirely cold-cache for that matter) and/or big memory
copies.

The *normal* memory copy size tends to be in the 10-30 byte range, and
the cache issues (both code *and* data) are unclear. Running
microbenchmarks is almost always counter-productive, since it actually
shows numbers for something that has absolutely *nothing* to do with
the actual patterns.

End result: people do crazy things and tune memcpy for their
benchmarks, doing things like instruction (or prefetch) scheduling
that only makes the code more complicated, and has no actual basis in
reality. And then other people are afraid to touch the end result,
even though it's shit - simply because it *looks* like it was done
with lots of actual testing and effort. Never mind that all the
testing and effort was likely crap.

                  Linus
