Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab1DOQPJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 12:15:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45012 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751380Ab1DOQPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 12:15:08 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.SOC.4.64.1104151122330.1320@er3.rutgers.edu>
References: <Pine.SOC.4.64.1104150931390.1320@er3.rutgers.edu>
 <BANLkTinO+HFq+Mgg1aUz9V==zYs7qSBtDw@mail.gmail.com> <Pine.SOC.4.64.1104151122330.1320@er3.rutgers.edu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 15 Apr 2011 09:14:17 -0700
Message-ID: <BANLkTi=Gq5thZk2f1nWTz3dDA5Non8ANZg@mail.gmail.com>
Subject: Re: Suspend/resume - slow resume
To: Ciprian Docan <docan@eden.rutgers.edu>, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Francois Romieu <romieu@fr.zoreil.com>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, "Rafael, J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 15, 2011 at 8:33 AM, Ciprian Docan <docan@eden.rutgers.edu> wrote:
>
> I enabled CONFIG_PRINTK_TIME in the config file and rebuild the kernel; and
> after a fresh reboot I saved the dmesg output before and after
> suspend/resume. Attached is the diff file containing the resume sequence. At
> linew 133 - 134 there is a longer gap, which I think is related to the r8169
> driver.
>
> I have unloaded the module and did a new suspend/resume sequence, but this
> time with the r8169 module removed it went much faster (3-4s to resume
> completely). Can you please help here ?

Ok, this seems to be yet another case of the ridiculously common error
of "let's load the firmware early, before the machine is even up". It
sometimes happens at boot-time (driver writers only test the module
case, not the built-in case), but it happens very often at
suspend/resume time (which driver writers seem to not test at all).

It is not valid to try to load the firmware at resume time. User space
isn't running, so all the firmware loading helpers are frozen.
Firmware that needs to be reloaded after a suspend needs to be saved
to memory!

I added netdev to the recipient list, because this is definitely not
just a r8169 issue - we've had this bug happen over and over again.

Looking at the code, it looks like r8169 _tries_ to save the firmware
(it has had this SAME bug before), but in case no firmware was ever
loaded successfully at all (either because there was no firmware to
begin with, or because the device had never been opened, so it had
never tried to load it before), it _still_ tries to load the firmware.

WTF? At resume time, you should _resume_, not "load firmware even if
it wasn't loaded before".

I also wonder if the generic power management layer code could do
something smarter about this. Print a big warning when somebody wants
to load firmware when the machine isn't fully operational, instead of
the "wait 60 seconds in the totally futile hope that things will
change". Adding greg to the cc for that case, he's marked as firmware
loader maintainer.

So Francois, can we please not load the firmware at resume time when
it wasn't loaded when suspended!

Greg/Rafael/whoever - could we please replace the "sleep for a minute
if you can't load the firmware" with a big immediate WARN_ON() if
somebody tries to load it at early boot time or at resume time? That
way we don't have the machine dead for sixty seconds (most people just
assume it's dead and will just reboot - I've done that myself when
I've been hit by this), and we'd get a nice "here's the offender"
printout.

And netdev/lkml just cc'd for information, just in case some driver
writer is lurking and suddenly realizes that their driver is broken
too.

                             Linus
