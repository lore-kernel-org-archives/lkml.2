Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab2BAXbh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 18:31:37 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39534 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab2BAXbg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 18:31:36 -0500
MIME-Version: 1.0
In-Reply-To: <CADyApD0yVOePmaLznks_h6xR_BCUjzEFUB7VtsL9vvsoHwCOVw@mail.gmail.com>
References: <20120130205444.22f5e26a@infradead.org> <20120131125232.GD4408@elte.hu>
 <20120131054155.371e8307@infradead.org> <20120131143130.GF13676@elte.hu>
 <20120131072216.1ce78e50@infradead.org> <20120131161207.GA18357@elte.hu>
 <20120131082439.575978c0@infradead.org> <20120201145544.f3a4cc64.akpm@linux-foundation.org>
 <CADyApD0yVOePmaLznks_h6xR_BCUjzEFUB7VtsL9vvsoHwCOVw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 1 Feb 2012 15:31:16 -0800
X-Google-Sender-Auth: frE2WdwRzp_o601APoKl29AwS0I
Message-ID: <CA+55aFwuGpYJ944EnZq5-DJ3dLeCu1YA5GncRQueYnDaQPVhog@mail.gmail.com>
Subject: Re: smp: Start up non-boot CPUs asynchronously
To: Arjan van de Ven <arjanvandeven@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Milton Miller <miltonm@bga.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 1, 2012 at 3:09 PM, Arjan van de Ven
<arjanvandeven@gmail.com> wrote:
>
>
> we spend slightly more than 10 milliseconds on doing the hardware level
> "send ipi, wait for the cpu to get power"  dance. This is mostly just
> hardware physics.
> we spend a bunch of time calibrating loops-per-jiffie/tsc (in 3.3-rc this is
> only done once per socket, but each time we do it, it's several dozen
> milliseconds)
> we spend 20 milliseconds on making sure the tsc is not out of sync with the
> rest of the system (we're looking at optimizing this right now)
>
> a 3.2 kernel spent on average 120 milliseconds per logical non-boot cpu on
> my laptop. 3.3-rc is better (the calibration is now cached for each physical
> cpu), but still dire

Could we drop the cpu hotplug lock earlier?

In particular, maybe we could split it up, and make it something like
the following:

 - keep the existing cpu_hotplug.lock with largely the same semantics

 - add a new *per-cpu* hotplug lock that gets taken fairly early when
the CPU comes up (before calibration), and then we can drop the global
lock. We just need to make sure that the CPU has been added to the
list of CPU's, we don't need for the CPU to have fully initialized
itself.

 - on cpu unplug, we first take the global lock, and then after that
we need to take the local lock of the CPU being brought down - so that
a "down" event cannot succeed before the previous "up" is complete.

Wouldn't something like that largely solve the problem? Sure, maybe
some of the current get_online_cpus() users would need to be taught to
wait for the percpu lock (or completion - maybe that would be better),
but most of them don't really care. They tend to want to just do
something fairly simple with a stable list of CPU's.

I dunno. Maybe it would be more painful than I think it would.

                  Linus
