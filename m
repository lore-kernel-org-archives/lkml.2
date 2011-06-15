Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab1FOJgs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 05:36:48 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41549 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209Ab1FOJgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 05:36:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=kSgFhviYI2SKzQVPHGzssi/NuWJi6u6Fb3Db4+ettrUZI625yKmRdh0o/oeODjv9t/
         ZyCLnRAr61egKuE8TXrfxLUqBmCeDY7aL+CHtmyJQruYj1sbtUcY4WYDTFuOagAZhDKQ
         x7fPpNKhGZmueAscUiiEhnichXva/rMSdy5IY=
Message-ID: <4DF87D2B.7090201@gmail.com>
Date: Wed, 15 Jun 2011 11:36:43 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Thunderbird/3.1.9
MIME-Version: 1.0
To: Petr Tesarik <ptesarik@suse.cz>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: bug: kernel 3.0-rc3 not relocatable on i386?
References: <1308125533.4641.33.camel@nathan.suse.cz>
In-Reply-To: <1308125533.4641.33.camel@nathan.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Petr,

Op 15-06-11 10:12, Petr Tesarik schreef:
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
> c13daab7:       8b 3d 40 7a 39 c1       mov    0xc1397a40,%edi
>
> but arch/x86/boot/compressed/vmlinux.relocs does not contain c13daaba.
> Consequently, timer_irq_works() reads the wrong memory location and
> fails, causing a panic:
>
> kernel panic: IO-APIC + timer doesn't work! Boot with apic=debug and
> send a report.  Then try booting with the 'noapic' option.
>
> Needless to say, the kernel freezes a few initcalls later when booted
> with noapic, because IO-APIC worked fine, in fact. I verified that by
> inserting a debugging printk() in do_timer(), and I also verified with
> that printk() that the address of jiffies_64 and the address of jiffies
> differ at run time.

Can you try this patch?

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 89aed99..49e666e 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -34,12 +34,11 @@ OUTPUT_FORMAT(CONFIG_OUTPUT_FORMAT, CONFIG_OUTPUT_FORMAT, CONFIG_OUTPUT_FORMAT)
 #ifdef CONFIG_X86_32
 OUTPUT_ARCH(i386)
 ENTRY(phys_startup_32)
-jiffies = jiffies_64;
 #else
 OUTPUT_ARCH(i386:x86-64)
 ENTRY(phys_startup_64)
-jiffies_64 = jiffies;
 #endif
+jiffies_64 = jiffies;
 
 #if defined(CONFIG_X86_64) && defined(CONFIG_DEBUG_RODATA)
 /*
