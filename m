Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932381Ab1IHIgB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 04:36:01 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45360 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932365Ab1IHIf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 04:35:57 -0400
Date: Thu, 8 Sep 2011 10:35:51 +0200
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        Borislav Petkov <bp@amd64.org>,
        "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
        Ingo Molnar <mingo@elte.hu>, melwyn lobo <linux.melwyn@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: x86 memcpy performance
Message-ID: <20110908083551.GA5646@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Maarten Lankhorst <m.b.lankhorst@gmail.com>,
	Borislav Petkov <bp@amd64.org>,
	"Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
	Ingo Molnar <mingo@elte.hu>, melwyn lobo <linux.melwyn@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <CAHSGOutFRcXWtn9d2zwLbkQG==kwPEUZh-ZigKS5AnMN6ty2-w@mail.gmail.com>
 <20110812195220.GA29051@elte.hu>
 <20110814095910.GA18809@liondog.tnic>
 <6296.1313462075@turing-police.cc.vt.edu>
 <20110816121604.GA29251@aftab>
 <4E5FA18A.7010205@gmail.com>
 <CA+55aFz1RRY6KcqVVZ9tBH7PDXfBwkZ1AhJcSHPABLXMkNJCOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+55aFz1RRY6KcqVVZ9tBH7PDXfBwkZ1AhJcSHPABLXMkNJCOA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 01, 2011 at 09:18:32AM -0700, Linus Torvalds wrote:
> On Thu, Sep 1, 2011 at 8:15 AM, Maarten Lankhorst
> <m.b.lankhorst@gmail.com> wrote:
> >
> > This work intrigued me, in some cases kernel memcpy was a lot faster than sse memcpy,
> > and I finally figured out why. I also extended the test to an optimized avx memcpy,
> > but I think the kernel memcpy will always win in the aligned case.
> 
> "rep movs" is generally optimized in microcode on most modern Intel
> CPU's for some easyish cases, and it will outperform just about
> anything.
> 
> Atom is a notable exception, but if you expect performance on any
> general loads from Atom, you need to get your head examined. Atom is a
> disaster for anything but tuned loops.
> 
> The "easyish cases" depend on microarchitecture. They are improving,
> so long-term "rep movs" is the best way regardless, but for most
> current ones it's something like "source aligned to 8 bytes *and*
> source and destination are equal "mod 64"".
> 
> And that's true in a lot of common situations. It's true for the page
> copy, for example, and it's often true for big user "read()/write()"
> calls (but "often" may not be "often enough" - high-performance
> userland should strive to align read/write buffers to 64 bytes, for
> example).
> 
> Many other cases of "memcpy()" are the fairly small, constant-sized
> ones, where the optimal strategy tends to be "move words by hand".

Yeah,

this probably makes enabling SSE memcpy in the kernel a task
with diminishing returns. There are also the additional costs of
saving/restoring FPU context in the kernel which eat off from any SSE
speedup.

And then there's the additional I$ pressure because "rep movs" is
much smaller than all those mov[au]ps stanzas. Btw, mov[au]ps are the
smallest (two-byte) instructions I could use - in the AVX case they can
get up to 4 Bytes of length with the VEX prefix and the additional SIB,
size override, etc. fields.

Oh, and then there's copy_*_user which also does fault handling and
replacing that with a SSE version of memcpy could get quite hairy quite
fast.

Anyway, I'll try to benchmark an asm version of SSE memcpy in the kernel
when I get the time to see whether it still makes sense, at all.

Thanks.

-- 
Regards/Gruss,
    Boris.
