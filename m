Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032Ab2BTEoa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 23:44:30 -0500
Received: from mga11.intel.com ([192.55.52.93]:30852 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374Ab2BTEo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 23:44:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="127273538"
Date: Mon, 20 Feb 2012 12:43:22 +0800
From: Feng Tang <feng.tang@intel.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Darren Hart <dvhart@linux.intel.com>,
        "lkml," <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org,
        feng.tang@intel.com
Subject: Re: pch_uart and pch_phub clock selection
Message-ID: <20120220044322.GA4113@feng-i7>
References: <4F3DA617.5030805@linux.intel.com>
 <20120217072808.GA26800@feng-i7>
 <CANKRQnhfQyUrMWaXJVsjmL-yFnHa9WuR5LfTkqv=QmRGnC2aTw@mail.gmail.com>
 <4F3E9909.7010301@linux.intel.com>
 <CANKRQnihp+CO9yz3SfEL=kFO18SMUJnU_LdELViPsNmd-Ew8yw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANKRQnihp+CO9yz3SfEL=kFO18SMUJnU_LdELViPsNmd-Ew8yw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomoya,

On Mon, Feb 20, 2012 at 01:28:33PM +0900, Tomoya MORINAGA wrote:
> Hi
> 
> Considering Feng's/Darren's proposal/question,
> I should have set 192MHz as default uart clock setting.
> So, I created the following patch. (not formal patch but for review)
> Let me know your opinion.
> 
> ---
>  drivers/misc/pch_phub.c       |   17 ++++++-----------
>  drivers/tty/serial/pch_uart.c |   15 +++++++--------
>  2 files changed, 13 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/misc/pch_phub.c b/drivers/misc/pch_phub.c
> index 10fc478..8f9c1db 100644
> --- a/drivers/misc/pch_phub.c
> +++ b/drivers/misc/pch_phub.c
> @@ -55,7 +55,7 @@
>  #define CLKCFG_CANCLK_MASK 0xFF000000
>  #define CLKCFG_UART_MASK			0xFFFFFF
> 
> -/* CM-iTC */
> +/* 192MHz Clock configuration. USB_48MHz / 2 * 8 = 192 */
>  #define CLKCFG_UART_48MHZ			(1 << 16)
>  #define CLKCFG_BAUDDIV				(2 << 20)
>  #define CLKCFG_PLL2VCO				(8 << 9)
> @@ -715,8 +715,6 @@ static int __devinit pch_phub_probe(struct pci_dev *pdev,
>  	chip->pdev = pdev; /* Save pci device struct */
> 
>  	if (id->driver_data == 1) { /* EG20T PCH */
> -		const char *board_name;
> -
>  		retval = sysfs_create_file(&pdev->dev.kobj,
>  					   &dev_attr_pch_mac.attr);
>  		if (retval)
> @@ -731,14 +729,11 @@ static int __devinit pch_phub_probe(struct pci_dev *pdev,
>  					       CLKCFG_CAN_50MHZ,
>  					       CLKCFG_CANCLK_MASK);
> 
> -		/* quirk for CM-iTC board */
> -		board_name = dmi_get_system_info(DMI_BOARD_NAME);
> -		if (board_name && strstr(board_name, "CM-iTC"))
> -			pch_phub_read_modify_write_reg(chip,
> -						(unsigned int)CLKCFG_REG_OFFSET,
> -						CLKCFG_UART_48MHZ | CLKCFG_BAUDDIV |
> -						CLKCFG_PLL2VCO | CLKCFG_UARTCLKSEL,
> -						CLKCFG_UART_MASK);
> +		pch_phub_read_modify_write_reg(chip,
> +					(unsigned int)CLKCFG_REG_OFFSET,
> +					CLKCFG_UART_48MHZ | CLKCFG_BAUDDIV |
> +					CLKCFG_PLL2VCO | CLKCFG_UARTCLKSEL,
> +					CLKCFG_UART_MASK);

All the code looks fine to me except one point: Can we also set ML7213/7223's
default clk to 192MHz? 192MHz works fine on my ML7213 board. And using an
unified default clock rate for all EG20T compatible IOHs will save extra
effort of setting the uart clock.

Thanks,
Feng

