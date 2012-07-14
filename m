Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545Ab2GNHxc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 03:53:32 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:63225 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883Ab2GNHx3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 03:53:29 -0400
Subject: Re: [PATCH] i2c: sis964: bus driver
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=iso-8859-1
From: =?iso-8859-1?Q?Amaury_Decr=EAme?= <amaury.decreme@gmail.com>
In-Reply-To: <CAErSpo5-ou3vjmHgjiOOd57PvWg_hez80U0k3AX_ydjb0pikvQ@mail.gmail.com>
Date: Sat, 14 Jul 2012 09:53:22 +0200
Cc: khali@linux-fr.org, linux-i2c@vger.kernel.org, amalysh@web.de,
        nelson@sis.com, ben-linux@fluff.org, w.sang@pengutronix.de,
        rob@landley.net, jeffrey.t.kirsher@intel.com,
        akpm@linux-foundation.org, davem@davemloft.net, joe@perches.com,
        ralf@linux-mips.org, dirk.brandewie@gmail.com,
        jayachandranc@netlogicmicro.com, Xiangzhen.Ye@csr.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, suzanne.decreme@gmail.com
Content-Transfer-Encoding: 8BIT
Message-Id: <9B830E94-C699-44FE-8034-1F663D50ADFD@gmail.com>
References: <1342172455-8530-1-git-send-email-amaury.decreme@gmail.com> <CAErSpo5-ou3vjmHgjiOOd57PvWg_hez80U0k3AX_ydjb0pikvQ@mail.gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(sorry for the spam, I needed to resend in text format...)

Hello,

You're right. In fact, I was thinking of add code in drivers/pci/quirk.c to unhide the SMBus for users who maybe needed it with the following code:

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1389,6 +1389,24 @@ DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_SI, PCI_DEVICE_ID_SI_962,           quirk_si
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_SI,       PCI_DEVICE_ID_SI_963,           quirk_sis_96x_smbus);
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_SI,       PCI_DEVICE_ID_SI_LPC,           quirk_sis_96x_smbus);

+
+/*
+ * SiS 964 south bridge: BIOS typically hides SMBus device...
+ */
+static void quirk_sis_964_smbus(struct pci_dev *dev)
+{
+       u8 val = 0;
+       pci_read_config_byte(dev, 0x76, &val);
+       if (!(val & 0x01)) {
+               dev_info(&dev->dev, "Enabling SiS 964 SMBus\n");
+               pci_write_config_byte(dev, 0x76, val | 0x01);
+       }
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SI,     PCI_DEVICE_ID_SI_964,
+                                                       quirk_sis_964_smbus);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_SI,       PCI_DEVICE_ID_SI_964,
+                                                       quirk_sis_964_smbus);


Still, I'm not quite sure if it is needed.

Thanks for the comments.



Le 13 juil. 2012 à 17:36, Bjorn Helgaas a écrit :

