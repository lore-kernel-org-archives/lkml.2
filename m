Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977Ab1G2Ani (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 20:43:38 -0400
Received: from outgw05.ricoh.co.jp ([202.248.73.90]:39514 "EHLO
	outgw05.ricoh.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494Ab1G2Anh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 20:43:37 -0400
X-Greylist: delayed 1052 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Jul 2011 20:43:36 EDT
In-Reply-To: <20110728234413.75CBB2403FF@tassilo.jf.intel.com>
Subject: Re: [PATCH] [9/50] mmc: Added quirks for Ricoh 1180:e823 lower base clock
To: andi@firstfloor.org
Cc: ak@linux.intel.com, cjb@laptop.org, daniel.manrique@canonical.com,
        jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
        manoj.iyer@canonical.com, stable@kernel.org, tim.bird@am.sony.com
X-Mailer: Lotus Notes Release 7.0.2 September 26, 2006
Message-ID: <OFEA694ED7.D779260D-ON492578DB.00834494-492578DC.000262D4@mta.ricoh.co.jp>
From: matsumur@nts.ricoh.co.jp
Date: Fri, 29 Jul 2011 09:27:56 +0900
X-MIMETrack: Serialize by Router on ZGMTA07/G/RGroup(Release 7.0.2FP1 HF237|April 25, 2007) at
 2011/07/29 09:26:02
MIME-Version: 1.0
Content-type: text/plain; charset=ISO-2022-JP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Sir,

Ricoh 1180:e823 device is named R5U220/R5U232 (2 devices have the same
device ID ).
So, I think it should be declared to as PCI_DEVICE_ID_RICOH_R5U220.

BTW, does anyone know whether the current SDHCI-driver sets 200Mhz to
SD-CLK for UHS-I cards ?


Thanks,

Koji Matsumuro
Ricoh Company,Ltd.




                                                                           
             Andi Kleen                                                    
             <andi@firstfloor.                                             
             org>                                                     宛先 
                                        manoj.iyer@canonical.com,          
             2011/07/29 08:44           daniel.manrique@canonical.com,     
                                        Koji Matsumuro/R/RICOH@RICOH,      
                                        jbarnes@virtuousgeek.org,          
                                        cjb@laptop.org,                    
                                        ak@linux.intel.com,                
                                        linux-kernel@vger.kernel.org,      
                                        stable@kernel.org,                 
                                        tim.bird@am.sony.com               
                                                                        cc 
                                                                           
                                                                      件名 
                                        [PATCH] [9/50] mmc: Added quirks   
                                        for Ricoh 1180:e823 lower base     
                                        clock                              
                                                                           
                                                                           
                                                                           
                                                                           
                                                                           
                                                                           



2.6.35-longterm review patch.  If anyone has any objections, please let me
know.

------------------
From: Manoj Iyer <manoj.iyer@canonical.com>

[ upstream commit 15bed0f2fa8e1d7db201692532c210a7823d2d21 ]
 frequency

Ricoh 1180:e823 does not recognize certain types of SD/MMC cards,
as reported at http://launchpad.net/bugs/773524.  Lowering the SD
base clock frequency from 200Mhz to 50Mhz fixes this issue. This
solution was suggest by Koji Matsumuro, Ricoh Company, Ltd.

This change has no negative performance effect on standard SD
cards, though it's quite possible that there will be one on
UHS-1 cards.

Signed-off-by: Manoj Iyer <manoj.iyer@canonical.com>
Tested-by: Daniel Manrique <daniel.manrique@canonical.com>
Cc: Koji Matsumuro <matsumur@nts.ricoh.co.jp>
Cc: <stable@kernel.org>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/drivers/pci/quirks.c
===================================================================
--- linux-2.6.35.y.orig/drivers/pci/quirks.c
+++ linux-2.6.35.y/drivers/pci/quirks.c
@@ -2698,6 +2698,29 @@ static void ricoh_mmc_fixup_r5c832(struc

  dev_notice(&dev->dev, "proprietary Ricoh MMC controller disabled (via
  firewire function)\n");
  dev_notice(&dev->dev, "MMC cards are now supported by standard SDHCI
  controller\n");
+
+     /*
+      * RICOH 0xe823 SD/MMC card reader fails to recognize
+      * certain types of SD/MMC cards. Lowering the SD base
+      * clock frequency from 200Mhz to 50Mhz fixes this issue.
+      *
+      * 0x150 - SD2.0 mode enable for changing base clock
+      *       frequency to 50Mhz
+      * 0xe1  - Base clock frequency
+      * 0x32  - 50Mhz new clock frequency
+      * 0xf9  - Key register for 0x150
+      * 0xfc  - key register for 0xe1
+      */
+     if (dev->device == PCI_DEVICE_ID_RICOH_R5CE823) {
+           pci_write_config_byte(dev, 0xf9, 0xfc);
+           pci_write_config_byte(dev, 0x150, 0x10);
+           pci_write_config_byte(dev, 0xf9, 0x00);
+           pci_write_config_byte(dev, 0xfc, 0x01);
+           pci_write_config_byte(dev, 0xe1, 0x32);
+           pci_write_config_byte(dev, 0xfc, 0x00);
+
+           dev_notice(&dev->dev, "MMC controller base frequency changed to
50Mhz.\n");
+     }
 }
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5C832,
 ricoh_mmc_fixup_r5c832);
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_RICOH,
 PCI_DEVICE_ID_RICOH_R5C832, ricoh_mmc_fixup_r5c832);


