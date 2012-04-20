Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab2DTQVL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 12:21:11 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:18390 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab2DTQVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 12:21:07 -0400
Date: Fri, 20 Apr 2012 18:21:03 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Matt Turner <mattst88@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Richard Kuo <rkuo@codeaurora.org>, Tony Luck <tony.luck@intel.com>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        David Howells <dhowells@redhat.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Richard Weinberger <richard@nod.at>, x86@kernel.org
Subject: Re: [patch 04/18] smp: Provide generic idle thread allocation
Message-ID: <20120420162103.GA3065@merkur.ravnborg.org>
References: <20120420122120.097464672@linutronix.de> <20120420124557.102478630@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120420124557.102478630@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 01:05:45PM -0000, Thomas Gleixner wrote:
> All SMP architectures have magic to fork the idle task and to store it
> for reusage when cpu hotplug is enabled. Provide a generic
> infrastructure for it.
> 
> Create/reinit the idle thread for the cpu which is brought up in the
> generic code and hand the thread pointer to the architecture code via
> __cpu_up().
> 
> Note, that fork_idle() is called via a workqueue, because this
> guarantees that the idle thread does not get a reference to a user
> space VM. This can happen when the boot process did not bring up all
> possible cpus and a later cpu_up() is initiated via the sysfs
> interface. In that case fork_idle() would be called in the context of
> the user space task and take a reference on the user space VM.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Matt Turner <mattst88@gmail.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Mike Frysinger <vapier@gentoo.org>
> Cc: Jesper Nilsson <jesper.nilsson@axis.com>
> Cc: Richard Kuo <rkuo@codeaurora.org>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Hirokazu Takata <takata@linux-m32r.org>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: David Howells <dhowells@redhat.com>
> Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Cc: Richard Weinberger <richard@nod.at>
> Cc: x86@kernel.org
> ---
>  arch/Kconfig        |    3 +
>  kernel/cpu.c        |    2 -
>  kernel/sched/core.c |    2 +
>  kernel/smpboot.c    |   83 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  kernel/smpboot.h    |   10 ++++++
>  5 files changed, 99 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/arch/Kconfig
> ===================================================================
> --- linux-2.6.orig/arch/Kconfig
> +++ linux-2.6/arch/Kconfig
> @@ -145,6 +145,9 @@ config HAVE_DMA_ATTRS
>  config USE_GENERIC_SMP_HELPERS
>  	bool
>  
> +config GENERIC_SMP_IDLE_THREAD
> +       bool
> +

Symbols we select in arch Kconfig files are often named HAVE_*
And no matter the name - a comment preceeding the definition of the symbol
would be nice so it is possible to deduct the use of the symbol
in a few years time when this thread is long forgotten.

	Sam
