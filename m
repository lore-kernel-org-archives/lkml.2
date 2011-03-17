Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088Ab1CQSfY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 14:35:24 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:1355 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354Ab1CQSfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 14:35:22 -0400
Message-ID: <4D825464.3070407@caviumnetworks.com>
Date: Thu, 17 Mar 2011 11:35:16 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-serial@vger.kernel.org, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [RFC PATCH 2/2] MIPS: Octeon: Use device tree to register serial
 ports.
References: <1300325167-26433-1-git-send-email-ddaney@caviumnetworks.com> <1300325167-26433-3-git-send-email-ddaney@caviumnetworks.com> <20110317182853.GO9597@angua.secretlab.ca>
In-Reply-To: <20110317182853.GO9597@angua.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Mar 2011 18:35:21.0863 (UTC) FILETIME=[12B9E970:01CBE4D2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2011 11:28 AM, Grant Likely wrote:
> On Wed, Mar 16, 2011 at 06:26:07PM -0700, David Daney wrote:
>> Switch to using the device tree to register serial ports.
>>
>> After the serial8250 driver indicates that it is initialized, add all
>> the ports with compatible = "cavium,octeon-3860-uart".  Octeon serial
>> ports have their own device type, required port flags, and I/O
>> functions, so using of_serial.c is not indicated.
>
> What specifically is the list extra settings needed to make of_serial
> work?  From what I can see in this driver, nothing looks particularly
> troublesome to handle.
>

Specifically:

+	port.flags = ASYNC_SKIP_TEST | UPF_SHARE_IRQ | UPF_FIXED_TYPE;
+	port.type = PORT_OCTEON;
+	port.serial_in = octeon_serial_in;
+	port.serial_out = octeon_serial_out;


This one is iffy:
+	port.uartclk = octeon_get_io_clock_rate();



Those octeon_serial_in() and octeon_serial_out() are chip specific code 
that does not belong in a generic driver file like of_serial.c

David Daney

> g.
>
>>
>> Signed-off-by: David Daney<ddaney@caviumnetworks.com>
>> ---
>>   arch/mips/cavium-octeon/serial.c |  140 ++++++++++++++++----------------------
>>   1 files changed, 60 insertions(+), 80 deletions(-)
>>
>> diff --git a/arch/mips/cavium-octeon/serial.c b/arch/mips/cavium-octeon/serial.c
>> index 057f0ae..28cacac 100644
>> --- a/arch/mips/cavium-octeon/serial.c
>> +++ b/arch/mips/cavium-octeon/serial.c
>> @@ -43,95 +43,75 @@ void octeon_serial_out(struct uart_port *up, int offset, int value)
>>   	cvmx_write_csr((uint64_t)(up->membase + (offset<<  3)), (u8)value);
>>   }
>>
>> -/*
>> - * Allocated in .bss, so it is all zeroed.
>> - */
>> -#define OCTEON_MAX_UARTS 3
>> -static struct plat_serial8250_port octeon_uart8250_data[OCTEON_MAX_UARTS + 1];
>> -static struct platform_device octeon_uart8250_device = {
>> -	.name			= "serial8250",
>> -	.id			= PLAT8250_DEV_PLATFORM,
>> -	.dev			= {
>> -		.platform_data	= octeon_uart8250_data,
>> -	},
>> -};
>> -
>> -static void __init octeon_uart_set_common(struct plat_serial8250_port *p)
>> +static int __devinit octeon_serial_probe(struct platform_device *pdev)
>>   {
>> -	p->flags = ASYNC_SKIP_TEST | UPF_SHARE_IRQ | UPF_FIXED_TYPE;
>> -	p->type = PORT_OCTEON;
>> -	p->iotype = UPIO_MEM;
>> -	p->regshift = 3;	/* I/O addresses are every 8 bytes */
>> +	int irq, res;
>> +	struct resource *res_mem;
>> +	struct uart_port port;
>> +
>> +	/* All adaptors have an irq.  */
>> +	irq = platform_get_irq(pdev, 0);
>> +	if (irq<  0)
>> +		return irq;
>> +
>> +	memset(&port, 0, sizeof(port));
>> +
>> +	port.flags = ASYNC_SKIP_TEST | UPF_SHARE_IRQ | UPF_FIXED_TYPE;
>> +	port.type = PORT_OCTEON;
>> +	port.iotype = UPIO_MEM;
>> +	port.regshift = 3;
>> +	port.dev =&pdev->dev;
>> +
>>   	if (octeon_is_simulation())
>>   		/* Make simulator output fast*/
>> -		p->uartclk = 115200 * 16;
>> +		port.uartclk = 115200 * 16;
>>   	else
>> -		p->uartclk = octeon_get_io_clock_rate();
>> -	p->serial_in = octeon_serial_in;
>> -	p->serial_out = octeon_serial_out;
>> -}
>> +		port.uartclk = octeon_get_io_clock_rate();
>>
>> -static int __init octeon_serial_init(void)
>> -{
>> -	int enable_uart0;
>> -	int enable_uart1;
>> -	int enable_uart2;
>> -	struct plat_serial8250_port *p;
>> +	port.serial_in = octeon_serial_in;
>> +	port.serial_out = octeon_serial_out;
>> +	port.irq = irq;
>>
>> -#ifdef CONFIG_CAVIUM_OCTEON_2ND_KERNEL
>> -	/*
>> -	 * If we are configured to run as the second of two kernels,
>> -	 * disable uart0 and enable uart1. Uart0 is owned by the first
>> -	 * kernel
>> -	 */
>> -	enable_uart0 = 0;
>> -	enable_uart1 = 1;
>> -#else
>> -	/*
>> -	 * We are configured for the first kernel. We'll enable uart0
>> -	 * if the bootloader told us to use 0, otherwise will enable
>> -	 * uart 1.
>> -	 */
>> -	enable_uart0 = (octeon_get_boot_uart() == 0);
>> -	enable_uart1 = (octeon_get_boot_uart() == 1);
>> -#ifdef CONFIG_KGDB
>> -	enable_uart1 = 1;
>> -#endif
>> -#endif
>> -
>> -	/* Right now CN52XX is the only chip with a third uart */
>> -	enable_uart2 = OCTEON_IS_MODEL(OCTEON_CN52XX);
>> -
>> -	p = octeon_uart8250_data;
>> -	if (enable_uart0) {
>> -		/* Add a ttyS device for hardware uart 0 */
>> -		octeon_uart_set_common(p);
>> -		p->membase = (void *) CVMX_MIO_UARTX_RBR(0);
>> -		p->mapbase = CVMX_MIO_UARTX_RBR(0)&  ((1ull<<  49) - 1);
>> -		p->irq = OCTEON_IRQ_UART0;
>> -		p++;
>> +	res_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +	if (res_mem == NULL) {
>> +		dev_err(&pdev->dev, "found no memory resource\n");
>> +		return -ENXIO;
>>   	}
>> +	port.mapbase = res_mem->start;
>> +	port.membase = ioremap(res_mem->start, resource_size(res_mem));
>>
>> -	if (enable_uart1) {
>> -		/* Add a ttyS device for hardware uart 1 */
>> -		octeon_uart_set_common(p);
>> -		p->membase = (void *) CVMX_MIO_UARTX_RBR(1);
>> -		p->mapbase = CVMX_MIO_UARTX_RBR(1)&  ((1ull<<  49) - 1);
>> -		p->irq = OCTEON_IRQ_UART1;
>> -		p++;
>> -	}
>> -	if (enable_uart2) {
>> -		/* Add a ttyS device for hardware uart 2 */
>> -		octeon_uart_set_common(p);
>> -		p->membase = (void *) CVMX_MIO_UART2_RBR;
>> -		p->mapbase = CVMX_MIO_UART2_RBR&  ((1ull<<  49) - 1);
>> -		p->irq = OCTEON_IRQ_UART2;
>> -		p++;
>> -	}
>> +	res = serial8250_register_port(&port);
>> +
>> +	return res>= 0 ? 0 : res;
>> +}
>> +
>> +static struct of_device_id octeon_serial_match[] = {
>> +	{
>> +		.compatible = "cavium,octeon-3860-uart",
>> +	},
>> +	{},
>> +};
>> +MODULE_DEVICE_TABLE(of, octeon_serial_match);
>>
>> -	BUG_ON(p>  &octeon_uart8250_data[OCTEON_MAX_UARTS]);
>> +static struct platform_driver octeon_serial_driver = {
>> +	.probe		= octeon_serial_probe,
>> +	.driver		= {
>> +		.owner	= THIS_MODULE,
>> +		.name	= "octeon_serial",
>> +		.of_match_table = octeon_serial_match,
>> +	},
>> +};
>>
>> -	return platform_device_register(&octeon_uart8250_device);
>> +static int octeon_serial_register_driver(struct notifier_block *nb,
>> +					 unsigned long code, void *arg)
>> +{
>> +	if (code == SERIAL8250_DRIVER_ADD)
>> +		platform_driver_register(&octeon_serial_driver);
>> +	return NOTIFY_OK;
>>   }
>>
>> -device_initcall(octeon_serial_init);
>> +static int __init octeon_serial_init(void)
>> +{
>> +	return serial8250_notifier(octeon_serial_register_driver, 0);
>> +}
>> +arch_initcall(octeon_serial_init);
>> --
>> 1.7.2.3
>>

