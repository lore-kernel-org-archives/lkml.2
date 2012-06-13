Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330Ab2FMFbQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 01:31:16 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40455 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab2FMFbP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 01:31:15 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1206121732230.3086@ionos>
References: <20120522032554.GA11358@gmail.com> <Pine.LNX.4.64.1206121201130.6800@axis700.grange>
 <alpine.LFD.2.02.1206121639420.3086@ionos> <CA+55aFxNy2-DnWVDUiOuF+NncRBUC=frZN+CTLsJ+o2ofXtZYQ@mail.gmail.com>
 <alpine.LFD.2.02.1206121732230.3086@ionos>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 13 Jun 2012 08:30:53 +0300
X-Google-Sender-Auth: w38GKwf1ZC85a4CLl7k14O0sWh8
Message-ID: <CA+55aFxC0436vCDwX8nUnKNa3ZZi=ZhL0w6eMk0hM3oKTz4LJw@mail.gmail.com>
Subject: Re: [GIT PULL] irq/core changes for v3.5
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 7:47 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> So now we have the choice of:
>
>   - Leaving the current check and regress 90+ drivers
>
>   - Leaving the current check and fix 90+ broken drivers
>
>   - Reverting it and end up with no protection at all
>
>   - Forcing the flag and risking the wreckage of two oddball drivers
>     _IF_ they ever show up on a PC platform.

So I'd really prefer #2.

I'd rather have a nice sane generic irq layer that really makes it an
*error* to do stupid things that make no sense, and then fix the
drivers that do them.

I would assume that fixing the drivers should be simple, and could
even be done largely by simply just grepping for the pattern of "NULL
irq-time handler without the proper markers to show that the driver
author knew what the hell they were doing".

Because I really do think that your suggested "let's work around it"
approach breaks the *wrong* driver, and does so very subtly. If you
have a buggy driver that first registers a threaded interrupt and that
silently gets turned into a IRQF_ONESHOT, and then you have the case
of a driver later coming in that would like to share the irq (but
doesn't use threading, and wants the sane shared level semantics), you
now disallow that second (non-buggy) request.

And clearly that kind of sharing cannot work, but the driver author
that looks at his (non-buggy) driver and then maybe even understands
what the problem is, and starts looking at the *buggy* driver, doesn't
actually *see* that the buggy drver uses IRQF_ONESHOT.

See what I'm trying to say? The "implicit IRQF_ONESHOT" model
basically hides a failure point in a subtle way. If we just make it a
hard requirement that drivers have to use sane models, the driver that
wants the one-shot behavior (and *depends* on it, because it doesn't
have an interrupt-time routine at all), will have to explicitly mark
itself that way, so that *other* drivers - that might be impacted by
that choice - can see it, and can see why they can't share the irq.

I relaize that the current drivers that rely on our old fast-and-loose
behavior actually *work*, and I realize that apparently there aren't
any shared irq issues in existence today, but I'd like our generic irq
code to do the RightThing(tm), and I think that implies that it is the
drivers that should be fixed, not the core irq layer that should work
around the problem.

Driver authors that see the error should be able to easily fix their
drivers, no?

                Linus
