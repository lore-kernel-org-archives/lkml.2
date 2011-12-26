Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab1LZIAs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 03:00:48 -0500
Received: from exprod5og117.obsmtp.com ([64.18.0.149]:41821 "HELO
	exprod5og117.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753794Ab1LZIAl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 03:00:41 -0500
From: Vinh Huu Tuong Nguyen <vhtnguyen@apm.com>
References: <1324385081-30824-1-git-send-email-vhtnguyen@apm.com>
	<CA+5PVA41Haf-_H3UoR1O3VFbC3XtgScyo5hekNjt0VWxunL-fg@mail.gmail.com>
	<e10be3d24de889e9e80d2fd76de9dcd8@mail.gmail.com> <CA+5PVA4cjiUvn4YavkFs6Jx87YpO8yHZZbm4pcPJQn1r1cggUA@mail.gmail.com>
In-Reply-To: <CA+5PVA4cjiUvn4YavkFs6Jx87YpO8yHZZbm4pcPJQn1r1cggUA@mail.gmail.com>
MIME-Version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AczAHe41hWUqHAsyRCKkDyjswttozQDgxttg
Date: Mon, 26 Dec 2011 15:00:38 +0700
Message-ID: <adc28ecd196e3cb9af86094e039f01b6@mail.gmail.com>
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

-----Original Message-----
From: Josh Boyer [mailto:jwboyer@gmail.com]
Sent: Thursday, December 22, 2011 3:20 AM
To: Vinh Huu Tuong Nguyen
Cc: Benjamin Herrenschmidt; Paul Mackerras; Matt Porter; Kumar Gala; Paul
Gortmaker; Anton Blanchard; Dave Kleikamp; Grant Likely; Tony Breeds; Rob
Herring; Jiri Kosina; Lucas De Marchi; Ayman El-Khashab;
linuxppc-dev@lists.ozlabs.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] powerpc/44x: Add support PCI-E for APM821xx SoC
and Bluestone board

On Tue, Dec 20, 2011 at 11:47 PM, Vinh Huu Tuong Nguyen
<vhtnguyen@apm.com> wrote:
>> +
>> +       mtdcri(SDR0, port->sdr_base + PESDRn_RCSSET,
>> +               mfdcri(SDR0, port->sdr_base + PESDRn_RCSSET) |
>> +               (PESDRx_RCSSET_RSTGU | PESDRx_RCSSET_RSTPYN));
>> +
>> +       /* Poll for PHY reset */
>> +       timeout = 0;
>> +       while ((!(mfdcri(SDR0, PESDR0_460EX_RSTSTA +
>> +                       (port->index * 0x55)) & 0x1)) &&
>> +                (timeout < PCIE_PHY_RESET_TIMEOUT)) {
>> +               udelay(10);
>> +               timeout++;
>> +       }
>> +
>> +       if (timeout < PCIE_PHY_RESET_TIMEOUT) {
>> +               mtdcri(SDR0, port->sdr_base + PESDRn_RCSSET,
>> +                       (mfdcri(SDR0, port->sdr_base + PESDRn_RCSSET) &
>> +                       ~(PESDRx_RCSSET_RSTGU | PESDRx_RCSSET_RSTDL)) |
>> +                       PESDRx_RCSSET_RSTPYN);
>> +
>> +               port->has_ibpre = 1;
>> +
>> +               return 0;
>> +       } else {
>> +               printk(KERN_INFO "PCIE: Can't reset PHY\n");
>> +               return -1;
>> +       }
>
> If we can't reset the PHY, does this whole function essentially fail?
> Do the devices not get renumbered, etc?  If so, you probably want to
> make that KERN_ERR.
> [Vinh Nguyen] if we can't reset the PHY, maybe the device can't work
> properly. I will update codes to return the error in case PHY can't
reset.

OK.

>> @@ -1751,9 +1856,9 @@ static void __init
> ppc4xx_configure_pciex_PIMs(struct ppc4xx_pciex_port *port,
>>                 * if it works
>>                 */
>>                out_le32(mbase + PECFG_PIM0LAL, 0x00000000);
>> -               out_le32(mbase + PECFG_PIM0LAH, 0x00000000);
>> +               out_le32(mbase + PECFG_PIM0LAH, 0x00000008); /* Moving
> on HB */
>>                out_le32(mbase + PECFG_PIM1LAL, 0x00000000);
>> -               out_le32(mbase + PECFG_PIM1LAH, 0x00000000);
>> +               out_le32(mbase + PECFG_PIM1LAH, 0x0000000c); /* Moving
> on HB */
>>                out_le32(mbase + PECFG_PIM01SAH, 0xffff0000);
>>                out_le32(mbase + PECFG_PIM01SAL, 0x00000000);
>
> Why are these values changed, and are those changes only needed on
> APM821xx?
> [Vinh Nguyen] In system memory map of 460EX chip, we have an "alias DDR
> SDRAM" area that is Local Memory Alias for HB(high bandwidth), so we
tried
> to initialize it for speedup. For APM821xx, although we didn't mention
> about this area, this configuration still works well. So we keep it.

This function isn't just called for 460EX or APM821xx SoCs.  It's
called on any 4xx SoC with PCIe configured.
Is this change going to work on them all?  If not, it needs to be
conditionalized.
[Vinh Nguyen] I will update my codes as your comments. Please see next
submitted                                     codes.
>> diff --git a/arch/powerpc/sysdev/ppc4xx_pci.h
> b/arch/powerpc/sysdev/ppc4xx_pci.h
>> index 32ce763..faf3017 100644
>> --- a/arch/powerpc/sysdev/ppc4xx_pci.h
>> +++ b/arch/powerpc/sysdev/ppc4xx_pci.h
>> @@ -441,6 +441,7 @@
>>  /*
>>  * Config space register offsets
>>  */
>> +#define PECFG_ECDEVCTL         0x060
>>  #define PECFG_ECRTCTL          0x074
>>
>>  #define PECFG_BAR0LMPA         0x210
>> @@ -448,6 +449,7 @@
>>  #define PECFG_BAR1MPA          0x218
>>  #define PECFG_BAR2LMPA         0x220
>>  #define PECFG_BAR2HMPA         0x224
>> +#define PECFG_ECDEVCAPPA       0x25c
>>
>>  #define PECFG_PIMEN            0x33c
>>  #define PECFG_PIM0LAL          0x340
>> @@ -494,5 +496,7 @@ enum
>>        LNKW_X8                 = 0x8
>>  };
>>
>> +/* Timout for reset phy */
>> +#define PCIE_PHY_RESET_TIMEOUT 10
>
> Is this value applicable to all the 44x devices with PCI-e?
> [Vinh Nguyen] At this time, we only checked this on APM821xx chips.

Then it should probably be conditionalized somehow.  Or put as a
worst-case value that will work for them all.
[Vinh Nguyen] At this time, this definition is called in
apm821xx_pciex_init_port_hw function that is used only for apm821xx chip.
So I think it's ok, but as your recommendation, I'll check with various
boards that I have to get the best value and update it in next submitted
codes.
Best regards,
Vinh Nguyen.
