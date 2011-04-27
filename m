Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341Ab1D0Ggb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 02:36:31 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50127 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab1D0Gga convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 02:36:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=eZa4uRbEBskUjV7vAw2tiTtZU58zYYTbRWSxgSxjMmLPnzuhVTgaOGC6ehQY+a+Adn
         P1eO+lDdE9q9IoFm6kQkArCrkISEiu5bovM10JqMD3pBOWJ7SAJD6Tn+MFl2qy0SkTji
         nZ19hJcUQfSYvgPgJNbj2JmoZg4g1dawcnNU4=
MIME-Version: 1.0
In-Reply-To: <201104270032.42046.rjw@sisk.pl>
References: <1303288106-2965-1-git-send-email-myungjoo.ham@samsung.com>
	<20110426210627.GA28033@elf.ucw.cz>
	<201104262346.58046.rjw@sisk.pl>
	<201104270032.42046.rjw@sisk.pl>
Date: Wed, 27 Apr 2011 15:36:25 +0900
X-Google-Sender-Auth: c9Ml0gxAhFGpb4KlkkcxW6FqB4U
Message-ID: <BANLkTi=QDjBtY2WypXjYzyAOUGYjf_oRvw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 1/3] PM / Core: suspend_again callback for device PM.
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-pm@lists.linux-foundation.org, Len Brown <len.brown@intel.com>,
        "Jean Delvare (PC drivers core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        kyungmin.park@samsung.com, LKML <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>, rpurdie@rpsys.net,
        lenz@cs.wisc.edu, arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>,
        thommycheck@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
        utx@penguin.cz, zaurus-devel@www.linuxtogo.org,
        Marek Vasut <marek.vasut@gmail.com>, myungjoo.ham@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 7:32 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Tuesday, April 26, 2011, Rafael J. Wysocki wrote:
>> On Tuesday, April 26, 2011, Pavel Machek wrote:
> ...
>> > Ok, see the spitz_should_wakeup() function in arch/arm/mach-pxa/* and
>> > should_wakeup() usage.
>>
>> OK, I will.
>
> Well, as far as I can tell, on Zaurus this is all done within the platform
> ->enter() callback, so it doesn't carry out the device resume, while the
> proposed $subject patch does.  For this reason, I'm not even sure if the
> proposed approach is really suitable for Zaurus (the resuming and suspending
> of all devices every once a while will cost quite some enery I guess).

In fact, the kernel "hacks" of mine have been looping at
sysdev-suspend/resume implemented with platform_suspend_ops; thus it
does not carry device resume either.
I've moved the looping point to general device-suspend/resume because
I thought that other systems may require active devices.
However, if others can be satisfied without resumed devices, it is
perfect with me to move that inside device resume as well.

>
> Still, in the unlikely case it is suitable, here's my opinion.
>
> I don't think syscore_ops is the right place to put the new "suspend
> again" callback for reasons stated previously.
>
> I also don't think dev_pm_ops is the right place to put such a callback,
> because it will only be necessary on very few platforms and there's no
> reason why every driver, subsystem or power domain in the kernel should care.
>
> Moreover, the usage cases appear to be suspend-specific.
>
> For the above reasons, the only place the "suspend again" callback may be
> put into is struct platform_suspend_ops.  Then, suspend_devices_and_enter()
> may be modified so that it loops between dpm_suspend_start() and
> dpm_suspend_end() until that callback returns "false" and there are no
> wakeup events (as indicated by pm_wakeup_pending(); but please note that
> this would require suspend_enter() to indicate that pm_wakeup_pending()
> returned "true" and events_check_enabled should not be reset until
> we're sure that we _really_ want to resume).
>
> Alternatively, if that's sufficient, suspend_enter() may be called in a
> loop until the "suspend again" callback returns "false" and there are no
> wakeup events (in the above sense).
>
> The callback can be called "repeat" and return bool as far as I'm concerned,
> but I'm not insisting on that.
>
> MyungJoo, would that be suitable to you?

As long as sysdevs are resumed and some devices/subsystems (I2C-PMIC,
ADC, and RTC in my cases) can be selectively resumed and suspended, it
is fine.
Thus, your "alternative" suggestion is perfect with me. Actually, this
is almost going back to the original hack. =)

I'll submit next revision with platform_suspend_ops later.

Thank you!

>
> Rafael
>

Cheers!
- MyungJoo
-- 
MyungJoo Ham (함명주), Ph.D.
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: 82-10-6714-2858
