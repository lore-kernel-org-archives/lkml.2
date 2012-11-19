Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab2KSPeI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 10:34:08 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:61241 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735Ab2KSPeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 10:34:05 -0500
MIME-Version: 1.0
In-Reply-To: <20121119151050.GA4270@redhat.com>
References: <1351159974-980-1-git-send-email-meltedpianoman@gmail.com>
	<1353310211-3011-1-git-send-email-meltedpianoman@gmail.com>
	<20121119151050.GA4270@redhat.com>
Date: Mon, 19 Nov 2012 16:34:04 +0100
Message-ID: <CAMSQXEF9BGBVRRtuz88XFqVmPBdbWisepq4qjah3vM05_7hztw@mail.gmail.com>
Subject: Re: [REPOST-v2] sched: Prevent wakeup to enter critical section needlessly
From: Ivo Sieben <meltedpianoman@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-serial@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

2012/11/19 Oleg Nesterov <oleg@redhat.com>:
>
> I am wondering if it makes sense unconditionally. A lot of callers do
>
>         if (waitqueue_active(q))
>                 wake_up(...);
>
> this patch makes the optimization above pointless and adds mb().
>
>
> But I won't argue.
>
> Oleg.
>

This patch solved an issue for me that I had with the TTY line
discipline idle handling:
Testing on a PREEMPT_RT system with TTY serial communication. Each
time the TTY line discipline is dereferenced the Idle handling wait
queue is woken up (see function put_ldisc in /drivers/tty/tty_ldisc.c)
However line discipline idle handling is not used very often so the
wait queue is empty most of the time. But still the wake_up() function
enters the critical section guarded by spin locks. This causes
additional scheduling overhead when a lower priority thread has
control of that same lock.

The /drivers/tty/tty_ldisc.c did not use the waitqueue_active() call
to check if the waitqueue was filled.... maybe I should solve this
problem the other way around: and make tty_ldisc.c first do the
waitqueue_active() call?

Regards,
Ivo
