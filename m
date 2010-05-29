Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960Ab0E2Oaq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 10:30:46 -0400
Received: from smtp-out.google.com ([74.125.121.35]:22644 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756047Ab0E2Oap convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 10:30:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=TmTwEXaeRrto9SSqVRBfL1gD4P2cB9VqO1zZ/XSAuBFfBsQOk386MqKHDkFh96R9G
	areWGgwbUrHiJs3jxsvsA==
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1005290941060.30763-100000@netrider.rowland.org>
References: <20100529131810.5bb51bdd@schatten.dmk.lab>
	<Pine.LNX.4.44L0.1005290941060.30763-100000@netrider.rowland.org>
Date: Sat, 29 May 2010 07:30:40 -0700
Message-ID: <AANLkTimyLsldXoZ_egjybwS9kE_OcxsOuZwC0F-C2HjY@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Brian Swetland <swetland@google.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Florian Mickler <florian@mickler.org>,
       Peter Zijlstra <peterz@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 29, 2010 at 7:10 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
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
> The Android people want debugging and accountability.  So in the most
> objectionable part of this proposal, we add a new way of registering
> QoS constraints: monitored constraints.  The "monitored" implies that:
>
>        The constraint has a name, which can be used for debugging
>        and accounting;
>
>        The kernel maintains statistics on the constraint's use and
>        makes them available to userspace; and

The name/statistics could obviously be gated by CONFIG_QOS_STATS or
the like -- we'd want such a thing in our world and others may want to
enable it to debug other situations, but the default could easily
remain "no overhead".

>
>        The PM core is notified whenever the number of active monitored
>        constraints drops to 0.
>
> There is no /sys/power/policy file.  In place of opportunistic suspend,
> we have "QoS-based suspend".  This is initiated by userspace writing
> "qos" to /sys/power/state, and it is very much like suspend-to-RAM.
> However a QoS-based suspend fails immediately if there are any active
> normal QoS constraints incompatible with system suspend, in other
> words, any constraints requiring a throughput > 0 or an interrupt
> latency shorter than the time required for a suspend-to-RAM/resume
> cycle.
>
> If no such constraints are active, the QoS-based suspend blocks in an
> interruptible wait until the number of active QOS_EVENTUALLY
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

The issue with this approach is that if userspace wants to suspend
while a driver is holding a QOS_EVENTUALLY constraint, it's basically
going to spin constantly writing "qos" and failing.

Could we have write(powerstate_fd, "qos",3) block until all
QOS_EVENTUALLY constraints are lifted or the system successfully
suspends and resumes or a signal arrives?

> The idea is that receipt of a new IPC request will cause a signal to be
> sent, interrupting the sleep or the "qos" write.

Alternatively (to ipc), we could have a driver provide the same
suspendblock style interface to userspace and maps it to qos
constraints.  If it's something we maintain out-of-tree, no worries.
The kernel side api is the bit that's the headache to maintain
multiple versions of drivers with and without, after all.

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

I'm sure Arve will weigh in on this later, but from what I can see it
certainly seems like this model provides us with the functionality
we're looking for, provided the issue with
spinning-while-waiting-for-drivers-to-release-constraints is sorted
out.

Brian