> On Fri, Jul 13, 2012 at 3:40 AM, Amaury Decrême
> <amaury.decreme@gmail.com> wrote:
>> This patch is a driver for SiS964 I2C bus.
>> 
>> It was forked from i2c-sis630 and modified with SiS datasheets.
>> 
>> Tested with kmemleak.
>> 
>> Signed-off-by: Amaury Decrême <amaury.decreme@gmail.com>
>> ---
>> Documentation/i2c/busses/i2c-sis964 |   34 ++
>> MAINTAINERS                         |   16 +
>> drivers/i2c/busses/Kconfig          |   12 +-
>> drivers/i2c/busses/Makefile         |    1 +
>> drivers/i2c/busses/i2c-sis964.c     |  575 +++++++++++++++++++++++++++++++++++
>> include/linux/pci_ids.h             |    1 +
>> 6 files changed, 638 insertions(+), 1 deletions(-)
>> create mode 100644 Documentation/i2c/busses/i2c-sis964
>> create mode 100644 drivers/i2c/busses/i2c-sis964.c
>> 
>> diff --git a/Documentation/i2c/busses/i2c-sis964 b/Documentation/i2c/busses/i2c-sis964
>> new file mode 100644
>> index 0000000..a831f1a
>> --- /dev/null
>> +++ b/Documentation/i2c/busses/i2c-sis964
>> @@ -0,0 +1,34 @@
>> +Kernel driver i2c-sis964
>> +
>> +Supported adapters:
>> +  * Silicon Integrated Systems Corp (SiS)
>> +       964 chipset (Datasheet by SiS)
>> +  * Possible other SiS chipsets with the same registers and clocks
>> +
>> +Author:        Amaury Decrême <amaury.decreme@gmail.com>
>> +
>> +Module Parameters
>> +-----------------
>> +
>> +* force = [1|0]        Forcibly enable the SIS964. DANGEROUS!
>> +                       This can be interesting for chipsets not named
>> +                       above to check if it works for you chipset,
>> +                       but DANGEROUS!
>> +
>> +* low_clock = [1|0]    1 = Set Host Master Clock to 28KHz (defaut 56Khz)
>> +
>> +Description
>> +-----------
>> +
>> +This SMBus driver is known to work on motherboards with the SiS964 chipset.
>> +
>> +If you see something like this:
>> +
>> +00:02.0 ISA bridge: Silicon Integrated Systems [SiS] SiS964 [MuTIOL Media IO]
>> +
>> +in your 'lspci' output , then this driver is for your chipset.
>> +
>> +Thank You
>> +---------
>> +Alexander Malysh <amalysh@web.de>
>> +- Who has written i2c-sis630, from which i2c-sis964 is forked
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index eb22272..4a11805 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -6179,6 +6179,22 @@ S:       Maintained
>> F:     Documentation/i2c/busses/i2c-sis96x
>> F:     drivers/i2c/busses/i2c-sis96x.c
>> 
>> +SIS 964 I2C/SMBUS DRIVER
>> +M:     "Amaury Decrême" <amaury.decreme@gmail.com>
>> +L:     linux-i2c@vger.kernel.org
>> +S:     Maintained
>> +F:     Documentation/i2c/busses/i2c-sis96i4
>> +F:     drivers/i2c/busses/i2c-sis964.c
>> +
>> +SIS FRAMEBUFFER DRIVER
>> +M:     Thomas Winischhofer <thomas@winischhofer.net>
>> +W:     http://www.winischhofer.net/linuxsisvga.shtml
>> +S:     Maintained
>> +F:     Documentation/fb/sisfb.txt
>> +F:     drivers/video/sis/
>> +F:     include/video/sisfb.h
>> +
>> +SIS USB2VGA DRIVER
>> SIS FRAMEBUFFER DRIVER
>> M:     Thomas Winischhofer <thomas@winischhofer.net>
>> W:     http://www.winischhofer.net/linuxsisvga.shtml
>> diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
>> index 7244c8b..8dc9f90 100644
>> --- a/drivers/i2c/busses/Kconfig
>> +++ b/drivers/i2c/busses/Kconfig
>> @@ -189,8 +189,18 @@ config I2C_SIS630
>>          This driver can also be built as a module.  If so, the module
>>          will be called i2c-sis630.
>> 
>> +config I2C_SIS964
>> +       tristate "SiS 964"
>> +       depends on PCI && EXPERIMENTAL
>> +       help
>> +         If you say yes to this option, support will be included for the SiS
>> +         964 SMBus (a subset of I2C) interfaces.
>> +
>> +         This driver can also be built as a module.  If so, the module
>> +         will be called i2c-sis964.
>> +
>> config I2C_SIS96X
>> -       tristate "SiS 96x"
>> +       tristate "SiS 96x (but SiS964)"
>>        depends on PCI
>>        help
>>          If you say yes to this option, support will be included for the SiS
>> diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
>> index ce3c2be..b985bc8 100644
>> --- a/drivers/i2c/busses/Makefile
>> +++ b/drivers/i2c/busses/Makefile
>> @@ -19,6 +19,7 @@ obj-$(CONFIG_I2C_NFORCE2_S4985)       += i2c-nforce2-s4985.o
>> obj-$(CONFIG_I2C_PIIX4)                += i2c-piix4.o
>> obj-$(CONFIG_I2C_SIS5595)      += i2c-sis5595.o
>> obj-$(CONFIG_I2C_SIS630)       += i2c-sis630.o
>> +obj-$(CONFIG_I2C_SIS964)       += i2c-sis964.o
>> obj-$(CONFIG_I2C_SIS96X)       += i2c-sis96x.o
>> obj-$(CONFIG_I2C_VIA)          += i2c-via.o
>> obj-$(CONFIG_I2C_VIAPRO)       += i2c-viapro.o
>> diff --git a/drivers/i2c/busses/i2c-sis964.c b/drivers/i2c/busses/i2c-sis964.c
>> new file mode 100644
>> index 0000000..9f4ed14
>> --- /dev/null
>> +++ b/drivers/i2c/busses/i2c-sis964.c
>> @@ -0,0 +1,575 @@
>> +/*
>> +    Copyright (c) 2012 Amaury Decrême <amaury.decreme@gmail.com>
>> +
>> +    This program is free software; you can redistribute it and/or modify
>> +    it under the terms of the GNU General Public License as published by
>> +    the Free Software Foundation; either version 2 of the License, or
>> +    (at your option) any later version.
>> +
>> +    This program is distributed in the hope that it will be useful,
>> +    but WITHOUT ANY WARRANTY; without even the implied warranty of
>> +    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> +    GNU General Public License for more details.
>> +
>> +    You should have received a copy of the GNU General Public License
>> +    along with this program; if not, write to the Free Software
>> +    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>> +*/
>> +
>> +/*
>> +   Changes:
>> +   11.08.2011
>> +       Fork of original i2c-sis630 - Alexander Malysh <amalysh@web.de>
>> +       Adapted for SiS964 with datasheets
>> +                       - Amaury Decrême <amaury.decreme@gmail.com>
>> +*/
>> +
>> +/*
>> +   Supports:
>> +       SIS 964
>> +
>> +   Note: we assume there can only be one device, with one SMBus interface.
>> +*/
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/delay.h>
>> +#include <linux/pci.h>
>> +#include <linux/ioport.h>
>> +#include <linux/init.h>
>> +#include <linux/i2c.h>
>> +#include <linux/acpi.h>
>> +#include <linux/io.h>
>> +
>> +/* SIS964 SMBus registers */
>> +#define SMB_STS                        0xE0    /* status */
>> +#define SMB_EN                 0xE1    /* status enable */
>> +#define SMB_CNT                        0xE2    /* Control */
>> +#define SMBHOST_CNT            0xE3    /* Host Control */
>> +#define SMB_ADDR               0xE4    /* Address */
>> +#define SMB_CMD                        0xE5    /* Command */
>> +#define SMB_PERRCHK            0xE6    /* Packet Error Check */
>> +#define SMB_COUNT              0xE7    /* Byte Count */
>> +#define SMB_BYTE               0xE8    /* ~0x8F data byte field */
>> +#define SMBDEV_ADDR            0xF0    /* Device Address */
>> +#define SMB_DB0                        0xF1    /* Device byte0 */
>> +#define SMB_DB1                        0xF2    /* Device byte1 */
>> +#define SMB_SAA                        0xF3    /* Host slave alias address */
>> +#define SMB_PCOUNT             0xF4    /* processed byte count */
>> +
>> +
>> +/* SMB_STS register */
>> +#define SMBALT_STS             0x80    /* Slave alert */
>> +#define BYTE_DONE_STS          0x10    /* Byte Done Status / Block Array */
>> +#define SMBMAS_STS             0x08    /* Host Master */
>> +#define SMBCOL_STS             0x04    /* Collision */
>> +#define SMBERR_STS             0x02    /* Device error */
>> +
>> +/* SMB_CNT register */
>> +#define SMBCLK_SEL             0x20    /* Host master clock selection */
>> +#define SMB_PROBE              0x02    /* Bus Probe */
>> +#define SMB_HOSTBUSY           0x01    /* Host Busy */
>> +
>> +/* SMBHOST_CNT register */
>> +#define SMB_KILL               0x20    /* Kill */
>> +#define SMB_START              0x10    /* Start */
>> +#define SMB_PTL                        0x07    /* Command Protocol */
>> +
>> +
>> +/* SMB_ADDR register */
>> +#define SMB_ADDRESS            0xFE    /* Adress */
>> +#define SMB_RW                 0x01    /* Read/Write */
>> +
>> +
>> +/* SMB_BYTE register */
>> +#define SMB_BYTE0              0xFF    /* Byte 0 */
>> +#define SMB_BYTE1              0xFF00  /* Byte 1 */
>> +
>> +/* register count for request_region */
>> +#define SIS964_SMB_IOREGION    21
>> +
>> +/* PCI address constants */
>> +/* acpi base address register  */
>> +#define SIS964_ACPI_BASE_REG   0x74
>> +/* bios control register */
>> +#define SIS964_BIOS_CTL_REG    0x40
>> +
>> +/* Other settings */
>> +#define MAX_TIMEOUT            500
>> +
>> +/* SIS964 constants */
>> +#define SIS964_QUICK           0x00
>> +#define SIS964_BYTE            0x01
>> +#define SIS964_BYTE_DATA       0x02
>> +#define SIS964_WORD_DATA       0x03
>> +#define SIS964_PCALL           0x04
>> +#define SIS964_BLOCK_DATA      0x05
>> +
>> +static struct pci_driver sis964_driver;
>> +
>> +/* insmod parameters */
>> +static bool low_clock;
>> +static bool force;
>> +module_param(low_clock, bool, 0);
>> +MODULE_PARM_DESC(low_clock, "Set Host Master Clock to 28KHz (default 56KHz).");
>> +module_param(force, bool, 0);
>> +MODULE_PARM_DESC(force, "Forcibly enable the SIS964. DANGEROUS!");
>> +
>> +/* acpi base address */
>> +static unsigned short acpi_base;
>> +
>> +/* supported chips */
>> +static int supported[] = {
>> +       PCI_DEVICE_ID_SI_964,
>> +       0 /* terminates the list */
>> +};
>> +
>> +static inline u8 sis964_read(u8 reg)
>> +{
>> +       return inb(acpi_base + reg);
>> +}
>> +
>> +static inline void sis964_write(u8 reg, u8 data)
>> +{
>> +       outb(data, acpi_base + reg);
>> +}
>> +
>> +static int sis964_transaction_start(struct i2c_adapter *adap,
>> +                                       int ptl, u8 *oldclock)
>> +{
>> +       int tmp = 0;
>> +
>> +       /* Clear status register */
>> +       sis964_write(SMB_STS, 0xFF);
>> +
>> +       /* Make sure the SMBus host is ready to start transmitting. */
>> +       tmp = sis964_read(SMB_CNT);
>> +       if (tmp & (SMB_PROBE | SMB_HOSTBUSY)) {
>> +               dev_dbg(&adap->dev,
>> +                       "Bus busy (status 0x%02x). Killing transaction.\n",
>> +                       tmp);
>> +
>> +               sis964_write(SMBHOST_CNT, SMB_KILL);
>> +
>> +               return -EBUSY;
>> +       }
>> +
>> +       /* Set Host Master Clock to 28KHz if requested */
>> +       if (low_clock) {
>> +               *oldclock = sis964_read(SMB_CNT);
>> +               sis964_write(SMB_CNT, SMBCLK_SEL);
>> +       }
>> +
>> +       /* start the transaction by setting bit start and protocol */
>> +       sis964_write(SMBHOST_CNT, SMB_START | (ptl & SMB_PTL));
>> +
>> +       return 0;
>> +}
>> +
>> +static int sis964_transaction_wait(struct i2c_adapter *adap, int ptl)
>> +{
>> +       int tmp = 0, timeout = 0;
>> +
>> +       /* Wait 30us, valid for 28Khz and 56Khz */
>> +       udelay(30);
>> +
>> +       tmp = sis964_read(SMB_STS);
>> +       if (!(tmp & SMB_PROBE) && (tmp & SMB_HOSTBUSY)) {
>> +               dev_dbg(&adap->dev,
>> +                       "Host busy (status 0x%02x). Restarting transaction.\n",
>> +                       tmp);
>> +               sis964_write(SMBHOST_CNT, SMB_KILL);
>> +               return -EAGAIN;
>> +       }
>> +
>> +       while (!(ptl == SIS964_BLOCK_DATA && (tmp & BYTE_DONE_STS))
>> +               && !(tmp & (SMBMAS_STS | SMBCOL_STS | SMBERR_STS))
>> +               && (timeout++ < MAX_TIMEOUT)) {
>> +
>> +               /* Datasheets: wait 4ms max at 28Khz and
>> +                * 2ms max at 56Khz for 8 bytes */
>> +               if (low_clock)
>> +                       udelay(4000);
>> +               else
>> +                       udelay(2000);
>> +               tmp = sis964_read(SMB_STS);
>> +       }
>> +
>> +       /* If the SMBus is still busy, we give up */
>> +       if (timeout > MAX_TIMEOUT) {
>> +               dev_dbg(&adap->dev,
>> +                       "Bus Timeout (status 0x%02x)!\n", tmp);
>> +               return -ETIMEDOUT;
>> +       }
>> +
>> +       if (tmp & SMBERR_STS) {
>> +               dev_dbg(&adap->dev,
>> +                       "Failed bus transaction (status 0x%02x)!\n", tmp);
>> +               return -ENXIO;
>> +       }
>> +
>> +       if (tmp & SMBCOL_STS) {
>> +               dev_err(&adap->dev,
>> +                       "Bus collision (status 0x%02x)!\n", tmp);
>> +               sis964_write(SMB_STS, tmp & ~SMBCOL_STS);
>> +               return -EAGAIN;
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static void sis964_transaction_end(u8 oldclock)
>> +{
>> +       /* clear all status "sticky" bits */
>> +       sis964_write(SMB_STS, 0xFF);
>> +
>> +       /* restore old Host Master Clock if low_clock is set */
>> +       if (low_clock)
>> +               sis964_write(SMB_CNT, oldclock & SMBCLK_SEL);
>> +}
>> +
>> +static int sis964_transaction(struct i2c_adapter *adap, int ptl)
>> +{
>> +       int tmp = 0, timeout = 0;
>> +       u8 oldclock = 0;
>> +
>> +       do {
>> +               tmp = sis964_transaction_start(adap, ptl, &oldclock);
>> +               if (tmp)
>> +                       return tmp;
>> +
>> +               tmp = sis964_transaction_wait(adap, ptl);
>> +               sis964_transaction_end(oldclock);
>> +       } while (tmp == -EAGAIN && timeout++ < MAX_TIMEOUT);
>> +
>> +       if (timeout > MAX_TIMEOUT) {
>> +               dev_dbg(&adap->dev, "Bus timeout !\n");
>> +               return -ETIMEDOUT;
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static int sis964_block_data_read(struct i2c_adapter *adap,
>> +                               union i2c_smbus_data *data)
>> +{
>> +       int i, len = 0, tmp = 0;
>> +       u8 oldclock = 0;
>> +
>> +       data->block[0] = len = 0;
>> +
>> +       tmp = sis964_transaction_start(adap, SIS964_BLOCK_DATA, &oldclock);
>> +       if (tmp)
>> +               return tmp;
>> +
>> +       do {
>> +               tmp = sis964_transaction_wait(adap, SIS964_BLOCK_DATA);
>> +               if (tmp) {
>> +                       dev_dbg(&adap->dev, "Transaction wait failed\n");
>> +                       break;
>> +               }
>> +
>> +               /* if this first transaction then read byte count */
>> +               if (len == 0)
>> +                       data->block[0] = sis964_read(SMB_COUNT);
>> +
>> +               if (data->block[0] > 32)
>> +                       data->block[0] = 32;
>> +
>> +               dev_dbg(&adap->dev, "Block data read len=0x%x\n",
>> +                       data->block[0]);
>> +
>> +               for (i = 0; i < 8 && len < data->block[0]; i++, len++) {
>> +                       dev_dbg(&adap->dev, "Read i=%d len=%d\n", i, len);
>> +                       data->block[len+1] = sis964_read(SMB_BYTE+i);
>> +               }
>> +
>> +               /* clear BYTE_DONE_STS */
>> +               sis964_write(SMB_STS, BYTE_DONE_STS);
>> +       } while (len < data->block[0]);
>> +
>> +       sis964_transaction_end(oldclock);
>> +
>> +       return 0;
>> +}
>> +
>> +
>> +static int sis964_block_data_write(struct i2c_adapter *adap,
>> +                               union i2c_smbus_data *data)
>> +{
>> +
>> +       int i, len = 0, tmp = 0;
>> +       u8 oldclock = 0;
>> +
>> +       len = data->block[0];
>> +       if (len < 0)
>> +               len = 0;
>> +       else if (len > 32)
>> +               len = 32;
>> +
>> +       sis964_write(SMB_COUNT, len);
>> +
>> +       for (i = 1; i <= len; i++) {
>> +               dev_dbg(&adap->dev, "Set data 0x%02x\n", data->block[i]);
>> +
>> +               /* set data */
>> +               sis964_write(SMB_BYTE+(i-1)%8, data->block[i]);
>> +               if (i == 8 || (len < 8 && i == len)) {
>> +
>> +                       /* first transaction */
>> +                       tmp = sis964_transaction_start(adap, SIS964_BLOCK_DATA,
>> +                                       &oldclock);
>> +                       if (tmp)
>> +                               return tmp;
>> +
>> +               } else if ((i-1)%8 == 7 || i == len) {
>> +                       if (i > 8) {
>> +                               dev_dbg(&adap->dev,
>> +                               "Clear smbary_sts len=%d i=%d\n", len, i);
>> +
>> +                               /*
>> +                                  If this is not first transaction,
>> +                                  we must clear sticky bit.
>> +                                  clear BYTE_DONE-STS
>> +                               */
>> +                               sis964_write(SMB_STS, BYTE_DONE_STS);
>> +                       }
>> +                       tmp = sis964_transaction_wait(adap,
>> +                                       SIS964_BLOCK_DATA);
>> +                       if (tmp) {
>> +                               dev_dbg(&adap->dev,
>> +                                       "Transaction wait failed\n");
>> +                               break;
>> +                       }
>> +               }
>> +       }
>> +
>> +       sis964_transaction_end(oldclock);
>> +
>> +       return 0;
>> +}
>> +
>> +static int sis964_block_data(struct i2c_adapter *adap,
>> +                               union i2c_smbus_data *data, int read_write)
>> +{
>> +       if (read_write == I2C_SMBUS_WRITE)
>> +               return sis964_block_data_write(adap, data);
>> +       else
>> +               return sis964_block_data_read(adap, data);
>> +}
>> +
>> +/* Return negative errno on error. */
>> +static s32 sis964_access(struct i2c_adapter *adap, u16 addr,
>> +                        unsigned short flags, char read_write,
>> +                        u8 command, int ptl, union i2c_smbus_data *data)
>> +{
>> +       int tmp = 0;
>> +
>> +       switch (ptl) {
>> +       case I2C_SMBUS_QUICK:
>> +               sis964_write(SMB_ADDR, ((addr << 1) & SMB_ADDRESS) |
>> +                                       (read_write & SMB_RW));
>> +               ptl = SIS964_QUICK;
>> +               break;
>> +       case I2C_SMBUS_BYTE:
>> +               sis964_write(SMB_ADDR, ((addr << 1) & SMB_ADDRESS) |
>> +                                       (read_write & SMB_RW));
>> +               if (read_write == I2C_SMBUS_WRITE)
>> +                       sis964_write(SMB_CMD, command);
>> +               ptl = SIS964_BYTE;
>> +               break;
>> +       case I2C_SMBUS_BYTE_DATA:
>> +               sis964_write(SMB_ADDR, ((addr << 1) & SMB_ADDRESS) |
>> +                                       (read_write & SMB_RW));
>> +               sis964_write(SMB_CMD, command);
>> +               if (read_write == I2C_SMBUS_WRITE)
>> +                       sis964_write(SMB_BYTE, data->byte);
>> +               ptl = SIS964_BYTE_DATA;
>> +               break;
>> +       case I2C_SMBUS_PROC_CALL:
>> +       case I2C_SMBUS_WORD_DATA:
>> +               sis964_write(SMB_ADDR, ((addr << 1) & SMB_ADDRESS) |
>> +                                       (read_write & SMB_RW));
>> +               sis964_write(SMB_CMD, command);
>> +               if (read_write == I2C_SMBUS_WRITE) {
>> +                       sis964_write(SMB_BYTE, data->word & SMB_BYTE0);
>> +                       sis964_write(SMB_BYTE + 1,
>> +                                       (data->word & SMB_BYTE1) >> 8);
>> +               }
>> +               ptl = (ptl == I2C_SMBUS_PROC_CALL ?
>> +                               SIS964_PCALL : SIS964_WORD_DATA);
>> +               break;
>> +       case I2C_SMBUS_BLOCK_DATA:
>> +               sis964_write(SMB_ADDR, ((addr << 1) & SMB_ADDRESS) |
>> +                                       (read_write & SMB_RW));
>> +               sis964_write(SMB_CMD, command);
>> +               ptl = SIS964_BLOCK_DATA;
>> +               return sis964_block_data(adap, data, read_write);
>> +       default:
>> +               dev_warn(&adap->dev, "Unsupported transaction %d\n",
>> +                        ptl);
>> +               return -EOPNOTSUPP;
>> +       }
>> +
>> +       tmp = sis964_transaction(adap, ptl);
>> +       if (tmp)
>> +               return tmp;
>> +
>> +       if (ptl != SIS964_PCALL &&
>> +               (read_write == I2C_SMBUS_WRITE || ptl == SIS964_QUICK)) {
>> +               return 0;
>> +       }
>> +
>> +       switch (ptl) {
>> +       case SIS964_BYTE:
>> +       case SIS964_BYTE_DATA:
>> +               data->byte = sis964_read(SMB_BYTE);
>> +               break;
>> +       case SIS964_PCALL:
>> +       case SIS964_WORD_DATA:
>> +               data->word = sis964_read(SMB_BYTE) +
>> +                               (sis964_read(SMB_BYTE + 1) << 8);
>> +               break;
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static u32 sis964_func(struct i2c_adapter *adapter)
>> +{
>> +       /* SMBus Command protocol supported */
>> +       return I2C_FUNC_SMBUS_QUICK |           /* Quick command */
>> +               I2C_FUNC_SMBUS_BYTE |           /* Send/Receive Byte */
>> +               I2C_FUNC_SMBUS_BYTE_DATA |      /* Read/Write Byte Data */
>> +               I2C_FUNC_SMBUS_WORD_DATA |      /* Read/Write Word Data */
>> +               I2C_FUNC_SMBUS_PROC_CALL |      /* Process Call */
>> +               I2C_FUNC_SMBUS_BLOCK_DATA;      /* Read/Write Block Data */
>> +}
>> +
>> +static int __devinit sis964_setup(struct pci_dev *sis964_dev)
>> +{
>> +       unsigned char b;
>> +       struct pci_dev *dummy = NULL;
>> +       int tmp = 0, i;
>> +
>> +       /* check for supported SiS devices */
>> +       for (i = 0; supported[i] > 0 && dummy == NULL; i++)
>> +               dummy = pci_get_device(PCI_VENDOR_ID_SI, supported[i], dummy);
>> +
>> +       if (dummy) {
>> +               pci_dev_put(dummy);
>> +       } else if (force) {
>> +               dev_err(&sis964_dev->dev,
>> +                       "WARNING: Can't detect SIS964 compatible device, but "
>> +                       "loading because of force option enabled\n");
>> +       } else {
>> +               return -ENODEV;
>> +       }
>> +
>> +
>> +       /*
>> +          Enable ACPI first , so we can accsess reg 74-75
>> +          in acpi io space and read acpi base addr
>> +       */
>> +       if (pci_read_config_byte(sis964_dev, SIS964_BIOS_CTL_REG, &b)) {
>> +               dev_err(&sis964_dev->dev, "Error: Can't read bios ctl reg\n");
>> +               return -ENODEV;
>> +       }
>> +       /* if ACPI already enabled , do nothing */
>> +       if (!(b & 0x80) &&
>> +           pci_write_config_byte(sis964_dev, SIS964_BIOS_CTL_REG, b | 0x80)) {
>> +               dev_err(&sis964_dev->dev, "Error: Can't enable ACPI\n");
>> +               return -ENODEV;
>> +       }
>> +
>> +       /* Determine the ACPI base address */
>> +       if (pci_read_config_word(sis964_dev, SIS964_ACPI_BASE_REG,
>> +                               &acpi_base)) {
>> +               dev_err(&sis964_dev->dev,
>> +                               "Error: Can't determine ACPI base address\n");
>> +               return -ENODEV;
>> +       }
>> +
>> +       dev_dbg(&sis964_dev->dev, "ACPI base at 0x%04x\n", acpi_base);
>> +
>> +       tmp = acpi_check_region(acpi_base + SMB_STS, SIS964_SMB_IOREGION,
>> +                                  sis964_driver.name);
>> +       if (tmp) {
>> +               acpi_base = 0;
>> +               return -ENODEV;
>> +       }
>> +
>> +       /* Everything is happy, let's grab the memory and set things up. */
>> +       if (!request_region(acpi_base + SMB_STS, SIS964_SMB_IOREGION,
>> +                           sis964_driver.name)) {
>> +               dev_err(&sis964_dev->dev,
>> +                       "SMBus registers 0x%04x-0x%04x already in use!\n",
>> +                       acpi_base + SMB_STS, acpi_base + SMB_SAA);
>> +               acpi_base = 0;
>> +               return -ENODEV;
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +
>> +static const struct i2c_algorithm smbus_algorithm = {
>> +       .smbus_xfer     = sis964_access,
>> +       .functionality  = sis964_func,
>> +};
>> +
>> +static struct i2c_adapter sis964_adapter = {
>> +       .owner          = THIS_MODULE,
>> +       .class          = I2C_CLASS_HWMON | I2C_CLASS_SPD,
>> +       .algo           = &smbus_algorithm,
>> +};
>> +
>> +static DEFINE_PCI_DEVICE_TABLE(sis964_ids) = {
>> +       { PCI_DEVICE(PCI_VENDOR_ID_SI, PCI_DEVICE_ID_SI_964) },
>> +       { 0 }
>> +};
>> +
>> +MODULE_DEVICE_TABLE(pci, sis964_ids);
>> +
>> +static int __devinit sis964_probe(struct pci_dev *dev,
>> +                                       const struct pci_device_id *id)
>> +{
>> +       if (sis964_setup(dev)) {
>> +               dev_err(&dev->dev,
>> +                      "SIS964 comp. bus not detected, module not inserted.\n");
>> +               return -ENODEV;
>> +       }
>> +
>> +       /* set up the sysfs linkage to our parent device */
>> +       sis964_adapter.dev.parent = &dev->dev;
>> +
>> +       snprintf(sis964_adapter.name, sizeof(sis964_adapter.name),
>> +                "SMBus SIS964 adapter at %04xh", acpi_base + SMB_STS);
>> +
>> +       return i2c_add_adapter(&sis964_adapter);
>> +}
>> +
>> +static void __devexit sis964_remove(struct pci_dev *dev)
>> +{
>> +       dev_dbg(&dev->dev, "sis964_remove");
>> +
>> +       if (acpi_base) {
>> +               i2c_del_adapter(&sis964_adapter);
>> +               release_region(acpi_base + SMB_STS, SIS964_SMB_IOREGION);
>> +               acpi_base = 0;
>> +       }
>> +}
>> +
>> +
>> +static struct pci_driver sis964_driver = {
>> +       .name           = "sis964_smbus",
>> +       .id_table       = sis964_ids,
>> +       .probe          = sis964_probe,
>> +       .remove         = __devexit_p(sis964_remove),
>> +};
>> +
>> +module_pci_driver(sis964_driver);
>> +
>> +MODULE_LICENSE("GPL");
>> +MODULE_AUTHOR("Amaury Decrême <amaury.decreme@gmail.com>");
>> +MODULE_DESCRIPTION("SiS964 SMBus driver");
>> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
>> index ab741b0..0ffc982 100644
>> --- a/include/linux/pci_ids.h
>> +++ b/include/linux/pci_ids.h
>> @@ -699,6 +699,7 @@
>> #define PCI_DEVICE_ID_SI_961           0x0961
>> #define PCI_DEVICE_ID_SI_962           0x0962
>> #define PCI_DEVICE_ID_SI_963           0x0963
>> +#define PCI_DEVICE_ID_SI_964           0x0964
> 
> Please read the comment at the top of this file; I don't think this
> addition qualifies as something that should be added.
> 
>> #define PCI_DEVICE_ID_SI_965           0x0965
>> #define PCI_DEVICE_ID_SI_966           0x0966
>> #define PCI_DEVICE_ID_SI_968           0x0968
>> --
>> 1.7.8.6
>> 

