Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab1EJFcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 01:32:52 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:37957 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739Ab1EJFcv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 01:32:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UqGp7xtVneFnT7F6CaNHF9FKSAf1ORonNGXy+k9exh4soQsWVs6+hekc27LEzuj0Ir
         UGJ4v7MLt8RVMSTa2CB/j7p+iTQJGnxjEh0phhbScdb/Icn5F8M9BTtC7218VjMtd1Na
         qXYtqvcyJ90QOFwXPvkjaV0QEE48Pu42cZXjQ=
MIME-Version: 1.0
In-Reply-To: <1304908814-23369-1-git-send-email-daniel.blueman@gmail.com>
References: <1304908814-23369-1-git-send-email-daniel.blueman@gmail.com>
Date: Tue, 10 May 2011 13:32:50 +0800
Message-ID: <BANLkTi=H2hFmx1fBAocaU=UNrv_NisGqGg@mail.gmail.com>
Subject: Re: [PATCH] ioapic: fix potential resume deadlock
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        H Peter Anvin <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas, Ingo, HPA,

On 9 May 2011 10:40, Daniel J Blueman <daniel.blueman@gmail.com> wrote:
> Fix a potential deadlock when resuming; here the calling function
> has disabled interrupts, so we cannot sleep.
>
> Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
>
> ---
>  arch/x86/kernel/apic/io_apic.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index 45fd33d..df63620 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -621,14 +621,14 @@ struct IO_APIC_route_entry **alloc_ioapic_entries(void)
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

Any feedback on this? I tested it on 2.6.39-rc6 and it does address
the potential deadlock warning I receive when resuming from suspend.
If positive, it would be good to get into -rc8, as rc7 is released.

Thanks,
  Daniel
-- 
Daniel J Blueman
