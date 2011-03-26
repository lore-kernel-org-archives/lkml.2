Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588Ab1CZMf6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 08:35:58 -0400
Received: from mail.bisel.ru ([80.93.56.210]:34525 "EHLO mail.bisel.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076Ab1CZMf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 08:35:57 -0400
X-Greylist: delayed 350 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Mar 2011 08:35:56 EDT
X-Envelope-Recipient: jgarzik@pobox.com
X-Envelope-Recipient: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Sat, 26 Mar 2011 15:30:02 +0300
From: igor@novg.net
To: <jgarzik@pobox.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH 2.6.38.1] =?UTF-8?Q?pata=5Fit=38=32=31x=3A=20Add=20module?=
 =?UTF-8?Q?=20param=20to=20force=20UDMA=20on=20Vortex=38=36SX?=
Message-ID: <89bf4e2c74a16f130208a485c6eafd77@novg.net>
User-Agent: Roundcube Webmail/0.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 This patch adds parameter 'it8212_rdc11_force_udma' to 'pata_it821x' 
 module,
 which allows users to force UDMA mode on RDC11/Vortex86SX embedded 
 devices.

 ---
 UDMA is disabled by default due to some CRC errors, which i cannot 
 observe when
 using CompactFlash card with patched driver.

 May be there are errors with pure IDE devices or with older revisions 
 of Vortex86SX
 boards, i do no know. But for my device i have 2x improvement in I/O 
 speed when
 enabling UDMA/33 instead of MWDMA, so i think this parameter would be 
 useful.

 Also fix to initialize default value for parameter 'noraid'.

 --- b/drivers/ata/pata_it821x.c 2011-03-23 23:04:47.000000000 +0300
 +++ a/drivers/ata/pata_it821x.c 2011-03-26 15:10:49.608952573 +0300
 @@ -111,7 +111,8 @@ struct it821x_dev
   *     device.
   */

 -static int it8212_noraid;
 +static int it8212_noraid = 0;
 +static int it8212_rdc11_force_udma = 0;

  /**
   *     it821x_program  -       program the PIO/MWDMA registers
 @@ -913,7 +914,7 @@ static int it821x_init_one(struct pci_de

         if (pdev->vendor == PCI_VENDOR_ID_RDC) {
                 /* Deal with Vortex86SX */
 -               if (pdev->revision == 0x11)
 +               if (pdev->revision == 0x11 && !it8212_rdc11_force_udma)
                         ppi[0] = &info_rdc_11;
                 else
                         ppi[0] = &info_rdc;
 @@ -988,9 +989,12 @@ MODULE_LICENSE("GPL");
  MODULE_DEVICE_TABLE(pci, it821x);
  MODULE_VERSION(DRV_VERSION);

 -
  module_param_named(noraid, it8212_noraid, int, S_IRUGO);
  MODULE_PARM_DESC(noraid, "Force card into bypass mode");

 +module_param_named(rdc11_force_udma, it8212_rdc11_force_udma, int, 
 S_IRUGO|S_IWUSR);
 +MODULE_PARM_DESC(rdc11_force_udma, "Force enable UDMA mode 
 RDC11/Vortex86SX boards."
 +       " Use with caution");
 +
  module_init(it821x_init);
  module_exit(it821x_exit);

