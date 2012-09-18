Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170Ab2IRWPh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 18:15:37 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:48597 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400Ab2IRWPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 18:15:32 -0400
MIME-Version: 1.0
In-Reply-To: <1347670122-25824-1-git-send-email-yinghai@kernel.org>
References: <1347670122-25824-1-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 18 Sep 2012 16:15:10 -0600
Message-ID: <CAErSpo54VVFHj4TDA5JELW0LwFVMXjVOJywwFQ4fo4C1rX69mQ@mail.gmail.com>
Subject: Re: [PATCH] PCI, x86: fix default vga ref_count
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Dave Airlie <airlied@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 6:48 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> when __ARCH_HAS_VGA_DEFAULT_DEVICE is not defined, aka EFIFB is not used,
>
> for static path, vga_default setting is through vga_arbiter_add_pci_device.
> and for x86 pci_fixup_video, will skip that.
> because subsys_initcall(vga_arb_device_init) come first to call vga_arbiter_add_pci_device.
>
> for hotplug path, even vga_arbiter_add_pci_device is called via notifier, but it
> will check VGA_RSRC_LEGACY_MASK that is not set for hotplug path.
> So x86 pci_fixup_video will take over to call vga_set_default_device().
>
> We need to hold one dev reference there.
>
> otherwise vga_arbiter_del_pci_device that does not check VGA_RSRC_LEGACY_MASK
> will call put_device and it will cause ref_count to decrease extra.
> that will have that device get deleted early wrongly.

I'm sure you're fixing a real bug, but this patch is completely unintelligible.

I tried to decipher the changelog and I failed.  I tried to figure out
the PCI reference counting from the vgaarb code, and I failed there
too.

Apparently the reference is connected with the vga_default device,
since that's what vga_arbiter_del_pci_device() checks, but
vga_set_default_device() is blissfully ignorant of references (and it
isn't used consistently anyway).

If you can do some rework to make this all make more sense, that would be great.

While you're at it, look at both the x86 and ia64 versions of
pci_fixup_video().  They are 90% identical, and it's not clear why
they should be different.  In fact, it's not clear why there's a fixup
for x86 and ia64 but not for any other architecture with PCI.

> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: x86@kernel.org
>
> ---
>  arch/x86/pci/fixup.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> Index: linux-2.6/arch/x86/pci/fixup.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/pci/fixup.c
> +++ linux-2.6/arch/x86/pci/fixup.c
> @@ -349,8 +349,12 @@ static void __devinit pci_fixup_video(st
>         if (config & (PCI_COMMAND_IO | PCI_COMMAND_MEMORY)) {
>                 pdev->resource[PCI_ROM_RESOURCE].flags |= IORESOURCE_ROM_SHADOW;
>                 dev_printk(KERN_DEBUG, &pdev->dev, "Boot video device\n");
> -               if (!vga_default_device())
> +               if (!vga_default_device()) {
> +#ifndef __ARCH_HAS_VGA_DEFAULT_DEVICE
> +                       pdev = pci_dev_get(pdev);
> +#endif
>                         vga_set_default_device(pdev);
> +               }
>         }
>  }
>  DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_ANY_ID, PCI_ANY_ID,
