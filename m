Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184Ab2F0GJp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 02:09:45 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:48146 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab2F0GJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 02:09:44 -0400
Date: Wed, 27 Jun 2012 08:09:39 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Kay Sievers <kay@vrfy.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: cosmetic printk() issue with lockdep warning in
 arch/x86/kernel/alternative.c
Message-ID: <20120627060939.GD14913@gmail.com>
References: <CAPXgP124qFG=QdO4H7qsp1bhY4BOp-PJEz7-4v-Dhi13LW+GDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPXgP124qFG=QdO4H7qsp1bhY4BOp-PJEz7-4v-Dhi13LW+GDQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Cc:-ed a more interested folks and lkml, as this really matters 
to more people than just me)

* Kay Sievers <kay@vrfy.org> wrote:

> mind moving "fixing up alternatives" in:
>   arch/x86/kernel/alternative.c:431
> down to where really happens something, or whatever other solution
> fits, maybe it can be removed today ...
> 
> The CPU code in:
>   arch/x86/kernel/smpboot.c:654
> tries to print continuation lines, which look weird with the
> prefix-less lockdep warning that gets merged into the former line when
> lockdep is enabled:
> 
> [    0.053070] lockdep: fixing up alternatives.
> [    0.054003] Booting Node   0, Processors  #1lockdep: fixing up alternatives.
> [    0.128995]  #2lockdep: fixing up alternatives.
> [    0.203985]  #3lockdep: fixing up alternatives.
> [    0.278972]  #4lockdep: fixing up alternatives.
> [    0.353960]  #5lockdep: fixing up alternatives.
> [    0.427948]  #6lockdep: fixing up alternatives.
> [    0.501937]  #7 Ok.
> [    0.575952] Brought up 8 CPUs

We could certainly change the lockdep printouts - but I'm really 
not sure it's wise to fight those kinds of printk() usage 
patterns:

Piecemail wise printouts are handy and natural as they follow 
actual code flow. As the code progresses so do the continued 
printk()s get progressed. We use single-line printouts to not 
use up too much screen real estate during bootup.

So ... why not do what I suggested very, very early on: don't 
touch printk screen output itself *AT ALL* - keep it simple and 
direct, don't add complexity to the pathway of kernel code 
trying to communicate a kernel bug to the user.

Instead solve your needs by simply tracing printk() calls and 
the resulting strings [with a string event - I think Steve 
posted an RFC patch for that early on - apply that patch and 
recover the events - we could build-in this portion of tracing 
whenever CONFIG_PRINTK is enabled to make sure the facility is 
always available] and reconstruct the lines and the full 
ASCII-string events in user-space: if PID,CPU is traced and 
there's one record per printk() call then it's *trivial* to 
reconstruct 99.9% of the printk lines in the user-space code 
that receives the trace events.

Keep /proc/kmsg and don't change it much - but trace printk() 
calls form your new systemd code. WHY don't you use that 
approach? It's actually totally sensible, useful, it keeps the 
printk status quo in place, improves other usecases and can be 
done using existing facilities...

Thanks,

	Ingo
