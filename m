Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933014Ab1IOKzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 06:55:40 -0400
Received: from mail-gw0-f42.google.com ([74.125.83.42]:56005 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932575Ab1IOKzi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 06:55:38 -0400
MIME-Version: 1.0
In-Reply-To: <201109142245.14808.rjw@sisk.pl>
References: <201108310017.03103.rjw@sisk.pl>
	<201109131806.39050.rjw@sisk.pl>
	<CACVXFVMFZJioG_vgJ_tx9rA8_=H0HcKZLCyLcTu8oSSSmUoNJg@mail.gmail.com>
	<201109142245.14808.rjw@sisk.pl>
Date: Thu, 15 Sep 2011 18:55:37 +0800
Message-ID: <CACVXFVN4G==wbyVPsuDJHC_+tWX6Jdn=+3Mp+9Ji_oMxE0MNsQ@mail.gmail.com>
Subject: Re: [PATCH 2/5] PM / Runtime: Do not run callbacks under lock for
 power.irq_safe set
From: Ming Lei <tom.leiming@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Kevin Hilman <khilman@ti.com>,
        jean.pihet@newoldbits.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 4:45 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Wednesday, September 14, 2011, Ming Lei wrote:
>> Hi,
>>
>> On Wed, Sep 14, 2011 at 12:06 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>
>> >> >> If power.lock is released, the transition states(resuming or suspending)
>> >> >
>> >> >> may be observed in rpm_suspend or rpm_resume, then tasks schedule
>> >> >
>> >> >> will be produced in these two functions,
>> >> >
>> >> > I don't think so, because the interrupts are still off.
>> >>
>> >> Yes, the interrupts are still off on local CPU, but the release of spin lock may
>> >> cause another CPUs to run into rpm_suspend or rpm_resume and produce
>> >> task schedule inside the two functions.
>> >
>> > Not for the same device, though.
>>
>> I think it is probable to happen on the same device in theory, see below:
>>
>> - suppose irq_safe is set before calling two pm_runtime_suspend below
>> - suppose this patch has been applied
>>
>> CPU0                                          CPU1
>> pm_runtime_suspend
>>       acquired power lock
>>       rpm_suspend
>>                                               pm_runtime_suspend
>>                                                       spining power lock
>>       ...
>>       release power lock
>>                                                       acquired power lock
>>       run .runtime_suspend
>>                                                       found the dev suspending
>>                                                       wait for power state and schedule
>
> OK, I see what the problem is.  The second CPU can see the status
> being RPM_SUSPENDING in the irq_safe case, which isn't possible
> without the patch.
>
> Good catch!
>
> I think in that case rpm_suspend() should just release the lock,
> run cpu_relax(), reacquire the lock and go to the "repeat" label.

Yes, it makes sense in this case.

BTW: looks like something is wrong about PM mail list, I often got
the messages below these days:

Delivery to the following recipient has been delayed:

    linux-pm@lists.linux-foundation.org

Message will be retried for 1 more day(s)


thanks,
-- 
Ming Lei
