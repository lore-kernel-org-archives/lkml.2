Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab0GLFTA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 01:19:00 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52039 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab0GLFS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 01:18:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=N5oevVdd/mx5JcluY9gdz4/KsbGDE6+F/Y0OXXYKgbS7OucHyIi8jw9XTjOapYdCpb
         sWg8oOtRq2KrsdDsd9d2vbnZ29sW4afokLfHf3ElFMes49uelZdCvmeTT3KifFGwRbUy
         WzK5jg6E96a58vip+UpWvVzGc/yfb2J1XoM8w=
Subject: Re: [RFC PATCH] x86-64: software IRQ masking and handling
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <AANLkTim5a4OxT518REsmNow-wo3T2qdkUORv876Adcqj@mail.gmail.com>
References: <4C3A06E3.50402@kernel.org>
	 <AANLkTik8EHarsrnAisuj9SKbeXddlA6Dz-KzDOPsmBxh@mail.gmail.com>
	 <1278885797.6740.18.camel@localhost>
	 <AANLkTim5a4OxT518REsmNow-wo3T2qdkUORv876Adcqj@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Jul 2010 07:11:33 +0200
Message-ID: <1278911493.2538.204.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 11 juillet 2010 à 18:18 -0700, Linus Torvalds a écrit :
> On Sun, Jul 11, 2010 at 3:03 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > I have seen some hits with cli-sti. I was considering swapping all
> > preempt_disable() with local_irq_save() in ftrace, but hackbench showed
> > a 30% performance degradation when I did that.
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
> 

Some kernel dev incorrectly assume they own cpu caches...

This discussion reminds me I noticed a performance problem with
placement of cpu_online_bits and cpu_online_mask on separate sections
(and thus separate cache lines) and a network load.

static DECLARE_BITMAP(cpu_online_bits, CONFIG_NR_CPUS) __read_mostly;
const struct cpumask *const cpu_online_mask = to_cpumask(cpu_online_bits);

Two changes are possible :

1) Get rid of the cpu_online_mask (its a const pointer to a known
target). I cant see a reason for its need it actually...

2) Dont use a the last const qualifier but __read_mostly to move
cpu_online_mask on same section.

Rusty, could you comment on one or other way before I submit a patch ?

(Of course, possible/present/active have same problem)


