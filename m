Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751246Ab0HPEMe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 00:12:34 -0400
Received: from 207-172-69-77.c3-0.smr-ubr3.sbo-smr.ma.static.cable.rcn.com ([207.172.69.77]:53607
	"EHLO thaum.luto.us" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab0HPEMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 00:12:33 -0400
X-Greylist: delayed 383 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Aug 2010 00:12:33 EDT
Message-ID: <4C68B92B.3080406@myrealbox.com>
Date: Mon, 16 Aug 2010 00:06:03 -0400
From: Andy Lutomirski <luto@myrealbox.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Dave Airlie <airlied@linux.ie>, Chris Wilson <chris@chris-wilson.co.uk>,
        Zhao Yakui <yakui.zhao@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Adam Jackson <ajax@redhat.com>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Intel graphics CPU usage - SDVO detect bogosity?
References: <AANLkTi=NFpeyo7Q31yMfqKSP2c-2OS2ccqa=Q9CQ8bpk@mail.gmail.com>
In-Reply-To: <AANLkTi=NFpeyo7Q31yMfqKSP2c-2OS2ccqa=Q9CQ8bpk@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> I started wondering why 'top' was showing an otherwise idle system as
> having a load average of 0.5+, and worker threads constantly using the
> CPU.
> 
> So I did a system-wide profile, and got the attached output (look at
> it in a really wide terminal).
> 
> There seems to be something _seriously_ wrong with i915 SDVO detect.
> This is on an Apple Mac Mini (hey, your favorite problem child!), and
> apparently it spends 20% of its non-idle CPU time just doing udelay's
> for the i2c SDVO connection detection.

You might be hitting the infamous hotplug storm [1].  The symptoms vary 
by kernel version.

2.6.34 and before: udevadm --monitor shows craploads of events and, as 
long as X is running, X keeps reprobing the outputs which (depending on 
the particular bug) can suck cpu in the i2c code or cause more hotplug 
events.  It also makes X oddly laggy.

2.6.35 and newer: The kernel is smart enough to probe outputs itself 
before telling X, so the events never hit userspace.  But things still 
can get a bit laggy.

Anyone know why merely *reading* /sys/class/drm/whatever/status causes 
the output to get probed?  (I see it in the code, but I have no idea why 
that code's still there after most of the rest of the hotplug code got 
cleaned up in 2.6.36).

Once I find some free time, I plan on trying to at least fix the issue 
that causes this bug for me.  (It's apparently quite nontrivial due to 
silliness in the way dock/undock (!) works on some laptops.)


[1] for example: 
http://www.mail-archive.com/intel-gfx@lists.freedesktop.org/msg00921.html

> 
> That sounds a bit wrong, doesn't it?
> 
> I don't know how recent this is - it might have been going on for some
> time without me noticing. It's the wife's computer, and the same thing
> doesn't seem to happen on my Core i5 desktop
> 
> Any ideas? Any information I can give about the machine?

If I'm right, the outputs of intel_bios_dumper and intel_bios_reader 
could be instructive (both are in intel-gpu-tools).

You could also try intel_reg_write 0x61110 0x0 and see if the problem 
stops (at least until a suspend/resume cycle).  That command turns off 
output hotplug on the card, which has the side effect that the kernel 
will stop acting on bogus interrupts.

--Andy
