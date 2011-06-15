Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab1FOIMS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 04:12:18 -0400
Received: from cantor.suse.de ([195.135.220.2]:51851 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872Ab1FOIMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 04:12:15 -0400
Subject: bug: kernel 3.0-rc3 not relocatable on i386?
From: Petr Tesarik <ptesarik@suse.cz>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: SUSE LINUX
Date: Wed, 15 Jun 2011 10:12:13 +0200
Message-Id: <1308125533.4641.33.camel@nathan.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

it seems that the 3.0-rc3 kernel is not relocatable on i386. I get
warnings about jiffies being an absolute symbol, and indeed, when GRUB
loads the kernel at a non-default address, jiffies is not relocated.

In my example the kernel is configured with
CONFIG_PHYSICAL_START=0x1000000
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_RELOCATABLE=y
and loaded at 0x200000 by GRUB.

Booting fails when checking whether the timer works, because do_timer()
increments jiffies_64, but timer_irq_works() checks jiffies. The code
looks like this:

c13daab7:       8b 3d 40 7a 39 c1       mov    0xc1397a40,%edi

but arch/x86/boot/compressed/vmlinux.relocs does not contain c13daaba.
Consequently, timer_irq_works() reads the wrong memory location and
fails, causing a panic:

kernel panic: IO-APIC + timer doesn't work! Boot with apic=debug and
send a report.  Then try booting with the 'noapic' option.

Needless to say, the kernel freezes a few initcalls later when booted
with noapic, because IO-APIC worked fine, in fact. I verified that by
inserting a debugging printk() in do_timer(), and I also verified with
that printk() that the address of jiffies_64 and the address of jiffies
differ at run time.

Any idea how to fix this?

Petr Tesarik

