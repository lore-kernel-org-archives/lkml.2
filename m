Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab2DUCZy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 22:25:54 -0400
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:24032
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752590Ab2DUCZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 22:25:52 -0400
X-SpamScore: -3
X-BigFish: VPS-3(z1039ozbb2dI1432N98dKzz1202hzz8275ch8275bh8275dhz2fh668h839hd25h)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4F921A95.3030805@am.sony.com>
Date: Fri, 20 Apr 2012 19:25:25 -0700
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
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
        Richard Weinberger <richard@nod.at>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [patch 04/18] smp: Provide generic idle thread allocation
References: <20120420122120.097464672@linutronix.de> <20120420124557.102478630@linutronix.de>
In-Reply-To: <20120420124557.102478630@linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/12 06:05, Thomas Gleixner wrote:
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

    ^^^^^  This _appears_ to be spaces instead of a tab.  Hopefully not a false alarm, I know
           my mail servers randomly change tabs to spaces, just to mess with me, but I double
           checked at the lkml archive.

> +
>  config HAVE_REGS_AND_STACK_ACCESS_API
>  	bool
>  	help

< snip >

- Frank

