Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab2ASMTO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 07:19:14 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58139 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055Ab2ASMTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 07:19:12 -0500
Date: Thu, 19 Jan 2012 13:18:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <JBeulich@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, tglx@linutronix.de,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] x86-64: fix memset() to support sizes of 4Gb and above
Message-ID: <20120119121859.GA3936@elte.hu>
References: <4F05D992020000780006AA09@nat28.tlf.novell.com>
 <20120106110519.GA32673@elte.hu>
 <4F16AFB1020000780006D671@nat28.tlf.novell.com>
 <CA+55aFxKkfKNKqt4rWanWXX3g2p0-K+=SVeAR8H-TLAXTqTZjg@mail.gmail.com>
 <4F17D8EB020000780006D943@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F17D8EB020000780006D943@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <JBeulich@suse.com> wrote:

> >>> On 18.01.12 at 19:16, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > On Wed, Jan 18, 2012 at 2:40 AM, Jan Beulich <JBeulich@suse.com> wrote:
> >>
> >>> For example the kernel's memcpy routine in slightly faster than
> >>> glibc's:
> >>
> >> This is an illusion - since the kernel's memcpy_64.S also defines a
> >> "memcpy" (not just "__memcpy"), the static linker resolves the
> >> reference from mem-memcpy.c against this one. Apparent
> >> performance differences rather point at effects like (guessing)
> >> branch prediction (using the second vs the first entry of
> >> routines[]). After fixing this, on my Westmere box glibc's is quite
> >> a bit slower than the unrolled kernel variant (4% fewer
> >> instructions, but about 15% more cycles).
> > 
> > Please don't bother doing memcpy performance analysis using 
> > hot-cache cases (or entirely cold-cache for that matter) 
> > and/or big memory copies.
> 
> I realize that - I just was asked to do this analysis, to 
> (hopefully) turn down arguments against the $subject patch.

The other problem with such repeated measurements, beyond their 
very isolated and artificially sterile nature, is what i 
mentioned: the inter-test variability is not enough to signal 
the real variance that occurs in a live system. That too can be 
deceiving.

Note that your patch is a special case which makes measurement 
easier: from the nature of your changes i expected *at most* 
some minimal micro-performance impact, not any larger access 
pattern related changes.

But Linus is right that this cannot be generalized to the 
typical patch.

So i realize all those limitations and fully agree with being 
aware of them, but compared to measuring *nothing* (which is the 
current status quo) we have to start *somewhere*.

> > The *normal* memory copy size tends to be in the 10-30 byte 
> > range, and the cache issues (both code *and* data) are 
> > unclear. Running microbenchmarks is almost always 
> > counter-productive, since it actually shows numbers for 
> > something that has absolutely *nothing* to do with the 
> > actual patterns.
> 
> This is why I added a way to do meaningful measurement on 
> small size operations (albeit still cache-hot) with perf.

We could add a test point for 10 and a 30 bytes, and the two 
corner cases: one measurement with an I$ that is trashing and a 
measurement where the D$ is trashing in a non-trivial way.

( I have used test-code before to achieve high I$ trashing: a
  function with a million NOPs. )

Once we have the typical sizes and the edge cases covered we can 
at least hope that reality is a healthy mix of all those 
"eigen-vectors".

Once we have that in place we can at least have one meaningful 
result: if a patch improves *all* these edge cases on the CPU 
models that matter, then it's typically true that it will 
improve the generic 'mixed' workload as well.

If a patch is not so clear-cut then it has to be measured with 
real loads as well, etc.

Anyway, i'll apply your current patches and play with them a 
bit.

Thanks,

	Ingo
