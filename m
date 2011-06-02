Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab1FBAcC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 20:32:02 -0400
Received: from smtp-out.google.com ([74.125.121.67]:10900 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250Ab1FBAcA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 20:32:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=MWPyB7J/pgaqqRfEDmWAalGSo82y2rfDtOTuR4znj6h079uZeqC5hMCppjhFPTTODL
         hSPzO7fSHbIbsHwafrDw==
MIME-Version: 1.0
In-Reply-To: <1306972711.11492.23.camel@work-vm>
References: <BANLkTiniq6GVMJPO_-efKrWHQg9V9Dod9g@mail.gmail.com>
 <1306967733.11492.11.camel@work-vm> <BANLkTi=yEMDLEo99WZm2Bt4pi_pog5igww@mail.gmail.com>
 <1306972711.11492.23.camel@work-vm>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 1 Jun 2011 18:31:37 -0600
Message-ID: <BANLkTimuPrqN1euyOqAGm2m4Ea1PdbrzDQ@mail.gmail.com>
Subject: Re: /proc/stat btime accuracy problem
To: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 1, 2011 at 5:58 PM, john stultz <johnstul@us.ibm.com> wrote:
> On Wed, 2011-06-01 at 17:35 -0600, Bjorn Helgaas wrote:
>> On Wed, Jun 1, 2011 at 4:35 PM, john stultz <johnstul@us.ibm.com> wrote:
>> > On Wed, 2011-06-01 at 14:50 -0600, Bjorn Helgaas wrote:
>> >> timekeeping_init() basically does the following:
>> >>
>> >>     xtime = RTC
>> >>     if (arch implements read_boot_clock())
>> >>         wall_to_monotonic = -read_boot_clock()
>> >>     else
>> >>       wall_to_monotonic = -xtime
>> >>
>> >> So wall_to_monotonic records some approximation of the system boot
>> >> time, which is then used to derive the "btime" reported in /proc/stat.
>> >>
>> >> The problem I'm seeing is that xtime is updated on timer ticks, so
>> >> uninterruptible code, like kernel serial printk, makes us miss ticks,
>> >> so xtime falls behind the RTC.
>> >
>> > Huh. So this sort of issue was common back when we had tick-based
>> > timekeeping (in combination with troubled hardware), but with the
>> > current clocksource based timekeeping, occasional lost ticks shouldn't
>> > really effect time.
>>
>> Makes sense.  Your presentation here was a great help:
>>   http://sr71.net/~jstultz/tod/ols-presentation-final.pdf
>>
>> > Can you explain a bit more about what kind of hardware this is happening
>> > on, and what clocksource is being used?
>>
>> Sure.  This is an x86 box.  Normally we're using the TSC clocksource,
>> and I don't think the issue happens after that.  I guess my
>> experimentation so far has been with uninterruptible time before we
>> register *any* clocksource (or at least before I see any "Switching to
>> clocksource" messages).
>
> Huh.
>
> So yea, if we are very early at boot, we're likely using the jiffies
> clocksource, which is basically a software-based tick counter, which
> would be prone to lost-ticks issues if irqs were disabled for too long.
>
> Do you know if this is this a relatively new issue?
>
> My first instinct is "don't do that!" to whatever driver is disabling
> irqs for so long. Do you know what's actually causing these long irq off
> periods?
>
> I assume you're noticing this offset by seeing that CLOCK_REALTIME is
> off from the RTC right after boot? How severe is this? The RTC read is
> only second granular, so there's a fair amount of error (~1 second)
> possible right at boot, so this then must be many seconds worth of lost
> ticks to be noticeable, right?

I'm using 2.6.34, so not really new.  I think the major offender is
kernel serial printk, which is done in polled mode.  A *lot* of it,
e.g., 30+ seconds' worth.  I wonder if there's some reasonably clean
way to resync with the RTC, say at the time we register a clocksource
better than jiffies, or in clocksource_done_booting(), or something.

Bjorn
