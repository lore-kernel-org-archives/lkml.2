Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943Ab2CJUY2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 15:24:28 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61406 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab2CJUY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 15:24:26 -0500
MIME-Version: 1.0
Date: Sat, 10 Mar 2012 20:24:25 +0000
Message-ID: <CALyZvKxQ1-5RY_7a4NiqDLuUf4cBaLTASAybUd67Z0AuJedsJw@mail.gmail.com>
Subject: after resume from suspend to disk, x86_64 CPU frequency throttling
 stops working - a known issue ?
From: Jason Vas Dias <jason.vas.dias@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi - since many kernel versions ago (I believe 2.6.38+), now running
3.1.1 (built from 'stable' GIT tree),
CPU frequency throttling once the maximum fans have been enabled does
not work after I resume
my HP 6715b x86_64 2.2GHz TL64 dual-core laptop from disk . The trip
point temperatures are :
$ cat /sys/class/thermal/thermal_zone0/trip_point_*temp | tr '\n' ' '
105000 95000 75000 65000 50000 15900

When the 95-degree thermal_zone0 trip point is exceeded, the CPU is
meant to be throttled back from 2.2Ghz to 800Khz, until the
temperature
falls below the trip point when the normal frequency is restored (with
some hystereisis delay factor) .

On boot-up from a 'pm-hibernate' suspend-to-disk on my laptop ,
however,  the 95-degree trip point is triggered,  but no CPU frequency
throttling occurs, and no  below-95-degree
trip-point is triggerred, so the CPU eventually reaches the 105 degree
trip-point and does an emergency power-off if it is heavily loaded.
Also, the system
in this state generates only one 95 degree trip-point event ;  after
the temperature falls below 95-degrees for some time (over 10mins) ,
and then I load
the machine again, so the temperature again exceeds 95-degrees, no
ACPI thermal event is raised .

This occurs with ANY available "governor" - I use "ondemand" by
default, with a 'scaling_max_freq' set to 2.0Ghz (because when I run
the CPU at 2.2Ghz , and load the machine
(with for instance  a large package 'make -j2' build) I get hardware
'system hang' issues - I've tried every available means to get the
kernel to trace / log something or boot a crash
kernel when this occurs, with no luck, so have concluded this is a
hardware issue - it did not occur when the laptop was new (it is now
nearly 4 years old) - since the machine  goes
into a state that is totally unresponsive to anything (mouse,
keyboard, networking, video,  serial, parport, USB devices all hang),
only a PCI bus analyzer will help solve this).
But I've reproduced the no-throttling-
above-95-degrees-after-suspend-from-disk problem with EVERY governor:
performance, userspace, etc.  I have the powernow-k8 CPU
 frequency scaling module built-in to the kernel.

I've resorted to hacking together an acpid driven thermal.sh shell
script that, on receipt of a 95 degree event, spawns a daemon process
that periodically monitors
the thermal_zone0 temperature and if the temp is above 95 and the freq
is above 800Khz, sets the frequency down a notch, and back to where it
was
when the temperature falls below 95 degrees.

Is this a known kernel issue ? Should I raise a bug about this ? I can
post detailed logs showing the events occurring and CPU frequency
throttling when booted up from cold,
and no frequency scaling and only one 95-degree event when booted from
suspend to disk - I wanted to check if this was a known issue first (a
bugzilla search for
'no ACPI thermal event after resume from disk' returned zarro boogs).

Comments and advice would be much appreciated,

Thanks & Regards,
Jason Vas Dias <jason.vas.dias@gmail.com>
