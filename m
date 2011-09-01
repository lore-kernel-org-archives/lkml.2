Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932654Ab1IAQT0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 12:19:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47725 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750786Ab1IAQTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 12:19:23 -0400
MIME-Version: 1.0
In-Reply-To: <4E5FA18A.7010205@gmail.com>
References: <CAHSGOutFRcXWtn9d2zwLbkQG==kwPEUZh-ZigKS5AnMN6ty2-w@mail.gmail.com>
 <20110812195220.GA29051@elte.hu> <20110814095910.GA18809@liondog.tnic>
 <6296.1313462075@turing-police.cc.vt.edu> <20110816121604.GA29251@aftab> <4E5FA18A.7010205@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 1 Sep 2011 09:18:32 -0700
Message-ID: <CA+55aFz1RRY6KcqVVZ9tBH7PDXfBwkZ1AhJcSHPABLXMkNJCOA@mail.gmail.com>
Subject: Re: x86 memcpy performance
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: Borislav Petkov <bp@amd64.org>,
        "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@elte.hu>,
        melwyn lobo <linux.melwyn@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 1, 2011 at 8:15 AM, Maarten Lankhorst
<m.b.lankhorst@gmail.com> wrote:
>
> This work intrigued me, in some cases kernel memcpy was a lot faster than sse memcpy,
> and I finally figured out why. I also extended the test to an optimized avx memcpy,
> but I think the kernel memcpy will always win in the aligned case.

"rep movs" is generally optimized in microcode on most modern Intel
CPU's for some easyish cases, and it will outperform just about
anything.

Atom is a notable exception, but if you expect performance on any
general loads from Atom, you need to get your head examined. Atom is a
disaster for anything but tuned loops.

The "easyish cases" depend on microarchitecture. They are improving,
so long-term "rep movs" is the best way regardless, but for most
current ones it's something like "source aligned to 8 bytes *and*
source and destination are equal "mod 64"".

And that's true in a lot of common situations. It's true for the page
copy, for example, and it's often true for big user "read()/write()"
calls (but "often" may not be "often enough" - high-performance
userland should strive to align read/write buffers to 64 bytes, for
example).

Many other cases of "memcpy()" are the fairly small, constant-sized
ones, where the optimal strategy tends to be "move words by hand".

                      Linus
