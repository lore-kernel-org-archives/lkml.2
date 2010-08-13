Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761710Ab0HMOrZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 10:47:25 -0400
Received: from snt0-omc1-s15.snt0.hotmail.com ([65.55.90.26]:29138 "EHLO
	snt0-omc1-s15.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761667Ab0HMOrY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 10:47:24 -0400
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Aug 2010 10:47:24 EDT
Message-ID: <SNT135-w1108C18559F0BF8F0A3242F3980@phx.gbl>
X-Originating-IP: [209.87.232.162]
From: Jon E <je_nfd@hotmail.com>
To: <linux-kernel@vger.kernel.org>
Subject: Problems with Recent Patches to IDE Driver
Date: Fri, 13 Aug 2010 10:41:14 -0400
Importance: Normal
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 13 Aug 2010 14:41:14.0434 (UTC) FILETIME=[94945A20:01CB3AF5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hi,
 
We manufacture an interface board for our product that utilizes the IDE interface.  A couple of patches were made (back in 2008, kernel 2.6.30 series) to the IDE driver code that are now causing us some grief as we port our driver from kernel 2.6.15 to 2.6.32 (FC5 to Ubuntu LL).
 
1. Refer to http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.30.y.git;a=commit;h=dafd01cc14a38690c87981eb2670d9c95f799ffd
 
A change was made to include/linux/hdreg.h that wrapped the WIN_xx macros in #ifndef/#endif __KERNEL__.  Our code utilized those macros and now no longer builds.
 
The area of code in oiur driver modules that's affected:

...
        // If writing to Audio card, indicate which Audio Channel
        if ((!reading) && (!DMAIPData))
        {
            outb(to_channel(CardAndChannel), LCYL_REG);
        }
        outb(reading ? WIN_READDMA : WIN_WRITEDMA, COMMAND_REG);
    case ide_dma_begin:
        outb(inb(dma_base)|1, dma_base); // start DMA 
        return 0;
    case ide_dma_end: // returns 1 on error, 0 otherwise 
...
 
The driver is built as a kernel module.  I'm not defining __KERNEL__ in my Makefile but the make process is picking up __KERNEL__ from /lib/modules/2.6.32-24-generic/build/Makefile and so, the compile fails thus:
 
ideDriver.c: In function ‘DmaProc’:
ideDriver.c:4208: error: ‘WIN_READDMA’ undeclared (first use in this function)
ideDriver.c:4208: error: (Each undeclared identifier is reported only once
ideDriver.c:4208: error: for each function it appears in.)
ideDriver.c:4208: error: ‘WIN_WRITEDMA’ undeclared (first use in this function)
ideDriver.o] Error 1
 
2. Refer to http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.30.y.git;a=commitdiff;h=18de10170df31d34b342612f1c896a16a52f0a5c
 
It seems that the ide_hwifs master data array has been removed from ide.h.  We're using this array in our code and I'm not sure how to code around the fact that it's no longer present.
 
Our code:
 
    for (h = 0; h < MAX_HWIFS; ++h)
    {
        ide_hwif_t *hwif = &ide_hwifs[h];
        if (hwif->major == IDEMajor[whichController])
        {
            IDEDrive = &hwif->drives[0];
            break;
        }
    }
 
I've googled for some answers but it seems there are no suggested workarounds for these problems.  Perhaps someone reading this can offer some suggestions?
 
Thanks,
Jon 		 	   		  