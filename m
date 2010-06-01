Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757Ab0FANuu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 09:50:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60673 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756182Ab0FANus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 09:50:48 -0400
Date: Tue, 1 Jun 2010 09:50:04 -0400
From: Don Zickus <dzickus@redhat.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       linux-ide@vger.kernel.org
Subject: Re: hibernation hangs with ATA errors (lockup_detector bug)
Message-ID: <20100601135004.GP15159@redhat.com>
References: <4C03C608.1040600@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C03C608.1040600@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 04:22:00PM +0200, Jiri Slaby wrote:
> Hi,
> 
> with -next I get the following errors while trying to hibernate in
> qemu-kvm after the image is stored on disk:

Is this the host that is hibernating or the guest?

KVM guests don't emulate the performance counters, so the nmi piece
shouldn't be functioning and the soft lockup piece just sits on top of an
hrtimer, so off the top of my head it is hard to imagine it intefering
with a sata driver.

I'll need your whole boot up log to see how the lockup detector
initialized itself.

Cheers,
Don

> sd 0:0:0:0: [sda] Starting disk
> sd 0:0:1:0: [sdb] Starting disk
> e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
> ata1.00: configured for MWDMA2
> ata1.01: configured for MWDMA2
> PM: thaw of devices complete after 168.017 msecs
> ata2.01: qc timeout (cmd 0xec)
> ata2.01: failed to IDENTIFY (I/O error, err_mask=0x4)
> sd 0:0:1:0: [sdb] Stopping disk
> sd 0:0:0:0: [sda] Stopping disk
> uhci_hcd 0000:00:01.2: PCI INT D disabled
> e1000 0000:00:03.0: PCI INT A disabled
> ata2.01: qc timeout (cmd 0xec)
> ata2.01: failed to IDENTIFY (I/O error, err_mask=0x4)
> ata2.01: qc timeout (cmd 0xec)
> ata2.01: failed to IDENTIFY (I/O error, err_mask=0x4)
> ...
> 
> I bisected it down to:
> commit 58687acba59266735adb8ccd9b5b9aa2c7cd205b
> Author: Don Zickus <dzickus@redhat.com>
> Date:   Fri May 7 17:11:44 2010 -0400
> 
>     lockup_detector: Combine nmi_watchdog and softlockup detector
> 
>     The new nmi_watchdog (which uses the perf event subsystem) is very
>     similar in structure to the softlockup detector.  Using Ingo's
>     suggestion, I combined the two functionalities into one file:
>     kernel/watchdog.c.
> ...
> 
> 
> 
> The config difference against 58687acb^:
> --- .config.old     2010-05-31 16:01:51.727312636 +0200
> +++ .config 2010-05-31 16:11:08.682136175 +0200
> @@ -1,7 +1,7 @@
>  #
>  # Automatically generated make config: don't edit
>  # Linux kernel version: 2.6.34-rc7
> -# Mon May 31 16:01:51 2010
> +# Mon May 31 16:11:08 2010
>  #
>  CONFIG_64BIT=y
>  # CONFIG_X86_32 is not set
> @@ -2133,7 +2133,7 @@
>  CONFIG_DEBUG_KERNEL=y
>  CONFIG_DEBUG_SHIRQ=y
>  CONFIG_DETECT_SOFTLOCKUP=y
> -CONFIG_NMI_WATCHDOG=y
> +CONFIG_LOCKUP_DETECTOR=y
>  # CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
>  CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
>  CONFIG_DETECT_HUNG_TASK=y
> 
> 
> 
> 
> 'nowatchdog' parameter helps.
> 
> $ grep PERF .config
> CONFIG_HAVE_PERF_EVENTS=y
> CONFIG_PERF_EVENTS=y
> # CONFIG_PERF_COUNTERS is not set
> # CONFIG_DEBUG_PERF_USE_VMALLOC is not set
> CONFIG_HAVE_PERF_EVENTS_NMI=y
> 
> -- 
> js
