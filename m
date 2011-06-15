Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab1FOM0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 08:26:31 -0400
Received: from cantor.suse.de ([195.135.220.2]:33080 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768Ab1FOM01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 08:26:27 -0400
Subject: Re: bug: kernel 3.0-rc3 not relocatable on i386?
From: Petr Tesarik <ptesarik@suse.cz>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1308132448.4641.41.camel@nathan.suse.cz>
References: <1308125533.4641.33.camel@nathan.suse.cz>
	 <BANLkTikoxYAz7G7pvKABbVPzOuxUzLkO=Q@mail.gmail.com>
	 <1308132078.4641.38.camel@nathan.suse.cz>
	 <1308132448.4641.41.camel@nathan.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Organization: SUSE LINUX
Date: Wed, 15 Jun 2011 14:26:23 +0200
Message-Id: <1308140783.4641.141.camel@nathan.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Petr Tesarik píše v St 15. 06. 2011 v 12:07 +0200:
> Petr Tesarik píše v St 15. 06. 2011 v 12:01 +0200:
> > Maarten Lankhorst píše v St 15. 06. 2011 v 11:21 +0200:
> > > Hi Petr,
> > > 
> > > 2011/6/15 Petr Tesarik <ptesarik@suse.cz>:
> > > > Hi all,
> > > >
> > > > it seems that the 3.0-rc3 kernel is not relocatable on i386. I get
> > > > warnings about jiffies being an absolute symbol, and indeed, when GRUB
> > > > loads the kernel at a non-default address, jiffies is not relocated.
> > > >
> > > > In my example the kernel is configured with
> > > > CONFIG_PHYSICAL_START=0x1000000
> > > > CONFIG_PHYSICAL_ALIGN=0x200000
> > > > CONFIG_RELOCATABLE=y
> > > > and loaded at 0x200000 by GRUB.
> > > >
> > > > Booting fails when checking whether the timer works, because do_timer()
> > > > increments jiffies_64, but timer_irq_works() checks jiffies. The code
> > > > looks like this:
> > > >
> > > > c13daab7:       8b 3d 40 7a 39 c1       mov    0xc1397a40,%edi
> > > >
> > > > but arch/x86/boot/compressed/vmlinux.relocs does not contain c13daaba.
> > > > Consequently, timer_irq_works() reads the wrong memory location and
> > > > fails, causing a panic:
> > > >
> > > > kernel panic: IO-APIC + timer doesn't work! Boot with apic=debug and
> > > > send a report.  Then try booting with the 'noapic' option.
> > > >
> > > > Needless to say, the kernel freezes a few initcalls later when booted
> > > > with noapic, because IO-APIC worked fine, in fact. I verified that by
> > > > inserting a debugging printk() in do_timer(), and I also verified with
> > > > that printk() that the address of jiffies_64 and the address of jiffies
> > > > differ at run time.
> > > >
> > > > Any idea how to fix this?
> > > Does reverting this commit fix it?
> > 
> > Isn't this related to VDSO? I've got no troubles with the VDSO. It's
> > just that the kernel assumes a fixed location of jiffies (in the kernel
> > direct mapping), so it cannot be relocated.
> > 
> > OTOH this must have worked the other day, so searching for the commit
> > that broke it is a good hint. I'll try it here, too.
> 
> Ah, it turns out this is in fact reported here:
> 
> http://sourceware.org/bugzilla/show_bug.cgi?id=12327
> 
> But the patch was reverted by commit
> 6b35eb9ddcddde7b510726de03fae071178f1ec4, so these binutils have been
> broken again since January.

I tried to understand what was wrong with the approach taken by Shaohua
and what caused a problem for Markus Trippelsdorf, but it seems the
revert didn't help in any way: I don't get build failures. I get a
non-booting kernel, and the traces didn't give me any clue what was
wrong.

Anyway, what's wrong with the generic approach suggested by hpa?

http://linux.derkeiler.com/Mailing-Lists/Kernel/2011-01/msg06976.html

Petr

