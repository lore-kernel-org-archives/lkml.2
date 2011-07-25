Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739Ab1GYJo5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 05:44:57 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:33012 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab1GYJow convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 05:44:52 -0400
MIME-Version: 1.0
In-Reply-To: <20110725063836.GC694@elte.hu>
References: <CAObL_7GCDsfXWRJgkNk7c44GNF0JhQPAH_P0WiYHK7QUX1Bcaw@mail.gmail.com>
 <20110724211526.GA6785@elte.hu> <CAObL_7H1j1cewgWP6Jmkw_H9dZVh1kxRGgTLa+ju=ns4gYxMdA@mail.gmail.com>
 <20110725063836.GC694@elte.hu>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 25 Jul 2011 05:44:32 -0400
X-Google-Sender-Auth: cQ_SaRvyr_cwcLRlL-Lasx9x6bs
Message-ID: <CAObL_7G-afftZD7ULhbyTqBsuZCs03H-HS-n8tqRC=-Q3Bs9Eg@mail.gmail.com>
Subject: Re: [RFC] syscall calling convention, stts/clts, and xstate latency
To: Ingo Molnar <mingo@elte.hu>, Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: linux-kernel@vger.kernel.org, x86 <x86@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>, Avi Kivity <avi@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 2:38 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Andrew Lutomirski <luto@mit.edu> wrote:
>
>> On Sun, Jul 24, 2011 at 5:15 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> >
>> > * Andrew Lutomirski <luto@mit.edu> wrote:
>> >
>> >> I was trying to understand the FPU/xstate saving code, and I ran
>> >> some benchmarks with surprising results.  These are all on Sandy
>> >> Bridge i7-2600.  Please take all numbers with a grain of salt --
>> >> they're in tight-ish loops and don't really take into account
>> >> real-world cache effects.
>> >>
>> >> A clts/stts pair takes about 80 ns.  Accessing extended state from
>> >> userspace with TS set takes 239 ns.  A kernel_fpu_begin /
>> >> kernel_fpu_end pair with no userspace xstate access takes 80 ns
>> >> (presumably 79 of those 80 are the clts/stts).  (Note: The numbers
>> >> in this paragraph were measured using a hacked-up kernel and KVM.)
>> >>
>> >> With nonzero ymm state, xsave + clflush (on the first cacheline of
>> >> xstate) + xrstor takes 128 ns.  With hot cache, xsave = 24ns,
>> >> xsaveopt (with unchanged state) = 16 ns, and xrstor = 40 ns.
>> >>
>> >> With nonzero xmm state but zero ymm state, xsave+xrstor drops to 38
>> >> ns and xsaveopt saves another 5 ns.
>> >>
>> >> Zeroing the state completely with vzeroall adds 2 ns.  Not sure
>> >> what's going on.
>> >>
>> >> All of this makes me think that, at least on Sandy Bridge, lazy
>> >> xstate saving is a bad optimization -- if the cache is being nice,
>> >> save/restore is faster than twiddling the TS bit.  And the cost of
>> >> the trap when TS is set blows everything else away.
>> >
>> > Interesting. Mind cooking up a delazying patch and measure it on
>> > native as well? KVM generally makes exceptions more expensive, so the
>> > effect of lazy exceptions might be less on native.
>>
>> Using the same patch on native, I get:
>>
>> kernel_fpu_begin/kernel_fpu_end (no userspace xstate): 71.53 ns
>> stts/clts: 73 ns (clearly there's a bit of error here) userspace
>> xstate with TS set: 229 ns
>>
>> So virtualization adds only a little bit of overhead.
>
> KVM rocks.
>
>> This isn't really a delazying patch -- it's two arch_prctls, one of
>> them is kernel_fpu_begin();kernel_fpu_end().  The other is the same
>> thing in a loop.
>>
>> The other numbers were already native since I measured them
>> entirely in userspace.  They look the same after rebooting.
>
> I should have mentioned it earlier, but there's a certain amount of
> delazying patches in the tip:x86/xsave branch:
>
>  $ gll linus..x86/xsave
>  300c6120b465: x86, xsave: fix non-lazy allocation of the xsave area
>  f79018f2daa9: Merge branch 'x86/urgent' into x86/xsave
>  66beba27e8b5: x86, xsave: remove lazy allocation of xstate area
>  1039b306b1c6: x86, xsave: add kernel support for AMDs Lightweight Profiling (LWP)
>  4182a4d68bac: x86, xsave: add support for non-lazy xstates
>  324cbb83e215: x86, xsave: more cleanups
>  2efd67935eb7: x86, xsave: remove unused code
>  0c11e6f1aed1: x86, xsave: cleanup fpu/xsave signal frame setup
>  7f4f0a56a7d3: x86, xsave: rework fpu/xsave support
>  26bce4e4c56f: x86, xsave: cleanup fpu/xsave support
>
> it's not in tip:master because the LWP bits need (much) more work to
> be palatable - but we could spin them off and complete them as per
> your suggestions if they are an independent speedup on modern CPUs.

Hans, what's the status of these?  I want to do some other cleanups
(now or in a couple of weeks) that will probably conflict with your
xsave work.

--Andy
