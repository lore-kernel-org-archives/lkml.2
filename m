Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443Ab1KAJbH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 05:31:07 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:57092 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab1KAJbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 05:31:03 -0400
Subject: Re: [PATCH v5 33/36] Hexagon: Add configuration and makefiles for
 the Hexagon architecture.
From: Paul Bolle <pebolle@tiscali.nl>
To: Richard Kuo <rkuo@codeaurora.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <093448$3uejv7@wolverine01.qualcomm.com>
References: <093448$3uejv7@wolverine01.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Nov 2011 10:30:46 +0100
Message-ID: <1320139846.14409.129.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(I'd like to add some quick comments, Kconfig related. It's too late, I
guess.)

On Mon, 2011-10-31 at 18:55 -0500, Richard Kuo wrote:
> diff --git a/arch/hexagon/Kconfig b/arch/hexagon/Kconfig
> new file mode 100644
> index 0000000..02513c2
> --- /dev/null
> +++ b/arch/hexagon/Kconfig
> @@ -0,0 +1,220 @@
> +# Hexagon configuration
> +comment "Linux Kernel Configuration for Hexagon"
> +
> +config HEXAGON
> +	def_bool y
> +	select HAVE_OPROFILE
> +	select USE_GENERIC_SMP_HELPERS if SMP
> +	# Other pending projects/to-do items.
> +	# select HAVE_REGS_AND_STACK_ACCESS_API
> +	# select HAVE_HW_BREAKPOINT if PERF_EVENTS
> +	# select ARCH_HAS_CPU_IDLE_WAIT
> +	# select ARCH_WANT_OPTIONAL_GPIOLIB
> +	# select ARCH_REQUIRE_GPIOLIB
> +	# select HAVE_CLK
> +	# select IRQ_PER_CPU
> +	select HAVE_IRQ_WORK
> +	# select GENERIC_PENDING_IRQ if SMP

Is GENERIC_PENDING_IRQ also a pending project?

> +	select GENERIC_ATOMIC64
> +	select HAVE_PERF_EVENTS
> +	select HAVE_GENERIC_HARDIRQS
> +	select GENERIC_HARDIRQS_NO__DO_IRQ
> +	select GENERIC_HARDIRQS_NO_DEPRECATED
> +	# GENERIC_ALLOCATOR is used by dma_alloc_coherent()
> +	select GENERIC_ALLOCATOR
> +	select GENERIC_IRQ_SHOW
> +	select HAVE_ARCH_KGDB
> +	select HAVE_ARCH_TRACEHOOK
> +	select NO_IOPORT
> +	# mostly generic routines, with some accelerated ones

What does this comment on?

> +	---help---
> +	  Qualcomm Hexagon is a processor architecture designed for high
> +	  performance and low power across a wide variety of applications.
> +
> +config HEXAGON_ARCH_V1
> +	bool
> +
> +config HEXAGON_ARCH_V2
> +	bool
> +
> +config HEXAGON_ARCH_V3
> +	bool
> +
> +config HEXAGON_ARCH_V4
> +	bool

[...]

> +#config ZONE_DMA
> +#	bool
> +#	default y

Why is this added commented out?

> +config HAS_DMA
> +	bool
> +	select HAVE_DMA_ATTRS
> +	default y

HAS_DMA isn't supposed to be used this way, is it? See commit
411f0f3edc141a582190d3605cadd1d993abb6df ("Introduce CONFIG_HAS_DMA").
Can't this entry be replaced by a "select HAVE_DMA_ATTRS" line in the
"config HEXAGON" entry? That seems to be the common idiom.

[...]

> +config STACKTRACE_SUPPORT
> +	def_bool y
> +	select STACKTRACE

Some grepping suggests that the tracing infrastructure will "select
STACKTRACE" if the architecture sets STACKTRACE_SUPPORT (tile apparently
also gets this wrong). Have I grepped this correctly?

> +config GENERIC_BUG
> +	def_bool y
> +	depends on BUG
> +
> +config BUG
> +	def_bool y

Why do you have this? Other architecture don't (there's just one BUG
entry in all the Kconfig files).

> +menu "Machine selection"
> +
> +choice
> +	prompt "System type"
> +	default HEXAGON_ARCH_V2
> +
> +config HEXAGON_COMET
> +	bool "Comet Board"
> +	select HEXAGON_ARCH_V2
> +	---help---
> +	  Support for the Comet platform.
> +
> +endchoice

The default doesn't match the (single) config option here (it should
default to HEXAGON_COMET). That shouldn't matter because there's only
one option, which the config tools will then pick (that's the way they
seem to work). 

But why is this a choice when there's nothing to actually choose?
Moreover, just looking at this patch suggests HEXAGON_COMET is yet
unused (CONFIG_HEXAGON_COMET is commented out in the Makefile). So at
first glance this seems an elaborate way to select HEXAGON_ARCH_V2.

[...]

> +config SMP
> +	bool "Multi-Processing support"
> +	---help---
> +	  Enables SMP support in the kernel.  If unsure, say "Y"

Odd. Even x86 and powerpc (the only two architectures I looked at)
suggest to say "N" to those not knowing what to do here.

> +config NR_CPUS
> +	int "Maximum number of CPUs" if SMP
> +	range 2 6 if SMP
> +	default "1" if !SMP
> +	default "6" if SMP
> +	---help---
> +	  This allows you to specify the maximum number of CPUs which this
> +	  kernel will support.  The maximum supported value is 6 and the
> +	  minimum value which makes sense is 2.
> +
> +	  This is purely to save memory - each supported CPU adds
> +	  approximately eight kilobytes to the kernel image.

This is good. Quite a number of architectures do net set this
(especially the default of "1" in the !SMP case).

[...]

> +config GENERIC_GPIO
> +	bool "Generic GPIO support"
> +	default n

I know next to nothing about GENERIC_GPIO but does it make sense for
Hexagon? If not, wouldn't a "def_bool n" do? (Perhaps you could even
drop this entry entirely.)

[...]

> diff --git a/arch/hexagon/Makefile b/arch/hexagon/Makefile
> new file mode 100644
> index 0000000..7ce9563
> --- /dev/null
> +++ b/arch/hexagon/Makefile

[...]

> +#	arch/hexagon/platform/common/
> +#
> +#core-$(CONFIG_HEXAGON_COMET)		+= arch/hexagon/platform/comet/
> +#machine-$(CONFIG_HEXAGON_COMET)		:= comet


Paul Bolle

