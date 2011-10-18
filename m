Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab1JRHYi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 03:24:38 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45271 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412Ab1JRHYh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 03:24:37 -0400
MIME-Version: 1.0
In-Reply-To: <20110919142801.101ae0ad.akpm@google.com>
References: <20110919103637.E116D9D401D@zog.reactivated.net>
	<20110919142801.101ae0ad.akpm@google.com>
Date: Tue, 18 Oct 2011 08:24:36 +0100
X-Google-Sender-Auth: hi_b_f2a0bo3cZL5XUzXPvUVGzY
Message-ID: <CAMLZHHRrhYJ2V5nDkNpw3+7yLcKtuesO+DrYj-a7JUpa=P_hWg@mail.gmail.com>
Subject: Re: [RFC] wait for VX855 RTC to become ready during resume
From: Daniel Drake <dsd@laptop.org>
To: Andrew Morton <akpm@google.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, rjw@sisk.pl, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Mon, Sep 19, 2011 at 10:28 PM, Andrew Morton <akpm@google.com> wrote:
>> As diagnosed at http://dev.laptop.org/ticket/10757 we are finding that
>> the RTC on the VIA VX855 frequently is not 'ready' during system resume.
>>
>> Reading from it produces zero. This causes the resume code to fail to
>> increment the system clock for the amount of time that was spent sleeping,
>> so the time is then wrong.
>>
>> We have found that if we wait for the RTC_REF_CLCK_32KHZ signal, the RTC
>> does soon start returning 'good' values.
>>
>> The patch below demonstrates the solution we have found, but will probably
>> make x86 maintainers cry. What would be a good approach to get this
>> appropriately quirked and worked around? Detect VX855 southbridge on PCI bus
>> and apply the quirk in this case? Do it from OLPC platform code?
>>
>> Thanks,
>> Daniel
>>
>>
>> ---
>>  arch/x86/kernel/rtc.c |   15 +++++++++++++++
>>  1 files changed, 15 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/x86/kernel/rtc.c b/arch/x86/kernel/rtc.c
>> index 88ee70d..3ad2e47 100644
>> --- a/arch/x86/kernel/rtc.c
>> +++ b/arch/x86/kernel/rtc.c
>> @@ -100,6 +100,21 @@ unsigned long mach_get_cmos_time(void)
>>       unsigned int status, year, mon, day, hour, min, sec, century = 0;
>>
>>       /*
>> +      * dev.laptop.org #10757, sometimes the RTC returns zero data
>> +      * immediately after a resume, so this code will give it some
>> +      * more time by waiting for the 32KHz clock bit to be set, in the
>> +      * hope that this means it is ready to be used.
>> +      */
>> +     if (!(CMOS_READ(RTC_FREQ_SELECT) & RTC_REF_CLCK_32KHZ)) {
>> +             int n = 0;
>> +             printk(KERN_INFO "rtc is insane, waiting for it\n");
>> +             while (!(CMOS_READ(RTC_FREQ_SELECT) & RTC_REF_CLCK_32KHZ)) {
>> +                     cpu_relax();
>> +                     n++;
>> +             }
>> +             printk(KERN_INFO "rtc was insane for %d counts\n", n);
>> +     }
>
> If the rtc is permanently insane, the kernel locks up.  I'd suggest
> adding a timeout.
>
> Perhaps also replace the cpu_relax() with a udelay(1), so the timeout
> can be properly implemented and so that the information in that printk
> has some useful meaning: "102 microseconds" is better than "11,434 counts".

Thanks for looking at this. We'll make the changes you've suggested,
test and resubmit.

Do you have any comments on the general approach? Is it OK to run such
code on all systems or should we look for a way to limit this to only
VX855/OLPC systems?

Thanks,
Daniel
