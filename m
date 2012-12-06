Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab2LFGK7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 01:10:59 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:48337 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845Ab2LFGK5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 01:10:57 -0500
MIME-Version: 1.0
X-Originating-IP: [71.232.234.122]
In-Reply-To: <DAE2ECFDBE54434BA3014E0CC0F2A1E877000F52@G4W3211.americas.hpqcorp.net>
References: <DAE2ECFDBE54434BA3014E0CC0F2A1E87700075B@G4W3211.americas.hpqcorp.net>
 <alpine.LFD.2.02.1211221120580.2701@ionos> <alpine.LFD.2.02.1211231008060.2701@ionos>
 <DAE2ECFDBE54434BA3014E0CC0F2A1E877000F52@G4W3211.americas.hpqcorp.net>
From: Edward Donovan <edward.donovan@numble.net>
Date: Thu, 6 Dec 2012 01:10:36 -0500
X-Google-Sender-Auth: lcuzuGEs1BJ5fRnLAp15LtXAm24
Message-ID: <CADdbW+F0aO3Y1F+-Ywksmfy5J5xmRc+euwEO9B2frA=EfrRfGg@mail.gmail.com>
Subject: Re: need help on a DEADLOCK problem related to function try_one_irq()
To: "Wang, Warner" <warner.wang@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "Wang, Song-Bo (Stoney)" <song-bo.wang@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thomas, Stoney, Warner -

Thanks for your patience. :)   The patch from Thomas works here, too.

I can add that when I made the patch that became 52553ddffad76cc, I
didn't understand why we needed to run the handler again, in that
test:

   (action->handler(irq, action->dev_id) == IRQ_HANDLED)

But without it, irqfixup and irqpoll weren't working.  And I can't
pretend I have a clear idea of what all this code should like, anyway,
myself.  I and others had bisected the breaking of irqpoll/fixup to
commit fa27271bc8d.  I was testing the parts of that small patch, like
puzzle pieces.  That was one the one that worked for me and everyone
else, until now.  I thought we might have a discussion about it, but
that didn't happen.  The first time I submitted it, I hadn't heard
back.  Then another user bugged Linus about the regression.  I piped
up that I had submitted a patch.  Users tested it successfully, and it
went in.

So, let me try to confirm some things now, so I can learn as I go.  To
spell out what's in the new patch:

The later line,

  action = desc->action;

should have been this all along?

  action = action->next;

And with that fixed, the other test can go.  Which is good, now,
because it was creating locking problems for you.

Ok, thanks for bearing with me.   I'll repeat the test here, some
more, but they've generally behaved consistently and probably will
keep showing the same.

I might as well add that I would happily ship one of these computers,
with a reliably spurious interrupt, to Thomas in Germany. if that
would help for testing.

Thanks all -

Ed



On Mon, Nov 26, 2012 at 3:09 AM, Wang, Warner <warner.wang@hp.com> wrote:
> Hi Thomas and Edward,
>
> This patch works fine for our problems, but I'm not sure if it works for the recent submit "genirq: fix regression in irqfixup, irqpoll" "52553ddffad76ccf192d4dd9ce88d5818f57f62a", which submitted by Edward Donovan.
>
> Edward can you help verify it on your environment?
>
>
> Thanks,
> -Warner
>
> -----Original Message-----
> From: Thomas Gleixner [mailto:tglx@linutronix.de]
> Sent: 2012年11月23日 PM 5:09
> To: Wang, Warner
> Cc: Wang, Song-Bo (Stoney)
> Subject: Re: need help on a DEADLOCK problem related to function try_one_irq()
>
> On Thu, 22 Nov 2012, Thomas Gleixner wrote:
>
>> Warner,
>>
>> On Thu, 22 Nov 2012, Wang, Warner wrote:
>>
>> please send such bug reports to the kernel mailinglist in the future.
>>
>> > We met a problem on some of our x86 server and after a few weeks
>> > trace-down effort, we believe the problem is in the file
>> > "linux/kernel/irq/spurious.c".  We created a patch but we are not
>> > 100% sure if it is correct or complete.  That is why we want to
>> > consult you.
>>
>> You spotted the problem right, but I'm not sure at the first glance,
>> whether this is correct. I need to go back into history and figure out
>> why we added that call in the first place. It looks fundamentally
>> wrong.
>>
>> Thanks for analyzing it. I'll keep you posted on my findings.
>
> Can you try the patch below ?
>
> Thanks,
>
>         tglx
>
> ---
>  kernel/irq/spurious.c |    8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>
> Index: tip/kernel/irq/spurious.c
> ===================================================================
> --- tip.orig/kernel/irq/spurious.c
> +++ tip/kernel/irq/spurious.c
> @@ -80,13 +80,11 @@ static int try_one_irq(int irq, struct i
>
>         /*
>          * All handlers must agree on IRQF_SHARED, so we test just the
> -        * first. Check for action->next as well.
> +        * first.
>          */
>         action = desc->action;
>         if (!action || !(action->flags & IRQF_SHARED) ||
> -           (action->flags & __IRQF_TIMER) ||
> -           (action->handler(irq, action->dev_id) == IRQ_HANDLED) ||
> -           !action->next)
> +           (action->flags & __IRQF_TIMER))
>                 goto out;
>
>         /* Already running on another processor */ @@ -104,7 +102,7 @@ static int try_one_irq(int irq, struct i
>         do {
>                 if (handle_irq_event(desc) == IRQ_HANDLED)
>                         ret = IRQ_HANDLED;
> -               action = desc->action;
> +               action = action->next;
>         } while ((desc->istate & IRQS_PENDING) && action);
>         desc->istate &= ~IRQS_POLL_INPROGRESS;
>  out:
