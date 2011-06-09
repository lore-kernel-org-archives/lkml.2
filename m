Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509Ab1FIDn4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 23:43:56 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59438 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756070Ab1FIDnx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 23:43:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=s5fn1orDmRdhfQHLyfIPHBYuAaZ1iQL+s7lBM32GE986hPXj3yFjvL2vhmlGOy8Mf5
         ATgHovwpPphIPy9HvBIcnz+pb6sLEVscG8C9HbIgfrYxgcLGhK6xltGsdc/cvlrBw5qM
         EeFEOi3VOMc3KT8nHHWc2BZpAnrY2YIotTjBY=
MIME-Version: 1.0
In-Reply-To: <1306296049-11797-1-git-send-email-airlied@gmail.com>
References: <1306296049-11797-1-git-send-email-airlied@gmail.com>
Date: Thu, 9 Jun 2011 13:43:52 +1000
Message-ID: <BANLkTi=8JQWojj4UrH1iBYN=tWdx5AuOCA@mail.gmail.com>
Subject: Re: [PATCH] uv/x2apic: update for change in pci bridge handling.
From: Dave Airlie <airlied@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>, steiner@sgi.com
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 2:00 PM, Dave Airlie <airlied@gmail.com> wrote:
> From: Dave Airlie <airlied@redhat.com>
>
> I forgot about the special uv handling code for this, so this
> patch fixes it up.

ping?

This fixes a warning and bug in Linus tree,

  CC      arch/x86/kernel/apic/x2apic_uv_x.o
/home/airlied/git/linux-2.6/arch/x86/kernel/apic/x2apic_uv_x.c: In
function ‘uv_system_init’:
/home/airlied/git/linux-2.6/arch/x86/kernel/apic/x2apic_uv_x.c:882:2:
warning: passing argument 1 of ‘pci_register_set_vga_state’ from
incompatible pointer type [enabled by default]
/home/airlied/git/linux-2.6/include/linux/pci.h:1094:13: note:
expected ‘arch_set_vga_state_t’ but argument is of type ‘int
(*)(struct pci_dev *, bool,  unsigned int,  bool)’


Dave.

>
> Signed-off-by: Dave Airlie <airlied@redhat.com>
> ---
>  arch/x86/kernel/apic/x2apic_uv_x.c |    8 ++++----
>  drivers/pci/pci.c                  |    4 ++--
>  2 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
> index 33b10a0..185cd1e 100644
> --- a/arch/x86/kernel/apic/x2apic_uv_x.c
> +++ b/arch/x86/kernel/apic/x2apic_uv_x.c
> @@ -599,14 +599,14 @@ late_initcall(uv_init_heartbeat);
>
>  /* Direct Legacy VGA I/O traffic to designated IOH */
>  int uv_set_vga_state(struct pci_dev *pdev, bool decode,
> -                     unsigned int command_bits, bool change_bridge)
> +                     unsigned int command_bits, u32 flags)
>  {
>        int domain, bus, rc;
>
> -       PR_DEVEL("devfn %x decode %d cmd %x chg_brdg %d\n",
> -                       pdev->devfn, decode, command_bits, change_bridge);
> +       PR_DEVEL("devfn %x decode %d cmd %x flags %d\n",
> +                       pdev->devfn, decode, command_bits, flags);
>
> -       if (!change_bridge)
> +       if (!(flags & PCI_VGA_STATE_CHANGE_BRIDGE))
>                return 0;
>
>        if ((command_bits & PCI_COMMAND_IO) == 0)
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index a339237..4528ee7 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -2862,11 +2862,11 @@ void __init pci_register_set_vga_state(arch_set_vga_state_t func)
>  }
>
>  static int pci_set_vga_state_arch(struct pci_dev *dev, bool decode,
> -                     unsigned int command_bits, bool change_bridge)
> +                     unsigned int command_bits, u32 flags)
>  {
>        if (arch_set_vga_state)
>                return arch_set_vga_state(dev, decode, command_bits,
> -                                               change_bridge);
> +                                               flags);
>        return 0;
>  }
>
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
