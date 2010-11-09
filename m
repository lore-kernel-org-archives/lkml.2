Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab0KINq7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 08:46:59 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:53590 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab0KINq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 08:46:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:from:date:x-google-sender-auth:message-id
         :subject:to:content-type;
        b=o6dSmYZf5X9qFGghEIoZ8jHnNsB/xDSKeo8Onx3az1VRZuxbJwS6F4CRW6GpUsGxth
         ntryHG9QD0/9kWtLl3qyGsjMkshgbH3Q92lQM6BbpKgmkhAydsh9iFKeNFcOz1lGFCSa
         NE6jONrR1HbNMUS9tt+GHM/2zzdJ/+BRgmupY=
MIME-Version: 1.0
From: Andrew Lutomirski <luto@mit.edu>
Date: Tue, 9 Nov 2010 08:46:36 -0500
X-Google-Sender-Auth: lmIkyrr2o15D9YZg1EbJQaylkdY
Message-ID: <AANLkTikA6hZDV0A30fku7VT7Z1P8OqxcsF-EK95pBdD=@mail.gmail.com>
Subject: HPET (?) related hangs and breakage in 2.6.35,36
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all-

I have a problem, possibly HPET related, that's gotten a lot worse in
2.6.35 and later.  It is present in the latest Fedora 14 kernel
(2.6.35-blahblahblah) and in kernel.org's 2.6.36.

After several minutes of uptime, my system freezes in a strange way.
All of userspace and some kernel services freeze hard (no mouse, no
typing, etc.)  Caps-lock works intermittently, as does (I think)
pinging.  The only debug output I've been able to get is this (typed
from a blurry photo because netconsole dies along with everything
else):

[ 5478.244722] Clocksource tsc unstable (delta = 101399051316 ns)
[ 5478.367958] Switching to clocksource hpet
[ 5543.729698] BUG: soft lockup - CPU #1 stuck for 61s! [migration/1:6]
[ 5543.729743] Modules linked in: [...]

At this point, even SysRq only works some of the time (it'll work for
a few seconds then die for awhile).  Banging on the keyboard doesn't
appear to help, and I'd expect it to if all that was wrong was that I
was losing wakeups.

IIRC I got the tsc unstable messages on older kernels with similarly
insanely large deltas but the system kept working.

Booting with hpet=disable not only makes the system stable but
prevents the clocksource tsc unstable message.  ntpd doesn't seem to
complain about my clock, either (and on a different machine with a (I
think) particularly crappy onboard clock, ntpd complains loudly, so I
assume that ntpd would tell me if my clock didn't work right).

CPU is Intel Xeon W5320 at 2.67GHz and /proc/cpuinfo says tsc, rdtscp,
constant_tsc, nonstop_tsc, so the TSC should be good.
Motherboard is Asus P6T WS PRO rev 1.xx running a BIOS from 02/26/2009
(version 0603).

My guess is that my hpet (or its driver) is broken enough to bring
down userspace and that the kernel incorrectly trusts the hpet more
than the TSC.

--Andy
