Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759548Ab2CMDgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 23:36:20 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45600 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193Ab2CMDgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 23:36:12 -0400
Subject: Re: [PATCH] Added backlight driver for Acer Aspire 4736
From: Pradeep Subrahmanion <subrahmanion.pradeep@gmail.com>
To: joeyli <jlee@suse.com>
Cc: rpurdie@rpsys.net, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
In-Reply-To: <1331608245.10557.149.camel@linux-s257.site>
References: <CABNxG=CU+bOWUauLYfcS2vtFqKvXA-9axgokNoYz+KuU1Mzztw@mail.gmail.com>
	 <4F5D000E.8040104@gmx.de>  <1331608245.10557.149.camel@linux-s257.site>
Content-Type: multipart/mixed; boundary="=-ohF2s1RZUbPpbswLIEUE"
Date: Tue, 13 Mar 2012 09:12:40 -0400
Message-ID: <1331644360.3319.6.camel@debian.Gayathri>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ohF2s1RZUbPpbswLIEUE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

Hi Joey, 

yes , /sys/class/backlight/intel_backlight exists . I tried giving
acpi_backlight=vendor in grub config.Hot keys works like earlier.But
increasing brightness after maximum levels give blank screen(like
earlier). 

I have attached acpidump.
 
----
Thanks  , 
 
Pradeep Subrahmanion

On Tue, 2012-03-13 at 11:10 +0800, joeyli wrote:
> Hi Pradeep, 
> 
> 於 日，2012-03-11 於 19:42 +0000，Florian Tobias Schandinat 提到：
> > Hi,
> > 
> > On 03/11/2012 06:21 PM, Pradeep Subrahmanion wrote:
> > > Hi ,
> > > 
> > >          Brightness control was not  working on Acer Aspire 4736 using
> > > default ACPI interface.  acer-acpi also do not support 4730 series since
> > > it uses new WMI interface.
> > > This driver adds brightness control by accessing the LBB PCI
> > > configuration register. This approach may also work on other laptops in
> > > 4730 series .But currently ,  it is only tested  for 
> > > Aspire 4736.  
> > > 
> 
> Pleae check does there have following interface?
> 
> /sys/class/backlight/intel_backlight
> 
> And,
> did you try kernel parameter "acpi_backlight=vendor", does it work to
> you?
> 
> Please attach acpidump: acpidump > acpidump.dat
> 
> 
> Thanks
> Joey Lee
> 
> > > From 893031c1e9bdefd9642b98825062b5df98af0d77 Mon Sep 17 00:00:00 2001
> > > From: Pradeep Subrahmanion <subrahmanion.pradeep@gmail.com
> > > <mailto:subrahmanion.pradeep@gmail.com>>
> > > Date: Sun, 11 Mar 2012 23:11:23 -0400
> > > Subject: [PATCH] Added backlight driver for Acer Aspire 4736
> > > 
> > 
> > the commit message should be here, I think.
> > 
> > > 
> > > Signed-off-by: Pradeep Subrahmanion <subrahmanion.pradeep@gmail.com
> > > <mailto:subrahmanion.pradeep@gmail.com>>
> > 
> > Please resend this email in the correct format: As you can see in my
> > email the text version of your patch is severely screwed up and nobody
> > wants to even try converting a HTML format to a proper patch again,
> > probably most people won't even receive an email that has a HTML part as
> > their spam filter are going to handle it as spam. git send-email will
> > take care of it for you if you configure it for your account.
> > You should also cc Andrew Morton <akpm@linux-foundation.org> as he's the
> > one who handles backlight patches at the moment.
> > 
> > 
> > Best regards,
> > 
> > Florian Tobias Schandinat
> > 
> > > ---
> > >  drivers/video/backlight/acer4736_bl.c |  110
> > > +++++++++++++++++++++++++++++++++
> > >  1 files changed, 110 insertions(+), 0 deletions(-)
> > >  create mode 100644 drivers/video/backlight/acer4736_bl.c
> > > 
> > > diff --git a/drivers/video/backlight/acer4736_bl.c
> > > b/drivers/video/backlight/acer4736_bl.c
> > > new file mode 100644
> > > index 0000000..6fe2937
> > > --- /dev/null
> > > +++ b/drivers/video/backlight/acer4736_bl.c
> > > @@ -0,0 +1,110 @@
> > > +/*
> > > + * Backlight driver for Acer Aspire 4736
> > > + *
> > > + * Copyright (C) Pradeep Subrahmanion <subrahmanion.pradeep@gmail.com
> > > <mailto:subrahmanion.pradeep@gmail.com>>
> > > + *
> > > + * This program is free software; you can redistribute it and/or modify
> > > + * it under the terms of the GNU General Public License version 2 as
> > > + * published by the Free Software Foundation.
> > > + *
> > > + * This driver uses LBB PCI configuration register to change the
> > > + * backlight brightness.
> > > + *
> > > + */
> > > +
> > > +#include <linux/module.h>
> > > +#include <linux/kernel.h>
> > > +#include <linux/init.h>
> > > +#include <linux/backlight.h>
> > > +#include <linux/err.h>
> > > +#include <linux/dmi.h>
> > > +#include <linux/io.h>
> > > +#include <linux/pci.h>
> > > +
> > > +static u8 max_brightness = 0xFF;
> > > +static u8 lbb_offset =  0xF4;
> > > +static unsigned int device_id = 0x2a42;
> > > +static unsigned int vendor_id = 0x8086;
> > > +
> > > +struct backlight_device *acer_backlight_device;
> > > +struct pci_dev *pdev;
> > > +
> > > +static int acer_dmi_match(const struct dmi_system_id *id)
> > > +{
> > > + printk(KERN_INFO "acer4736_bl: %s detected\n", id->ident);
> > > + return 1;
> > > +}
> > > +
> > > +static const struct dmi_system_id __initdata acer_device_table[] = {
> > > +{
> > > + .callback = acer_dmi_match,
> > > + .ident = "Aspire 4736",
> > > + .matches = {
> > > + DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
> > > + DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 4736"),
> > > + },
> > > + },
> > > + {}
> > > +};
> > > +static int read_brightness(struct backlight_device *bd)
> > > +{
> > > + u8 result;
> > > + pci_read_config_byte(pdev, lbb_offset, &result);
> > > + return result;
> > > +}
> > > +
> > > +static int update_brightness(struct backlight_device *bd)
> > > +{
> > > + u8 intensity = bd->props.brightness;
> > > + if (intensity > max_brightness) {
> > > + printk(KERN_INFO "Acer4736_bl: Invalid parameter. Maximum value is %d"
> > > + , max_brightness);
> > > + return -1;
> > > + }
> > > + pci_write_config_byte(pdev, lbb_offset, intensity);
> > > + return 0;
> > > +}
> > > +static const struct  backlight_ops acer_backlight_ops = {
> > > + .get_brightness = read_brightness,
> > > + .update_status  = update_brightness,
> > > +};
> > > +
> > > +static int __init acer4736_bl_init(void)
> > > +{
> > > + struct backlight_properties props;
> > > + if (!dmi_check_system(acer_device_table))
> > > + return -ENODEV;
> > > +
> > > + pdev = pci_get_device(vendor_id, device_id, NULL);
> > > +
> > > + if (!pdev)
> > > + return -ENODEV;
> > > +
> > > + printk(KERN_INFO "Loading Acer 4736 backlight driver\n");
> > > + memset(&props, 0, sizeof(struct backlight_properties));
> > > + props.type = BACKLIGHT_RAW;
> > > + props.max_brightness = max_brightness;
> > > +
> > > + acer_backlight_device = backlight_device_register("acer_backlight",
> > > + NULL, NULL, &acer_backlight_ops, &props);
> > > + acer_backlight_device->props.max_brightness = max_brightness;
> > > + acer_backlight_device->props.brightness  =
> > > + read_brightness(acer_backlight_device);
> > > + backlight_update_status(acer_backlight_device);
> > > +
> > > + return 0;
> > > +}
> > > +
> > > +static void __exit acer4736_bl_exit(void)
> > > +{
> > > + pci_dev_put(pdev);
> > > + backlight_device_unregister(acer_backlight_device);
> > > +}
> > > +
> > > +module_init(acer4736_bl_init);
> > > +module_exit(acer4736_bl_exit);
> > > +
> > > +MODULE_AUTHOR("Pradeep Subrahmanion <subrahmanion.pradeep@gmail.com
> > > <mailto:subrahmanion.pradeep@gmail.com>>");
> > > +MODULE_DESCRIPTION("Acer Aspire 4736 Backlight Driver");
> > > +MODULE_LICENSE("GPL");
> > > +MODULE_DEVICE_TABLE(dmi, acer_device_table);
> > > -- 
> > > 1.7.2.5
> > > 
> > > -------------  
> > > 
> > > Pradeep Subrahmanion
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > 
> 
> 


--=-ohF2s1RZUbPpbswLIEUE
Content-Disposition: attachment; filename="acpidump.dat"
Content-Type: text/plain; name="acpidump.dat"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

DSDT @ 0xbbaec000
  0000: 44 53 44 54 d7 b4 00 00 01 e2 41 43 52 53 59 53  DSDT......ACRSYS
  0010: 41 43 52 50 52 44 43 54 01 00 00 00 31 30 32 35  ACRPRDCT....1025
  0020: 13 00 00 01 08 53 50 32 4f 0a 4e 08 53 50 31 4f  .....SP2O.N.SP1O
  0030: 0b 4e 16 08 49 4f 31 42 0b 00 06 08 49 4f 31 4c  .N..IO1B....IO1L
  0040: 0a 70 08 49 4f 32 42 0b 80 06 08 49 4f 32 4c 0a  .p.IO2B....IO2L.
  0050: 20 08 49 4f 33 42 0b 90 02 08 49 4f 33 4c 0a 10   .IO3B....IO3L..
  0060: 08 4d 43 48 42 0c 00 00 d1 fe 08 4d 43 48 4c 0b  .MCHB......MCHL.
  0070: 00 40 08 45 47 50 42 0c 00 90 d1 fe 08 45 47 50  .@.EGPB......EGP
  0080: 4c 0b 00 10 08 44 4d 49 42 0c 00 80 d1 fe 08 44  L....DMIB......D
  0090: 4d 49 4c 0b 00 10 08 49 46 50 42 0c 00 40 d1 fe  MIL....IFPB..@..
  00a0: 08 49 46 50 4c 0b 00 10 08 50 45 42 53 0c 00 00  .IFPL....PEBS...
  00b0: 00 e0 08 50 45 4c 4e 0c 00 00 00 10 08 54 54 54  ...PELN......TTT
  00c0: 42 0c 00 00 d2 fe 08 54 54 54 4c 0c 00 00 02 00  B......TTTL.....
  00d0: 08 53 4d 42 53 0b a0 ef 08 50 42 4c 4b 0b 10 04  .SMBS....PBLK...
  00e0: 08 50 4d 42 53 0b 00 04 08 50 4d 4c 4e 0a 80 08  .PMBS....PMLN...
  00f0: 4c 56 4c 32 0b 14 04 08 4c 56 4c 33 0b 15 04 08  LVL2....LVL3....
  0100: 4c 56 4c 34 0b 16 04 08 53 4d 49 50 0a b2 08 47  LVL4....SMIP...G
  0110: 50 42 53 0b 00 05 08 47 50 4c 4e 0a 40 08 41 50  PBS....GPLN.@.AP
  0120: 43 42 0c 00 00 c0 fe 08 41 50 43 4c 0b 00 10 08  CB......APCL....
  0130: 50 4d 33 30 0b 30 04 08 53 52 43 42 0c 00 c0 d1  PM30.0..SRCB....
  0140: fe 08 53 52 43 4c 0b 00 40 08 53 55 53 57 0a ff  ..SRCL..@.SUSW..
  0150: 08 41 43 50 48 0a de 08 41 53 53 42 00 08 41 4f  .ACPH...ASSB..AO
  0160: 54 42 00 08 41 41 58 42 00 08 50 45 48 50 01 08  TB..AAXB..PEHP..
  0170: 53 48 50 43 01 08 50 45 50 4d 01 08 50 45 45 52  SHPC..PEPM..PEER
  0180: 01 08 50 45 43 53 01 08 49 54 4b 45 00 08 54 52  ..PECS..ITKE..TR
  0190: 54 50 01 08 54 52 54 44 0a 02 08 54 52 54 49 0a  TP..TRTD...TRTI.
  01a0: 03 08 47 43 44 44 01 08 44 53 54 41 0a 0a 08 44  ..GCDD..DSTA...D
  01b0: 53 4c 4f 0a 0c 08 44 53 4c 43 0a 0e 08 50 49 54  SLO...DSLC...PIT
  01c0: 53 0a 10 08 53 42 43 53 0a 12 08 53 41 4c 53 0a  S...SBCS...SALS.
  01d0: 13 08 4c 53 53 53 0a 2a 08 50 53 53 53 0a 2b 08  ..LSSS.*.PSSS.+.
  01e0: 53 4f 4f 54 0a 35 08 45 53 43 53 0a 48 08 50 44  SOOT.5.ESCS.H.PD
  01f0: 42 52 0a 4d 08 53 4d 42 4c 0a 10 5b 80 47 50 49  BR.M.SMBL..[.GPI
  0200: 4f 01 0b 00 05 0a 3c 5b 81 19 47 50 49 4f 01 00  O.....<[..GPIO..
  0210: 40 16 00 08 00 03 4c 50 44 4c 01 00 01 4e 45 57  @.....LPDL...NEW
  0220: 44 01 5b 80 50 4d 42 41 01 0b 00 04 0a 80 5b 81  D.[.PMBA......[.
  0230: 26 50 4d 42 41 01 00 40 14 00 02 53 50 53 54 01  &PMBA..@...SPST.
  0240: 00 4d 0c 00 01 47 50 45 43 01 00 4e 10 00 09 53  .M...GPEC..N...S
  0250: 43 49 53 01 00 06 5b 80 52 43 52 42 00 0c 00 c0  CIS...[.RCRB....
  0260: d1 fe 0b 00 40 5b 81 48 05 52 43 52 42 13 00 80  ....@[.H.RCRB...
  0270: 00 08 00 80 00 10 00 80 02 02 48 50 41 53 02 00  ..........HPAS..
  0280: 05 48 50 41 45 01 00 48 09 00 01 50 41 54 44 01  .HPAE..H...PATD.
  0290: 53 41 54 44 01 53 4d 42 44 01 48 44 41 44 01 00  SATD.SMBD.HDAD..
  02a0: 0b 52 50 31 44 01 52 50 32 44 01 52 50 33 44 01  .RP1D.RP2D.RP3D.
  02b0: 52 50 34 44 01 52 50 35 44 01 52 50 36 44 01 5b  RP4D.RP5D.RP6D.[
  02c0: 80 4d 42 4f 58 00 0c 18 ec ab bb 0c bc 02 00 00  .MBOX...........
  02d0: 5b 81 4d 78 4d 42 4f 58 00 50 43 49 31 08 50 43  [.MxMBOX.PCI1.PC
  02e0: 49 32 08 50 43 49 33 08 50 43 49 34 08 50 43 49  I2.PCI3.PCI4.PCI
  02f0: 35 08 50 43 49 36 08 50 43 49 37 08 50 43 49 38  5.PCI6.PCI7.PCI8
  0300: 08 4e 4c 43 4b 08 5a 49 50 45 08 43 4f 4d 41 08  .NLCK.ZIPE.COMA.
  0310: 43 41 49 4f 08 43 41 49 50 08 43 41 4d 44 08 43  CAIO.CAIP.CAMD.C
  0320: 41 44 41 08 43 4f 4d 42 08 43 42 49 4f 08 43 42  ADA.COMB.CBIO.CB
  0330: 49 50 08 43 42 4d 44 08 43 42 44 41 08 46 48 53  IP.CBMD.CBDA.FHS
  0340: 44 08 43 4f 4d 43 08 43 43 49 4f 08 43 43 49 50  D.COMC.CCIO.CCIP
  0350: 08 43 43 4d 44 08 43 43 44 41 08 43 4f 4d 44 08  .CCMD.CCDA.COMD.
  0360: 43 44 49 4f 08 43 44 49 50 08 43 44 4d 44 08 43  CDIO.CDIP.CDMD.C
  0370: 44 44 41 08 4c 50 54 31 08 4c 31 49 4f 08 4c 31  DDA.LPT1.L1IO.L1
  0380: 49 50 08 4c 31 4d 44 08 4c 31 44 41 08 4c 50 54  IP.L1MD.L1DA.LPT
  0390: 32 08 4c 32 49 4f 08 4c 32 49 50 08 4c 32 4d 44  2.L2IO.L2IP.L2MD
  03a0: 08 4c 32 44 41 08 4c 50 54 33 08 4c 33 49 4f 08  .L2DA.LPT3.L3IO.
  03b0: 4c 33 49 50 08 4c 33 4d 44 08 4c 33 44 41 08 46  L3IP.L3MD.L3DA.F
  03c0: 44 44 43 08 46 44 57 50 08 48 47 4d 50 08 4c 47  DDC.FDWP.HGMP.LG
  03d0: 4d 50 08 4d 49 44 49 08 41 5a 4c 41 08 41 55 44  MP.MIDI.AZLA.AUD
  03e0: 4f 08 4d 4f 44 4d 08 49 44 45 43 08 53 53 45 44  O.MODM.IDEC.SSED
  03f0: 08 50 41 43 54 08 53 43 46 47 08 41 4d 4f 44 08  .PACT.SCFG.AMOD.
  0400: 49 4d 4f 44 08 4c 43 46 47 08 49 44 4c 59 08 50  IMOD.LCFG.IDLY.P
  0410: 4d 54 50 08 50 4d 49 4f 08 50 4d 42 4d 08 50 4d  MTP.PMIO.PMBM.PM
  0420: 54 4d 08 50 53 54 50 08 50 53 49 4f 08 50 53 42  TM.PSTP.PSIO.PSB
  0430: 4d 08 50 53 54 4d 08 49 44 45 30 08 49 44 45 31  M.PSTM.IDE0.IDE1
  0440: 08 49 44 45 32 08 49 44 45 33 08 49 44 45 34 08  .IDE2.IDE3.IDE4.
  0450: 49 44 45 35 08 49 44 45 36 08 49 44 45 37 08 48  IDE5.IDE6.IDE7.H
  0460: 49 55 42 08 4c 55 42 53 08 50 4c 59 54 08 45 44  IUB.LUBS.PLYT.ED
  0470: 43 47 08 53 44 46 59 08 53 44 54 43 08 53 44 52  CG.SDFY.SDTC.SDR
  0480: 50 08 53 44 43 4c 08 53 44 52 43 08 53 44 52 45  P.SDCL.SDRC.SDRE
  0490: 08 46 43 32 4c 08 46 43 33 4c 08 46 43 53 34 08  .FC2L.FC3L.FCS4.
  04a0: 41 50 49 4d 08 48 50 54 53 08 48 50 54 41 08 45  APIM.HPTS.HPTA.E
  04b0: 4d 41 53 08 56 47 41 4f 08 53 4f 46 46 08 4b 42  MAS.VGAO.SOFF.KB
  04c0: 50 4f 08 4d 53 50 4f 08 55 53 42 42 08 45 56 54  PO.MSPO.USBB.EVT
  04d0: 4c 08 53 59 42 45 08 45 54 4c 43 08 41 43 33 30  L.SYBE.ETLC.AC30
  04e0: 08 54 50 4d 44 08 54 50 4d 4f 08 54 50 4d 43 08  .TPMD.TPMO.TPMC.
  04f0: 54 50 4d 4d 08 54 50 43 43 08 54 50 4c 43 08 54  TPMM.TPCC.TPLC.T
  0500: 50 4c 52 20 51 42 4f 54 08 42 4f 54 51 08 50 42  PLR QBOT.BOTQ.PB
  0510: 4f 54 08 4d 32 35 36 08 50 45 47 46 08 4f 53 59  OT.M256.PEGF.OSY
  0520: 53 10 42 4d 54 50 08 42 4e 50 54 08 4c 4e 4d 54  S.BMTP.BNPT.LNMT
  0530: 08 4e 42 54 4f 08 4e 41 42 44 08 4e 45 42 44 08  .NBTO.NABD.NEBD.
  0540: 4e 4c 42 44 08 44 46 42 54 10 4e 50 53 50 10 4c  NLBD.DFBT.NPSP.L
  0550: 41 4e 47 08 55 41 43 4c 08 53 55 50 53 08 44 56  ANG.UACL.SUPS.DV
  0560: 45 54 08 53 33 52 53 08 44 41 53 31 08 44 41 53  ET.S3RS.DAS1.DAS
  0570: 33 08 57 4b 50 4d 08 57 4b 4d 44 08 57 4b 53 35  3.WKPM.WKMD.WKS5
  0580: 08 48 4f 55 52 08 4d 49 4e 53 08 53 45 43 53 08  .HOUR.MINS.SECS.
  0590: 44 4f 46 4d 08 4e 42 54 56 40 04 42 54 4f 44 40  DOFM.NBTV@.BTOD@
  05a0: 04 53 50 56 50 10 50 4f 50 57 10 55 53 50 57 10  .SPVP.POPW.USPW.
  05b0: 48 44 50 57 10 4b 52 53 56 40 1e 4c 41 4e 45 08  HDPW.KRSV@.LANE.
  05c0: 41 4f 52 53 08 50 30 48 50 08 50 31 48 50 08 50  AORS.P0HP.P1HP.P
  05d0: 34 48 50 08 50 35 48 50 08 50 30 49 4c 08 50 31  4HP.P5HP.P0IL.P1
  05e0: 49 4c 08 50 32 49 4c 08 50 45 47 53 08 44 32 46  IL.P2IL.PEGS.D2F
  05f0: 31 08 49 47 4d 54 08 44 54 53 5a 08 43 4c 4b 43  1.IGMT.DTSZ.CLKC
  0600: 08 43 4b 53 43 08 42 4f 54 54 08 50 41 4e 54 08  .CKSC.BOTT.PANT.
  0610: 54 56 54 50 08 55 32 30 31 08 55 32 30 32 08 55  TVTP.U201.U202.U
  0620: 31 31 31 08 55 31 31 32 08 55 31 31 33 08 55 31  111.U112.U113.U1
  0630: 31 34 08 55 31 31 35 08 55 50 50 43 08 55 50 30  14.U115.UPPC.UP0
  0640: 30 08 55 50 30 31 08 55 50 30 32 08 55 50 30 33  0.UP01.UP02.UP03
  0650: 08 55 50 30 34 08 55 50 30 35 08 55 50 30 36 08  .UP04.UP05.UP06.
  0660: 55 50 30 37 08 55 50 30 38 08 55 50 30 39 08 55  UP07.UP08.UP09.U
  0670: 50 31 30 08 55 50 31 31 08 50 38 30 52 08 57 44  P10.UP11.P80R.WD
  0680: 4f 47 08 57 44 54 4f 10 57 44 54 42 10 4d 41 53  OG.WDTO.WDTB.MAS
  0690: 46 08 4d 41 4d 54 08 41 42 58 50 08 53 50 49 4c  F.MAMT.ABXP.SPIL
  06a0: 08 50 57 44 57 08 48 45 54 4f 08 41 57 54 52 10  .PWDW.HETO.AWTR.
  06b0: 45 4f 50 54 08 41 53 46 42 08 4d 42 54 58 08 49  EOPT.ASFB.MBTX.I
  06c0: 44 45 52 08 53 4f 4c 45 08 50 52 45 30 08 50 52  DER.SOLE.PRE0.PR
  06d0: 45 31 08 50 52 45 32 08 50 52 45 33 08 50 52 45  E1.PRE2.PRE3.PRE
  06e0: 34 08 50 52 45 35 08 50 52 41 30 08 50 52 41 31  4.PRE5.PRA0.PRA1
  06f0: 08 50 52 41 32 08 50 52 41 33 08 50 52 41 34 08  .PRA2.PRA3.PRA4.
  0700: 50 52 41 35 08 50 52 56 30 08 50 52 56 31 08 50  PRA5.PRV0.PRV1.P
  0710: 52 56 32 08 50 52 56 33 08 50 52 56 34 08 50 52  RV2.PRV3.PRV4.PR
  0720: 56 35 08 50 41 41 30 08 50 41 41 31 08 50 41 41  V5.PAA0.PAA1.PAA
  0730: 32 08 50 41 41 33 08 50 41 41 34 08 50 41 41 35  2.PAA3.PAA4.PAA5
  0740: 08 4c 30 53 30 08 4c 30 53 31 08 4c 30 53 32 08  .L0S0.L0S1.L0S2.
  0750: 4c 30 53 33 08 4c 30 53 34 08 4c 30 53 35 08 41  L0S3.L0S4.L0S5.A
  0760: 4c 31 30 08 41 4c 31 31 08 41 4c 31 32 08 41 4c  L10.AL11.AL12.AL
  0770: 31 33 08 41 4c 31 34 08 41 4c 31 35 08 50 45 53  13.AL14.AL15.PES
  0780: 30 08 50 45 53 31 08 50 45 53 32 08 50 45 53 33  0.PES1.PES2.PES3
  0790: 08 50 45 53 34 08 50 45 53 35 08 50 52 55 30 08  .PES4.PES5.PRU0.
  07a0: 50 52 55 31 08 50 52 55 32 08 50 52 55 33 08 50  PRU1.PRU2.PRU3.P
  07b0: 52 55 34 08 50 52 55 35 08 50 52 46 30 08 50 52  RU4.PRU5.PRF0.PR
  07c0: 46 31 08 50 52 46 32 08 50 52 46 33 08 50 52 46  F1.PRF2.PRF3.PRF
  07d0: 34 08 50 52 46 35 08 50 52 4e 30 08 50 52 4e 31  4.PRF5.PRN0.PRN1
  07e0: 08 50 52 4e 32 08 50 52 4e 33 08 50 52 4e 34 08  .PRN2.PRN3.PRN4.
  07f0: 50 52 4e 35 08 50 52 43 30 08 50 52 43 31 08 50  PRN5.PRC0.PRC1.P
  0800: 52 43 32 08 50 52 43 33 08 50 52 43 34 08 50 52  RC2.PRC3.PRC4.PR
  0810: 43 35 08 43 54 44 30 08 43 54 44 31 08 43 54 44  C5.CTD0.CTD1.CTD
  0820: 32 08 43 54 44 33 08 43 54 44 34 08 43 54 44 35  2.CTD3.CTD4.CTD5
  0830: 08 50 49 45 30 08 50 49 45 31 08 50 49 45 32 08  .PIE0.PIE1.PIE2.
  0840: 50 49 45 33 08 50 49 45 34 08 50 49 45 35 08 53  PIE3.PIE4.PIE5.S
  0850: 46 45 30 08 53 46 45 31 08 53 46 45 32 08 53 46  FE0.SFE1.SFE2.SF
  0860: 45 33 08 53 46 45 34 08 53 46 45 35 08 53 4e 45  E3.SFE4.SFE5.SNE
  0870: 30 08 53 4e 45 31 08 53 4e 45 32 08 53 4e 45 33  0.SNE1.SNE2.SNE3
  0880: 08 53 4e 45 34 08 53 4e 45 35 08 53 43 45 30 08  .SNE4.SNE5.SCE0.
  0890: 53 43 45 31 08 53 43 45 32 08 53 43 45 33 08 53  SCE1.SCE2.SCE3.S
  08a0: 43 45 34 08 53 43 45 35 08 4d 43 45 30 08 4d 43  CE4.SCE5.MCE0.MC
  08b0: 45 31 08 4d 43 45 32 08 4d 43 45 33 08 4d 43 45  E1.MCE2.MCE3.MCE
  08c0: 34 08 4d 43 45 35 08 50 43 45 30 08 50 43 45 31  4.MCE5.PCE0.PCE1
  08d0: 08 50 43 45 32 08 50 43 45 33 08 50 43 45 34 08  .PCE2.PCE3.PCE4.
  08e0: 50 43 45 35 08 50 54 43 30 08 50 54 43 31 08 50  PCE5.PTC0.PTC1.P
  08f0: 54 43 32 08 50 54 43 33 08 50 54 43 34 08 50 54  TC2.PTC3.PTC4.PT
  0900: 43 35 08 44 41 50 4d 08 44 50 4d 41 08 44 4c 30  C5.DAPM.DPMA.DL0
  0910: 53 08 44 41 4c 31 08 50 45 47 41 08 50 47 41 41  S.DAL1.PEGA.PGAA
  0920: 08 50 47 4c 30 08 50 4c 30 41 08 50 47 4c 31 08  .PGL0.PL0A.PGL1.
  0930: 50 47 45 53 08 50 41 56 50 08 49 53 54 43 08 54  PGES.PAVP.ISTC.T
  0940: 52 4d 4c 08 46 4e 4f 4e 08 54 52 4f 4e 08 4e 58  RML.FNON.TRON.NX
  0950: 4d 44 08 50 43 52 52 08 43 34 45 4e 08 43 34 33  MD.PCRR.C4EN.C43
  0960: 44 08 45 4d 54 54 08 50 52 4f 48 08 44 46 53 42  D.EMTT.PROH.DFSB
  0970: 08 54 55 42 4d 08 54 53 54 45 08 42 50 53 54 08  .TUBM.TSTE.BPST.
  0980: 51 4b 53 34 08 50 4f 50 55 08 50 4f 50 44 08 43  QKS4.POPU.POPD.C
  0990: 34 45 54 08 4e 58 46 45 08 56 54 53 54 08 56 54  4ET.NXFE.VTST.VT
  09a0: 46 45 08 53 35 46 47 08 43 53 54 53 08 45 4e 43  FE.S5FG.CSTS.ENC
  09b0: 53 08 44 45 43 34 08 48 43 34 45 08 45 4e 43 36  S.DEC4.HC4E.ENC6
  09c0: 08 43 53 54 52 08 43 4d 50 45 08 43 53 4d 44 08  .CSTR.CMPE.CSMD.
  09d0: 44 54 53 45 08 44 54 53 43 08 52 41 49 44 08 50  DTSE.DTSC.RAID.P
  09e0: 53 48 4d 08 50 45 58 43 08 44 54 53 54 08 54 58  SHM.PEXC.DTST.TX
  09f0: 54 53 08 56 54 44 45 08 53 4d 52 52 08 43 41 52  TS.VTDE.SMRR.CAR
  0a00: 54 08 43 41 54 54 08 49 54 50 4d 08 53 54 42 45  T.CATT.ITPM.STBE
  0a10: 08 50 45 42 45 08 50 43 42 45 08 45 48 42 45 08  .PEBE.PCBE.EHBE.
  0a20: 55 48 42 45 08 48 41 42 45 08 45 52 53 32 08 43  UHBE.HABE.ERS2.C
  0a30: 52 53 56 48 22 4f 52 53 56 40 23 53 50 57 30 08  RSVH"ORSV@#SPW0.
  0a40: 53 50 57 31 08 44 32 44 45 08 46 31 32 4d 08 4d  SPW1.D2DE.F12M.M
  0a50: 57 44 54 10 50 4f 57 54 10 44 52 53 56 40 2e 5b  WDT.POWT.DRSV@.[
  0a60: 80 53 4d 49 4f 01 0a b2 0a 02 5b 81 10 53 4d 49  .SMIO.....[..SMI
  0a70: 4f 01 41 50 4d 43 08 41 50 4d 44 08 14 2b 4f 53  O.APMC.APMD..+OS
  0a80: 4d 49 01 70 68 41 50 4d 44 70 0a b2 41 50 4d 43  MI.phAPMDp..APMC
  0a90: 5b 21 0a ff 5b 21 0a ff 5b 21 0a ff 5b 21 0a ff  [!..[!..[!..[!..
  0aa0: 5b 21 0a ff 5b 21 0a ff 5b 80 49 4f 5f 54 01 0b  [!..[!..[.IO_T..
  0ab0: 00 08 0a 10 5b 81 21 49 4f 5f 54 01 00 10 00 10  ....[.!IO_T.....
  0ac0: 00 10 00 10 54 52 50 30 08 00 08 00 08 00 08 00  ....TRP0........
  0ad0: 08 00 08 00 08 00 08 5b 80 49 4f 5f 44 01 0b 10  .......[.IO_D...
  0ae0: 08 0a 08 5b 81 0b 49 4f 5f 44 01 54 52 50 44 08  ...[..IO_D.TRPD.
  0af0: 5b 80 49 4f 5f 48 01 0b 00 04 0a 04 5b 81 0b 49  [.IO_H......[..I
  0b00: 4f 5f 48 01 54 52 50 48 08 5b 80 4e 56 53 54 00  O_H.TRPH.[.NVST.
  0b10: 0c d4 ee ab bb 0c e1 00 00 00 5b 81 41 22 4e 56  ..........[.A"NV
  0b20: 53 54 10 53 4d 49 46 08 50 52 4d 30 08 50 52 4d  ST.SMIF.PRM0.PRM
  0b30: 31 08 53 43 49 46 08 50 52 4d 32 08 50 52 4d 33  1.SCIF.PRM2.PRM3
  0b40: 08 4c 43 4b 46 08 50 52 4d 34 08 50 52 4d 35 08  .LCKF.PRM4.PRM5.
  0b50: 50 38 30 44 20 4c 49 44 53 08 50 57 52 53 08 44  P80D LIDS.PWRS.D
  0b60: 42 47 53 08 54 48 4f 46 08 41 43 54 31 08 41 43  BGS.THOF.ACT1.AC
  0b70: 54 54 08 43 52 54 54 08 00 08 44 54 53 31 08 44  TT.CRTT...DTS1.D
  0b80: 54 53 32 08 44 54 53 46 08 42 4e 55 4d 08 41 50  TS2.DTSF.BNUM.AP
  0b90: 49 43 08 50 43 50 30 08 50 43 50 31 08 50 50 43  IC.PCP0.PCP1.PPC
  0ba0: 4d 08 50 50 4d 46 20 49 47 44 53 08 54 4c 53 54  M.PPMF IGDS.TLST
  0bb0: 08 43 41 44 4c 08 50 41 44 4c 08 43 53 54 45 10  .CADL.PADL.CSTE.
  0bc0: 4e 53 54 45 10 53 53 54 45 10 4e 44 49 44 08 44  NSTE.SSTE.NDID.D
  0bd0: 49 44 31 20 44 49 44 32 20 44 49 44 33 20 44 49  ID1 DID2 DID3 DI
  0be0: 44 34 20 44 49 44 35 20 42 44 53 50 08 50 54 59  D4 DID5 BDSP.PTY
  0bf0: 31 08 50 54 59 32 08 50 53 43 4c 08 54 56 46 31  1.PTY2.PSCL.TVF1
  0c00: 08 54 56 46 32 08 47 45 54 4d 08 42 4c 43 53 08  .TVF2.GETM.BLCS.
  0c10: 42 52 54 4c 08 41 4c 53 45 08 41 4c 41 46 08 4c  BRTL.ALSE.ALAF.L
  0c20: 4c 4f 57 08 4c 48 49 48 08 45 4d 41 45 08 45 4d  LOW.LHIH.EMAE.EM
  0c30: 41 50 10 45 4d 41 4c 10 4d 45 46 45 08 44 53 54  AP.EMAL.MEFE.DST
  0c40: 53 08 54 50 4d 50 08 54 50 4d 45 08 47 54 46 30  S.TPMP.TPME.GTF0
  0c50: 38 47 54 46 32 38 49 44 45 4d 08 47 54 46 31 38  8GTF28IDEM.GTF18
  0c60: 42 49 44 5f 08 41 53 4c 42 20 49 42 54 54 08 49  BID_.ASLB IBTT.I
  0c70: 50 41 54 08 49 54 56 46 08 49 54 56 4d 08 49 50  PAT.ITVF.ITVM.IP
  0c80: 53 43 08 49 42 4c 43 08 49 42 49 41 08 49 53 53  SC.IBLC.IBIA.ISS
  0c90: 43 08 49 34 30 39 08 49 35 30 39 08 49 36 30 39  C.I409.I509.I609
  0ca0: 08 49 37 30 39 08 49 44 4d 4d 08 49 44 4d 53 08  .I709.IDMM.IDMS.
  0cb0: 49 46 31 45 08 48 56 43 4f 08 4e 58 44 31 20 4e  IF1E.HVCO.NXD1 N
  0cc0: 58 44 32 20 4e 58 44 33 20 4e 58 44 34 20 4e 58  XD2 NXD3 NXD4 NX
  0cd0: 44 35 20 4e 58 44 36 20 4e 58 44 37 20 4e 58 44  D5 NXD6 NXD7 NXD
  0ce0: 38 20 47 53 4d 49 08 44 53 45 4e 08 45 43 4f 4e  8 GSMI.DSEN.ECON
  0cf0: 08 47 50 49 43 08 43 54 59 50 08 4c 30 31 43 08  .GPIC.CTYP.L01C.
  0d00: 56 46 4e 30 08 56 46 4e 31 08 4c 43 44 41 10 42  VFN0.VFN1.LCDA.B
  0d10: 56 41 4c 20 44 49 30 30 40 14 54 50 41 44 08 4b  VAL DI00@.TPAD.K
  0d20: 42 54 50 08 4b 53 56 30 20 4b 53 56 31 08 43 52  BTP.KSV0 KSV1.CR
  0d30: 54 44 08 46 54 41 54 08 50 4d 49 44 08 10 39 5f  TD.FTAT.PMID..9_
  0d40: 50 52 5f 5b 83 0b 43 50 55 30 01 10 04 00 00 06  PR_[..CPU0......
  0d50: 5b 83 0b 43 50 55 31 02 10 04 00 00 06 5b 83 0b  [..CPU1......[..
  0d60: 43 50 55 32 03 10 04 00 00 06 5b 83 0b 43 50 55  CPU2......[..CPU
  0d70: 33 04 10 04 00 00 06 5b 80 50 52 54 30 01 0a 80  3......[.PRT0...
  0d80: 0a 04 5b 81 0b 50 52 54 30 13 50 38 30 48 20 14  ..[..PRT0.P80H .
  0d90: 4e 07 50 38 58 48 0a a0 17 93 68 00 70 7d 7b 50  N.P8XH....h.p}{P
  0da0: 38 30 44 0c 00 ff ff ff 00 69 00 50 38 30 44 a0  80D......i.P80D.
  0db0: 1b 93 68 01 70 7d 7b 50 38 30 44 0c ff 00 ff ff  ..h.p}{P80D.....
  0dc0: 00 79 69 0a 08 00 00 50 38 30 44 a0 1c 93 68 0a  .yi....P80D...h.
  0dd0: 02 70 7d 7b 50 38 30 44 0c ff ff 00 ff 00 79 69  .p}{P80D......yi
  0de0: 0a 10 00 00 50 38 30 44 a0 1c 93 68 0a 03 70 7d  ....P80D...h..p}
  0df0: 7b 50 38 30 44 0c ff ff ff 00 00 79 69 0a 18 00  {P80D......yi...
  0e00: 00 50 38 30 44 70 50 38 30 44 50 38 30 48 14 47  .P80DpP80DP80H.G
  0e10: 04 54 52 41 50 0a 70 69 53 4d 49 46 a0 0d 93 68  .TRAP.piSMIF...h
  0e20: 54 52 54 50 70 00 54 52 50 30 a0 18 93 68 54 52  TRTPp.TRP0...hTR
  0e30: 54 44 70 69 44 54 53 46 70 00 54 52 50 44 a4 44  TDpiDTSFp.TRPD.D
  0e40: 54 53 46 a0 0d 93 68 54 52 54 49 70 00 54 52 50  TSF...hTRTIp.TRP
  0e50: 48 a4 53 4d 49 46 5b 80 43 4d 53 31 01 0a 72 0a  H.SMIF[.CMS1..r.
  0e60: 02 5b 81 10 43 4d 53 31 01 43 4d 53 49 08 43 4d  .[..CMS1.CMSI.CM
  0e70: 53 44 08 14 12 43 4d 53 57 02 70 68 43 4d 53 49  SD...CMSW.phCMSI
  0e80: 70 69 43 4d 53 44 5b 01 50 53 4d 58 00 14 2f 49  piCMSD[.PSMX../I
  0e90: 48 57 4d 02 5b 23 50 53 4d 58 ff ff 70 68 50 52  HWM.[#PSMX..phPR
  0ea0: 4d 30 70 69 44 49 30 30 70 0a c1 41 50 4d 43 70  M0piDI00p..APMCp
  0eb0: 44 49 30 30 60 5b 27 50 53 4d 58 a4 60 14 4d 04  DI00`['PSMX.`.M.
  0ec0: 5f 50 54 53 01 70 0a 55 50 38 30 48 a0 0c 93 68  _PTS.p.UP80H...h
  0ed0: 0a 03 70 0a 53 50 38 30 48 a0 2f 93 68 0a 04 70  ..p.SP80H./.h..p
  0ee0: 0a 54 50 38 30 48 4f 53 4d 49 0a 82 5c 2f 04 5f  .TP80HOSMI..\/._
  0ef0: 53 42 5f 50 43 49 30 4f 56 47 41 47 4c 49 44 0a  SB_PCI0OVGAGLID.
  0f00: 03 43 4d 53 57 0a 3f 0a 3f a4 00 14 46 1a 5f 57  .CMSW.?.?...F._W
  0f10: 41 4b 01 a0 2f 93 52 50 31 44 00 a0 27 93 5c 2f  AK../.RP1D..'.\/
  0f20: 04 5f 53 42 5f 50 43 49 30 45 58 50 31 50 44 53  ._SB_PCI0EXP1PDS
  0f30: 58 01 86 5c 2f 03 5f 53 42 5f 50 43 49 30 45 58  X..\/._SB_PCI0EX
  0f40: 50 31 00 a0 2f 93 52 50 32 44 00 a0 27 93 5c 2f  P1../.RP2D..'.\/
  0f50: 04 5f 53 42 5f 50 43 49 30 45 58 50 32 50 44 53  ._SB_PCI0EXP2PDS
  0f60: 58 01 86 5c 2f 03 5f 53 42 5f 50 43 49 30 45 58  X..\/._SB_PCI0EX
  0f70: 50 32 00 a0 2f 93 52 50 33 44 00 a0 27 93 5c 2f  P2../.RP3D..'.\/
  0f80: 04 5f 53 42 5f 50 43 49 30 45 58 50 33 50 44 53  ._SB_PCI0EXP3PDS
  0f90: 58 01 86 5c 2f 03 5f 53 42 5f 50 43 49 30 45 58  X..\/._SB_PCI0EX
  0fa0: 50 33 00 a0 2f 93 52 50 34 44 00 a0 27 93 5c 2f  P3../.RP4D..'.\/
  0fb0: 04 5f 53 42 5f 50 43 49 30 45 58 50 34 50 44 53  ._SB_PCI0EXP4PDS
  0fc0: 58 01 86 5c 2f 03 5f 53 42 5f 50 43 49 30 45 58  X..\/._SB_PCI0EX
  0fd0: 50 34 00 a0 2f 93 52 50 35 44 00 a0 27 93 5c 2f  P4../.RP5D..'.\/
  0fe0: 04 5f 53 42 5f 50 43 49 30 45 58 50 35 50 44 53  ._SB_PCI0EXP5PDS
  0ff0: 58 01 86 5c 2f 03 5f 53 42 5f 50 43 49 30 45 58  X..\/._SB_PCI0EX
  1000: 50 35 00 a0 4a 06 93 68 0a 03 70 0a e3 50 38 30  P5..J..h..p..P80
  1010: 48 a0 17 90 44 54 53 45 43 4d 50 45 70 0a 14 44  H...DTSECMPEp..D
  1020: 54 53 46 70 00 54 52 50 44 4f 53 4d 49 0a 81 86  TSFp.TRPDOSMI...
  1030: 5c 2f 03 5f 53 42 5f 50 43 49 30 45 58 50 35 00  \/._SB_PCI0EXP5.
  1040: 86 5c 2f 03 5f 53 42 5f 50 43 49 30 45 58 50 31  .\/._SB_PCI0EXP1
  1050: 01 70 0a 52 41 50 4d 43 86 5c 2f 04 5f 53 42 5f  .p.RAPMC.\/._SB_
  1060: 50 43 49 30 4c 50 43 5f 50 57 52 42 0a 02 a0 41  PCI0LPC_PWRB...A
  1070: 04 93 68 0a 04 70 0a e4 50 38 30 48 4f 53 4d 49  ..h..p..P80HOSMI
  1080: 0a 83 a0 17 90 44 54 53 45 43 4d 50 45 70 0a 14  .....DTSECMPEp..
  1090: 44 54 53 46 70 00 54 52 50 44 86 5c 2f 04 5f 53  DTSFp.TRPD.\/._S
  10a0: 42 5f 50 43 49 30 4c 50 43 5f 50 57 52 42 0a 02  B_PCI0LPC_PWRB..
  10b0: a4 00 a0 15 93 44 41 53 33 01 08 5f 53 33 5f 12  .....DAS3.._S3_.
  10c0: 08 04 0a 05 0a 05 00 00 08 5f 53 34 5f 12 08 04  ........._S4_...
  10d0: 0a 06 0a 06 00 00 08 5f 53 35 5f 12 08 04 0a 07  ......._S5_.....
  10e0: 0a 07 00 00 08 4d 58 4d 32 11 2e 0a 2b 4d 58 4d  .....MXM2...+MXM
  10f0: 5f 02 00 23 00 00 00 fa ff f9 3e 30 12 b8 ff f9  _..#......>0....
  1100: 3e 20 21 8a f0 f9 5e 03 64 90 01 13 64 90 01 e5  > !...^.d...d...
  1110: 0d 11 02 00 00 00 00 13 10 45 6e 5f 47 50 45 14  .........En_GPE.
  1120: 49 3d 5f 4c 30 31 00 a0 44 07 92 93 5c 2f 04 5f  I=_L01..D...\/._
  1130: 53 42 5f 50 43 49 30 45 58 50 31 56 44 49 44 0b  SB_PCI0EXP1VDID.
  1140: ff ff a0 49 05 5c 2f 04 5f 53 42 5f 50 43 49 30  ...I.\/._SB_PCI0
  1150: 45 58 50 31 48 50 53 58 5b 22 0b dc 05 a0 29 5c  EXP1HPSX["....)\
  1160: 2f 04 5f 53 42 5f 50 43 49 30 45 58 50 31 50 44  /._SB_PCI0EXP1PD
  1170: 43 58 70 01 5c 2f 04 5f 53 42 5f 50 43 49 30 45  CXp.\/._SB_PCI0E
  1180: 58 50 31 50 44 43 58 70 01 5c 2f 04 5f 53 42 5f  XP1PDCXp.\/._SB_
  1190: 50 43 49 30 45 58 50 31 48 50 53 58 a0 4f 06 92  PCI0EXP1HPSX.O..
  11a0: 93 5c 2f 04 5f 53 42 5f 50 43 49 30 45 58 50 32  .\/._SB_PCI0EXP2
  11b0: 56 44 49 44 0b ff ff a0 44 05 5c 2f 04 5f 53 42  VDID....D.\/._SB
  11c0: 5f 50 43 49 30 45 58 50 32 48 50 53 58 a0 29 5c  _PCI0EXP2HPSX.)\
  11d0: 2f 04 5f 53 42 5f 50 43 49 30 45 58 50 32 50 44  /._SB_PCI0EXP2PD
  11e0: 43 58 70 01 5c 2f 04 5f 53 42 5f 50 43 49 30 45  CXp.\/._SB_PCI0E
  11f0: 58 50 32 50 44 43 58 70 01 5c 2f 04 5f 53 42 5f  XP2PDCXp.\/._SB_
  1200: 50 43 49 30 45 58 50 32 48 50 53 58 a0 4f 06 92  PCI0EXP2HPSX.O..
  1210: 93 5c 2f 04 5f 53 42 5f 50 43 49 30 45 58 50 33  .\/._SB_PCI0EXP3
  1220: 56 44 49 44 0b ff ff a0 44 05 5c 2f 04 5f 53 42  VDID....D.\/._SB
  1230: 5f 50 43 49 30 45 58 50 33 48 50 53 58 a0 29 5c  _PCI0EXP3HPSX.)\
  1240: 2f 04 5f 53 42 5f 50 43 49 30 45 58 50 33 50 44  /._SB_PCI0EXP3PD
  1250: 43 58 70 01 5c 2f 04 5f 53 42 5f 50 43 49 30 45  CXp.\/._SB_PCI0E
  1260: 58 50 33 50 44 43 58 70 01 5c 2f 04 5f 53 42 5f  XP3PDCXp.\/._SB_
  1270: 50 43 49 30 45 58 50 33 48 50 53 58 a0 4f 06 92  PCI0EXP3HPSX.O..
  1280: 93 5c 2f 04 5f 53 42 5f 50 43 49 30 45 58 50 34  .\/._SB_PCI0EXP4
  1290: 56 44 49 44 0b ff ff a0 44 05 5c 2f 04 5f 53 42  VDID....D.\/._SB
  12a0: 5f 50 43 49 30 45 58 50 34 48 50 53 58 a0 29 5c  _PCI0EXP4HPSX.)\
  12b0: 2f 04 5f 53 42 5f 50 43 49 30 45 58 50 34 50 44  /._SB_PCI0EXP4PD
  12c0: 43 58 70 01 5c 2f 04 5f 53 42 5f 50 43 49 30 45  CXp.\/._SB_PCI0E
  12d0: 58 50 34 50 44 43 58 70 01 5c 2f 04 5f 53 42 5f  XP4PDCXp.\/._SB_
  12e0: 50 43 49 30 45 58 50 34 48 50 53 58 5b 22 0a 64  PCI0EXP4HPSX[".d
  12f0: a0 2a 92 93 5c 2f 04 5f 53 42 5f 50 43 49 30 45  .*..\/._SB_PCI0E
  1300: 58 50 31 56 44 49 44 0b ff ff 86 5c 2f 03 5f 53  XP1VDID....\/._S
  1310: 42 5f 50 43 49 30 45 58 50 31 00 a0 2a 92 93 5c  B_PCI0EXP1..*..\
  1320: 2f 04 5f 53 42 5f 50 43 49 30 45 58 50 32 56 44  /._SB_PCI0EXP2VD
  1330: 49 44 0b ff ff 86 5c 2f 03 5f 53 42 5f 50 43 49  ID....\/._SB_PCI
  1340: 30 45 58 50 32 00 a0 2a 92 93 5c 2f 04 5f 53 42  0EXP2..*..\/._SB
  1350: 5f 50 43 49 30 45 58 50 33 56 44 49 44 0b ff ff  _PCI0EXP3VDID...
  1360: 86 5c 2f 03 5f 53 42 5f 50 43 49 30 45 58 50 33  .\/._SB_PCI0EXP3
  1370: 00 a0 2a 92 93 5c 2f 04 5f 53 42 5f 50 43 49 30  ..*..\/._SB_PCI0
  1380: 45 58 50 34 56 44 49 44 0b ff ff 86 5c 2f 03 5f  EXP4VDID....\/._
  1390: 53 42 5f 50 43 49 30 45 58 50 34 00 a0 45 15 90  SB_PCI0EXP4..E..
  13a0: 93 52 50 35 44 00 5c 2f 04 5f 53 42 5f 50 43 49  .RP5D.\/._SB_PCI
  13b0: 30 45 58 50 35 48 50 53 58 70 0a 70 50 38 30 48  0EXP5HPSXp.pP80H
  13c0: 5b 22 0a 64 a0 46 11 5c 2f 04 5f 53 42 5f 50 43  [".d.F.\/._SB_PC
  13d0: 49 30 45 58 50 35 50 44 43 58 70 01 5c 2f 04 5f  I0EXP5PDCXp.\/._
  13e0: 53 42 5f 50 43 49 30 45 58 50 35 50 44 43 58 70  SB_PCI0EXP5PDCXp
  13f0: 01 5c 2f 04 5f 53 42 5f 50 43 49 30 45 58 50 35  .\/._SB_PCI0EXP5
  1400: 48 50 53 58 a0 4f 0b 5c 2f 04 5f 53 42 5f 50 43  HPSX.O.\/._SB_PC
  1410: 49 30 45 58 50 35 50 44 53 58 70 0a 71 50 38 30  I0EXP5PDSXp.qP80
  1420: 48 5b 22 0a 64 70 0a 0a 62 a2 4a 09 94 62 00 70  H[".dp..b.J..b.p
  1430: 0a 72 50 38 30 48 5b 22 0a 64 7b 5c 2f 05 5f 53  .rP80H[".d{\/._S
  1440: 42 5f 50 43 49 30 45 58 50 35 4a 33 38 30 44 56  B_PCI0EXP5J380DV
  1450: 49 44 0c ff ff f0 ff 61 a0 41 05 93 61 0c 7b 19  ID.....a.A..a.{.
  1460: 80 23 70 0a 88 5c 2f 05 5f 53 42 5f 50 43 49 30  .#p..\/._SB_PCI0
  1470: 45 58 50 35 4a 33 38 30 4c 41 54 30 70 0a 80 5c  EXP5J380LAT0p..\
  1480: 2f 05 5f 53 42 5f 50 43 49 30 45 58 50 35 4a 33  /._SB_PCI0EXP5J3
  1490: 38 30 50 4d 43 30 70 0a 73 50 38 30 48 5b 22 0a  80PMC0p.sP80H[".
  14a0: 64 4f 53 4d 49 0a 5a 70 00 62 a1 19 70 0a 74 50  dOSMI.Zp.b..p.tP
  14b0: 38 30 48 5b 22 0a 64 76 62 70 0a 75 50 38 30 48  80H[".dvbp.uP80H
  14c0: 5b 22 0a 64 a1 05 5b 22 0a 64 86 5c 2f 03 5f 53  [".d..[".d.\/._S
  14d0: 42 5f 50 43 49 30 45 58 50 35 00 a1 16 70 01 5c  B_PCI0EXP5...p.\
  14e0: 2f 04 5f 53 42 5f 50 43 49 30 45 58 50 35 48 50  /._SB_PCI0EXP5HP
  14f0: 53 58 70 0a 78 50 38 30 48 14 19 5f 4c 30 32 00  SXp.xP80H.._L02.
  1500: 70 00 47 50 45 43 86 5c 2e 5f 54 5a 5f 54 5a 30  p.GPEC.\._TZ_TZ0
  1510: 31 0a 80 14 36 5f 4c 30 36 00 a0 27 5c 2f 04 5f  1...6_L06..'\/._
  1520: 53 42 5f 50 43 49 30 4f 56 47 41 47 53 53 45 5c  SB_PCI0OVGAGSSE\
  1530: 2f 04 5f 53 42 5f 50 43 49 30 4f 56 47 41 47 53  /._SB_PCI0OVGAGS
  1540: 43 49 a1 07 70 01 53 43 49 53 14 49 08 5f 4c 30  CI..p.SCIS.I._L0
  1550: 39 00 86 5c 2f 03 5f 53 42 5f 50 43 49 30 45 58  9..\/._SB_PCI0EX
  1560: 50 31 0a 02 86 5c 2f 04 5f 53 42 5f 50 43 49 30  P1...\/._SB_PCI0
  1570: 45 58 50 31 50 58 53 31 0a 02 86 5c 2f 03 5f 53  EXP1PXS1...\/._S
  1580: 42 5f 50 43 49 30 45 58 50 32 0a 02 86 5c 2f 03  B_PCI0EXP2...\/.
  1590: 5f 53 42 5f 50 43 49 30 45 58 50 33 0a 02 86 5c  _SB_PCI0EXP3...\
  15a0: 2f 03 5f 53 42 5f 50 43 49 30 45 58 50 34 0a 02  /._SB_PCI0EXP4..
  15b0: 86 5c 2f 03 5f 53 42 5f 50 43 49 30 45 58 50 35  .\/._SB_PCI0EXP5
  15c0: 0a 02 86 5c 2f 03 5f 53 42 5f 50 43 49 30 45 58  ...\/._SB_PCI0EX
  15d0: 50 36 0a 02 14 18 5f 4c 30 42 00 86 5c 2f 03 5f  P6...._L0B..\/._
  15e0: 53 42 5f 50 43 49 30 50 33 32 5f 0a 02 14 2e 5f  SB_PCI0P32_...._
  15f0: 4c 30 33 00 86 5c 2f 03 5f 53 42 5f 50 43 49 30  L03..\/._SB_PCI0
  1600: 55 48 43 30 0a 02 86 5c 2f 04 5f 53 42 5f 50 43  UHC0...\/._SB_PC
  1610: 49 30 4c 50 43 5f 53 4c 50 42 0a 80 14 2e 5f 4c  I0LPC_SLPB...._L
  1620: 30 34 00 86 5c 2f 03 5f 53 42 5f 50 43 49 30 55  04..\/._SB_PCI0U
  1630: 48 43 31 0a 02 86 5c 2f 04 5f 53 42 5f 50 43 49  HC1...\/._SB_PCI
  1640: 30 4c 50 43 5f 53 4c 50 42 0a 80 14 2e 5f 4c 30  0LPC_SLPB...._L0
  1650: 43 00 86 5c 2f 03 5f 53 42 5f 50 43 49 30 55 48  C..\/._SB_PCI0UH
  1660: 43 32 0a 02 86 5c 2f 04 5f 53 42 5f 50 43 49 30  C2...\/._SB_PCI0
  1670: 4c 50 43 5f 53 4c 50 42 0a 80 14 2e 5f 4c 32 30  LPC_SLPB...._L20
  1680: 00 86 5c 2f 03 5f 53 42 5f 50 43 49 30 55 48 43  ..\/._SB_PCI0UHC
  1690: 52 0a 02 86 5c 2f 04 5f 53 42 5f 50 43 49 30 4c  R...\/._SB_PCI0L
  16a0: 50 43 5f 53 4c 50 42 0a 80 14 2e 5f 4c 30 44 00  PC_SLPB...._L0D.
  16b0: 86 5c 2f 03 5f 53 42 5f 50 43 49 30 45 48 43 31  .\/._SB_PCI0EHC1
  16c0: 0a 02 86 5c 2f 04 5f 53 42 5f 50 43 49 30 4c 50  ...\/._SB_PCI0LP
  16d0: 43 5f 53 4c 50 42 0a 80 14 17 5f 4c 31 37 00 86  C_SLPB...._L17..
  16e0: 5c 2f 03 5f 53 42 5f 50 43 49 30 45 58 50 35 00  \/._SB_PCI0EXP5.
  16f0: 14 4b 05 5f 4c 31 42 00 80 4c 50 44 4c 4c 50 44  .K._L1B..LPDLLPD
  1700: 4c 70 5c 2f 05 5f 53 42 5f 50 43 49 30 4c 50 43  Lp\/._SB_PCI0LPC
  1710: 5f 45 43 30 5f 4c 49 44 4f 60 80 60 60 72 60 0a  _EC0_LIDO`.``r`.
  1720: 02 00 5c 2f 04 5f 53 42 5f 50 43 49 30 4f 56 47  ..\/._SB_PCI0OVG
  1730: 41 47 4c 49 44 60 86 5c 2f 04 5f 53 42 5f 50 43  AGLID`.\/._SB_PC
  1740: 49 30 4c 50 43 5f 4c 49 44 30 0a 80 14 43 05 5f  I0LPC_LID0...C._
  1750: 4c 31 44 00 80 4e 45 57 44 4e 45 57 44 70 5c 2f  L1D..NEWDNEWDp\/
  1760: 04 5f 53 42 5f 50 43 49 30 45 58 50 31 4c 50 57  ._SB_PCI0EXP1LPW
  1770: 52 62 80 62 62 70 62 5c 2f 04 5f 53 42 5f 50 43  Rb.bbpb\/._SB_PC
  1780: 49 30 45 58 50 31 4c 50 57 52 5b 22 0b f4 01 86  I0EXP1LPWR["....
  1790: 5c 2f 03 5f 53 42 5f 50 43 49 30 45 58 50 31 00  \/._SB_PCI0EXP1.
  17a0: 14 2e 5f 4c 30 45 00 86 5c 2f 03 5f 53 42 5f 50  .._L0E..\/._SB_P
  17b0: 43 49 30 55 48 43 33 0a 02 86 5c 2f 04 5f 53 42  CI0UHC3...\/._SB
  17c0: 5f 50 43 49 30 4c 50 43 5f 53 4c 50 42 0a 80 14  _PCI0LPC_SLPB...
  17d0: 2e 5f 4c 30 35 00 86 5c 2f 03 5f 53 42 5f 50 43  ._L05..\/._SB_PC
  17e0: 49 30 55 48 43 34 0a 02 86 5c 2f 04 5f 53 42 5f  I0UHC4...\/._SB_
  17f0: 50 43 49 30 4c 50 43 5f 53 4c 50 42 0a 80 14 0c  PCI0LPC_SLPB....
  1800: 5f 50 49 43 01 70 68 47 50 49 43 10 4d 08 5f 54  _PIC.phGPIC.M._T
  1810: 5a 5f 5b 85 45 08 54 5a 30 31 14 0a 5f 43 52 54  Z_[.E.TZ01.._CRT
  1820: 08 a4 0b f8 0e 14 43 07 5f 54 4d 50 08 a0 47 06  ......C._TMP..G.
  1830: 45 43 4f 4e a0 3c 44 54 53 45 70 44 54 53 32 61  ECON.<DTSEpDTS2a
  1840: a0 11 92 95 44 54 53 31 44 54 53 32 70 44 54 53  ....DTS1DTS2pDTS
  1850: 31 61 a0 1e 95 61 0a 6e 70 61 5c 2f 05 5f 53 42  1a...a.npa\/._SB
  1860: 5f 50 43 49 30 4c 50 43 5f 45 43 30 5f 53 4b 54  _PCI0LPC_EC0_SKT
  1870: 41 70 5c 2f 05 5f 53 42 5f 50 43 49 30 4c 50 43  Ap\/._SB_PCI0LPC
  1880: 5f 45 43 30 5f 43 54 4d 50 61 a4 72 0b ac 0a 77  _EC0_CTMPa.r...w
  1890: 61 0a 0a 00 00 a4 0b b8 0b 14 41 04 47 45 54 50  a.........A.GETP
  18a0: 09 a0 0a 93 7b 68 0a 09 00 00 a4 ff a0 0d 93 7b  ....{h.........{
  18b0: 68 0a 09 00 0a 08 a4 0b 84 03 7a 7b 68 0b 00 03  h.........z{h...
  18c0: 00 0a 08 60 7a 7b 68 0b 00 30 00 0a 0c 61 a4 77  ...`z{h..0...a.w
  18d0: 0a 1e 74 0a 09 72 60 61 00 00 00 14 28 47 44 4d  ..t..r`a....(GDM
  18e0: 41 0d a0 1f 68 a0 05 69 a4 0a 14 a0 0c 6a a4 77  A...h..i.....j.w
  18f0: 74 0a 04 6b 00 0a 0f 00 a4 77 74 0a 04 6b 00 0a  t..k.....wt..k..
  1900: 1e 00 a4 ff 14 1f 47 45 54 54 09 a4 77 0a 1e 74  ......GETT..w..t
  1910: 0a 09 72 7b 7a 68 0a 02 00 0a 03 00 7b 68 0a 03  ..r{zh......{h..
  1920: 00 00 00 00 14 44 06 47 45 54 46 0b 08 54 4d 50  .....D.GETF..TMP
  1930: 46 00 a0 0c 68 7d 54 4d 50 46 01 54 4d 50 46 a0  F...h}TMPF.TMPF.
  1940: 11 7b 6a 0a 02 00 7d 54 4d 50 46 0a 02 54 4d 50  .{j...}TMPF..TMP
  1950: 46 a0 0d 69 7d 54 4d 50 46 0a 04 54 4d 50 46 a0  F..i}TMPF..TMPF.
  1960: 11 7b 6a 0a 20 00 7d 54 4d 50 46 0a 08 54 4d 50  .{j. .}TMPF..TMP
  1970: 46 a0 12 7b 6a 0b 00 40 00 7d 54 4d 50 46 0a 10  F..{j..@.}TMPF..
  1980: 54 4d 50 46 a4 54 4d 50 46 14 3d 53 45 54 50 0b  TMPF.TMPF.=SETP.
  1990: a0 08 94 68 0a f0 a4 0a 08 a1 2d a0 27 7b 69 0a  ...h......-.'{i.
  19a0: 02 00 a0 10 90 92 94 68 0a 78 7b 6a 0a 02 00 a4  .......h.x{j....
  19b0: 0b 01 23 a0 0f 90 92 94 68 0a b4 7b 6a 01 00 a4  ..#.....h..{j...
  19c0: 0b 01 21 a4 0b 01 10 14 37 53 44 4d 41 09 a0 08  ..!.....7SDMA...
  19d0: 92 94 68 0a 14 a4 01 a0 09 92 94 68 0a 1e a4 0a  ..h........h....
  19e0: 02 a0 08 92 94 68 0a 2d a4 01 a0 09 92 94 68 0a  .....h.-......h.
  19f0: 3c a4 0a 02 a0 08 92 94 68 0a 5a a4 01 a4 00 14  <.......h.Z.....
  1a00: 2f 53 45 54 54 0b a0 25 7b 69 0a 02 00 a0 0f 90  /SETT..%{i......
  1a10: 92 94 68 0a 78 7b 6a 0a 02 00 a4 0a 0b a0 0e 90  ..h.x{j.........
  1a20: 92 94 68 0a b4 7b 6a 01 00 a4 0a 09 a4 0a 04 10  ..h..{j.........
  1a30: 87 aa 09 5f 53 42 5f 5b 82 8e a9 09 50 43 49 30  ..._SB_[....PCI0
  1a40: 08 5f 48 49 44 0c 41 d0 0a 08 08 5f 43 49 44 0c  ._HID.A...._CID.
  1a50: 41 d0 0a 03 08 5f 41 44 52 00 5b 82 49 38 57 4d  A...._ADR.[.I8WM
  1a60: 49 31 08 5f 48 49 44 0d 70 6e 70 30 63 31 34 00  I1._HID.pnp0c14.
  1a70: 08 5f 55 49 44 0d 4d 58 4d 32 00 08 5f 57 44 47  ._UID.MXM2.._WDG
  1a80: 11 3f 0a 3c 3c 5c cb f6 ae 9c bd 4e b5 77 93 1e  .?.<<\.....N.w..
  1a90: a3 2a 2c c0 4d 58 01 02 57 93 8a f2 4b cf 1a 4a  .*,.MX..W...K..J
  1aa0: 88 93 bb 1f 58 ee a1 af d1 00 01 08 21 12 90 05  ....X.......!...
  1ab0: 66 d5 d1 11 b2 f0 00 a0 c9 06 29 10 58 4d 01 00  f.........).XM..
  1ac0: 14 4d 07 57 4d 4d 58 03 a0 43 07 92 95 87 6a 0a  .M.WMMX..C....j.
  1ad0: 04 8a 6a 00 46 55 4e 43 8a 6a 0a 04 41 52 47 53  ..j.FUNC.j..ARGS
  1ae0: a0 20 93 46 55 4e 43 0c 4d 58 4d 49 a4 5e 5e 2f  . .FUNC.MXMI.^^/
  1af0: 03 50 45 47 50 56 47 41 5f 4d 58 4d 49 41 52 47  .PEGPVGA_MXMIARG
  1b00: 53 a1 3a a0 20 93 46 55 4e 43 0c 4d 58 4d 53 a4  S.:. .FUNC.MXMS.
  1b10: 5e 5e 2f 03 50 45 47 50 56 47 41 5f 4d 58 4d 53  ^^/.PEGPVGA_MXMS
  1b20: 41 52 47 53 a1 17 a0 15 93 46 55 4e 43 0c 4d 58  ARGS.....FUNC.MX
  1b30: 4d 58 a0 09 92 95 87 69 0a 08 a4 01 a4 00 08 57  MX.....i.......W
  1b40: 51 42 41 11 41 2a 0b 9c 02 46 4f 4d 42 01 00 00  QBA.A*...FOMB...
  1b50: 00 8b 02 00 00 0c 08 00 00 44 53 00 01 1a 7d da  .........DS...}.
  1b60: 54 18 d2 83 00 01 06 18 42 10 05 10 8a e6 80 42  T.......B......B
  1b70: 04 92 43 a4 30 30 28 0b 20 86 90 0b 26 26 40 04  ..C.00(. ...&&@.
  1b80: 84 bc 0a b0 29 c0 24 88 fa f7 87 28 09 0e 25 04  ....).$....(..%.
  1b90: 42 12 05 98 17 a0 5b 80 61 01 b6 05 98 16 e0 18  B.....[.a.......
  1ba0: 92 4a 03 a7 04 96 02 21 a1 02 94 0b f0 2d 40 3b  .J.....!.....-@;
  1bb0: a2 24 0b b0 0c 23 02 8f 82 a1 71 68 ec 30 2c 13  .$...#....qh.0,.
  1bc0: 4c 83 38 8c b2 91 45 60 dc 4e 05 c8 15 20 4c 80  L.8...E`.N... L.
  1bd0: 78 54 61 34 07 45 e0 42 63 64 40 c8 a3 00 ab a3  xTa4.E.Bcd@.....
  1be0: d0 a4 12 d8 bd 00 8d 02 b4 09 70 28 40 a1 00 6b  ..........p(@..k
  1bf0: 18 72 06 21 5b d8 c2 68 50 80 45 14 8d e0 2c 2a  .r.![..hP.E...,*
  1c00: 9e 93 50 02 da 1b 82 f0 8c d9 18 9e 10 83 54 86  ..P...........T.
  1c10: 21 88 b8 11 8e a5 fd 41 10 f9 ab d7 b8 1d 69 34  !......A......i4
  1c20: a8 b1 26 38 76 8f e6 84 3b 17 20 7d 6e 02 39 ba  ..&8v...;. }n.9.
  1c30: d3 a8 73 d0 64 78 0c 2b c1 7f 80 4f 01 78 d7 80  ..s.dx.+...O.x..
  1c40: 9a fe c1 33 41 70 a8 21 7a d4 e1 4e e0 bc 8e 84  ...3Ap.!z..N....
  1c50: 41 1c d1 71 63 67 75 32 07 5d aa 00 b3 07 00 0d  A..qcgu2.]......
  1c60: 2e c1 69 9f 49 e8 f7 80 f3 e9 79 6c 6c 10 a8 91  ..i.I.....yll...
  1c70: f9 ff 0f ed 41 9e 56 cc 90 cf 02 87 c5 c4 1e 19  ....A.V.........
  1c80: e8 78 c0 7f 00 78 34 88 f0 66 e0 f9 9a 60 50 08  .x...x4..f...`P.
  1c90: 39 19 0f 4a cc f9 80 cc 25 c4 43 c0 31 c4 08 7a  9..J....%.C.1..z
  1ca0: 46 45 23 6b 22 3e 03 78 dc 96 05 42 09 0c ec 73  FE#k">.x...B...s
  1cb0: c3 3b 84 61 71 a3 09 ec f3 85 05 0e 0a 05 eb bb  .;.aq...........
  1cc0: 42 cc e7 81 e3 3c 60 0b 9f 28 01 3e 24 8f 06 de  B....<`..(.>$...
  1cd0: 20 e1 5b 3f 02 10 e0 27 06 13 58 1e 30 7a 94 f6   .[?...'..X.0z..
  1ce0: 2b 00 21 f8 8b c5 53 c0 eb 40 84 63 81 29 72 6c  +.!...S..@.c.)rl
  1cf0: 68 78 7e 70 88 1e f5 5c c2 1f 4d 94 53 38 1c 1f  hx~p...\..M.S8..
  1d00: 39 8c 10 fe 49 e3 c9 c3 9a ef 00 9a d2 5b c0 fb  9...I........[..
  1d10: 83 47 80 11 20 e1 68 82 89 7c 3a 01 d5 ff ff 74  .G.. .h..|:....t
  1d20: 02 b8 ba 01 14 37 6a 9d 49 7c 2c f1 ad e4 bc 43  .....7j.I|,....C
  1d30: c5 7f 93 78 3a f1 34 1e 4c 42 44 89 18 21 a2 ef  ...x:.4.LBD..!..
  1d40: 27 46 08 15 31 6c a4 37 80 e7 13 e3 84 08 f4 74  'F..1l.7.......t
  1d50: c2 42 3e 34 a4 e1 74 02 50 e0 ff 7f 3a 81 1f f5  .B>4..t.P...:...
  1d60: 74 82 1e ae 4f 19 18 e4 03 f2 a9 c3 f7 1f 13 f8  t...O...........
  1d70: 78 c2 45 1d 4f 50 a7 07 1f 4f d8 19 e1 2c 1e 03  x.E.OP...O...,..
  1d80: 7c 3a c1 dc 13 7c 3a 01 db 68 60 1c 4f c0 77 74  |:...|:..h`.O.wt
  1d90: c1 1d 4f c0 30 18 18 e7 13 e0 31 5e dc 31 c0 43  ..O.0.....1^.1.C
  1da0: e0 03 78 dc 38 3d 2b 9d 14 f2 24 c2 07 85 39 b0  ..x.8=+...$...9.
  1db0: e0 14 da f4 a9 d1 a8 55 83 32 35 ca 34 a8 d5 a7  .......U.25.4...
  1dc0: 52 63 c6 ce 19 0e f8 10 d0 89 c0 f2 9e 0d 02 b1  Rc..............
  1dd0: 0c 0a 81 58 fa ab 45 20 0e 0e a2 ff 3f 88 23 d2  ...X..E ....?.#.
  1de0: 0a c4 ff 7f 7f 14 4b 06 5f 49 4e 49 00 70 0a 12  ......K._INI.p..
  1df0: 50 38 30 48 70 00 46 54 41 54 a0 4c 04 5b 12 5f  P80Hp.FTAT.L.[._
  1e00: 4f 53 49 60 a0 1a 5f 4f 53 49 0d 4c 69 6e 75 78  OSI`.._OSI.Linux
  1e10: 00 70 0b e8 03 4f 53 59 53 4f 53 4d 49 0a 72 a1  .p...OSYSOSMI.r.
  1e20: 27 a0 1b 5f 4f 53 49 0d 57 69 6e 64 6f 77 73 20  '.._OSI.Windows 
  1e30: 32 30 30 36 00 70 0b d6 07 4f 53 59 53 a1 09 70  2006.p...OSYS..p
  1e40: 0b d1 07 4f 53 59 53 a1 09 70 0b d0 07 4f 53 59  ...OSYS..p...OSY
  1e50: 53 08 5f 42 42 4e 00 5b 80 48 42 55 53 02 0a 40  S._BBN.[.HBUS..@
  1e60: 0a c0 5b 81 46 0d 48 42 55 53 03 45 50 45 4e 01  ..[.F.HBUS.EPEN.
  1e70: 00 0b 45 50 42 52 14 00 20 4d 48 45 4e 01 00 0d  ..EPBR.. MHEN...
  1e80: 4d 48 42 52 12 00 40 0a 50 58 45 4e 01 50 58 53  MHBR..@.PXEN.PXS
  1e90: 5a 02 00 17 50 58 42 52 06 00 20 44 49 45 4e 01  Z...PXBR.. DIEN.
  1ea0: 00 0b 44 49 42 52 14 00 20 49 50 45 4e 01 00 0b  ..DIBR.. IPEN...
  1eb0: 49 50 42 52 14 00 40 0e 00 04 50 4d 30 48 02 00  IPBR..@...PM0H..
  1ec0: 02 50 4d 31 4c 02 00 02 50 4d 31 48 02 00 02 50  .PM1L...PM1H...P
  1ed0: 4d 32 4c 02 00 02 50 4d 32 48 02 00 02 50 4d 33  M2L...PM2H...PM3
  1ee0: 4c 02 00 02 50 4d 33 48 02 00 02 50 4d 34 4c 02  L...PM3H...PM4L.
  1ef0: 00 02 50 4d 34 48 02 00 02 50 4d 35 4c 02 00 02  ..PM4H...PM5L...
  1f00: 50 4d 35 48 02 00 02 50 4d 36 4c 02 00 02 50 4d  PM5H...PM6L...PM
  1f10: 36 48 02 00 02 00 07 48 45 4e 41 01 00 40 05 54  6H.....HENA..@.T
  1f20: 55 55 44 10 00 40 06 00 04 54 4c 55 44 0c 00 48  UUD..@...TLUD..H
  1f30: 0b 00 03 47 54 53 45 01 00 04 5b 80 4d 43 48 54  ...GTSE...[.MCHT
  1f40: 00 0c 00 10 d1 fe 0a ff 5b 81 1e 4d 43 48 54 01  ........[..MCHT.
  1f50: 00 40 0f 54 30 49 53 10 00 40 1f 54 31 49 53 10  .@.T0IS..@.T1IS.
  1f60: 00 48 47 45 53 43 53 08 08 42 55 46 30 11 43 1f  .HGESCS..BUF0.C.
  1f70: 0b ee 01 88 0d 00 02 0c 00 00 00 00 00 ff 00 00  ................
  1f80: 00 00 01 87 17 00 01 0c 03 00 00 00 00 00 00 00  ................
  1f90: 00 f7 0c 00 00 00 00 00 00 f8 0c 00 00 47 01 f8  .............G..
  1fa0: 0c f8 0c 01 08 87 17 00 01 0c 03 00 00 00 00 00  ................
  1fb0: 0d 00 00 ff ff 00 00 00 00 00 00 00 f3 00 00 87  ................
  1fc0: 17 00 00 0c 03 00 00 00 00 00 00 0a 00 ff ff 0b  ................
  1fd0: 00 00 00 00 00 00 00 02 00 87 17 00 00 0c 03 00  ................
  1fe0: 00 00 00 00 00 0c 00 ff 3f 0c 00 00 00 00 00 00  ........?.......
  1ff0: 40 00 00 87 17 00 00 0c 03 00 00 00 00 00 40 0c  @.............@.
  2000: 00 ff 7f 0c 00 00 00 00 00 00 40 00 00 87 17 00  ..........@.....
  2010: 00 0c 03 00 00 00 00 00 80 0c 00 ff bf 0c 00 00  ................
  2020: 00 00 00 00 40 00 00 87 17 00 00 0c 03 00 00 00  ....@...........
  2030: 00 00 c0 0c 00 ff ff 0c 00 00 00 00 00 00 40 00  ..............@.
  2040: 00 87 17 00 00 0c 03 00 00 00 00 00 00 0d 00 ff  ................
  2050: 3f 0d 00 00 00 00 00 00 40 00 00 87 17 00 00 0c  ?.......@.......
  2060: 03 00 00 00 00 00 40 0d 00 ff 7f 0d 00 00 00 00  ......@.........
  2070: 00 00 40 00 00 87 17 00 00 0c 03 00 00 00 00 00  ..@.............
  2080: 80 0d 00 ff bf 0d 00 00 00 00 00 00 40 00 00 87  ............@...
  2090: 17 00 00 0c 03 00 00 00 00 00 c0 0d 00 ff ff 0d  ................
  20a0: 00 00 00 00 00 00 40 00 00 87 17 00 00 0c 03 00  ......@.........
  20b0: 00 00 00 00 00 0e 00 ff 3f 0e 00 00 00 00 00 00  ........?.......
  20c0: 40 00 00 87 17 00 00 0c 03 00 00 00 00 00 40 0e  @.............@.
  20d0: 00 ff 7f 0e 00 00 00 00 00 00 40 00 00 87 17 00  ..........@.....
  20e0: 00 0c 03 00 00 00 00 00 80 0e 00 ff bf 0e 00 00  ................
  20f0: 00 00 00 00 40 00 00 87 17 00 00 0c 03 00 00 00  ....@...........
  2100: 00 00 c0 0e 00 ff ff 0e 00 00 00 00 00 00 40 00  ..............@.
  2110: 00 87 17 00 00 0c 03 00 00 00 00 00 00 0f 00 ff  ................
  2120: ff 0f 00 00 00 00 00 00 00 01 00 87 17 00 00 0c  ................
  2130: 03 00 00 00 00 00 00 00 00 ff ff bf fe 00 00 00  ................
  2140: 00 00 00 00 00 87 17 00 00 0c 03 00 00 00 00 00  ................
  2150: 00 d4 fe ff 4f d4 fe 00 00 00 00 00 00 00 00 79  ....O..........y
  2160: 00 14 4f 2c 5f 43 52 53 08 a0 16 50 4d 31 4c 8a  ..O,_CRS...PM1L.
  2170: 42 55 46 30 0a 7c 43 30 4c 4e 70 00 43 30 4c 4e  BUF0.|C0LNp.C0LN
  2180: a0 19 93 50 4d 31 4c 01 8d 42 55 46 30 0b 58 03  ...PM1L..BUF0.X.
  2190: 43 30 52 57 70 00 43 30 52 57 a0 16 50 4d 31 48  C0RWp.C0RW..PM1H
  21a0: 8a 42 55 46 30 0a 96 43 34 4c 4e 70 00 43 34 4c  .BUF0..C4LNp.C4L
  21b0: 4e a0 19 93 50 4d 31 48 01 8d 42 55 46 30 0b 28  N...PM1H..BUF0.(
  21c0: 04 43 34 52 57 70 00 43 34 52 57 a0 16 50 4d 32  .C4RWp.C4RW..PM2
  21d0: 4c 8a 42 55 46 30 0a b0 43 38 4c 4e 70 00 43 38  L.BUF0..C8LNp.C8
  21e0: 4c 4e a0 19 93 50 4d 32 4c 01 8d 42 55 46 30 0b  LN...PM2L..BUF0.
  21f0: f8 04 43 38 52 57 70 00 43 38 52 57 a0 16 50 4d  ..C8RWp.C8RW..PM
  2200: 32 48 8a 42 55 46 30 0a ca 43 43 4c 4e 70 00 43  2H.BUF0..CCLNp.C
  2210: 43 4c 4e a0 19 93 50 4d 32 48 01 8d 42 55 46 30  CLN...PM2H..BUF0
  2220: 0b c8 05 43 43 52 57 70 00 43 43 52 57 a0 16 50  ...CCRWp.CCRW..P
  2230: 4d 33 4c 8a 42 55 46 30 0a e4 44 30 4c 4e 70 00  M3L.BUF0..D0LNp.
  2240: 44 30 4c 4e a0 19 93 50 4d 33 4c 01 8d 42 55 46  D0LN...PM3L..BUF
  2250: 30 0b 98 06 44 30 52 57 70 00 44 30 52 57 a0 16  0...D0RWp.D0RW..
  2260: 50 4d 33 48 8a 42 55 46 30 0a fe 44 34 4c 4e 70  PM3H.BUF0..D4LNp
  2270: 00 44 34 4c 4e a0 19 93 50 4d 33 48 01 8d 42 55  .D4LN...PM3H..BU
  2280: 46 30 0b 68 07 44 34 52 57 70 00 44 34 52 57 a0  F0.h.D4RWp.D4RW.
  2290: 17 50 4d 34 4c 8a 42 55 46 30 0b 18 01 44 38 4c  .PM4L.BUF0...D8L
  22a0: 4e 70 00 44 38 4c 4e a0 19 93 50 4d 34 4c 01 8d  Np.D8LN...PM4L..
  22b0: 42 55 46 30 0b 38 08 44 38 52 57 70 00 44 38 52  BUF0.8.D8RWp.D8R
  22c0: 57 a0 17 50 4d 34 48 8a 42 55 46 30 0b 32 01 44  W..PM4H.BUF0.2.D
  22d0: 43 4c 4e 70 00 44 43 4c 4e a0 19 93 50 4d 34 48  CLNp.DCLN...PM4H
  22e0: 01 8d 42 55 46 30 0b 08 09 44 43 52 57 70 00 44  ..BUF0...DCRWp.D
  22f0: 43 52 57 a0 17 50 4d 35 4c 8a 42 55 46 30 0b 4c  CRW..PM5L.BUF0.L
  2300: 01 45 30 4c 4e 70 00 45 30 4c 4e a0 19 93 50 4d  .E0LNp.E0LN...PM
  2310: 35 4c 01 8d 42 55 46 30 0b d8 09 45 30 52 57 70  5L..BUF0...E0RWp
  2320: 00 45 30 52 57 a0 17 50 4d 35 48 8a 42 55 46 30  .E0RW..PM5H.BUF0
  2330: 0b 66 01 45 34 4c 4e 70 00 45 34 4c 4e a0 19 93  .f.E4LNp.E4LN...
  2340: 50 4d 35 48 01 8d 42 55 46 30 0b a8 0a 45 34 52  PM5H..BUF0...E4R
  2350: 57 70 00 45 34 52 57 a0 17 50 4d 36 4c 8a 42 55  Wp.E4RW..PM6L.BU
  2360: 46 30 0b 80 01 45 38 4c 4e 70 00 45 38 4c 4e a0  F0...E8LNp.E8LN.
  2370: 19 93 50 4d 36 4c 01 8d 42 55 46 30 0b 78 0b 45  ..PM6L..BUF0.x.E
  2380: 38 52 57 70 00 45 38 52 57 a0 17 50 4d 36 48 8a  8RWp.E8RW..PM6H.
  2390: 42 55 46 30 0b 9a 01 45 43 4c 4e 70 00 45 43 4c  BUF0...ECLNp.ECL
  23a0: 4e a0 19 93 50 4d 36 48 01 8d 42 55 46 30 0b 48  N...PM6H..BUF0.H
  23b0: 0c 45 43 52 57 70 00 45 43 52 57 a0 17 50 4d 30  .ECRWp.ECRW..PM0
  23c0: 48 8a 42 55 46 30 0b b4 01 46 30 4c 4e 70 00 46  H.BUF0...F0LNp.F
  23d0: 30 4c 4e a0 19 93 50 4d 30 48 01 8d 42 55 46 30  0LN...PM0H..BUF0
  23e0: 0b 18 0d 46 30 52 57 70 00 46 30 52 57 8a 42 55  ...F0RWp.F0RW.BU
  23f0: 46 30 0b c2 01 4d 31 4d 4e 8a 42 55 46 30 0b c6  F0...M1MN.BUF0..
  2400: 01 4d 31 4d 58 8a 42 55 46 30 0b ce 01 4d 31 4c  .M1MX.BUF0...M1L
  2410: 4e 79 54 4c 55 44 0a 14 4d 31 4d 4e 72 74 4d 31  NyTLUD..M1MNrtM1
  2420: 4d 58 4d 31 4d 4e 00 01 4d 31 4c 4e a4 42 55 46  MXM1MN..M1LN.BUF
  2430: 30 14 45 39 5f 50 52 54 00 a0 45 23 93 47 50 49  0.E9_PRT..E#.GPI
  2440: 43 00 a4 12 4b 22 1b 12 13 04 0c ff ff 01 00 00  C...K"..........
  2450: 5e 2e 4c 50 43 5f 4c 4e 4b 41 00 12 13 04 0c ff  ^.LPC_LNKA......
  2460: ff 01 00 01 5e 2e 4c 50 43 5f 4c 4e 4b 42 00 12  ....^.LPC_LNKB..
  2470: 14 04 0c ff ff 01 00 0a 02 5e 2e 4c 50 43 5f 4c  .........^.LPC_L
  2480: 4e 4b 43 00 12 14 04 0c ff ff 01 00 0a 03 5e 2e  NKC...........^.
  2490: 4c 50 43 5f 4c 4e 4b 44 00 12 13 04 0c ff ff 02  LPC_LNKD........
  24a0: 00 00 5e 2e 4c 50 43 5f 4c 4e 4b 41 00 12 13 04  ..^.LPC_LNKA....
  24b0: 0c ff ff 03 00 00 5e 2e 4c 50 43 5f 4c 4e 4b 41  ......^.LPC_LNKA
  24c0: 00 12 13 04 0c ff ff 03 00 01 5e 2e 4c 50 43 5f  ..........^.LPC_
  24d0: 4c 4e 4b 42 00 12 14 04 0c ff ff 03 00 0a 02 5e  LNKB...........^
  24e0: 2e 4c 50 43 5f 4c 4e 4b 43 00 12 14 04 0c ff ff  .LPC_LNKC.......
  24f0: 03 00 0a 03 5e 2e 4c 50 43 5f 4c 4e 4b 44 00 12  ....^.LPC_LNKD..
  2500: 13 04 0c ff ff 19 00 00 5e 2e 4c 50 43 5f 4c 4e  ........^.LPC_LN
  2510: 4b 45 00 12 13 04 0c ff ff 1a 00 00 5e 2e 4c 50  KE..........^.LP
  2520: 43 5f 4c 4e 4b 45 00 12 13 04 0c ff ff 1a 00 01  C_LNKE..........
  2530: 5e 2e 4c 50 43 5f 4c 4e 4b 46 00 12 14 04 0c ff  ^.LPC_LNKF......
  2540: ff 1a 00 0a 02 5e 2e 4c 50 43 5f 4c 4e 4b 43 00  .....^.LPC_LNKC.
  2550: 12 14 04 0c ff ff 1a 00 0a 03 5e 2e 4c 50 43 5f  ..........^.LPC_
  2560: 4c 4e 4b 46 00 12 13 04 0c ff ff 1b 00 00 5e 2e  LNKF..........^.
  2570: 4c 50 43 5f 4c 4e 4b 47 00 12 13 04 0c ff ff 1c  LPC_LNKG........
  2580: 00 00 5e 2e 4c 50 43 5f 4c 4e 4b 42 00 12 13 04  ..^.LPC_LNKB....
  2590: 0c ff ff 1c 00 01 5e 2e 4c 50 43 5f 4c 4e 4b 41  ......^.LPC_LNKA
  25a0: 00 12 14 04 0c ff ff 1c 00 0a 02 5e 2e 4c 50 43  ...........^.LPC
  25b0: 5f 4c 4e 4b 43 00 12 14 04 0c ff ff 1c 00 0a 03  _LNKC...........
  25c0: 5e 2e 4c 50 43 5f 4c 4e 4b 44 00 12 13 04 0c ff  ^.LPC_LNKD......
  25d0: ff 1d 00 00 5e 2e 4c 50 43 5f 4c 4e 4b 48 00 12  ....^.LPC_LNKH..
  25e0: 13 04 0c ff ff 1d 00 01 5e 2e 4c 50 43 5f 4c 4e  ........^.LPC_LN
  25f0: 4b 44 00 12 14 04 0c ff ff 1d 00 0a 02 5e 2e 4c  KD...........^.L
  2600: 50 43 5f 4c 4e 4b 43 00 12 14 04 0c ff ff 1d 00  PC_LNKC.........
  2610: 0a 03 5e 2e 4c 50 43 5f 4c 4e 4b 45 00 12 13 04  ..^.LPC_LNKE....
  2620: 0c ff ff 1f 00 00 5e 2e 4c 50 43 5f 4c 4e 4b 43  ......^.LPC_LNKC
  2630: 00 12 13 04 0c ff ff 1f 00 01 5e 2e 4c 50 43 5f  ..........^.LPC_
  2640: 4c 4e 4b 44 00 12 14 04 0c ff ff 1f 00 0a 02 5e  LNKD...........^
  2650: 2e 4c 50 43 5f 4c 4e 4b 43 00 12 14 04 0c ff ff  .LPC_LNKC.......
  2660: 1f 00 0a 03 5e 2e 4c 50 43 5f 4c 4e 4b 41 00 a1  ....^.LPC_LNKA..
  2670: 47 15 a4 12 43 15 1b 12 0b 04 0c ff ff 01 00 00  G...C...........
  2680: 00 0a 10 12 0b 04 0c ff ff 01 00 01 00 0a 11 12  ................
  2690: 0c 04 0c ff ff 01 00 0a 02 00 0a 12 12 0c 04 0c  ................
  26a0: ff ff 01 00 0a 03 00 0a 13 12 0b 04 0c ff ff 02  ................
  26b0: 00 00 00 0a 10 12 0b 04 0c ff ff 03 00 00 00 0a  ................
  26c0: 10 12 0b 04 0c ff ff 03 00 01 00 0a 11 12 0c 04  ................
  26d0: 0c ff ff 03 00 0a 02 00 0a 12 12 0c 04 0c ff ff  ................
  26e0: 03 00 0a 03 00 0a 13 12 0b 04 0c ff ff 19 00 00  ................
  26f0: 00 0a 14 12 0b 04 0c ff ff 1a 00 00 00 0a 14 12  ................
  2700: 0b 04 0c ff ff 1a 00 01 00 0a 15 12 0c 04 0c ff  ................
  2710: ff 1a 00 0a 02 00 0a 12 12 0c 04 0c ff ff 1a 00  ................
  2720: 0a 03 00 0a 15 12 0b 04 0c ff ff 1b 00 00 00 0a  ................
  2730: 16 12 0b 04 0c ff ff 1c 00 00 00 0a 11 12 0b 04  ................
  2740: 0c ff ff 1c 00 01 00 0a 10 12 0c 04 0c ff ff 1c  ................
  2750: 00 0a 02 00 0a 12 12 0c 04 0c ff ff 1c 00 0a 03  ................
  2760: 00 0a 13 12 0b 04 0c ff ff 1d 00 00 00 0a 17 12  ................
  2770: 0b 04 0c ff ff 1d 00 01 00 0a 13 12 0c 04 0c ff  ................
  2780: ff 1d 00 0a 02 00 0a 12 12 0c 04 0c ff ff 1d 00  ................
  2790: 0a 03 00 0a 14 12 0b 04 0c ff ff 1f 00 00 00 0a  ................
  27a0: 12 12 0b 04 0c ff ff 1f 00 01 00 0a 13 12 0c 04  ................
  27b0: 0c ff ff 1f 00 0a 02 00 0a 12 12 0c 04 0c ff ff  ................
  27c0: 1f 00 0a 03 00 0a 10 5b 82 4e 9e 50 45 47 50 08  .......[.N.PEGP.
  27d0: 5f 41 44 52 0c 00 00 01 00 14 43 05 5f 50 52 54  _ADR......C._PRT
  27e0: 00 a0 31 93 47 50 49 43 00 a4 12 28 02 12 12 04  ..1.GPIC...(....
  27f0: 0b ff ff 00 5e 5e 2e 4c 50 43 5f 4c 4e 4b 41 00  ....^^.LPC_LNKA.
  2800: 12 12 04 0b ff ff 01 5e 5e 2e 4c 50 43 5f 4c 4e  .......^^.LPC_LN
  2810: 4b 42 00 a1 19 a4 12 16 02 12 09 04 0b ff ff 00  KB..............
  2820: 00 0a 10 12 09 04 0b ff ff 01 00 0a 11 5b 82 48  .............[.H
  2830: 98 56 47 41 5f 08 5f 41 44 52 00 08 53 57 49 54  .VGA_._ADR..SWIT
  2840: 01 08 43 52 54 41 01 08 4c 43 44 41 01 08 54 56  ..CRTA..LCDA..TV
  2850: 41 41 01 08 44 56 49 41 01 08 56 4c 44 46 01 5b  AA..DVIA..VLDF.[
  2860: 80 56 49 44 53 02 00 0a c8 5b 81 0b 56 49 44 53  .VIDS....[..VIDS
  2870: 03 56 44 49 44 20 14 09 5f 53 54 41 00 a4 0a 0f  .VDID .._STA....
  2880: 08 5f 50 53 43 00 14 0c 5f 50 53 30 00 70 00 5f  ._PSC..._PS0.p._
  2890: 50 53 43 14 0c 5f 50 53 31 00 70 01 5f 50 53 43  PSC.._PS1.p._PSC
  28a0: 14 0d 5f 50 53 33 00 70 0a 03 5f 50 53 43 14 10  .._PS3.p.._PSC..
  28b0: 5f 44 4f 53 01 70 7b 68 0a 07 00 44 53 45 4e 14  _DOS.p{h...DSEN.
  28c0: 17 5f 44 4f 44 00 a4 12 0f 03 0b 10 01 0c 00 01  ._DOD...........
  28d0: 00 80 0c 30 73 00 80 5b 82 45 04 43 52 54 5f 14  ...0s..[.E.CRT_.
  28e0: 0c 5f 41 44 52 00 a4 0c 00 01 00 80 14 09 5f 44  ._ADR........._D
  28f0: 43 53 00 a4 0a 1f 14 17 5f 44 47 53 00 7b 53 57  CS......_DGS.{SW
  2900: 49 54 0a 02 60 a0 04 60 a4 01 a1 03 a4 00 14 06  IT..`..`........
  2910: 5f 44 53 53 01 14 08 4d 58 4d 58 01 a4 01 5b 82  _DSS...MXMX...[.
  2920: 48 0b 4c 43 44 5f 14 0a 5f 41 44 52 00 a4 0b 10  H.LCD_.._ADR....
  2930: 01 14 09 5f 44 43 53 00 a4 0a 1f 14 16 5f 44 47  ..._DCS......_DG
  2940: 53 00 7b 53 57 49 54 01 60 a0 04 60 a4 01 a1 03  S.{SWIT.`..`....
  2950: a4 00 14 06 5f 44 53 53 01 14 08 4d 58 4d 58 01  ...._DSS...MXMX.
  2960: a4 01 14 22 5f 42 43 4c 00 a4 12 1a 0c 0a 46 0a  ..."_BCL......F.
  2970: 28 0a 0a 0a 14 0a 1e 0a 28 0a 32 0a 3c 0a 46 0a  (.......(.2.<.F.
  2980: 50 0a 5a 0a 64 14 22 5f 42 43 4d 01 78 68 0a 0a  P.Z.d."_BCM.xh..
  2990: 60 61 76 61 70 61 5e 5e 5e 5e 2f 03 4c 50 43 5f  `avapa^^^^/.LPC_
  29a0: 45 43 30 5f 42 52 54 53 14 2f 5f 42 51 43 00 70  EC0_BRTS./_BQC.p
  29b0: 5e 5e 5e 5e 2f 03 4c 50 43 5f 45 43 30 5f 42 52  ^^^^/.LPC_EC0_BR
  29c0: 54 53 60 72 60 01 60 77 60 0a 0a 60 70 60 50 38  TS`r`.`w`..`p`P8
  29d0: 30 48 5b 22 0a 64 a4 60 5b 82 42 04 48 44 56 30  0H[".d.`[.B.HDV0
  29e0: 08 5f 41 44 52 0c 30 73 00 80 14 17 5f 44 47 53  ._ADR.0s...._DGS
  29f0: 00 7b 53 57 49 54 0a 08 60 a0 04 60 a4 01 a1 03  .{SWIT..`..`....
  2a00: a4 00 14 09 5f 44 43 53 00 a4 0a 1f 14 06 5f 44  ...._DCS......_D
  2a10: 53 53 01 14 08 4d 58 4d 58 01 a4 01 5b 82 44 08  SS...MXMX...[.D.
  2a20: 54 56 5f 5f 14 0a 5f 41 44 52 00 a4 0b 00 02 14  TV__.._ADR......
  2a30: 48 05 5f 44 43 53 00 4f 53 4d 49 0a 90 70 43 41  H._DCS.OSMI..pCA
  2a40: 44 4c 60 70 43 53 54 45 61 7b 60 0a 04 60 7b 61  DL`pCSTEa{`..`{a
  2a50: 0a 04 61 a0 08 60 70 01 54 56 41 41 a1 07 70 00  ..a..`p.TVAA..p.
  2a60: 54 56 41 41 a0 13 54 56 41 41 a0 08 93 61 0a 04  TVAA..TVAA...a..
  2a70: a4 0a 1f a1 04 a4 0a 1d a1 0f a0 08 93 61 0a 04  .............a..
  2a80: a4 0a 0f a1 04 a4 0a 0d 14 12 5f 44 47 53 00 a0  .........._DGS..
  2a90: 07 54 56 41 41 a4 01 a1 03 a4 00 14 06 5f 44 53  .TVAA........_DS
  2aa0: 53 01 5b 82 44 08 44 56 49 5f 14 0a 5f 41 44 52  S.[.D.DVI_.._ADR
  2ab0: 00 a4 0b 20 01 14 48 05 5f 44 43 53 00 4f 53 4d  ... ..H._DCS.OSM
  2ac0: 49 0a 90 70 43 41 44 4c 60 70 43 53 54 45 61 7b  I..pCADL`pCSTEa{
  2ad0: 60 0a 08 60 7b 61 0a 08 61 a0 08 60 70 01 44 56  `..`{a..a..`p.DV
  2ae0: 49 41 a1 07 70 00 44 56 49 41 a0 13 44 56 49 41  IA..p.DVIA..DVIA
  2af0: a0 08 93 61 0a 08 a4 0a 1f a1 04 a4 0a 1d a1 0f  ...a............
  2b00: a0 08 93 61 0a 08 a4 0a 0f a1 04 a4 0a 0d 14 12  ...a............
  2b10: 5f 44 47 53 00 a0 07 44 56 49 41 a4 01 a1 03 a4  _DGS...DVIA.....
  2b20: 00 14 06 5f 44 53 53 01 14 44 1a 44 53 53 57 00  ..._DSS..D.DSSW.
  2b30: a0 42 19 93 53 57 49 54 00 4f 53 4d 49 0a 90 70  .B..SWIT.OSMI..p
  2b40: 43 41 44 4c 60 70 43 53 54 45 61 a0 16 94 61 01  CADL`pCSTEa...a.
  2b50: 7b 60 61 56 4c 44 46 7b 56 4c 44 46 0a fe 56 4c  {`aVLDF{VLDF..VL
  2b60: 44 46 a0 43 15 56 4c 44 46 a0 27 93 60 0a 09 a0  DF.C.VLDF.'.`...
  2b70: 0b 93 61 0a 08 53 54 42 4c 0a 03 a0 09 93 61 01  ..a..STBL.....a.
  2b80: 53 54 42 4c 01 a0 0b 93 61 0a 09 53 54 42 4c 0a  STBL....a..STBL.
  2b90: 02 a0 28 93 60 0a 0a a0 0b 93 61 0a 08 53 54 42  ..(.`.....a..STB
  2ba0: 4c 0a 05 a0 0a 93 61 0a 02 53 54 42 4c 01 a0 0b  L.....a..STBL...
  2bb0: 93 61 0a 0a 53 54 42 4c 0a 04 a0 4b 04 93 60 0a  .a..STBL...K..`.
  2bc0: 0b a0 0b 93 61 0a 08 53 54 42 4c 0a 03 a0 0b 93  ....a..STBL.....
  2bd0: 61 0a 09 53 54 42 4c 0a 02 a0 0a 93 61 01 53 54  a..STBL.....a.ST
  2be0: 42 4c 0a 05 a0 0b 93 61 0a 0a 53 54 42 4c 0a 04  BL.....a..STBL..
  2bf0: a0 0a 93 61 0a 02 53 54 42 4c 01 a0 0a 93 61 0a  ...a..STBL....a.
  2c00: 0b 53 54 42 4c 01 a0 28 93 60 0a 0c a0 0b 93 61  .STBL..(.`.....a
  2c10: 0a 08 53 54 42 4c 0a 09 a0 0b 93 61 0a 0c 53 54  ..STBL.....a..ST
  2c20: 42 4c 0a 08 a0 0a 93 61 0a 04 53 54 42 4c 01 a0  BL.....a..STBL..
  2c30: 3f 93 60 0a 0d a0 0b 93 61 0a 08 53 54 42 4c 0a  ?.`.....a..STBL.
  2c40: 03 a0 0b 93 61 0a 09 53 54 42 4c 0a 02 a0 0a 93  ....a..STBL.....
  2c50: 61 01 53 54 42 4c 0a 09 a0 0b 93 61 0a 0c 53 54  a.STBL.....a..ST
  2c60: 42 4c 0a 08 a0 0a 93 61 0a 04 53 54 42 4c 01 a0  BL.....a..STBL..
  2c70: 46 04 91 93 60 0a 0e 93 60 0a 0f a0 0b 93 61 0a  F...`...`.....a.
  2c80: 08 53 54 42 4c 0a 09 a0 0b 93 61 0a 0c 53 54 42  .STBL.....a..STB
  2c90: 4c 0a 08 a0 0b 93 61 0a 04 53 54 42 4c 0a 05 a0  L.....a..STBL...
  2ca0: 0b 93 61 0a 0a 53 54 42 4c 0a 04 a0 0a 93 61 0a  ..a..STBL.....a.
  2cb0: 02 53 54 42 4c 01 a1 0c 70 01 56 4c 44 46 53 54  .STBL...p.VLDFST
  2cc0: 42 4c 01 a1 09 a0 07 93 53 57 49 54 01 14 4b 11  BL......SWIT..K.
  2cd0: 53 54 42 4c 01 a0 1c 93 68 01 70 00 43 52 54 41  STBL....h.p.CRTA
  2ce0: 70 01 4c 43 44 41 70 00 54 56 41 41 70 00 44 56  p.LCDAp.TVAAp.DV
  2cf0: 49 41 a0 1d 93 68 0a 02 70 01 43 52 54 41 70 00  IA...h..p.CRTAp.
  2d00: 4c 43 44 41 70 00 54 56 41 41 70 00 44 56 49 41  LCDAp.TVAAp.DVIA
  2d10: a0 1d 93 68 0a 03 70 01 43 52 54 41 70 01 4c 43  ...h..p.CRTAp.LC
  2d20: 44 41 70 00 54 56 41 41 70 00 44 56 49 41 a0 1d  DAp.TVAAp.DVIA..
  2d30: 93 68 0a 04 70 00 43 52 54 41 70 00 4c 43 44 41  .h..p.CRTAp.LCDA
  2d40: 70 01 54 56 41 41 70 00 44 56 49 41 a0 1d 93 68  p.TVAAp.DVIA...h
  2d50: 0a 05 70 00 43 52 54 41 70 01 4c 43 44 41 70 01  ..p.CRTAp.LCDAp.
  2d60: 54 56 41 41 70 00 44 56 49 41 a0 1d 93 68 0a 06  TVAAp.DVIA...h..
  2d70: 70 01 43 52 54 41 70 00 4c 43 44 41 70 01 54 56  p.CRTAp.LCDAp.TV
  2d80: 41 41 70 00 44 56 49 41 a0 1d 93 68 0a 07 70 01  AAp.DVIA...h..p.
  2d90: 43 52 54 41 70 01 4c 43 44 41 70 01 54 56 41 41  CRTAp.LCDAp.TVAA
  2da0: 70 00 44 56 49 41 a0 1d 93 68 0a 08 70 00 43 52  p.DVIA...h..p.CR
  2db0: 54 41 70 00 4c 43 44 41 70 00 54 56 41 41 70 01  TAp.LCDAp.TVAAp.
  2dc0: 44 56 49 41 a0 1d 93 68 0a 09 70 00 43 52 54 41  DVIA...h..p.CRTA
  2dd0: 70 01 4c 43 44 41 70 00 54 56 41 41 70 01 44 56  p.LCDAp.TVAAp.DV
  2de0: 49 41 86 56 47 41 5f 0a 80 08 44 50 46 4c 00 08  IA.VGA_...DPFL..
  2df0: 44 4c 49 53 11 0f 0a 0c 00 01 00 00 10 01 00 00  DLIS............
  2e00: 21 01 00 00 08 44 4c 43 44 00 08 44 43 52 54 00  !....DLCD..DCRT.
  2e10: 08 44 48 44 4d 00 08 44 53 53 30 00 08 44 43 53  .DHDM..DSS0..DCS
  2e20: 30 00 08 44 47 53 30 00 08 54 49 44 58 00 08 41  0..DGS0..TIDX..A
  2e30: 44 49 53 00 08 53 45 51 30 11 09 0a 06 01 02 04  DIS..SEQ0.......
  2e40: 05 03 01 08 53 45 51 31 11 09 0a 06 01 02 03 01  ....SEQ1........
  2e50: 01 01 08 53 45 51 32 11 09 0a 06 01 04 00 00 05  ...SEQ2.........
  2e60: 01 08 44 44 44 53 11 03 0a 14 8a 44 44 44 53 00  ..DDDS.....DDDS.
  2e70: 44 30 53 54 8a 44 44 44 53 0a 04 44 31 53 54 8a  D0ST.DDDS..D1ST.
  2e80: 44 44 44 53 0a 08 44 32 53 54 8a 44 44 44 53 0a  DDDS..D2ST.DDDS.
  2e90: 0c 44 33 53 54 8a 44 44 44 53 0a 10 44 34 53 54  .D3ST.DDDS..D4ST
  2ea0: 8b 44 44 44 53 00 44 30 49 44 8d 44 44 44 53 0a  .DDDS.D0ID.DDDS.
  2eb0: 12 44 30 45 4e 8d 44 44 44 53 0a 14 44 30 43 4e  .D0EN.DDDS..D0CN
  2ec0: 8b 44 44 44 53 0a 04 44 31 49 44 8d 44 44 44 53  .DDDS..D1ID.DDDS
  2ed0: 0a 32 44 31 45 4e 8d 44 44 44 53 0a 34 44 31 43  .2D1EN.DDDS.4D1C
  2ee0: 4e 8b 44 44 44 53 0a 08 44 32 49 44 8d 44 44 44  N.DDDS..D2ID.DDD
  2ef0: 53 0a 52 44 32 45 4e 8d 44 44 44 53 0a 54 44 32  S.RD2EN.DDDS.TD2
  2f00: 43 4e 8b 44 44 44 53 0a 0c 44 33 49 44 8d 44 44  CN.DDDS..D3ID.DD
  2f10: 44 53 0a 72 44 33 45 4e 8d 44 44 44 53 0a 74 44  DS.rD3EN.DDDS.tD
  2f20: 33 43 4e 8b 44 44 44 53 0a 10 44 34 49 44 8d 44  3CN.DDDS..D4ID.D
  2f30: 44 44 53 0a 92 44 34 45 4e 8d 44 44 44 53 0a 94  DDS..D4EN.DDDS..
  2f40: 44 34 43 4e 14 4a 05 44 44 45 56 01 7b 68 0b ff  D4CN.J.DDEV.{h..
  2f50: ff 60 a0 0c 93 60 44 30 49 44 a4 44 30 45 4e a1  .`...`D0ID.D0EN.
  2f60: 3f a0 0c 93 60 44 31 49 44 a4 44 31 45 4e a1 30  ?...`D1ID.D1EN.0
  2f70: a0 0c 93 60 44 32 49 44 a4 44 32 45 4e a1 21 a0  ...`D2ID.D2EN.!.
  2f80: 0c 93 60 44 33 49 44 a4 44 33 45 4e a1 12 a0 0c  ..`D3ID.D3EN....
  2f90: 93 60 44 34 49 44 a4 44 34 45 4e a1 03 a4 00 14  .`D4ID.D4EN.....
  2fa0: 4a 05 44 44 43 4e 01 7b 68 0b ff ff 60 a0 0c 93  J.DDCN.{h...`...
  2fb0: 60 44 30 49 44 a4 44 30 43 4e a1 3f a0 0c 93 60  `D0ID.D0CN.?...`
  2fc0: 44 31 49 44 a4 44 31 43 4e a1 30 a0 0c 93 60 44  D1ID.D1CN.0...`D
  2fd0: 32 49 44 a4 44 32 43 4e a1 21 a0 0c 93 60 44 33  2ID.D2CN.!...`D3
  2fe0: 49 44 a4 44 33 43 4e a1 12 a0 0c 93 60 44 34 49  ID.D3CN.....`D4I
  2ff0: 44 a4 44 34 43 4e a1 03 a4 00 14 3c 47 4e 41 44  D.D4CN.....<GNAD
  3000: 01 a0 07 93 68 01 a4 0a 02 a0 08 93 68 0a 02 a4  ....h.......h...
  3010: 0a 08 a0 08 93 68 0a 08 a4 0a 03 a0 08 93 68 0a  .....h........h.
  3020: 03 a4 0a 09 a0 08 93 68 0a 09 a4 0a 0a a0 07 93  .......h........
  3030: 68 0a 0a a4 01 a4 01 14 44 0e 44 47 53 4d 00 70  h.......D.DGSM.p
  3040: 00 60 a0 0c 44 44 43 4e 0b 10 01 7d 60 01 60 a0  .`..DDCN...}`.`.
  3050: 0f 44 44 43 4e 0c 00 01 00 80 7d 60 0a 02 60 a0  .DDCN.....}`..`.
  3060: 0f 44 44 43 4e 0c 20 02 00 80 7d 60 0a 04 60 a0  .DDCN. ...}`..`.
  3070: 1a 92 95 4f 53 59 53 0b d6 07 a0 0f 44 44 43 4e  ...OSYS.....DDCN
  3080: 0c 30 73 00 80 7d 60 0a 08 60 a1 16 a0 14 44 44  .0s..}`..`....DD
  3090: 43 4e 0b 11 01 7d 60 0a 08 60 70 0a 02 44 50 46  CN...}`..`p..DPF
  30a0: 4c 70 00 61 a0 0c 44 44 45 56 0b 10 01 7d 61 01  Lp.a..DDEV...}a.
  30b0: 61 a0 0f 44 44 45 56 0c 00 01 00 80 7d 61 0a 02  a..DDEV.....}a..
  30c0: 61 a0 0f 44 44 45 56 0c 20 02 00 80 7d 61 0a 04  a..DDEV. ...}a..
  30d0: 61 a0 1a 92 95 4f 53 59 53 0b d6 07 a0 0f 44 44  a....OSYS.....DD
  30e0: 45 56 0c 30 73 00 80 7d 61 0a 08 61 a1 0f a0 0d  EV.0s..}a..a....
  30f0: 44 44 45 56 0b 11 01 7d 61 0a 08 61 70 0a 07 63  DDEV...}a..ap..c
  3100: a2 1b 63 70 47 4e 41 44 61 61 7b 60 61 62 a0 0b  ..cpGNADaa{`ab..
  3110: 93 61 62 70 61 53 57 49 54 a5 76 63 08 45 52 52  .abpaSWIT.vc.ERR
  3120: 30 11 07 0a 04 00 00 00 00 08 45 52 52 31 11 07  0.........ERR1..
  3130: 0a 04 01 00 00 80 08 45 52 52 32 11 07 0a 04 02  .......ERR2.....
  3140: 00 00 80 08 56 45 52 31 11 07 0a 04 01 00 00 00  ....VER1........
  3150: 14 40 05 4e 56 49 46 03 70 45 52 52 31 60 a0 0e  .@.NVIF.pERR1`..
  3160: 93 68 01 73 45 52 52 30 56 45 52 31 60 a1 31 a0  .h.sERR0VER1`.1.
  3170: 2f 93 68 0a 0b a0 0a 93 69 00 70 45 52 52 30 60  /.h.....i.pERR0`
  3180: a1 1e a0 1c 93 69 0a 03 70 6a 44 44 44 53 44 47  .....i..pjDDDSDG
  3190: 53 4d 86 56 47 41 5f 0a 80 70 45 52 52 30 60 a4  SM.VGA_..pERR0`.
  31a0: 60 14 09 4d 58 4d 49 01 a4 0a 20 14 0b 4d 58 4d  `..MXMI... ..MXM
  31b0: 53 01 a4 4d 58 4d 32 5b 82 8d 05 01 4f 56 47 41  S..MXM2[....OVGA
  31c0: 08 5f 41 44 52 0c 00 00 02 00 14 10 5f 44 4f 53  ._ADR......._DOS
  31d0: 01 70 7b 68 0a 07 00 44 53 45 4e 14 44 22 5f 44  .p{h...DSEN.D"_D
  31e0: 4f 44 00 70 00 4e 44 49 44 a0 15 92 93 44 49 44  OD.p.NDID....DID
  31f0: 4c 00 70 53 44 44 4c 44 49 44 31 44 49 44 31 a0  L.pSDDLDID1DID1.
  3200: 15 92 93 44 44 4c 32 00 70 53 44 44 4c 44 49 44  ...DDL2.pSDDLDID
  3210: 32 44 49 44 32 a0 15 92 93 44 44 4c 33 00 70 53  2DID2....DDL3.pS
  3220: 44 44 4c 44 49 44 33 44 49 44 33 a0 15 92 93 44  DDLDID3DID3....D
  3230: 44 4c 34 00 70 53 44 44 4c 44 49 44 34 44 49 44  DL4.pSDDLDID4DID
  3240: 34 a0 15 92 93 44 44 4c 35 00 70 53 44 44 4c 44  4....DDL5.pSDDLD
  3250: 49 44 35 44 49 44 35 a0 28 93 4e 44 49 44 01 08  ID5DID5.(.NDID..
  3260: 54 4d 50 31 12 03 01 ff 70 7d 0c 00 00 01 00 44  TMP1....p}.....D
  3270: 49 44 31 00 88 54 4d 50 31 00 00 a4 54 4d 50 31  ID1..TMP1...TMP1
  3280: a0 3d 93 4e 44 49 44 0a 02 08 54 4d 50 32 12 04  .=.NDID...TMP2..
  3290: 02 ff ff 70 7d 0c 00 00 01 00 44 49 44 31 00 88  ...p}.....DID1..
  32a0: 54 4d 50 32 00 00 70 7d 0c 00 00 01 00 44 49 44  TMP2..p}.....DID
  32b0: 32 00 88 54 4d 50 32 01 00 a4 54 4d 50 32 a0 43  2..TMP2...TMP2.C
  32c0: 05 93 4e 44 49 44 0a 03 08 54 4d 50 33 12 05 03  ..NDID...TMP3...
  32d0: ff ff ff 70 7d 0c 00 00 01 00 44 49 44 31 00 88  ...p}.....DID1..
  32e0: 54 4d 50 33 00 00 70 7d 0c 00 00 01 00 44 49 44  TMP3..p}.....DID
  32f0: 32 00 88 54 4d 50 33 01 00 70 7d 0c 00 00 01 00  2..TMP3..p}.....
  3300: 44 49 44 33 00 88 54 4d 50 33 0a 02 00 a4 54 4d  DID3..TMP3....TM
  3310: 50 33 a0 48 06 93 4e 44 49 44 0a 04 08 54 4d 50  P3.H..NDID...TMP
  3320: 34 12 06 04 ff ff ff ff 70 7d 0c 00 00 01 00 44  4.......p}.....D
  3330: 49 44 31 00 88 54 4d 50 34 00 00 70 7d 0c 00 00  ID1..TMP4..p}...
  3340: 01 00 44 49 44 32 00 88 54 4d 50 34 01 00 70 7d  ..DID2..TMP4..p}
  3350: 0c 00 00 01 00 44 49 44 33 00 88 54 4d 50 34 0a  .....DID3..TMP4.
  3360: 02 00 70 7d 0c 00 00 01 00 44 49 44 34 00 88 54  ..p}.....DID4..T
  3370: 4d 50 34 0a 03 00 a4 54 4d 50 34 a0 4d 07 94 4e  MP4....TMP4.M..N
  3380: 44 49 44 0a 04 08 54 4d 50 35 12 07 05 ff ff ff  DID...TMP5......
  3390: ff ff 70 7d 0c 00 00 01 00 44 49 44 31 00 88 54  ..p}.....DID1..T
  33a0: 4d 50 35 00 00 70 7d 0c 00 00 01 00 44 49 44 32  MP5..p}.....DID2
  33b0: 00 88 54 4d 50 35 01 00 70 7d 0c 00 00 01 00 44  ..TMP5..p}.....D
  33c0: 49 44 33 00 88 54 4d 50 35 0a 02 00 70 7d 0c 00  ID3..TMP5...p}..
  33d0: 00 01 00 44 49 44 34 00 88 54 4d 50 35 0a 03 00  ...DID4..TMP5...
  33e0: 70 7d 0c 00 00 01 00 44 49 44 35 00 88 54 4d 50  p}.....DID5..TMP
  33f0: 35 0a 04 00 a4 54 4d 50 35 a4 12 05 01 0b 00 04  5....TMP5.......
  3400: 5b 82 43 06 44 44 30 31 14 1c 5f 41 44 52 08 a0  [.C.DD01.._ADR..
  3410: 09 93 44 49 44 31 00 a4 01 a1 0b a4 7b 0b ff ff  ..DID1......{...
  3420: 44 49 44 31 00 14 0f 5f 44 43 53 00 a4 43 44 44  DID1..._DCS..CDD
  3430: 53 44 49 44 31 14 0f 5f 44 47 53 00 a4 4e 44 44  SDID1.._DGS..NDD
  3440: 53 44 49 44 31 14 1f 5f 44 53 53 01 a0 18 93 7b  SDID1.._DSS....{
  3450: 68 0c 00 00 00 c0 00 0c 00 00 00 c0 70 4e 53 54  h...........pNST
  3460: 45 43 53 54 45 5b 82 44 06 44 44 30 32 14 1d 5f  ECSTE[.D.DD02.._
  3470: 41 44 52 08 a0 0a 93 44 49 44 32 00 a4 0a 02 a1  ADR....DID2.....
  3480: 0b a4 7b 0b ff ff 44 49 44 32 00 14 0f 5f 44 43  ..{...DID2..._DC
  3490: 53 00 a4 43 44 44 53 44 49 44 32 14 0f 5f 44 47  S..CDDSDID2.._DG
  34a0: 53 00 a4 4e 44 44 53 44 49 44 32 14 1f 5f 44 53  S..NDDSDID2.._DS
  34b0: 53 01 a0 18 93 7b 68 0c 00 00 00 c0 00 0c 00 00  S....{h.........
  34c0: 00 c0 70 4e 53 54 45 43 53 54 45 5b 82 45 0e 44  ..pNSTECSTE[.E.D
  34d0: 44 30 33 14 1d 5f 41 44 52 08 a0 0a 93 44 49 44  D03.._ADR....DID
  34e0: 33 00 a4 0a 03 a1 0b a4 7b 0b ff ff 44 49 44 33  3.......{...DID3
  34f0: 00 14 1c 5f 44 43 53 00 a0 0a 93 44 49 44 33 00  ..._DCS....DID3.
  3500: a4 0a 0b a1 0a a4 43 44 44 53 44 49 44 33 14 0f  ......CDDSDID3..
  3510: 5f 44 47 53 00 a4 4e 44 44 53 44 49 44 33 14 1f  _DGS..NDDSDID3..
  3520: 5f 44 53 53 01 a0 18 93 7b 68 0c 00 00 00 c0 00  _DSS....{h......
  3530: 0c 00 00 00 c0 70 4e 53 54 45 43 53 54 45 14 22  .....pNSTECSTE."
  3540: 5f 42 43 4c 00 a4 12 1a 0c 0a 46 0a 28 0a 0a 0a  _BCL......F.(...
  3550: 14 0a 1e 0a 28 0a 32 0a 3c 0a 46 0a 50 0a 5a 0a  ....(.2.<.F.P.Z.
  3560: 64 14 21 5f 42 43 4d 01 78 68 0a 0a 60 61 76 61  d.!_BCM.xh..`ava
  3570: 70 61 5e 5e 5e 2f 03 4c 50 43 5f 45 43 30 5f 42  pa^^^/.LPC_EC0_B
  3580: 52 54 53 14 2e 5f 42 51 43 00 70 5e 5e 5e 2f 03  RTS.._BQC.p^^^/.
  3590: 4c 50 43 5f 45 43 30 5f 42 52 54 53 60 72 60 01  LPC_EC0_BRTS`r`.
  35a0: 60 77 60 0a 0a 60 70 60 50 38 30 48 5b 22 0a 64  `w`..`p`P80H[".d
  35b0: a4 60 5b 82 41 07 44 44 30 34 14 1d 5f 41 44 52  .`[.A.DD04.._ADR
  35c0: 08 a0 0a 93 44 49 44 34 00 a4 0a 04 a1 0b a4 7b  ....DID4.......{
  35d0: 0b ff ff 44 49 44 34 00 14 1c 5f 44 43 53 00 a0  ...DID4..._DCS..
  35e0: 0a 93 44 49 44 34 00 a4 0a 0b a1 0a a4 43 44 44  ..DID4.......CDD
  35f0: 53 44 49 44 34 14 0f 5f 44 47 53 00 a4 4e 44 44  SDID4.._DGS..NDD
  3600: 53 44 49 44 34 14 1f 5f 44 53 53 01 a0 18 93 7b  SDID4.._DSS....{
  3610: 68 0c 00 00 00 c0 00 0c 00 00 00 c0 70 4e 53 54  h...........pNST
  3620: 45 43 53 54 45 5b 82 41 07 44 44 30 35 14 1d 5f  ECSTE[.A.DD05.._
  3630: 41 44 52 08 a0 0a 93 44 49 44 35 00 a4 0a 05 a1  ADR....DID5.....
  3640: 0b a4 7b 0b ff ff 44 49 44 35 00 14 1c 5f 44 43  ..{...DID5..._DC
  3650: 53 00 a0 0a 93 44 49 44 35 00 a4 0a 0b a1 0a a4  S....DID5.......
  3660: 43 44 44 53 44 49 44 35 14 0f 5f 44 47 53 00 a4  CDDSDID5.._DGS..
  3670: 4e 44 44 53 44 49 44 35 14 1f 5f 44 53 53 01 a0  NDDSDID5.._DSS..
  3680: 18 93 7b 68 0c 00 00 00 c0 00 0c 00 00 00 c0 70  ..{h...........p
  3690: 4e 53 54 45 43 53 54 45 14 4e 06 53 44 44 4c 01  NSTECSTE.N.SDDL.
  36a0: 75 4e 44 49 44 70 7b 68 0b 0f 0f 00 60 7d 0c 00  uNDIDp{h....`}..
  36b0: 00 00 80 60 61 a0 09 93 44 49 44 4c 60 a4 61 a0  ...`a...DIDL`.a.
  36c0: 09 93 44 44 4c 32 60 a4 61 a0 09 93 44 44 4c 33  ..DDL2`.a...DDL3
  36d0: 60 a4 61 a0 09 93 44 44 4c 34 60 a4 61 a0 09 93  `.a...DDL4`.a...
  36e0: 44 44 4c 35 60 a4 61 a0 09 93 44 44 4c 36 60 a4  DDL5`.a...DDL6`.
  36f0: 61 a0 09 93 44 44 4c 37 60 a4 61 a0 09 93 44 44  a...DDL7`.a...DD
  3700: 4c 38 60 a4 61 a4 00 14 4a 08 43 44 44 53 01 a0  L8`.a...J.CDDS..
  3710: 0f 93 43 41 44 4c 7b 68 0b 0f 0f 00 a4 0a 1f a0  ..CADL{h........
  3720: 0f 93 43 41 4c 32 7b 68 0b 0f 0f 00 a4 0a 1f a0  ..CAL2{h........
  3730: 0f 93 43 41 4c 33 7b 68 0b 0f 0f 00 a4 0a 1f a0  ..CAL3{h........
  3740: 0f 93 43 41 4c 34 7b 68 0b 0f 0f 00 a4 0a 1f a0  ..CAL4{h........
  3750: 0f 93 43 41 4c 35 7b 68 0b 0f 0f 00 a4 0a 1f a0  ..CAL5{h........
  3760: 0f 93 43 41 4c 36 7b 68 0b 0f 0f 00 a4 0a 1f a0  ..CAL6{h........
  3770: 0f 93 43 41 4c 37 7b 68 0b 0f 0f 00 a4 0a 1f a0  ..CAL7{h........
  3780: 0f 93 43 41 4c 38 7b 68 0b 0f 0f 00 a4 0a 1f a4  ..CAL8{h........
  3790: 0a 1d 14 41 08 4e 44 44 53 01 a0 0e 93 4e 41 44  ...A.NDDS....NAD
  37a0: 4c 7b 68 0b 0f 0f 00 a4 01 a0 0e 93 4e 44 4c 32  L{h.........NDL2
  37b0: 7b 68 0b 0f 0f 00 a4 01 a0 0e 93 4e 44 4c 33 7b  {h.........NDL3{
  37c0: 68 0b 0f 0f 00 a4 01 a0 0e 93 4e 44 4c 34 7b 68  h.........NDL4{h
  37d0: 0b 0f 0f 00 a4 01 a0 0e 93 4e 44 4c 35 7b 68 0b  .........NDL5{h.
  37e0: 0f 0f 00 a4 01 a0 0e 93 4e 44 4c 36 7b 68 0b 0f  ........NDL6{h..
  37f0: 0f 00 a4 01 a0 0e 93 4e 44 4c 37 7b 68 0b 0f 0f  .......NDL7{h...
  3800: 00 a4 01 a0 0e 93 4e 44 4c 38 7b 68 0b 0f 0f 00  ......NDL8{h....
  3810: a4 01 a4 00 14 2c 43 50 44 53 01 7b 68 0b 0f ff  .....,CPDS.{h...
  3820: 60 a0 09 93 43 50 44 4c 60 a4 01 a0 09 93 43 50  `...CPDL`.....CP
  3830: 4c 32 60 a4 01 a0 09 93 43 50 4c 33 60 a4 01 a4  L2`.....CPL3`...
  3840: 00 10 24 5e 5e 50 43 49 30 5b 80 4d 43 48 50 02  ..$^^PCI0[.MCHP.
  3850: 0a 40 0a c0 5b 81 10 4d 43 48 50 00 00 40 30 54  .@..[..MCHP..@0T
  3860: 41 53 4d 0a 00 06 5b 80 49 47 44 50 02 0a 40 0a  ASM...[.IGDP..@.
  3870: c0 5b 81 45 05 49 47 44 50 00 00 40 09 00 01 47  .[.E.IGDP..@...G
  3880: 49 56 44 01 00 02 47 55 4d 41 03 00 09 00 04 47  IVD...GUMA.....G
  3890: 4d 46 4e 01 00 1b 00 40 46 41 53 4c 45 08 00 18  MFN....@FASLE...
  38a0: 47 53 53 45 01 47 53 53 42 0e 47 53 45 53 01 00  GSSE.GSSB.GSES..
  38b0: 30 00 0c 43 44 56 4c 01 00 03 00 18 4c 42 50 43  0..CDVL.....LBPC
  38c0: 08 00 30 41 53 4c 53 20 5b 80 49 47 44 4d 00 41  ..0ASLS [.IGDM.A
  38d0: 53 4c 42 0b 00 20 5b 81 48 19 49 47 44 4d 00 53  SLB.. [.H.IGDM.S
  38e0: 49 47 4e 40 08 53 49 5a 45 20 4f 56 45 52 20 53  IGN@.SIZE OVER S
  38f0: 56 45 52 40 10 56 56 45 52 40 08 47 56 45 52 40  VER@.VVER@.GVER@
  3900: 08 4d 42 4f 58 20 44 4d 4f 44 20 00 40 50 44 52  .MBOX DMOD .@PDR
  3910: 44 59 20 43 53 54 53 20 43 45 56 54 20 00 40 0a  DY CSTS CEVT .@.
  3920: 44 49 44 4c 20 44 44 4c 32 20 44 44 4c 33 20 44  DIDL DDL2 DDL3 D
  3930: 44 4c 34 20 44 44 4c 35 20 44 44 4c 36 20 44 44  DL4 DDL5 DDL6 DD
  3940: 4c 37 20 44 44 4c 38 20 43 50 44 4c 20 43 50 4c  L7 DDL8 CPDL CPL
  3950: 32 20 43 50 4c 33 20 43 50 4c 34 20 43 50 4c 35  2 CPL3 CPL4 CPL5
  3960: 20 43 50 4c 36 20 43 50 4c 37 20 43 50 4c 38 20   CPL6 CPL7 CPL8 
  3970: 43 41 44 4c 20 43 41 4c 32 20 43 41 4c 33 20 43  CADL CAL2 CAL3 C
  3980: 41 4c 34 20 43 41 4c 35 20 43 41 4c 36 20 43 41  AL4 CAL5 CAL6 CA
  3990: 4c 37 20 43 41 4c 38 20 4e 41 44 4c 20 4e 44 4c  L7 CAL8 NADL NDL
  39a0: 32 20 4e 44 4c 33 20 4e 44 4c 34 20 4e 44 4c 35  2 NDL3 NDL4 NDL5
  39b0: 20 4e 44 4c 36 20 4e 44 4c 37 20 4e 44 4c 38 20   NDL6 NDL7 NDL8 
  39c0: 41 53 4c 50 20 54 49 44 58 20 43 48 50 44 20 43  ASLP TIDX CHPD C
  39d0: 4c 49 44 20 43 44 43 4b 20 53 58 53 57 20 45 56  LID CDCK SXSW EV
  39e0: 54 53 20 43 4e 4f 54 20 4e 52 44 59 20 00 40 1e  TS CNOT NRDY .@.
  39f0: 53 43 49 45 01 47 45 46 43 04 47 58 46 43 03 47  SCIE.GEFC.GXFC.G
  3a00: 45 53 46 08 00 10 50 41 52 4d 20 44 53 4c 50 20  ESF...PARM DSLP 
  3a10: 00 40 7a 41 52 44 59 20 41 53 4c 43 20 54 43 48  .@zARDY ASLC TCH
  3a20: 45 20 41 4c 53 49 20 42 43 4c 50 20 50 46 49 54  E ALSI BCLP PFIT
  3a30: 20 43 42 4c 56 20 42 43 4c 4d 40 14 43 50 46 4d   CBLV BCLM@.CPFM
  3a40: 20 45 50 46 4d 20 50 4c 55 54 40 25 50 46 4d 42   EPFM PLUT@%PFMB
  3a50: 20 43 43 44 56 20 50 43 46 54 20 00 40 2f 47 56   CCDV PCFT .@/GV
  3a60: 44 31 80 00 0c 50 48 45 44 20 42 44 44 43 40 80  D1...PHED BDDC@.
  3a70: 08 44 42 54 42 12 32 15 00 0a 07 0a 38 0b c0 01  .DBTB.2.....8...
  3a80: 0b 00 0e 0a 3f 0b c7 01 0b 07 0e 0b f8 01 0b 38  ....?..........8
  3a90: 0e 0b c0 0f 00 00 00 00 00 0b 00 70 0b 07 70 0b  ...........p..p.
  3aa0: 38 70 0b c0 71 0b 00 7e 08 43 44 43 54 12 27 05  8p..q..~.CDCT.'.
  3ab0: 12 07 02 0a e4 0b 40 01 12 07 02 0a de 0b 4d 01  ......@.......M.
  3ac0: 12 07 02 0a de 0b 4d 01 12 04 02 00 00 12 07 02  ......M.........
  3ad0: 0a de 0b 4d 01 08 53 55 43 43 01 08 4e 56 4c 44  ...M..SUCC..NVLD
  3ae0: 0a 02 08 43 52 49 54 0a 04 08 4e 43 52 54 0a 06  ...CRIT...NCRT..
  3af0: 14 4a 4f 47 53 43 49 08 14 48 1e 47 42 44 41 08  .JOGSCI..H.GBDA.
  3b00: a0 1a 93 47 45 53 46 00 70 0b 79 06 50 41 52 4d  ...GESF.p.y.PARM
  3b10: 70 00 47 45 53 46 a4 53 55 43 43 a0 1a 93 47 45  p.GESF.SUCC...GE
  3b20: 53 46 01 70 0b 40 02 50 41 52 4d 70 00 47 45 53  SF.p.@.PARMp.GES
  3b30: 46 a4 53 55 43 43 a0 47 04 93 47 45 53 46 0a 04  F.SUCC.G..GESF..
  3b40: 7b 50 41 52 4d 0c 00 00 ff ef 50 41 52 4d 7b 50  {PARM.....PARM{P
  3b50: 41 52 4d 79 83 88 44 42 54 42 49 42 54 54 00 0a  ARMy..DBTBIBTT..
  3b60: 10 00 50 41 52 4d 7d 49 42 54 54 50 41 52 4d 50  ..PARM}IBTTPARMP
  3b70: 41 52 4d 70 00 47 45 53 46 a4 53 55 43 43 a0 4a  ARMp.GESF.SUCC.J
  3b80: 06 93 47 45 53 46 0a 05 70 49 50 53 43 50 41 52  ..GESF..pIPSCPAR
  3b90: 4d 7d 50 41 52 4d 79 49 50 41 54 0a 08 00 50 41  M}PARMyIPAT...PA
  3ba0: 52 4d 72 50 41 52 4d 0b 00 01 50 41 52 4d 7d 50  RMrPARM...PARM}P
  3bb0: 41 52 4d 79 4c 49 44 53 0a 10 00 50 41 52 4d 72  ARMyLIDS...PARMr
  3bc0: 50 41 52 4d 0c 00 00 01 00 50 41 52 4d 7d 50 41  PARM.....PARM}PA
  3bd0: 52 4d 79 49 42 49 41 0a 14 00 50 41 52 4d 70 00  RMyIBIA...PARMp.
  3be0: 47 45 53 46 a4 53 55 43 43 a0 2d 93 47 45 53 46  GESF.SUCC.-.GESF
  3bf0: 0a 06 70 49 54 56 46 50 41 52 4d 7d 50 41 52 4d  ..pITVFPARM}PARM
  3c00: 79 49 54 56 4d 0a 04 00 50 41 52 4d 70 00 47 45  yITVM...PARMp.GE
  3c10: 53 46 a4 53 55 43 43 a0 43 07 93 47 45 53 46 0a  SF.SUCC.C..GESF.
  3c20: 07 70 47 49 56 44 50 41 52 4d 7f 50 41 52 4d 01  .pGIVDPARM.PARM.
  3c30: 50 41 52 4d 7d 50 41 52 4d 79 47 4d 46 4e 01 00  PARM}PARMyGMFN..
  3c40: 50 41 52 4d 7d 50 41 52 4d 0b 00 18 50 41 52 4d  PARM}PARM...PARM
  3c50: 7d 50 41 52 4d 79 49 44 4d 53 0a 11 00 50 41 52  }PARMyIDMS...PAR
  3c60: 4d 7d 79 83 88 83 88 43 44 43 54 48 56 43 4f 00  M}y....CDCTHVCO.
  3c70: 43 44 56 4c 00 0a 15 00 50 41 52 4d 50 41 52 4d  CDVL....PARMPARM
  3c80: 70 01 47 45 53 46 a4 53 55 43 43 a0 2a 93 47 45  p.GESF.SUCC.*.GE
  3c90: 53 46 0a 0a 70 00 50 41 52 4d a0 10 49 53 53 43  SF..p.PARM..ISSC
  3ca0: 7d 50 41 52 4d 0a 03 50 41 52 4d 70 00 47 45 53  }PARM..PARMp.GES
  3cb0: 46 a4 53 55 43 43 a0 1f 93 47 45 53 46 0a 0b 70  F.SUCC...GESF..p
  3cc0: 4b 53 56 30 50 41 52 4d 70 4b 53 56 31 47 45 53  KSV0PARMpKSV1GES
  3cd0: 46 a4 53 55 43 43 70 00 47 45 53 46 a4 43 52 49  F.SUCCp.GESF.CRI
  3ce0: 54 14 4b 2c 53 42 43 42 08 a0 18 93 47 45 53 46  T.K,SBCB....GESF
  3cf0: 00 70 00 50 41 52 4d 70 00 47 45 53 46 a4 53 55  .p.PARMp.GESF.SU
  3d00: 43 43 a0 18 93 47 45 53 46 01 70 00 47 45 53 46  CC...GESF.p.GESF
  3d10: 70 00 50 41 52 4d a4 53 55 43 43 a0 19 93 47 45  p.PARM.SUCC...GE
  3d20: 53 46 0a 03 70 00 47 45 53 46 70 00 50 41 52 4d  SF..p.GESFp.PARM
  3d30: a4 53 55 43 43 a0 19 93 47 45 53 46 0a 04 70 00  .SUCC...GESF..p.
  3d40: 47 45 53 46 70 00 50 41 52 4d a4 53 55 43 43 a0  GESFp.PARM.SUCC.
  3d50: 19 93 47 45 53 46 0a 05 70 00 47 45 53 46 70 00  ..GESF..p.GESFp.
  3d60: 50 41 52 4d a4 53 55 43 43 a0 37 93 47 45 53 46  PARM.SUCC.7.GESF
  3d70: 0a 06 70 7b 50 41 52 4d 0a 0f 00 49 54 56 46 70  ..p{PARM...ITVFp
  3d80: 7a 7b 50 41 52 4d 0a f0 00 0a 04 00 49 54 56 4d  z{PARM......ITVM
  3d90: 70 00 47 45 53 46 70 00 50 41 52 4d a4 53 55 43  p.GESFp.PARM.SUC
  3da0: 43 a0 45 04 93 47 45 53 46 0a 07 a0 2a 93 50 41  C.E..GESF...*.PA
  3db0: 52 4d 00 70 43 4c 49 44 60 a0 1c 7b 0c 00 00 00  RM.pCLID`..{....
  3dc0: 80 60 00 7b 43 4c 49 44 0a 0f 43 4c 49 44 47 4c  .`.{CLID..CLIDGL
  3dd0: 49 44 43 4c 49 44 70 00 47 45 53 46 70 00 50 41  IDCLIDp.GESFp.PA
  3de0: 52 4d a4 53 55 43 43 a0 19 93 47 45 53 46 0a 08  RM.SUCC...GESF..
  3df0: 70 00 47 45 53 46 70 00 50 41 52 4d a4 53 55 43  p.GESFp.PARM.SUC
  3e00: 43 a0 24 93 47 45 53 46 0a 09 7b 50 41 52 4d 0a  C.$.GESF..{PARM.
  3e10: ff 49 42 54 54 70 00 47 45 53 46 70 00 50 41 52  .IBTTp.GESFp.PAR
  3e20: 4d a4 53 55 43 43 a0 46 05 93 47 45 53 46 0a 0a  M.SUCC.F..GESF..
  3e30: 7b 50 41 52 4d 0a ff 49 50 53 43 a0 21 7b 7a 50  {PARM..IPSC.!{zP
  3e40: 41 52 4d 0a 08 00 0a ff 00 7b 7a 50 41 52 4d 0a  ARM......{zPARM.
  3e50: 08 00 0a ff 49 50 41 54 76 49 50 41 54 7b 7a 50  ....IPATvIPAT{zP
  3e60: 41 52 4d 0a 14 00 0a 07 49 42 49 41 70 00 47 45  ARM.....IBIAp.GE
  3e70: 53 46 70 00 50 41 52 4d a4 53 55 43 43 a0 44 05  SFp.PARM.SUCC.D.
  3e80: 93 47 45 53 46 0a 0b 7b 7a 50 41 52 4d 01 00 01  .GESF..{zPARM...
  3e90: 49 46 31 45 a0 1b 7b 50 41 52 4d 0c 00 e0 01 00  IF1E..{PARM.....
  3ea0: 00 7b 7a 50 41 52 4d 0a 0d 00 0a 0f 49 44 4d 53  .{zPARM.....IDMS
  3eb0: a1 10 7b 7a 50 41 52 4d 0a 11 00 0a 0f 49 44 4d  ..{zPARM.....IDM
  3ec0: 53 70 00 47 45 53 46 70 00 50 41 52 4d a4 53 55  Sp.GESFp.PARM.SU
  3ed0: 43 43 a0 19 93 47 45 53 46 0a 10 70 00 47 45 53  CC...GESF..p.GES
  3ee0: 46 70 00 50 41 52 4d a4 53 55 43 43 a0 2c 93 47  Fp.PARM.SUCC.,.G
  3ef0: 45 53 46 0a 11 70 79 4c 49 44 53 0a 08 00 50 41  ESF..pyLIDS...PA
  3f00: 52 4d 72 50 41 52 4d 0b 00 01 50 41 52 4d 70 00  RMrPARM...PARMp.
  3f10: 47 45 53 46 a4 53 55 43 43 a0 49 04 93 47 45 53  GESF.SUCC.I..GES
  3f20: 46 0a 12 a0 26 7b 50 41 52 4d 01 00 a0 10 93 7a  F...&{PARM.....z
  3f30: 50 41 52 4d 01 00 01 70 01 49 53 53 43 a1 0c 70  PARM...p.ISSC..p
  3f40: 00 47 45 53 46 a4 43 52 49 54 a1 07 70 00 49 53  .GESF.CRIT..p.IS
  3f50: 53 43 70 00 47 45 53 46 70 00 50 41 52 4d a4 53  SCp.GESFp.PARM.S
  3f60: 55 43 43 a0 19 93 47 45 53 46 0a 13 70 00 47 45  UCC...GESF..p.GE
  3f70: 53 46 70 00 50 41 52 4d a4 53 55 43 43 a0 24 93  SFp.PARM.SUCC.$.
  3f80: 47 45 53 46 0a 14 7b 50 41 52 4d 0a 0f 50 41 56  GESF..{PARM..PAV
  3f90: 50 70 00 47 45 53 46 70 00 50 41 52 4d a4 53 55  Pp.GESFp.PARM.SU
  3fa0: 43 43 70 00 47 45 53 46 a4 53 55 43 43 a0 11 93  CCp.GESF.SUCC...
  3fb0: 47 45 46 43 0a 04 70 47 42 44 41 47 58 46 43 a0  GEFC..pGBDAGXFC.
  3fc0: 11 93 47 45 46 43 0a 06 70 53 42 43 42 47 58 46  ..GEFC..pSBCBGXF
  3fd0: 43 70 00 47 45 46 43 70 01 53 43 49 53 70 00 47  Cp.GEFCp.SCISp.G
  3fe0: 53 53 45 70 00 53 43 49 45 a4 00 14 19 50 44 52  SSEp.SCIE....PDR
  3ff0: 44 00 a0 0c 92 44 52 44 59 5b 22 41 53 4c 50 a4  D....DRDY["ASLP.
  4000: 92 44 52 44 59 14 1d 50 53 54 53 00 a0 0e 94 43  .DRDY..PSTS....C
  4010: 53 54 53 0a 02 5b 22 41 53 4c 50 a4 93 43 53 54  STS..["ASLP..CST
  4020: 53 0a 03 14 43 05 47 4e 4f 54 02 a0 07 50 44 52  S...C.GNOT...PDR
  4030: 44 a4 01 70 68 43 45 56 54 70 0a 03 43 53 54 53  D..phCEVTp..CSTS
  4040: a0 2d 90 93 43 48 50 44 00 93 69 00 a0 19 91 94  .-..CHPD..i.....
  4050: 4f 53 59 53 0b d0 07 92 94 4f 53 59 53 0b d6 07  OSYS.....OSYS...
  4060: 86 50 43 49 30 69 a1 07 86 4f 56 47 41 69 86 4f  .PCI0i...OVGAi.O
  4070: 56 47 41 0a 80 a4 00 14 13 47 48 44 53 01 70 68  VGA......GHDS.ph
  4080: 54 49 44 58 a4 47 4e 4f 54 01 00 14 14 47 4c 49  TIDX.GNOT....GLI
  4090: 44 01 70 68 43 4c 49 44 a4 47 4e 4f 54 0a 02 00  D.phCLID.GNOT...
  40a0: 14 14 47 44 43 4b 01 70 68 43 44 43 4b a4 47 4e  ..GDCK.phCDCK.GN
  40b0: 4f 54 0a 04 00 14 19 50 41 52 44 00 a0 0c 92 41  OT.....PARD....A
  40c0: 52 44 59 5b 22 41 53 4c 50 a4 92 41 52 44 59 14  RDY["ASLP..ARDY.
  40d0: 4e 12 41 49 4e 54 02 a0 0e 92 7b 54 43 48 45 79  N.AINT....{TCHEy
  40e0: 01 68 00 00 a4 01 a0 07 50 41 52 44 a4 01 a0 40  .h......PARD...@
  40f0: 0c 93 68 0a 02 a0 47 09 43 50 46 4d 7b 43 50 46  ..h...G.CPFM{CPF
  4100: 4d 0a 0f 60 7b 45 50 46 4d 0a 0f 61 a0 2a 93 60  M..`{EPFM..a.*.`
  4110: 01 a0 0d 7b 61 0a 06 00 70 0a 06 50 46 49 54 a1  ...{a...p..PFIT.
  4120: 17 a0 0d 7b 61 0a 08 00 70 0a 08 50 46 49 54 a1  ...{a...p..PFIT.
  4130: 07 70 01 50 46 49 54 a0 2a 93 60 0a 06 a0 0d 7b  .p.PFIT.*.`....{
  4140: 61 0a 08 00 70 0a 08 50 46 49 54 a1 16 a0 0b 7b  a...p..PFIT....{
  4150: 61 01 00 70 01 50 46 49 54 a1 08 70 0a 06 50 46  a..p.PFIT..p..PF
  4160: 49 54 a0 2a 93 60 0a 08 a0 0b 7b 61 01 00 70 01  IT.*.`....{a..p.
  4170: 50 46 49 54 a1 18 a0 0d 7b 61 0a 06 00 70 0a 06  PFIT....{a...p..
  4180: 50 46 49 54 a1 08 70 0a 08 50 46 49 54 a1 0c 7f  PFIT..p..PFIT...
  4190: 50 46 49 54 0a 07 50 46 49 54 7d 50 46 49 54 0c  PFIT..PFIT}PFIT.
  41a0: 00 00 00 80 50 46 49 54 70 0a 04 41 53 4c 43 a1  ....PFITp..ASLC.
  41b0: 46 04 a0 2c 93 68 01 72 69 01 69 70 78 77 69 0a  F..,.h.ri.ipxwi.
  41c0: ff 00 0a 0a 00 00 42 43 4c 50 7d 42 43 4c 50 0c  ......BCLP}BCLP.
  41d0: 00 00 00 80 42 43 4c 50 70 0a 02 41 53 4c 43 a1  ....BCLPp..ASLC.
  41e0: 16 a0 10 93 68 00 70 69 41 4c 53 49 70 01 41 53  ....h.piALSIp.AS
  41f0: 4c 43 a1 03 a4 01 70 00 4c 42 50 43 a4 00 14 17  LC....p.LBPC....
  4200: 53 43 49 50 00 a0 0e 92 93 4f 56 45 52 00 a4 92  SCIP.....OVER...
  4210: 47 53 4d 49 a4 00 5b 82 0f 50 33 32 5f 08 5f 41  GSMI..[..P32_._A
  4220: 44 52 0c 00 00 1e 00 5b 82 8c a7 01 4c 50 43 5f  DR.....[....LPC_
  4230: 08 5f 41 44 52 0c 00 00 1f 00 5b 80 4c 50 43 30  ._ADR.....[.LPC0
  4240: 02 0a 40 0a c0 5b 81 4b 06 4c 50 43 30 00 00 40  ..@..[.K.LPC0..@
  4250: 10 50 41 52 43 08 50 42 52 43 08 50 43 52 43 08  .PARC.PBRC.PCRC.
  4260: 50 44 52 43 08 00 20 50 45 52 43 08 50 46 52 43  PDRC.. PERC.PFRC
  4270: 08 50 47 52 43 08 50 48 52 43 08 00 40 0a 49 4f  .PGRC.PHRC..@.IO
  4280: 44 30 08 49 4f 44 31 08 43 4d 41 30 01 43 4d 42  D0.IOD1.CMA0.CMB
  4290: 30 01 4c 50 30 45 01 46 44 44 45 01 00 0c 44 49  0.LP0E.FDDE...DI
  42a0: 4f 31 10 52 49 4f 31 08 00 48 0c 00 07 43 34 4f  O1.RIO1..H...C4O
  42b0: 33 01 5b 82 43 2d 42 41 54 30 08 5f 48 49 44 0c  3.[.C-BAT0._HID.
  42c0: 41 d0 0c 0a 08 5f 55 49 44 01 08 5f 50 43 4c 12  A...._UID.._PCL.
  42d0: 06 01 5f 53 42 5f 08 50 42 49 46 12 3b 0d 01 0b  .._SB_.PBIF.;...
  42e0: a0 0f 0b a0 0f 01 0b d0 39 0b 90 01 0a 78 0b 08  ........9....x..
  42f0: 01 0b c4 0e 0d 4c 69 5f 49 6f 6e 20 34 30 30 30  .....Li_Ion 4000
  4300: 6d 41 20 00 0d 31 32 33 34 00 0d 4c 69 6f 6e 00  mA ..1234..Lion.
  4310: 0d 41 63 65 72 20 00 08 50 42 53 54 12 08 04 01  .Acer ..PBST....
  4320: ff ff 0b d0 39 14 32 5f 53 54 41 00 a0 22 45 43  ....9.2_STA.."EC
  4330: 4f 4e a0 13 5e 5e 2e 45 43 30 5f 42 41 4c 31 5b  ON..^^.EC0_BAL1[
  4340: 22 0a 64 a4 0a 1f a1 08 5b 22 0a 64 a4 0a 0f a1  ".d.....[".d....
  4350: 08 5b 22 0a 64 a4 0a 1f 14 44 16 5f 42 49 46 00  .[".d....D._BIF.
  4360: a0 47 15 45 43 4f 4e 5b 22 0a 64 70 5e 5e 2e 45  .G.ECON[".dp^^.E
  4370: 43 30 5f 42 44 43 30 88 50 42 49 46 01 00 5b 22  C0_BDC0.PBIF..["
  4380: 0a 64 70 5e 5e 2e 45 43 30 5f 42 46 43 30 88 50  .dp^^.EC0_BFC0.P
  4390: 42 49 46 0a 02 00 5b 22 0a 64 70 5e 5e 2e 45 43  BIF...[".dp^^.EC
  43a0: 30 5f 42 44 56 30 88 50 42 49 46 0a 04 00 5b 22  0_BDV0.PBIF...["
  43b0: 0a 64 70 5e 5e 2e 45 43 30 5f 42 44 43 30 62 78  .dp^^.EC0_BDC0bx
  43c0: 62 0a 64 66 62 77 62 0a 05 63 70 63 88 50 42 49  b.dfbwb..cpc.PBI
  43d0: 46 0a 05 00 77 62 0a 03 64 70 64 88 50 42 49 46  F...wb..dpd.PBIF
  43e0: 0a 06 00 5b 22 0a 64 a0 2c 92 95 4f 53 59 53 0b  ...[".d.,..OSYS.
  43f0: d6 07 98 5e 5e 2e 45 43 30 5f 42 53 4e 30 62 9e  ...^^.EC0_BSN0b.
  4400: 62 0a 02 0a 04 63 70 63 88 50 42 49 46 0a 0a 00  b....cpc.PBIF...
  4410: 5b 22 0a 64 70 5e 5e 2e 45 43 30 5f 42 41 54 44  [".dp^^.EC0_BATD
  4420: 88 50 42 49 46 0a 09 00 5b 22 0a 64 70 5e 5e 2e  .PBIF...[".dp^^.
  4430: 45 43 30 5f 42 54 4d 46 61 5b 22 0a 64 a0 15 93  EC0_BTMFa[".d...
  4440: 61 01 70 0d 53 41 4e 59 4f 20 00 88 50 42 49 46  a.p.SANYO ..PBIF
  4450: 0a 0c 00 a1 44 06 a0 15 93 61 0a 02 70 0d 53 4f  ....D....a..p.SO
  4460: 4e 59 20 00 88 50 42 49 46 0a 0c 00 a1 4b 04 a0  NY ..PBIF....K..
  4470: 1a 93 61 0a 04 70 0d 50 41 4e 41 53 4f 4e 49 43  ..a..p.PANASONIC
  4480: 20 00 88 50 42 49 46 0a 0c 00 a1 2d a0 17 93 61   ..PBIF....-...a
  4490: 0a 03 70 0d 53 69 6d 70 6c 6f 20 00 88 50 42 49  ..p.Simplo ..PBI
  44a0: 46 0a 0c 00 a1 13 70 0d 43 4f 4d 50 41 4c 20 00  F.....p.COMPAL .
  44b0: 88 50 42 49 46 0a 0c 00 a4 50 42 49 46 14 49 0c  .PBIF....PBIF.I.
  44c0: 5f 42 53 54 00 a0 4c 0b 45 43 4f 4e 5b 22 0a 64  _BST..L.ECON[".d
  44d0: 70 5e 5e 2e 45 43 30 5f 42 53 54 30 60 7b 60 0a  p^^.EC0_BST0`{`.
  44e0: 07 60 70 60 88 50 42 53 54 00 00 5b 22 0a 64 70  .`p`.PBST..[".dp
  44f0: 5e 5e 2e 45 43 30 5f 47 41 55 30 62 5b 22 0a 64  ^^.EC0_GAU0b[".d
  4500: 70 5e 5e 2e 45 43 30 5f 42 50 56 30 63 5b 22 0a  p^^.EC0_BPV0c[".
  4510: 64 70 5e 5e 2e 45 43 30 5f 42 46 43 30 61 5b 22  dp^^.EC0_BFC0a["
  4520: 0a 64 a0 11 62 77 62 61 62 78 62 0a 64 66 62 a0  .d..bwbabxb.dfb.
  4530: 04 66 75 62 70 5e 5e 2e 45 43 30 5f 42 41 43 30  .fubp^^.EC0_BAC0
  4540: 61 a0 1a 7b 61 0b 00 80 61 70 5e 5e 2e 45 43 30  a..{a...ap^^.EC0
  4550: 5f 42 41 43 30 61 74 0b ff ff 61 61 a1 04 70 00  _BAC0at...aa..p.
  4560: 61 5b 22 0a 64 70 61 88 50 42 53 54 01 00 70 62  a[".dpa.PBST..pb
  4570: 88 50 42 53 54 0a 02 00 70 63 88 50 42 53 54 0a  .PBST...pc.PBST.
  4580: 03 00 a4 50 42 53 54 5b 82 43 04 41 43 5f 5f 08  ...PBST[.C.AC__.
  4590: 5f 48 49 44 0d 41 43 50 49 30 30 30 33 00 08 5f  _HID.ACPI0003.._
  45a0: 50 43 4c 12 06 01 5f 53 42 5f 14 21 5f 50 53 52  PCL..._SB_.!_PSR
  45b0: 00 a0 15 45 43 4f 4e 70 5e 5e 2e 45 43 30 5f 41  ...ECONp^^.EC0_A
  45c0: 44 50 54 50 57 52 53 a4 50 57 52 53 5b 82 0f 50  DPTPWRS.PWRS[..P
  45d0: 57 52 42 08 5f 48 49 44 0c 41 d0 0c 0c 5b 82 1b  WRB._HID.A...[..
  45e0: 4c 49 44 30 08 5f 48 49 44 0c 41 d0 0c 0d 14 0b  LID0._HID.A.....
  45f0: 5f 4c 49 44 00 a4 4c 50 44 4c 5b 82 0f 53 4c 50  _LID..LPDL[..SLP
  4600: 42 08 5f 48 49 44 0c 41 d0 0c 0e 5b 80 50 52 52  B._HID.A...[.PRR
  4610: 30 02 0a 60 0a 04 5b 81 1a 50 52 52 30 00 50 49  0..`..[..PRR0.PI
  4620: 52 41 08 50 49 52 42 08 50 49 52 43 08 50 49 52  RA.PIRB.PIRC.PIR
  4630: 44 08 5b 80 50 52 52 31 02 0a 68 0a 04 5b 81 1a  D.[.PRR1..h..[..
  4640: 50 52 52 31 00 50 49 52 45 08 50 49 52 46 08 50  PRR1.PIRE.PIRF.P
  4650: 49 52 47 08 50 49 52 48 08 5b 80 50 52 52 32 02  IRG.PIRH.[.PRR2.
  4660: 0a 80 0a 02 5b 81 10 50 52 52 32 00 49 4f 44 4c  ....[..PRR2.IODL
  4670: 08 49 4f 44 48 08 5b 82 47 0c 4c 4e 4b 41 08 5f  .IODH.[.G.LNKA._
  4680: 48 49 44 0c 41 d0 0c 0f 08 5f 55 49 44 01 14 18  HID.A...._UID...
  4690: 5f 53 54 41 00 a0 0c 7b 50 49 52 41 0a 80 00 a4  _STA...{PIRA....
  46a0: 0a 09 a1 04 a4 0a 0b 14 11 5f 44 49 53 00 7d 50  ........._DIS.}P
  46b0: 49 52 41 0a 80 50 49 52 41 14 45 04 5f 43 52 53  IRA..PIRA.E._CRS
  46c0: 00 08 42 55 46 30 11 09 0a 06 23 01 00 18 79 00  ..BUF0....#...y.
  46d0: 8b 42 55 46 30 01 49 52 51 57 a0 0c 7b 50 49 52  .BUF0.IRQW..{PIR
  46e0: 41 0a 80 00 70 00 60 a1 04 70 01 60 79 60 7b 50  A...p.`..p.`y`{P
  46f0: 49 52 41 0a 0f 00 49 52 51 57 a4 42 55 46 30 08  IRA...IRQW.BUF0.
  4700: 5f 50 52 53 11 09 0a 06 23 b8 1e 18 79 00 14 30  _PRS....#...y..0
  4710: 5f 53 52 53 01 8b 68 01 49 52 51 57 82 49 52 51  _SRS..h.IRQW.IRQ
  4720: 57 60 a0 0f 92 93 49 52 51 57 00 7b 60 0a 7f 60  W`....IRQW.{`..`
  4730: 76 60 a1 06 7d 60 0a 80 60 70 60 50 49 52 41 5b  v`..}`..`p`PIRA[
  4740: 82 48 0c 4c 4e 4b 42 08 5f 48 49 44 0c 41 d0 0c  .H.LNKB._HID.A..
  4750: 0f 08 5f 55 49 44 0a 02 14 18 5f 53 54 41 00 a0  .._UID...._STA..
  4760: 0c 7b 50 49 52 42 0a 80 00 a4 0a 09 a1 04 a4 0a  .{PIRB..........
  4770: 0b 14 11 5f 44 49 53 00 7d 50 49 52 42 0a 80 50  ..._DIS.}PIRB..P
  4780: 49 52 42 14 45 04 5f 43 52 53 00 08 42 55 46 30  IRB.E._CRS..BUF0
  4790: 11 09 0a 06 23 01 00 18 79 00 8b 42 55 46 30 01  ....#...y..BUF0.
  47a0: 49 52 51 57 a0 0c 7b 50 49 52 42 0a 80 00 70 00  IRQW..{PIRB...p.
  47b0: 60 a1 04 70 01 60 79 60 7b 50 49 52 42 0a 0f 00  `..p.`y`{PIRB...
  47c0: 49 52 51 57 a4 42 55 46 30 08 5f 50 52 53 11 09  IRQW.BUF0._PRS..
  47d0: 0a 06 23 b8 1e 18 79 00 14 30 5f 53 52 53 01 8b  ..#...y..0_SRS..
  47e0: 68 01 49 52 51 57 82 49 52 51 57 60 a0 0f 92 93  h.IRQW.IRQW`....
  47f0: 49 52 51 57 00 7b 60 0a 7f 60 76 60 a1 06 7d 60  IRQW.{`..`v`..}`
  4800: 0a 80 60 70 60 50 49 52 42 5b 82 48 0c 4c 4e 4b  ..`p`PIRB[.H.LNK
  4810: 43 08 5f 48 49 44 0c 41 d0 0c 0f 08 5f 55 49 44  C._HID.A...._UID
  4820: 0a 03 14 18 5f 53 54 41 00 a0 0c 7b 50 49 52 43  ...._STA...{PIRC
  4830: 0a 80 00 a4 0a 09 a1 04 a4 0a 0b 14 11 5f 44 49  ............._DI
  4840: 53 00 7d 50 49 52 43 0a 80 50 49 52 43 14 45 04  S.}PIRC..PIRC.E.
  4850: 5f 43 52 53 00 08 42 55 46 30 11 09 0a 06 23 01  _CRS..BUF0....#.
  4860: 00 18 79 00 8b 42 55 46 30 01 49 52 51 57 a0 0c  ..y..BUF0.IRQW..
  4870: 7b 50 49 52 43 0a 80 00 70 00 60 a1 04 70 01 60  {PIRC...p.`..p.`
  4880: 79 60 7b 50 49 52 43 0a 0f 00 49 52 51 57 a4 42  y`{PIRC...IRQW.B
  4890: 55 46 30 08 5f 50 52 53 11 09 0a 06 23 b8 1e 18  UF0._PRS....#...
  48a0: 79 00 14 30 5f 53 52 53 01 8b 68 01 49 52 51 57  y..0_SRS..h.IRQW
  48b0: 82 49 52 51 57 60 a0 0f 92 93 49 52 51 57 00 7b  .IRQW`....IRQW.{
  48c0: 60 0a 7f 60 76 60 a1 06 7d 60 0a 80 60 70 60 50  `..`v`..}`..`p`P
  48d0: 49 52 43 5b 82 48 0c 4c 4e 4b 44 08 5f 48 49 44  IRC[.H.LNKD._HID
  48e0: 0c 41 d0 0c 0f 08 5f 55 49 44 0a 04 14 18 5f 53  .A...._UID...._S
  48f0: 54 41 00 a0 0c 7b 50 49 52 44 0a 80 00 a4 0a 09  TA...{PIRD......
  4900: a1 04 a4 0a 0b 14 11 5f 44 49 53 00 7d 50 49 52  ......._DIS.}PIR
  4910: 44 0a 80 50 49 52 44 14 45 04 5f 43 52 53 00 08  D..PIRD.E._CRS..
  4920: 42 55 46 30 11 09 0a 06 23 01 00 18 79 00 8b 42  BUF0....#...y..B
  4930: 55 46 30 01 49 52 51 57 a0 0c 7b 50 49 52 44 0a  UF0.IRQW..{PIRD.
  4940: 80 00 70 00 60 a1 04 70 01 60 79 60 7b 50 49 52  ..p.`..p.`y`{PIR
  4950: 44 0a 0f 00 49 52 51 57 a4 42 55 46 30 08 5f 50  D...IRQW.BUF0._P
  4960: 52 53 11 09 0a 06 23 b8 1e 18 79 00 14 30 5f 53  RS....#...y..0_S
  4970: 52 53 01 8b 68 01 49 52 51 57 82 49 52 51 57 60  RS..h.IRQW.IRQW`
  4980: a0 0f 92 93 49 52 51 57 00 7b 60 0a 7f 60 76 60  ....IRQW.{`..`v`
  4990: a1 06 7d 60 0a 80 60 70 60 50 49 52 44 5b 82 48  ..}`..`p`PIRD[.H
  49a0: 0c 4c 4e 4b 45 08 5f 48 49 44 0c 41 d0 0c 0f 08  .LNKE._HID.A....
  49b0: 5f 55 49 44 0a 05 14 18 5f 53 54 41 00 a0 0c 7b  _UID...._STA...{
  49c0: 50 49 52 45 0a 80 00 a4 0a 09 a1 04 a4 0a 0b 14  PIRE............
  49d0: 11 5f 44 49 53 00 7d 50 49 52 45 0a 80 50 49 52  ._DIS.}PIRE..PIR
  49e0: 45 14 45 04 5f 43 52 53 00 08 42 55 46 30 11 09  E.E._CRS..BUF0..
  49f0: 0a 06 23 01 00 18 79 00 8b 42 55 46 30 01 49 52  ..#...y..BUF0.IR
  4a00: 51 57 a0 0c 7b 50 49 52 45 0a 80 00 70 00 60 a1  QW..{PIRE...p.`.
  4a10: 04 70 01 60 79 60 7b 50 49 52 45 0a 0f 00 49 52  .p.`y`{PIRE...IR
  4a20: 51 57 a4 42 55 46 30 08 5f 50 52 53 11 09 0a 06  QW.BUF0._PRS....
  4a30: 23 b8 1e 18 79 00 14 30 5f 53 52 53 01 8b 68 01  #...y..0_SRS..h.
  4a40: 49 52 51 57 82 49 52 51 57 60 a0 0f 92 93 49 52  IRQW.IRQW`....IR
  4a50: 51 57 00 7b 60 0a 7f 60 76 60 a1 06 7d 60 0a 80  QW.{`..`v`..}`..
  4a60: 60 70 60 50 49 52 45 5b 82 48 0c 4c 4e 4b 46 08  `p`PIRE[.H.LNKF.
  4a70: 5f 48 49 44 0c 41 d0 0c 0f 08 5f 55 49 44 0a 06  _HID.A...._UID..
  4a80: 14 18 5f 53 54 41 00 a0 0c 7b 50 49 52 46 0a 80  .._STA...{PIRF..
  4a90: 00 a4 0a 09 a1 04 a4 0a 0b 14 11 5f 44 49 53 00  ..........._DIS.
  4aa0: 7d 50 49 52 46 0a 80 50 49 52 46 14 45 04 5f 43  }PIRF..PIRF.E._C
  4ab0: 52 53 00 08 42 55 46 30 11 09 0a 06 23 01 00 18  RS..BUF0....#...
  4ac0: 79 00 8b 42 55 46 30 01 49 52 51 57 a0 0c 7b 50  y..BUF0.IRQW..{P
  4ad0: 49 52 46 0a 80 00 70 00 60 a1 04 70 01 60 79 60  IRF...p.`..p.`y`
  4ae0: 7b 50 49 52 46 0a 0f 00 49 52 51 57 a4 42 55 46  {PIRF...IRQW.BUF
  4af0: 30 08 5f 50 52 53 11 09 0a 06 23 b8 1e 18 79 00  0._PRS....#...y.
  4b00: 14 30 5f 53 52 53 01 8b 68 01 49 52 51 57 82 49  .0_SRS..h.IRQW.I
  4b10: 52 51 57 60 a0 0f 92 93 49 52 51 57 00 7b 60 0a  RQW`....IRQW.{`.
  4b20: 7f 60 76 60 a1 06 7d 60 0a 80 60 70 60 50 49 52  .`v`..}`..`p`PIR
  4b30: 46 5b 82 48 0c 4c 4e 4b 47 08 5f 48 49 44 0c 41  F[.H.LNKG._HID.A
  4b40: d0 0c 0f 08 5f 55 49 44 0a 07 14 18 5f 53 54 41  ...._UID...._STA
  4b50: 00 a0 0c 7b 50 49 52 47 0a 80 00 a4 0a 09 a1 04  ...{PIRG........
  4b60: a4 0a 0b 14 11 5f 44 49 53 00 7d 50 49 52 47 0a  ....._DIS.}PIRG.
  4b70: 80 50 49 52 47 14 45 04 5f 43 52 53 00 08 42 55  .PIRG.E._CRS..BU
  4b80: 46 30 11 09 0a 06 23 01 00 18 79 00 8b 42 55 46  F0....#...y..BUF
  4b90: 30 01 49 52 51 57 a0 0c 7b 50 49 52 47 0a 80 00  0.IRQW..{PIRG...
  4ba0: 70 00 60 a1 04 70 01 60 79 60 7b 50 49 52 47 0a  p.`..p.`y`{PIRG.
  4bb0: 0f 00 49 52 51 57 a4 42 55 46 30 08 5f 50 52 53  ..IRQW.BUF0._PRS
  4bc0: 11 09 0a 06 23 b8 1e 18 79 00 14 30 5f 53 52 53  ....#...y..0_SRS
  4bd0: 01 8b 68 01 49 52 51 57 82 49 52 51 57 60 a0 0f  ..h.IRQW.IRQW`..
  4be0: 92 93 49 52 51 57 00 7b 60 0a 7f 60 76 60 a1 06  ..IRQW.{`..`v`..
  4bf0: 7d 60 0a 80 60 70 60 50 49 52 47 5b 82 48 0c 4c  }`..`p`PIRG[.H.L
  4c00: 4e 4b 48 08 5f 48 49 44 0c 41 d0 0c 0f 08 5f 55  NKH._HID.A...._U
  4c10: 49 44 0a 08 14 18 5f 53 54 41 00 a0 0c 7b 50 49  ID...._STA...{PI
  4c20: 52 48 0a 80 00 a4 0a 09 a1 04 a4 0a 0b 14 11 5f  RH............._
  4c30: 44 49 53 00 7d 50 49 52 48 0a 80 50 49 52 48 14  DIS.}PIRH..PIRH.
  4c40: 45 04 5f 43 52 53 00 08 42 55 46 30 11 09 0a 06  E._CRS..BUF0....
  4c50: 23 01 00 18 79 00 8b 42 55 46 30 01 49 52 51 57  #...y..BUF0.IRQW
  4c60: a0 0c 7b 50 49 52 48 0a 80 00 70 00 60 a1 04 70  ..{PIRH...p.`..p
  4c70: 01 60 79 60 7b 50 49 52 48 0a 0f 00 49 52 51 57  .`y`{PIRH...IRQW
  4c80: a4 42 55 46 30 08 5f 50 52 53 11 09 0a 06 23 b8  .BUF0._PRS....#.
  4c90: 1e 18 79 00 14 30 5f 53 52 53 01 8b 68 01 49 52  ..y..0_SRS..h.IR
  4ca0: 51 57 82 49 52 51 57 60 a0 0f 92 93 49 52 51 57  QW.IRQW`....IRQW
  4cb0: 00 7b 60 0a 7f 60 76 60 a1 06 7d 60 0a 80 60 70  .{`..`v`..}`..`p
  4cc0: 60 50 49 52 48 5b 82 43 13 53 59 53 52 14 15 5f  `PIRH[.C.SYSR.._
  4cd0: 53 54 41 00 a0 0a 93 50 4d 49 44 01 a4 0a 0f a1  STA....PMID.....
  4ce0: 03 a4 00 08 5f 48 49 44 0c 41 d0 0c 02 08 5f 43  ...._HID.A...._C
  4cf0: 52 53 11 47 10 0b 02 01 47 01 2e 00 2e 00 01 02  RS.G....G.......
  4d00: 47 01 4e 00 4e 00 01 02 47 01 4e 16 4e 16 01 02  G.N.N...G.N.N...
  4d10: 47 01 61 00 61 00 01 01 47 01 70 00 70 00 01 01  G.a.a...G.p.p...
  4d20: 47 01 80 00 80 00 01 01 47 01 92 00 92 00 01 01  G.......G.......
  4d30: 47 01 b2 00 b2 00 01 02 47 01 63 00 63 00 01 01  G.......G.c.c...
  4d40: 47 01 65 00 65 00 01 01 47 01 67 00 67 00 01 01  G.e.e...G.g.g...
  4d50: 47 01 00 06 00 06 01 10 47 01 10 06 10 06 01 01  G.......G.......
  4d60: 47 01 00 08 00 08 01 10 47 01 10 08 10 08 01 08  G.......G.......
  4d70: 47 01 20 08 20 08 01 04 47 01 00 04 00 04 01 80  G. . ...G.......
  4d80: 47 01 00 05 00 05 01 80 47 01 68 00 68 00 01 01  G.......G.h.h...
  4d90: 47 01 6c 00 6c 00 01 01 86 09 00 01 00 00 00 f8  G.l.l...........
  4da0: 00 00 00 04 86 09 00 01 00 c0 d1 fe 00 40 00 00  .............@..
  4db0: 86 09 00 01 00 00 d1 fe 00 40 00 00 86 09 00 01  .........@......
  4dc0: 00 80 d1 fe 00 10 00 00 86 09 00 01 00 90 d1 fe  ................
  4dd0: 00 10 00 00 86 09 00 01 00 00 c0 fe 00 10 00 00  ................
  4de0: 86 09 00 01 00 00 d2 fe 00 00 07 00 86 09 00 01  ................
  4df0: 00 00 e0 fe 00 10 00 00 79 00 5b 82 4b 13 53 59  ........y.[.K.SY
  4e00: 53 4d 14 15 5f 53 54 41 00 a0 09 93 50 4d 49 44  SM.._STA....PMID
  4e10: 01 a4 00 a1 04 a4 0a 0f 08 5f 48 49 44 0c 41 d0  ........._HID.A.
  4e20: 0c 02 08 5f 43 52 53 11 4f 10 0b 0a 01 47 01 2e  ..._CRS.O....G..
  4e30: 00 2e 00 01 02 47 01 4e 00 4e 00 01 02 47 01 4e  .....G.N.N...G.N
  4e40: 16 4e 16 01 02 47 01 61 00 61 00 01 01 47 01 70  .N...G.a.a...G.p
  4e50: 00 70 00 01 01 47 01 80 00 80 00 01 01 47 01 92  .p...G.......G..
  4e60: 00 92 00 01 01 47 01 b2 00 b2 00 01 02 47 01 63  .....G.......G.c
  4e70: 00 63 00 01 01 47 01 65 00 65 00 01 01 47 01 67  .c...G.e.e...G.g
  4e80: 00 67 00 01 01 47 01 00 06 00 06 01 10 47 01 10  .g...G.......G..
  4e90: 06 10 06 01 01 47 01 00 08 00 08 01 10 47 01 10  .....G.......G..
  4ea0: 08 10 08 01 08 47 01 20 08 20 08 01 04 47 01 00  .....G. . ...G..
  4eb0: 04 00 04 01 80 47 01 00 05 00 05 01 80 47 01 68  .....G.......G.h
  4ec0: 00 68 00 01 01 47 01 6c 00 6c 00 01 01 47 01 2c  .h...G.l.l...G.,
  4ed0: ff 2c ff 01 04 86 09 00 01 00 00 00 f8 00 00 00  .,..............
  4ee0: 04 86 09 00 01 00 c0 d1 fe 00 40 00 00 86 09 00  ..........@.....
  4ef0: 01 00 00 d1 fe 00 40 00 00 86 09 00 01 00 80 d1  ......@.........
  4f00: fe 00 10 00 00 86 09 00 01 00 90 d1 fe 00 10 00  ................
  4f10: 00 86 09 00 01 00 00 c0 fe 00 10 00 00 86 09 00  ................
  4f20: 01 00 00 d2 fe 00 00 07 00 86 09 00 01 00 00 e0  ................
  4f30: fe 00 10 00 00 79 00 5b 82 3d 44 4d 41 43 08 5f  .....y.[.=DMAC._
  4f40: 48 49 44 0c 41 d0 02 00 08 5f 43 52 53 11 28 0a  HID.A...._CRS.(.
  4f50: 25 47 01 00 00 00 00 01 20 47 01 81 00 81 00 01  %G...... G......
  4f60: 11 47 01 93 00 93 00 01 0d 47 01 c0 00 c0 00 01  .G.......G......
  4f70: 20 2a 10 01 79 00 5b 82 44 05 52 54 43 5f 08 5f   *..y.[.D.RTC_._
  4f80: 48 49 44 0c 41 d0 0b 00 08 42 55 46 30 11 0d 0a  HID.A....BUF0...
  4f90: 0a 47 01 70 00 70 00 01 08 79 00 08 42 55 46 31  .G.p.p...y..BUF1
  4fa0: 11 10 0a 0d 47 01 70 00 70 00 01 08 22 00 01 79  ....G.p.p..."..y
  4fb0: 00 14 1a 5f 43 52 53 08 a0 0c 93 48 50 54 53 01  ..._CRS....HPTS.
  4fc0: a4 42 55 46 30 a1 06 a4 42 55 46 31 5b 82 46 0b  .BUF0...BUF1[.F.
  4fd0: 48 50 45 54 08 5f 48 49 44 0c 41 d0 01 03 08 42  HPET._HID.A....B
  4fe0: 55 46 30 11 17 0a 14 22 01 00 22 00 01 86 09 00  UF0...."..".....
  4ff0: 00 00 00 d0 fe 00 04 00 00 79 00 14 2f 5f 53 54  .........y../_ST
  5000: 41 00 a0 19 92 95 4f 53 59 53 0b d1 07 a0 0a 93  A.....OSYS......
  5010: 48 50 54 53 01 a4 0a 0f a1 03 a4 00 a1 0e a0 08  HPTS............
  5020: 48 50 54 53 a4 0a 0b a1 03 a4 00 14 48 05 5f 43  HPTS........H._C
  5030: 52 53 08 a0 4b 04 93 48 50 54 53 01 8a 42 55 46  RS..K..HPTS..BUF
  5040: 30 0a 0a 48 50 54 30 a0 11 93 48 50 54 41 01 70  0..HPT0...HPTA.p
  5050: 0c 00 10 d0 fe 48 50 54 30 a0 12 93 48 50 54 41  .....HPT0...HPTA
  5060: 0a 02 70 0c 00 20 d0 fe 48 50 54 30 a0 12 93 48  ..p.. ..HPT0...H
  5070: 50 54 41 0a 03 70 0c 00 30 d0 fe 48 50 54 30 a4  PTA..p..0..HPT0.
  5080: 42 55 46 30 5b 82 45 0a 50 49 43 5f 08 5f 48 49  BUF0[.E.PIC_._HI
  5090: 44 0b 41 d0 08 5f 43 52 53 11 41 09 0a 8d 47 01  D.A.._CRS.A...G.
  50a0: 20 00 20 00 01 02 47 01 24 00 24 00 01 02 47 01   . ...G.$.$...G.
  50b0: 28 00 28 00 01 02 47 01 2c 00 2c 00 01 02 47 01  (.(...G.,.,...G.
  50c0: 30 00 30 00 01 02 47 01 34 00 34 00 01 02 47 01  0.0...G.4.4...G.
  50d0: 38 00 38 00 01 02 47 01 3c 00 3c 00 01 02 47 01  8.8...G.<.<...G.
  50e0: a0 00 a0 00 01 02 47 01 a4 00 a4 00 01 02 47 01  ......G.......G.
  50f0: a8 00 a8 00 01 02 47 01 ac 00 ac 00 01 02 47 01  ......G.......G.
  5100: b0 00 b0 00 01 02 47 01 b4 00 b4 00 01 02 47 01  ......G.......G.
  5110: b8 00 b8 00 01 02 47 01 bc 00 bc 00 01 02 47 01  ......G.......G.
  5120: d0 04 d0 04 01 02 22 04 00 79 00 5b 82 25 46 50  ......"..y.[.%FP
  5130: 55 5f 08 5f 48 49 44 0c 41 d0 0c 04 08 5f 43 52  U_._HID.A...._CR
  5140: 53 11 10 0a 0d 47 01 f0 00 f0 00 01 01 22 00 20  S....G.......". 
  5150: 79 00 5b 82 40 06 54 49 4d 52 08 5f 48 49 44 0c  y.[.@.TIMR._HID.
  5160: 41 d0 01 00 08 42 55 46 30 11 15 0a 12 47 01 40  A....BUF0....G.@
  5170: 00 40 00 01 04 47 01 50 00 50 00 10 04 79 00 08  .@...G.P.P...y..
  5180: 42 55 46 31 11 18 0a 15 47 01 40 00 40 00 01 04  BUF1....G.@.@...
  5190: 47 01 50 00 50 00 10 04 22 01 00 79 00 14 16 5f  G.P.P..."..y..._
  51a0: 43 52 53 08 a0 0a 48 50 54 53 a4 42 55 46 30 a4  CRS...HPTS.BUF0.
  51b0: 42 55 46 31 5b 82 26 46 57 48 44 08 5f 48 49 44  BUF1[.&FWHD._HID
  51c0: 0c 25 d4 08 00 08 5f 43 52 53 11 11 0a 0e 86 09  .%...._CRS......
  51d0: 00 00 00 00 f0 ff 00 00 10 00 79 00 5b 82 46 05  ..........y.[.F.
  51e0: 4b 42 43 30 08 5f 48 49 44 0c 41 d0 03 03 14 26  KBC0._HID.A....&
  51f0: 5f 53 54 41 00 a0 1a 92 95 4f 53 59 53 0b d6 07  _STA.....OSYS...
  5200: a0 0a 93 4b 42 54 50 0a 4a a4 00 a1 04 a4 0a 0f  ...KBTP.J.......
  5210: a1 04 a4 0a 0f 08 5f 43 52 53 11 19 0a 16 47 01  ......_CRS....G.
  5220: 60 00 60 00 01 01 47 01 64 00 64 00 01 01 23 02  `.`...G.d.d...#.
  5230: 00 01 79 00 5b 82 45 05 4b 42 43 4a 08 5f 48 49  ..y.[.E.KBCJ._HI
  5240: 44 0c 41 d0 03 20 14 25 5f 53 54 41 00 a0 1a 92  D.A.. .%_STA....
  5250: 95 4f 53 59 53 0b d6 07 a0 0b 93 4b 42 54 50 0a  .OSYS......KBTP.
  5260: 4a a4 0a 0f a1 03 a4 00 a1 03 a4 00 08 5f 43 52  J............_CR
  5270: 53 11 19 0a 16 47 01 60 00 60 00 01 01 47 01 64  S....G.`.`...G.d
  5280: 00 64 00 01 01 23 02 00 01 79 00 5b 82 37 4d 53  .d...#...y.[.7MS
  5290: 45 30 08 5f 48 49 44 0c 41 d0 0f 13 14 18 5f 53  E0._HID.A....._S
  52a0: 54 41 00 a0 0c 93 7b 54 50 41 44 01 00 01 a4 00  TA....{TPAD.....
  52b0: a1 04 a4 0a 0f 08 5f 43 52 53 11 09 0a 06 23 00  ......_CRS....#.
  52c0: 10 01 79 00 5b 82 4f 04 4d 53 53 30 08 5f 48 49  ..y.[.O.MSS0._HI
  52d0: 44 0c 4f 2e 1b 16 08 5f 43 49 44 12 11 03 0c 4f  D.O...._CID....O
  52e0: 2e 1b 00 0c 4f 2e 00 02 0c 41 d0 0f 13 14 18 5f  ....O....A....._
  52f0: 53 54 41 00 a0 0d 93 7b 54 50 41 44 01 00 01 a4  STA....{TPAD....
  5300: 0a 0f a1 03 a4 00 08 5f 43 52 53 11 09 0a 06 23  ......._CRS....#
  5310: 00 10 01 79 00 5b 82 4e 98 45 43 30 5f 08 5f 48  ...y.[.N.EC0_._H
  5320: 49 44 0c 41 d0 0c 09 08 5f 55 49 44 01 08 5f 47  ID.A...._UID.._G
  5330: 50 45 0a 1c 14 26 5f 43 52 53 00 08 42 46 46 52  PE...&_CRS..BFFR
  5340: 11 15 0a 12 47 01 62 00 62 00 00 01 47 01 66 00  ....G.b.b...G.f.
  5350: 66 00 00 01 79 00 a4 42 46 46 52 08 5f 41 44 52  f...y..BFFR._ADR
  5360: 0c 00 00 02 00 5b 80 48 44 43 53 02 00 01 5b 81  .....[.HDCS...[.
  5370: 0b 48 44 43 53 01 4f 42 56 5f 08 5b 80 45 52 41  .HDCS.OBV_.[.ERA
  5380: 4d 03 00 0a ff 5b 81 4b 39 45 52 41 4d 11 00 01  M....[.K9ERAM...
  5390: 4c 43 44 53 01 44 4f 43 4b 01 4c 41 4e 43 01 42  LCDS.DOCK.LANC.B
  53a0: 42 45 54 01 00 3b 42 41 54 4d 10 00 48 07 42 41  BET..;BATM..H.BA
  53b0: 54 44 38 00 40 20 53 4d 50 52 08 53 4d 53 54 08  TD8.@ SMPR.SMST.
  53c0: 53 4d 41 44 08 53 4d 43 4d 08 53 4d 44 52 20 42  SMAD.SMCM.SMDR B
  53d0: 43 4e 54 08 53 4d 41 41 08 53 4d 44 30 08 53 4d  CNT.SMAA.SMD0.SM
  53e0: 44 31 08 00 40 12 00 08 00 08 00 08 00 08 45 52  D1..@.........ER
  53f0: 49 42 10 45 52 42 44 08 00 08 00 08 4f 53 49 46  IB.ERBD.....OSIF
  5400: 01 00 07 42 41 4c 31 01 42 41 4c 32 01 42 41 4c  ...BAL1.BAL2.BAL
  5410: 33 01 42 41 4c 34 01 42 43 4c 31 01 42 43 4c 32  3.BAL4.BCL1.BCL2
  5420: 01 42 43 4c 33 01 42 43 4c 34 01 42 50 55 31 01  .BCL3.BCL4.BPU1.
  5430: 42 50 55 32 01 42 50 55 33 01 42 50 55 34 01 42  BPU2.BPU3.BPU4.B
  5440: 4f 53 31 01 42 4f 53 32 01 42 4f 53 33 01 42 4f  OS1.BOS2.BOS3.BO
  5450: 53 34 01 50 48 44 44 01 49 46 44 44 01 49 4f 44  S4.PHDD.IFDD.IOD
  5460: 44 01 53 48 44 44 01 4c 53 32 30 01 45 46 44 44  D.SHDD.LS20.EFDD
  5470: 01 45 43 52 54 01 00 01 53 42 54 4e 01 56 49 44  .ECRT...SBTN.VID
  5480: 4f 01 56 4f 4c 44 01 56 4f 4c 55 01 4d 55 54 45  O.VOLD.VOLU.MUTE
  5490: 01 43 4f 4e 54 01 42 52 47 54 01 48 42 54 4e 01  .CONT.BRGT.HBTN.
  54a0: 53 34 53 45 01 53 4b 45 59 01 42 4b 45 59 01 54  S4SE.SKEY.BKEY.T
  54b0: 4b 45 59 01 46 4b 45 59 01 44 56 44 4d 01 44 49  KEY.FKEY.DVDM.DI
  54c0: 47 4d 01 43 44 4c 4b 01 00 01 4c 49 44 4f 01 50  GM.CDLK...LIDO.P
  54d0: 4d 45 45 01 50 42 45 54 01 52 49 49 4e 01 42 54  MEE.PBET.RIIN.BT
  54e0: 57 4b 01 44 4b 49 4e 01 00 01 00 06 53 57 54 48  WK.DKIN.....SWTH
  54f0: 01 48 57 54 48 01 44 4b 54 30 01 44 4b 54 31 01  .HWTH.DKT0.DKT1.
  5500: 00 02 4f 53 55 44 01 4f 53 44 4b 01 4f 53 53 55  ..OSUD.OSDK.OSSU
  5510: 01 44 4b 43 47 01 4f 44 54 53 08 53 31 4c 44 01  .DKCG.ODTS.S1LD.
  5520: 53 33 4c 44 01 56 47 41 51 01 50 43 4d 51 01 50  S3LD.VGAQ.PCMQ.P
  5530: 43 4d 52 01 41 44 50 54 01 53 59 53 36 01 53 59  CMR.ADPT.SYS6.SY
  5540: 53 37 01 50 57 41 4b 01 4d 57 41 4b 01 4c 57 41  S7.PWAK.MWAK.LWA
  5550: 4b 01 52 57 41 4b 01 00 02 4b 57 41 4b 01 4d 53  K.RWAK...KWAK.MS
  5560: 57 4b 01 43 43 41 43 01 41 4f 41 43 01 42 4c 41  WK.CCAC.AOAC.BLA
  5570: 43 01 50 53 52 43 01 42 4f 41 43 01 4c 43 41 43  C.PSRC.BOAC.LCAC
  5580: 01 41 41 41 43 01 41 43 41 43 01 50 43 45 43 08  .AAAC.ACAC.PCEC.
  5590: 54 48 4f 4e 08 54 48 53 44 08 54 48 45 4d 08 54  THON.THSD.THEM.T
  55a0: 43 4f 4e 08 54 48 52 53 08 54 48 53 45 08 46 53  CON.THRS.THSE.FS
  55b0: 53 4e 04 46 41 4e 55 04 50 54 56 4c 03 00 03 54  SN.FANU.PTVL...T
  55c0: 54 53 52 01 54 54 48 52 01 54 53 54 48 01 54 53  TSR.TTHR.TSTH.TS
  55d0: 42 43 01 54 53 42 46 01 54 53 50 4c 01 54 53 42  BC.TSBF.TSPL.TSB
  55e0: 54 01 00 02 54 48 54 41 01 43 54 4d 50 08 4c 54  T...THTA.CTMP.LT
  55f0: 4d 50 08 00 08 00 08 53 4b 54 43 08 53 4b 54 41  MP.....SKTC.SKTA
  5600: 08 4e 42 54 50 08 00 08 42 54 50 56 08 42 52 54  .NBTP...BTPV.BRT
  5610: 53 08 43 54 52 53 08 57 4c 41 54 01 42 54 41 54  S.CTRS.WLAT.BTAT
  5620: 01 57 4c 45 58 01 42 54 45 58 01 4b 4c 53 57 01  .WLEX.BTEX.KLSW.
  5630: 57 4c 4f 4b 01 00 02 50 4a 49 44 08 43 50 55 4e  WLOK...PJID.CPUN
  5640: 08 54 48 46 4e 08 4d 4c 45 44 01 53 43 48 47 01  .THFN.MLED.SCHG.
  5650: 53 43 43 46 01 53 43 50 46 01 41 43 49 53 01 00  SCCF.SCPF.ACIS..
  5660: 03 00 04 42 54 4d 46 03 42 54 59 30 01 42 53 54  ...BTMF.BTY0.BST
  5670: 30 08 42 52 43 30 10 42 53 4e 30 10 42 50 56 30  0.BRC0.BSN0.BPV0
  5680: 10 42 44 56 30 10 42 44 43 30 10 42 46 43 30 10  .BDV0.BDC0.BFC0.
  5690: 47 41 55 30 08 42 53 43 59 08 42 53 43 55 10 42  GAU0.BSCY.BSCU.B
  56a0: 41 43 30 10 42 54 57 30 08 42 41 54 56 08 42 50  AC0.BTW0.BATV.BP
  56b0: 54 43 08 42 54 54 43 08 42 54 4d 41 10 42 54 53  TC.BTTC.BTMA.BTS
  56c0: 43 08 42 43 49 58 08 43 43 42 41 08 43 42 4f 54  C.BCIX.CCBA.CBOT
  56d0: 08 42 54 53 53 10 4f 56 43 43 08 43 43 46 43 08  .BTSS.OVCC.CCFC.
  56e0: 42 41 44 43 08 42 53 43 31 10 42 53 43 32 10 42  BADC.BSC1.BSC2.B
  56f0: 53 43 33 10 42 53 43 34 10 42 44 4d 45 10 00 08  SC3.BSC4.BDME...
  5700: 00 08 00 08 42 54 53 31 08 42 54 53 32 08 42 53  ....BTS1.BTS2.BS
  5710: 43 53 10 42 44 41 44 10 42 41 43 56 10 42 44 46  CS.BDAD.BACV.BDF
  5720: 43 08 5b 80 43 43 4c 4b 01 0b 10 04 0a 04 5b 81  C.[.CCLK......[.
  5730: 20 43 43 4c 4b 03 00 01 44 55 54 59 03 54 48 45   CCLK...DUTY.THE
  5740: 4e 01 00 03 46 54 54 5f 01 00 08 54 53 54 53 01  N...FTT_...TSTS.
  5750: 5b 01 46 41 4d 58 00 14 22 46 41 4e 47 01 5b 23  [.FAMX.."FANG.[#
  5760: 46 41 4d 58 ff ff 70 68 45 52 49 42 70 45 52 42  FAMX..phERIBpERB
  5770: 44 60 5b 27 46 41 4d 58 a4 60 14 22 46 41 4e 57  D`['FAMX.`."FANW
  5780: 02 5b 23 46 41 4d 58 ff ff 70 68 45 52 49 42 70  .[#FAMX..phERIBp
  5790: 69 45 52 42 44 5b 27 46 41 4d 58 a4 69 14 09 54  iERBD['FAMX.i..T
  57a0: 55 56 52 01 a4 0a 03 14 2e 54 48 52 4f 01 a0 09  UVR......THRO...
  57b0: 93 68 00 a4 54 48 45 4e a1 1d a0 09 93 68 01 a4  .h..THEN.....h..
  57c0: 44 55 54 59 a1 11 a0 0a 93 68 0a 02 a4 54 54 48  DUTY.....h...TTH
  57d0: 52 a1 04 a4 0a ff 14 24 43 4c 43 4b 01 a0 0a 93  R......$CLCK....
  57e0: 68 00 70 00 54 48 45 4e a1 0d 70 68 44 55 54 59  h.p.THEN..phDUTY
  57f0: 70 01 54 48 45 4e a4 54 48 45 4e 14 3e 50 43 4c  p.THEN.THEN.>PCL
  5800: 4b 00 70 50 54 56 4c 60 a0 0a 93 60 00 70 00 54  K.pPTVL`...`.p.T
  5810: 48 45 4e a1 26 80 60 60 72 60 01 60 7b 60 0a 07  HEN.&.``r`.`{`..
  5820: 60 70 60 44 55 54 59 a0 0a 93 60 00 70 00 54 48  `p`DUTY...`.p.TH
  5830: 45 4e a1 07 70 01 54 48 45 4e 14 40 07 5f 52 45  EN..p.THEN.@._RE
  5840: 47 02 a0 48 06 93 68 0a 03 70 69 45 43 4f 4e a0  G..H..h..piECON.
  5850: 36 93 4c 49 44 4f 5e 5e 5e 2e 4f 56 47 41 43 4c  6.LIDO^^^.OVGACL
  5860: 49 44 a0 14 93 4c 49 44 4f 00 5e 5e 5e 2e 4f 56  ID...LIDO.^^^.OV
  5870: 47 41 47 4c 49 44 01 a1 0e 5e 5e 5e 2e 4f 56 47  GAGLID...^^^.OVG
  5880: 41 47 4c 49 44 00 a1 24 a0 22 92 5e 5e 5e 2e 4f  AGLID..$.".^^^.O
  5890: 56 47 41 47 4c 49 44 4c 49 44 4f 70 4c 49 44 4f  VGAGLIDLIDOpLIDO
  58a0: 4c 49 44 53 86 4c 49 44 30 0a 80 14 41 09 5f 51  LIDS.LID0...A._Q
  58b0: 31 31 00 a0 38 92 95 4f 53 59 53 0b d6 07 a0 1c  11..8..OSYS.....
  58c0: 93 4f 42 56 5f 0a ff 86 5e 5e 5e 2f 03 50 45 47  .OBV_...^^^/.PEG
  58d0: 50 56 47 41 5f 4c 43 44 5f 0a 87 a1 10 86 5e 5e  PVGA_LCD_.....^^
  58e0: 5e 2e 4f 56 47 41 44 44 30 33 0a 87 a1 40 05 5e  ^.OVGADD03...@.^
  58f0: 5e 5e 2e 4f 56 47 41 41 49 4e 54 01 42 52 54 53  ^^.OVGAAINT.BRTS
  5900: a0 3c 93 5e 5e 5e 2e 57 4d 49 44 42 41 45 46 01  .<.^^^.WMIDBAEF.
  5910: 70 42 52 54 53 61 70 5e 5e 5e 2e 57 4d 49 44 4c  pBRTSap^^^.WMIDL
  5920: 42 4c 30 62 72 62 61 62 70 62 5e 5e 5e 2e 57 4d  BL0brbabpb^^^.WM
  5930: 49 44 4e 54 44 43 86 57 4d 49 44 0a 80 14 41 09  IDNTDC.WMID...A.
  5940: 5f 51 31 32 00 a0 38 92 95 4f 53 59 53 0b d6 07  _Q12..8..OSYS...
  5950: a0 1c 93 4f 42 56 5f 0a ff 86 5e 5e 5e 2f 03 50  ...OBV_...^^^/.P
  5960: 45 47 50 56 47 41 5f 4c 43 44 5f 0a 86 a1 10 86  EGPVGA_LCD_.....
  5970: 5e 5e 5e 2e 4f 56 47 41 44 44 30 33 0a 86 a1 40  ^^^.OVGADD03...@
  5980: 05 5e 5e 5e 2e 4f 56 47 41 41 49 4e 54 01 42 52  .^^^.OVGAAINT.BR
  5990: 54 53 a0 3c 93 5e 5e 5e 2e 57 4d 49 44 42 41 45  TS.<.^^^.WMIDBAE
  59a0: 46 01 70 42 52 54 53 61 70 5e 5e 5e 2e 57 4d 49  F.pBRTSap^^^.WMI
  59b0: 44 4c 42 4c 30 62 72 62 61 62 70 62 5e 5e 5e 2e  DLBL0brbabpb^^^.
  59c0: 57 4d 49 44 4e 54 44 43 86 57 4d 49 44 0a 80 14  WMIDNTDC.WMID...
  59d0: 43 05 5f 51 31 43 00 a0 17 93 4f 42 56 5f 0a ff  C._Q1C....OBV_..
  59e0: 86 5e 5e 5e 2e 50 45 47 50 56 47 41 5f 0a cb a1  .^^^.PEGPVGA_...
  59f0: 33 a0 31 91 5e 5e 5e 2e 4f 56 47 41 43 50 44 53  3.1.^^^.OVGACPDS
  5a00: 0c 00 01 00 80 5e 5e 5e 2e 4f 56 47 41 43 50 44  .....^^^.OVGACPD
  5a10: 53 0c 20 03 00 80 5e 5e 5e 2e 4f 56 47 41 47 48  S. ...^^^.OVGAGH
  5a20: 44 53 01 14 0a 5f 51 31 44 00 50 43 4c 4b 14 0d  DS..._Q1D.PCLK..
  5a30: 5f 51 32 32 00 86 42 41 54 30 0a 80 14 14 5f 51  _Q22..BAT0...._Q
  5a40: 32 35 00 86 42 41 54 30 0a 81 86 42 41 54 30 0a  25..BAT0...BAT0.
  5a50: 80 14 0c 5f 51 32 41 00 4f 53 4d 49 0a 92 14 0c  ..._Q2A.OSMI....
  5a60: 5f 51 32 42 00 4f 53 4d 49 0a 93 14 44 04 5f 51  _Q2B.OSMI...D._Q
  5a70: 33 34 00 a0 3c 93 5e 5e 5e 2e 57 4d 49 44 42 41  34..<.^^^.WMIDBA
  5a80: 45 46 01 70 42 54 41 54 61 70 5e 5e 5e 2e 57 4d  EF.pBTATap^^^.WM
  5a90: 49 44 42 4c 54 44 62 72 62 61 62 70 62 5e 5e 5e  IDBLTDbrbabpb^^^
  5aa0: 2e 57 4d 49 44 4e 54 44 43 86 57 4d 49 44 0a 80  .WMIDNTDC.WMID..
  5ab0: 14 42 06 5f 51 33 37 00 86 41 43 5f 5f 00 5b 22  .B._Q37..AC__.["
  5ac0: 0b f0 03 86 42 41 54 30 0a 80 86 5c 2e 5f 50 52  ....BAT0...\._PR
  5ad0: 5f 43 50 55 30 0a 80 86 5c 2e 5f 50 52 5f 43 50  _CPU0...\._PR_CP
  5ae0: 55 31 0a 80 a0 28 92 93 5e 5e 5e 2f 03 45 58 50  U1...(..^^^/.EXP
  5af0: 35 4a 33 38 30 44 56 49 44 ff 70 00 5e 5e 5e 2f  5J380DVID.p.^^^/
  5b00: 03 45 58 50 35 4a 33 38 30 44 33 45 46 4f 53 4d  .EXP5J380D3EFOSM
  5b10: 49 0a 87 14 42 06 5f 51 33 38 00 86 41 43 5f 5f  I...B._Q38..AC__
  5b20: 01 5b 22 0b f0 03 86 42 41 54 30 0a 80 86 5c 2e  .["....BAT0...\.
  5b30: 5f 50 52 5f 43 50 55 30 0a 80 86 5c 2e 5f 50 52  _PR_CPU0...\._PR
  5b40: 5f 43 50 55 31 0a 80 a0 28 92 93 5e 5e 5e 2f 03  _CPU1...(..^^^/.
  5b50: 45 58 50 35 4a 33 38 30 44 56 49 44 ff 70 01 5e  EXP5J380DVID.p.^
  5b60: 5e 5e 2f 03 45 58 50 35 4a 33 38 30 44 33 45 46  ^^/.EXP5J380D3EF
  5b70: 4f 53 4d 49 0a 88 14 44 04 5f 51 36 30 00 a0 3c  OSMI...D._Q60..<
  5b80: 93 5e 5e 5e 2e 57 4d 49 44 42 41 45 46 01 70 57  .^^^.WMIDBAEF.pW
  5b90: 4c 41 54 61 70 5e 5e 5e 2e 57 4d 49 44 57 4c 53  LATap^^^.WMIDWLS
  5ba0: 44 62 72 62 61 62 70 62 5e 5e 5e 2e 57 4d 49 44  Dbrbabpb^^^.WMID
  5bb0: 4e 54 44 43 86 57 4d 49 44 0a 80 14 4d 04 5f 51  NTDC.WMID...M._Q
  5bc0: 36 31 00 a0 45 04 93 5e 5e 5e 2e 57 4d 49 44 42  61..E..^^^.WMIDB
  5bd0: 41 45 46 01 70 00 61 a0 0a 93 42 42 45 54 01 70  AEF.p.a...BBET.p
  5be0: 01 61 70 5e 5e 5e 2e 57 4d 49 44 42 55 4f 46 62  .ap^^^.WMIDBUOFb
  5bf0: 72 62 61 62 70 62 5e 5e 5e 2e 57 4d 49 44 4e 54  rbabpb^^^.WMIDNT
  5c00: 44 43 86 57 4d 49 44 0a 80 14 4d 04 5f 51 34 46  DC.WMID...M._Q4F
  5c10: 00 a0 45 04 93 5e 5e 5e 2e 57 4d 49 44 42 41 45  ..E..^^^.WMIDBAE
  5c20: 46 01 70 01 61 a0 0a 93 4c 41 4e 43 01 70 00 61  F.p.a...LANC.p.a
  5c30: 70 5e 5e 5e 2e 57 4d 49 44 4c 41 4e 49 62 72 62  p^^^.WMIDLANIbrb
  5c40: 61 62 70 62 5e 5e 5e 2e 57 4d 49 44 4e 54 44 43  abpb^^^.WMIDNTDC
  5c50: 86 57 4d 49 44 0a 80 14 4d 04 5f 51 35 30 00 a0  .WMID...M._Q50..
  5c60: 45 04 93 5e 5e 5e 2e 57 4d 49 44 42 41 45 46 01  E..^^^.WMIDBAEF.
  5c70: 70 00 61 a0 0a 93 4c 43 44 53 01 70 01 61 70 5e  p.a...LCDS.p.ap^
  5c80: 5e 5e 2e 57 4d 49 44 4c 44 4f 46 62 72 62 61 62  ^^.WMIDLDOFbrbab
  5c90: 70 62 5e 5e 5e 2e 57 4d 49 44 4e 54 44 43 86 57  pb^^^.WMIDNTDC.W
  5ca0: 4d 49 44 0a 80 5b 82 43 0a 55 48 43 30 08 5f 41  MID..[.C.UHC0._A
  5cb0: 44 52 0c 00 00 1d 00 5b 82 41 04 48 55 42 30 08  DR.....[.A.HUB0.
  5cc0: 5f 41 44 52 00 5b 82 0b 50 52 54 31 08 5f 41 44  _ADR.[..PRT1._AD
  5cd0: 52 01 5b 82 26 50 52 54 32 08 5f 41 44 52 0a 02  R.[.&PRT2._ADR..
  5ce0: 08 5f 45 4a 44 0d 5c 5f 53 42 2e 50 43 49 30 2e  ._EJD.\_SB.PCI0.
  5cf0: 45 58 50 31 2e 50 58 53 31 00 08 5f 50 52 57 12  EXP1.PXS1.._PRW.
  5d00: 06 02 0a 03 0a 03 5b 80 55 53 42 52 02 0a c4 01  ......[.USBR....
  5d10: 5b 81 0b 55 53 42 52 00 55 52 45 53 08 14 18 5f  [..USBR.URES..._
  5d20: 50 53 57 01 a0 09 68 70 0a 03 55 52 45 53 a1 07  PSW...hp..URES..
  5d30: 70 00 55 52 45 53 14 09 5f 53 33 44 00 a4 0a 02  p.URES.._S3D....
  5d40: 14 09 5f 53 34 44 00 a4 0a 02 5b 82 37 55 48 43  .._S4D....[.7UHC
  5d50: 31 08 5f 41 44 52 0c 01 00 1d 00 5b 82 26 48 55  1._ADR.....[.&HU
  5d60: 42 31 08 5f 41 44 52 00 5b 82 0b 50 52 54 31 08  B1._ADR.[..PRT1.
  5d70: 5f 41 44 52 01 5b 82 0c 50 52 54 32 08 5f 41 44  _ADR.[..PRT2._AD
  5d80: 52 0a 02 5b 82 37 55 48 43 32 08 5f 41 44 52 0c  R..[.7UHC2._ADR.
  5d90: 02 00 1d 00 5b 82 26 48 55 42 32 08 5f 41 44 52  ....[.&HUB2._ADR
  5da0: 00 5b 82 0b 50 52 54 31 08 5f 41 44 52 01 5b 82  .[..PRT1._ADR.[.
  5db0: 0c 50 52 54 32 08 5f 41 44 52 0a 02 5b 82 37 55  .PRT2._ADR..[.7U
  5dc0: 48 43 52 08 5f 41 44 52 0c 03 00 1d 00 5b 82 26  HCR._ADR.....[.&
  5dd0: 48 55 42 52 08 5f 41 44 52 00 5b 82 0b 50 52 54  HUBR._ADR.[..PRT
  5de0: 31 08 5f 41 44 52 01 5b 82 0c 50 52 54 32 08 5f  1._ADR.[..PRT2._
  5df0: 41 44 52 0a 02 5b 82 4d 0c 45 48 43 31 5b 80 55  ADR..[.M.EHC1[.U
  5e00: 37 43 53 02 0a 54 0a 04 5b 81 0d 55 37 43 53 03  7CS..T..[..U7CS.
  5e10: 00 0f 50 4d 45 53 01 08 5f 41 44 52 0c 07 00 1d  ..PMES.._ADR....
  5e20: 00 5b 82 45 09 48 55 42 37 08 5f 41 44 52 00 5b  .[.E.HUB7._ADR.[
  5e30: 82 0b 50 52 54 31 08 5f 41 44 52 01 5b 82 26 50  ..PRT1._ADR.[.&P
  5e40: 52 54 32 08 5f 41 44 52 0a 02 08 5f 45 4a 44 0d  RT2._ADR..._EJD.
  5e50: 5c 5f 53 42 2e 50 43 49 30 2e 45 58 50 31 2e 50  \_SB.PCI0.EXP1.P
  5e60: 58 53 31 00 5b 82 0c 50 52 54 33 08 5f 41 44 52  XS1.[..PRT3._ADR
  5e70: 0a 03 5b 82 0c 50 52 54 34 08 5f 41 44 52 0a 04  ..[..PRT4._ADR..
  5e80: 5b 82 0c 50 52 54 35 08 5f 41 44 52 0a 05 5b 82  [..PRT5._ADR..[.
  5e90: 0c 50 52 54 36 08 5f 41 44 52 0a 06 5b 82 0c 50  .PRT6._ADR..[..P
  5ea0: 52 54 37 08 5f 41 44 52 0a 07 5b 82 0c 50 52 54  RT7._ADR..[..PRT
  5eb0: 38 08 5f 41 44 52 0a 08 08 5f 50 52 57 12 06 02  8._ADR..._PRW...
  5ec0: 0a 0d 0a 03 5b 82 47 08 55 48 43 33 08 5f 41 44  ....[.G.UHC3._AD
  5ed0: 52 0c 00 00 1a 00 5b 82 26 48 55 42 33 08 5f 41  R.....[.&HUB3._A
  5ee0: 44 52 00 5b 82 0b 50 52 54 31 08 5f 41 44 52 01  DR.[..PRT1._ADR.
  5ef0: 5b 82 0c 50 52 54 32 08 5f 41 44 52 0a 02 08 5f  [..PRT2._ADR..._
  5f00: 50 52 57 12 06 02 0a 0e 0a 03 5b 80 55 53 42 52  PRW.......[.USBR
  5f10: 02 0a c4 01 5b 81 0b 55 53 42 52 00 55 52 45 53  ....[..USBR.URES
  5f20: 08 14 17 5f 50 53 57 01 a0 08 68 70 01 55 52 45  ..._PSW...hp.URE
  5f30: 53 a1 07 70 00 55 52 45 53 14 09 5f 53 33 44 00  S..p.URES.._S3D.
  5f40: a4 0a 02 14 09 5f 53 34 44 00 a4 0a 02 5b 82 37  ....._S4D....[.7
  5f50: 55 48 43 34 08 5f 41 44 52 0c 01 00 1a 00 5b 82  UHC4._ADR.....[.
  5f60: 26 48 55 42 34 08 5f 41 44 52 00 5b 82 0b 50 52  &HUB4._ADR.[..PR
  5f70: 54 31 08 5f 41 44 52 01 5b 82 0c 50 52 54 32 08  T1._ADR.[..PRT2.
  5f80: 5f 41 44 52 0a 02 5b 82 4c 07 45 48 43 32 08 5f  _ADR..[.L.EHC2._
  5f90: 41 44 52 0c 07 00 1a 00 5b 82 4e 05 48 55 42 38  ADR.....[.N.HUB8
  5fa0: 08 5f 41 44 52 00 5b 82 0b 50 52 54 31 08 5f 41  ._ADR.[..PRT1._A
  5fb0: 44 52 01 5b 82 15 50 52 54 32 08 5f 41 44 52 0a  DR.[..PRT2._ADR.
  5fc0: 02 14 08 5f 52 4d 56 00 a4 00 5b 82 15 50 52 54  ..._RMV...[..PRT
  5fd0: 33 08 5f 41 44 52 0a 03 14 08 5f 52 4d 56 00 a4  3._ADR...._RMV..
  5fe0: 00 5b 82 15 50 52 54 34 08 5f 41 44 52 0a 04 14  .[..PRT4._ADR...
  5ff0: 08 5f 52 4d 56 00 a4 00 08 5f 50 52 57 12 06 02  ._RMV...._PRW...
  6000: 0a 0d 0a 03 5b 82 44 16 45 58 50 31 08 5f 41 44  ....[.D.EXP1._AD
  6010: 52 0c 00 00 1c 00 5b 80 50 58 43 53 02 00 0a e0  R.....[.PXCS....
  6020: 5b 81 41 05 50 58 43 53 40 56 44 49 44 10 00 40  [.A.PXCS@VDID..@
  6030: 27 4c 50 57 52 02 00 0e 00 0d 4c 41 53 58 01 00  'LPWR.....LASX..
  6040: 32 41 42 50 58 01 00 02 50 44 43 58 01 00 02 50  2ABPX...PDCX...P
  6050: 44 53 58 01 00 01 4c 53 43 58 01 00 27 00 10 50  DSX...LSCX..'..P
  6060: 53 50 58 01 00 4f 3c 00 1e 48 50 53 58 01 50 4d  SPX..O<..HPSX.PM
  6070: 53 58 01 5b 82 41 06 50 58 53 31 08 5f 41 44 52  SX.[.A.PXS1._ADR
  6080: 00 5b 80 50 31 46 47 02 00 0a 08 5b 81 0b 50 31  .[.P1FG....[..P1
  6090: 46 47 03 50 31 49 44 20 14 08 5f 52 4d 56 00 a4  FG.P1ID .._RMV..
  60a0: 01 14 15 5f 53 54 41 00 a0 09 93 50 31 49 44 ff  ..._STA....P1ID.
  60b0: a4 00 a1 04 a4 0a 0f 08 5f 45 4a 44 0d 5c 5f 53  ........_EJD.\_S
  60c0: 42 2e 50 43 49 30 2e 45 48 43 31 2e 48 55 42 37  B.PCI0.EHC1.HUB7
  60d0: 2e 50 52 54 32 00 14 43 09 5f 50 52 54 00 a0 4b  .PRT2..C._PRT..K
  60e0: 05 93 47 50 49 43 00 a4 12 41 05 04 12 12 04 0b  ..GPIC...A......
  60f0: ff ff 00 5e 5e 2e 4c 50 43 5f 4c 4e 4b 41 00 12  ...^^.LPC_LNKA..
  6100: 12 04 0b ff ff 01 5e 5e 2e 4c 50 43 5f 4c 4e 4b  ......^^.LPC_LNK
  6110: 42 00 12 13 04 0b ff ff 0a 02 5e 5e 2e 4c 50 43  B.........^^.LPC
  6120: 5f 4c 4e 4b 43 00 12 13 04 0b ff ff 0a 03 5e 5e  _LNKC.........^^
  6130: 2e 4c 50 43 5f 4c 4e 4b 44 00 a1 2f a4 12 2c 04  .LPC_LNKD../..,.
  6140: 12 09 04 0b ff ff 00 00 0a 10 12 09 04 0b ff ff  ................
  6150: 01 00 0a 11 12 0a 04 0b ff ff 0a 02 00 0a 12 12  ................
  6160: 0a 04 0b ff ff 0a 03 00 0a 13 5b 82 4a 0f 45 58  ..........[.J.EX
  6170: 50 32 08 5f 41 44 52 0c 01 00 1c 00 14 43 09 5f  P2._ADR......C._
  6180: 50 52 54 00 a0 4b 05 93 47 50 49 43 00 a4 12 41  PRT..K..GPIC...A
  6190: 05 04 12 12 04 0b ff ff 00 5e 5e 2e 4c 50 43 5f  .........^^.LPC_
  61a0: 4c 4e 4b 42 00 12 12 04 0b ff ff 01 5e 5e 2e 4c  LNKB........^^.L
  61b0: 50 43 5f 4c 4e 4b 43 00 12 13 04 0b ff ff 0a 02  PC_LNKC.........
  61c0: 5e 5e 2e 4c 50 43 5f 4c 4e 4b 44 00 12 13 04 0b  ^^.LPC_LNKD.....
  61d0: ff ff 0a 03 5e 5e 2e 4c 50 43 5f 4c 4e 4b 41 00  ....^^.LPC_LNKA.
  61e0: a1 2f a4 12 2c 04 12 09 04 0b ff ff 00 00 0a 11  ./..,...........
  61f0: 12 09 04 0b ff ff 01 00 0a 12 12 0a 04 0b ff ff  ................
  6200: 0a 02 00 0a 13 12 0a 04 0b ff ff 0a 03 00 0a 10  ................
  6210: 5b 80 50 58 43 53 02 00 0a e0 5b 81 4a 04 50 58  [.PXCS....[.J.PX
  6220: 43 53 40 56 44 49 44 10 00 40 28 00 0d 4c 41 53  CS@VDID..@(..LAS
  6230: 58 01 00 32 41 42 50 58 01 00 02 50 44 43 58 01  X..2ABPX...PDCX.
  6240: 00 02 50 44 53 58 01 00 01 4c 53 43 58 01 00 27  ..PDSX...LSCX..'
  6250: 00 10 50 53 50 58 01 00 4f 3c 00 1e 48 50 53 58  ..PSPX..O<..HPSX
  6260: 01 50 4d 53 58 01 5b 82 46 10 45 58 50 33 08 5f  .PMSX.[.F.EXP3._
  6270: 41 44 52 0c 02 00 1c 00 08 5f 50 52 57 12 06 02  ADR......_PRW...
  6280: 0a 09 0a 04 14 43 09 5f 50 52 54 00 a0 4b 05 93  .....C._PRT..K..
  6290: 47 50 49 43 00 a4 12 41 05 04 12 12 04 0b ff ff  GPIC...A........
  62a0: 00 5e 5e 2e 4c 50 43 5f 4c 4e 4b 43 00 12 12 04  .^^.LPC_LNKC....
  62b0: 0b ff ff 01 5e 5e 2e 4c 50 43 5f 4c 4e 4b 44 00  ....^^.LPC_LNKD.
  62c0: 12 13 04 0b ff ff 0a 02 5e 5e 2e 4c 50 43 5f 4c  ........^^.LPC_L
  62d0: 4e 4b 41 00 12 13 04 0b ff ff 0a 03 5e 5e 2e 4c  NKA.........^^.L
  62e0: 50 43 5f 4c 4e 4b 42 00 a1 2f a4 12 2c 04 12 09  PC_LNKB../..,...
  62f0: 04 0b ff ff 00 00 0a 12 12 09 04 0b ff ff 01 00  ................
  6300: 0a 13 12 0a 04 0b ff ff 0a 02 00 0a 10 12 0a 04  ................
  6310: 0b ff ff 0a 03 00 0a 11 5b 80 50 58 43 53 02 00  ........[.PXCS..
  6320: 0a e0 5b 81 4a 04 50 58 43 53 40 56 44 49 44 10  ..[.J.PXCS@VDID.
  6330: 00 40 28 00 0d 4c 41 53 58 01 00 32 41 42 50 58  .@(..LASX..2ABPX
  6340: 01 00 02 50 44 43 58 01 00 02 50 44 53 58 01 00  ...PDCX...PDSX..
  6350: 01 4c 53 43 58 01 00 27 00 10 50 53 50 58 01 00  .LSCX..'..PSPX..
  6360: 4f 3c 00 1e 48 50 53 58 01 50 4d 53 58 01 5b 82  O<..HPSX.PMSX.[.
  6370: 4a 0f 45 58 50 34 08 5f 41 44 52 0c 03 00 1c 00  J.EXP4._ADR.....
  6380: 14 43 09 5f 50 52 54 00 a0 4b 05 93 47 50 49 43  .C._PRT..K..GPIC
  6390: 00 a4 12 41 05 04 12 12 04 0b ff ff 00 5e 5e 2e  ...A.........^^.
  63a0: 4c 50 43 5f 4c 4e 4b 44 00 12 12 04 0b ff ff 01  LPC_LNKD........
  63b0: 5e 5e 2e 4c 50 43 5f 4c 4e 4b 41 00 12 13 04 0b  ^^.LPC_LNKA.....
  63c0: ff ff 0a 02 5e 5e 2e 4c 50 43 5f 4c 4e 4b 42 00  ....^^.LPC_LNKB.
  63d0: 12 13 04 0b ff ff 0a 03 5e 5e 2e 4c 50 43 5f 4c  ........^^.LPC_L
  63e0: 4e 4b 43 00 a1 2f a4 12 2c 04 12 09 04 0b ff ff  NKC../..,.......
  63f0: 00 00 0a 13 12 09 04 0b ff ff 01 00 0a 10 12 0a  ................
  6400: 04 0b ff ff 0a 02 00 0a 11 12 0a 04 0b ff ff 0a  ................
  6410: 03 00 0a 12 5b 80 50 58 43 53 02 00 0a e0 5b 81  ....[.PXCS....[.
  6420: 4a 04 50 58 43 53 40 56 44 49 44 10 00 40 28 00  J.PXCS@VDID..@(.
  6430: 0d 4c 41 53 58 01 00 32 41 42 50 58 01 00 02 50  .LASX..2ABPX...P
  6440: 44 43 58 01 00 02 50 44 53 58 01 00 01 4c 53 43  DCX...PDSX...LSC
  6450: 58 01 00 27 00 10 50 53 50 58 01 00 4f 3c 00 1e  X..'..PSPX..O<..
  6460: 48 50 53 58 01 50 4d 53 58 01 5b 82 41 18 45 58  HPSX.PMSX.[.A.EX
  6470: 50 35 08 5f 41 44 52 0c 04 00 1c 00 14 43 09 5f  P5._ADR......C._
  6480: 50 52 54 00 a0 4b 05 93 47 50 49 43 00 a4 12 41  PRT..K..GPIC...A
  6490: 05 04 12 12 04 0b ff ff 00 5e 5e 2e 4c 50 43 5f  .........^^.LPC_
  64a0: 4c 4e 4b 41 00 12 12 04 0b ff ff 01 5e 5e 2e 4c  LNKA........^^.L
  64b0: 50 43 5f 4c 4e 4b 42 00 12 13 04 0b ff ff 0a 02  PC_LNKB.........
  64c0: 5e 5e 2e 4c 50 43 5f 4c 4e 4b 43 00 12 13 04 0b  ^^.LPC_LNKC.....
  64d0: ff ff 0a 03 5e 5e 2e 4c 50 43 5f 4c 4e 4b 44 00  ....^^.LPC_LNKD.
  64e0: a1 2f a4 12 2c 04 12 09 04 0b ff ff 00 00 0a 10  ./..,...........
  64f0: 12 09 04 0b ff ff 01 00 0a 11 12 0a 04 0b ff ff  ................
  6500: 0a 02 00 0a 12 12 0a 04 0b ff ff 0a 03 00 0a 13  ................
  6510: 5b 80 50 58 43 52 02 00 0a ff 5b 81 34 50 58 43  [.PXCR....[.4PXC
  6520: 52 40 00 40 2d 00 03 50 44 43 58 01 00 02 50 44  R@.@-..PDCX...PD
  6530: 53 58 01 00 02 00 47 3e 00 1e 48 50 45 4e 01 50  SX....G>..HPEN.P
  6540: 4d 45 4e 01 00 1e 48 50 53 58 01 50 4d 53 58 01  MEN...HPSX.PMSX.
  6550: 5b 82 44 06 4a 33 38 30 08 5f 41 44 52 00 5b 80  [.D.J380._ADR.[.
  6560: 50 43 46 47 02 00 0a ff 5b 81 35 50 43 46 47 01  PCFG....[.5PCFG.
  6570: 44 56 49 44 20 00 40 14 53 53 49 44 20 00 40 3e  DVID .@.SSID .@>
  6580: 00 06 44 33 45 46 01 00 01 00 28 4c 41 54 30 08  ..D3EF....(LAT0.
  6590: 00 40 0e 41 54 52 42 08 00 18 50 4d 43 30 08 14  .@.ATRB...PMC0..
  65a0: 16 5f 53 54 41 00 a0 0b 92 93 44 56 49 44 ff a4  ._STA.....DVID..
  65b0: 0a 0a a1 03 a4 00 5b 82 0b 4a 33 38 31 08 5f 41  ......[..J381._A
  65c0: 44 52 01 5b 82 0c 4a 33 38 32 08 5f 41 44 52 0a  DR.[..J382._ADR.
  65d0: 02 5b 82 0c 4a 33 38 33 08 5f 41 44 52 0a 03 5b  .[..J383._ADR..[
  65e0: 82 0c 4a 33 38 34 08 5f 41 44 52 0a 04 5b 82 44  ..J384._ADR..[.D
  65f0: 0a 45 58 50 36 08 5f 41 44 52 0c 05 00 1c 00 14  .EXP6._ADR......
  6600: 43 09 5f 50 52 54 00 a0 4b 05 93 47 50 49 43 00  C._PRT..K..GPIC.
  6610: a4 12 41 05 04 12 12 04 0b ff ff 00 5e 5e 2e 4c  ..A.........^^.L
  6620: 50 43 5f 4c 4e 4b 42 00 12 12 04 0b ff ff 01 5e  PC_LNKB........^
  6630: 5e 2e 4c 50 43 5f 4c 4e 4b 43 00 12 13 04 0b ff  ^.LPC_LNKC......
  6640: ff 0a 02 5e 5e 2e 4c 50 43 5f 4c 4e 4b 44 00 12  ...^^.LPC_LNKD..
  6650: 13 04 0b ff ff 0a 03 5e 5e 2e 4c 50 43 5f 4c 4e  .......^^.LPC_LN
  6660: 4b 41 00 a1 2f a4 12 2c 04 12 09 04 0b ff ff 00  KA../..,........
  6670: 00 0a 11 12 09 04 0b ff ff 01 00 0a 12 12 0a 04  ................
  6680: 0b ff ff 0a 02 00 0a 13 12 0a 04 0b ff ff 0a 03  ................
  6690: 00 0a 10 5b 82 8e 92 01 53 41 54 30 08 5f 41 44  ...[....SAT0._AD
  66a0: 52 0c 02 00 1f 00 5b 80 53 41 43 53 02 0a 40 0a  R.....[.SACS..@.
  66b0: c0 5b 81 47 06 53 41 43 53 03 50 52 49 54 10 53  .[.G.SACS.PRIT.S
  66c0: 45 43 54 10 50 53 49 54 04 53 53 49 54 04 00 18  ECT.PSIT.SSIT...
  66d0: 53 59 4e 43 04 00 0c 53 44 54 30 02 00 02 53 44  SYNC...SDT0...SD
  66e0: 54 31 02 00 02 53 44 54 32 02 00 02 53 44 54 33  T1...SDT2...SDT3
  66f0: 02 00 42 04 49 43 52 30 04 49 43 52 31 04 49 43  ..B.ICR0.ICR1.IC
  6700: 52 32 04 49 43 52 33 04 49 43 52 34 04 49 43 52  R2.ICR3.ICR4.ICR
  6710: 35 04 00 48 1c 4d 41 50 56 02 5b 82 45 61 50 52  5..H.MAPV.[.EaPR
  6720: 49 44 08 5f 41 44 52 00 14 40 14 5f 47 54 4d 00  ID._ADR..@._GTM.
  6730: a0 48 13 93 53 43 46 47 00 08 50 42 55 46 11 17  .H..SCFG..PBUF..
  6740: 0a 14 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  6750: 00 00 00 00 00 00 8a 50 42 55 46 00 50 49 4f 30  .......PBUF.PIO0
  6760: 8a 50 42 55 46 0a 04 44 4d 41 30 8a 50 42 55 46  .PBUF..DMA0.PBUF
  6770: 0a 08 50 49 4f 31 8a 50 42 55 46 0a 0c 44 4d 41  ..PIO1.PBUF..DMA
  6780: 31 8a 50 42 55 46 0a 10 46 4c 41 47 70 47 45 54  1.PBUF..FLAGpGET
  6790: 50 50 52 49 54 50 49 4f 30 70 47 44 4d 41 7b 53  PPRITPIO0pGDMA{S
  67a0: 59 4e 43 01 00 7b 49 43 52 33 01 00 7b 49 43 52  YNC..{ICR3..{ICR
  67b0: 30 01 00 53 44 54 30 7b 49 43 52 31 01 00 44 4d  0..SDT0{ICR1..DM
  67c0: 41 30 a0 10 93 44 4d 41 30 ff 70 50 49 4f 30 44  A0...DMA0.pPIO0D
  67d0: 4d 41 30 a0 2e 7b 50 52 49 54 0b 00 40 00 a0 14  MA0..{PRIT..@...
  67e0: 93 7b 50 52 49 54 0a 90 00 0a 80 70 0b 84 03 50  .{PRIT.....p...P
  67f0: 49 4f 31 a1 0e 70 47 45 54 54 50 53 49 54 50 49  IO1..pGETTPSITPI
  6800: 4f 31 a1 07 70 ff 50 49 4f 31 70 47 44 4d 41 7b  O1..p.PIO1pGDMA{
  6810: 53 59 4e 43 0a 02 00 7b 49 43 52 33 0a 02 00 7b  SYNC...{ICR3...{
  6820: 49 43 52 30 0a 02 00 53 44 54 31 7b 49 43 52 31  ICR0...SDT1{ICR1
  6830: 0a 02 00 44 4d 41 31 a0 10 93 44 4d 41 31 ff 70  ...DMA1...DMA1.p
  6840: 50 49 4f 31 44 4d 41 31 70 47 45 54 46 7b 53 59  PIO1DMA1pGETF{SY
  6850: 4e 43 01 00 7b 53 59 4e 43 0a 02 00 50 52 49 54  NC..{SYNC...PRIT
  6860: 46 4c 41 47 a4 50 42 55 46 14 44 2a 5f 53 54 4d  FLAG.PBUF.D*_STM
  6870: 03 a0 4c 29 93 53 43 46 47 00 8a 68 00 50 49 4f  ..L).SCFG..h.PIO
  6880: 30 8a 68 0a 04 44 4d 41 30 8a 68 0a 08 50 49 4f  0.h..DMA0.h..PIO
  6890: 31 8a 68 0a 0c 44 4d 41 31 8a 68 0a 10 46 4c 41  1.h..DMA1.h..FLA
  68a0: 47 a0 46 11 93 87 69 0b 00 02 7b 50 52 49 54 0b  G.F...i...{PRIT.
  68b0: f0 40 50 52 49 54 7b 53 59 4e 43 0a 0e 53 59 4e  .@PRIT{SYNC..SYN
  68c0: 43 70 00 53 44 54 30 7b 49 43 52 30 0a 0e 49 43  Cp.SDT0{ICR0..IC
  68d0: 52 30 7b 49 43 52 31 0a 0e 49 43 52 31 7b 49 43  R0{ICR1..ICR1{IC
  68e0: 52 33 0a 0e 49 43 52 33 7b 49 43 52 35 0a 0e 49  R3..ICR3{ICR5..I
  68f0: 43 52 35 8b 69 0a 62 57 34 39 30 8b 69 0a 6a 57  CR5.i.bW490.i.jW
  6900: 35 33 30 8b 69 0a 7e 57 36 33 30 8b 69 0a 80 57  530.i.~W630.i..W
  6910: 36 34 30 8b 69 0a b0 57 38 38 30 8b 69 0a ba 57  640.i..W880.i..W
  6920: 39 33 30 7d 50 52 49 54 0b 04 80 50 52 49 54 a0  930}PRIT...PRIT.
  6930: 1e 90 7b 46 4c 41 47 0a 02 00 7b 57 34 39 30 0b  ..{FLAG...{W490.
  6940: 00 08 00 7d 50 52 49 54 0a 02 50 52 49 54 7d 50  ...}PRIT..PRIT}P
  6950: 52 49 54 53 45 54 50 50 49 4f 30 57 35 33 30 57  RITSETPPIO0W530W
  6960: 36 34 30 50 52 49 54 a0 40 05 7b 46 4c 41 47 01  640PRIT.@.{FLAG.
  6970: 00 7d 53 59 4e 43 01 53 59 4e 43 70 53 44 4d 41  .}SYNC.SYNCpSDMA
  6980: 44 4d 41 30 53 44 54 30 a0 12 95 44 4d 41 30 0a  DMA0SDT0...DMA0.
  6990: 1e 7d 49 43 52 33 01 49 43 52 33 a0 12 95 44 4d  .}ICR3.ICR3...DM
  69a0: 41 30 0a 3c 7d 49 43 52 30 01 49 43 52 30 7d 49  A0.<}ICR0.ICR0}I
  69b0: 43 52 31 01 49 43 52 31 a0 45 15 93 87 6a 0b 00  CR1.ICR1.E...j..
  69c0: 02 7b 50 52 49 54 0b 0f 3f 50 52 49 54 70 00 50  .{PRIT..?PRITp.P
  69d0: 53 49 54 7b 53 59 4e 43 0a 0d 53 59 4e 43 70 00  SIT{SYNC..SYNCp.
  69e0: 53 44 54 31 7b 49 43 52 30 0a 0d 49 43 52 30 7b  SDT1{ICR0..ICR0{
  69f0: 49 43 52 31 0a 0d 49 43 52 31 7b 49 43 52 33 0a  ICR1..ICR1{ICR3.
  6a00: 0d 49 43 52 33 7b 49 43 52 35 0a 0d 49 43 52 35  .ICR3{ICR5..ICR5
  6a10: 8b 6a 0a 62 57 34 39 31 8b 6a 0a 6a 57 35 33 31  .j.bW491.j.jW531
  6a20: 8b 6a 0a 7e 57 36 33 31 8b 6a 0a 80 57 36 34 31  .j.~W631.j..W641
  6a30: 8b 6a 0a b0 57 38 38 31 8b 6a 0a ba 57 39 33 31  .j..W881.j..W931
  6a40: 7d 50 52 49 54 0b 40 80 50 52 49 54 a0 1e 90 7b  }PRIT.@.PRIT...{
  6a50: 46 4c 41 47 0a 08 00 7b 57 34 39 31 0b 00 08 00  FLAG...{W491....
  6a60: 7d 50 52 49 54 0a 20 50 52 49 54 a0 4c 04 7b 46  }PRIT. PRIT.L.{F
  6a70: 4c 41 47 0a 10 00 7d 50 52 49 54 0b 00 40 50 52  LAG...}PRIT..@PR
  6a80: 49 54 a0 13 94 50 49 4f 31 0a f0 7d 50 52 49 54  IT...PIO1..}PRIT
  6a90: 0a 80 50 52 49 54 a1 21 7d 50 52 49 54 0a 10 50  ..PRIT.!}PRIT..P
  6aa0: 52 49 54 70 53 45 54 54 50 49 4f 31 57 35 33 31  RITpSETTPIO1W531
  6ab0: 57 36 34 31 50 53 49 54 a0 45 05 7b 46 4c 41 47  W641PSIT.E.{FLAG
  6ac0: 0a 04 00 7d 53 59 4e 43 0a 02 53 59 4e 43 70 53  ...}SYNC..SYNCpS
  6ad0: 44 4d 41 44 4d 41 31 53 44 54 31 a0 13 95 44 4d  DMADMA1SDT1...DM
  6ae0: 41 31 0a 1e 7d 49 43 52 33 0a 02 49 43 52 33 a0  A1..}ICR3..ICR3.
  6af0: 13 95 44 4d 41 31 0a 3c 7d 49 43 52 30 0a 02 49  ..DMA1.<}ICR0..I
  6b00: 43 52 30 7d 49 43 52 31 0a 02 49 43 52 31 5b 82  CR0}ICR1..ICR1[.
  6b10: 40 11 50 5f 44 30 08 5f 41 44 52 00 14 43 10 5f  @.P_D0._ADR..C._
  6b20: 47 54 46 00 a0 4b 0f 93 53 43 46 47 00 08 50 49  GTF..K..SCFG..PI
  6b30: 42 30 11 11 0a 0e 03 00 00 00 00 a0 ef 03 00 00  B0..............
  6b40: 00 00 a0 ef 8c 50 49 42 30 01 50 4d 44 30 8c 50  .....PIB0.PMD0.P
  6b50: 49 42 30 0a 08 44 4d 44 30 a0 40 06 7b 50 52 49  IB0..DMD0.@.{PRI
  6b60: 54 0a 02 00 a0 13 93 7b 50 52 49 54 0a 09 00 0a  T......{PRIT....
  6b70: 08 70 0a 08 50 4d 44 30 a1 41 04 70 0a 0a 50 4d  .p..PMD0.A.p..PM
  6b80: 44 30 7a 7b 50 52 49 54 0b 00 03 00 0a 08 60 7a  D0z{PRIT......`z
  6b90: 7b 50 52 49 54 0b 00 30 00 0a 0c 61 72 60 61 62  {PRIT..0...ar`ab
  6ba0: a0 0c 93 0a 03 62 70 0a 0b 50 4d 44 30 a0 0c 93  .....bp..PMD0...
  6bb0: 0a 05 62 70 0a 0c 50 4d 44 30 a1 07 70 01 50 4d  ..bp..PMD0..p.PM
  6bc0: 44 30 a0 43 04 7b 53 59 4e 43 01 00 70 7d 53 44  D0.C.{SYNC..p}SD
  6bd0: 54 30 0a 40 00 44 4d 44 30 a0 2c 7b 49 43 52 31  T0.@.DMD0.,{ICR1
  6be0: 01 00 a0 13 7b 49 43 52 30 01 00 72 44 4d 44 30  ....{ICR0..rDMD0
  6bf0: 0a 02 44 4d 44 30 a0 0f 7b 49 43 52 33 01 00 70  ..DMD0..{ICR3..p
  6c00: 0a 45 44 4d 44 30 a1 14 7d 74 7b 50 4d 44 30 0a  .EDMD0..}t{PMD0.
  6c10: 07 00 0a 02 00 0a 20 44 4d 44 30 a4 50 49 42 30  ...... DMD0.PIB0
  6c20: 5b 82 4f 10 50 5f 44 31 08 5f 41 44 52 01 14 42  [.O.P_D1._ADR..B
  6c30: 10 5f 47 54 46 00 a0 4a 0f 93 53 43 46 47 00 08  ._GTF..J..SCFG..
  6c40: 50 49 42 31 11 11 0a 0e 03 00 00 00 00 b0 ef 03  PIB1............
  6c50: 00 00 00 00 b0 ef 8c 50 49 42 31 01 50 4d 44 31  .......PIB1.PMD1
  6c60: 8c 50 49 42 31 0a 08 44 4d 44 31 a0 4b 05 7b 50  .PIB1..DMD1.K.{P
  6c70: 52 49 54 0a 20 00 a0 13 93 7b 50 52 49 54 0a 90  RIT. ....{PRIT..
  6c80: 00 0a 80 70 0a 08 50 4d 44 31 a1 3c 72 7b 50 53  ...p..PMD1.<r{PS
  6c90: 49 54 0a 03 00 7a 7b 50 53 49 54 0a 0c 00 0a 02  IT...z{PSIT.....
  6ca0: 00 60 a0 0c 93 0a 05 60 70 0a 0c 50 4d 44 31 a1  .`.....`p..PMD1.
  6cb0: 17 a0 0c 93 0a 03 60 70 0a 0b 50 4d 44 31 a1 08  ......`p..PMD1..
  6cc0: 70 0a 0a 50 4d 44 31 a1 07 70 01 50 4d 44 31 a0  p..PMD1..p.PMD1.
  6cd0: 47 04 7b 53 59 4e 43 0a 02 00 70 7d 53 44 54 31  G.{SYNC...p}SDT1
  6ce0: 0a 40 00 44 4d 44 31 a0 2f 7b 49 43 52 31 0a 02  .@.DMD1./{ICR1..
  6cf0: 00 a0 14 7b 49 43 52 30 0a 02 00 72 44 4d 44 31  ...{ICR0...rDMD1
  6d00: 0a 02 44 4d 44 31 a0 10 7b 49 43 52 33 0a 02 00  ..DMD1..{ICR3...
  6d10: 70 0a 45 44 4d 44 31 a1 14 7d 74 7b 50 4d 44 31  p.EDMD1..}t{PMD1
  6d20: 0a 07 00 0a 02 00 0a 20 44 4d 44 31 a4 50 49 42  ....... DMD1.PIB
  6d30: 31 5b 82 42 62 53 45 43 44 08 5f 41 44 52 01 14  1[.BbSECD._ADR..
  6d40: 45 14 5f 47 54 4d 00 a0 4d 13 93 53 43 46 47 00  E._GTM..M..SCFG.
  6d50: 08 53 42 55 46 11 17 0a 14 00 00 00 00 00 00 00  .SBUF...........
  6d60: 00 00 00 00 00 00 00 00 00 00 00 00 00 8a 53 42  ..............SB
  6d70: 55 46 00 50 49 4f 30 8a 53 42 55 46 0a 04 44 4d  UF.PIO0.SBUF..DM
  6d80: 41 30 8a 53 42 55 46 0a 08 50 49 4f 31 8a 53 42  A0.SBUF..PIO1.SB
  6d90: 55 46 0a 0c 44 4d 41 31 8a 53 42 55 46 0a 10 46  UF..DMA1.SBUF..F
  6da0: 4c 41 47 70 47 45 54 50 53 45 43 54 50 49 4f 30  LAGpGETPSECTPIO0
  6db0: 70 47 44 4d 41 7b 53 59 4e 43 0a 04 00 7b 49 43  pGDMA{SYNC...{IC
  6dc0: 52 33 0a 04 00 7b 49 43 52 30 0a 04 00 53 44 54  R3...{ICR0...SDT
  6dd0: 32 7b 49 43 52 31 0a 04 00 44 4d 41 30 a0 10 93  2{ICR1...DMA0...
  6de0: 44 4d 41 30 ff 70 50 49 4f 30 44 4d 41 30 a0 2e  DMA0.pPIO0DMA0..
  6df0: 7b 53 45 43 54 0b 00 40 00 a0 14 93 7b 53 45 43  {SECT..@....{SEC
  6e00: 54 0a 90 00 0a 80 70 0b 84 03 50 49 4f 31 a1 0e  T.....p...PIO1..
  6e10: 70 47 45 54 54 53 53 49 54 50 49 4f 31 a1 07 70  pGETTSSITPIO1..p
  6e20: ff 50 49 4f 31 70 47 44 4d 41 7b 53 59 4e 43 0a  .PIO1pGDMA{SYNC.
  6e30: 08 00 7b 49 43 52 33 0a 08 00 7b 49 43 52 30 0a  ..{ICR3...{ICR0.
  6e40: 08 00 53 44 54 33 7b 49 43 52 31 0a 08 00 44 4d  ..SDT3{ICR1...DM
  6e50: 41 31 a0 10 93 44 4d 41 31 ff 70 50 49 4f 31 44  A1...DMA1.pPIO1D
  6e60: 4d 41 31 70 47 45 54 46 7b 53 59 4e 43 0a 04 00  MA1pGETF{SYNC...
  6e70: 7b 53 59 4e 43 0a 08 00 53 45 43 54 46 4c 41 47  {SYNC...SECTFLAG
  6e80: a4 53 42 55 46 14 48 2a 5f 53 54 4d 03 a0 40 2a  .SBUF.H*_STM..@*
  6e90: 93 53 43 46 47 00 8a 68 00 50 49 4f 30 8a 68 0a  .SCFG..h.PIO0.h.
  6ea0: 04 44 4d 41 30 8a 68 0a 08 50 49 4f 31 8a 68 0a  .DMA0.h..PIO1.h.
  6eb0: 0c 44 4d 41 31 8a 68 0a 10 46 4c 41 47 a0 4a 11  .DMA1.h..FLAG.J.
  6ec0: 93 87 69 0b 00 02 7b 53 45 43 54 0b f0 40 53 45  ..i...{SECT..@SE
  6ed0: 43 54 7b 53 59 4e 43 0a 0b 53 59 4e 43 70 00 53  CT{SYNC..SYNCp.S
  6ee0: 44 54 32 7b 49 43 52 30 0a 0b 49 43 52 30 7b 49  DT2{ICR0..ICR0{I
  6ef0: 43 52 31 0a 0b 49 43 52 31 7b 49 43 52 33 0a 0b  CR1..ICR1{ICR3..
  6f00: 49 43 52 33 7b 49 43 52 35 0a 0b 49 43 52 35 8b  ICR3{ICR5..ICR5.
  6f10: 69 0a 62 57 34 39 30 8b 69 0a 6a 57 35 33 30 8b  i.bW490.i.jW530.
  6f20: 69 0a 7e 57 36 33 30 8b 69 0a 80 57 36 34 30 8b  i.~W630.i..W640.
  6f30: 69 0a b0 57 38 38 30 8b 69 0a ba 57 39 33 30 7d  i..W880.i..W930}
  6f40: 53 45 43 54 0b 04 80 53 45 43 54 a0 1e 90 7b 46  SECT...SECT...{F
  6f50: 4c 41 47 0a 02 00 7b 57 34 39 30 0b 00 08 00 7d  LAG...{W490....}
  6f60: 53 45 43 54 0a 02 53 45 43 54 7d 53 45 43 54 53  SECT..SECT}SECTS
  6f70: 45 54 50 50 49 4f 30 57 35 33 30 57 36 34 30 53  ETPPIO0W530W640S
  6f80: 45 43 54 a0 44 05 7b 46 4c 41 47 01 00 7d 53 59  ECT.D.{FLAG..}SY
  6f90: 4e 43 0a 04 53 59 4e 43 70 53 44 4d 41 44 4d 41  NC..SYNCpSDMADMA
  6fa0: 30 53 44 54 32 a0 13 95 44 4d 41 30 0a 1e 7d 49  0SDT2...DMA0..}I
  6fb0: 43 52 33 0a 04 49 43 52 33 a0 13 95 44 4d 41 30  CR3..ICR3...DMA0
  6fc0: 0a 3c 7d 49 43 52 30 0a 04 49 43 52 30 7d 49 43  .<}ICR0..ICR0}IC
  6fd0: 52 31 0a 04 49 43 52 31 a0 45 15 93 87 6a 0b 00  R1..ICR1.E...j..
  6fe0: 02 7b 53 45 43 54 0b 0f 3f 53 45 43 54 70 00 53  .{SECT..?SECTp.S
  6ff0: 53 49 54 7b 53 59 4e 43 0a 07 53 59 4e 43 70 00  SIT{SYNC..SYNCp.
  7000: 53 44 54 33 7b 49 43 52 30 0a 07 49 43 52 30 7b  SDT3{ICR0..ICR0{
  7010: 49 43 52 31 0a 07 49 43 52 31 7b 49 43 52 33 0a  ICR1..ICR1{ICR3.
  7020: 07 49 43 52 33 7b 49 43 52 35 0a 07 49 43 52 35  .ICR3{ICR5..ICR5
  7030: 8b 6a 0a 62 57 34 39 31 8b 6a 0a 6a 57 35 33 31  .j.bW491.j.jW531
  7040: 8b 6a 0a 7e 57 36 33 31 8b 6a 0a 80 57 36 34 31  .j.~W631.j..W641
  7050: 8b 6a 0a b0 57 38 38 31 8b 6a 0a ba 57 39 33 31  .j..W881.j..W931
  7060: 7d 53 45 43 54 0b 40 80 53 45 43 54 a0 1e 90 7b  }SECT.@.SECT...{
  7070: 46 4c 41 47 0a 08 00 7b 57 34 39 31 0b 00 08 00  FLAG...{W491....
  7080: 7d 53 45 43 54 0a 20 53 45 43 54 a0 4c 04 7b 46  }SECT. SECT.L.{F
  7090: 4c 41 47 0a 10 00 7d 53 45 43 54 0b 00 40 53 45  LAG...}SECT..@SE
  70a0: 43 54 a0 13 94 50 49 4f 31 0a f0 7d 53 45 43 54  CT...PIO1..}SECT
  70b0: 0a 80 53 45 43 54 a1 21 7d 53 45 43 54 0a 10 53  ..SECT.!}SECT..S
  70c0: 45 43 54 70 53 45 54 54 50 49 4f 31 57 35 33 31  ECTpSETTPIO1W531
  70d0: 57 36 34 31 53 53 49 54 a0 45 05 7b 46 4c 41 47  W641SSIT.E.{FLAG
  70e0: 0a 04 00 7d 53 59 4e 43 0a 08 53 59 4e 43 70 53  ...}SYNC..SYNCpS
  70f0: 44 4d 41 44 4d 41 31 53 44 54 33 a0 13 95 44 4d  DMADMA1SDT3...DM
  7100: 41 31 0a 1e 7d 49 43 52 33 0a 08 49 43 52 33 a0  A1..}ICR3..ICR3.
  7110: 13 95 44 4d 41 31 0a 3c 7d 49 43 52 30 0a 08 49  ..DMA1.<}ICR0..I
  7120: 43 52 30 7d 49 43 52 31 0a 08 49 43 52 31 5b 82  CR0}ICR1..ICR1[.
  7130: 44 11 53 5f 44 30 08 5f 41 44 52 00 14 47 10 5f  D.S_D0._ADR..G._
  7140: 47 54 46 00 a0 4f 0f 93 53 43 46 47 00 08 53 49  GTF..O..SCFG..SI
  7150: 42 30 11 11 0a 0e 03 00 00 00 00 a0 ef 03 00 00  B0..............
  7160: 00 00 a0 ef 8c 53 49 42 30 01 50 4d 44 30 8c 53  .....SIB0.PMD0.S
  7170: 49 42 30 0a 08 44 4d 44 30 a0 40 06 7b 53 45 43  IB0..DMD0.@.{SEC
  7180: 54 0a 02 00 a0 13 93 7b 53 45 43 54 0a 09 00 0a  T......{SECT....
  7190: 08 70 0a 08 50 4d 44 30 a1 41 04 70 0a 0a 50 4d  .p..PMD0.A.p..PM
  71a0: 44 30 7a 7b 53 45 43 54 0b 00 03 00 0a 08 60 7a  D0z{SECT......`z
  71b0: 7b 53 45 43 54 0b 00 30 00 0a 0c 61 72 60 61 62  {SECT..0...ar`ab
  71c0: a0 0c 93 0a 03 62 70 0a 0b 50 4d 44 30 a0 0c 93  .....bp..PMD0...
  71d0: 0a 05 62 70 0a 0c 50 4d 44 30 a1 07 70 01 50 4d  ..bp..PMD0..p.PM
  71e0: 44 30 a0 47 04 7b 53 59 4e 43 0a 04 00 70 7d 53  D0.G.{SYNC...p}S
  71f0: 44 54 32 0a 40 00 44 4d 44 30 a0 2f 7b 49 43 52  DT2.@.DMD0./{ICR
  7200: 31 0a 04 00 a0 14 7b 49 43 52 30 0a 04 00 72 44  1.....{ICR0...rD
  7210: 4d 44 30 0a 02 44 4d 44 30 a0 10 7b 49 43 52 33  MD0..DMD0..{ICR3
  7220: 0a 04 00 70 0a 45 44 4d 44 30 a1 14 7d 74 7b 50  ...p.EDMD0..}t{P
  7230: 4d 44 30 0a 07 00 0a 02 00 0a 20 44 4d 44 30 a4  MD0....... DMD0.
  7240: 53 49 42 30 5b 82 4f 10 53 5f 44 31 08 5f 41 44  SIB0[.O.S_D1._AD
  7250: 52 01 14 42 10 5f 47 54 46 00 a0 4a 0f 93 53 43  R..B._GTF..J..SC
  7260: 46 47 00 08 53 49 42 31 11 11 0a 0e 03 00 00 00  FG..SIB1........
  7270: 00 b0 ef 03 00 00 00 00 b0 ef 8c 53 49 42 31 01  ...........SIB1.
  7280: 50 4d 44 31 8c 53 49 42 31 0a 08 44 4d 44 31 a0  PMD1.SIB1..DMD1.
  7290: 4b 05 7b 53 45 43 54 0a 20 00 a0 13 93 7b 53 45  K.{SECT. ....{SE
  72a0: 43 54 0a 90 00 0a 80 70 0a 08 50 4d 44 31 a1 3c  CT.....p..PMD1.<
  72b0: 72 7b 53 53 49 54 0a 03 00 7a 7b 53 53 49 54 0a  r{SSIT...z{SSIT.
  72c0: 0c 00 0a 02 00 60 a0 0c 93 0a 05 60 70 0a 0c 50  .....`.....`p..P
  72d0: 4d 44 31 a1 17 a0 0c 93 0a 03 60 70 0a 0b 50 4d  MD1.......`p..PM
  72e0: 44 31 a1 08 70 0a 0a 50 4d 44 31 a1 07 70 01 50  D1..p..PMD1..p.P
  72f0: 4d 44 31 a0 47 04 7b 53 59 4e 43 0a 08 00 70 7d  MD1.G.{SYNC...p}
  7300: 53 44 54 33 0a 40 00 44 4d 44 31 a0 2f 7b 49 43  SDT3.@.DMD1./{IC
  7310: 52 31 0a 08 00 a0 14 7b 49 43 52 30 0a 08 00 72  R1.....{ICR0...r
  7320: 44 4d 44 31 0a 02 44 4d 44 31 a0 10 7b 49 43 52  DMD1..DMD1..{ICR
  7330: 33 0a 08 00 70 0a 45 44 4d 44 31 a1 14 7d 74 7b  3...p.EDMD1..}t{
  7340: 50 4d 44 31 0a 07 00 0a 02 00 0a 20 44 4d 44 31  PMD1....... DMD1
  7350: a4 53 49 42 31 5b 82 45 63 50 54 34 44 08 5f 41  .SIB1[.EcPT4D._A
  7360: 44 52 0a 04 14 45 14 5f 47 54 4d 00 a0 4d 13 93  DR...E._GTM..M..
  7370: 53 43 46 47 00 08 53 42 55 46 11 17 0a 14 00 00  SCFG..SBUF......
  7380: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  7390: 00 00 8a 53 42 55 46 00 50 49 4f 30 8a 53 42 55  ...SBUF.PIO0.SBU
  73a0: 46 0a 04 44 4d 41 30 8a 53 42 55 46 0a 08 50 49  F..DMA0.SBUF..PI
  73b0: 4f 31 8a 53 42 55 46 0a 0c 44 4d 41 31 8a 53 42  O1.SBUF..DMA1.SB
  73c0: 55 46 0a 10 46 4c 41 47 70 47 45 54 50 53 45 43  UF..FLAGpGETPSEC
  73d0: 54 50 49 4f 30 70 47 44 4d 41 7b 53 59 4e 43 0a  TPIO0pGDMA{SYNC.
  73e0: 04 00 7b 49 43 52 33 0a 04 00 7b 49 43 52 30 0a  ..{ICR3...{ICR0.
  73f0: 04 00 53 44 54 32 7b 49 43 52 31 0a 04 00 44 4d  ..SDT2{ICR1...DM
  7400: 41 30 a0 10 93 44 4d 41 30 ff 70 50 49 4f 30 44  A0...DMA0.pPIO0D
  7410: 4d 41 30 a0 2e 7b 53 45 43 54 0b 00 40 00 a0 14  MA0..{SECT..@...
  7420: 93 7b 53 45 43 54 0a 90 00 0a 80 70 0b 84 03 50  .{SECT.....p...P
  7430: 49 4f 31 a1 0e 70 47 45 54 54 53 53 49 54 50 49  IO1..pGETTSSITPI
  7440: 4f 31 a1 07 70 ff 50 49 4f 31 70 47 44 4d 41 7b  O1..p.PIO1pGDMA{
  7450: 53 59 4e 43 0a 08 00 7b 49 43 52 33 0a 08 00 7b  SYNC...{ICR3...{
  7460: 49 43 52 30 0a 08 00 53 44 54 33 7b 49 43 52 31  ICR0...SDT3{ICR1
  7470: 0a 08 00 44 4d 41 31 a0 10 93 44 4d 41 31 ff 70  ...DMA1...DMA1.p
  7480: 50 49 4f 31 44 4d 41 31 70 47 45 54 46 7b 53 59  PIO1DMA1pGETF{SY
  7490: 4e 43 0a 04 00 7b 53 59 4e 43 0a 08 00 53 45 43  NC...{SYNC...SEC
  74a0: 54 46 4c 41 47 a4 53 42 55 46 14 48 2a 5f 53 54  TFLAG.SBUF.H*_ST
  74b0: 4d 03 a0 40 2a 93 53 43 46 47 00 8a 68 00 50 49  M..@*.SCFG..h.PI
  74c0: 4f 30 8a 68 0a 04 44 4d 41 30 8a 68 0a 08 50 49  O0.h..DMA0.h..PI
  74d0: 4f 31 8a 68 0a 0c 44 4d 41 31 8a 68 0a 10 46 4c  O1.h..DMA1.h..FL
  74e0: 41 47 a0 4a 11 93 87 69 0b 00 02 7b 53 45 43 54  AG.J...i...{SECT
  74f0: 0b f0 40 53 45 43 54 7b 53 59 4e 43 0a 0b 53 59  ..@SECT{SYNC..SY
  7500: 4e 43 70 00 53 44 54 32 7b 49 43 52 30 0a 0b 49  NCp.SDT2{ICR0..I
  7510: 43 52 30 7b 49 43 52 31 0a 0b 49 43 52 31 7b 49  CR0{ICR1..ICR1{I
  7520: 43 52 33 0a 0b 49 43 52 33 7b 49 43 52 35 0a 0b  CR3..ICR3{ICR5..
  7530: 49 43 52 35 8b 69 0a 62 57 34 39 30 8b 69 0a 6a  ICR5.i.bW490.i.j
  7540: 57 35 33 30 8b 69 0a 7e 57 36 33 30 8b 69 0a 80  W530.i.~W630.i..
  7550: 57 36 34 30 8b 69 0a b0 57 38 38 30 8b 69 0a ba  W640.i..W880.i..
  7560: 57 39 33 30 7d 53 45 43 54 0b 04 80 53 45 43 54  W930}SECT...SECT
  7570: a0 1e 90 7b 46 4c 41 47 0a 02 00 7b 57 34 39 30  ...{FLAG...{W490
  7580: 0b 00 08 00 7d 53 45 43 54 0a 02 53 45 43 54 7d  ....}SECT..SECT}
  7590: 53 45 43 54 53 45 54 50 50 49 4f 30 57 35 33 30  SECTSETPPIO0W530
  75a0: 57 36 34 30 53 45 43 54 a0 44 05 7b 46 4c 41 47  W640SECT.D.{FLAG
  75b0: 01 00 7d 53 59 4e 43 0a 04 53 59 4e 43 70 53 44  ..}SYNC..SYNCpSD
  75c0: 4d 41 44 4d 41 30 53 44 54 32 a0 13 95 44 4d 41  MADMA0SDT2...DMA
  75d0: 30 0a 1e 7d 49 43 52 33 0a 04 49 43 52 33 a0 13  0..}ICR3..ICR3..
  75e0: 95 44 4d 41 30 0a 3c 7d 49 43 52 30 0a 04 49 43  .DMA0.<}ICR0..IC
  75f0: 52 30 7d 49 43 52 31 0a 04 49 43 52 31 a0 45 15  R0}ICR1..ICR1.E.
  7600: 93 87 6a 0b 00 02 7b 53 45 43 54 0b 0f 3f 53 45  ..j...{SECT..?SE
  7610: 43 54 70 00 53 53 49 54 7b 53 59 4e 43 0a 07 53  CTp.SSIT{SYNC..S
  7620: 59 4e 43 70 00 53 44 54 33 7b 49 43 52 30 0a 07  YNCp.SDT3{ICR0..
  7630: 49 43 52 30 7b 49 43 52 31 0a 07 49 43 52 31 7b  ICR0{ICR1..ICR1{
  7640: 49 43 52 33 0a 07 49 43 52 33 7b 49 43 52 35 0a  ICR3..ICR3{ICR5.
  7650: 07 49 43 52 35 8b 6a 0a 62 57 34 39 31 8b 6a 0a  .ICR5.j.bW491.j.
  7660: 6a 57 35 33 31 8b 6a 0a 7e 57 36 33 31 8b 6a 0a  jW531.j.~W631.j.
  7670: 80 57 36 34 31 8b 6a 0a b0 57 38 38 31 8b 6a 0a  .W641.j..W881.j.
  7680: ba 57 39 33 31 7d 53 45 43 54 0b 40 80 53 45 43  .W931}SECT.@.SEC
  7690: 54 a0 1e 90 7b 46 4c 41 47 0a 08 00 7b 57 34 39  T...{FLAG...{W49
  76a0: 31 0b 00 08 00 7d 53 45 43 54 0a 20 53 45 43 54  1....}SECT. SECT
  76b0: a0 4c 04 7b 46 4c 41 47 0a 10 00 7d 53 45 43 54  .L.{FLAG...}SECT
  76c0: 0b 00 40 53 45 43 54 a0 13 94 50 49 4f 31 0a f0  ..@SECT...PIO1..
  76d0: 7d 53 45 43 54 0a 80 53 45 43 54 a1 21 7d 53 45  }SECT..SECT.!}SE
  76e0: 43 54 0a 10 53 45 43 54 70 53 45 54 54 50 49 4f  CT..SECTpSETTPIO
  76f0: 31 57 35 33 31 57 36 34 31 53 53 49 54 a0 45 05  1W531W641SSIT.E.
  7700: 7b 46 4c 41 47 0a 04 00 7d 53 59 4e 43 0a 08 53  {FLAG...}SYNC..S
  7710: 59 4e 43 70 53 44 4d 41 44 4d 41 31 53 44 54 33  YNCpSDMADMA1SDT3
  7720: a0 13 95 44 4d 41 31 0a 1e 7d 49 43 52 33 0a 08  ...DMA1..}ICR3..
  7730: 49 43 52 33 a0 13 95 44 4d 41 31 0a 3c 7d 49 43  ICR3...DMA1.<}IC
  7740: 52 30 0a 08 49 43 52 30 7d 49 43 52 31 0a 08 49  R0..ICR0}ICR1..I
  7750: 43 52 31 5b 82 4d 11 53 5f 44 30 08 5f 41 44 52  CR1[.M.S_D0._ADR
  7760: 00 14 08 5f 52 4d 56 00 a4 01 14 47 10 5f 47 54  ..._RMV....G._GT
  7770: 46 00 a0 4f 0f 93 53 43 46 47 00 08 53 49 42 30  F..O..SCFG..SIB0
  7780: 11 11 0a 0e 03 00 00 00 00 a0 ef 03 00 00 00 00  ................
  7790: a0 ef 8c 53 49 42 30 01 50 4d 44 30 8c 53 49 42  ...SIB0.PMD0.SIB
  77a0: 30 0a 08 44 4d 44 30 a0 40 06 7b 53 45 43 54 0a  0..DMD0.@.{SECT.
  77b0: 02 00 a0 13 93 7b 53 45 43 54 0a 09 00 0a 08 70  .....{SECT.....p
  77c0: 0a 08 50 4d 44 30 a1 41 04 70 0a 0a 50 4d 44 30  ..PMD0.A.p..PMD0
  77d0: 7a 7b 53 45 43 54 0b 00 03 00 0a 08 60 7a 7b 53  z{SECT......`z{S
  77e0: 45 43 54 0b 00 30 00 0a 0c 61 72 60 61 62 a0 0c  ECT..0...ar`ab..
  77f0: 93 0a 03 62 70 0a 0b 50 4d 44 30 a0 0c 93 0a 05  ...bp..PMD0.....
  7800: 62 70 0a 0c 50 4d 44 30 a1 07 70 01 50 4d 44 30  bp..PMD0..p.PMD0
  7810: a0 47 04 7b 53 59 4e 43 0a 04 00 70 7d 53 44 54  .G.{SYNC...p}SDT
  7820: 32 0a 40 00 44 4d 44 30 a0 2f 7b 49 43 52 31 0a  2.@.DMD0./{ICR1.
  7830: 04 00 a0 14 7b 49 43 52 30 0a 04 00 72 44 4d 44  ....{ICR0...rDMD
  7840: 30 0a 02 44 4d 44 30 a0 10 7b 49 43 52 33 0a 04  0..DMD0..{ICR3..
  7850: 00 70 0a 45 44 4d 44 30 a1 14 7d 74 7b 50 4d 44  .p.EDMD0..}t{PMD
  7860: 30 0a 07 00 0a 02 00 0a 20 44 4d 44 30 a4 53 49  0....... DMD0.SI
  7870: 42 30 5b 82 48 11 53 5f 44 31 08 5f 41 44 52 01  B0[.H.S_D1._ADR.
  7880: 14 08 5f 52 4d 56 00 a4 01 14 42 10 5f 47 54 46  .._RMV....B._GTF
  7890: 00 a0 4a 0f 93 53 43 46 47 00 08 53 49 42 31 11  ..J..SCFG..SIB1.
  78a0: 11 0a 0e 03 00 00 00 00 b0 ef 03 00 00 00 00 b0  ................
  78b0: ef 8c 53 49 42 31 01 50 4d 44 31 8c 53 49 42 31  ..SIB1.PMD1.SIB1
  78c0: 0a 08 44 4d 44 31 a0 4b 05 7b 53 45 43 54 0a 20  ..DMD1.K.{SECT. 
  78d0: 00 a0 13 93 7b 53 45 43 54 0a 90 00 0a 80 70 0a  ....{SECT.....p.
  78e0: 08 50 4d 44 31 a1 3c 72 7b 53 53 49 54 0a 03 00  .PMD1.<r{SSIT...
  78f0: 7a 7b 53 53 49 54 0a 0c 00 0a 02 00 60 a0 0c 93  z{SSIT......`...
  7900: 0a 05 60 70 0a 0c 50 4d 44 31 a1 17 a0 0c 93 0a  ..`p..PMD1......
  7910: 03 60 70 0a 0b 50 4d 44 31 a1 08 70 0a 0a 50 4d  .`p..PMD1..p..PM
  7920: 44 31 a1 07 70 01 50 4d 44 31 a0 47 04 7b 53 59  D1..p.PMD1.G.{SY
  7930: 4e 43 0a 08 00 70 7d 53 44 54 33 0a 40 00 44 4d  NC...p}SDT3.@.DM
  7940: 44 31 a0 2f 7b 49 43 52 31 0a 08 00 a0 14 7b 49  D1./{ICR1.....{I
  7950: 43 52 30 0a 08 00 72 44 4d 44 31 0a 02 44 4d 44  CR0...rDMD1..DMD
  7960: 31 a0 10 7b 49 43 52 33 0a 08 00 70 0a 45 44 4d  1..{ICR3...p.EDM
  7970: 44 31 a1 14 7d 74 7b 50 4d 44 31 0a 07 00 0a 02  D1..}t{PMD1.....
  7980: 00 0a 20 44 4d 44 31 a4 53 49 42 31 5b 82 45 63  .. DMD1.SIB1[.Ec
  7990: 50 54 35 44 08 5f 41 44 52 0a 05 14 45 14 5f 47  PT5D._ADR...E._G
  79a0: 54 4d 00 a0 4d 13 93 53 43 46 47 00 08 53 42 55  TM..M..SCFG..SBU
  79b0: 46 11 17 0a 14 00 00 00 00 00 00 00 00 00 00 00  F...............
  79c0: 00 00 00 00 00 00 00 00 00 8a 53 42 55 46 00 50  ..........SBUF.P
  79d0: 49 4f 30 8a 53 42 55 46 0a 04 44 4d 41 30 8a 53  IO0.SBUF..DMA0.S
  79e0: 42 55 46 0a 08 50 49 4f 31 8a 53 42 55 46 0a 0c  BUF..PIO1.SBUF..
  79f0: 44 4d 41 31 8a 53 42 55 46 0a 10 46 4c 41 47 70  DMA1.SBUF..FLAGp
  7a00: 47 45 54 50 53 45 43 54 50 49 4f 30 70 47 44 4d  GETPSECTPIO0pGDM
  7a10: 41 7b 53 59 4e 43 0a 04 00 7b 49 43 52 33 0a 04  A{SYNC...{ICR3..
  7a20: 00 7b 49 43 52 30 0a 04 00 53 44 54 32 7b 49 43  .{ICR0...SDT2{IC
  7a30: 52 31 0a 04 00 44 4d 41 30 a0 10 93 44 4d 41 30  R1...DMA0...DMA0
  7a40: ff 70 50 49 4f 30 44 4d 41 30 a0 2e 7b 53 45 43  .pPIO0DMA0..{SEC
  7a50: 54 0b 00 40 00 a0 14 93 7b 53 45 43 54 0a 90 00  T..@....{SECT...
  7a60: 0a 80 70 0b 84 03 50 49 4f 31 a1 0e 70 47 45 54  ..p...PIO1..pGET
  7a70: 54 53 53 49 54 50 49 4f 31 a1 07 70 ff 50 49 4f  TSSITPIO1..p.PIO
  7a80: 31 70 47 44 4d 41 7b 53 59 4e 43 0a 08 00 7b 49  1pGDMA{SYNC...{I
  7a90: 43 52 33 0a 08 00 7b 49 43 52 30 0a 08 00 53 44  CR3...{ICR0...SD
  7aa0: 54 33 7b 49 43 52 31 0a 08 00 44 4d 41 31 a0 10  T3{ICR1...DMA1..
  7ab0: 93 44 4d 41 31 ff 70 50 49 4f 31 44 4d 41 31 70  .DMA1.pPIO1DMA1p
  7ac0: 47 45 54 46 7b 53 59 4e 43 0a 04 00 7b 53 59 4e  GETF{SYNC...{SYN
  7ad0: 43 0a 08 00 53 45 43 54 46 4c 41 47 a4 53 42 55  C...SECTFLAG.SBU
  7ae0: 46 14 48 2a 5f 53 54 4d 03 a0 40 2a 93 53 43 46  F.H*_STM..@*.SCF
  7af0: 47 00 8a 68 00 50 49 4f 30 8a 68 0a 04 44 4d 41  G..h.PIO0.h..DMA
  7b00: 30 8a 68 0a 08 50 49 4f 31 8a 68 0a 0c 44 4d 41  0.h..PIO1.h..DMA
  7b10: 31 8a 68 0a 10 46 4c 41 47 a0 4a 11 93 87 69 0b  1.h..FLAG.J...i.
  7b20: 00 02 7b 53 45 43 54 0b f0 40 53 45 43 54 7b 53  ..{SECT..@SECT{S
  7b30: 59 4e 43 0a 0b 53 59 4e 43 70 00 53 44 54 32 7b  YNC..SYNCp.SDT2{
  7b40: 49 43 52 30 0a 0b 49 43 52 30 7b 49 43 52 31 0a  ICR0..ICR0{ICR1.
  7b50: 0b 49 43 52 31 7b 49 43 52 33 0a 0b 49 43 52 33  .ICR1{ICR3..ICR3
  7b60: 7b 49 43 52 35 0a 0b 49 43 52 35 8b 69 0a 62 57  {ICR5..ICR5.i.bW
  7b70: 34 39 30 8b 69 0a 6a 57 35 33 30 8b 69 0a 7e 57  490.i.jW530.i.~W
  7b80: 36 33 30 8b 69 0a 80 57 36 34 30 8b 69 0a b0 57  630.i..W640.i..W
  7b90: 38 38 30 8b 69 0a ba 57 39 33 30 7d 53 45 43 54  880.i..W930}SECT
  7ba0: 0b 04 80 53 45 43 54 a0 1e 90 7b 46 4c 41 47 0a  ...SECT...{FLAG.
  7bb0: 02 00 7b 57 34 39 30 0b 00 08 00 7d 53 45 43 54  ..{W490....}SECT
  7bc0: 0a 02 53 45 43 54 7d 53 45 43 54 53 45 54 50 50  ..SECT}SECTSETPP
  7bd0: 49 4f 30 57 35 33 30 57 36 34 30 53 45 43 54 a0  IO0W530W640SECT.
  7be0: 44 05 7b 46 4c 41 47 01 00 7d 53 59 4e 43 0a 04  D.{FLAG..}SYNC..
  7bf0: 53 59 4e 43 70 53 44 4d 41 44 4d 41 30 53 44 54  SYNCpSDMADMA0SDT
  7c00: 32 a0 13 95 44 4d 41 30 0a 1e 7d 49 43 52 33 0a  2...DMA0..}ICR3.
  7c10: 04 49 43 52 33 a0 13 95 44 4d 41 30 0a 3c 7d 49  .ICR3...DMA0.<}I
  7c20: 43 52 30 0a 04 49 43 52 30 7d 49 43 52 31 0a 04  CR0..ICR0}ICR1..
  7c30: 49 43 52 31 a0 45 15 93 87 6a 0b 00 02 7b 53 45  ICR1.E...j...{SE
  7c40: 43 54 0b 0f 3f 53 45 43 54 70 00 53 53 49 54 7b  CT..?SECTp.SSIT{
  7c50: 53 59 4e 43 0a 07 53 59 4e 43 70 00 53 44 54 33  SYNC..SYNCp.SDT3
  7c60: 7b 49 43 52 30 0a 07 49 43 52 30 7b 49 43 52 31  {ICR0..ICR0{ICR1
  7c70: 0a 07 49 43 52 31 7b 49 43 52 33 0a 07 49 43 52  ..ICR1{ICR3..ICR
  7c80: 33 7b 49 43 52 35 0a 07 49 43 52 35 8b 6a 0a 62  3{ICR5..ICR5.j.b
  7c90: 57 34 39 31 8b 6a 0a 6a 57 35 33 31 8b 6a 0a 7e  W491.j.jW531.j.~
  7ca0: 57 36 33 31 8b 6a 0a 80 57 36 34 31 8b 6a 0a b0  W631.j..W641.j..
  7cb0: 57 38 38 31 8b 6a 0a ba 57 39 33 31 7d 53 45 43  W881.j..W931}SEC
  7cc0: 54 0b 40 80 53 45 43 54 a0 1e 90 7b 46 4c 41 47  T.@.SECT...{FLAG
  7cd0: 0a 08 00 7b 57 34 39 31 0b 00 08 00 7d 53 45 43  ...{W491....}SEC
  7ce0: 54 0a 20 53 45 43 54 a0 4c 04 7b 46 4c 41 47 0a  T. SECT.L.{FLAG.
  7cf0: 10 00 7d 53 45 43 54 0b 00 40 53 45 43 54 a0 13  ..}SECT..@SECT..
  7d00: 94 50 49 4f 31 0a f0 7d 53 45 43 54 0a 80 53 45  .PIO1..}SECT..SE
  7d10: 43 54 a1 21 7d 53 45 43 54 0a 10 53 45 43 54 70  CT.!}SECT..SECTp
  7d20: 53 45 54 54 50 49 4f 31 57 35 33 31 57 36 34 31  SETTPIO1W531W641
  7d30: 53 53 49 54 a0 45 05 7b 46 4c 41 47 0a 04 00 7d  SSIT.E.{FLAG...}
  7d40: 53 59 4e 43 0a 08 53 59 4e 43 70 53 44 4d 41 44  SYNC..SYNCpSDMAD
  7d50: 4d 41 31 53 44 54 33 a0 13 95 44 4d 41 31 0a 1e  MA1SDT3...DMA1..
  7d60: 7d 49 43 52 33 0a 08 49 43 52 33 a0 13 95 44 4d  }ICR3..ICR3...DM
  7d70: 41 31 0a 3c 7d 49 43 52 30 0a 08 49 43 52 30 7d  A1.<}ICR0..ICR0}
  7d80: 49 43 52 31 0a 08 49 43 52 31 5b 82 4d 11 53 5f  ICR1..ICR1[.M.S_
  7d90: 44 30 08 5f 41 44 52 00 14 08 5f 52 4d 56 00 a4  D0._ADR..._RMV..
  7da0: 01 14 47 10 5f 47 54 46 00 a0 4f 0f 93 53 43 46  ..G._GTF..O..SCF
  7db0: 47 00 08 53 49 42 30 11 11 0a 0e 03 00 00 00 00  G..SIB0.........
  7dc0: a0 ef 03 00 00 00 00 a0 ef 8c 53 49 42 30 01 50  ..........SIB0.P
  7dd0: 4d 44 30 8c 53 49 42 30 0a 08 44 4d 44 30 a0 40  MD0.SIB0..DMD0.@
  7de0: 06 7b 53 45 43 54 0a 02 00 a0 13 93 7b 53 45 43  .{SECT......{SEC
  7df0: 54 0a 09 00 0a 08 70 0a 08 50 4d 44 30 a1 41 04  T.....p..PMD0.A.
  7e00: 70 0a 0a 50 4d 44 30 7a 7b 53 45 43 54 0b 00 03  p..PMD0z{SECT...
  7e10: 00 0a 08 60 7a 7b 53 45 43 54 0b 00 30 00 0a 0c  ...`z{SECT..0...
  7e20: 61 72 60 61 62 a0 0c 93 0a 03 62 70 0a 0b 50 4d  ar`ab.....bp..PM
  7e30: 44 30 a0 0c 93 0a 05 62 70 0a 0c 50 4d 44 30 a1  D0.....bp..PMD0.
  7e40: 07 70 01 50 4d 44 30 a0 47 04 7b 53 59 4e 43 0a  .p.PMD0.G.{SYNC.
  7e50: 04 00 70 7d 53 44 54 32 0a 40 00 44 4d 44 30 a0  ..p}SDT2.@.DMD0.
  7e60: 2f 7b 49 43 52 31 0a 04 00 a0 14 7b 49 43 52 30  /{ICR1.....{ICR0
  7e70: 0a 04 00 72 44 4d 44 30 0a 02 44 4d 44 30 a0 10  ...rDMD0..DMD0..
  7e80: 7b 49 43 52 33 0a 04 00 70 0a 45 44 4d 44 30 a1  {ICR3...p.EDMD0.
  7e90: 14 7d 74 7b 50 4d 44 30 0a 07 00 0a 02 00 0a 20  .}t{PMD0....... 
  7ea0: 44 4d 44 30 a4 53 49 42 30 5b 82 48 11 53 5f 44  DMD0.SIB0[.H.S_D
  7eb0: 31 08 5f 41 44 52 01 14 08 5f 52 4d 56 00 a4 01  1._ADR..._RMV...
  7ec0: 14 42 10 5f 47 54 46 00 a0 4a 0f 93 53 43 46 47  .B._GTF..J..SCFG
  7ed0: 00 08 53 49 42 31 11 11 0a 0e 03 00 00 00 00 b0  ..SIB1..........
  7ee0: ef 03 00 00 00 00 b0 ef 8c 53 49 42 31 01 50 4d  .........SIB1.PM
  7ef0: 44 31 8c 53 49 42 31 0a 08 44 4d 44 31 a0 4b 05  D1.SIB1..DMD1.K.
  7f00: 7b 53 45 43 54 0a 20 00 a0 13 93 7b 53 45 43 54  {SECT. ....{SECT
  7f10: 0a 90 00 0a 80 70 0a 08 50 4d 44 31 a1 3c 72 7b  .....p..PMD1.<r{
  7f20: 53 53 49 54 0a 03 00 7a 7b 53 53 49 54 0a 0c 00  SSIT...z{SSIT...
  7f30: 0a 02 00 60 a0 0c 93 0a 05 60 70 0a 0c 50 4d 44  ...`.....`p..PMD
  7f40: 31 a1 17 a0 0c 93 0a 03 60 70 0a 0b 50 4d 44 31  1.......`p..PMD1
  7f50: a1 08 70 0a 0a 50 4d 44 31 a1 07 70 01 50 4d 44  ..p..PMD1..p.PMD
  7f60: 31 a0 47 04 7b 53 59 4e 43 0a 08 00 70 7d 53 44  1.G.{SYNC...p}SD
  7f70: 54 33 0a 40 00 44 4d 44 31 a0 2f 7b 49 43 52 31  T3.@.DMD1./{ICR1
  7f80: 0a 08 00 a0 14 7b 49 43 52 30 0a 08 00 72 44 4d  .....{ICR0...rDM
  7f90: 44 31 0a 02 44 4d 44 31 a0 10 7b 49 43 52 33 0a  D1..DMD1..{ICR3.
  7fa0: 08 00 70 0a 45 44 4d 44 31 a1 14 7d 74 7b 50 4d  ..p.EDMD1..}t{PM
  7fb0: 44 31 0a 07 00 0a 02 00 0a 20 44 4d 44 31 a4 53  D1....... DMD1.S
  7fc0: 49 42 31 5b 82 8e 92 01 53 41 54 31 08 5f 41 44  IB1[....SAT1._AD
  7fd0: 52 0c 05 00 1f 00 5b 80 53 41 43 53 02 0a 40 0a  R.....[.SACS..@.
  7fe0: c0 5b 81 47 06 53 41 43 53 03 50 52 49 54 10 53  .[.G.SACS.PRIT.S
  7ff0: 45 43 54 10 50 53 49 54 04 53 53 49 54 04 00 18  ECT.PSIT.SSIT...
  8000: 53 59 4e 43 04 00 0c 53 44 54 30 02 00 02 53 44  SYNC...SDT0...SD
  8010: 54 31 02 00 02 53 44 54 32 02 00 02 53 44 54 33  T1...SDT2...SDT3
  8020: 02 00 42 04 49 43 52 30 04 49 43 52 31 04 49 43  ..B.ICR0.ICR1.IC
  8030: 52 32 04 49 43 52 33 04 49 43 52 34 04 49 43 52  R2.ICR3.ICR4.ICR
  8040: 35 04 00 48 1c 4d 41 50 56 02 5b 82 45 61 50 52  5..H.MAPV.[.EaPR
  8050: 49 44 08 5f 41 44 52 00 14 40 14 5f 47 54 4d 00  ID._ADR..@._GTM.
  8060: a0 48 13 93 53 43 46 47 00 08 50 42 55 46 11 17  .H..SCFG..PBUF..
  8070: 0a 14 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  8080: 00 00 00 00 00 00 8a 50 42 55 46 00 50 49 4f 30  .......PBUF.PIO0
  8090: 8a 50 42 55 46 0a 04 44 4d 41 30 8a 50 42 55 46  .PBUF..DMA0.PBUF
  80a0: 0a 08 50 49 4f 31 8a 50 42 55 46 0a 0c 44 4d 41  ..PIO1.PBUF..DMA
  80b0: 31 8a 50 42 55 46 0a 10 46 4c 41 47 70 47 45 54  1.PBUF..FLAGpGET
  80c0: 50 50 52 49 54 50 49 4f 30 70 47 44 4d 41 7b 53  PPRITPIO0pGDMA{S
  80d0: 59 4e 43 01 00 7b 49 43 52 33 01 00 7b 49 43 52  YNC..{ICR3..{ICR
  80e0: 30 01 00 53 44 54 30 7b 49 43 52 31 01 00 44 4d  0..SDT0{ICR1..DM
  80f0: 41 30 a0 10 93 44 4d 41 30 ff 70 50 49 4f 30 44  A0...DMA0.pPIO0D
  8100: 4d 41 30 a0 2e 7b 50 52 49 54 0b 00 40 00 a0 14  MA0..{PRIT..@...
  8110: 93 7b 50 52 49 54 0a 90 00 0a 80 70 0b 84 03 50  .{PRIT.....p...P
  8120: 49 4f 31 a1 0e 70 47 45 54 54 50 53 49 54 50 49  IO1..pGETTPSITPI
  8130: 4f 31 a1 07 70 ff 50 49 4f 31 70 47 44 4d 41 7b  O1..p.PIO1pGDMA{
  8140: 53 59 4e 43 0a 02 00 7b 49 43 52 33 0a 02 00 7b  SYNC...{ICR3...{
  8150: 49 43 52 30 0a 02 00 53 44 54 31 7b 49 43 52 31  ICR0...SDT1{ICR1
  8160: 0a 02 00 44 4d 41 31 a0 10 93 44 4d 41 31 ff 70  ...DMA1...DMA1.p
  8170: 50 49 4f 31 44 4d 41 31 70 47 45 54 46 7b 53 59  PIO1DMA1pGETF{SY
  8180: 4e 43 01 00 7b 53 59 4e 43 0a 02 00 50 52 49 54  NC..{SYNC...PRIT
  8190: 46 4c 41 47 a4 50 42 55 46 14 44 2a 5f 53 54 4d  FLAG.PBUF.D*_STM
  81a0: 03 a0 4c 29 93 53 43 46 47 00 8a 68 00 50 49 4f  ..L).SCFG..h.PIO
  81b0: 30 8a 68 0a 04 44 4d 41 30 8a 68 0a 08 50 49 4f  0.h..DMA0.h..PIO
  81c0: 31 8a 68 0a 0c 44 4d 41 31 8a 68 0a 10 46 4c 41  1.h..DMA1.h..FLA
  81d0: 47 a0 46 11 93 87 69 0b 00 02 7b 50 52 49 54 0b  G.F...i...{PRIT.
  81e0: f0 40 50 52 49 54 7b 53 59 4e 43 0a 0e 53 59 4e  .@PRIT{SYNC..SYN
  81f0: 43 70 00 53 44 54 30 7b 49 43 52 30 0a 0e 49 43  Cp.SDT0{ICR0..IC
  8200: 52 30 7b 49 43 52 31 0a 0e 49 43 52 31 7b 49 43  R0{ICR1..ICR1{IC
  8210: 52 33 0a 0e 49 43 52 33 7b 49 43 52 35 0a 0e 49  R3..ICR3{ICR5..I
  8220: 43 52 35 8b 69 0a 62 57 34 39 30 8b 69 0a 6a 57  CR5.i.bW490.i.jW
  8230: 35 33 30 8b 69 0a 7e 57 36 33 30 8b 69 0a 80 57  530.i.~W630.i..W
  8240: 36 34 30 8b 69 0a b0 57 38 38 30 8b 69 0a ba 57  640.i..W880.i..W
  8250: 39 33 30 7d 50 52 49 54 0b 04 80 50 52 49 54 a0  930}PRIT...PRIT.
  8260: 1e 90 7b 46 4c 41 47 0a 02 00 7b 57 34 39 30 0b  ..{FLAG...{W490.
  8270: 00 08 00 7d 50 52 49 54 0a 02 50 52 49 54 7d 50  ...}PRIT..PRIT}P
  8280: 52 49 54 53 45 54 50 50 49 4f 30 57 35 33 30 57  RITSETPPIO0W530W
  8290: 36 34 30 50 52 49 54 a0 40 05 7b 46 4c 41 47 01  640PRIT.@.{FLAG.
  82a0: 00 7d 53 59 4e 43 01 53 59 4e 43 70 53 44 4d 41  .}SYNC.SYNCpSDMA
  82b0: 44 4d 41 30 53 44 54 30 a0 12 95 44 4d 41 30 0a  DMA0SDT0...DMA0.
  82c0: 1e 7d 49 43 52 33 01 49 43 52 33 a0 12 95 44 4d  .}ICR3.ICR3...DM
  82d0: 41 30 0a 3c 7d 49 43 52 30 01 49 43 52 30 7d 49  A0.<}ICR0.ICR0}I
  82e0: 43 52 31 01 49 43 52 31 a0 45 15 93 87 6a 0b 00  CR1.ICR1.E...j..
  82f0: 02 7b 50 52 49 54 0b 0f 3f 50 52 49 54 70 00 50  .{PRIT..?PRITp.P
  8300: 53 49 54 7b 53 59 4e 43 0a 0d 53 59 4e 43 70 00  SIT{SYNC..SYNCp.
  8310: 53 44 54 31 7b 49 43 52 30 0a 0d 49 43 52 30 7b  SDT1{ICR0..ICR0{
  8320: 49 43 52 31 0a 0d 49 43 52 31 7b 49 43 52 33 0a  ICR1..ICR1{ICR3.
  8330: 0d 49 43 52 33 7b 49 43 52 35 0a 0d 49 43 52 35  .ICR3{ICR5..ICR5
  8340: 8b 6a 0a 62 57 34 39 31 8b 6a 0a 6a 57 35 33 31  .j.bW491.j.jW531
  8350: 8b 6a 0a 7e 57 36 33 31 8b 6a 0a 80 57 36 34 31  .j.~W631.j..W641
  8360: 8b 6a 0a b0 57 38 38 31 8b 6a 0a ba 57 39 33 31  .j..W881.j..W931
  8370: 7d 50 52 49 54 0b 40 80 50 52 49 54 a0 1e 90 7b  }PRIT.@.PRIT...{
  8380: 46 4c 41 47 0a 08 00 7b 57 34 39 31 0b 00 08 00  FLAG...{W491....
  8390: 7d 50 52 49 54 0a 20 50 52 49 54 a0 4c 04 7b 46  }PRIT. PRIT.L.{F
  83a0: 4c 41 47 0a 10 00 7d 50 52 49 54 0b 00 40 50 52  LAG...}PRIT..@PR
  83b0: 49 54 a0 13 94 50 49 4f 31 0a f0 7d 50 52 49 54  IT...PIO1..}PRIT
  83c0: 0a 80 50 52 49 54 a1 21 7d 50 52 49 54 0a 10 50  ..PRIT.!}PRIT..P
  83d0: 52 49 54 70 53 45 54 54 50 49 4f 31 57 35 33 31  RITpSETTPIO1W531
  83e0: 57 36 34 31 50 53 49 54 a0 45 05 7b 46 4c 41 47  W641PSIT.E.{FLAG
  83f0: 0a 04 00 7d 53 59 4e 43 0a 02 53 59 4e 43 70 53  ...}SYNC..SYNCpS
  8400: 44 4d 41 44 4d 41 31 53 44 54 31 a0 13 95 44 4d  DMADMA1SDT1...DM
  8410: 41 31 0a 1e 7d 49 43 52 33 0a 02 49 43 52 33 a0  A1..}ICR3..ICR3.
  8420: 13 95 44 4d 41 31 0a 3c 7d 49 43 52 30 0a 02 49  ..DMA1.<}ICR0..I
  8430: 43 52 30 7d 49 43 52 31 0a 02 49 43 52 31 5b 82  CR0}ICR1..ICR1[.
  8440: 40 11 50 5f 44 30 08 5f 41 44 52 00 14 43 10 5f  @.P_D0._ADR..C._
  8450: 47 54 46 00 a0 4b 0f 93 53 43 46 47 00 08 50 49  GTF..K..SCFG..PI
  8460: 42 30 11 11 0a 0e 03 00 00 00 00 a0 ef 03 00 00  B0..............
  8470: 00 00 a0 ef 8c 50 49 42 30 01 50 4d 44 30 8c 50  .....PIB0.PMD0.P
  8480: 49 42 30 0a 08 44 4d 44 30 a0 40 06 7b 50 52 49  IB0..DMD0.@.{PRI
  8490: 54 0a 02 00 a0 13 93 7b 50 52 49 54 0a 09 00 0a  T......{PRIT....
  84a0: 08 70 0a 08 50 4d 44 30 a1 41 04 70 0a 0a 50 4d  .p..PMD0.A.p..PM
  84b0: 44 30 7a 7b 50 52 49 54 0b 00 03 00 0a 08 60 7a  D0z{PRIT......`z
  84c0: 7b 50 52 49 54 0b 00 30 00 0a 0c 61 72 60 61 62  {PRIT..0...ar`ab
  84d0: a0 0c 93 0a 03 62 70 0a 0b 50 4d 44 30 a0 0c 93  .....bp..PMD0...
  84e0: 0a 05 62 70 0a 0c 50 4d 44 30 a1 07 70 01 50 4d  ..bp..PMD0..p.PM
  84f0: 44 30 a0 43 04 7b 53 59 4e 43 01 00 70 7d 53 44  D0.C.{SYNC..p}SD
  8500: 54 30 0a 40 00 44 4d 44 30 a0 2c 7b 49 43 52 31  T0.@.DMD0.,{ICR1
  8510: 01 00 a0 13 7b 49 43 52 30 01 00 72 44 4d 44 30  ....{ICR0..rDMD0
  8520: 0a 02 44 4d 44 30 a0 0f 7b 49 43 52 33 01 00 70  ..DMD0..{ICR3..p
  8530: 0a 45 44 4d 44 30 a1 14 7d 74 7b 50 4d 44 30 0a  .EDMD0..}t{PMD0.
  8540: 07 00 0a 02 00 0a 20 44 4d 44 30 a4 50 49 42 30  ...... DMD0.PIB0
  8550: 5b 82 4f 10 50 5f 44 31 08 5f 41 44 52 01 14 42  [.O.P_D1._ADR..B
  8560: 10 5f 47 54 46 00 a0 4a 0f 93 53 43 46 47 00 08  ._GTF..J..SCFG..
  8570: 50 49 42 31 11 11 0a 0e 03 00 00 00 00 b0 ef 03  PIB1............
  8580: 00 00 00 00 b0 ef 8c 50 49 42 31 01 50 4d 44 31  .......PIB1.PMD1
  8590: 8c 50 49 42 31 0a 08 44 4d 44 31 a0 4b 05 7b 50  .PIB1..DMD1.K.{P
  85a0: 52 49 54 0a 20 00 a0 13 93 7b 50 52 49 54 0a 90  RIT. ....{PRIT..
  85b0: 00 0a 80 70 0a 08 50 4d 44 31 a1 3c 72 7b 50 53  ...p..PMD1.<r{PS
  85c0: 49 54 0a 03 00 7a 7b 50 53 49 54 0a 0c 00 0a 02  IT...z{PSIT.....
  85d0: 00 60 a0 0c 93 0a 05 60 70 0a 0c 50 4d 44 31 a1  .`.....`p..PMD1.
  85e0: 17 a0 0c 93 0a 03 60 70 0a 0b 50 4d 44 31 a1 08  ......`p..PMD1..
  85f0: 70 0a 0a 50 4d 44 31 a1 07 70 01 50 4d 44 31 a0  p..PMD1..p.PMD1.
  8600: 47 04 7b 53 59 4e 43 0a 02 00 70 7d 53 44 54 31  G.{SYNC...p}SDT1
  8610: 0a 40 00 44 4d 44 31 a0 2f 7b 49 43 52 31 0a 02  .@.DMD1./{ICR1..
  8620: 00 a0 14 7b 49 43 52 30 0a 02 00 72 44 4d 44 31  ...{ICR0...rDMD1
  8630: 0a 02 44 4d 44 31 a0 10 7b 49 43 52 33 0a 02 00  ..DMD1..{ICR3...
  8640: 70 0a 45 44 4d 44 31 a1 14 7d 74 7b 50 4d 44 31  p.EDMD1..}t{PMD1
  8650: 0a 07 00 0a 02 00 0a 20 44 4d 44 31 a4 50 49 42  ....... DMD1.PIB
  8660: 31 5b 82 42 62 53 45 43 44 08 5f 41 44 52 01 14  1[.BbSECD._ADR..
  8670: 45 14 5f 47 54 4d 00 a0 4d 13 93 53 43 46 47 00  E._GTM..M..SCFG.
  8680: 08 53 42 55 46 11 17 0a 14 00 00 00 00 00 00 00  .SBUF...........
  8690: 00 00 00 00 00 00 00 00 00 00 00 00 00 8a 53 42  ..............SB
  86a0: 55 46 00 50 49 4f 30 8a 53 42 55 46 0a 04 44 4d  UF.PIO0.SBUF..DM
  86b0: 41 30 8a 53 42 55 46 0a 08 50 49 4f 31 8a 53 42  A0.SBUF..PIO1.SB
  86c0: 55 46 0a 0c 44 4d 41 31 8a 53 42 55 46 0a 10 46  UF..DMA1.SBUF..F
  86d0: 4c 41 47 70 47 45 54 50 53 45 43 54 50 49 4f 30  LAGpGETPSECTPIO0
  86e0: 70 47 44 4d 41 7b 53 59 4e 43 0a 04 00 7b 49 43  pGDMA{SYNC...{IC
  86f0: 52 33 0a 04 00 7b 49 43 52 30 0a 04 00 53 44 54  R3...{ICR0...SDT
  8700: 32 7b 49 43 52 31 0a 04 00 44 4d 41 30 a0 10 93  2{ICR1...DMA0...
  8710: 44 4d 41 30 ff 70 50 49 4f 30 44 4d 41 30 a0 2e  DMA0.pPIO0DMA0..
  8720: 7b 53 45 43 54 0b 00 40 00 a0 14 93 7b 53 45 43  {SECT..@....{SEC
  8730: 54 0a 90 00 0a 80 70 0b 84 03 50 49 4f 31 a1 0e  T.....p...PIO1..
  8740: 70 47 45 54 54 53 53 49 54 50 49 4f 31 a1 07 70  pGETTSSITPIO1..p
  8750: ff 50 49 4f 31 70 47 44 4d 41 7b 53 59 4e 43 0a  .PIO1pGDMA{SYNC.
  8760: 08 00 7b 49 43 52 33 0a 08 00 7b 49 43 52 30 0a  ..{ICR3...{ICR0.
  8770: 08 00 53 44 54 33 7b 49 43 52 31 0a 08 00 44 4d  ..SDT3{ICR1...DM
  8780: 41 31 a0 10 93 44 4d 41 31 ff 70 50 49 4f 31 44  A1...DMA1.pPIO1D
  8790: 4d 41 31 70 47 45 54 46 7b 53 59 4e 43 0a 04 00  MA1pGETF{SYNC...
  87a0: 7b 53 59 4e 43 0a 08 00 53 45 43 54 46 4c 41 47  {SYNC...SECTFLAG
  87b0: a4 53 42 55 46 14 48 2a 5f 53 54 4d 03 a0 40 2a  .SBUF.H*_STM..@*
  87c0: 93 53 43 46 47 00 8a 68 00 50 49 4f 30 8a 68 0a  .SCFG..h.PIO0.h.
  87d0: 04 44 4d 41 30 8a 68 0a 08 50 49 4f 31 8a 68 0a  .DMA0.h..PIO1.h.
  87e0: 0c 44 4d 41 31 8a 68 0a 10 46 4c 41 47 a0 4a 11  .DMA1.h..FLAG.J.
  87f0: 93 87 69 0b 00 02 7b 53 45 43 54 0b f0 40 53 45  ..i...{SECT..@SE
  8800: 43 54 7b 53 59 4e 43 0a 0b 53 59 4e 43 70 00 53  CT{SYNC..SYNCp.S
  8810: 44 54 32 7b 49 43 52 30 0a 0b 49 43 52 30 7b 49  DT2{ICR0..ICR0{I
  8820: 43 52 31 0a 0b 49 43 52 31 7b 49 43 52 33 0a 0b  CR1..ICR1{ICR3..
  8830: 49 43 52 33 7b 49 43 52 35 0a 0b 49 43 52 35 8b  ICR3{ICR5..ICR5.
  8840: 69 0a 62 57 34 39 30 8b 69 0a 6a 57 35 33 30 8b  i.bW490.i.jW530.
  8850: 69 0a 7e 57 36 33 30 8b 69 0a 80 57 36 34 30 8b  i.~W630.i..W640.
  8860: 69 0a b0 57 38 38 30 8b 69 0a ba 57 39 33 30 7d  i..W880.i..W930}
  8870: 53 45 43 54 0b 04 80 53 45 43 54 a0 1e 90 7b 46  SECT...SECT...{F
  8880: 4c 41 47 0a 02 00 7b 57 34 39 30 0b 00 08 00 7d  LAG...{W490....}
  8890: 53 45 43 54 0a 02 53 45 43 54 7d 53 45 43 54 53  SECT..SECT}SECTS
  88a0: 45 54 50 50 49 4f 30 57 35 33 30 57 36 34 30 53  ETPPIO0W530W640S
  88b0: 45 43 54 a0 44 05 7b 46 4c 41 47 01 00 7d 53 59  ECT.D.{FLAG..}SY
  88c0: 4e 43 0a 04 53 59 4e 43 70 53 44 4d 41 44 4d 41  NC..SYNCpSDMADMA
  88d0: 30 53 44 54 32 a0 13 95 44 4d 41 30 0a 1e 7d 49  0SDT2...DMA0..}I
  88e0: 43 52 33 0a 04 49 43 52 33 a0 13 95 44 4d 41 30  CR3..ICR3...DMA0
  88f0: 0a 3c 7d 49 43 52 30 0a 04 49 43 52 30 7d 49 43  .<}ICR0..ICR0}IC
  8900: 52 31 0a 04 49 43 52 31 a0 45 15 93 87 6a 0b 00  R1..ICR1.E...j..
  8910: 02 7b 53 45 43 54 0b 0f 3f 53 45 43 54 70 00 53  .{SECT..?SECTp.S
  8920: 53 49 54 7b 53 59 4e 43 0a 07 53 59 4e 43 70 00  SIT{SYNC..SYNCp.
  8930: 53 44 54 33 7b 49 43 52 30 0a 07 49 43 52 30 7b  SDT3{ICR0..ICR0{
  8940: 49 43 52 31 0a 07 49 43 52 31 7b 49 43 52 33 0a  ICR1..ICR1{ICR3.
  8950: 07 49 43 52 33 7b 49 43 52 35 0a 07 49 43 52 35  .ICR3{ICR5..ICR5
  8960: 8b 6a 0a 62 57 34 39 31 8b 6a 0a 6a 57 35 33 31  .j.bW491.j.jW531
  8970: 8b 6a 0a 7e 57 36 33 31 8b 6a 0a 80 57 36 34 31  .j.~W631.j..W641
  8980: 8b 6a 0a b0 57 38 38 31 8b 6a 0a ba 57 39 33 31  .j..W881.j..W931
  8990: 7d 53 45 43 54 0b 40 80 53 45 43 54 a0 1e 90 7b  }SECT.@.SECT...{
  89a0: 46 4c 41 47 0a 08 00 7b 57 34 39 31 0b 00 08 00  FLAG...{W491....
  89b0: 7d 53 45 43 54 0a 20 53 45 43 54 a0 4c 04 7b 46  }SECT. SECT.L.{F
  89c0: 4c 41 47 0a 10 00 7d 53 45 43 54 0b 00 40 53 45  LAG...}SECT..@SE
  89d0: 43 54 a0 13 94 50 49 4f 31 0a f0 7d 53 45 43 54  CT...PIO1..}SECT
  89e0: 0a 80 53 45 43 54 a1 21 7d 53 45 43 54 0a 10 53  ..SECT.!}SECT..S
  89f0: 45 43 54 70 53 45 54 54 50 49 4f 31 57 35 33 31  ECTpSETTPIO1W531
  8a00: 57 36 34 31 53 53 49 54 a0 45 05 7b 46 4c 41 47  W641SSIT.E.{FLAG
  8a10: 0a 04 00 7d 53 59 4e 43 0a 08 53 59 4e 43 70 53  ...}SYNC..SYNCpS
  8a20: 44 4d 41 44 4d 41 31 53 44 54 33 a0 13 95 44 4d  DMADMA1SDT3...DM
  8a30: 41 31 0a 1e 7d 49 43 52 33 0a 08 49 43 52 33 a0  A1..}ICR3..ICR3.
  8a40: 13 95 44 4d 41 31 0a 3c 7d 49 43 52 30 0a 08 49  ..DMA1.<}ICR0..I
  8a50: 43 52 30 7d 49 43 52 31 0a 08 49 43 52 31 5b 82  CR0}ICR1..ICR1[.
  8a60: 44 11 53 5f 44 30 08 5f 41 44 52 00 14 47 10 5f  D.S_D0._ADR..G._
  8a70: 47 54 46 00 a0 4f 0f 93 53 43 46 47 00 08 53 49  GTF..O..SCFG..SI
  8a80: 42 30 11 11 0a 0e 03 00 00 00 00 a0 ef 03 00 00  B0..............
  8a90: 00 00 a0 ef 8c 53 49 42 30 01 50 4d 44 30 8c 53  .....SIB0.PMD0.S
  8aa0: 49 42 30 0a 08 44 4d 44 30 a0 40 06 7b 53 45 43  IB0..DMD0.@.{SEC
  8ab0: 54 0a 02 00 a0 13 93 7b 53 45 43 54 0a 09 00 0a  T......{SECT....
  8ac0: 08 70 0a 08 50 4d 44 30 a1 41 04 70 0a 0a 50 4d  .p..PMD0.A.p..PM
  8ad0: 44 30 7a 7b 53 45 43 54 0b 00 03 00 0a 08 60 7a  D0z{SECT......`z
  8ae0: 7b 53 45 43 54 0b 00 30 00 0a 0c 61 72 60 61 62  {SECT..0...ar`ab
  8af0: a0 0c 93 0a 03 62 70 0a 0b 50 4d 44 30 a0 0c 93  .....bp..PMD0...
  8b00: 0a 05 62 70 0a 0c 50 4d 44 30 a1 07 70 01 50 4d  ..bp..PMD0..p.PM
  8b10: 44 30 a0 47 04 7b 53 59 4e 43 0a 04 00 70 7d 53  D0.G.{SYNC...p}S
  8b20: 44 54 32 0a 40 00 44 4d 44 30 a0 2f 7b 49 43 52  DT2.@.DMD0./{ICR
  8b30: 31 0a 04 00 a0 14 7b 49 43 52 30 0a 04 00 72 44  1.....{ICR0...rD
  8b40: 4d 44 30 0a 02 44 4d 44 30 a0 10 7b 49 43 52 33  MD0..DMD0..{ICR3
  8b50: 0a 04 00 70 0a 45 44 4d 44 30 a1 14 7d 74 7b 50  ...p.EDMD0..}t{P
  8b60: 4d 44 30 0a 07 00 0a 02 00 0a 20 44 4d 44 30 a4  MD0....... DMD0.
  8b70: 53 49 42 30 5b 82 4f 10 53 5f 44 31 08 5f 41 44  SIB0[.O.S_D1._AD
  8b80: 52 01 14 42 10 5f 47 54 46 00 a0 4a 0f 93 53 43  R..B._GTF..J..SC
  8b90: 46 47 00 08 53 49 42 31 11 11 0a 0e 03 00 00 00  FG..SIB1........
  8ba0: 00 b0 ef 03 00 00 00 00 b0 ef 8c 53 49 42 31 01  ...........SIB1.
  8bb0: 50 4d 44 31 8c 53 49 42 31 0a 08 44 4d 44 31 a0  PMD1.SIB1..DMD1.
  8bc0: 4b 05 7b 53 45 43 54 0a 20 00 a0 13 93 7b 53 45  K.{SECT. ....{SE
  8bd0: 43 54 0a 90 00 0a 80 70 0a 08 50 4d 44 31 a1 3c  CT.....p..PMD1.<
  8be0: 72 7b 53 53 49 54 0a 03 00 7a 7b 53 53 49 54 0a  r{SSIT...z{SSIT.
  8bf0: 0c 00 0a 02 00 60 a0 0c 93 0a 05 60 70 0a 0c 50  .....`.....`p..P
  8c00: 4d 44 31 a1 17 a0 0c 93 0a 03 60 70 0a 0b 50 4d  MD1.......`p..PM
  8c10: 44 31 a1 08 70 0a 0a 50 4d 44 31 a1 07 70 01 50  D1..p..PMD1..p.P
  8c20: 4d 44 31 a0 47 04 7b 53 59 4e 43 0a 08 00 70 7d  MD1.G.{SYNC...p}
  8c30: 53 44 54 33 0a 40 00 44 4d 44 31 a0 2f 7b 49 43  SDT3.@.DMD1./{IC
  8c40: 52 31 0a 08 00 a0 14 7b 49 43 52 30 0a 08 00 72  R1.....{ICR0...r
  8c50: 44 4d 44 31 0a 02 44 4d 44 31 a0 10 7b 49 43 52  DMD1..DMD1..{ICR
  8c60: 33 0a 08 00 70 0a 45 44 4d 44 31 a1 14 7d 74 7b  3...p.EDMD1..}t{
  8c70: 50 4d 44 31 0a 07 00 0a 02 00 0a 20 44 4d 44 31  PMD1....... DMD1
  8c80: a4 53 49 42 31 5b 82 45 63 50 54 34 44 08 5f 41  .SIB1[.EcPT4D._A
  8c90: 44 52 0a 04 14 45 14 5f 47 54 4d 00 a0 4d 13 93  DR...E._GTM..M..
  8ca0: 53 43 46 47 00 08 53 42 55 46 11 17 0a 14 00 00  SCFG..SBUF......
  8cb0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  8cc0: 00 00 8a 53 42 55 46 00 50 49 4f 30 8a 53 42 55  ...SBUF.PIO0.SBU
  8cd0: 46 0a 04 44 4d 41 30 8a 53 42 55 46 0a 08 50 49  F..DMA0.SBUF..PI
  8ce0: 4f 31 8a 53 42 55 46 0a 0c 44 4d 41 31 8a 53 42  O1.SBUF..DMA1.SB
  8cf0: 55 46 0a 10 46 4c 41 47 70 47 45 54 50 53 45 43  UF..FLAGpGETPSEC
  8d00: 54 50 49 4f 30 70 47 44 4d 41 7b 53 59 4e 43 0a  TPIO0pGDMA{SYNC.
  8d10: 04 00 7b 49 43 52 33 0a 04 00 7b 49 43 52 30 0a  ..{ICR3...{ICR0.
  8d20: 04 00 53 44 54 32 7b 49 43 52 31 0a 04 00 44 4d  ..SDT2{ICR1...DM
  8d30: 41 30 a0 10 93 44 4d 41 30 ff 70 50 49 4f 30 44  A0...DMA0.pPIO0D
  8d40: 4d 41 30 a0 2e 7b 53 45 43 54 0b 00 40 00 a0 14  MA0..{SECT..@...
  8d50: 93 7b 53 45 43 54 0a 90 00 0a 80 70 0b 84 03 50  .{SECT.....p...P
  8d60: 49 4f 31 a1 0e 70 47 45 54 54 53 53 49 54 50 49  IO1..pGETTSSITPI
  8d70: 4f 31 a1 07 70 ff 50 49 4f 31 70 47 44 4d 41 7b  O1..p.PIO1pGDMA{
  8d80: 53 59 4e 43 0a 08 00 7b 49 43 52 33 0a 08 00 7b  SYNC...{ICR3...{
  8d90: 49 43 52 30 0a 08 00 53 44 54 33 7b 49 43 52 31  ICR0...SDT3{ICR1
  8da0: 0a 08 00 44 4d 41 31 a0 10 93 44 4d 41 31 ff 70  ...DMA1...DMA1.p
  8db0: 50 49 4f 31 44 4d 41 31 70 47 45 54 46 7b 53 59  PIO1DMA1pGETF{SY
  8dc0: 4e 43 0a 04 00 7b 53 59 4e 43 0a 08 00 53 45 43  NC...{SYNC...SEC
  8dd0: 54 46 4c 41 47 a4 53 42 55 46 14 48 2a 5f 53 54  TFLAG.SBUF.H*_ST
  8de0: 4d 03 a0 40 2a 93 53 43 46 47 00 8a 68 00 50 49  M..@*.SCFG..h.PI
  8df0: 4f 30 8a 68 0a 04 44 4d 41 30 8a 68 0a 08 50 49  O0.h..DMA0.h..PI
  8e00: 4f 31 8a 68 0a 0c 44 4d 41 31 8a 68 0a 10 46 4c  O1.h..DMA1.h..FL
  8e10: 41 47 a0 4a 11 93 87 69 0b 00 02 7b 53 45 43 54  AG.J...i...{SECT
  8e20: 0b f0 40 53 45 43 54 7b 53 59 4e 43 0a 0b 53 59  ..@SECT{SYNC..SY
  8e30: 4e 43 70 00 53 44 54 32 7b 49 43 52 30 0a 0b 49  NCp.SDT2{ICR0..I
  8e40: 43 52 30 7b 49 43 52 31 0a 0b 49 43 52 31 7b 49  CR0{ICR1..ICR1{I
  8e50: 43 52 33 0a 0b 49 43 52 33 7b 49 43 52 35 0a 0b  CR3..ICR3{ICR5..
  8e60: 49 43 52 35 8b 69 0a 62 57 34 39 30 8b 69 0a 6a  ICR5.i.bW490.i.j
  8e70: 57 35 33 30 8b 69 0a 7e 57 36 33 30 8b 69 0a 80  W530.i.~W630.i..
  8e80: 57 36 34 30 8b 69 0a b0 57 38 38 30 8b 69 0a ba  W640.i..W880.i..
  8e90: 57 39 33 30 7d 53 45 43 54 0b 04 80 53 45 43 54  W930}SECT...SECT
  8ea0: a0 1e 90 7b 46 4c 41 47 0a 02 00 7b 57 34 39 30  ...{FLAG...{W490
  8eb0: 0b 00 08 00 7d 53 45 43 54 0a 02 53 45 43 54 7d  ....}SECT..SECT}
  8ec0: 53 45 43 54 53 45 54 50 50 49 4f 30 57 35 33 30  SECTSETPPIO0W530
  8ed0: 57 36 34 30 53 45 43 54 a0 44 05 7b 46 4c 41 47  W640SECT.D.{FLAG
  8ee0: 01 00 7d 53 59 4e 43 0a 04 53 59 4e 43 70 53 44  ..}SYNC..SYNCpSD
  8ef0: 4d 41 44 4d 41 30 53 44 54 32 a0 13 95 44 4d 41  MADMA0SDT2...DMA
  8f00: 30 0a 1e 7d 49 43 52 33 0a 04 49 43 52 33 a0 13  0..}ICR3..ICR3..
  8f10: 95 44 4d 41 30 0a 3c 7d 49 43 52 30 0a 04 49 43  .DMA0.<}ICR0..IC
  8f20: 52 30 7d 49 43 52 31 0a 04 49 43 52 31 a0 45 15  R0}ICR1..ICR1.E.
  8f30: 93 87 6a 0b 00 02 7b 53 45 43 54 0b 0f 3f 53 45  ..j...{SECT..?SE
  8f40: 43 54 70 00 53 53 49 54 7b 53 59 4e 43 0a 07 53  CTp.SSIT{SYNC..S
  8f50: 59 4e 43 70 00 53 44 54 33 7b 49 43 52 30 0a 07  YNCp.SDT3{ICR0..
  8f60: 49 43 52 30 7b 49 43 52 31 0a 07 49 43 52 31 7b  ICR0{ICR1..ICR1{
  8f70: 49 43 52 33 0a 07 49 43 52 33 7b 49 43 52 35 0a  ICR3..ICR3{ICR5.
  8f80: 07 49 43 52 35 8b 6a 0a 62 57 34 39 31 8b 6a 0a  .ICR5.j.bW491.j.
  8f90: 6a 57 35 33 31 8b 6a 0a 7e 57 36 33 31 8b 6a 0a  jW531.j.~W631.j.
  8fa0: 80 57 36 34 31 8b 6a 0a b0 57 38 38 31 8b 6a 0a  .W641.j..W881.j.
  8fb0: ba 57 39 33 31 7d 53 45 43 54 0b 40 80 53 45 43  .W931}SECT.@.SEC
  8fc0: 54 a0 1e 90 7b 46 4c 41 47 0a 08 00 7b 57 34 39  T...{FLAG...{W49
  8fd0: 31 0b 00 08 00 7d 53 45 43 54 0a 20 53 45 43 54  1....}SECT. SECT
  8fe0: a0 4c 04 7b 46 4c 41 47 0a 10 00 7d 53 45 43 54  .L.{FLAG...}SECT
  8ff0: 0b 00 40 53 45 43 54 a0 13 94 50 49 4f 31 0a f0  ..@SECT...PIO1..
  9000: 7d 53 45 43 54 0a 80 53 45 43 54 a1 21 7d 53 45  }SECT..SECT.!}SE
  9010: 43 54 0a 10 53 45 43 54 70 53 45 54 54 50 49 4f  CT..SECTpSETTPIO
  9020: 31 57 35 33 31 57 36 34 31 53 53 49 54 a0 45 05  1W531W641SSIT.E.
  9030: 7b 46 4c 41 47 0a 04 00 7d 53 59 4e 43 0a 08 53  {FLAG...}SYNC..S
  9040: 59 4e 43 70 53 44 4d 41 44 4d 41 31 53 44 54 33  YNCpSDMADMA1SDT3
  9050: a0 13 95 44 4d 41 31 0a 1e 7d 49 43 52 33 0a 08  ...DMA1..}ICR3..
  9060: 49 43 52 33 a0 13 95 44 4d 41 31 0a 3c 7d 49 43  ICR3...DMA1.<}IC
  9070: 52 30 0a 08 49 43 52 30 7d 49 43 52 31 0a 08 49  R0..ICR0}ICR1..I
  9080: 43 52 31 5b 82 4d 11 53 5f 44 30 08 5f 41 44 52  CR1[.M.S_D0._ADR
  9090: 00 14 08 5f 52 4d 56 00 a4 01 14 47 10 5f 47 54  ..._RMV....G._GT
  90a0: 46 00 a0 4f 0f 93 53 43 46 47 00 08 53 49 42 30  F..O..SCFG..SIB0
  90b0: 11 11 0a 0e 03 00 00 00 00 a0 ef 03 00 00 00 00  ................
  90c0: a0 ef 8c 53 49 42 30 01 50 4d 44 30 8c 53 49 42  ...SIB0.PMD0.SIB
  90d0: 30 0a 08 44 4d 44 30 a0 40 06 7b 53 45 43 54 0a  0..DMD0.@.{SECT.
  90e0: 02 00 a0 13 93 7b 53 45 43 54 0a 09 00 0a 08 70  .....{SECT.....p
  90f0: 0a 08 50 4d 44 30 a1 41 04 70 0a 0a 50 4d 44 30  ..PMD0.A.p..PMD0
  9100: 7a 7b 53 45 43 54 0b 00 03 00 0a 08 60 7a 7b 53  z{SECT......`z{S
  9110: 45 43 54 0b 00 30 00 0a 0c 61 72 60 61 62 a0 0c  ECT..0...ar`ab..
  9120: 93 0a 03 62 70 0a 0b 50 4d 44 30 a0 0c 93 0a 05  ...bp..PMD0.....
  9130: 62 70 0a 0c 50 4d 44 30 a1 07 70 01 50 4d 44 30  bp..PMD0..p.PMD0
  9140: a0 47 04 7b 53 59 4e 43 0a 04 00 70 7d 53 44 54  .G.{SYNC...p}SDT
  9150: 32 0a 40 00 44 4d 44 30 a0 2f 7b 49 43 52 31 0a  2.@.DMD0./{ICR1.
  9160: 04 00 a0 14 7b 49 43 52 30 0a 04 00 72 44 4d 44  ....{ICR0...rDMD
  9170: 30 0a 02 44 4d 44 30 a0 10 7b 49 43 52 33 0a 04  0..DMD0..{ICR3..
  9180: 00 70 0a 45 44 4d 44 30 a1 14 7d 74 7b 50 4d 44  .p.EDMD0..}t{PMD
  9190: 30 0a 07 00 0a 02 00 0a 20 44 4d 44 30 a4 53 49  0....... DMD0.SI
  91a0: 42 30 5b 82 48 11 53 5f 44 31 08 5f 41 44 52 01  B0[.H.S_D1._ADR.
  91b0: 14 08 5f 52 4d 56 00 a4 01 14 42 10 5f 47 54 46  .._RMV....B._GTF
  91c0: 00 a0 4a 0f 93 53 43 46 47 00 08 53 49 42 31 11  ..J..SCFG..SIB1.
  91d0: 11 0a 0e 03 00 00 00 00 b0 ef 03 00 00 00 00 b0  ................
  91e0: ef 8c 53 49 42 31 01 50 4d 44 31 8c 53 49 42 31  ..SIB1.PMD1.SIB1
  91f0: 0a 08 44 4d 44 31 a0 4b 05 7b 53 45 43 54 0a 20  ..DMD1.K.{SECT. 
  9200: 00 a0 13 93 7b 53 45 43 54 0a 90 00 0a 80 70 0a  ....{SECT.....p.
  9210: 08 50 4d 44 31 a1 3c 72 7b 53 53 49 54 0a 03 00  .PMD1.<r{SSIT...
  9220: 7a 7b 53 53 49 54 0a 0c 00 0a 02 00 60 a0 0c 93  z{SSIT......`...
  9230: 0a 05 60 70 0a 0c 50 4d 44 31 a1 17 a0 0c 93 0a  ..`p..PMD1......
  9240: 03 60 70 0a 0b 50 4d 44 31 a1 08 70 0a 0a 50 4d  .`p..PMD1..p..PM
  9250: 44 31 a1 07 70 01 50 4d 44 31 a0 47 04 7b 53 59  D1..p.PMD1.G.{SY
  9260: 4e 43 0a 08 00 70 7d 53 44 54 33 0a 40 00 44 4d  NC...p}SDT3.@.DM
  9270: 44 31 a0 2f 7b 49 43 52 31 0a 08 00 a0 14 7b 49  D1./{ICR1.....{I
  9280: 43 52 30 0a 08 00 72 44 4d 44 31 0a 02 44 4d 44  CR0...rDMD1..DMD
  9290: 31 a0 10 7b 49 43 52 33 0a 08 00 70 0a 45 44 4d  1..{ICR3...p.EDM
  92a0: 44 31 a1 14 7d 74 7b 50 4d 44 31 0a 07 00 0a 02  D1..}t{PMD1.....
  92b0: 00 0a 20 44 4d 44 31 a4 53 49 42 31 5b 82 45 63  .. DMD1.SIB1[.Ec
  92c0: 50 54 35 44 08 5f 41 44 52 0a 05 14 45 14 5f 47  PT5D._ADR...E._G
  92d0: 54 4d 00 a0 4d 13 93 53 43 46 47 00 08 53 42 55  TM..M..SCFG..SBU
  92e0: 46 11 17 0a 14 00 00 00 00 00 00 00 00 00 00 00  F...............
  92f0: 00 00 00 00 00 00 00 00 00 8a 53 42 55 46 00 50  ..........SBUF.P
  9300: 49 4f 30 8a 53 42 55 46 0a 04 44 4d 41 30 8a 53  IO0.SBUF..DMA0.S
  9310: 42 55 46 0a 08 50 49 4f 31 8a 53 42 55 46 0a 0c  BUF..PIO1.SBUF..
  9320: 44 4d 41 31 8a 53 42 55 46 0a 10 46 4c 41 47 70  DMA1.SBUF..FLAGp
  9330: 47 45 54 50 53 45 43 54 50 49 4f 30 70 47 44 4d  GETPSECTPIO0pGDM
  9340: 41 7b 53 59 4e 43 0a 04 00 7b 49 43 52 33 0a 04  A{SYNC...{ICR3..
  9350: 00 7b 49 43 52 30 0a 04 00 53 44 54 32 7b 49 43  .{ICR0...SDT2{IC
  9360: 52 31 0a 04 00 44 4d 41 30 a0 10 93 44 4d 41 30  R1...DMA0...DMA0
  9370: ff 70 50 49 4f 30 44 4d 41 30 a0 2e 7b 53 45 43  .pPIO0DMA0..{SEC
  9380: 54 0b 00 40 00 a0 14 93 7b 53 45 43 54 0a 90 00  T..@....{SECT...
  9390: 0a 80 70 0b 84 03 50 49 4f 31 a1 0e 70 47 45 54  ..p...PIO1..pGET
  93a0: 54 53 53 49 54 50 49 4f 31 a1 07 70 ff 50 49 4f  TSSITPIO1..p.PIO
  93b0: 31 70 47 44 4d 41 7b 53 59 4e 43 0a 08 00 7b 49  1pGDMA{SYNC...{I
  93c0: 43 52 33 0a 08 00 7b 49 43 52 30 0a 08 00 53 44  CR3...{ICR0...SD
  93d0: 54 33 7b 49 43 52 31 0a 08 00 44 4d 41 31 a0 10  T3{ICR1...DMA1..
  93e0: 93 44 4d 41 31 ff 70 50 49 4f 31 44 4d 41 31 70  .DMA1.pPIO1DMA1p
  93f0: 47 45 54 46 7b 53 59 4e 43 0a 04 00 7b 53 59 4e  GETF{SYNC...{SYN
  9400: 43 0a 08 00 53 45 43 54 46 4c 41 47 a4 53 42 55  C...SECTFLAG.SBU
  9410: 46 14 48 2a 5f 53 54 4d 03 a0 40 2a 93 53 43 46  F.H*_STM..@*.SCF
  9420: 47 00 8a 68 00 50 49 4f 30 8a 68 0a 04 44 4d 41  G..h.PIO0.h..DMA
  9430: 30 8a 68 0a 08 50 49 4f 31 8a 68 0a 0c 44 4d 41  0.h..PIO1.h..DMA
  9440: 31 8a 68 0a 10 46 4c 41 47 a0 4a 11 93 87 69 0b  1.h..FLAG.J...i.
  9450: 00 02 7b 53 45 43 54 0b f0 40 53 45 43 54 7b 53  ..{SECT..@SECT{S
  9460: 59 4e 43 0a 0b 53 59 4e 43 70 00 53 44 54 32 7b  YNC..SYNCp.SDT2{
  9470: 49 43 52 30 0a 0b 49 43 52 30 7b 49 43 52 31 0a  ICR0..ICR0{ICR1.
  9480: 0b 49 43 52 31 7b 49 43 52 33 0a 0b 49 43 52 33  .ICR1{ICR3..ICR3
  9490: 7b 49 43 52 35 0a 0b 49 43 52 35 8b 69 0a 62 57  {ICR5..ICR5.i.bW
  94a0: 34 39 30 8b 69 0a 6a 57 35 33 30 8b 69 0a 7e 57  490.i.jW530.i.~W
  94b0: 36 33 30 8b 69 0a 80 57 36 34 30 8b 69 0a b0 57  630.i..W640.i..W
  94c0: 38 38 30 8b 69 0a ba 57 39 33 30 7d 53 45 43 54  880.i..W930}SECT
  94d0: 0b 04 80 53 45 43 54 a0 1e 90 7b 46 4c 41 47 0a  ...SECT...{FLAG.
  94e0: 02 00 7b 57 34 39 30 0b 00 08 00 7d 53 45 43 54  ..{W490....}SECT
  94f0: 0a 02 53 45 43 54 7d 53 45 43 54 53 45 54 50 50  ..SECT}SECTSETPP
  9500: 49 4f 30 57 35 33 30 57 36 34 30 53 45 43 54 a0  IO0W530W640SECT.
  9510: 44 05 7b 46 4c 41 47 01 00 7d 53 59 4e 43 0a 04  D.{FLAG..}SYNC..
  9520: 53 59 4e 43 70 53 44 4d 41 44 4d 41 30 53 44 54  SYNCpSDMADMA0SDT
  9530: 32 a0 13 95 44 4d 41 30 0a 1e 7d 49 43 52 33 0a  2...DMA0..}ICR3.
  9540: 04 49 43 52 33 a0 13 95 44 4d 41 30 0a 3c 7d 49  .ICR3...DMA0.<}I
  9550: 43 52 30 0a 04 49 43 52 30 7d 49 43 52 31 0a 04  CR0..ICR0}ICR1..
  9560: 49 43 52 31 a0 45 15 93 87 6a 0b 00 02 7b 53 45  ICR1.E...j...{SE
  9570: 43 54 0b 0f 3f 53 45 43 54 70 00 53 53 49 54 7b  CT..?SECTp.SSIT{
  9580: 53 59 4e 43 0a 07 53 59 4e 43 70 00 53 44 54 33  SYNC..SYNCp.SDT3
  9590: 7b 49 43 52 30 0a 07 49 43 52 30 7b 49 43 52 31  {ICR0..ICR0{ICR1
  95a0: 0a 07 49 43 52 31 7b 49 43 52 33 0a 07 49 43 52  ..ICR1{ICR3..ICR
  95b0: 33 7b 49 43 52 35 0a 07 49 43 52 35 8b 6a 0a 62  3{ICR5..ICR5.j.b
  95c0: 57 34 39 31 8b 6a 0a 6a 57 35 33 31 8b 6a 0a 7e  W491.j.jW531.j.~
  95d0: 57 36 33 31 8b 6a 0a 80 57 36 34 31 8b 6a 0a b0  W631.j..W641.j..
  95e0: 57 38 38 31 8b 6a 0a ba 57 39 33 31 7d 53 45 43  W881.j..W931}SEC
  95f0: 54 0b 40 80 53 45 43 54 a0 1e 90 7b 46 4c 41 47  T.@.SECT...{FLAG
  9600: 0a 08 00 7b 57 34 39 31 0b 00 08 00 7d 53 45 43  ...{W491....}SEC
  9610: 54 0a 20 53 45 43 54 a0 4c 04 7b 46 4c 41 47 0a  T. SECT.L.{FLAG.
  9620: 10 00 7d 53 45 43 54 0b 00 40 53 45 43 54 a0 13  ..}SECT..@SECT..
  9630: 94 50 49 4f 31 0a f0 7d 53 45 43 54 0a 80 53 45  .PIO1..}SECT..SE
  9640: 43 54 a1 21 7d 53 45 43 54 0a 10 53 45 43 54 70  CT.!}SECT..SECTp
  9650: 53 45 54 54 50 49 4f 31 57 35 33 31 57 36 34 31  SETTPIO1W531W641
  9660: 53 53 49 54 a0 45 05 7b 46 4c 41 47 0a 04 00 7d  SSIT.E.{FLAG...}
  9670: 53 59 4e 43 0a 08 53 59 4e 43 70 53 44 4d 41 44  SYNC..SYNCpSDMAD
  9680: 4d 41 31 53 44 54 33 a0 13 95 44 4d 41 31 0a 1e  MA1SDT3...DMA1..
  9690: 7d 49 43 52 33 0a 08 49 43 52 33 a0 13 95 44 4d  }ICR3..ICR3...DM
  96a0: 41 31 0a 3c 7d 49 43 52 30 0a 08 49 43 52 30 7d  A1.<}ICR0..ICR0}
  96b0: 49 43 52 31 0a 08 49 43 52 31 5b 82 4d 11 53 5f  ICR1..ICR1[.M.S_
  96c0: 44 30 08 5f 41 44 52 00 14 08 5f 52 4d 56 00 a4  D0._ADR..._RMV..
  96d0: 01 14 47 10 5f 47 54 46 00 a0 4f 0f 93 53 43 46  ..G._GTF..O..SCF
  96e0: 47 00 08 53 49 42 30 11 11 0a 0e 03 00 00 00 00  G..SIB0.........
  96f0: a0 ef 03 00 00 00 00 a0 ef 8c 53 49 42 30 01 50  ..........SIB0.P
  9700: 4d 44 30 8c 53 49 42 30 0a 08 44 4d 44 30 a0 40  MD0.SIB0..DMD0.@
  9710: 06 7b 53 45 43 54 0a 02 00 a0 13 93 7b 53 45 43  .{SECT......{SEC
  9720: 54 0a 09 00 0a 08 70 0a 08 50 4d 44 30 a1 41 04  T.....p..PMD0.A.
  9730: 70 0a 0a 50 4d 44 30 7a 7b 53 45 43 54 0b 00 03  p..PMD0z{SECT...
  9740: 00 0a 08 60 7a 7b 53 45 43 54 0b 00 30 00 0a 0c  ...`z{SECT..0...
  9750: 61 72 60 61 62 a0 0c 93 0a 03 62 70 0a 0b 50 4d  ar`ab.....bp..PM
  9760: 44 30 a0 0c 93 0a 05 62 70 0a 0c 50 4d 44 30 a1  D0.....bp..PMD0.
  9770: 07 70 01 50 4d 44 30 a0 47 04 7b 53 59 4e 43 0a  .p.PMD0.G.{SYNC.
  9780: 04 00 70 7d 53 44 54 32 0a 40 00 44 4d 44 30 a0  ..p}SDT2.@.DMD0.
  9790: 2f 7b 49 43 52 31 0a 04 00 a0 14 7b 49 43 52 30  /{ICR1.....{ICR0
  97a0: 0a 04 00 72 44 4d 44 30 0a 02 44 4d 44 30 a0 10  ...rDMD0..DMD0..
  97b0: 7b 49 43 52 33 0a 04 00 70 0a 45 44 4d 44 30 a1  {ICR3...p.EDMD0.
  97c0: 14 7d 74 7b 50 4d 44 30 0a 07 00 0a 02 00 0a 20  .}t{PMD0....... 
  97d0: 44 4d 44 30 a4 53 49 42 30 5b 82 48 11 53 5f 44  DMD0.SIB0[.H.S_D
  97e0: 31 08 5f 41 44 52 01 14 08 5f 52 4d 56 00 a4 01  1._ADR..._RMV...
  97f0: 14 42 10 5f 47 54 46 00 a0 4a 0f 93 53 43 46 47  .B._GTF..J..SCFG
  9800: 00 08 53 49 42 31 11 11 0a 0e 03 00 00 00 00 b0  ..SIB1..........
  9810: ef 03 00 00 00 00 b0 ef 8c 53 49 42 31 01 50 4d  .........SIB1.PM
  9820: 44 31 8c 53 49 42 31 0a 08 44 4d 44 31 a0 4b 05  D1.SIB1..DMD1.K.
  9830: 7b 53 45 43 54 0a 20 00 a0 13 93 7b 53 45 43 54  {SECT. ....{SECT
  9840: 0a 90 00 0a 80 70 0a 08 50 4d 44 31 a1 3c 72 7b  .....p..PMD1.<r{
  9850: 53 53 49 54 0a 03 00 7a 7b 53 53 49 54 0a 0c 00  SSIT...z{SSIT...
  9860: 0a 02 00 60 a0 0c 93 0a 05 60 70 0a 0c 50 4d 44  ...`.....`p..PMD
  9870: 31 a1 17 a0 0c 93 0a 03 60 70 0a 0b 50 4d 44 31  1.......`p..PMD1
  9880: a1 08 70 0a 0a 50 4d 44 31 a1 07 70 01 50 4d 44  ..p..PMD1..p.PMD
  9890: 31 a0 47 04 7b 53 59 4e 43 0a 08 00 70 7d 53 44  1.G.{SYNC...p}SD
  98a0: 54 33 0a 40 00 44 4d 44 31 a0 2f 7b 49 43 52 31  T3.@.DMD1./{ICR1
  98b0: 0a 08 00 a0 14 7b 49 43 52 30 0a 08 00 72 44 4d  .....{ICR0...rDM
  98c0: 44 31 0a 02 44 4d 44 31 a0 10 7b 49 43 52 33 0a  D1..DMD1..{ICR3.
  98d0: 08 00 70 0a 45 44 4d 44 31 a1 14 7d 74 7b 50 4d  ..p.EDMD1..}t{PM
  98e0: 44 31 0a 07 00 0a 02 00 0a 20 44 4d 44 31 a4 53  D1....... DMD1.S
  98f0: 49 42 31 5b 82 4e 05 4d 49 52 5f 08 5f 48 49 44  IB1[.N.MIR_._HID
  9900: 0c 15 c5 01 00 14 15 5f 53 54 41 00 a0 0a 93 50  ......._STA....P
  9910: 4d 49 44 01 a4 0a 0f a1 03 a4 00 14 21 5f 43 52  MID.........!_CR
  9920: 53 00 08 42 55 46 30 11 10 0a 0d 47 01 2c ff 2c  S..BUF0....G.,.,
  9930: ff 01 04 22 10 00 79 00 a4 42 55 46 30 08 5f 50  ..."..y..BUF0._P
  9940: 52 53 11 10 0a 0d 47 01 2c ff 2c ff 01 04 22 10  RS....G.,.,...".
  9950: 00 79 00 5b 82 86 b3 01 57 4d 49 44 08 5f 48 49  .y.[....WMID._HI
  9960: 44 0d 50 4e 50 30 43 31 34 00 08 5f 55 49 44 00  D.PNP0C14.._UID.
  9970: 08 45 52 52 44 0c 00 00 01 00 08 42 55 46 46 11  .ERRD......BUFF.
  9980: 0b 0a 08 00 00 00 00 00 00 00 00 8c 42 55 46 46  ............BUFF
  9990: 00 42 46 30 30 8c 42 55 46 46 01 42 46 30 31 8c  .BF00.BUFF.BF01.
  99a0: 42 55 46 46 0a 02 42 46 30 32 8c 42 55 46 46 0a  BUFF..BF02.BUFF.
  99b0: 03 42 46 30 33 8c 42 55 46 46 0a 04 42 46 30 34  .BF03.BUFF..BF04
  99c0: 8c 42 55 46 46 0a 05 42 46 30 35 8c 42 55 46 46  .BUFF..BF05.BUFF
  99d0: 0a 06 42 46 30 36 8c 42 55 46 46 0a 07 42 46 30  ..BF06.BUFF..BF0
  99e0: 37 08 42 55 46 31 11 07 0a 04 00 00 00 00 08 41  7.BUF1.........A
  99f0: 41 44 53 11 04 0a 04 00 5b 13 41 41 44 53 00 0a  ADS.....[.AADS..
  9a00: 04 41 53 30 30 5b 13 41 41 44 53 0a 04 01 41 53  .AS00[.AADS...AS
  9a10: 30 31 5b 13 41 41 44 53 0a 05 01 41 53 30 32 5b  01[.AADS...AS02[
  9a20: 13 41 41 44 53 0a 06 01 41 53 30 33 5b 13 41 41  .AADS...AS03[.AA
  9a30: 44 53 0a 07 01 41 53 30 34 5b 13 41 41 44 53 0a  DS...AS04[.AADS.
  9a40: 10 0a 10 41 53 30 35 08 42 41 45 46 00 08 42 41  ...AS05.BAEF..BA
  9a50: 44 46 00 08 42 41 44 47 12 25 0f 00 00 00 00 00  DF..BADG.%......
  9a60: 00 00 0c 00 00 01 00 0c 00 00 01 00 0c 00 00 01  ................
  9a70: 00 0c 00 00 01 00 00 0c 00 00 01 00 00 00 08 57  ...............W
  9a80: 4c 44 53 00 08 57 4c 45 44 00 08 42 54 44 53 00  LDS..WLED..BTDS.
  9a90: 08 42 54 45 44 00 08 42 4c 44 53 00 08 42 4c 45  .BTED..BLDS..BLE
  9aa0: 44 00 08 4e 54 44 43 00 08 4e 54 44 56 00 08 57  D..NTDC..NTDV..W
  9ab0: 4c 53 44 0b 00 01 08 57 4c 53 45 0b 01 01 08 42  LSD....WLSE....B
  9ac0: 4c 54 44 0b 00 02 08 42 4c 54 45 0b 01 02 08 4c  LTD....BLTE....L
  9ad0: 42 4c 30 0b 00 03 08 4c 42 4c 31 0b 01 03 08 4c  BL0....LBL1....L
  9ae0: 42 4c 32 0b 02 03 08 4c 42 4c 33 0b 03 03 08 4c  BL2....LBL3....L
  9af0: 42 4c 34 0b 04 03 08 4c 42 4c 35 0b 05 03 08 4c  BL4....LBL5....L
  9b00: 42 4c 36 0b 06 03 08 4c 42 4c 37 0b 07 03 08 4c  BL6....LBL7....L
  9b10: 42 4c 38 0b 08 03 08 4c 42 4c 39 0b 09 03 08 4c  BL8....LBL9....L
  9b20: 42 4c 41 0b 0a 03 08 4c 42 4c 42 0b 0b 03 08 4c  BLA....LBLB....L
  9b30: 42 4c 43 0b 0c 03 08 4c 42 4c 44 0b 0d 03 08 4c  BLC....LBLD....L
  9b40: 42 4c 45 0b 0e 03 08 4c 42 4c 46 0b 0f 03 08 43  BLE....LBLF....C
  9b50: 41 44 49 0b 01 04 08 43 41 44 4f 0b 00 04 08 47  ADI....CADO....G
  9b60: 53 45 45 0b 01 05 08 47 53 45 44 0b 02 05 08 56  SEE....GSED....V
  9b70: 41 50 49 0b 01 06 08 56 41 50 4f 0b 00 06 08 57  API....VAPO....W
  9b80: 42 42 4f 0b 01 07 08 57 42 42 49 0b 00 07 08 47  BBO....WBBI....G
  9b90: 33 4d 44 0b 00 08 08 47 33 4d 45 0b 01 08 08 4c  3MD....G3ME....L
  9ba0: 41 4e 49 0b 00 09 08 4c 41 4e 4f 0b 01 09 08 4c  ANI....LANO....L
  9bb0: 44 4f 46 0b 00 0a 08 4c 44 4f 4e 0b 01 0a 08 42  DOF....LDON....B
  9bc0: 55 4f 46 0b 00 0b 08 42 55 4f 4e 0b 01 0b 08 46  UOF....BUON....F
  9bd0: 4e 4b 45 0c 02 00 01 00 08 46 4e 46 35 0c 01 50  NKE......FNF5..P
  9be0: 01 00 08 42 42 53 42 11 07 0a 04 00 00 00 00 5b  ...BBSB........[
  9bf0: 13 42 42 53 42 00 0a 10 42 42 44 30 5b 13 42 42  .BBSB...BBD0[.BB
  9c00: 53 42 0a 10 0a 10 42 42 44 31 08 54 4c 53 30 00  SB....BBD1.TLS0.
  9c10: 08 54 4c 53 31 01 08 54 4c 53 32 0a 02 08 54 4c  .TLS1..TLS2...TL
  9c20: 53 33 0a 03 08 54 4c 53 34 0a 04 08 54 4c 53 35  S3...TLS4...TLS5
  9c30: 0a 05 08 54 4c 53 36 0a 06 08 54 4c 53 37 0a 07  ...TLS6...TLS7..
  9c40: 08 42 43 44 53 12 44 04 0d 0c 00 00 01 00 0c 00  .BCDS.D.........
  9c50: 00 01 00 0c 00 00 01 00 0c 00 00 01 00 0c 00 00  ................
  9c60: 01 00 0c 00 00 01 00 0c 00 00 01 00 0c 00 00 01  ................
  9c70: 00 0c 00 00 01 00 0c 00 00 01 00 0c 00 00 01 00  ................
  9c80: 0c 00 00 01 00 0c 00 00 01 00 08 42 44 44 53 11  ...........BDDS.
  9c90: 07 0a 04 00 00 00 00 5b 13 42 44 44 53 00 0a 10  .......[.BDDS...
  9ca0: 42 44 44 30 5b 13 42 44 44 53 0a 10 0a 10 42 44  BDD0[.BDDS....BD
  9cb0: 44 31 08 44 53 59 30 11 2b 0a 28 00 00 00 00 00  D1.DSY0.+.(.....
  9cc0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  9cd0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  9ce0: 00 00 00 08 44 53 59 31 11 1b 0a 18 00 00 00 00  ....DSY1........
  9cf0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  9d00: 00 00 00 00 08 44 53 59 32 11 13 0a 10 00 00 00  .....DSY2.......
  9d10: 00 00 00 00 00 00 00 00 00 00 00 00 00 08 44 53  ..............DS
  9d20: 59 33 11 1b 0a 18 00 00 00 00 00 00 00 00 00 00  Y3..............
  9d30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 08 44  ...............D
  9d40: 53 59 34 11 13 0a 10 00 00 00 00 00 00 00 00 00  SY4.............
  9d50: 00 00 00 00 00 00 00 08 44 53 59 35 11 2b 0a 28  ........DSY5.+.(
  9d60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  9d70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  9d80: 00 00 00 00 00 00 00 00 5b 13 44 53 59 30 00 0a  ........[.DSY0..
  9d90: 40 44 59 30 30 5b 13 44 53 59 30 0a 40 0a 40 44  @DY00[.DSY0.@.@D
  9da0: 59 30 31 5b 13 44 53 59 30 0a 80 0a 40 44 59 30  Y01[.DSY0...@DY0
  9db0: 32 5b 13 44 53 59 30 0a c0 0a 40 44 59 30 33 5b  2[.DSY0...@DY03[
  9dc0: 13 44 53 59 30 0b 00 01 0a 40 44 59 30 34 5b 13  .DSY0....@DY04[.
  9dd0: 44 53 59 31 00 0a 40 44 59 31 30 5b 13 44 53 59  DSY1..@DY10[.DSY
  9de0: 31 0a 40 0a 40 44 59 31 31 5b 13 44 53 59 31 0a  1.@.@DY11[.DSY1.
  9df0: 80 0a 40 44 59 31 32 5b 13 44 53 59 32 00 0a 40  ..@DY12[.DSY2..@
  9e00: 44 59 32 30 5b 13 44 53 59 32 0a 40 0a 10 44 59  DY20[.DSY2.@..DY
  9e10: 32 31 5b 13 44 53 59 32 0a 50 0a 10 44 59 32 32  21[.DSY2.P..DY22
  9e20: 5b 13 44 53 59 30 00 0a c0 44 53 58 34 08 42 45  [.DSY0...DSX4.BE
  9e30: 44 53 12 15 13 00 00 00 00 00 00 00 00 00 00 00  DS..............
  9e40: 00 00 00 00 00 00 00 00 08 57 49 54 30 00 08 44  .........WIT0..D
  9e50: 53 59 36 11 17 0a 14 00 00 00 00 00 00 00 00 00  SY6.............
  9e60: 00 00 00 00 00 00 00 00 00 00 00 5b 13 44 53 59  ...........[.DSY
  9e70: 36 00 0a 20 44 59 36 30 5b 13 44 53 59 36 0a 20  6.. DY60[.DSY6. 
  9e80: 0a 20 44 59 36 31 5b 13 44 53 59 36 0a 40 0a 20  . DY61[.DSY6.@. 
  9e90: 44 59 36 32 5b 13 44 53 59 36 0a 60 0a 20 44 59  DY62[.DSY6.`. DY
  9ea0: 36 33 5b 13 44 53 59 36 0a 80 0a 20 44 59 36 34  63[.DSY6... DY64
  9eb0: 08 57 50 52 57 11 17 0a 14 00 00 00 00 00 00 00  .WPRW...........
  9ec0: 00 00 00 00 00 00 00 00 00 00 00 00 00 5b 13 57  .............[.W
  9ed0: 50 52 57 00 0a 08 57 57 44 30 5b 13 57 50 52 57  PRW...WWD0[.WPRW
  9ee0: 0a 08 0a 08 57 57 44 31 5b 13 57 50 52 57 0a 10  ....WWD1[.WPRW..
  9ef0: 0a 08 57 57 44 32 5b 13 57 50 52 57 0a 18 0a 08  ..WWD2[.WPRW....
  9f00: 57 57 44 33 5b 13 57 50 52 57 0a 20 0a 08 57 57  WWD3[.WPRW. ..WW
  9f10: 44 34 5b 13 57 50 52 57 0a 28 0a 20 57 57 44 35  D4[.WPRW.(. WWD5
  9f20: 08 57 50 43 49 11 07 0a 04 00 00 00 00 5b 13 57  .WPCI........[.W
  9f30: 50 43 49 00 0a 08 57 50 49 52 5b 13 57 50 43 49  PCI...WPIR[.WPCI
  9f40: 0a 08 0a 03 57 50 49 46 5b 13 57 50 43 49 0a 0b  ....WPIF[.WPCI..
  9f50: 0a 05 57 50 49 44 5b 13 57 50 43 49 0a 10 0a 08  ..WPID[.WPCI....
  9f60: 57 50 49 42 08 42 46 44 53 12 0a 04 0a 02 0a 02  WPIB.BFDS.......
  9f70: 0a 02 0a 02 08 47 53 54 53 00 08 42 46 45 46 00  .....GSTS..BFEF.
  9f80: 08 42 47 45 46 00 08 42 47 44 53 12 03 01 01 08  .BGEF..BGDS.....
  9f90: 42 4f 4f 54 11 17 0a 14 00 00 00 00 00 00 00 00  BOOT............
  9fa0: 00 00 00 00 00 00 00 00 00 00 00 00 5b 13 42 4f  ............[.BO
  9fb0: 4f 54 00 0a 80 42 4f 30 31 5b 13 42 4f 4f 54 0a  OT...BO01[.BOOT.
  9fc0: 80 0a 10 42 4f 30 32 5b 13 42 4f 4f 54 0a 90 0a  ...BO02[.BOOT...
  9fd0: 08 42 4f 30 33 5b 13 42 4f 4f 54 0a 98 0a 08 42  .BO03[.BOOT....B
  9fe0: 4f 30 34 14 49 05 41 41 46 31 00 70 5e 5e 2f 03  O04.I.AAF1.p^^/.
  9ff0: 4c 50 43 5f 45 43 30 5f 57 4c 45 58 41 53 30 30  LPC_EC0_WLEXAS00
  a000: 70 5e 5e 2f 03 4c 50 43 5f 45 43 30 5f 42 54 45  p^^/.LPC_EC0_BTE
  a010: 58 41 53 30 31 70 00 41 53 30 32 70 00 41 53 30  XAS01p.AS02p.AS0
  a020: 33 a0 0d 93 50 4d 49 44 01 70 00 41 53 30 34 a1  3...PMID.p.AS04.
  a030: 07 70 01 41 53 30 34 70 00 41 53 30 35 14 44 13  .p.AS04p.AS05.D.
  a040: 57 47 44 53 01 08 5f 54 5f 30 00 70 68 5f 54 5f  WGDS.._T_0.ph_T_
  a050: 30 a0 1f 93 5f 54 5f 30 01 70 5e 5e 2f 03 4c 50  0..._T_0.p^^/.LP
  a060: 43 5f 45 43 30 5f 57 4c 41 54 88 42 41 44 47 00  C_EC0_WLAT.BADG.
  a070: 00 a1 40 10 a0 20 93 5f 54 5f 30 0a 02 70 5e 5e  ..@.. ._T_0..p^^
  a080: 2f 03 4c 50 43 5f 45 43 30 5f 42 54 41 54 88 42  /.LPC_EC0_BTAT.B
  a090: 41 44 47 01 00 a1 4c 0d a0 21 93 5f 54 5f 30 0a  ADG...L..!._T_0.
  a0a0: 03 70 5e 5e 2f 03 4c 50 43 5f 45 43 30 5f 42 52  .p^^/.LPC_EC0_BR
  a0b0: 54 53 88 42 41 44 47 0a 02 00 a1 47 0b a0 12 93  TS.BADG....G....
  a0c0: 5f 54 5f 30 0a 08 70 01 88 42 41 44 47 0a 07 00  _T_0..p..BADG...
  a0d0: a1 41 0a a0 16 93 5f 54 5f 30 0a 09 70 0c 00 00  .A...._T_0..p...
  a0e0: 02 00 88 42 41 44 47 0a 08 00 a1 47 08 a0 16 93  ...BADG....G....
  a0f0: 5f 54 5f 30 0a 0a 70 0c 00 00 02 00 88 42 41 44  _T_0..p......BAD
  a100: 47 0a 09 00 a1 4d 06 a0 21 93 5f 54 5f 30 0a 0c  G....M..!._T_0..
  a110: 70 5e 5e 2f 03 4c 50 43 5f 45 43 30 5f 4c 41 4e  p^^/.LPC_EC0_LAN
  a120: 43 88 42 41 44 47 0a 0b 00 a1 48 04 a0 21 93 5f  C.BADG....H..!._
  a130: 54 5f 30 0a 0d 70 5e 5e 2f 03 4c 50 43 5f 45 43  T_0..p^^/.LPC_EC
  a140: 30 5f 4c 43 44 53 88 42 41 44 47 0a 0c 00 a1 23  0_LCDS.BADG....#
  a150: a0 21 93 5f 54 5f 30 0a 0e 70 5e 5e 2f 03 4c 50  .!._T_0..p^^/.LP
  a160: 43 5f 45 43 30 5f 42 42 45 54 88 42 41 44 47 0a  C_EC0_BBET.BADG.
  a170: 0d 00 14 40 19 57 53 44 53 02 70 69 42 55 46 46  ...@.WSDS.piBUFF
  a180: 70 68 60 70 42 46 30 30 61 70 00 88 42 41 44 47  ph`pBF00ap..BADG
  a190: 74 60 01 00 00 08 5f 54 5f 30 00 70 61 5f 54 5f  t`...._T_0.pa_T_
  a1a0: 30 a0 4d 0b 93 5f 54 5f 30 00 08 5f 54 5f 31 00  0.M.._T_0.._T_1.
  a1b0: 70 60 5f 54 5f 31 a0 1a 93 5f 54 5f 31 0a 04 70  p`_T_1..._T_1..p
  a1c0: 00 5e 5e 2f 03 4c 50 43 5f 45 43 30 5f 57 4c 41  .^^/.LPC_EC0_WLA
  a1d0: 54 a1 4d 08 a0 1a 93 5f 54 5f 31 0a 05 70 00 5e  T.M...._T_1..p.^
  a1e0: 5e 2f 03 4c 50 43 5f 45 43 30 5f 42 54 41 54 a1  ^/.LPC_EC0_BTAT.
  a1f0: 4f 06 a0 1a 93 5f 54 5f 31 0a 06 70 00 5e 5e 2f  O...._T_1..p.^^/
  a200: 03 4c 50 43 5f 45 43 30 5f 42 52 54 53 a1 41 05  .LPC_EC0_BRTS.A.
  a210: a0 0e 93 5f 54 5f 31 0a 07 70 00 42 41 45 46 a1  ..._T_1..p.BAEF.
  a220: 3f a0 10 93 5f 54 5f 31 0a 0b 70 0b 00 01 42 41  ?..._T_1..p...BA
  a230: 45 46 a1 2c a0 1a 93 5f 54 5f 31 0a 0f 70 00 5e  EF.,..._T_1..p.^
  a240: 5e 2f 03 4c 50 43 5f 45 43 30 5f 42 42 45 54 a1  ^/.LPC_EC0_BBET.
  a250: 0f 70 0b 00 01 88 42 41 44 47 74 60 01 00 00 a1  .p....BADGt`....
  a260: 43 0a 08 5f 54 5f 32 00 70 60 5f 54 5f 32 a0 1a  C.._T_2.p`_T_2..
  a270: 93 5f 54 5f 32 0a 04 70 01 5e 5e 2f 03 4c 50 43  ._T_2..p.^^/.LPC
  a280: 5f 45 43 30 5f 57 4c 41 54 a1 49 07 a0 1a 93 5f  _EC0_WLAT.I...._
  a290: 54 5f 32 0a 05 70 01 5e 5e 2f 03 4c 50 43 5f 45  T_2..p.^^/.LPC_E
  a2a0: 43 30 5f 42 54 41 54 a1 4b 05 a0 1a 93 5f 54 5f  C0_BTAT.K...._T_
  a2b0: 32 0a 06 70 61 5e 5e 2f 03 4c 50 43 5f 45 43 30  2..pa^^/.LPC_EC0
  a2c0: 5f 42 52 54 53 a1 3d a0 0e 93 5f 54 5f 32 0a 07  _BRTS.=..._T_2..
  a2d0: 70 01 42 41 45 46 a1 2c a0 1a 93 5f 54 5f 32 0a  p.BAEF.,..._T_2.
  a2e0: 0f 70 01 5e 5e 2f 03 4c 50 43 5f 45 43 30 5f 42  .p.^^/.LPC_EC0_B
  a2f0: 42 45 54 a1 0f 70 0b 00 01 88 42 41 44 47 74 60  BET..p....BADGt`
  a300: 01 00 00 14 47 04 4f 45 4d 4e 00 a0 1b 93 42 47  ....G.OEMN....BG
  a310: 45 46 01 70 4e 54 44 56 60 a0 0d 92 93 60 00 70  EF.pNTDV`....`.p
  a320: 00 4e 54 44 56 a4 60 a0 1b 93 42 41 45 46 01 70  .NTDV.`...BAEF.p
  a330: 4e 54 44 43 60 a0 0d 92 93 60 00 70 00 4e 54 44  NTDC`....`.p.NTD
  a340: 43 a4 60 a0 07 93 42 46 45 46 01 14 4a 08 53 54  C.`...BFEF..J.ST
  a350: 52 4c 02 70 68 60 70 69 42 55 46 46 70 00 42 42  RL.ph`piBUFFp.BB
  a360: 53 42 08 5f 54 5f 30 00 70 60 5f 54 5f 30 a0 39  SB._T_0.p`_T_0.9
  a370: 93 5f 54 5f 30 01 70 5e 5e 2f 03 4c 50 43 5f 45  ._T_0.p^^/.LPC_E
  a380: 43 30 5f 54 48 52 4f 00 61 a0 1e 7b 61 01 00 70  C0_THRO.a..{a..p
  a390: 5e 5e 2f 03 4c 50 43 5f 45 43 30 5f 54 48 52 4f  ^^/.LPC_EC0_THRO
  a3a0: 01 61 70 61 42 42 53 42 a1 2d a0 1f 93 5f 54 5f  .apaBBSB.-..._T_
  a3b0: 30 0a 02 70 42 46 30 30 61 5e 5e 2f 03 4c 50 43  0..pBF00a^^/.LPC
  a3c0: 5f 45 43 30 5f 43 4c 43 4b 61 a1 0b 70 0c 00 00  _EC0_CLCKa..p...
  a3d0: 01 00 42 42 53 42 14 46 0b 57 4f 44 50 02 08 5f  ..BBSB.F.WODP.._
  a3e0: 54 5f 30 00 70 68 5f 54 5f 30 a0 23 93 5f 54 5f  T_0.ph_T_0.#._T_
  a3f0: 30 0a 03 70 5e 5e 2f 03 4c 50 43 5f 45 43 30 5f  0..p^^/.LPC_EC0_
  a400: 4c 41 4e 43 88 42 43 44 53 74 68 01 00 00 a1 4e  LANC.BCDSth....N
  a410: 07 a0 2b 92 93 89 12 11 08 01 0a 02 0a 04 0a 05  ..+.............
  a420: 0a 06 0a 07 0a 08 0a 09 01 5f 54 5f 30 00 00 00  ........._T_0...
  a430: ff 70 01 88 42 43 44 53 74 68 01 00 00 a1 4f 04  .p..BCDSth....O.
  a440: a0 3e 93 5f 54 5f 30 0a 0c a0 14 69 70 01 5e 5e  .>._T_0....ip.^^
  a450: 2f 03 4c 50 43 5f 45 43 30 5f 4c 41 4e 43 a1 13  /.LPC_EC0_LANC..
  a460: 70 00 5e 5e 2f 03 4c 50 43 5f 45 43 30 5f 4c 41  p.^^/.LPC_EC0_LA
  a470: 4e 43 70 00 88 42 43 44 53 74 68 0a 0a 00 00 a1  NCp..BCDSth.....
  a480: 0d 70 01 88 42 43 44 53 74 68 01 00 00 14 45 04  .p..BCDSth....E.
  a490: 47 43 50 55 01 70 44 53 59 35 44 53 59 30 70 68  GCPU.pDSY5DSY0ph
  a4a0: 60 70 49 48 57 4d 00 68 62 70 62 44 53 59 36 70  `pIHWM.hbpbDSY6p
  a4b0: 44 59 36 30 44 59 30 30 70 44 59 36 31 44 59 30  DY60DY00pDY61DY0
  a4c0: 31 70 44 59 36 32 44 59 30 32 70 44 59 36 33 44  1pDY62DY02pDY63D
  a4d0: 59 30 33 14 45 04 4d 53 52 52 01 70 44 53 59 33  Y03.E.MSRR.pDSY3
  a4e0: 44 53 59 31 70 68 44 59 30 30 70 49 48 57 4d 01  DSY1phDY00pIHWM.
  a4f0: 68 62 70 62 44 53 59 36 70 44 59 36 30 44 59 31  hbpbDSY6pDY60DY1
  a500: 30 70 44 59 36 31 44 59 31 31 70 00 57 49 54 30  0pDY61DY11p.WIT0
  a510: 70 57 49 54 30 44 59 31 32 14 3f 4d 53 52 57 01  pWIT0DY12.?MSRW.
  a520: 70 44 53 59 33 44 53 59 31 70 49 48 57 4d 0a 02  pDSY3DSY1pIHWM..
  a530: 68 62 70 62 44 53 59 36 70 44 59 36 30 44 59 31  hbpbDSY6pDY60DY1
  a540: 30 70 44 59 36 31 44 59 31 31 70 00 57 49 54 30  0pDY61DY11p.WIT0
  a550: 70 57 49 54 30 44 59 31 32 14 40 07 43 34 43 33  pWIT0DY12.@.C4C3
  a560: 02 70 69 42 55 46 46 70 42 46 30 30 61 a0 46 04  .piBUFFpBF00a.F.
  a570: 93 68 0a 04 47 43 50 55 0a 05 70 44 59 30 30 42  .h..GCPU..pDY00B
  a580: 55 46 46 a0 20 7b 42 46 30 32 0a 03 00 70 61 5e  UFF. {BF02...pa^
  a590: 5e 2e 4c 50 43 5f 43 34 4f 33 70 61 88 42 43 44  ^.LPC_C4O3pa.BCD
  a5a0: 53 0a 09 00 a1 0f 70 0c 00 00 01 00 88 42 43 44  S.....p......BCD
  a5b0: 53 0a 09 00 a1 15 70 5e 5e 2e 4c 50 43 5f 43 34  S.....p^^.LPC_C4
  a5c0: 4f 33 88 42 43 44 53 0a 09 00 14 27 43 50 55 46  O3.BCDS....'CPUF
  a5d0: 00 70 5e 5e 2f 03 4c 50 43 5f 45 43 30 5f 54 48  .p^^/.LPC_EC0_TH
  a5e0: 46 4e 60 77 60 0a 64 61 70 61 88 42 43 44 53 0a  FN`w`.dapa.BCDS.
  a5f0: 0a 00 14 1f 43 50 55 54 00 70 5e 5e 2f 03 4c 50  ....CPUT.p^^/.LP
  a600: 43 5f 45 43 30 5f 43 54 4d 50 88 42 43 44 53 0a  C_EC0_CTMP.BCDS.
  a610: 0b 00 14 30 50 43 49 52 01 70 68 60 70 49 48 57  ...0PCIR.ph`pIHW
  a620: 4d 0a 03 68 62 70 62 44 59 32 30 70 62 44 53 59  M..hbpbDY20pbDSY
  a630: 36 70 44 53 59 34 44 53 59 32 70 44 59 36 30 44  6pDSY4DSY2pDY60D
  a640: 59 32 30 14 27 50 43 49 57 01 70 68 60 70 68 44  Y20.'PCIW.ph`phD
  a650: 59 32 30 70 49 48 57 4d 0a 04 68 62 70 62 44 53  Y20pIHWM..hbpbDS
  a660: 59 36 70 44 59 36 31 42 55 46 46 14 22 43 50 55  Y6pDY61BUFF."CPU
  a670: 53 00 70 49 48 57 4d 0a 05 00 62 70 62 42 55 46  S.pIHWM...bpbBUF
  a680: 46 70 42 55 46 46 88 42 43 44 53 0a 0c 00 14 15  FpBUFF.BCDS.....
  a690: 50 43 49 44 01 70 49 48 57 4d 0a 06 68 62 70 62  PCID.pIHWM..hbpb
  a6a0: 44 53 59 36 14 40 7e 42 54 49 46 02 70 68 60 70  DSY6.@~BTIF.ph`p
  a6b0: 69 42 55 46 46 a0 1a 93 60 0a 13 70 42 46 30 30  iBUFF...`..pBF00
  a6c0: 61 70 42 46 30 34 42 46 30 30 70 61 42 46 30 34  apBF04BF00paBF04
  a6d0: a0 23 93 60 0a 0d 70 42 46 30 32 42 46 30 30 70  .#.`..pBF02BF00p
  a6e0: 42 46 30 31 61 70 42 46 30 32 42 46 30 30 70 42  BF01apBF02BF00pB
  a6f0: 46 30 31 61 a0 22 93 60 0a 0e a0 0e 93 42 46 30  F01a.".`.....BF0
  a700: 30 00 70 0a ff 42 46 30 30 a1 0d 70 42 46 30 30  0.p..BF00..pBF00
  a710: 61 70 01 42 46 30 30 08 5f 54 5f 30 00 70 42 46  ap.BF00._T_0.pBF
  a720: 30 30 5f 54 5f 30 a0 4e 4e 93 5f 54 5f 30 01 a0  00_T_0.NN._T_0..
  a730: 25 93 5e 5e 2f 03 4c 50 43 5f 45 43 30 5f 42 44  %.^^/.LPC_EC0_BD
  a740: 43 30 00 70 0c 00 00 02 00 61 76 60 70 61 88 42  C0.p.....av`pa.B
  a750: 45 44 53 60 00 a1 4f 4b 08 5f 54 5f 31 00 70 60  EDS`..OK._T_1.p`
  a760: 5f 54 5f 31 a0 10 93 5f 54 5f 31 01 70 00 88 42  _T_1..._T_1.p..B
  a770: 45 44 53 00 00 a1 4f 49 a0 20 93 5f 54 5f 31 0a  EDS...OI. ._T_1.
  a780: 02 70 5e 5e 2f 03 4c 50 43 5f 45 43 30 5f 42 50  .p^^/.LPC_EC0_BP
  a790: 54 43 88 42 45 44 53 01 00 a1 4b 47 a0 21 93 5f  TC.BEDS...KG.!._
  a7a0: 54 5f 31 0a 03 70 5e 5e 2f 03 4c 50 43 5f 45 43  T_1..p^^/.LPC_EC
  a7b0: 30 5f 42 50 56 30 88 42 45 44 53 0a 02 00 a1 46  0_BPV0.BEDS....F
  a7c0: 45 a0 21 93 5f 54 5f 31 0a 04 70 5e 5e 2f 03 4c  E.!._T_1..p^^/.L
  a7d0: 50 43 5f 45 43 30 5f 42 53 43 55 88 42 45 44 53  PC_EC0_BSCU.BEDS
  a7e0: 0a 03 00 a1 41 43 a0 21 93 5f 54 5f 31 0a 05 70  ....AC.!._T_1..p
  a7f0: 5e 5e 2f 03 4c 50 43 5f 45 43 30 5f 42 52 43 30  ^^/.LPC_EC0_BRC0
  a800: 88 42 45 44 53 0a 04 00 a1 4c 40 a0 21 93 5f 54  .BEDS....L@.!._T
  a810: 5f 31 0a 06 70 5e 5e 2f 03 4c 50 43 5f 45 43 30  _1..p^^/.LPC_EC0
  a820: 5f 42 46 43 30 88 42 45 44 53 0a 05 00 a1 47 3e  _BFC0.BEDS....G>
  a830: a0 21 93 5f 54 5f 31 0a 07 70 5e 5e 2f 03 4c 50  .!._T_1..p^^/.LP
  a840: 43 5f 45 43 30 5f 42 53 43 59 88 42 45 44 53 0a  C_EC0_BSCY.BEDS.
  a850: 06 00 a1 42 3c a0 21 93 5f 54 5f 31 0a 08 70 5e  ...B<.!._T_1..p^
  a860: 5e 2f 03 4c 50 43 5f 45 43 30 5f 42 44 43 30 88  ^/.LPC_EC0_BDC0.
  a870: 42 45 44 53 0a 07 00 a1 4d 39 a0 21 93 5f 54 5f  BEDS....M9.!._T_
  a880: 31 0a 09 70 5e 5e 2f 03 4c 50 43 5f 45 43 30 5f  1..p^^/.LPC_EC0_
  a890: 42 44 56 30 88 42 45 44 53 0a 08 00 a1 48 37 a0  BDV0.BEDS....H7.
  a8a0: 21 93 5f 54 5f 31 0a 0a 70 5e 5e 2f 03 4c 50 43  !._T_1..p^^/.LPC
  a8b0: 5f 45 43 30 5f 42 44 41 44 88 42 45 44 53 0a 09  _EC0_BDAD.BEDS..
  a8c0: 00 a1 43 35 a0 21 93 5f 54 5f 31 0a 0b 70 5e 5e  ..C5.!._T_1..p^^
  a8d0: 2f 03 4c 50 43 5f 45 43 30 5f 42 53 4e 30 88 42  /.LPC_EC0_BSN0.B
  a8e0: 45 44 53 0a 0a 00 a1 4e 32 a0 49 04 93 5f 54 5f  EDS....N2.I.._T_
  a8f0: 31 0a 0c a0 2f 93 5e 5e 2f 03 4c 50 43 5f 45 43  1.../.^^/.LPC_EC
  a900: 30 5f 41 43 49 53 01 70 00 5e 5e 2f 03 4c 50 43  0_ACIS.p.^^/.LPC
  a910: 5f 45 43 30 5f 50 53 52 43 70 01 88 42 45 44 53  _EC0_PSRCp..BEDS
  a920: 0a 0b 00 a1 0f 70 0c 00 00 02 00 88 42 45 44 53  .....p......BEDS
  a930: 0a 0b 00 a1 41 2e a0 36 93 5f 54 5f 31 0a 0d 70  ....A..6._T_1..p
  a940: 61 5e 5e 2f 03 4c 50 43 5f 45 43 30 5f 42 54 4d  a^^/.LPC_EC0_BTM
  a950: 41 70 01 5e 5e 2f 03 4c 50 43 5f 45 43 30 5f 53  Ap.^^/.LPC_EC0_S
  a960: 43 43 46 70 01 88 42 45 44 53 0a 0c 00 a1 47 2a  CCFp..BEDS....G*
  a970: a0 49 04 93 5f 54 5f 31 0a 0e 70 61 5e 5e 2f 03  .I.._T_1..pa^^/.
  a980: 4c 50 43 5f 45 43 30 5f 42 54 50 56 70 00 5e 5e  LPC_EC0_BTPVp.^^
  a990: 2f 03 4c 50 43 5f 45 43 30 5f 53 43 48 47 70 01  /.LPC_EC0_SCHGp.
  a9a0: 5e 5e 2f 03 4c 50 43 5f 45 43 30 5f 53 43 50 46  ^^/.LPC_EC0_SCPF
  a9b0: 70 01 88 42 45 44 53 0a 0d 00 a1 4a 25 a0 21 93  p..BEDS....J%.!.
  a9c0: 5f 54 5f 31 0a 0f 70 5e 5e 2f 03 4c 50 43 5f 45  _T_1..p^^/.LPC_E
  a9d0: 43 30 5f 42 44 46 43 88 42 45 44 53 0a 0e 00 a1  C0_BDFC.BEDS....
  a9e0: 45 23 a0 21 93 5f 54 5f 31 0a 10 70 5e 5e 2f 03  E#.!._T_1..p^^/.
  a9f0: 4c 50 43 5f 45 43 30 5f 42 44 4d 45 88 42 45 44  LPC_EC0_BDME.BED
  aa00: 53 0a 0f 00 a1 40 21 a0 37 93 5f 54 5f 31 0a 11  S....@!.7._T_1..
  aa10: a0 20 7b 01 5e 5e 2f 03 4c 50 43 5f 45 43 30 5f  . {.^^/.LPC_EC0_
  aa20: 41 44 50 54 00 70 0b bc 02 88 42 45 44 53 0a 10  ADPT.p....BEDS..
  aa30: 00 a1 0d 70 0b 90 01 88 42 45 44 53 0a 10 00 a1  ...p....BEDS....
  aa40: 45 1d a0 36 93 5f 54 5f 31 0a 12 a0 20 7b 01 5e  E..6._T_1... {.^
  aa50: 5e 2f 03 4c 50 43 5f 45 43 30 5f 41 44 50 54 00  ^/.LPC_EC0_ADPT.
  aa60: 70 0b f4 01 88 42 45 44 53 0a 11 00 a1 0c 70 0a  p....BEDS.....p.
  aa70: 02 88 42 45 44 53 0a 11 00 a1 4b 19 a0 46 19 93  ..BEDS....K..F..
  aa80: 5f 54 5f 31 0a 13 08 5f 54 5f 32 00 70 42 46 30  _T_1..._T_2.pBF0
  aa90: 34 5f 54 5f 32 a0 21 93 5f 54 5f 32 0a 03 70 5e  4_T_2.!._T_2..p^
  aaa0: 5e 2f 03 4c 50 43 5f 45 43 30 5f 42 41 54 4d 88  ^/.LPC_EC0_BATM.
  aab0: 42 45 44 53 0a 12 00 a1 4b 15 a0 2f 93 5f 54 5f  BEDS....K../._T_
  aac0: 32 0a 08 70 5e 5e 2f 03 4c 50 43 5f 45 43 30 5f  2..p^^/.LPC_EC0_
  aad0: 42 54 54 43 60 72 60 0b 11 01 60 77 60 0a 0a 60  BTTC`r`...`w`..`
  aae0: 70 60 88 42 45 44 53 0a 12 00 a1 48 12 a0 21 93  p`.BEDS....H..!.
  aaf0: 5f 54 5f 32 0a 09 70 5e 5e 2f 03 4c 50 43 5f 45  _T_2..p^^/.LPC_E
  ab00: 43 30 5f 42 50 56 30 88 42 45 44 53 0a 12 00 a1  C0_BPV0.BEDS....
  ab10: 43 10 a0 21 93 5f 54 5f 32 0a 0a 70 5e 5e 2f 03  C..!._T_2..p^^/.
  ab20: 4c 50 43 5f 45 43 30 5f 42 53 43 55 88 42 45 44  LPC_EC0_BSCU.BED
  ab30: 53 0a 12 00 a1 4e 0d a0 21 93 5f 54 5f 32 0a 0f  S....N..!._T_2..
  ab40: 70 5e 5e 2f 03 4c 50 43 5f 45 43 30 5f 42 52 43  p^^/.LPC_EC0_BRC
  ab50: 30 88 42 45 44 53 0a 12 00 a1 49 0b a0 21 93 5f  0.BEDS....I..!._
  ab60: 54 5f 32 0a 17 70 5e 5e 2f 03 4c 50 43 5f 45 43  T_2..p^^/.LPC_EC
  ab70: 30 5f 42 53 43 59 88 42 45 44 53 0a 12 00 a1 44  0_BSCY.BEDS....D
  ab80: 09 a0 21 93 5f 54 5f 32 0a 18 70 5e 5e 2f 03 4c  ..!._T_2..p^^/.L
  ab90: 50 43 5f 45 43 30 5f 42 44 43 30 88 42 45 44 53  PC_EC0_BDC0.BEDS
  aba0: 0a 12 00 a1 4f 06 a0 21 93 5f 54 5f 32 0a 19 70  ....O..!._T_2..p
  abb0: 5e 5e 2f 03 4c 50 43 5f 45 43 30 5f 42 44 56 30  ^^/.LPC_EC0_BDV0
  abc0: 88 42 45 44 53 0a 12 00 a1 4a 04 a0 21 93 5f 54  .BEDS....J..!._T
  abd0: 5f 32 0a 1b 70 5e 5e 2f 03 4c 50 43 5f 45 43 30  _2..p^^/.LPC_EC0
  abe0: 5f 42 44 41 44 88 42 45 44 53 0a 12 00 a1 25 a0  _BDAD.BEDS....%.
  abf0: 21 93 5f 54 5f 32 0a 1c 70 5e 5e 2f 03 4c 50 43  !._T_2..p^^/.LPC
  ac00: 5f 45 43 30 5f 42 53 4e 30 88 42 45 44 53 0a 12  _EC0_BSN0.BEDS..
  ac10: 00 a1 01 a1 01 a1 4f 26 08 5f 54 5f 33 00 70 60  ......O&._T_3.p`
  ac20: 5f 54 5f 33 a0 14 93 5f 54 5f 33 01 70 0c 00 00  _T_3..._T_3.p...
  ac30: 02 00 88 42 45 44 53 00 00 a1 4b 24 a0 15 93 5f  ...BEDS...K$..._
  ac40: 54 5f 33 0a 02 70 0c 00 00 02 00 88 42 45 44 53  T_3..p......BEDS
  ac50: 01 00 a1 42 23 a0 16 93 5f 54 5f 33 0a 03 70 0c  ...B#..._T_3..p.
  ac60: 00 00 02 00 88 42 45 44 53 0a 02 00 a1 48 21 a0  .....BEDS....H!.
  ac70: 16 93 5f 54 5f 33 0a 04 70 0c 00 00 02 00 88 42  .._T_3..p......B
  ac80: 45 44 53 0a 03 00 a1 4e 1f a0 16 93 5f 54 5f 33  EDS....N...._T_3
  ac90: 0a 05 70 0c 00 00 02 00 88 42 45 44 53 0a 04 00  ..p......BEDS...
  aca0: a1 44 1e a0 16 93 5f 54 5f 33 0a 06 70 0c 00 00  .D...._T_3..p...
  acb0: 02 00 88 42 45 44 53 0a 05 00 a1 4a 1c a0 16 93  ...BEDS....J....
  acc0: 5f 54 5f 33 0a 07 70 0c 00 00 02 00 88 42 45 44  _T_3..p......BED
  acd0: 53 0a 06 00 a1 40 1b a0 16 93 5f 54 5f 33 0a 08  S....@...._T_3..
  ace0: 70 0c 00 00 02 00 88 42 45 44 53 0a 07 00 a1 46  p......BEDS....F
  acf0: 19 a0 16 93 5f 54 5f 33 0a 09 70 0c 00 00 02 00  ...._T_3..p.....
  ad00: 88 42 45 44 53 0a 08 00 a1 4c 17 a0 16 93 5f 54  .BEDS....L...._T
  ad10: 5f 33 0a 0a 70 0c 00 00 02 00 88 42 45 44 53 0a  _3..p......BEDS.
  ad20: 09 00 a1 42 16 a0 16 93 5f 54 5f 33 0a 0b 70 0c  ...B...._T_3..p.
  ad30: 00 00 02 00 88 42 45 44 53 0a 0a 00 a1 48 14 a0  .....BEDS....H..
  ad40: 49 04 93 5f 54 5f 33 0a 0c a0 21 93 5e 5e 2f 03  I.._T_3...!.^^/.
  ad50: 4c 50 43 5f 45 43 30 5f 42 44 43 30 00 70 0c 00  LPC_EC0_BDC0.p..
  ad60: 00 03 00 88 42 45 44 53 0a 0b 00 a1 1d 70 01 5e  ....BEDS.....p.^
  ad70: 5e 2f 03 4c 50 43 5f 45 43 30 5f 50 53 52 43 70  ^/.LPC_EC0_PSRCp
  ad80: 01 88 42 45 44 53 0a 0b 00 a1 4b 0f a0 16 93 5f  ..BEDS....K...._
  ad90: 54 5f 33 0a 0d 70 0c 00 00 02 00 88 42 45 44 53  T_3..p......BEDS
  ada0: 0a 0c 00 a1 41 0e a0 36 93 5f 54 5f 33 0a 0e 70  ....A..6._T_3..p
  adb0: 01 5e 5e 2f 03 4c 50 43 5f 45 43 30 5f 53 43 48  .^^/.LPC_EC0_SCH
  adc0: 47 70 01 5e 5e 2f 03 4c 50 43 5f 45 43 30 5f 53  Gp.^^/.LPC_EC0_S
  add0: 43 50 46 70 01 88 42 45 44 53 0a 0d 00 a1 47 0a  CPFp..BEDS....G.
  ade0: a0 16 93 5f 54 5f 33 0a 0f 70 0c 00 00 02 00 88  ..._T_3..p......
  adf0: 42 45 44 53 0a 0e 00 a1 4d 08 a0 16 93 5f 54 5f  BEDS....M...._T_
  ae00: 33 0a 10 70 0c 00 00 02 00 88 42 45 44 53 0a 0f  3..p......BEDS..
  ae10: 00 a1 43 07 a0 37 93 5f 54 5f 33 0a 11 a0 20 7b  ..C..7._T_3... {
  ae20: 01 5e 5e 2f 03 4c 50 43 5f 45 43 30 5f 41 44 50  .^^/.LPC_EC0_ADP
  ae30: 54 00 70 0b bc 02 88 42 45 44 53 0a 10 00 a1 0d  T.p....BEDS.....
  ae40: 70 0b 90 01 88 42 45 44 53 0a 10 00 a1 38 a0 36  p....BEDS....8.6
  ae50: 93 5f 54 5f 33 0a 12 a0 20 7b 01 5e 5e 2f 03 4c  ._T_3... {.^^/.L
  ae60: 50 43 5f 45 43 30 5f 41 44 50 54 00 70 0b f4 01  PC_EC0_ADPT.p...
  ae70: 88 42 45 44 53 0a 11 00 a1 0c 70 0a 02 88 42 45  .BEDS.....p...BE
  ae80: 44 53 0a 11 00 14 11 43 4b 47 53 00 70 01 47 53  DS.....CKGS.p.GS
  ae90: 54 53 a4 47 53 54 53 14 06 57 53 48 50 01 14 06  TS.GSTS..WSHP...
  aea0: 57 53 53 4c 01 14 06 57 53 53 50 01 14 06 57 53  WSSL...WSSP...WS
  aeb0: 53 45 01 14 25 57 53 56 45 01 70 68 60 a0 0a 93  SE..%WSVE.ph`...
  aec0: 60 01 70 01 42 47 45 46 a1 07 70 00 42 47 45 46  `.p.BGEF..p.BGEF
  aed0: 70 00 88 42 47 44 53 00 00 14 31 47 42 44 53 00  p..BGDS...1GBDS.
  aee0: 49 48 57 4d 0a 07 00 70 44 49 30 30 44 53 59 34  IHWM...pDI00DSY4
  aef0: 70 44 53 59 34 42 4f 30 31 70 00 42 4f 30 32 70  pDSY4BO01p.BO02p
  af00: 00 42 4f 30 33 70 00 42 4f 30 34 14 0d 53 42 44  .BO03p.BO04..SBD
  af10: 53 01 49 48 57 4d 0a 08 68 08 5f 57 44 47 11 44  S.IHWM..h._WDG.D
  af20: 0f 0a f0 09 4e 76 95 56 fb 83 4e b3 1a 37 76 1f  ....Nv.V..N..7v.
  af30: 60 99 4a 41 41 01 01 58 f2 f4 6a 01 b4 fd 42 be  `.JAA..X..j...B.
  af40: 91 3d 4a c2 d7 c0 d3 42 41 01 02 ac 61 1a cc 56  .=J....BA...a..V
  af50: 42 a3 41 b9 e0 05 a4 45 ad e2 f5 80 00 01 08 53  B.A....E.......S
  af60: 44 8c e7 27 02 61 48 9e de f5 60 0b 4a 3d 39 42  D..'.aH...`.J=9B
  af70: 42 01 02 7b 4f e0 aa c5 b3 65 48 95 d6 9f ac 7f  B..{O....eH.....
  af80: f3 e9 2b 42 43 01 02 79 4c f9 cf 77 6c f7 4a ac  ..+BC..yL..wl.J.
  af90: 56 7d d0 ce 01 c9 97 42 44 01 02 c5 2e 77 79 b1  V}.....BD....wy.
  afa0: 04 fd 4b 84 3c 61 e7 f7 7b 6c c9 42 45 01 02 b7  ..K.<a..{l.BE...
  afb0: a0 c9 a7 9d 4c 72 4c 83 bb 53 a3 45 91 71 df 42  ....LrL..S.E.q.B
  afc0: 46 01 02 4f 06 3a 65 3a a2 5f 48 b3 d9 13 f6 53  F..O.:e:._H....S
  afd0: 2a 01 82 42 47 01 02 45 dd 23 59 80 04 d5 4e b6  *..BG..E.#Y...N.
  afe0: 1a c9 ec 6c 90 e2 6a 42 48 01 02 a7 b1 85 db 9a  ...l..jBH.......
  aff0: 06 bb 4a a2 b5 d1 86 a2 1b 80 f1 81 00 01 08 91  ..J.............
  b000: 6b 91 36 64 1a 83 45 84 d0 53 83 0f b9 10 8d 82  k.6d..E..S......
  b010: 00 01 08 14 18 57 51 41 41 01 41 41 46 31 70 41  .....WQAA.AAF1pA
  b020: 41 44 53 42 55 46 46 a4 42 55 46 46 14 47 09 57  ADSBUFF.BUFF.G.W
  b030: 4d 42 41 03 08 5f 54 5f 30 00 70 69 5f 54 5f 30  MBA.._T_0.pi_T_0
  b040: a0 24 92 93 89 12 13 09 01 0a 02 0a 03 0a 08 0a  .$..............
  b050: 09 0a 0a 0a 0c 0a 0d 0a 0e 01 5f 54 5f 30 00 00  .........._T_0..
  b060: 00 ff 70 00 60 a1 39 a0 37 92 93 89 12 0e 06 0a  ..p.`.9.7.......
  b070: 04 0a 05 0a 06 0a 07 0a 0b 0a 0f 01 5f 54 5f 30  ............_T_0
  b080: 00 00 00 ff a0 17 93 69 0a 07 70 6a 42 55 46 46  .......i..pjBUFF
  b090: a0 0b 42 46 30 30 70 01 42 41 45 46 70 01 60 a0  ..BF00p.BAEFp.`.
  b0a0: 08 60 57 53 44 53 69 6a a1 06 57 47 44 53 69 70  .`WSDSij..WGDSip
  b0b0: 83 88 42 41 44 47 74 69 01 00 00 42 55 46 46 a4  ..BADGti...BUFF.
  b0c0: 42 55 46 46 14 18 5f 57 45 44 01 a0 11 92 95 68  BUFF.._WED.....h
  b0d0: 0a 80 a0 0a 95 68 0a 83 a4 4f 45 4d 4e 14 2e 57  .....h...OEMN..W
  b0e0: 4d 42 42 03 53 54 52 4c 69 6a a0 0d 93 69 01 70  MBB.STRLij...i.p
  b0f0: 42 42 53 42 42 55 46 46 a0 0e 93 69 0a 02 70 42  BBSBBUFF...i..pB
  b100: 42 44 31 42 55 46 46 a4 42 55 46 46 14 41 04 57  BD1BUFF.BUFF.A.W
  b110: 4d 42 43 03 57 4f 44 50 69 6a a0 19 95 69 0a 0a  MBC.WODPij...i..
  b120: 74 69 01 60 70 83 88 42 43 44 53 74 69 01 00 00  ti.`p..BCDSti...
  b130: 42 55 46 46 a1 14 7a 83 88 42 43 44 53 74 69 0a  BUFF..z..BCDSti.
  b140: 0a 00 00 0a 10 42 55 46 46 a4 42 55 46 46 14 43  .....BUFF.BUFF.C
  b150: 1b 57 4d 42 44 03 a0 23 93 69 01 70 6a 42 55 46  .WMBD..#.i.pjBUF
  b160: 46 70 42 55 46 46 60 70 6a 57 49 54 30 47 43 50  FpBUFF`pjWIT0GCP
  b170: 55 57 49 54 30 a4 44 53 59 30 a0 12 93 69 0a 02  UWIT0.DSY0...i..
  b180: 70 6a 60 4d 53 52 52 6a a4 44 53 59 31 a0 12 93  pj`MSRRj.DSY1...
  b190: 69 0a 03 70 6a 60 4d 53 52 57 6a a4 44 53 59 31  i..pj`MSRWj.DSY1
  b1a0: a0 23 93 69 0a 04 43 34 43 33 69 6a 7a 83 88 42  .#.i..C4C3ijz..B
  b1b0: 43 44 53 72 69 0a 05 00 00 0a 10 42 55 46 46 a4  CDSri......BUFF.
  b1c0: 42 55 46 46 a0 21 93 69 0a 05 43 34 43 33 69 6a  BUFF.!.i..C4C3ij
  b1d0: 70 83 88 42 43 44 53 72 69 0a 04 00 00 42 55 46  p..BCDSri....BUF
  b1e0: 46 a4 42 55 46 46 a0 1f 93 69 0a 06 43 50 55 46  F.BUFF...i..CPUF
  b1f0: 70 83 88 42 43 44 53 72 69 0a 04 00 00 42 55 46  p..BCDSri....BUF
  b200: 46 a4 42 55 46 46 a0 1f 93 69 0a 07 43 50 55 54  F.BUFF...i..CPUT
  b210: 70 83 88 42 43 44 53 72 69 0a 04 00 00 42 55 46  p..BCDSri....BUF
  b220: 46 a4 42 55 46 46 a0 44 04 93 69 0a 08 70 6a 57  F.BUFF.D..i..pjW
  b230: 50 52 57 70 57 57 44 31 57 50 49 52 70 57 57 44  PRWpWWD1WPIRpWWD
  b240: 32 57 50 49 46 70 57 57 44 33 57 50 49 44 70 57  2WPIFpWWD3WPIDpW
  b250: 57 44 34 57 50 49 42 73 57 50 43 49 57 57 44 30  WD4WPIBsWPCIWWD0
  b260: 60 50 43 49 52 60 a4 44 53 59 32 a0 46 06 93 69  `PCIR`.DSY2.F..i
  b270: 0a 09 70 6a 44 53 59 36 70 44 59 36 30 60 70 6a  ..pjDSY6pDY60`pj
  b280: 44 53 59 30 70 44 59 30 31 57 50 52 57 70 57 57  DSY0pDY01WPRWpWW
  b290: 44 31 57 50 49 52 70 57 57 44 32 57 50 49 46 70  D1WPIRpWWD2WPIFp
  b2a0: 57 57 44 33 57 50 49 44 70 57 57 44 34 57 50 49  WWD3WPIDpWWD4WPI
  b2b0: 42 70 57 50 43 49 61 73 44 59 36 30 57 50 43 49  BpWPCIasDY60WPCI
  b2c0: 60 73 60 57 57 44 30 61 50 43 49 57 61 a4 42 55  `s`WWD0aPCIWa.BU
  b2d0: 46 46 a0 1f 93 69 0a 0a 43 50 55 53 70 83 88 42  FF...i..CPUSp..B
  b2e0: 43 44 53 72 69 0a 02 00 00 42 55 46 46 a4 42 55  CDSri....BUFF.BU
  b2f0: 46 46 a0 0f 93 69 0a 0b 50 43 49 44 6a a4 44 53  FF...i..PCIDj.DS
  b300: 59 36 14 21 57 4d 42 45 03 42 54 49 46 69 6a 70  Y6.!WMBE.BTIFijp
  b310: 83 88 42 45 44 53 74 69 01 00 00 42 55 46 46 a4  ..BEDSti...BUFF.
  b320: 42 55 46 46 14 46 0a 57 4d 42 46 03 a0 23 94 69  BUFF.F.WMBF..#.i
  b330: 0a 04 70 0a 02 42 46 30 30 70 00 42 46 30 31 70  ..p..BF00p.BF01p
  b340: 00 42 46 30 32 70 00 42 46 30 33 a4 42 55 46 46  .BF02p.BF03.BUFF
  b350: a0 4a 05 43 4b 47 53 70 6a 42 55 46 46 a0 0c 93  .J.CKGSpjBUFF...
  b360: 69 01 57 53 48 50 42 46 30 30 a1 29 a0 0d 93 69  i.WSHPBF00.)...i
  b370: 0a 02 57 53 53 4c 42 46 30 30 a1 19 a0 0d 93 69  ..WSSLBF00.....i
  b380: 0a 03 57 53 53 50 42 46 30 30 a1 09 57 53 53 45  ..WSSPBF00..WSSE
  b390: 42 46 30 30 70 83 88 42 46 44 53 74 69 01 00 00  BF00p..BFDSti...
  b3a0: 42 55 46 46 70 42 55 46 46 5b 31 a1 1a 70 0a 03  BUFFpBUFF[1..p..
  b3b0: 42 46 30 30 70 00 42 46 30 31 70 00 42 46 30 32  BF00p.BF01p.BF02
  b3c0: 70 00 42 46 30 33 a4 42 55 46 46 14 30 57 4d 42  p.BF03.BUFF.0WMB
  b3d0: 47 03 70 6a 42 55 46 46 57 53 56 45 42 46 30 30  G.pjBUFFWSVEBF00
  b3e0: 70 83 88 42 47 44 53 74 69 01 00 00 42 55 46 46  p..BGDSti...BUFF
  b3f0: 70 42 55 46 46 5b 31 a4 42 55 46 46 14 4e 08 57  pBUFF[1.BUFF.N.W
  b400: 4d 42 48 03 70 0a 44 50 38 30 48 a0 0e 93 69 0a  MBH.p.DP80H...i.
  b410: 04 47 42 44 53 a4 42 4f 4f 54 a0 35 93 69 0a 05  .GBDS.BOOT.5.i..
  b420: 53 42 44 53 6a 70 00 88 42 55 46 31 00 00 70 00  SBDSjp..BUF1..p.
  b430: 88 42 55 46 31 01 00 70 00 88 42 55 46 31 0a 02  .BUF1..p..BUF1..
  b440: 00 70 00 88 42 55 46 31 0a 03 00 a4 42 55 46 31  .p..BUF1....BUF1
  b450: a0 3a 93 69 0a 0a a0 10 93 44 32 44 45 00 70 01  .:.i.....D2DE.p.
  b460: 88 42 55 46 31 00 00 a1 0a 70 00 88 42 55 46 31  .BUF1....p..BUF1
  b470: 00 00 70 00 88 42 55 46 31 0a 02 00 70 00 88 42  ..p..BUF1...p..B
  b480: 55 46 31 0a 03 00 a4 42 55 46 31 5b 82 4a 04 41  UF1....BUF1[.J.A
  b490: 5a 41 4c 08 5f 41 44 52 0c 00 00 1b 00 5b 80 48  ZAL._ADR.....[.H
  b4a0: 44 43 53 02 0a 54 0a 04 5b 81 0d 48 44 43 53 03  DCS..T..[..HDCS.
  b4b0: 00 0f 50 4d 45 53 01 14 1f 5f 50 52 57 00 a0 0f  ..PMES..._PRW...
  b4c0: 93 57 4b 4d 44 01 a4 12 06 02 0a 0d 0a 03 a1 08  .WKMD...........
  b4d0: a4 12 05 02 0a 0d 00                             .......

FACS @ 0xbba8f000
  0000: 46 41 43 53 40 00 00 00 00 00 00 00 00 00 00 00  FACS@...........
  0010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0020: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................

FACP @ 0xbbafd000
  0000: 46 41 43 50 f4 00 00 00 04 b3 41 43 52 53 59 53  FACP......ACRSYS
  0010: 41 43 52 50 52 44 43 54 01 00 00 00 31 30 32 35  ACRPRDCT....1025
  0020: 13 00 00 01 00 f0 a8 bb 00 c0 ae bb 00 02 09 00  ................
  0030: b2 00 00 00 a0 a1 00 00 00 04 00 00 00 00 00 00  ................
  0040: 04 04 00 00 00 00 00 00 50 04 00 00 08 04 00 00  ........P.......
  0050: 20 04 00 00 00 00 00 00 04 02 01 04 10 00 00 00   ...............
  0060: 65 00 e9 03 00 00 00 00 01 03 0d 00 00 03 00 00  e...............
  0070: a5 80 00 00 00 00 00 00 f9 0c 00 00 00 00 00 00  ................
  0080: 06 00 00 00 00 f0 a8 bb 00 00 00 00 00 c0 ae bb  ................
  0090: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  00a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  00b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  00c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  00d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  00e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  00f0: 00 00 00 00                                      ....

HPET @ 0xbbafc000
  0000: 48 50 45 54 38 00 00 00 01 9a 41 43 52 53 59 53  HPET8.....ACRSYS
  0010: 41 43 52 50 52 44 43 54 01 00 00 00 31 30 32 35  ACRPRDCT....1025
  0020: 13 00 00 01 01 a2 86 80 00 00 00 00 00 00 d0 fe  ................
  0030: 00 00 00 00 00 80 00 00                          ........

APIC @ 0xbbafb000
  0000: 41 50 49 43 6c 00 00 00 02 5c 41 43 52 53 59 53  APICl....\ACRSYS
  0010: 41 43 52 50 52 44 43 54 01 00 00 00 31 30 32 35  ACRPRDCT....1025
  0020: 13 00 00 01 00 00 e0 fe 01 00 00 00 00 08 01 00  ................
  0030: 01 00 00 00 00 08 02 01 01 00 00 00 00 08 03 00  ................
  0040: 00 00 00 00 00 08 04 00 00 00 00 00 01 0c 04 00  ................
  0050: 00 00 c0 fe 00 00 00 00 02 0a 00 00 02 00 00 00  ................
  0060: 00 00 02 0a 00 09 09 00 00 00 0d 00              ............

MCFG @ 0xbbafa000
  0000: 4d 43 46 47 3c 00 00 00 01 6a 41 43 52 53 59 53  MCFG<....jACRSYS
  0010: 41 43 52 50 52 44 43 54 01 00 00 00 31 30 32 35  ACRPRDCT....1025
  0020: 13 00 00 01 00 00 00 00 00 00 00 00 00 00 00 f8  ................
  0030: 00 00 00 00 00 00 00 3f 00 00 00 00              .......?....

ASF! @ 0xbbaf9000
  0000: 41 53 46 21 a5 00 00 00 20 cb 41 43 52 53 59 53  ASF!.... .ACRSYS
  0010: 41 43 52 50 52 44 43 54 01 00 00 00 31 30 32 35  ACRPRDCT....1025
  0020: 13 00 00 01 00 00 10 00 05 ff 01 00 00 00 01 57  ...............W
  0030: 00 00 00 00 01 00 2c 00 00 00 03 0c 89 04 01 01  ......,.........
  0040: 05 6f 00 68 08 88 17 00 89 04 04 04 07 6f 00 68  .o.h.........o.h
  0050: 20 88 03 00 89 05 01 01 19 6f 00 68 20 88 22 00   ........o.h .".
  0060: 02 00 18 00 04 04 00 00 00 88 00 03 01 88 00 02  ................
  0070: 02 88 00 01 03 88 00 04 03 00 17 00 20 f8 00 00  ............ ...
  0080: 00 1f f0 00 00 00 00 00 00 00 00 00 00 00 00 84  ................
  0090: 00 16 00 00 10 5c 68 88 c2 d2 dc a0 a2 a4 a6 c8  .....\h.........
  00a0: 00 00 00 00 00                                   .....

NSLI @ 0xbbaf8000
  0000: 4e 53 4c 49 76 01 00 00 01 4d 41 43 52 53 59 53  NSLIv....MACRSYS
  0010: 41 43 52 50 52 44 43 54 01 00 00 00 31 30 32 35  ACRPRDCT....1025
  0020: 13 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0090: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  00a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  00b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  00c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  00d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  00e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  00f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0100: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0110: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0120: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0130: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0140: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0150: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0160: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0170: 00 00 00 00 00 00                                ......

BOOT @ 0xbbaeb000
  0000: 42 4f 4f 54 28 00 00 00 01 5a 41 43 52 53 59 53  BOOT(....ZACRSYS
  0010: 41 43 52 50 52 44 43 54 01 00 00 00 31 30 32 35  ACRPRDCT....1025
  0020: 13 00 00 01 44 00 00 00                          ....D...

SSDT @ 0xbbaea000
  0000: 53 53 44 54 55 06 00 00 01 5b 50 6d 52 65 66 00  SSDTU....[PmRef.
  0010: 43 70 75 50 6d 00 00 00 00 30 00 00 49 4e 54 4c  CpuPm....0..INTL
  0020: 17 11 05 20 10 4a 09 5c 00 08 53 53 44 54 12 43  ... .J.\..SSDT.C
  0030: 05 0c 0d 43 50 55 30 49 53 54 20 00 0c 98 dc 98  ...CPU0IST .....
  0040: bb 0c 23 02 00 00 0d 41 50 49 53 54 20 20 20 00  ..#....APIST   .
  0050: 0c 18 ce 98 bb 0c cf 01 00 00 0d 43 50 55 30 43  ...........CPU0C
  0060: 53 54 20 00 0c 98 b5 98 bb 0c 37 05 00 00 0d 41  ST .......7....A
  0070: 50 43 53 54 20 20 20 00 0c 18 df 98 bb 0c 8d 00  PCST   .........
  0080: 00 00 08 43 46 47 44 0c f1 69 3b 05 08 5c 50 44  ...CFGD..i;..\PD
  0090: 43 30 0c 00 00 00 80 08 5c 50 44 43 31 0c 00 00  C0......\PDC1...
  00a0: 00 80 08 5c 50 44 43 32 0c 00 00 00 80 08 5c 50  ...\PDC2......\P
  00b0: 44 43 33 0c 00 00 00 80 08 5c 53 44 54 4c 00 10  DC3......\SDTL..
  00c0: 46 27 5c 2e 5f 50 52 5f 43 50 55 30 08 48 49 30  F'\._PR_CPU0.HI0
  00d0: 5f 00 08 48 43 30 5f 00 14 14 5f 50 44 43 01 70  _..HC0_..._PDC.p
  00e0: 43 50 44 43 68 60 47 43 41 50 60 a4 60 14 17 5f  CPDCh`GCAP`.`.._
  00f0: 4f 53 43 04 70 43 4f 53 43 68 69 6a 6b 60 47 43  OSC.pCOSChijk`GC
  0100: 41 50 60 a4 60 14 48 06 43 50 44 43 01 8a 68 00  AP`.`.H.CPDC..h.
  0110: 52 45 56 53 8a 68 0a 04 53 49 5a 45 70 87 68 60  REVS.h..SIZEp.h`
  0120: 70 74 60 0a 08 00 61 5b 13 68 0a 40 77 61 0a 08  pt`...a[.h.@wa..
  0130: 00 54 45 4d 50 08 53 54 53 30 11 07 0a 04 00 00  .TEMP.STS0......
  0140: 00 00 73 53 54 53 30 54 45 4d 50 62 a4 43 4f 53  ..sSTS0TEMPb.COS
  0150: 43 11 13 0a 10 16 a6 77 40 0c 29 be 47 9e bd d8  C......w@.).G...
  0160: 70 58 71 39 53 52 45 56 53 53 49 5a 45 62 14 4d  pXq9SREVSSIZEb.M
  0170: 0b 43 4f 53 43 04 8a 6b 00 53 54 53 30 8a 6b 0a  .COSC..k.STS0.k.
  0180: 04 43 41 50 30 8a 68 00 49 49 44 30 8a 68 0a 04  .CAP0.h.IID0.h..
  0190: 49 49 44 31 8a 68 0a 08 49 49 44 32 8a 68 0a 0c  IID1.h..IID2.h..
  01a0: 49 49 44 33 08 55 49 44 30 11 13 0a 10 16 a6 77  IID3.UID0......w
  01b0: 40 0c 29 be 47 9e bd d8 70 58 71 39 53 8a 55 49  @.).G...pXq9S.UI
  01c0: 44 30 00 45 49 44 30 8a 55 49 44 30 0a 04 45 49  D0.EID0.UID0..EI
  01d0: 44 31 8a 55 49 44 30 0a 08 45 49 44 32 8a 55 49  D1.UID0..EID2.UI
  01e0: 44 30 0a 0c 45 49 44 33 a0 32 92 90 90 93 49 49  D0..EID3.2....II
  01f0: 44 30 45 49 44 30 93 49 49 44 31 45 49 44 31 90  D0EID0.IID1EID1.
  0200: 93 49 49 44 32 45 49 44 32 93 49 49 44 33 45 49  .IID2EID2.IID3EI
  0210: 44 33 70 0a 06 53 54 53 30 a4 6b a0 0e 92 93 69  D3p..STS0.k....i
  0220: 01 70 0a 0a 53 54 53 30 a4 6b a4 6b 14 49 10 47  .p..STS0.k.k.I.G
  0230: 43 41 50 01 8a 68 00 53 54 53 30 8a 68 0a 04 43  CAP..h.STS0.h..C
  0240: 41 50 30 a0 12 91 93 53 54 53 30 0a 06 93 53 54  AP0....STS0...ST
  0250: 53 30 0a 0a a4 00 a0 16 7b 53 54 53 30 01 00 7b  S0......{STS0..{
  0260: 43 41 50 30 0b ff 0b 43 41 50 30 a4 00 7d 7b 50  CAP0...CAP0..}{P
  0270: 44 43 30 0c ff ff ff 7f 00 43 41 50 30 50 44 43  DC0......CAP0PDC
  0280: 30 a0 48 05 7b 43 46 47 44 01 00 a0 4e 04 90 90  0.H.{CFGD...N...
  0290: 7b 43 46 47 44 0c 00 00 00 01 00 93 7b 50 44 43  {CFGD.......{PDC
  02a0: 30 0a 09 00 0a 09 92 7b 53 44 54 4c 01 00 7d 53  0......{SDTL..}S
  02b0: 44 54 4c 01 53 44 54 4c 5b 80 49 53 54 30 00 83  DTL.SDTL[.IST0..
  02c0: 88 53 53 44 54 01 00 83 88 53 53 44 54 0a 02 00  .SSDT....SSDT...
  02d0: 5b 20 49 53 54 30 48 49 30 5f a0 49 05 7b 43 46  [ IST0HI0_.I.{CF
  02e0: 47 44 0a f0 00 a0 4e 04 90 90 7b 43 46 47 44 0c  GD....N...{CFGD.
  02f0: 00 00 00 01 00 7b 50 44 43 30 0a 18 00 92 7b 53  .....{PDC0....{S
  0300: 44 54 4c 0a 02 00 7d 53 44 54 4c 0a 02 53 44 54  DTL...}SDTL..SDT
  0310: 4c 5b 80 43 53 54 30 00 83 88 53 53 44 54 0a 07  L[.CST0...SSDT..
  0320: 00 83 88 53 53 44 54 0a 08 00 5b 20 43 53 54 30  ...SSDT...[ CST0
  0330: 48 43 30 5f a4 00 10 46 16 5c 2e 5f 50 52 5f 43  HC0_...F.\._PR_C
  0340: 50 55 31 08 48 49 31 5f 00 08 48 43 31 5f 00 14  PU1.HI1_..HC1_..
  0350: 1f 5f 50 44 43 01 70 5c 2f 03 5f 50 52 5f 43 50  ._PDC.p\/._PR_CP
  0360: 55 30 43 50 44 43 68 60 47 43 41 50 60 a4 60 14  U0CPDCh`GCAP`.`.
  0370: 22 5f 4f 53 43 04 70 5c 2f 03 5f 50 52 5f 43 50  "_OSC.p\/._PR_CP
  0380: 55 30 43 4f 53 43 68 69 6a 6b 60 47 43 41 50 60  U0COSChijk`GCAP`
  0390: a4 60 14 45 07 47 43 41 50 01 8a 68 00 53 54 53  .`.E.GCAP..h.STS
  03a0: 31 8a 68 0a 04 43 41 50 31 a0 12 91 93 53 54 53  1.h..CAP1....STS
  03b0: 31 0a 06 93 53 54 53 31 0a 0a a4 00 a0 16 7b 53  1...STS1......{S
  03c0: 54 53 31 01 00 7b 43 41 50 31 0b ff 0b 43 41 50  TS1..{CAP1...CAP
  03d0: 31 a4 00 7d 7b 50 44 43 31 0c ff ff ff 7f 00 43  1..}{PDC1......C
  03e0: 41 50 31 50 44 43 31 a0 10 93 7b 50 44 43 30 0a  AP1PDC1...{PDC0.
  03f0: 09 00 0a 09 41 50 50 54 a0 0d 7b 50 44 43 30 0a  ....APPT..{PDC0.
  0400: 18 00 41 50 43 54 a4 00 14 4a 04 41 50 43 54 00  ..APCT...J.APCT.
  0410: a0 42 04 90 7b 43 46 47 44 0a f0 00 92 7b 53 44  .B..{CFGD....{SD
  0420: 54 4c 0a 20 00 7d 53 44 54 4c 0a 20 53 44 54 4c  TL. .}SDTL. SDTL
  0430: 5b 80 43 53 54 31 00 83 88 53 53 44 54 0a 0a 00  [.CST1...SSDT...
  0440: 83 88 53 53 44 54 0a 0b 00 5b 20 43 53 54 31 48  ..SSDT...[ CST1H
  0450: 43 31 5f 14 49 04 41 50 50 54 00 a0 41 04 90 7b  C1_.I.APPT..A..{
  0460: 43 46 47 44 01 00 92 7b 53 44 54 4c 0a 10 00 7d  CFGD...{SDTL...}
  0470: 53 44 54 4c 0a 10 53 44 54 4c 5b 80 49 53 54 31  SDTL..SDTL[.IST1
  0480: 00 83 88 53 53 44 54 0a 04 00 83 88 53 53 44 54  ...SSDT.....SSDT
  0490: 0a 05 00 5b 20 49 53 54 31 48 49 31 5f 10 4b 0d  ...[ IST1HI1_.K.
  04a0: 5c 2e 5f 50 52 5f 43 50 55 32 14 1f 5f 50 44 43  \._PR_CPU2.._PDC
  04b0: 01 70 5c 2f 03 5f 50 52 5f 43 50 55 30 43 50 44  .p\/._PR_CPU0CPD
  04c0: 43 68 60 47 43 41 50 60 a4 60 14 22 5f 4f 53 43  Ch`GCAP`.`."_OSC
  04d0: 04 70 5c 2f 03 5f 50 52 5f 43 50 55 30 43 4f 53  .p\/._PR_CPU0COS
  04e0: 43 68 69 6a 6b 60 47 43 41 50 60 a4 60 14 4b 08  Chijk`GCAP`.`.K.
  04f0: 47 43 41 50 01 8a 68 00 53 54 53 32 8a 68 0a 04  GCAP..h.STS2.h..
  0500: 43 41 50 32 a0 12 91 93 53 54 53 32 0a 06 93 53  CAP2....STS2...S
  0510: 54 53 32 0a 0a a4 00 a0 16 7b 53 54 53 32 01 00  TS2......{STS2..
  0520: 7b 43 41 50 32 0b ff 0b 43 41 50 32 a4 00 7d 7b  {CAP2...CAP2..}{
  0530: 50 44 43 32 0c ff ff ff 7f 00 43 41 50 32 50 44  PDC2......CAP2PD
  0540: 43 32 a0 1b 93 7b 50 44 43 32 0a 09 00 0a 09 5c  C2...{PDC2.....\
  0550: 2f 03 5f 50 52 5f 43 50 55 31 41 50 50 54 a0 18  /._PR_CPU1APPT..
  0560: 7b 50 44 43 32 0a 18 00 5c 2f 03 5f 50 52 5f 43  {PDC2...\/._PR_C
  0570: 50 55 31 41 50 43 54 a4 00 10 4b 0d 5c 2e 5f 50  PU1APCT...K.\._P
  0580: 52 5f 43 50 55 33 14 1f 5f 50 44 43 01 70 5c 2f  R_CPU3.._PDC.p\/
  0590: 03 5f 50 52 5f 43 50 55 30 43 50 44 43 68 60 47  ._PR_CPU0CPDCh`G
  05a0: 43 41 50 60 a4 60 14 22 5f 4f 53 43 04 70 5c 2f  CAP`.`."_OSC.p\/
  05b0: 03 5f 50 52 5f 43 50 55 30 43 4f 53 43 68 69 6a  ._PR_CPU0COSChij
  05c0: 6b 60 47 43 41 50 60 a4 60 14 4b 08 47 43 41 50  k`GCAP`.`.K.GCAP
  05d0: 01 8a 68 00 53 54 53 33 8a 68 0a 04 43 41 50 33  ..h.STS3.h..CAP3
  05e0: a0 12 91 93 53 54 53 33 0a 06 93 53 54 53 33 0a  ....STS3...STS3.
  05f0: 0a a4 00 a0 16 7b 53 54 53 33 01 00 7b 43 41 50  .....{STS3..{CAP
  0600: 33 0b ff 0b 43 41 50 33 a4 00 7d 7b 50 44 43 33  3...CAP3..}{PDC3
  0610: 0c ff ff ff 7f 00 43 41 50 33 50 44 43 33 a0 1b  ......CAP3PDC3..
  0620: 93 7b 50 44 43 32 0a 09 00 0a 09 5c 2f 03 5f 50  .{PDC2.....\/._P
  0630: 52 5f 43 50 55 31 41 50 50 54 a0 18 7b 50 44 43  R_CPU1APPT..{PDC
  0640: 32 0a 18 00 5c 2f 03 5f 50 52 5f 43 50 55 31 41  2...\/._PR_CPU1A
  0650: 50 43 54 a4 00                                   PCT..

XSDT @ 0xbbafe120
  0000: 58 53 44 54 64 00 00 00 01 0d 41 43 52 53 59 53  XSDTd.....ACRSYS
  0010: 41 43 52 50 52 44 43 54 01 00 00 00 20 20 20 20  ACRPRDCT....    
  0020: 13 00 00 01 00 d0 af bb 00 00 00 00 00 c0 af bb  ................
  0030: 00 00 00 00 00 b0 af bb 00 00 00 00 00 a0 af bb  ................
  0040: 00 00 00 00 00 90 af bb 00 00 00 00 00 80 af bb  ................
  0050: 00 00 00 00 00 b0 ae bb 00 00 00 00 00 a0 ae bb  ................
  0060: 00 00 00 00                                      ....

RSD PTR @ 0xfe020
  0000: 52 53 44 20 50 54 52 20 14 41 43 52 53 59 53 02  RSD PTR .ACRSYS.
  0010: ac e0 af bb 24 00 00 00 20 e1 af bb 00 00 00 00  ....$... .......
  0020: 71 00 00 00                                      q...


--=-ohF2s1RZUbPpbswLIEUE--

