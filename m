Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758937Ab1DZWca (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 18:32:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54359 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753770Ab1DZWc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 18:32:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>, MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [RFC PATCH v2 1/3] PM / Core: suspend_again callback for device PM.
Date: Wed, 27 Apr 2011 00:32:41 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc4+; KDE/4.6.0; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, linux-pm@lists.linux-foundation.org,
        Len Brown <len.brown@intel.com>,
        "Jean Delvare (PC drivers core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        kyungmin.park@samsung.com, myungjoo.ham@gmail.com,
        LKML <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>, rpurdie@rpsys.net,
        lenz@cs.wisc.edu, arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>,
        thommycheck@gmail.com,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
        utx@penguin.cz, zaurus-devel@www.linuxtogo.org,
        Marek Vasut <marek.vasut@gmail.com>
References: <1303288106-2965-1-git-send-email-myungjoo.ham@samsung.com> <20110426210627.GA28033@elf.ucw.cz> <201104262346.58046.rjw@sisk.pl>
In-Reply-To: <201104262346.58046.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104270032.42046.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 26, 2011, Rafael J. Wysocki wrote:
> On Tuesday, April 26, 2011, Pavel Machek wrote:
...
> > Ok, see the spitz_should_wakeup() function in arch/arm/mach-pxa/* and
> > should_wakeup() usage.
> 
> OK, I will.

Well, as far as I can tell, on Zaurus this is all done within the platform
->enter() callback, so it doesn't carry out the device resume, while the
proposed $subject patch does.  For this reason, I'm not even sure if the
proposed approach is really suitable for Zaurus (the resuming and suspending
of all devices every once a while will cost quite some enery I guess).

Still, in the unlikely case it is suitable, here's my opinion.

I don't think syscore_ops is the right place to put the new "suspend
again" callback for reasons stated previously.

I also don't think dev_pm_ops is the right place to put such a callback,
because it will only be necessary on very few platforms and there's no
reason why every driver, subsystem or power domain in the kernel should care.

Moreover, the usage cases appear to be suspend-specific.

For the above reasons, the only place the "suspend again" callback may be
put into is struct platform_suspend_ops.  Then, suspend_devices_and_enter()
may be modified so that it loops between dpm_suspend_start() and
dpm_suspend_end() until that callback returns "false" and there are no
wakeup events (as indicated by pm_wakeup_pending(); but please note that
this would require suspend_enter() to indicate that pm_wakeup_pending()
returned "true" and events_check_enabled should not be reset until
we're sure that we _really_ want to resume).

Alternatively, if that's sufficient, suspend_enter() may be called in a
loop until the "suspend again" callback returns "false" and there are no
wakeup events (in the above sense).

The callback can be called "repeat" and return bool as far as I'm concerned,
but I'm not insisting on that.

MyungJoo, would that be suitable to you?

Rafael
