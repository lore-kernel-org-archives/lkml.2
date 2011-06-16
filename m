Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab1FPF7a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 01:59:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44822 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753425Ab1FPF72 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 01:59:28 -0400
MIME-Version: 1.0
In-Reply-To: <CDE289EC-7844-48E1-BB6A-6230ADAF6B7C@suse.de>
References: <47FAB15C-B113-40FD-9CE0-49566AACC0DF@suse.de> <BANLkTimubRW2Az2MmRbgV+iTB+s6UEF5-w@mail.gmail.com>
 <CDE289EC-7844-48E1-BB6A-6230ADAF6B7C@suse.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 15 Jun 2011 22:59:04 -0700
Message-ID: <BANLkTikLLfJ6yGNVcZ+o1RFmRoqRVrRSYQ@mail.gmail.com>
Subject: Re: Oops in VMA code
To: Alexander Graf <agraf@suse.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, linux-mm@kvack.org,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 10:32 PM, Alexander Graf <agraf@suse.de> wrote:
>
> 0xc000000000190580 <find_vma_prev+44>:  ld      r9,16(r9)
> 0xc000000000190584 <find_vma_prev+48>:  mr      r26,r11
> 0xc000000000190588 <find_vma_prev+52>:  cmpdi   cr7,r9,0
> 0xc00000000019058c <find_vma_prev+56>:  mr      r11,r26
> 0xc000000000190590 <find_vma_prev+60>:  beq     cr7,0xc0000000001905c4 <find_vma_prev+112>
> 0xc000000000190594 <find_vma_prev+64>:  addi    r26,r9,-56
> 0xc000000000190598 <find_vma_prev+68>:  ld      r0,16(r26)
> 0xc00000000019059c <find_vma_prev+72>:  cmpld   cr7,r31,r0
> 0xc0000000001905a0 <find_vma_prev+76>:  blt     cr7,0xc000000000190580 <find_vma_prev+44>

That's the inner loop in find_vma_prev(), and yes, it was inlined into
do_munmap.

And the fault happens in that "ld r0,16(r26)", and it looks like you
have memory corruption.

r26 has the value 0xc00090026236bbb0, and that "90" byte in the middle
there looks bogus. It's not a valid pointer any more, but if that "9"
had been a zero, it would have been.

So it looks like the rbtree has become corrupt, and it _looks_ like
it's just a couple of bits that are set in what otherwise looks like a
reasonable pointer. It *could* be a two-bit error that wasn't
corrected (I assume you have ECC or parity on your RAM or caches), so
it's theoretically possible that it's hardware, but generally memory
corruption is due to software bugs, so that's a pretty far-fetched
thing.

At a guess, there's not a lot more to be had from the oops. The
corruption probably came from some totally unrelated code. Without
more of a pattern, it's pretty much impossible to even guess.

It may be that somebody can see something I'm missing, but unless you
can find an ECC error report in your logs and say "oh, that's it", I
suspect that you're better off ignoring it, and hoping that it will
happen again (and again) so that we'd get enough of a pattern to start
making any educated guesses about what's going on.

That's why I often google oops reports - one report may not give much
of a pattern, but if google finds lots of them that all look roughly
similar, you end up possibly seeing what the common issue is.

                   Linus
