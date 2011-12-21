Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab1LUErN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 23:47:13 -0500
Received: from exprod5og106.obsmtp.com ([64.18.0.182]:57176 "HELO
	exprod5og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752209Ab1LUErK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 23:47:10 -0500
From: Vinh Huu Tuong Nguyen <vhtnguyen@apm.com>
References: <1324385081-30824-1-git-send-email-vhtnguyen@apm.com> <CA+5PVA41Haf-_H3UoR1O3VFbC3XtgScyo5hekNjt0VWxunL-fg@mail.gmail.com>
In-Reply-To: <CA+5PVA41Haf-_H3UoR1O3VFbC3XtgScyo5hekNjt0VWxunL-fg@mail.gmail.com>
MIME-Version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acy/LHzKGGBQ7Q/yTfSYGQwsKBm7lAAaTq0A
Date: Wed, 21 Dec 2011 11:47:07 +0700
Message-ID: <e10be3d24de889e9e80d2fd76de9dcd8@mail.gmail.com>
Subject: RE: [PATCH 3/3] powerpc/44x: Add support PCI-E for APM821xx SoC and
 Bluestone board
To: Josh Boyer <jwboyer@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Anton Blanchard <anton@samba.org>,
        Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Tony Breeds <tony@bakeyournoodle.com>,
        Rob Herring <rob.herring@calxeda.com>, Jiri Kosina <jkosina@suse.cz>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Ayman El-Khashab <ayman@elkhashab.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Josh,
Please see below for my comments. If you have any concerns or suggestion,
please let me know.
Best regards,
Vinh Nguyen.

-----Original Message-----
From: Josh Boyer [mailto:jwboyer@gmail.com]
Sent: Tuesday, December 20, 2011 10:32 PM
To: Vinh Nguyen Huu Tuong
Cc: Benjamin Herrenschmidt; Paul Mackerras; Matt Porter; Kumar Gala; Paul
Gortmaker; Anton Blanchard; Dave Kleikamp; Grant Likely; Tony Breeds; Rob
Herring; Jiri Kosina; Lucas De Marchi; Ayman El-Khashab;
linuxppc-dev@lists.ozlabs.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] powerpc/44x: Add support PCI-E for APM821xx SoC
and Bluestone board

On Tue, Dec 20, 2011 at 7:44 AM, Vinh Nguyen Huu Tuong
<vhtnguyen@apm.com> wrote:
> This patch extends PCI-E driver to support PCI-E for APM821xx SoC on
Bluestone board.
>
> Signed-off-by: Vinh Nguyen Huu Tuong <vhtnguyen@apm.com>

