Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab2JVOy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 10:54:57 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:33138 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab2JVOy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 10:54:56 -0400
MIME-Version: 1.0
In-Reply-To: <20121017170654.638e20bf.akpm@linux-foundation.org>
References: <BD54883EA7DE8B41A61B7E723561C711139F75D348@sc-vexch3.marvell.com>
	<CAE-am1NFB+opbid_f7RA_9EXUKjPCJssdOcZBrEQmQHG4EP9Gg@mail.gmail.com>
	<20121015150204.6f837a39.akpm@linux-foundation.org>
	<CAE-am1OY8Tjv6a004-NfhEe1DXTGcFC6ogVAmtVdESW8sZ_R4w@mail.gmail.com>
	<20121017170654.638e20bf.akpm@linux-foundation.org>
Date: Mon, 22 Oct 2012 22:54:54 +0800
Message-ID: <CAE-am1NxHZ2aGrcwPYxdSXwB-59bf2q9uMwS8gA=Fg9w6LVxFA@mail.gmail.com>
Subject: Re: [PATCH] panic: fix incomplete panic log in panic()
From: Qing Z <njumical@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mingo@kernel.org, ben@decadent.org.uk, markivx@codeaurora.org,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, cxie4@marvell.com,
        binw@marvell.com, wwang27@marvell.com, xjian@marvell.com,
        zhangwm@marvell.com, Qing Zhu <qzhu@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/18 Andrew Morton <akpm@linux-foundation.org>:
> On Wed, 17 Oct 2012 18:44:32 +0800
> Qing Z <njumical@gmail.com> wrote:
>
>>          In ./drivers/video/fbmem.c, codes below cause issues:
>>
>>                             case FBIOPAN_DISPLAY:
>>                       ...
>>                       console_lock();
>>                       ret = fb_pan_display(info, &var);
>>                       console_unlock();
>>                       ...
>>                       break;
>>
>> issue case 1:
>> 1. core 0 call console_lock();
>> 2. panic;
>> ...
>> 4. panic process done.
>> Result: all panic log won't be printed.
>>
>> issue case 2:
>> 1. core 0 panic;
>> 2. core 1 call console_lock();
>> 3. core 0 call smp_send_stop(), core1 stop;
>> 4. core 0 panic process done.
>> Result: only little top part of panic log will be printed.
>>
>> My soluiton according to your suggestions:
>>
>> As you said, the first priority is to get oops message reliably
>> delivered. I think we needn't care about console_sem when panic, just
>> make sure we print the log imediately, so add
>> sema_init(&console_sem,1) in bust_spinlocks(0), just like zap_locks()
>> do.  It is safer than console_unlock() or up().
>
> hm, I see.
>
>> We can't add sema_init(..) in bust_spinlocks(1) due to issue case2,
>> although the condition is rare. About issue case 2: should we avoid
>> call console_lock() when panic?
>
> Well, I think we do have infrastructure to support that:
>
> +       if (!oops_in_progress)
>                 console_lock();
>
> I haven't looked to see how practical that approach would be.
>
>
> It would be better if we were to do
>
>         if (oops_in_progress)
>                 console_trylock();
>         else
>                 console_lock();
>
> where console_trylock() would *try* to do a console_lock() but would
> bail out if it was unable to immediately take the lock.  This is better
> because most of the time, the oopsing CPU *will* lock the console and
> will prevent other code from getting into the console code and messing
> things up.
>
> A problem with this approach is that it is very hard to test - the
> "console_trylock failed" case will be rare.
>
>
> I think it would be acceptable to just skip over the console_lock() if
> oops_in_progress is set.  And if we skipped the console_lock(), we
> should also skip the console_unlock().  So something like:
>
>         bool console_unlock_needed = true;
>
>         if (unlikely(oops_in_progress))
>                 console_unlock_needed = false;
>         else
>                 console_lock();
>
>         ...
>
>         if (console_unlock_needed)
>                 console_unlock();
>
>
>> If we init console_sem in panic, old text may be flushed too, but
>> should be before panic oops message. Also we can fix it by updating
>> con_start("con_start = log_end") once panic happen, only log after
>> panic will be printed.
Hi Andrew,
          Basically, console_unlock() should be called to make panic
log printed.  Call console_unlock() in panic have some risks when
recurse in it(are there other bad cases?). The condition is very rare
and the two issue cases I list always happen between console_lock()
and console_unlock(). So I think we need to couple with
console_lock(), but should avoid the case that panic happen in
console_unlock().  I think it is a more modest and safe way.  Please
corect me if there is something wrong. Thanks!

bool Is_in_console_unlock;
void console_unlock(void)
{
       ...
+      Is_in_console_unlock = ture;
        /* flush buffered message fragment immediately to console */
        console_cont_flush(text, sizeof(text));
again:
        for (;;) {
        ....
 +       Is_in_console_unlock = false;
}

void panic(const char *fmt, ...)
{
        ....
+      /*
+       * we should unlock console here to make oops log printed, in case
+       * console is locked before panic in this cpu, or other cpus lock the
+       * console before be stopped.
+       */
+      if( unlikely(console_locked) && !Is_in_console_unlock )
+           {
+                  console_unlock();
+                  console_locked = 0;
+            }

        /*
         * Note smp_send_stop is the usual smp shutdown function, which
         * unfortunately means it may not be hardened to work in a panic
         * situation.
         */
        smp_send_stop();

        ....
}
