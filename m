Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083Ab0CVQ2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 12:28:31 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:36348 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754937Ab0CVQ23 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 12:28:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gPlWULw9W+E4CukHZI+kBSaTbZFAVfaaCP0HZ1oZ+d+uzLRSpYt3ObWwcrgDGz2Iac
         k0Iwpgbh/dRRlC3sCwr2NEyHCxzjIeY9F5meSQZFkxgqQVKB5Z1VrwKLeuAWKQrPn8yz
         YPmZO7AOpbelKxVVL83MvEIrq9nIB9Uf4/T3U=
MIME-Version: 1.0
In-Reply-To: <4BA72FC0.6060002@ladisch.de>
References: <4BA72FC0.6060002@ladisch.de>
Date: Mon, 22 Mar 2010 12:28:00 -0400
Message-ID: <a728f9f91003220928t4655180djabe16e36c3389a05@mail.gmail.com>
Subject: Re: [PATCH] PCI quirks: RS780/RS880: work around missing MSI 
	initialization
From: Alex Deucher <alexdeucher@gmail.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 4:52 AM, Clemens Ladisch <clemens@ladisch.de> wrote:
> AMD says in section 2.5.4 (GFX MSI Enable) of #43291 (AMD 780G Family
> Register Programming Requirements):
>
>  The SBIOS must enable internal graphics MSI capability in GCCFG by
>  setting the following: NBCFG.NB_CNTL.STRAP_MSI_ENABLE='1'
>
> Quite a few BIOS writers misinterpret this sentence and think that
> enabling MSI is an optional feature.  However, clearing that bit just
> prevents delivery of MSI messages but does not remove the MSI PCI
> capabilities registers, and so leaves these devices unusable for any
> driver that attempts to use MSI.
>
> Setting that bit is not possible after the BIOS has locked down the
> configuration registers, so we have to manually disable MSI for the
> affected devices.
>
> This fixes the codec communication errors in the HDA driver when
> accessing the HDMI audio device, and allows us to get rid of the
> overcautious quirk in radeon_irq_kms.c.

Looks good.  This works properly on my rs780.

Tested-by: Alex Deucher <alexdeucher@gamil.com>

>
> Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
> Cc: <stable@kernel.org>
> ---
>  drivers/pci/quirks.c                    |   31 +++++++++++++++++++++++++++++++
>  drivers/gpu/drm/radeon/radeon_irq_kms.c |    8 +-------
>  2 files changed, 32 insertions(+), 7 deletions(-)
>
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -2479,6 +2479,39 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AT
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x4375,
>                        quirk_msi_intx_disable_bug);
>
> +/*
> + * MSI does not work with the AMD RS780/RS880 internal graphics and HDMI audio
> + * devices unless the BIOS has initialized the nb_cntl.strap_msi_enable bit.
> + */
> +static void __init rs780_int_gfx_disable_msi(struct pci_dev *int_gfx_bridge)
> +{
> +       u32 nb_cntl;
> +
> +       if (!int_gfx_bridge->subordinate)
> +               return;
> +
> +       pci_bus_write_config_dword(int_gfx_bridge->bus, PCI_DEVFN(0, 0),
> +                                  0x60, 0);
> +       pci_bus_read_config_dword(int_gfx_bridge->bus, PCI_DEVFN(0, 0),
> +                                 0x64, &nb_cntl);
> +
> +       if (!(nb_cntl & BIT(10))) {
> +               dev_warn(&int_gfx_bridge->dev,
> +                        FW_WARN "RS780: MSI for internal graphics disabled\n");
> +               int_gfx_bridge->subordinate->bus_flags |= PCI_BUS_FLAGS_NO_MSI;
> +       }
> +}
> +
> +#define PCI_DEVICE_ID_AMD_RS780_P2P_INT_GFX    0x9602
> +
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD,
> +                       PCI_DEVICE_ID_AMD_RS780_P2P_INT_GFX,
> +                       rs780_int_gfx_disable_msi);
> +/* wrong vendor ID on M4A785TD motherboard: */
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ASUSTEK,
> +                       PCI_DEVICE_ID_AMD_RS780_P2P_INT_GFX,
> +                       rs780_int_gfx_disable_msi);
> +
>  #endif /* CONFIG_PCI_MSI */
>
>  #ifdef CONFIG_PCI_IOV
> --- a/drivers/gpu/drm/radeon/radeon_irq_kms.c
> +++ b/drivers/gpu/drm/radeon/radeon_irq_kms.c
> @@ -116,13 +116,7 @@ int radeon_irq_kms_init(struct radeon_de
>        }
>        /* enable msi */
>        rdev->msi_enabled = 0;
> -       /* MSIs don't seem to work on my rs780;
> -        * not sure about rs880 or other rs780s.
> -        * Needs more investigation.
> -        */
> -       if ((rdev->family >= CHIP_RV380) &&
> -           (rdev->family != CHIP_RS780) &&
> -           (rdev->family != CHIP_RS880)) {
> +       if (rdev->family >= CHIP_RV380) {
>                int ret = pci_enable_msi(rdev->pdev);
>                if (!ret) {
>                        rdev->msi_enabled = 1;
>
