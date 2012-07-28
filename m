Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab2G1Dae (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 23:30:34 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40911 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934Ab2G1Dac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 23:30:32 -0400
MIME-Version: 1.0
In-Reply-To: <CAMbhsRSGYmu=eyqik23cECsJPfpo6rUqZUa853nkY35XRo4Q_w@mail.gmail.com>
References: <1343184588-20239-1-git-send-email-ccross@android.com>
	<CACRpkdZv4p+QT3Y+=-xh5iJ=sr1_aahroxQ535QpzVD9e_ESJA@mail.gmail.com>
	<20120727233829.GB14835@n2100.arm.linux.org.uk>
	<CAMbhsRSGYmu=eyqik23cECsJPfpo6rUqZUa853nkY35XRo4Q_w@mail.gmail.com>
Date: Fri, 27 Jul 2012 20:30:31 -0700
X-Google-Sender-Auth: teu5iK13rZBM6cCbL8znSHig9Ck
Message-ID: <CAMbhsRQg4pETrM7cx+aSBzGn3S1LV_x7vo8X3A300vCWTjkFng@mail.gmail.com>
Subject: Re: [RFC v2] ARM: sched_clock: update epoch_cyc on resume
From: Colin Cross <ccross@android.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, Barry Song <21cnbao@gmail.com>,
        Vaibhav Bedia <vaibhav.bedia@ti.com>, Krzysztof Halasa <khc@pm.waw.pl>,
        Nicolas Pitre <nico@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 6:15 PM, Colin Cross <ccross@android.com> wrote:
> On Fri, Jul 27, 2012 at 4:38 PM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
>> On Sat, Jul 28, 2012 at 01:32:50AM +0200, Linus Walleij wrote:
>>> On Wed, Jul 25, 2012 at 4:49 AM, Colin Cross <ccross@android.com> wrote:
>>>
>>> > Many clocks that are used to provide sched_clock will reset during
>>> > suspend.  If read_sched_clock returns 0 after suspend, sched_clock will
>>> > appear to jump forward.  This patch resets cd.epoch_cyc to the current
>>> > value of read_sched_clock during resume, which causes sched_clock() just
>>> > after suspend to return the same value as sched_clock() just before
>>> > suspend.
>>> >
>>> > In addition, during the window where epoch_ns has been updated before
>>> > suspend, but epoch_cyc has not been updated after suspend, it is unknown
>>> > whether the clock has reset or not, and sched_clock() could return a
>>> > bogus value.  Add a suspended flag, and return the pre-suspend epoch_ns
>>> > value during this period.
>>> >
>>> > The new behavior is triggered by calling setup_sched_clock_needs_suspend
>>> > instead of setup_sched_clock.
>>> >
>>> > Signed-off-by: Colin Cross <ccross@android.com>
>>>
>>> Sweet!
>>> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
>>
>> Have any of you looked at the patch I originally posted for doing this?
>> It needs updating but shows the overall principle - which is to ensure
>> that the epoch is up to date before suspending.
>>
>> It doesn't deal with resume, because different timers behave differently,
>> and there's no real way to deal with that properly.  The important thing
>> that this patch does is to ensure sched_clock() doesn't ever go backwards.
>>
>>  arch/arm/kernel/sched_clock.c |   18 ++++++++++++++++++
>>  1 files changed, 18 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/arm/kernel/sched_clock.c b/arch/arm/kernel/sched_clock.c
>> index 9a46370..4be4019 100644
>> --- a/arch/arm/kernel/sched_clock.c
>> +++ b/arch/arm/kernel/sched_clock.c
>> @@ -10,6 +10,7 @@
>>  #include <linux/jiffies.h>
>>  #include <linux/kernel.h>
>>  #include <linux/sched.h>
>> +#include <linux/syscore_ops.h>
>>  #include <linux/timer.h>
>>
>>  #include <asm/sched_clock.h>
>> @@ -72,3 +73,20 @@ void __init sched_clock_postinit(void)
>>  {
>>         sched_clock_poll(sched_clock_timer.data);
>>  }
>> +
>> +static int sched_clock_suspend(void)
>> +{
>> +       sched_clock_poll(sched_clock_timer.data);
>> +       return 0;
>> +}
>> +
>> +static struct syscore_ops sched_clock_ops = {
>> +       .suspend        = sched_clock_suspend,
>> +};
>> +
>> +static int __init sched_clock_syscore_init(void)
>> +{
>> +       register_syscore_ops(&sched_clock_ops);
>> +       return 0;
>> +}
>> +device_initcall(sched_clock_syscore_init);
>>
>
> That patch was merged in 3.4, and my patch is on top of it.  Your
> patch updates epoch_cyc and epoch_ns in suspend, but if the first call
> to cyc_to_sched_clock after resume gets cyc = 0, cyc - epoch_cyc can
> be negative, although it will be cast back to a large positive number.
>
> With my patch, epoch_cyc is updated in resume to whatever
> read_sched_clock() returns, and epoch_ns is still set to the suspend
> value, so it appears that sched_clock has not changed between
> sched_clock_suspend and sched_clock_resume.  It will work with any
> timer behavior (reset to 0, reset to random value, or continuing
> counting).  The old setup_sched_clock function maintains the old
> behavior to appease those who like their 32kHz sched clock to continue
> ticking in suspend, although I think it is more correct for all sched
> clocks to be faster than 32 kHz (when possible) and stop in suspend.

I think the existing code can cause sched_clock to go backwards if the
register read by the read function resets to 0 in suspend:

In sched_clock_suspend epoch_cyc is updated to 0x00002000.

The first sched_clock call after resume gets cyc = 0, returning
epoch_ns + cyc_to_ns(0xffffe000)

Later, sched_clock gets cyc = 0x5000, returning epoch_ns +
cyc_to_ns(0x3000), which will be much smaller than the previous
sched_clock value.
