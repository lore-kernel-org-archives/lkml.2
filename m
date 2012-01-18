Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab2ARLOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 06:14:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35422 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758Ab2ARLOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 06:14:20 -0500
Date: Wed, 18 Jan 2012 12:14:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <JBeulich@suse.com>
Cc: tglx@linutronix.de, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] x86-64: fix memset() to support sizes of 4Gb and above
Message-ID: <20120118111404.GA12152@elte.hu>
References: <4F05D992020000780006AA09@nat28.tlf.novell.com>
 <20120106110519.GA32673@elte.hu>
 <4F16AFB1020000780006D671@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F16AFB1020000780006D671@nat28.tlf.novell.com>
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

> >>> On 06.01.12 at 12:05, Ingo Molnar <mingo@elte.hu> wrote:
> >> * Jan Beulich <JBeulich@suse.com> wrote:
> > Would be nice to add support for arch/x86/lib/memset_64.S as 
> > well, and look at the before/after performance of it.
> 
> Got this done, will post the patch soon. However, ...
> 
> > For example the kernel's memcpy routine in slightly faster than 
> > glibc's:
> 
> This is an illusion [...]

Oh ...

> [...] - since the kernel's memcpy_64.S also defines a "memcpy" 
> (not just "__memcpy"), the static linker resolves the 
> reference from mem-memcpy.c against this one. Apparent 
> performance differences rather point at effects like 
> (guessing) branch prediction (using the second vs the first 
> entry of routines[]). After fixing this, on my Westmere box 
> glibc's is quite a bit slower than the unrolled kernel variant 
> (4% fewer instructions, but about 15% more cycles).

Cool and thanks for looking into this. Will wait for your 
patch(es).

> > If such measurements all suggests equal or better 
> > performance, and if there's no erratum in current CPUs that 
> > would make 4G string copies dangerous [which your research 
> > suggests should be fine], i have no principal objection 
> > against this patch.
> 
> If I interpreted things correctly, there's a tiny win with the 
> changes (also for not-yet-posted memcpy equivalent):

Nice. That would be the expectation from the reduction in the 
instruction count. Seems to be slighly above the noise threshold 
of the measurement.

Note that sometimes there's variance between different perf 
bench runs larger than the reported standard deviation. This can 
be seen from the three repeated --repeat 1000 runs you did.

I believe this effect is due to memory layout artifacts - found 
no good way so far to move that kind of variance inside the perf 
stat --repeat runs.

Maybe we could allocate a random amount of memory in user-space, 
in the [0..1MB] range, before doing a repeat run (and freeing it 
after an iteration), and perhaps dup() stdout randomly, to fuzz 
the kmalloc and page allocation layout patterns?

Thanks,

	Ingo
