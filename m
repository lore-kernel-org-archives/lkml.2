Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab2FONoY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 09:44:24 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:49252 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814Ab2FONoW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 09:44:22 -0400
MIME-Version: 1.0
In-Reply-To: <20120615103153.3ea7c009@endymion.delvare>
References: <20120613094739.360967aa@endymion.delvare> <1339606749-4578-1-git-send-email-andrew@asquaredlabs.com>
 <1339606749-4578-4-git-send-email-andrew@asquaredlabs.com> <20120615103153.3ea7c009@endymion.delvare>
From: Andrew Armenia <andrew@asquaredlabs.com>
Date: Fri, 15 Jun 2012 09:43:40 -0400
Message-ID: <CA+jCKRVsMNf7Yj7fP4c6+4ff__v5qsea7rYYqHv25XFBi8v9yg@mail.gmail.com>
Subject: Re: [PATCH 3/3] i2c-piix4: support AMD auxiliary SMBus controller
To: Jean Delvare <khali@linux-fr.org>
Cc: Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 4:31 AM, Jean Delvare <khali@linux-fr.org> wrote:
> Hi Andrew,
>
> For next time... When you post or repost a patch series, please always
> start a new discussion thread (don't use Reply), otherwise discussion
> threading becomes very hard to follow, both in e-mail clients and
> online list archives.
>
> On Wed, 13 Jun 2012 12:59:09 -0400, Andrew Armenia wrote:
>> Some AMD chipsets, such as the SP5100, have an auxiliary SMBus
>> controller with a second set of registers. This patch adds
>> support for this auxiliary controller.
>>
>> Tested on ASUS KCMA-D8 motherboard.
>>
>> Signed-off-by: Andrew Armenia <andrew@asquaredlabs.com>
>> ---
>>  Documentation/i2c/busses/i2c-piix4 |   13 +++++--
>>  drivers/i2c/busses/Kconfig         |    6 +++-
>>  drivers/i2c/busses/i2c-piix4.c     |   69 ++++++++++++++++++++++++++++++++++--
>>  3 files changed, 82 insertions(+), 6 deletions(-)
>
> A few issues remaining in this patch:
>
>> diff --git a/Documentation/i2c/busses/i2c-piix4 b/Documentation/i2c/busses/i2c-piix4
>> index 475bb4a..474779e 100644
>> --- a/Documentation/i2c/busses/i2c-piix4
>> +++ b/Documentation/i2c/busses/i2c-piix4
>> @@ -8,12 +8,17 @@ Supported adapters:
>>      Datasheet: Only available via NDA from ServerWorks
>>    * ATI IXP200, IXP300, IXP400, SB600, SB700 and SB800 southbridges
>>      Datasheet: Not publicly available
>> +    SB700 register reference available at:
>> +    http://support.amd.com/us/Embedded_TechDocs/43009_sb7xx_rrg_pub_1.00.pdf
>> +  * AMD SP5100 (SB700 derivative found on some server mainboards)
>> +    Datasheet: Publicly available at the AMD website
>> +    http://support.amd.com/us/Embedded_TechDocs/44413.pdf
>>    * AMD Hudson-2
>>      Datasheet: Not publicly available
>>    * Standard Microsystems (SMSC) SLC90E66 (Victory66) southbridge
>>      Datasheet: Publicly available at the SMSC website http://www.smsc.com
>>
>> -Authors:
>> +Authors:
>
> Never include white-space changes in a non-cleanup patch, they make
> review and backporting harder.
>
>>       Frodo Looijaard <frodol@dds.nl>
>>       Philip Edelbrock <phil@netroedge.com>
>>
>> @@ -32,7 +37,7 @@ Description
>>
>>  The PIIX4 (properly known as the 82371AB) is an Intel chip with a lot of
>>  functionality. Among other things, it implements the PCI bus. One of its
>> -minor functions is implementing a System Management Bus. This is a true
>> +minor functions is implementing a System Management Bus. This is a true
>>  SMBus - you can not access it on I2C levels. The good news is that it
>>  natively understands SMBus commands and you do not have to worry about
>>  timing problems. The bad news is that non-SMBus devices connected to it can
>> @@ -68,6 +73,10 @@ this driver on those mainboards.
>>  The ServerWorks Southbridges, the Intel 440MX, and the Victory66 are
>>  identical to the PIIX4 in I2C/SMBus support.
>>
>> +The AMD SB700 and SP5100 chipsets implement two PIIX4-compatible SMBus
>> +controllers. If your BIOS initializes the secondary controller, it will
>> +be detected by this driver as an "Auxiliary SMBus Host Controller".
>> +
>>  If you own Force CPCI735 motherboard or other OSB4 based systems you may need
>>  to change the SMBus Interrupt Select register so the SMBus controller uses
>>  the SMI mode.
>> diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
>> index 7244c8b..2e7530a 100644
>> --- a/drivers/i2c/busses/Kconfig
>> +++ b/drivers/i2c/busses/Kconfig
>> @@ -133,7 +133,7 @@ config I2C_PIIX4
>>           ATI IXP300
>>           ATI IXP400
>>           ATI SB600
>> -         ATI SB700
>> +         ATI SB700/SP5100
>>           ATI SB800
>>           AMD Hudson-2
>>           Serverworks OSB4
>> @@ -143,6 +143,10 @@ config I2C_PIIX4
>>           Serverworks HT-1100
>>           SMSC Victory66
>>
>> +       Some AMD chipsets contain two PIIX4-compatible SMBus
>> +       controllers. This driver will attempt to use both controllers
>> +       on the SB700/SP5100, if they have been initialized by the BIOS.
>> +
>>         This driver can also be built as a module.  If so, the module
>>         will be called i2c-piix4.
>>
>> diff --git a/drivers/i2c/busses/i2c-piix4.c b/drivers/i2c/busses/i2c-piix4.c
>> index 8181963..85d3db9 100644
>> --- a/drivers/i2c/busses/i2c-piix4.c
>> +++ b/drivers/i2c/busses/i2c-piix4.c
>> @@ -21,11 +21,12 @@
>>     Supports:
>>       Intel PIIX4, 440MX
>>       Serverworks OSB4, CSB5, CSB6, HT-1000, HT-1100
>> -     ATI IXP200, IXP300, IXP400, SB600, SB700, SB800
>> +     ATI IXP200, IXP300, IXP400, SB600, SB700/SP5100, SB800
>>       AMD Hudson-2
>>       SMSC Victory66
>>
>> -   Note: we assume there can only be one device, with one SMBus interface.
>> +   Note: we assume there can only be one device, with one or more
>> +   SMBus interfaces.
>>  */
>>
>>  #include <linux/module.h>
>> @@ -60,6 +61,7 @@
>>  #define SMBIOSIZE    8
>>
>>  /* PCI Address Constants */
>> +#define SMBAUXBA     0x058
>
> AFAICS this is SB700-specific, so this should either be clarified in
> the name, or maybe we don't even want a name. After all, register
> offset is hard-coded in piix4_setup_sb800.
>
>>  #define SMBBA                0x090
>>  #define SMBHSTCFG    0x0D2
>>  #define SMBSLVC              0x0D3
>> @@ -293,6 +295,43 @@ static int __devinit piix4_setup_sb800(struct pci_dev *PIIX4_dev,
>>       return piix4_smba;
>>  }
>>
>> +static int __devinit piix4_setup_aux(struct pci_dev *PIIX4_dev,
>> +                             const struct pci_device_id *id,
>> +                             unsigned short base_reg_addr)
>> +{
>> +     /* Set up auxiliary SMBus controllers found on some
>> +      * AMD chipsets e.g. SP5100 (SB700 derivative) */
>> +
>> +     unsigned short piix4_smba;
>> +
>> +     /* Read address of auxiliary SMBus controller */
>> +     pci_read_config_word(PIIX4_dev, base_reg_addr, &piix4_smba);
>> +     piix4_smba &= 0xffe0;
>
> You must check bit 0 first. You want the I/O base to be set AND
> decoding thereof enabled, otherwise the controller can't be used.
>
> Also, mask 0xffe0 is OK for the SB700 but not for the SB600 which only
> has bits 3:1 marked as reserved. Given that reserved bits are supposed
> to be 0 anyway, I think it is OK to mask with 0xfff0 always.
>
>> +
>> +     if (piix4_smba == 0) {
>> +             dev_dbg(&PIIX4_dev->dev,
>> +                     "Auxiliary SMBus base address uninitialized");
>
> Missing trailing new line.
>
>> +
>
> Needless blank line.
>
>> +             return -ENODEV;
>> +     }
>> +
>
>> +     if (acpi_check_region(piix4_smba, SMBIOSIZE, piix4_driver.name))
>> +             return -ENODEV;
>> +
>> +     if (!request_region(piix4_smba, SMBIOSIZE, piix4_driver.name)) {
>> +             dev_err(&PIIX4_dev->dev, "Auxiliary SMBus region 0x%x "
>> +                     "already in use!\n", piix4_smba);
>> +             return -EBUSY;
>> +     }
>> +
>> +     dev_info(&PIIX4_dev->dev,
>> +             "Auxiliary SMBus Host Controller at 0x%x\n",
>> +             piix4_smba
>> +     );
>
> Undesirable line break.
>
>> +
>> +     return piix4_smba;
>> +}
>> +
>>  static int piix4_transaction(struct i2c_adapter *piix4_adapter)
>>  {
>>       int temp;
>> @@ -504,6 +543,7 @@ static DEFINE_PCI_DEVICE_TABLE(piix4_ids) = {
>>  MODULE_DEVICE_TABLE (pci, piix4_ids);
>>
>>  static struct i2c_adapter *piix4_main_adapter;
>> +static struct i2c_adapter *piix4_aux_adapter;
>>
>>  static int __devinit piix4_add_adapter(struct pci_dev *dev,
>>                                       unsigned short smba,
>> @@ -565,10 +605,28 @@ static int __devinit piix4_probe(struct pci_dev *dev,
>>       else
>>               retval = piix4_setup(dev, id);
>>
>> +     /* if no main SMBus found, give up */
>>       if (retval < 0)
>>               return retval;
>>
>> -     return piix4_add_adapter(dev, retval, &piix4_main_adapter);
>> +     /* try to register main SMBus adapter, give up if we can't */
>> +     retval = piix4_add_adapter(dev, retval, &piix4_main_adapter);
>> +     if (retval < 0)
>> +             return retval;
>> +
>> +     /* check for auxiliary SMBus on some AMD chipsets */
>> +     if (dev->vendor == PCI_VENDOR_ID_ATI &&
>> +         dev->device == PCI_DEVICE_ID_ATI_SBX00_SMBUS &&
>> +         dev->revision < 0x40) {
>> +             retval = piix4_setup_aux(dev, id, SMBAUXBA);
>> +             if (retval > 0) {
>> +                     /* try to add the aux adapter if it exists,
>> +                      * piix4_add_adapter will clean up if this fails */
>> +                     piix4_add_adapter(dev, retval, &piix4_aux_adapter);
>> +             }
>> +     }
>> +
>> +     return 0;
>>  }
>>
>>  static void __devinit piix4_adap_remove(struct i2c_adapter *adap)
>> @@ -590,6 +648,11 @@ static void __devexit piix4_remove(struct pci_dev *dev)
>>               piix4_adap_remove(piix4_main_adapter);
>>               piix4_main_adapter = NULL;
>>       }
>> +
>> +     if (piix4_aux_adapter) {
>> +             piix4_adap_remove(piix4_aux_adapter);
>> +             piix4_aux_adapter = NULL;
>> +     }
>>  }
>>
>>  static struct pci_driver piix4_driver = {
>
> I've fixed them all, and applied your patch. The whole series with my
> changes incorporated is now visible at:
> http://khali.linux-fr.org/devel/linux-3/jdelvare-i2c/
>
> I would appreciate if you could test them and confirm I didn't break
> anything. Your patches will then be merged in kernel 3.6.
>
> Thanks,
> --
> Jean Delvare

I've just tested your updated patches and nothing seems broken. Thanks
for your patience with a first time submitter.

-Andrew
