Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531Ab2BQH3V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 02:29:21 -0500
Received: from mga11.intel.com ([192.55.52.93]:3210 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800Ab2BQH3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 02:29:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="126593275"
Date: Fri, 17 Feb 2012 15:28:08 +0800
From: Feng Tang <feng.tang@intel.com>
To: Darren Hart <dvhart@linux.intel.com>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: "lkml, " <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org
Subject: Re: pch_uart and pch_phub clock selection
Message-ID: <20120217072808.GA26800@feng-i7>
References: <4F3DA617.5030805@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F3DA617.5030805@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Darren,

On Thu, Feb 16, 2012 at 04:57:59PM -0800, Darren Hart wrote:
> I'm working on a tunnel creek (atom e6xx + topcliff PCH) development platform
> that uses a 48MHz or 64MHz clock to drive the pch_uart. I've found that if I
> force the uart_clock to 48MHz (or 64MHz on the latest rev) I can get the kernel
> messages and getty on the serial port.
> 
> I see that the the CM-iTC board is special-cased to set a 192MHz uart_clock.
> This is done in pch_uart.c code, but there is some register manipulation done in
> the pch_phub.c driver and I don't understand the connection. How are the two
> related?

I've met similar problem about the base clock rate for pch_uart on EG20T/ML7213,
which is controller by the phub clock configuration register. 

My thought is to use a unified base clock rate 192MHz for all pch_uart devices
which could be found on EG20T/ML7213/ML72xx chipsets, so that we don't need to
worry about the different clock rate on all kinds of boards, nor do we need
the CM-iTC quirk any more. I've tested the below patch on one EG20T board and
one ML7213 board, and both work fine with it.

Adding Tomoya for his comments as he is most familiar with pch_uart driver.

Tomoya, do you know if we can also set it to 192MHz for ML7223 IOH Bus-m/n?

Thanks,
Feng

----------------------------
>From 091952dc27d3bf76e28b2afbc2fb36f0d6caada1 Mon Sep 17 00:00:00 2001
From: Feng Tang <feng.tang@intel.com>
Date: Fri, 17 Feb 2012 13:59:43 +0800
Subject: [PATCH] pch_phub: unify the inital UART clock rate for EG20T and ML7213

Set the base clk rate to 192MHz, so that the pch_uart driver can
have the unique uartclk value, and don't need to add quirks for
different boards and configurations.

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 drivers/misc/pch_phub.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/pch_phub.c b/drivers/misc/pch_phub.c
index 10fc478..bbe4db9 100644
--- a/drivers/misc/pch_phub.c
+++ b/drivers/misc/pch_phub.c
@@ -731,10 +731,8 @@ static int __devinit pch_phub_probe(struct pci_dev *pdev,
 					       CLKCFG_CAN_50MHZ,
 					       CLKCFG_CANCLK_MASK);
 
-		/* quirk for CM-iTC board */
-		board_name = dmi_get_system_info(DMI_BOARD_NAME);
-		if (board_name && strstr(board_name, "CM-iTC"))
-			pch_phub_read_modify_write_reg(chip,
+		/* Set the UART base clk rate to 192MHz */
+		pch_phub_read_modify_write_reg(chip,
 						(unsigned int)CLKCFG_REG_OFFSET,
 						CLKCFG_UART_48MHZ | CLKCFG_BAUDDIV |
 						CLKCFG_PLL2VCO | CLKCFG_UARTCLKSEL,
@@ -747,6 +745,14 @@ static int __devinit pch_phub_probe(struct pci_dev *pdev,
 		chip->pch_opt_rom_start_address = PCH_PHUB_ROM_START_ADDR_EG20T;
 		chip->pch_mac_start_address = PCH_PHUB_MAC_START_ADDR_EG20T;
 	} else if (id->driver_data == 2) { /* ML7213 IOH */
+
+		/* Set the UART base clk rate to 192MHz */
+		pch_phub_read_modify_write_reg(chip,
+						(unsigned int)CLKCFG_REG_OFFSET,
+						CLKCFG_UART_48MHZ | CLKCFG_BAUDDIV |
+						CLKCFG_PLL2VCO | CLKCFG_UARTCLKSEL,
+						CLKCFG_UART_MASK);
+
 		retval = sysfs_create_bin_file(&pdev->dev.kobj, &pch_bin_attr);
 		if (retval)
 			goto err_sysfs_create;
@@ -804,6 +810,8 @@ static int __devinit pch_phub_probe(struct pci_dev *pdev,
 		chip->pch_mac_start_address = PCH_PHUB_MAC_START_ADDR_EG20T;
 	}
 
+	pr_info("PHUB controller: CLKCFG register is set to 0x%08x\n",
+		ioread32(chip->pch_phub_base_address + CLKCFG_REG_OFFSET));
 	chip->ioh_type = id->driver_data;
 	pci_set_drvdata(pdev, chip);
 
-- 
1.7.1


> 
> Is the pch_phub.c register manipulation required for proper related? It seems to
> work without touching those registers if I just force the clock.
> 
> The device I'm working with is EFI, and the dmi_get_system_info(DMI_BOARD_NAME)
> returns "(null)", so I can't use the same test to identify this board. Is there
> another common mechanism I might be able to use?
> 
> The following patch (by way of example, not meant for inclusion) gets things
> working for this particular board with this command line:
> 
> console=ttyPCH1,115200 pch_uart.clock_param=48000000
> 
> I believe the right thing to do here is to discover a way to identify the board
> and special case the clock as is done for the CM-iTC, but I would like to
> understand the purpose of the pch_phub register manipulation code. Does this
> make sense?
> 
> Thanks,
> 
> Darren
