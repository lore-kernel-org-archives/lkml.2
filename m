Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932700Ab1FHBEJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 21:04:09 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:55327 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932342Ab1FHBEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 21:04:07 -0400
Subject: Re: /proc/stat btime accuracy problem
From: john stultz <johnstul@us.ibm.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org, Alan Cox <alan@linux.intel.com>
In-Reply-To: <1307469017.3163.37.camel@work-vm>
References: <BANLkTiniq6GVMJPO_-efKrWHQg9V9Dod9g@mail.gmail.com>
	 <1306967733.11492.11.camel@work-vm>
	 <BANLkTi=yEMDLEo99WZm2Bt4pi_pog5igww@mail.gmail.com>
	 <1306972711.11492.23.camel@work-vm>
	 <BANLkTimuPrqN1euyOqAGm2m4Ea1PdbrzDQ@mail.gmail.com>
	 <1306975745.11492.30.camel@work-vm>
	 <BANLkTikR4HNnFsYm2ymm1+FTbeeXtvH51g@mail.gmail.com>
	 <BANLkTimGfwqvhOKXCGqJUvMU7jozqQT8=g@mail.gmail.com>
	 <1307469017.3163.37.camel@work-vm>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Jun 2011 18:03:57 -0700
Message-ID: <1307495037.3163.76.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-07 at 10:50 -0700, john stultz wrote:
> Maybe to get this back on coarse, could you provide some additional
> details about the machine where you're seeing this? Is there one
> specific driver that is putting out tons of output over the serial
> console? Or is there anything unique about the serial port or its
> settings (is it configured at 300 baud :)? What is the /proc/interrupts
> count after boot on one of these systems?

Sorry, I just remembered you already provided some of these details
below:

On Thu, 2011-06-02 at 00:34 -0600, Bjorn Helgaas wrote: 
> Linux version 3.0.0-smp-DEV ...
>   BH now   rtc 1306992452 (start_kernel, before setup_arch)
>       Printk 230K of numa=fake debug stuff (more than seems strictly
>       necessary to me, but there it is).  All this data goes into the log
>       buffer, not to the UART, because the console hasn't been
>       initialized yet.
[snip]
> console [ttyS0] enabled
>       Now ttyS0 is enabled, so we dump the log buffer to the UART.  I think
>       this happens in console_unlock(), with interrupts disabled for the whole
>       buffer.
> 
>   BH now   rtc 1306992481 xt 1306992459 wtm -1306992457
>   clocksource_register jiffies
>       This RTC read is in clocksource_register(); note that xtime is now
>       22 seconds behind the RTC.  The UART is running at 115200 baud,
>       and 230K/(115200/10) = about 20 seconds, so this sort of matches
>       the time I expect it to take to dump the buffer.


Ok. So having the 230k data backlog at console_unlock() seems to be part of the issue.

Maybe something like the following could help? By only holding irqs off for 1k chunks?

thanks
-john


diff --git a/kernel/printk.c b/kernel/printk.c
index 3518539..9703b22 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1243,6 +1243,7 @@ void console_unlock(void)
 	unsigned long flags;
 	unsigned _con_start, _log_end;
 	unsigned wake_klogd = 0;
+	unsigned chunk_size, length;
 
 	if (console_suspended) {
 		up(&console_sem);
@@ -1251,14 +1252,18 @@ void console_unlock(void)
 
 	console_may_schedule = 0;
 
+	chunk_size = min(LOG_BUF_MASK, 1024); /* 1k chunks */
+
 	for ( ; ; ) {
 		spin_lock_irqsave(&logbuf_lock, flags);
 		wake_klogd |= log_start - log_end;
 		if (con_start == log_end)
 			break;			/* Nothing to print */
+		length = (log_end - con_start) & LOG_BUF_MASK;
+		length = min(length , chunk_size);
 		_con_start = con_start;
-		_log_end = log_end;
-		con_start = log_end;		/* Flush */
+		_log_end = (con_start + length) & LOG_BUF_MASK;
+		con_start = _log_end;		/* Flush */
 		spin_unlock(&logbuf_lock);
 		stop_critical_timings();	/* don't trace print latency */
 		call_console_drivers(_con_start, _log_end);