> +static int apm821xx_pciex_init_port_hw(struct ppc4xx_pciex_port *port)
> +{
> +       u32 val;
> +       u32 utlset1;
> +       u32 timeout;
> +
> +       /*
> +        * Do a software reset on PCIe ports.
> +        * This code is to fix the issue that pci drivers doesn't
re-assign
> +        * bus number for PCIE devices after Uboot
> +        * scanned and configured all the buses (eg. PCIE NIC
IntelPro/1000
> +        * PT quad port, SAS LSI 1064E)
> +        */
> +
> +       mtdcri(SDR0, PESDR0_460EX_PHY_CTL_RST + (port->index * 0x55),
0x0);
> +       mdelay(10);
> +
> +       if (port->endpoint)
> +               val = PTYPE_LEGACY_ENDPOINT << 20;
> +       else
> +               val = PTYPE_ROOT_PORT << 20;
> +
> +       if (port->index == 0) {
> +               val |= LNKW_X1 << 12;
> +               utlset1 = 0x00000000;
> +       } else {
> +               val |= LNKW_X4 << 12;
> +               utlset1 = 0x20101101;
> +       }
> +
> +       mtdcri(SDR0, port->sdr_base + PESDRn_DLPSET, val);
> +       mtdcri(SDR0, port->sdr_base + PESDRn_UTLSET1, utlset1);
> +       mtdcri(SDR0, port->sdr_base + PESDRn_UTLSET2, 0x01010000);
> +
> +       switch (port->index) {
> +       case 0:
> +               mtdcri(SDR0, PESDR0_460EX_L0CDRCTL, 0x00003230);
> +               mtdcri(SDR0, PESDR0_460EX_L0DRV, 0x00000130);
> +               mtdcri(SDR0, PESDR0_460EX_L0CLK, 0x00000006);
> +
> +               mtdcri(SDR0, PESDR0_460EX_PHY_CTL_RST, 0x10000000);
> +               mdelay(50);
> +               mtdcri(SDR0, PESDR0_460EX_PHY_CTL_RST, 0x30000000);
> +               break;
> +
> +       case 1:
> +               mtdcri(SDR0, PESDR1_460EX_L0CDRCTL, 0x00003230);
> +               mtdcri(SDR0, PESDR1_460EX_L1CDRCTL, 0x00003230);
> +               mtdcri(SDR0, PESDR1_460EX_L2CDRCTL, 0x00003230);
> +               mtdcri(SDR0, PESDR1_460EX_L3CDRCTL, 0x00003230);
> +               mtdcri(SDR0, PESDR1_460EX_L0DRV, 0x00000130);
> +               mtdcri(SDR0, PESDR1_460EX_L1DRV, 0x00000130);
> +               mtdcri(SDR0, PESDR1_460EX_L2DRV, 0x00000130);
> +               mtdcri(SDR0, PESDR1_460EX_L3DRV, 0x00000130);
> +               mtdcri(SDR0, PESDR1_460EX_L0CLK, 0x00000006);
> +               mtdcri(SDR0, PESDR1_460EX_L1CLK, 0x00000006);
> +               mtdcri(SDR0, PESDR1_460EX_L2CLK, 0x00000006);
> +               mtdcri(SDR0, PESDR1_460EX_L3CLK, 0x00000006);
> +
> +               mtdcri(SDR0, PESDR1_460EX_PHY_CTL_RST, 0x10000000);
> +               break;
> +       }

Do we need a default case here to catch oddness and exit the function?
[Vinh Nguyen] we've already checked the port->index before calling this
function, so we assume that the port->index never exceed the checked
values.
> +
> +       mtdcri(SDR0, port->sdr_base + PESDRn_RCSSET,
> +               mfdcri(SDR0, port->sdr_base + PESDRn_RCSSET) |
> +               (PESDRx_RCSSET_RSTGU | PESDRx_RCSSET_RSTPYN));
> +
> +       /* Poll for PHY reset */
> +       timeout = 0;
> +       while ((!(mfdcri(SDR0, PESDR0_460EX_RSTSTA +
> +                       (port->index * 0x55)) & 0x1)) &&
> +                (timeout < PCIE_PHY_RESET_TIMEOUT)) {
> +               udelay(10);
> +               timeout++;
> +       }
> +
> +       if (timeout < PCIE_PHY_RESET_TIMEOUT) {
> +               mtdcri(SDR0, port->sdr_base + PESDRn_RCSSET,
> +                       (mfdcri(SDR0, port->sdr_base + PESDRn_RCSSET) &
> +                       ~(PESDRx_RCSSET_RSTGU | PESDRx_RCSSET_RSTDL)) |
> +                       PESDRx_RCSSET_RSTPYN);
> +
> +               port->has_ibpre = 1;
> +
> +               return 0;
> +       } else {
> +               printk(KERN_INFO "PCIE: Can't reset PHY\n");
> +               return -1;
> +       }

If we can't reset the PHY, does this whole function essentially fail?
Do the devices not get renumbered, etc?  If so, you probably want to
make that KERN_ERR.
[Vinh Nguyen] if we can't reset the PHY, maybe the device can't work
properly. I will update codes to return the error in case PHY can't reset.
> @@ -1751,9 +1856,9 @@ static void __init
ppc4xx_configure_pciex_PIMs(struct ppc4xx_pciex_port *port,
>                 * if it works
>                 */
>                out_le32(mbase + PECFG_PIM0LAL, 0x00000000);
> -               out_le32(mbase + PECFG_PIM0LAH, 0x00000000);
> +               out_le32(mbase + PECFG_PIM0LAH, 0x00000008); /* Moving
on HB */
>                out_le32(mbase + PECFG_PIM1LAL, 0x00000000);
> -               out_le32(mbase + PECFG_PIM1LAH, 0x00000000);
> +               out_le32(mbase + PECFG_PIM1LAH, 0x0000000c); /* Moving
on HB */
>                out_le32(mbase + PECFG_PIM01SAH, 0xffff0000);
>                out_le32(mbase + PECFG_PIM01SAL, 0x00000000);

Why are these values changed, and are those changes only needed on
APM821xx?
[Vinh Nguyen] In system memory map of 460EX chip, we have an "alias DDR
SDRAM" area that is Local Memory Alias for HB(high bandwidth), so we tried
to initialize it for speedup. For APM821xx, although we didn't mention
about this area, this configuration still works well. So we keep it.
> diff --git a/arch/powerpc/sysdev/ppc4xx_pci.h
b/arch/powerpc/sysdev/ppc4xx_pci.h
> index 32ce763..faf3017 100644
> --- a/arch/powerpc/sysdev/ppc4xx_pci.h
> +++ b/arch/powerpc/sysdev/ppc4xx_pci.h
> @@ -441,6 +441,7 @@
>  /*
>  * Config space register offsets
>  */
> +#define PECFG_ECDEVCTL         0x060
>  #define PECFG_ECRTCTL          0x074
>
>  #define PECFG_BAR0LMPA         0x210
> @@ -448,6 +449,7 @@
>  #define PECFG_BAR1MPA          0x218
>  #define PECFG_BAR2LMPA         0x220
>  #define PECFG_BAR2HMPA         0x224
> +#define PECFG_ECDEVCAPPA       0x25c
>
>  #define PECFG_PIMEN            0x33c
>  #define PECFG_PIM0LAL          0x340
> @@ -494,5 +496,7 @@ enum
>        LNKW_X8                 = 0x8
>  };
>
> +/* Timout for reset phy */
> +#define PCIE_PHY_RESET_TIMEOUT 10

Is this value applicable to all the 44x devices with PCI-e?
[Vinh Nguyen] At this time, we only checked this on APM821xx chips.
josh
