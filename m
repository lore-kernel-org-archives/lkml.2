Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510Ab1FHERY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 00:17:24 -0400
Received: from smtp-out.google.com ([74.125.121.67]:31783 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab1FHERV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 00:17:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=GabZ4SSe7JWYb2+hYozph/PxFRiE5rqFOUHEA3PtdiRq8zHALs4qEYJF7BnYSRk5Vy
         8bNI6qDvesNw+TnMUx5Q==
MIME-Version: 1.0
In-Reply-To: <1307495037.3163.76.camel@work-vm>
References: <BANLkTiniq6GVMJPO_-efKrWHQg9V9Dod9g@mail.gmail.com>
 <1306967733.11492.11.camel@work-vm> <BANLkTi=yEMDLEo99WZm2Bt4pi_pog5igww@mail.gmail.com>
 <1306972711.11492.23.camel@work-vm> <BANLkTimuPrqN1euyOqAGm2m4Ea1PdbrzDQ@mail.gmail.com>
 <1306975745.11492.30.camel@work-vm> <BANLkTikR4HNnFsYm2ymm1+FTbeeXtvH51g@mail.gmail.com>
 <BANLkTimGfwqvhOKXCGqJUvMU7jozqQT8=g@mail.gmail.com> <1307469017.3163.37.camel@work-vm>
 <1307495037.3163.76.camel@work-vm>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 7 Jun 2011 22:16:58 -0600
Message-ID: <BANLkTik259Z-0qRaPMn3FsJ0QWyo07s5nQ@mail.gmail.com>
Subject: Re: /proc/stat btime accuracy problem
To: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org, Alan Cox <alan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 7, 2011 at 7:03 PM, john stultz <johnstul@us.ibm.com> wrote:
> On Tue, 2011-06-07 at 10:50 -0700, john stultz wrote:
>> Maybe to get this back on coarse, could you provide some additional
>> details about the machine where you're seeing this? Is there one
>> specific driver that is putting out tons of output over the serial
>> console? Or is there anything unique about the serial port or its
>> settings (is it configured at 300 baud :)? What is the /proc/interrupts
>> count after boot on one of these systems?
>
> Sorry, I just remembered you already provided some of these details
> below:
>
> On Thu, 2011-06-02 at 00:34 -0600, Bjorn Helgaas wrote:
>> Linux version 3.0.0-smp-DEV ...
>>   BH now   rtc 1306992452 (start_kernel, before setup_arch)
>>       Printk 230K of numa=fake debug stuff (more than seems strictly
>>       necessary to me, but there it is).  All this data goes into the log
>>       buffer, not to the UART, because the console hasn't been
>>       initialized yet.
> [snip]
>> console [ttyS0] enabled
>>       Now ttyS0 is enabled, so we dump the log buffer to the UART.  I think
>>       this happens in console_unlock(), with interrupts disabled for the whole
>>       buffer.
>>
>>   BH now   rtc 1306992481 xt 1306992459 wtm -1306992457
>>   clocksource_register jiffies
>>       This RTC read is in clocksource_register(); note that xtime is now
>>       22 seconds behind the RTC.  The UART is running at 115200 baud,
>>       and 230K/(115200/10) = about 20 seconds, so this sort of matches
>>       the time I expect it to take to dump the buffer.
>
>
> Ok. So having the 230k data backlog at console_unlock() seems to be part of the issue.
>
> Maybe something like the following could help? By only holding irqs off for 1k chunks?
>
> thanks
> -john
>
>
> diff --git a/kernel/printk.c b/kernel/printk.c
> index 3518539..9703b22 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -1243,6 +1243,7 @@ void console_unlock(void)
>        unsigned long flags;
>        unsigned _con_start, _log_end;
>        unsigned wake_klogd = 0;
> +       unsigned chunk_size, length;
>
>        if (console_suspended) {
>                up(&console_sem);
> @@ -1251,14 +1252,18 @@ void console_unlock(void)
>
>        console_may_schedule = 0;
>
> +       chunk_size = min(LOG_BUF_MASK, 1024); /* 1k chunks */
> +
>        for ( ; ; ) {
>                spin_lock_irqsave(&logbuf_lock, flags);
>                wake_klogd |= log_start - log_end;
>                if (con_start == log_end)
>                        break;                  /* Nothing to print */
> +               length = (log_end - con_start) & LOG_BUF_MASK;
> +               length = min(length , chunk_size);
>                _con_start = con_start;
> -               _log_end = log_end;
> -               con_start = log_end;            /* Flush */
> +               _log_end = (con_start + length) & LOG_BUF_MASK;
> +               con_start = _log_end;           /* Flush */
>                spin_unlock(&logbuf_lock);
>                stop_critical_timings();        /* don't trace print latency */
>                call_console_drivers(_con_start, _log_end);

That's a much better attempt than the disastrous one I made.  But it
didn't help at all, and I think I know one reason: if we reenable
interrupts every 1K, and I have 230K to dump, that's 230 additional
ticks we might get.  But with HZ=1000, that's only a quarter second of
wallclock time.

Even at 115200 baud, I think we can only print about 10 characters/ms.
 It doesn't seem reasonable to me to try to flush in chunks anywhere
near that small.

But something else must still be going on, because even when I *did*
turn the chunk size down to 100 or 10 or even 4 characters, we still
didn't recover any of that missing wallclock time.  I tried to verify
that interrupts were actually enabled by the local_irq_restore(), and
they were, but maybe there's still a priority issue or something.

I wonder if we could do something with the TSC, e.g., capture it
early, then use it in getboottime() to compute the delta back from the
current time.  Machines without a stable TSC would use the present
system.

Bjorn
