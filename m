Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab1DITu1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 15:50:27 -0400
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:50503 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755151Ab1DITuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 15:50:25 -0400
X-Greylist: delayed 368 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 Apr 2011 15:50:25 EDT
X-Spam-ASN: 
From: "Nikita V. Youshchenko" <nyoushchenko@mvista.com>
To: Oleg Nesterov <oleg@redhat.com>,
        Anders Ernevi <anders.ernevi@eis.semcon.com>
Subject: Re: Likely race between sys_rt_sigtimedwait() and complete_signal()
Date: Sat, 9 Apr 2011 23:44:11 +0400
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alexander Kaliadin <akaliadin@mvista.com>, oishi.y@sys.yzk.co.jp,
        linux-kernel@vger.kernel.org
References: <20110407141215.46d0b930.akpm@linux-foundation.org> <20110409134520.GA19651@redhat.com>
In-Reply-To: <20110409134520.GA19651@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201104092344.12470@blacky.localdomain>
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Oleg and all.
Thanks to looking into this.

Unfotunately I was never able to reproduce the hang in question myself. It 
was only reproducible on customers side, and required hours of running to 
happen.

I can only ask Anders [CCed] to test your fix, if possible. But I'm not 
sure it is possible now, when problem is long closed by switching to 
timerfd-based periodic execution.

Se others comments below ...

> Can't find the original email, replying to Andrew's fwd.
>
> On 04/07, Andrew Morton wrote:
> > Within project we are working on, we are facing a "rare" situation
> > when setitimer() / sigwait() - based periodic task execution hangs.
> > "Rare" means once per several hours for 1000 Hz timer.
> >
> > For hanged thread, cat /proc/pid/status shows
> >
> > ...
> > State:	S (sleeping)
> > ...
> > SigPnd:	0000000000000000
> > ShdPnd:	0000000000002000
> > SigBlk:	0000000000000000
> > ...
> >
> > and SysRq - T shows
> >
> > [<c015b1b0>] (__schedule+0x2fc/0x37c) from [<c015b7b8>]
> > (schedule+0x1c/0x30)
> > [<c015b7b8>] (schedule+0x1c/0x30) from [<c015b8c4>]
> > (schedule_timeout+0x18/0x1dc)
> > [<c015b8c4>] (schedule_timeout+0x18/0x1dc) from [<c004a084>]
> > (sys_rt_sigtimedwait+0x1b4/0x288)
> > [<c004a084>] (sys_rt_sigtimedwait+0x1b4/0x288) from [<c001cf00>]
> > (ret_fast_syscall+0x0/0x28)
>
> Is this thread the group leader?

I don't know.
Anders, could you please answer?
"Group leader" is the main thread, that entered application's main() 
function on styartup.

> > All other threads have SIGALRM blocked as they should, looking
> > through /proc/X/status proves this.
>
> Do they ever had SIGALRM unlblocked ?

As far as I understand, all threads are created, and their signal masks 
set, at application startup - and the hang happens when application is 
already long running (and executed thousands, if not millions, of 
iterations successfully).

So, unless some libc or libGL routine plays hidden games with signal masks, 
SIGALRM should not become unblocked.

> > So for some reason, SIGALRM was successfully delivered by timer, bit
> > was set in ShdPnd [I guess at the bottom of __send_signal()], but that
> > still resulted somehow in thread going to schedule() and not waking.
>
> Thanks for the detailed report.
>
> There is an old, ancient problem which I constantly forget to fix.
> It _can_ perfectly explain the hang, at least in theory. I'll try
> to make the patch on Monday.
>
> In short: if a thread T runs with SIGALRM unblocked while another
> thread sleeps in sigtimedwait(), and then T blocks SIGALRM, the
> signal can be "lost" as above.
>
> Does your application do something like this? If not, then there
> is another problem.

As I've written above, I don't think this is the case - although I can't be 
100% sure.

> > This is on embedded system running vendor 2.6.31-based kernel, moving
> > forward is unfortunately impossible because of hardware support
> > issues.
>
> If I make the patch for 2.6.31, any chance you can test it?

See above. I can't. Maybe Anders can.

> > However I guess the race we faced still exists in the current upstream
> > kernel,
>
> Yes, this is possible. OTOH, the bug can be anywhere, not necessarily in
> signal.c, and it might be already fixed.

Well, I wrote original report just because I thought results of my analysis 
could be used by kernel developers to fix probably-still-existing issue 
that is hard to reproduce.

Thanks for looking into this anyway.

Nikita
