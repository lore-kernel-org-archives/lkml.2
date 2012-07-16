Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab2GPRBM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 13:01:12 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:42989 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab2GPRBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 13:01:11 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 3.5-rc7
Date: Mon, 16 Jul 2012 19:01:06 +0200
User-Agent: KMail/1.13.7 (Linux/3.5.0-rc7-tp520-timekeeping+; KDE/4.8.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <CA+55aFxLmxGaMUbEVSaG-Og=G1rf1TBrswuVwfwWUqbCPuAVrA@mail.gmail.com> <201207161828.40586.Martin@lichtvoll.de> <CA+55aFzWEJGTRi_a1JM433_Kp5NU4nkSYEGj7+ecH7d2Mt_2kA@mail.gmail.com> (sfid-20120716_183904_912432_37D38C71)
In-Reply-To: <CA+55aFzWEJGTRi_a1JM433_Kp5NU4nkSYEGj7+ecH7d2Mt_2kA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207161901.06959.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 16. Juli 2012 schrieb Linus Torvalds:
> On Mon, Jul 16, 2012 at 9:28 AM, Martin Steigerwald 
<Martin@lichtvoll.de> wrote:
> > Regresses badly on resume from in-kernel hibernation. I.e. hangs with
> > some red graphics artifacts on the tty. The same artifacts appear
> > for a short time with rc6 + some commits as well, but there then
> > X.org is available again.
> 
> There's a one-liner fix for this bouncing around.
> 
> Appended is a white-space damaged cut-and-paste version of the fix, so
> you'll need to either find the original patch (search the kernel
> mailing list for "Excessive delay or hang during resume from system
> suspend due to a hrtimer commit"), or just edit in the one-liner by
> hand.
> 
> This should fix it (there's apparently a question on whether the
> "false" should be "true", but that's an independent detail, it's worth
> verifying in this form regardless).
> 
>                Linus
> ---
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index 269b1fe..3447cfa 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -717,6 +717,7 @@ static void timekeeping_resume(void)
>         timekeeper.clock->cycle_last =
> timekeeper.clock->read(timekeeper.clock); timekeeper.ntp_error = 0;
>         timekeeping_suspended = 0;
> +       timekeeping_update(false);
>         write_sequnlock_irqrestore(&timekeeper.lock, flags);
> 
>         touch_softlockup_watchdog();

That fixes it.

Tested three cycles.

Tested-By: Martin Steigerwald <martin@lichtvoll.de>



Compiling TuxOnIce 3.5-rc7 with that patch now to verify if that fix work 
there, too. TuxOnIce is still so much faster than in-kernel-suspend ;).


I still get:

Message from syslogd@merkaba at Jul 16 18:53:53 ...
 kernel:[   42.442466] Uhhuh. NMI received for unknown reason 3c on CPU 0.

Message from syslogd@merkaba at Jul 16 18:53:53 ...
 kernel:[   42.442470] Do you have a strange power saving mode enabled?

Message from syslogd@merkaba at Jul 16 18:53:53 ...
 kernel:[   42.442472] Dazed and confused, but trying to continue

but I keep getting these since quite some time and did not take the time 
to follow up on it.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
