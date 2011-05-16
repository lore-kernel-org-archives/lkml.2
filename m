Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab1EPTxO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 15:53:14 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:60670 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755395Ab1EPTxK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 15:53:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DtURAXKpLMlZzhEKHqLgiIWSM1kBoG6zW8ua+ghk9YLKSk8vAPw6LiZ7bzZmfMmwjM
         ck+mCWN/bSviWqekMnU8m3u0qkGsDLN6s1w0pBxITiXi0S3IVKqYRU+S4Xfdd4cy6yuJ
         RAowxWVwv3ddJedM+WY2f9yJEp21+//xoYIt8=
MIME-Version: 1.0
In-Reply-To: <20110516185646.282418545@sbsiddha-MOBL3.sc.intel.com>
References: <20110516185646.282418545@sbsiddha-MOBL3.sc.intel.com>
Date: Mon, 16 May 2011 20:53:09 +0100
Message-ID: <BANLkTi=o0Z=Pc3KGDcZKr+a3OPWgb=iZrg@mail.gmail.com>
Subject: Re: [patch 1/4] x86, ioapic: fix potential resume deadlock
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 May 2011 19:56, Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> From: Daniel J Blueman <daniel.blueman@gmail.com>
> Subject: x86, ioapic: fix potential resume deadlock
>
> Fix a potential deadlock when resuming; here the calling function
> has disabled interrupts, so we cannot sleep.
>
> Change the memory allocation flag from GFP_KERNEL to GFP_ATOMIC.
>
> TODO: We can do away with this memory allocation during resume by
> reusing the ioapic suspend/resume code that uses boot time allocated
> buffers.
>
> Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Cc: stable@kernel.org   [v2.6.39]
> ---
>  arch/x86/kernel/apic/io_apic.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> Index: linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
> ===================================================================
> --- linux-2.6-tip.orig/arch/x86/kernel/apic/io_apic.c
> +++ linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
> @@ -621,14 +621,14 @@ struct IO_APIC_route_entry **alloc_ioapi
>        struct IO_APIC_route_entry **ioapic_entries;
>
>        ioapic_entries = kzalloc(sizeof(*ioapic_entries) * nr_ioapics,
> -                               GFP_KERNEL);
> +                               GFP_ATOMIC);
>        if (!ioapic_entries)
>                return 0;
>
>        for (apic = 0; apic < nr_ioapics; apic++) {
>                ioapic_entries[apic] =
>                        kzalloc(sizeof(struct IO_APIC_route_entry) *
> -                               nr_ioapic_registers[apic], GFP_KERNEL);
> +                               nr_ioapic_registers[apic], GFP_ATOMIC);
>                if (!ioapic_entries[apic])
>                        goto nomem;
>        }

I just tested this patch series (1-3) and it does addresses the resume
allocation failures I was consistently seeing (triggering your
warning); it passes nicely with full lock, allocation etc debugging,
so looks all good. Tested-by: Daniel J Blueman
<daniel.blueman@gmail.com>

Thanks, Suresh!

Daniel
-- 
Daniel J Blueman
