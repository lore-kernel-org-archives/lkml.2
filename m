Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab2GPQhn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 12:37:43 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62301 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483Ab2GPQhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 12:37:40 -0400
MIME-Version: 1.0
In-Reply-To: <201207161828.40586.Martin@lichtvoll.de>
References: <CA+55aFxLmxGaMUbEVSaG-Og=G1rf1TBrswuVwfwWUqbCPuAVrA@mail.gmail.com>
 <201207161828.40586.Martin@lichtvoll.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 16 Jul 2012 09:37:19 -0700
X-Google-Sender-Auth: HNK0So8QUOvr-hWzZaXU1c5pcGw
Message-ID: <CA+55aFzWEJGTRi_a1JM433_Kp5NU4nkSYEGj7+ecH7d2Mt_2kA@mail.gmail.com>
Subject: Re: Linux 3.5-rc7
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2012 at 9:28 AM, Martin Steigerwald <Martin@lichtvoll.de> wrote:
>
> Regresses badly on resume from in-kernel hibernation. I.e. hangs with some
> red graphics artifacts on the tty. The same artifacts appear for a short
> time with rc6 + some commits as well, but there then X.org is available
> again.

There's a one-liner fix for this bouncing around.

Appended is a white-space damaged cut-and-paste version of the fix, so
you'll need to either find the original patch (search the kernel
mailing list for "Excessive delay or hang during resume from system
suspend due to a hrtimer commit"), or just edit in the one-liner by
hand.

This should fix it (there's apparently a question on whether the
"false" should be "true", but that's an independent detail, it's worth
verifying in this form regardless).

               Linus
---
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 269b1fe..3447cfa 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -717,6 +717,7 @@ static void timekeeping_resume(void)
        timekeeper.clock->cycle_last = timekeeper.clock->read(timekeeper.clock);
        timekeeper.ntp_error = 0;
        timekeeping_suspended = 0;
+       timekeeping_update(false);
        write_sequnlock_irqrestore(&timekeeper.lock, flags);

        touch_softlockup_watchdog();
