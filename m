Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab1FOJVY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 05:21:24 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63692 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377Ab1FOJVW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 05:21:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ITTigz59zlAoJcEPBYLwUIZXx0uuDpvI1rUxAJ4cCLMADs2alxWCCHyxCog4ZsO0sO
         IuocTp9CfvN8vnGDTsmoJ3/fHhyIA8ZN0jeQmqQ3BZyBujpeg72K2PjK0nn7DSJ6I2Rc
         w+M+yxNZrDHGUyukDLCRahAvU8wBDCTnoQR0g=
MIME-Version: 1.0
In-Reply-To: <1308125533.4641.33.camel@nathan.suse.cz>
References: <1308125533.4641.33.camel@nathan.suse.cz>
Date: Wed, 15 Jun 2011 11:21:21 +0200
Message-ID: <BANLkTikoxYAz7G7pvKABbVPzOuxUzLkO=Q@mail.gmail.com>
Subject: Re: bug: kernel 3.0-rc3 not relocatable on i386?
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Petr,

2011/6/15 Petr Tesarik <ptesarik@suse.cz>:
> Hi all,
>
> it seems that the 3.0-rc3 kernel is not relocatable on i386. I get
> warnings about jiffies being an absolute symbol, and indeed, when GRUB
> loads the kernel at a non-default address, jiffies is not relocated.
>
> In my example the kernel is configured with
> CONFIG_PHYSICAL_START=0x1000000
> CONFIG_PHYSICAL_ALIGN=0x200000
> CONFIG_RELOCATABLE=y
> and loaded at 0x200000 by GRUB.
>
> Booting fails when checking whether the timer works, because do_timer()
> increments jiffies_64, but timer_irq_works() checks jiffies. The code
> looks like this:
>
> c13daab7:       8b 3d 40 7a 39 c1       mov    0xc1397a40,%edi
>
> but arch/x86/boot/compressed/vmlinux.relocs does not contain c13daaba.
> Consequently, timer_irq_works() reads the wrong memory location and
> fails, causing a panic:
>
> kernel panic: IO-APIC + timer doesn't work! Boot with apic=debug and
> send a report.  Then try booting with the 'noapic' option.
>
> Needless to say, the kernel freezes a few initcalls later when booted
> with noapic, because IO-APIC worked fine, in fact. I verified that by
> inserting a debugging printk() in do_timer(), and I also verified with
> that printk() that the address of jiffies_64 and the address of jiffies
> differ at run time.
>
> Any idea how to fix this?
Does reverting this commit fix it?

commit 8c49d9a74bac5ea3f18480307057241b808fcc0c
Author: Andy Lutomirski <luto@MIT.EDU>
Date:   Mon May 23 09:31:24 2011 -0400

    x86-64: Clean up vdso/kernel shared variables

~Maarten
