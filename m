Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426Ab1AUQh7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 11:37:59 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55500 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754027Ab1AUQh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 11:37:58 -0500
MIME-Version: 1.0
In-Reply-To: <20110121174438.7521539f@tornado.gnet>
References: <AANLkTimajU0x1v6y3rH2+jr-bZ=tNLs1S_agXdGGAa3S@mail.gmail.com>
 <20110119083916.GA2166@elte.hu> <20110121174438.7521539f@tornado.gnet>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 21 Jan 2011 08:37:34 -0800
Message-ID: <AANLkTi=p3=MkGevrW1YU0v_V5iXLw7iLDuWeb7Rf8Xx_@mail.gmail.com>
Subject: Re: PPS parport boot lockup: INFO: HARDIRQ-READ-safe ->
 HARDIRQ-READ-unsafe lock order detected
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 6:44 AM, Alexander Gordeev
<lasaine@lvk.cs.msu.su> wrote:
>
> But parport_unregister_device should probably never be called while
> parport interrupts are enabled (in hardware). So this is a false
> positive. Is this right?

"Enabled in hardware" is immaterial - with shared interrupts, it
doesn't matter one whit whether parport interrupts are disabled on the
chip, because some other chip may be using the same interrupt line.

So you'd need to have something that guarantees that there is no
concurrent use, like actually unregistering the irq handler itself.
Things like that can work.

HOWEVER, even then I think you should see the lockdep message as a
problem. The automated toolchain is great because it shows problems
that it thinks might happen - not when they happen, but based on a
simpler theoretical model. Ignoring the error because there is some
rule in place that is hard to explain to the automated toolchain is
the wrong thing to do, because it makes the lockdep automation less
reliable.

Think of it as a compiler warning - maybe the warning doesn't actually
imply an actual bug, but you should strive to write code that doesn't
warn, because otherwise the noise from the warning you ignored will
make it harder for others to see the _real_ bugs.

                 Linus
