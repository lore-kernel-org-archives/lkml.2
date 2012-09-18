Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689Ab2IRRVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 13:21:45 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52578 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab2IRRVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 13:21:44 -0400
MIME-Version: 1.0
In-Reply-To: <1347657078-32230-3-git-send-email-thierry.reding@avionic-design.de>
References: <1347657078-32230-1-git-send-email-thierry.reding@avionic-design.de>
 <1347657078-32230-3-git-send-email-thierry.reding@avionic-design.de>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 18 Sep 2012 11:21:21 -0600
Message-ID: <CAErSpo754W2TKr46V5FKwX43eusoOVjxkAWJ=kkB0BvRt_bJBw@mail.gmail.com>
Subject: Re: [PATCH 2/2] ARM: pci: Allow passing per-controller private data
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 3:11 PM, Thierry Reding
<thierry.reding@avionic-design.de> wrote:
> In order to allow drivers to specify private data for each controller,
> this commit adds a private_data field to the struct hw_pci. This field
> is an array of nr_controllers pointers that will be used to initialize
> the private_data field of the corresponding controller's pci_sys_data
> structure.

I guess you aren't changing the design here because struct hw_pci
already includes "nr_controllers," but having nr_controllers and a
private_data[] array sounds like something that might make it hard to
hot-add a host bridge after boot.

> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> ---
>  arch/arm/include/asm/mach/pci.h | 1 +
>  arch/arm/kernel/bios32.c        | 3 +++
>  2 files changed, 4 insertions(+)
>
> diff --git a/arch/arm/include/asm/mach/pci.h b/arch/arm/include/asm/mach/pci.h
> index 26c511f..736cb8d 100644
> --- a/arch/arm/include/asm/mach/pci.h
> +++ b/arch/arm/include/asm/mach/pci.h
> @@ -21,6 +21,7 @@ struct hw_pci {
>  #endif
>         struct pci_ops  *ops;
>         int             nr_controllers;
> +       void            **private_data;
>         int             (*setup)(int nr, struct pci_sys_data *);
>         struct pci_bus *(*scan)(int nr, struct pci_sys_data *);
>         void            (*preinit)(void);
> diff --git a/arch/arm/kernel/bios32.c b/arch/arm/kernel/bios32.c
> index 7288093..07a38d8 100644
> --- a/arch/arm/kernel/bios32.c
> +++ b/arch/arm/kernel/bios32.c
> @@ -442,6 +442,9 @@ static void __devinit pcibios_init_hw(struct hw_pci *hw, struct list_head *head)
>                 sys->map_irq = hw->map_irq;
>                 INIT_LIST_HEAD(&sys->resources);
>
> +               if (hw->private_data)
> +                       sys->private_data = hw->private_data[nr];
> +
>                 ret = hw->setup(nr, sys);
>
>                 if (ret > 0) {
> --
> 1.7.12
>
