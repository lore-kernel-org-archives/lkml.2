Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552Ab2LSVpD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 16:45:03 -0500
Received: from canardo.mork.no ([148.122.252.1]:38235 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009Ab2LSVo6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 16:44:58 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Don Zickus <dzickus@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Norbert Warmuth <nwarmuth@t-online.de>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RESEND][PATCH v3] watchdog: Fix disable/enable regression
Organization: m
References: <87y5h1c70y.fsf@nemi.mork.no>
	<1355946691-7969-1-git-send-email-bjorn@mork.no>
	<20121219201336.GK88797@redhat.com> <874njh7nd5.fsf@nemi.mork.no>
Date: Wed, 19 Dec 2012 22:44:44 +0100
In-Reply-To: <874njh7nd5.fsf@nemi.mork.no> (=?utf-8?Q?=22Bj=C3=B8rn?=
 Mork"'s message of "Wed, 19
	Dec 2012 22:17:42 +0100")
Message-ID: <87zk1967jn.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjørn Mork <bjorn@mork.no> writes:
> Don Zickus <dzickus@redhat.com> writes:
>
>> What about the opposite cases?  
>> nmi_watchdog=1
>> echo 1 > /sys/devices/system/cpu/cpu1/online
>
> I don't see why not. But verifying it would be nice.  I thought that it
> would be a simple thing to test using qemu-kvm, but it seems that the
> CPU hotplugging support there isn't quite ready. The guest just dies
> with "Assertion `bus->allow_hotplug' failed."
>
> I'll go digging for alternatives, but if anyone else could verify this
> then I'd appreciate it.

I just realized that you might not really want/need hotplugging, but
just booting with some cores initially offline?

That's easier to test at least:

qmitest:~# cat /proc/cmdline 
initrd=/initrd.img.test root=/dev/sda1 ro console=tty0 console=ttyS0,9600n8 maxcpus=1 BOOT_IMAGE=/vmlinuz.test 
qmitest:~#  grep . /sys/devices/system/cpu/o*line
/sys/devices/system/cpu/offline:1-3
/sys/devices/system/cpu/online:0
qmitest:~# grep . /sys/devices/system/cpu/cpu?/online 
/sys/devices/system/cpu/cpu1/online:0
/sys/devices/system/cpu/cpu2/online:0
/sys/devices/system/cpu/cpu3/online:0
qmitest:~# grep . /sys/devices/system/cpu/o*line
/sys/devices/system/cpu/offline:1-3
/sys/devices/system/cpu/online:0
qmitest:~# grep . /proc/sys/kernel/nmi_watchdog 
1


qmitest:~#  echo 1 > /sys/devices/system/cpu/cpu1/online
qmitest:~#  echo 1 > /sys/devices/system/cpu/cpu2/online
qmitest:~# grep . /sys/devices/system/cpu/cpu?/online 
/sys/devices/system/cpu/cpu1/online:1
/sys/devices/system/cpu/cpu2/online:1
/sys/devices/system/cpu/cpu3/online:0


No problem observed.  As expected.



Bjørn
