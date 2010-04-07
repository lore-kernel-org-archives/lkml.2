Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab0DGSFy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 14:05:54 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:35156 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab0DGSFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 14:05:53 -0400
Date: Wed, 7 Apr 2010 11:05:07 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Joe Korty <joe.korty@ccur.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2.6.34-rc3] A nonintrusive SMI sniffer for x86 (resend)
Message-Id: <20100407110507.3c8a3aea.randy.dunlap@oracle.com>
In-Reply-To: <20100406200605.GA16586@typhoon.ccur.com>
References: <20100406200605.GA16586@typhoon.ccur.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4BBCC95D.0151:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Apr 2010 16:06:05 -0400 Joe Korty wrote:

> [PATCH 2.6.34-rc3] A nonintrusive SMI sniffer for x86.
> 
> The smi sniffer is not 'on' until compiled in (CONFIG_DEBUG_SMI_SNIFFER=y)
> and enabled (poll=smi on the boot command line, or after boot, echo 1
> >/proc/sys/kernel/smi_sniffer_enable).  More details may be found in
> Documentation/x86/smi-sniffer.txt
> 
> [Developed and tested on 2.6.31 then forward-ported to 2.6.34-rc3]
> 
> Signed-off-by: Joe Korty <joe.korty@ccur.com>
> 
> Index: 2.6.34-rc3/Documentation/kernel-parameters.txt
> ===================================================================
> --- 2.6.34-rc3.orig/Documentation/kernel-parameters.txt	2010-04-05 14:25:10.000000000 -0400
> +++ 2.6.34-rc3/Documentation/kernel-parameters.txt	2010-04-05 14:30:06.000000000 -0400
> @@ -940,11 +940,15 @@
>  			Claim all unknown PCI IDE storage controllers.
>  
>  	idle=		[X86]
> -			Format: idle=poll, idle=mwait, idle=halt, idle=nomwait
> -			Poll forces a polling idle loop that can slightly
> +			Format: idle=poll, idle=smi, idle=mwait, idle=halt,
> +			idle=nomwait
> +			idle=poll: forces a polling idle loop that can slightly
>  			improve the performance of waking up a idle CPU, but
>  			will use a lot of power and make the system run hot.
>  			Not recommended.
> +			idle=smi: variant of idle=poll that uses the spin-time
> +			to detect otherwise undetectable SMIs.  Not available
> +			unless CONFIG_DEBUG_SMI_SNIFFER=y.

preferable:		Only available when CONFIG_DEBUG_SMI_SNIFFER=y.

>  			idle=mwait: On systems which support MONITOR/MWAIT but
>  			the kernel chose to not use it because it doesn't save
>  			as much power as a normal idle loop, use the
> Index: 2.6.34-rc3/Documentation/x86/smi-sniffer.txt
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ 2.6.34-rc3/Documentation/x86/smi-sniffer.txt	2010-04-05 14:30:06.000000000 -0400
> @@ -0,0 +1,79 @@
> +[Original written March, 2010]
> +
> +			The SMI Sniffer
> +
> +Background
> +----------
> +A System Management Mode Interrupt (SMI) is a special kind of NMI-like
> +interrupt that goes directly to the BIOS. They are used by motherboard
> +manufacturers to, for example, 1) simulate missing hardware in software,
> +such as an RTC or emulating a missing PS2 mouse/keyboard using a USB
> +mouse/keyboard, 2) to perform critical motherboard duties, such as periodic

drop "to" (redundant) ^^

> +DRAM memory refresh or slowing the cpu down whenever it gets too hot, and 3)

s/cpu/CPU/ throughout

> +to work around in software (ie, in the BIOS) deficiencies discovered after

drop "to" (redundant)
s/ie/i.e./

> +a board has been manufactured and shipped to customers.
> +
> +The OS is not involved with nor even informed of these interrupts when
> +they occur, and indeed it is difficult for the OS to detect that they have
> +occurred at all. The only signature an SMI leaves behind is the time that it
> +consumes. These 'time slices', taken randomly out of the running time of a cpu,
> +compromise the ability of the OS to provide reasonable latency guarantees to
> +the applications running underneath it. For many uses this is unimportant,

(or on top of it ;)

> +but for real time systems, the occurrence of an SMI during the run of some
> +critically-timed piece of code could shatter the correct running of the system.
> +
> +Since SMI generation is a side effect of motherboard design, the only recourse
> +a user has for avoiding them is to search for and acquire motherboards which
> +do not use SMIs at all, or which do use them, but in ways their occurrence
> +can be avoided by a proper setting up of the system. This can be a fruitful
> +approach, as SMI usage indeed varies widely across products.
> +
> +The SMI sniffer
> +---------------
> +For a kernel compiled with CONFIG_DEBUG_SMI_SNIFFER=y, a new idle method,
> +"smi", will show up in the list of available idle methods.  It can be enabled
> +by either adding "idle=smi" to the boot command line, or, if the default idle
> +routine is in use, by an "echo 1 >/proc/sys/kernel/smi_sniffer_enable" command.
> +
> +The sniffer adds a pair of lines to /proc/interrupts.  The "SMI" line shows
> +the number of SMIs detected (per-cpu) so far. The "DSMI" line gives the
> +duration, in microseconds, of the most recent SMI (for each cpu).
> +
> +These lines appear only while the sniffer is running. If it is disabled later,
> +say with an "echo 0 >/proc/sys/kernel/smi_sniffer_enable", then the lines
> +will no longer show up. This is a nice way to verify whether the sniffer is
> +actually running or not.
> +
> +The sniffer does suffer from some defects. It only sniffs out SMIs that last
> +15 usecs or longer.  It can only discover SMIs that occur on cpus that are
> +idle. It will therefore miss any SMI that occurs while a user application is
> +running, while a system call is running, or while a normal system interrupt
> +is being processed. It will also miss a few SMIs that interrupt idle: those
> +that occur 'too close' to a normal system interrupt, those that occur while
> +the sniffer self-calibrates, and those that occur in the interval between
> +successive sniffer 125 usec sampling periods.  Therefore one must not regard
> +the sniffer as a precision tool for diagnosing SMI problems.
> +
> +The Method
> +----------
> +The sniffer divides idle time into 125 usec periods. This is measured out
> +by a countdown on the basic need_resched() loop, whose initial value is such
> +that when the count reaches zero, we expect to find that 125 usecs has passed.
> +
> +The actual time is found by sampling the TSC before and after the period. This
> +will be the same as the expected time of 125 usec unless an interrupt (SMI
> +or normal system interrupt) occurs.  In that case the actual time will be
> +longer than 125 usecs by the time it took to process the interrupt.
> +
> +The OS is modified so that all normal system interrupts, including NMI, mark
> +their occurrence via the setting of a per-cpu 'system interrupt occured' flag.

                                                                   occurred

> +We can therefore detect SMIs by assuming that if a period significantly longer
> +than 125 usecs is seen, and this 'system interrupt happened' flag is not set,
> +that it was an SMI that lengthened the period.
> +
> +Additional Limitations
> +----------------------
> +The sniffer is sensitive to variable-frequency TSCs and to TSCs which can
> +stop-and-go.  Therefore it cannot be compiled in when CONFIG_CPU_FREQ=y.
> +For some platforms, much of power management may need to be turned off in
> +order to get reliable results.


---
~Randy
