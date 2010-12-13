Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757105Ab0LMKyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 05:54:43 -0500
Received: from netnation.com ([204.174.223.2]:45696 "EHLO peace.netnation.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752877Ab0LMKym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 05:54:42 -0500
Date: Mon, 13 Dec 2010 02:54:40 -0800
From: Simon Kirby <sim@hostway.ca>
To: linux-kernel@vger.kernel.org
Subject: [2.6.37-rc5] Timer or ICE1724 issues, HZ=250, NO_HZ=y
Message-ID: <20101213105440.GA12768@hostway.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With Linus git HEAD just compiled earlier today, I noticed a weird issue
just now while in the middle of some coding.  I think this may have
happened before (maybe in 2.6.36), but not as obvious as this time.

The music that was playing stopped, and the key I had just pressed did
not show up in rxvt.  I figured the machine had hung, but I hit another
key and the music played again for another second and my _previous_
keystroke output appeared.

Looking at /proc/interrupts, "timer" had completely stopped.  "perf top"
showed "snd_pcm_hwsync" was at the top of the profile with about 80%
usage.  Spinning in "snd_pcm_stream_lock_irq" from other CPUs, probably..

dmesg showed:

[13995.498393] Clocksource tsc unstable (delta = -8589909196 ns)
[13995.511452] Switching to clocksource hpet
[14039.525074] NOHZ: local_softirq_pending 100
[14039.882183] hrtimer: interrupt took 30800 ns
[14134.540724] NOHZ: local_softirq_pending 100

I tried a few things:

# cd /sys/devices/system/clocksource/clocksource0
# grep . *
available_clocksource:hpet acpi_pm 
current_clocksource:hpet
# echo acpi_pm > current_clocksource

[14249.256629] Switching to clocksource acpi_pm

Still problems, so I tried again:

# echo tsc > current_clocksource

[14258.808333] Override clocksource tsc is not HRT compatible. Cannot switch while in HRT/NOHZ mode
[14258.808343] Switching to clocksource hpet

...but after this, things seemed to return to normal.  /proc/interrupts
shows "timer" increasing once again.

Full boot dmesg: http://0x.ca/sim/ref/2.6.37/oof.dmesg
.config: http://0x.ca/sim/ref/2.6.37/oof.config

Simon-
