Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732Ab0HZOOj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 10:14:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517Ab0HZOOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 10:14:37 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100826141110.11132.91931.stgit@warthog.procyon.org.uk>
References: <20100826141110.11132.91931.stgit@warthog.procyon.org.uk>
To: linux-arch@vger.kernel.org, vapier@gentoo.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 0/7] Name the irq flag handling functions sanely
Date: Thu, 26 Aug 2010 15:14:09 +0100
Message-ID: <12348.1282832049@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[Note that this patch only alters X86, FRV, MN10300, ARM and Blackfin at the
 moment.  The other arches will need altering too as part of this patch].

The final patch of the series makes the naming of the general irq flag
functions sane.

Currently, under one configuration, linux/irqflags.h maps:

	local_irq_enable() -> raw_local_irq_enable()
	local_irq_disable() -> raw_local_irq_disable()
	local_irq_save() -> raw_local_irq_save()
	...

and under the other configuration, it maps:

	raw_local_irq_enable() -> local_irq_enable()
	raw_local_irq_disable() -> local_irq_disable()
	raw_local_irq_save() -> local_irq_save()
	...

This is quite confusing.  There should be one set of names expected of the
arch, and this should be wrapped to give another set of names that are expected
by users of this facility.

The final patch change the asm/irqflags.h headers to provide:

	flags = arch_local_save_flags()
	flags = arch_local_irq_save()
	arch_local_irq_restore(flags)
	arch_local_irq_disable()
	arch_local_irq_enable()
	arch_irqs_disabled_flags(flags)
	arch_irqs_disabled()
	arch_safe_halt()

Then linux/irqflags.h wraps these to provide:

	raw_local_save_flags(flags)
	raw_local_irq_save(flags)
	raw_local_irq_restore(flags)
	raw_local_irq_disable()
	raw_local_irq_enable()
	raw_irqs_disabled_flags(flags)
	raw_irqs_disabled()
	raw_safe_halt()

with type checking on the flags 'arguments', and then wraps those to provide:

	local_save_flags(flags)
	local_irq_save(flags)
	local_irq_restore(flags)
	local_irq_disable()
	local_irq_enable()
	irqs_disabled_flags(flags)
	irqs_disabled()
	safe_halt()

with tracing included if enabled.

The arch functions can now all be inline functions rather than some of them
having to be macros.

===========
ARCH FIXUPS
===========

To make this work, some of the arches need fixing up to some extent or other:

 (1) Blackfin.

     A number of circular dependencies and other problems needed sorting out in
     the Blackfin arch.  The first few patches deal with this.  With this, most
     of the Blackfin defconfigs compile, and none of the breakage is obviously
     to do with the irqflags patches.

     This also requires a name collision between the DES crypto module and the
     Blackfin arch code to be fixed.

David
