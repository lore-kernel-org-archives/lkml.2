Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab2BUQIg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 11:08:36 -0500
Received: from mga09.intel.com ([134.134.136.24]:20564 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358Ab2BUQId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 11:08:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="110421317"
Message-ID: <4F43C15D.6080401@linux.intel.com>
Date: Tue, 21 Feb 2012 08:07:57 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
CC: Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, feng.tang@intel.com
Subject: Re: [PATCH] pch_uart: Change default UART clock setting 192MHz
References: <1329800140-4279-1-git-send-email-tomoya.rohm@gmail.com>
In-Reply-To: <1329800140-4279-1-git-send-email-tomoya.rohm@gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2012 08:55 PM, Tomoya MORINAGA wrote:
> Currently, PCH_UART uses 1843200Hz as default clock.
> However, in case of using high baud rate, users need to modify
> clock setting.
> 
> This patch uses 192MHz setting as default UART clock setting.
> Using this clock, users can use almost high baud rate without modifying
> clock settings.
> 
> This setting is the same as quirk for CM-iTC board.
> So, delete the quirk.

This also adds my module parameter "clock_param" to the patch. This
should be added separately. My current version renames this to
user_uartclk. I can send this one separately.

I'll test this today to ensure it works for my development board. I'm
concerned that it won't work for early serial console and I'll still
need to modify the BAUD on the kernel command line to compensate for the
delta between the firmware clock setting (64MHz) and the phub setting to
192MHz. When does the phub driver update the clock registers?

--
Darren


> Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
> ---
> Related patch is 
> http://marc.info/?l=linux-kernel&m=132979974907774&w=2
> ---
>  drivers/tty/serial/pch_uart.c |   15 ++++++---------
>  1 files changed, 6 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
> index 17ae657..d068c34 100644
> --- a/drivers/tty/serial/pch_uart.c
> +++ b/drivers/tty/serial/pch_uart.c
> @@ -203,7 +203,7 @@ enum {
>  
>  #define BOTH_EMPTY (UART_LSR_TEMT | UART_LSR_THRE)
>  
> -#define DEFAULT_BAUD_RATE 1843200 /* 1.8432MHz */
> +#define DEFAULT_UART_CLOCK 192000000 /* 192.0MHz */
>  
>  struct pch_uart_buffer {
>  	unsigned char *buf;
> @@ -287,6 +287,7 @@ static struct pch_uart_driver_data drv_dat[] = {
>  static struct eg20t_port *pch_uart_ports[PCH_UART_NR];
>  #endif
>  static unsigned int default_baud = 9600;
> +static unsigned int clock_param;
>  static const int trigger_level_256[4] = { 1, 64, 128, 224 };
>  static const int trigger_level_64[4] = { 1, 16, 32, 56 };
>  static const int trigger_level_16[4] = { 1, 4, 8, 14 };
> @@ -1507,7 +1508,7 @@ static int __init pch_console_setup(struct console *co, char *options)
>  		return -ENODEV;
>  
>  	/* setup uartclock */
> -	port->uartclk = DEFAULT_BAUD_RATE;
> +	port->uartclk = clock_param ? clock_param : DEFAULT_UART_CLOCK;
>  
>  	if (options)
>  		uart_parse_options(options, &baud, &parity, &bits, &flow);
> @@ -1553,7 +1554,6 @@ static struct eg20t_port *pch_uart_init_port(struct pci_dev *pdev,
>  	int fifosize, base_baud;
>  	int port_type;
>  	struct pch_uart_driver_data *board;
> -	const char *board_name;
>  
>  	board = &drv_dat[id->driver_data];
>  	port_type = board->port_type;
> @@ -1566,12 +1566,8 @@ static struct eg20t_port *pch_uart_init_port(struct pci_dev *pdev,
>  	if (!rxbuf)
>  		goto init_port_free_txbuf;
>  
> -	base_baud = DEFAULT_BAUD_RATE;
> -
> -	/* quirk for CM-iTC board */
> -	board_name = dmi_get_system_info(DMI_BOARD_NAME);
> -	if (board_name && strstr(board_name, "CM-iTC"))
> -		base_baud = 192000000; /* 192.0MHz */
> +	/* The module parameter overrides default. */
> +	base_baud = clock_param ? clock_param : DEFAULT_UART_CLOCK;
>  
>  	switch (port_type) {
>  	case PORT_UNKNOWN:
> @@ -1785,3 +1781,4 @@ module_exit(pch_uart_module_exit);
>  MODULE_LICENSE("GPL v2");
>  MODULE_DESCRIPTION("Intel EG20T PCH UART PCI Driver");
>  module_param(default_baud, uint, S_IRUGO);
> +module_param(clock_param, uint, (S_IRUSR | S_IWUSR));

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
