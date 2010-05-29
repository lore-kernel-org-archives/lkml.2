Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818Ab0E2WNy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 18:13:54 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49373 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595Ab0E2WNw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 18:13:52 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1005290941060.30763-100000@netrider.rowland.org>
References: <20100529131810.5bb51bdd@schatten.dmk.lab>
	<Pine.LNX.4.44L0.1005290941060.30763-100000@netrider.rowland.org>
Date: Sat, 29 May 2010 15:13:51 -0700
Message-ID: <AANLkTik_4ezDAQoAQjkpEgwD9SLKeOjDzy2H7T2v6uCP@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Florian Mickler <florian@mickler.org>,
       Peter Zijlstra <peterz@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Brian Swetland <swetland@google.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 29, 2010 at 7:10 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Sat, 29 May 2010, Florian Mickler wrote:
>
>> On Sat, 29 May 2010 12:42:37 +0200
>> Peter Zijlstra <peterz@infradead.org> wrote:
>
>> > Now, all I'm interested in is providing interfaces from the kernel where
>> > needed, so that userspace can be optimally frugal with power usage, and
>> > can monitor/contain badly behaving tasks.
>> >
>>
>> I think this is a sensible approach.
>
> Here is an attempt to satisfy everyone as much as possible.  But first
> an explicit disclaimer: When I say "suspend", I mean it as in
> "suspend-to-RAM"; i.e., a forced suspend and not a cpuidle mode.
>
> In place of in-kernel suspend blockers, there will be a new type of QoS
> constraint -- call it QOS_EVENTUALLY.  It's a very weak constraint,
> compatible with all cpuidle modes in which runnable threads are allowed
> to run (which is all of them), but not compatible with suspend.
>
This sound just like another API rename. It will work, but given that
suspend blockers was the name least objectionable last time around,
I'm not sure what this would solve.

> The Android people want debugging and accountability.  So in the most
> objectionable part of this proposal, we add a new way of registering
> QoS constraints: monitored constraints.  The "monitored" implies that:
>
>        The constraint has a name, which can be used for debugging
>        and accounting;
>
>        The kernel maintains statistics on the constraint's use and
>        makes them available to userspace; and
>
>        The PM core is notified whenever the number of active monitored
>        constraints drops to 0.
>
> There is no /sys/power/policy file.  In place of opportunistic suspend,
> we have "QoS-based suspend".  This is initiated by userspace writing
> "qos" to /sys/power/state, and it is very much like suspend-to-RAM.

Why do you want to tie it to a specific state?

> However a QoS-based suspend fails immediately if there are any active

Fail or block? Your next paragraph said that it blocks for
QOS_EVENTUALLY, but if normal constraints fail, you are still stuck in
a retry loop.

> normal QoS constraints incompatible with system suspend, in other
> words, any constraints requiring a throughput > 0 or an interrupt
> latency shorter than the time required for a suspend-to-RAM/resume
> cycle.
>
> If no such constraints are active, the QoS-based suspend blocks in an
> interruptible wait until the number of active QOS_EVENTUALLY

How do you implement this?

> constraints drops to 0.  When that happens, it carries out a normal
> suspend-to-RAM -- except that it checks along the way to make sure that
> no new QoS constraints are activated while the suspend is in progress.
> If they are, the PM core backs out and fails the QoS-based suspend.
>
> Userspace suspend blockers don't exist at all, as far as the kernel is
> concerned.  In their place, the Android runs a power-manager program
> that receives IPC requests from other processes when they need to
> prevent the system from suspending or allow it to suspend.  The power
> manager's main loop looks like this:
>
>        for (;;) {
>                while (any IPC requests remain)
>                        handle them;
>                if (any processes need to prevent suspend)
>                        sleep;
>                else
>                        write "qos" to /sys/power/state;
>        }
>
> The idea is that receipt of a new IPC request will cause a signal to be
> sent, interrupting the sleep or the "qos" write.

What happen if the signal is right before (or even right after)
calling write "qos". How does the signal handler stop the write?

>
> There remains a question as to which kernel drivers should create
> monitored QOS_EVENTUALLY constraints.  Perhaps userspace could be
> allowed to specify this (I don't know how).  In any case, this is a
> relatively minor point.
>
> The advantages of this scheme are that this does everything the Android
> people need, and it does it in a way that's entirely compatible with
> pure QoS/cpuidle-based power management.  It even starts along the path
> of making suspend-to-RAM just another kind of dynamic power state.
>
> If people such as Peter still want to complain that using
> suspend-to-RAM in Android phones isn't a good way to do power
> management, that's okay -- it's the designers' decision to program
> their phones the way they want.  At least the kernel can give them the
> ability to do so in a way that doesn't compromise everybody else.
>
> Alan Stern
>
>



-- 
Arve Hjønnevåg
