Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407Ab0GLHmH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 03:42:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:38125 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628Ab0GLHmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 03:42:04 -0400
Message-ID: <4C3AC735.80806@kernel.org>
Date: Mon, 12 Jul 2010 09:41:41 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC PATCH] x86-64: software IRQ masking and handling
References: <4C3A06E3.50402@kernel.org>	<AANLkTik8EHarsrnAisuj9SKbeXddlA6Dz-KzDOPsmBxh@mail.gmail.com>	<1278885797.6740.18.camel@localhost> <AANLkTim5a4OxT518REsmNow-wo3T2qdkUORv876Adcqj@mail.gmail.com>
In-Reply-To: <AANLkTim5a4OxT518REsmNow-wo3T2qdkUORv876Adcqj@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 12 Jul 2010 07:41:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 07/12/2010 03:18 AM, Linus Torvalds wrote:
> On Sun, Jul 11, 2010 at 3:03 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>>
>> I have seen some hits with cli-sti. I was considering swapping all
>> preempt_disable() with local_irq_save() in ftrace, but hackbench showed
>> a 30% performance degradation when I did that.
> 
> Yeah, but in that case you almost certainly keep the per-cpu cacheline
> hot in the D$ L1 cache, and the stack tracer is presumably also not
> taking any extra I$ L1 misses. So you're not seeing any of the
> downsides. The upside of plain cli/sti is that they're small, and have
> no D$ footprint.
> 
> And it's possible that the interrupt flag - at least if/when
> positioned right - wouldn't have any additional D$ footprint under
> normal load either. IOW, if there is an existing per-cpu cacheline
> that is effectively always already dirty and in the cache,
> But that's something that really needs macro-benchmarks - exactly
> because microbenchmarks don't show those effects since they are always
> basically hot-cache.

I think I can pack everything into the space irq_count occupies now.
16 bit for pending, and a byte for enable and count each.

> Also, the preempt code is pretty optimized and uses "add". Tejun uses
> "btrl" at least in some places, which is generally not a fast
> instruction.  So there's a few caveats there too. Which is why I'd
> want numbers.

That can be replaced with bt + mov.  I wasn't sure which would be
cheaper tho.

Thanks.

-- 
tejun
