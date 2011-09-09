Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609Ab1IIIOT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 04:14:19 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48260 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757534Ab1IIIOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 04:14:16 -0400
Date: Fri, 9 Sep 2011 10:14:07 +0200
From: Borislav Petkov <bp@alien8.de>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@amd64.org>,
        "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
        Ingo Molnar <mingo@elte.hu>, melwyn lobo <linux.melwyn@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: x86 memcpy performance
Message-ID: <20110909081407.GA29251@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Maarten Lankhorst <m.b.lankhorst@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
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
 <20110908083551.GA5646@liondog.tnic>
 <4E689FC5.8010005@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4E689FC5.8010005@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 08, 2011 at 12:58:13PM +0200, Maarten Lankhorst wrote:
> I have changed your sse memcpy to test various alignments with
> source/destination offsets instead of random, from that you can
> see that you don't really get a speedup at all. It seems to be more
> a case of 'kernel memcpy is significantly slower with some alignments',
> than 'avx memcpy is just that much faster'.
> 
> For example 3754 with src misalignment 4 and target misalignment 20
> takes 1185 units on avx memcpy, but 1480 units with kernel memcpy

Right, so the idea is to check whether with the bigger buffer sizes
(and misaligned, although this should not be that often the case in
the kernel) the SSE version would outperform a "rep movs" with ucode
optimizations not kicking in.

With your version modified back to SSE memcpy (don't have an AVX box
right now) I get on an AMD F10h:

...
16384(12/40)    4756.24         7867.74         1.654192552
16384(40/12)    5067.81         6068.71         1.197500008
16384(12/44)    4341.3          8474.96         1.952172387
16384(44/12)    4277.13         7107.64         1.661777347
16384(12/48)    4989.16         7964.54         1.596369011
16384(48/12)    4644.94         6499.5          1.399264281
...

which looks like pretty nice numbers to me. I can't say whether there
ever is 16K buffer we copy in the kernel but if there were... But <16K
buffers also show up to 1.5x speedup. So I'd say it's a uarch thing.
As I said, best it would be to put it in the kernel and run a bunch of
benchmarks...

> The modified testcase is attached, I did some optimizations in avx
> memcpy, but I fear I may be missing something, when I tried to put it
> in the kernel, it complained about sata errors I never had before,
> so I immediately went for the power button to prevent more errors,
> fortunately it only corrupted some kernel object files, and btrfs
> threw checksum errors. :)

Well, your version should do something similar to what _mmx_memcpy does:
save FPU state and not execute in IRQ context.

> All in all I think testing in userspace is safer, you might want to
> run it on an idle cpu with schedtool, with a high fifo priority, and
> set cpufreq governor to performance.

No, you need a generic system with default settings - otherwise it is
blatant benchmark lying :-)

-- 
Regards/Gruss,
    Boris.
