Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222Ab0EMDfe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 23:35:34 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:38631 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab0EMDfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 23:35:31 -0400
Date: Wed, 12 May 2010 21:35:30 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Tony Lindgren <tony@atomide.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Alan Stern <stern@rowland.harvard.edu>, magnus.damm@gmail.com,
       "Theodore Ts'o" <tytso@mit.edu>, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>,
       Brian Swetland <swetland@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg@redhat.com>,
       =?ISO-8859-15?Q?Beno=EEt_Cousson?= <b-cousson@ti.com>,
       linux-omap@vger.kernel.org, Vitaly Wool <vitalywool@gmail.com>,
       Linus Walleij <linus.walleij@ericsson.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
In-Reply-To: <1272667021-21312-1-git-send-email-arve@android.com>
Message-ID: <alpine.DEB.2.00.1005122118530.7624@utopia.booyaka.com>
References: <1272667021-21312-1-git-send-email-arve@android.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Some general comments on the suspend blockers/wakelock/opportunistic
suspend v6 patch series, posted here:

    https://lists.linux-foundation.org/pipermail/linux-pm/2010-April/025146.html

The comments below are somewhat telegraphic in the interests of 
readability - more specific comments to follow in later E-mails. I am 
indebted to those of us who discussed these issues at LPC last year and 
ELC this year for several stimulating discussions.

There are several general problems with the design of opportunistic
suspend and suspend-blocks.

1. The opportunistic suspend code bypasses existing Linux kernel code,
   such as timers and the scheduler, that indicates when code
   needs to run, and when the system is idle.  This causes two problems:

   a. When opportunistic suspend is enabled, the default mode is to
      break all timers and scheduling on the system.  This isn't
      right: the default mode should be to preserve standard Linux
      behavior.  Exceptions can then be added for process groups that
      should run with the non-standard timer and scheduler behavior.

   b. The series introduces a de novo kernel API and userspace API
      that are unrelated to timers and the scheduler, but if the point
      is to modify the behavior of timers or the scheduler, the
      existing timer or scheduler APIs should be extended.  Any new
      APIs will need to be widely spread throughout the kernel and
      userspace.

2. The suspend-block kernel API tells the kernel _how_ to accomplish a
   goal, rather than telling the kernel _what_ the goal is.  This
   results in layering violations, unstated assumptions, and is too
   coarse-grained.  These problems in turn will cause fragile kernel
   code, kernel code with userspace dependencies, and power management
   problems on modern hardware.  Code should ask for what it wants.
   For example, if a driver needs to place an upper bound on its
   device wakeup latency, or if it needs to place an upper bound on
   interrupt response latency, that is what it should request.  Driver
   and subsystem code should not care how the kernel implements those
   requests, since the implementation can differ on different hardware
   and even on different use-cases with the same hardware.
   
3. Similarly, the suspend-block userspace API tells the kernel how to
   accomplish a goal, rather than telling the kernel what the goal is.
   Userspace processes should ask the kernel for what they really
   want.  If a process' timers should be disabled upon entering
   suspend, or the timer durations should have a lower bound, that's
   what the API should request.

Merging this series as currently designed and implemented will cause 
problems.  Suspend-blocks introduce a second, separate idle management 
approach in the Linux kernel.  The existing approach is the familiar timer 
and scheduler based approach.  The new approach is one where timers and 
runqueues no longer matter: the system is always at risk of entering 
suspend at any moment, with only suspend-blocks to stop it. Driver authors 
will effectively have to implement both approaches in their code.

Once merged, it will be nearly impossible to remove this code in favor 
of a cleaner approach.  Suspend-block calls are likely to spread 
throughout the kernel and drivers.  Patches 6, 7, and 8 are the leading 
edge of this - a quick grep through the Android common kernel at

    git://android.git.kernel.org/kernel/common.git 

shows wakelocks in the following drivers:

    drivers/input/evdev.c
    drivers/input/misc/gpio_input.c
    drivers/input/misc/gpio_matrix.c
    drivers/mmc/core/core.c
    drivers/rtc/alarm.c
    drivers/usb/gadget/f_mass_storage.c

Suspend-blocks will be difficult to convert to a finer-grained approach 
later.  The API design problems, mentioned above in points 2 and 3, will 
make it very difficult to determine what a driver author's or modifier's 
intention was when adding the suspend-block.  Also, patches 2 and 7 
introduce userspace APIs.  We will undoubtedly wish to avoid removing a 
userspace API once it is merged.  It will be quite difficult to implement 
such a general directive ("block system suspend") on a future kernel that 
may have a much finer-grained notion of low-power system modes, indeed 
that may have no useful notion of "system suspend."

...

The opportunistic suspend patches try to solve at least two real problems, 
that should be resolved in some way.  First, some types of userspace 
processes can unintentionally block system power management.  Second, the 
kernel is missing a system-wide form of CPUIdle.  This patch series, 
though, isn't the right way to solve either of these problems.  Let's 
figure out a different approach.

Figuring out a different way to do this should not limit Android at all, 
since Google can do what other Linux distributions do and continue to 
patch opportunistic suspend/suspend-block calls into their kernels as 
needed to ship devices, while contributing towards a different solution to 
the problem.

 
regards,

- Paul

(Linux-OMAP co-maintainer, focusing mostly on power management and 
software architecture issues)

