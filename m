Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287Ab0HZQAl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 12:00:41 -0400
Received: from www.tglx.de ([62.245.132.106]:60650 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754156Ab0HZQAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 12:00:38 -0400
Date: Thu, 26 Aug 2010 18:00:01 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Howells <dhowells@redhat.com>
cc: linux-arch@vger.kernel.org, vapier@gentoo.org,
        linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH 7/7] Fix IRQ flag handling naming
In-Reply-To: <20100826141141.11132.24274.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.LFD.2.00.1008261758450.2768@localhost.localdomain>
References: <20100826141110.11132.91931.stgit@warthog.procyon.org.uk> <20100826141141.11132.24274.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Aug 2010, David Howells wrote:

> Fix the IRQ flag handling naming.  In linux/irqflags.h under one configuration,
> it maps:
> 
> 	local_irq_enable() -> raw_local_irq_enable()
> 	local_irq_disable() -> raw_local_irq_disable()
> 	local_irq_save() -> raw_local_irq_save()
> 	...
> 
> and under the other configuration, it maps:
> 
> 	raw_local_irq_enable() -> local_irq_enable()
> 	raw_local_irq_disable() -> local_irq_disable()
> 	raw_local_irq_save() -> local_irq_save()
> 	...
> 
> This is quite confusing.  There should be one set of names expected of the
> arch, and this should be wrapped to give another set of names that are expected
> by users of this facility.
> 
> Change this to have the arch provide:
> 
> 	flags = arch_local_save_flags()
> 	flags = arch_local_irq_save()
> 	arch_local_irq_restore(flags)
> 	arch_local_irq_disable()
> 	arch_local_irq_enable()
> 	arch_irqs_disabled_flags(flags)
> 	arch_irqs_disabled()
> 	arch_safe_halt()
> 
> Then linux/irqflags.h wraps these to provide:
> 
> 	raw_local_save_flags(flags)
> 	raw_local_irq_save(flags)
> 	raw_local_irq_restore(flags)
> 	raw_local_irq_disable()
> 	raw_local_irq_enable()
> 	raw_irqs_disabled_flags(flags)
> 	raw_irqs_disabled()
> 	raw_safe_halt()
> 
> with type checking on the flags 'arguments', and then wraps those to provide:
> 
> 	local_save_flags(flags)
> 	local_irq_save(flags)
> 	local_irq_restore(flags)
> 	local_irq_disable()
> 	local_irq_enable()
> 	irqs_disabled_flags(flags)
> 	irqs_disabled()
> 	safe_halt()
> 
> with tracing included if enabled.
> 
> The arch functions can now all be inline functions rather than some of them
> having to be macros.

Nice one.
 
> [Note that this patch only alters X86, FRV, MN10300, ARM and Blackfin at the
>  moment.  The other arches will need altering too as part of this patch].
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> Tested-by: Catalin Marinas <catalin.marinas@arm.com>

Acked-by: Thomas Gleixner <tglx@linutronix.de>

