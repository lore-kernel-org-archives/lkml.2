Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab0DAPBx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 11:01:53 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:58581 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661Ab0DAPBq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 11:01:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QJWL4k0Bbw6NJUYnhXnFgUn9ynenYPiY9Afs8RYTRNoEWVDyNawymisEqGA/DcIFAG
         BcXV5/6Bg1IbcaUtgazRjG/wNVIJimOL2G1KnAx+klubvc+QLlQ7mYZx5n7lmuOcxgeY
         IJzrlwKKiD6yU+lP+GocjM5h9csFg99FisKSI=
MIME-Version: 1.0
In-Reply-To: <4BB43EE6.5040003@ladisch.de>
References: <alpine.LFD.2.00.1003301029250.3707@i5.linux-foundation.org>
	 <201003302316.45651.rjw@sisk.pl> <201004010313.32920.rjw@sisk.pl>
	 <u2ta728f9f91003311919lef17adc1s4ee009c7d18454e9@mail.gmail.com>
	 <4BB43EE6.5040003@ladisch.de>
Date: Thu, 1 Apr 2010 11:01:43 -0400
Message-ID: <t2ha728f9f91004010801tb1370b86t190fd31e146aa87e@mail.gmail.com>
Subject: Re: [Regression, post-rc2] Commit a5ee4eb7541 breaks OpenGL on RS780 
	(was: Re: Linux 2.6.34-rc3)
From: Alex Deucher <alexdeucher@gmail.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       dri-devel@lists.sourceforge.net, stable@kernel.org,
       Dave Airlie <airlied@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 1, 2010 at 2:36 AM, Clemens Ladisch <clemens@ladisch.de> wrote:
> Alex Deucher wrote:
>> On Wed, Mar 31, 2010 at 9:13 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>> On Tuesday 30 March 2010, Rafael J. Wysocki wrote:
>>>> >       PCI quirk: RS780/RS880: work around missing MSI initialization
>>>>
>>>> This one (commit a5ee4eb7541) broke OpenGL acceleration on my new test box
>>>> which happens to have a RS780.
>
> So it's better to disable MSI unconditionally.
>
> Rafael, can you check if MSI works for the HDMI audio device?
> (I'd guess it doesn't.)
>
>> I also have the attached patch queued in via Dave's tree to disable
>> MSI on all IGP chips for the time being.
>
> This disables MSI only for the graphics device.  I'd prefer to have
> the quirk on its bridge so that MSI gets disabled for the HDMI audio
> device too, to avoid having to duplicate this quirk in the snd-hda-intel
> driver.
>
> ==========
>
> PCI quirk: RS780/RS880: disable MSI completely
>
> The missing initialization of the nb_cntl.strap_msi_enable does not seem
> to be the only problem that prevents MSI, so that quirk is not
> sufficient to enable MSI on all machines.  To be safe, unconditionally
> disable MSI for the internal graphics and HDMI audio on these chipsets.
>
> Signed-off-by: Clemens Ladisch <clemens@ladisch.de>

Works fine here.

Tested-by: Alex Deucher <alexdeucher@gmail.com>

>
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -2123,6 +2123,8 @@ static void __devinit quirk_disable_msi(struct pci_dev *dev)
>        }
>  }
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_8131_BRIDGE, quirk_disable_msi);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, 0x9602, quirk_disable_msi);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ASUSTEK, 0x9602, quirk_disable_msi);
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, 0xa238, quirk_disable_msi);
>
>  /* Go through the list of Hypertransport capabilities and
> @@ -2495,39 +2497,6 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4374,
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4375,
>                        quirk_msi_intx_disable_bug);
>
> -/*
> - * MSI does not work with the AMD RS780/RS880 internal graphics and HDMI audio
> - * devices unless the BIOS has initialized the nb_cntl.strap_msi_enable bit.
> - */
> -static void __init rs780_int_gfx_disable_msi(struct pci_dev *int_gfx_bridge)
> -{
> -       u32 nb_cntl;
> -
> -       if (!int_gfx_bridge->subordinate)
> -               return;
> -
> -       pci_bus_write_config_dword(int_gfx_bridge->bus, PCI_DEVFN(0, 0),
> -                                  0x60, 0);
> -       pci_bus_read_config_dword(int_gfx_bridge->bus, PCI_DEVFN(0, 0),
> -                                 0x64, &nb_cntl);
> -
> -       if (!(nb_cntl & BIT(10))) {
> -               dev_warn(&int_gfx_bridge->dev,
> -                        FW_WARN "RS780: MSI for internal graphics disabled\n");
> -               int_gfx_bridge->subordinate->bus_flags |= PCI_BUS_FLAGS_NO_MSI;
> -       }
> -}
> -
> -#define PCI_DEVICE_ID_AMD_RS780_P2P_INT_GFX    0x9602
> -
> -DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD,
> -                       PCI_DEVICE_ID_AMD_RS780_P2P_INT_GFX,
> -                       rs780_int_gfx_disable_msi);
> -/* wrong vendor ID on M4A785TD motherboard: */
> -DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ASUSTEK,
> -                       PCI_DEVICE_ID_AMD_RS780_P2P_INT_GFX,
> -                       rs780_int_gfx_disable_msi);
> -
>  #endif /* CONFIG_PCI_MSI */
>
>  #ifdef CONFIG_PCI_IOV
>
