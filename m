Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab2KUNDq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 08:03:46 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:46549 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab2KUNDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 08:03:43 -0500
MIME-Version: 1.0
In-Reply-To: <20121119154940.GA6354@redhat.com>
References: <1351159974-980-1-git-send-email-meltedpianoman@gmail.com>
	<1353310211-3011-1-git-send-email-meltedpianoman@gmail.com>
	<20121119151050.GA4270@redhat.com>
	<CAMSQXEF9BGBVRRtuz88XFqVmPBdbWisepq4qjah3vM05_7hztw@mail.gmail.com>
	<20121119154940.GA6354@redhat.com>
Date: Wed, 21 Nov 2012 14:03:41 +0100
Message-ID: <CAMSQXEGfQE_vcvk9MvP-aJD2jeF7vU+84yx_fEn==v2Jve9w0A@mail.gmail.com>
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
> Because on a second thought I suspect this change is wrong.
>
> Just for example, please look at kauditd_thread(). It does
>
>         set_current_state(TASK_INTERRUPTIBLE);
>
>         add_wait_queue(&kauditd_wait, &wait);
>
>         if (!CONDITION)         // <-- LOAD
>                 schedule();
>
> And the last LOAD can leak into the critical section protected by
> wait_queue_head_t->lock, and it can be reordered with list_add()
> inside this critical section. In this case we can race with wake_up()
> unless it takes the same lock.
>
> Oleg.
>

I agree that I should solve my problem using the waitqueue_active()
function locally. I'll abandon this patch and fix it in the
tty_ldisc.c.

But we try to understand your fault scenario: How can the LOAD leak
into the critical section? As far as we understand the spin_unlock()
function also contains a memory barrier to prevent such a reordering
from happening.

Regards,
Ivo
