Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab0DEPBj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 11:01:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37838 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755006Ab0DEPBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 11:01:33 -0400
Date: Mon, 5 Apr 2010 07:56:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
cc: Jason Wessel <jason.wessel@windriver.com>,
       Will Deacon <will.deacon@arm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kgdb-bugreport@lists.sourceforge.net, linux-arm@vger.kernel.org,
       Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH 4/5] kgdb: Use atomic operators which use barriers
In-Reply-To: <20100405092126.GA1419@ucw.cz>
Message-ID: <alpine.LFD.2.00.1004050751500.8323@i5.linux-foundation.org>
References: <1270233145-29335-1-git-send-email-jason.wessel@windriver.com> <1270233145-29335-2-git-send-email-jason.wessel@windriver.com> <1270233145-29335-3-git-send-email-jason.wessel@windriver.com> <1270233145-29335-4-git-send-email-jason.wessel@windriver.com>
 <1270233145-29335-5-git-send-email-jason.wessel@windriver.com> <alpine.LFD.2.00.1004021205080.3634@i5.linux-foundation.org> <4BB64762.6040806@windriver.com> <alpine.LFD.2.00.1004021238270.3634@i5.linux-foundation.org> <20100405092126.GA1419@ucw.cz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 Apr 2010, Pavel Machek wrote:
> 
> And this is valid (but ugly and not optimal) kernel code:
> 
>  	kernel/sched.c-		while (task_is_waking(p))
>  	kernel/sched.c:			asm volatile("" :: "memory");

No. We would consider such code buggy.

That said, you're right that such code would exist. But if it were to 
exist and cause lock-ups, at least I would consider it a simple and 
outright bug, and that the proper fix would be to just replace the asm 
with cpu_relax().

> ...so I don't think inserting smp_mb() into cpu_relax() and udelay()
> and similar can ever fix the problem fully.

See above. 

> Run smp_mb() from periodic interrupt?

Doesn't help - it's quite valid to do things like this in irq-disabled 
code, although it is hopefully very very rare.

In particular, I suspect the kgdb use _is_ interrupts disabled, and is why 
the ARM people even noticed (the normal cases would break out of the loop 
exactly because an interrupt occurred, and an interrupt is probably 
already enough to make the issue go away).

And please do not confuse this with smp_mb() - this is not about the Linux 
notion of a memory barrier, this is about whatever per-arch oddity that 
makes changes not be noticed (ie caches may be _coherent_, but they are 
not "timely").

			Linus
