Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163Ab1FIPNo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 11:13:44 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:49059 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751372Ab1FIPNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 11:13:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=VDE3wMzzPaWy+o95Z54h+5bjnb47Usepqe1gBxo4v4aorskJxQG3Vm0h/5WJCYQedLhmY5MqjAOczv76Ku8iop+FWDSBTbA+rHX2J+3e7TATl4byPUC+B/ilck8O4zIx;
Date: Thu, 9 Jun 2011 08:13:30 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Dave Airlie <airlied@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>, steiner@sgi.com
Subject: Re: [PATCH] uv/x2apic: update for change in pci bridge handling.
Message-ID: <20110609081330.21a49d9d@jbarnes-desktop>
In-Reply-To: <BANLkTi=8JQWojj4UrH1iBYN=tWdx5AuOCA@mail.gmail.com>
References: <1306296049-11797-1-git-send-email-airlied@gmail.com>
	<BANLkTi=8JQWojj4UrH1iBYN=tWdx5AuOCA@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jun 2011 13:43:52 +1000
Dave Airlie <airlied@gmail.com> wrote:

> On Wed, May 25, 2011 at 2:00 PM, Dave Airlie <airlied@gmail.com> wrote:
> > From: Dave Airlie <airlied@redhat.com>
> >
> > I forgot about the special uv handling code for this, so this
> > patch fixes it up.
> 
> ping?
> 
> This fixes a warning and bug in Linus tree,
> 
>   CC      arch/x86/kernel/apic/x2apic_uv_x.o
> /home/airlied/git/linux-2.6/arch/x86/kernel/apic/x2apic_uv_x.c: In
> function ‘uv_system_init’:
> /home/airlied/git/linux-2.6/arch/x86/kernel/apic/x2apic_uv_x.c:882:2:
> warning: passing argument 1 of ‘pci_register_set_vga_state’ from
> incompatible pointer type [enabled by default]
> /home/airlied/git/linux-2.6/include/linux/pci.h:1094:13: note:
> expected ‘arch_set_vga_state_t’ but argument is of type ‘int
> (*)(struct pci_dev *, bool,  unsigned int,  bool)’
> 
> 
> Dave.
> 
> >
> > Signed-off-by: Dave Airlie <airlied@redhat.com>
> > ---
> >  arch/x86/kernel/apic/x2apic_uv_x.c |    8 ++++----
> >  drivers/pci/pci.c                  |    4 ++--
> >  2 files changed, 6 insertions(+), 6 deletions(-)
> >
> > diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
> > index 33b10a0..185cd1e 100644
> > --- a/arch/x86/kernel/apic/x2apic_uv_x.c
> > +++ b/arch/x86/kernel/apic/x2apic_uv_x.c
> > @@ -599,14 +599,14 @@ late_initcall(uv_init_heartbeat);
> >
> >  /* Direct Legacy VGA I/O traffic to designated IOH */
> >  int uv_set_vga_state(struct pci_dev *pdev, bool decode,
> > -                     unsigned int command_bits, bool change_bridge)
> > +                     unsigned int command_bits, u32 flags)
> >  {
> >        int domain, bus, rc;
> >
> > -       PR_DEVEL("devfn %x decode %d cmd %x chg_brdg %d\n",
> > -                       pdev->devfn, decode, command_bits, change_bridge);
> > +       PR_DEVEL("devfn %x decode %d cmd %x flags %d\n",
> > +                       pdev->devfn, decode, command_bits, flags);
> >
> > -       if (!change_bridge)
> > +       if (!(flags & PCI_VGA_STATE_CHANGE_BRIDGE))
> >                return 0;
> >
> >        if ((command_bits & PCI_COMMAND_IO) == 0)
> > diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> > index a339237..4528ee7 100644
> > --- a/drivers/pci/pci.c
> > +++ b/drivers/pci/pci.c
> > @@ -2862,11 +2862,11 @@ void __init pci_register_set_vga_state(arch_set_vga_state_t func)
> >  }
> >
> >  static int pci_set_vga_state_arch(struct pci_dev *dev, bool decode,
> > -                     unsigned int command_bits, bool change_bridge)
> > +                     unsigned int command_bits, u32 flags)
> >  {
> >        if (arch_set_vga_state)
> >                return arch_set_vga_state(dev, decode, command_bits,
> > -                                               change_bridge);
> > +                                               flags);
> >        return 0;
> >  }

Yeah, this is fine with me, you can push it through your tree.

Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center
