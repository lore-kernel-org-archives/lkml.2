Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758285Ab1IHK6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 06:58:20 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36642 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758223Ab1IHK6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 06:58:18 -0400
Message-ID: <4E689FC5.8010005@gmail.com>
Date: Thu, 08 Sep 2011 12:58:13 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@amd64.org>,
        "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
        Ingo Molnar <mingo@elte.hu>, melwyn lobo <linux.melwyn@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: x86 memcpy performance
References: <CAHSGOutFRcXWtn9d2zwLbkQG==kwPEUZh-ZigKS5AnMN6ty2-w@mail.gmail.com> <20110812195220.GA29051@elte.hu> <20110814095910.GA18809@liondog.tnic> <6296.1313462075@turing-police.cc.vt.edu> <20110816121604.GA29251@aftab> <4E5FA18A.7010205@gmail.com> <CA+55aFz1RRY6KcqVVZ9tBH7PDXfBwkZ1AhJcSHPABLXMkNJCOA@mail.gmail.com> <20110908083551.GA5646@liondog.tnic>
In-Reply-To: <20110908083551.GA5646@liondog.tnic>
Content-Type: multipart/mixed;
 boundary="------------070301090508010508020007"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070301090508010508020007
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 09/08/2011 10:35 AM, Borislav Petkov wrote:
> On Thu, Sep 01, 2011 at 09:18:32AM -0700, Linus Torvalds wrote:
>> On Thu, Sep 1, 2011 at 8:15 AM, Maarten Lankhorst
>> <m.b.lankhorst@gmail.com> wrote:
>>> This work intrigued me, in some cases kernel memcpy was a lot faster than sse memcpy,
>>> and I finally figured out why. I also extended the test to an optimized avx memcpy,
>>> but I think the kernel memcpy will always win in the aligned case.
>> "rep movs" is generally optimized in microcode on most modern Intel
>> CPU's for some easyish cases, and it will outperform just about
>> anything.
>>
>> Atom is a notable exception, but if you expect performance on any
>> general loads from Atom, you need to get your head examined. Atom is a
>> disaster for anything but tuned loops.
>>
>> The "easyish cases" depend on microarchitecture. They are improving,
>> so long-term "rep movs" is the best way regardless, but for most
>> current ones it's something like "source aligned to 8 bytes *and*
>> source and destination are equal "mod 64"".
>>
>> And that's true in a lot of common situations. It's true for the page
>> copy, for example, and it's often true for big user "read()/write()"
>> calls (but "often" may not be "often enough" - high-performance
>> userland should strive to align read/write buffers to 64 bytes, for
>> example).
>>
>> Many other cases of "memcpy()" are the fairly small, constant-sized
>> ones, where the optimal strategy tends to be "move words by hand".
> Yeah,
>
> this probably makes enabling SSE memcpy in the kernel a task
> with diminishing returns. There are also the additional costs of
> saving/restoring FPU context in the kernel which eat off from any SSE
> speedup.
>
> And then there's the additional I$ pressure because "rep movs" is
> much smaller than all those mov[au]ps stanzas. Btw, mov[au]ps are the
> smallest (two-byte) instructions I could use - in the AVX case they can
> get up to 4 Bytes of length with the VEX prefix and the additional SIB,
> size override, etc. fields.
>
> Oh, and then there's copy_*_user which also does fault handling and
> replacing that with a SSE version of memcpy could get quite hairy quite
> fast.
>
> Anyway, I'll try to benchmark an asm version of SSE memcpy in the kernel
> when I get the time to see whether it still makes sense, at all.
>
I have changed your sse memcpy to test various alignments with
source/destination offsets instead of random, from that you can
see that you don't really get a speedup at all. It seems to be more
a case of 'kernel memcpy is significantly slower with some alignments',
than 'avx memcpy is just that much faster'.

For example 3754 with src misalignment 4 and target misalignment 20
takes 1185 units on avx memcpy, but 1480 units with kernel memcpy

The modified testcase is attached, I did some optimizations in avx memcpy,
but I fear I may be missing something, when I tried to put it in the kernel, it
complained about sata errors I never had before, so I immediately went for
the power button to prevent more errors, fortunately it only corrupted some
kernel object files, and btrfs threw checksum errors. :)

All in all I think testing in userspace is safer, you might want to run it on an
idle cpu with schedtool, with a high fifo priority, and set cpufreq governor to
performance.

~Maarten

--------------070301090508010508020007
Content-Type: application/x-gzip;
 name="memcpy.tar.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="memcpy.tar.gz"

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
--------------070301090508010508020007--
