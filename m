Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab0GLHgG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 03:36:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:49728 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754171Ab0GLHgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 03:36:04 -0400
Message-ID: <4C3AC5C4.5090505@kernel.org>
Date: Mon, 12 Jul 2010 09:35:32 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC PATCH] x86-64: software IRQ masking and handling
References: <4C3A06E3.50402@kernel.org> <AANLkTik8EHarsrnAisuj9SKbeXddlA6Dz-KzDOPsmBxh@mail.gmail.com>
In-Reply-To: <AANLkTik8EHarsrnAisuj9SKbeXddlA6Dz-KzDOPsmBxh@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 12 Jul 2010 07:35:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 07/11/2010 10:29 PM, Linus Torvalds wrote:
> You need to show some real improvement on real hardware.
> 
> I can't really care less about qemu behavior. If the emulator is bad
> at emulating cli/sti, that's a qemu problem.

Yeap, qemu is just nice when developing things like this and I
mentioned it mainly to point out how immature the patch is as it
behaves good (correctness wise) only there yet probably because qemu
doesn't use one of the fancier idle's.

> But if it actually helps on real hardware (which is possible), that
> would be interesting. However, quite frankly, I doubt you can really
> measure it on any bigger load. cli-sti do not tend to be all that
> expensive any more (on a P4 it's probably noticeable, I doubt it shows
> up very much anywhere else).

I'm not very convinced either.  Nehalems are said to be able to do
cli-sti sequences every 13 cycles or so, which sounds pretty good and
managing it asynchronously might not buy anything.  But what they said
was cli-sti bandwidth, probably meaning that if you do cli-sti's in
succession or tight loop, each iteration will take 13 cycles.  So,
there still could be cost related to instruction scheduling.

Another thing is the cost difference of cli/sti's on different
archs/machines.  This is the reason Rusty suggested it in the first
place, I think (please correct me if I'm wrong).  This means that
we're forced to assume that cli/sti's are relatively expensive when
writing generic code.  This, for example, impacts how generic percpu
access operations are defined.  Their semantic is defined as
preemption safe but not IRQ safe.  ie. IRQ handler may run in the
middle of percpu_add() although on many archs including x86 these
operations are atomic w.r.t. IRQ.  If the cost of interrupt masking
operation can be brought down to that of preemption masking across
major architectures, those restrictions can be removed.

x86 might not be the architecture which would benefit the most from
such change but it's the most widely tested architecture so I think it
would be better to have it applied on x86 if it helps a bit while not
being too invasive if this is done on multiple platforms.  (Plus, it's
the architecture I'm most familiar with :-)

It only took me a couple of days to get it working and the changes are
pretty localized, so I think it's worthwhile to see whether it
actually helps anything on x86.  I'm thinking about doing raw IOs on
SSDs which isn't too unrealistic and heavy on both IRQ masking and IRQ
handling although actual hardware access cost might just drown any
difference and workloads which are heavy on memory allocations and
such might be better fit.  If you have any better ideas on testing,
please let me know.

Thanks.

-- 
tejun
