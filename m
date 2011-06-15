Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949Ab1FOLRX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 07:17:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36743 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209Ab1FOLRU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 07:17:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=i62FepEseqlqh8+WVK2szGWtuXEXi1v0xqoV22lBXX2MTYy7/UI8fkob1/x4KRRZNt
         PB4u3KCmcIVF+QOgBp1cUmBj+YF4EwNqYIF4MdU0ubxbBkxD97MXox3KhZZ5gXPDWbfA
         vGQ45maDw+ilxVNbFCG2PIFFJOzvdjDgZyQhI=
MIME-Version: 1.0
In-Reply-To: <1308125533.4641.33.camel@nathan.suse.cz>
References: <1308125533.4641.33.camel@nathan.suse.cz>
From: Andrew Lutomirski <luto@mit.edu>
Date: Wed, 15 Jun 2011 07:17:00 -0400
X-Google-Sender-Auth: qZVRa-8elWZ8eN6wVbBvWkKaV7g
Message-ID: <BANLkTi=eGtMpcKaOBH_c_dt3GNQTbZ2fPQ@mail.gmail.com>
Subject: Re: bug: kernel 3.0-rc3 not relocatable on i386?
To: Petr Tesarik <ptesarik@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 4:12 AM, Petr Tesarik <ptesarik@suse.cz> wrote:
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

This could be a regression in
8c49d9a74bac5ea3f18480307057241b808fcc0c, but I haven't spotted it
yet.  I'm having trouble reproducing this, though: I see the
relocation in the output of relocs --text.

Can you send me your .config?  I'll fiddle with it.

--Andy
