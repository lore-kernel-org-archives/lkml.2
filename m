Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab0H3QYu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 12:24:50 -0400
Received: from www.tglx.de ([62.245.132.106]:42857 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755934Ab0H3QYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 12:24:47 -0400
Date: Mon, 30 Aug 2010 18:24:35 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Armin Steinhoff <armin@steinhoff.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Hans J. Koch" <hjk@linutronix.de>
Subject: Re: UIO and Fedora 13  (kernel 33.6)
Message-ID: <20100830162435.GB2566@local>
References: <dda83e781002141023t2abe95b8w83f59d6f411f68a2@mail.gmail.com>
 <alpine.DEB.2.01.1002142229470.28195@bogon.housecafe.de>
 <dda83e781002142245l5c95d08bu214a796be289eb22@mail.gmail.com>
 <dda83e781002142246i61737ae2j4fe7efb660b53d07@mail.gmail.com>
 <4C7B8CA6.4010504@steinhoff.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C7B8CA6.4010504@steinhoff.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 12:49:10PM +0200, Armin Steinhoff wrote:
>  Hi,
> 
> I'm writing an UIO driver for a plain PC/104 board (ISA bus).
> After insmod <my_driver_mod> I don't see an entry of uio0 in /dev
> and also no entries in /sys/class. There are no error messages at
> module load.

Are you sure your probe() function is called? After a successfull
uio_register_device() there is both a /dev/uioX and a directory
/sys/class/uio/uioX/.

> 
> The same happens after loading the module uio.ko and uio_pdrv.ko ...
> no entries at all, no error messages.

uio_pdrv needs platform data set up somewhere, did you do that?
See docs in Documentation/DocBook/ for more details.

> 
> In the attachment is the kernel part of the driver. What could be
> the problem?

Some comments below.

> 
> --Armin
> 
> a-steinhoff-at-web-de

> /*
>  * UIO CAN L2
>  *
>  * (C) Armin Steinhoff <as@steinhoff-automation.com>
>  * (C) 2007 Hans J. Koch <hjk@linutronix.de>
>  * Original code (C) 2005 Benedikt Spranger <b.spranger@linutronix.de>
>  *
>  * Licensed under GPL version 2 only.
>  *
>  */
> 
> #include <linux/device.h>
> #include <linux/module.h>
> #include <linux/uio_driver.h>
> #include <linux/platform_device.h>
> #include <linux/moduleparam.h>
> #include <asm/io.h>

#include <linux/io.h>, please.

> 
> #define DEBUG 1

What's that used for?

> #define DRIVER_MAJOR 240

not needed.

> #define INT_QUEUE_SIZE 64

What's that used for?

> 
> static struct uio_info *info;

Are you sure you can have only one instance of this driver?

> static unsigned char int_x[2], * int_q[2];

No space between * and variable name. There are more cases below.
Please run your patch through checkpatch.pl and fix the issues.

> static	void __iomem *isr[2]; 
> 
> static unsigned int irq = 11;
> module_param (irq, uint, 11);
> MODULE_PARM_DESC (irq, "IRQ (default 11)");
> 
> static unsigned long base_addr = 0xd00000;
> module_param (base_addr, ulong, 0xd00000);
> MODULE_PARM_DESC (base_addr, "Base address (default 0xD0000)");
> 
> static unsigned long base_len;
> module_param (base_len, ulong, 0x1);
> MODULE_PARM_DESC (base_len, "Base length (default 0x1)");
> 
> static struct platform_device * uio_jand_device;
> static int jand_probe(struct device *dev);
> static int jand_remove(struct device *dev);

These declarations are not neeeded...

> 
> static struct device_driver uio_jand_driver = 
> {
>  .name   = "uio_jand",
>  .bus    = &platform_bus_type,
>  .probe  = jand_probe,
>  .remove = jand_remove,
> };

...if you move this struct to the end of the file.

> 
> static irqreturn_t int_handler(int irq, struct uio_info *dev_info)
> {
>     int irq_flag = 0;
> 	unsigned char ISRstat;
> 	
> 	ISRstat = readb(isr[0]);
> 	if(ISRstat & 0x02)
> 	{
> 		int_q[0][int_x[0]] = ISRstat;
> 		int_x[0] = (int_x[0] + 1) & 0xF ; // modulo 16
> 		
> 		irq_flag = 1;
> 	}
> 
> 	ISRstat = readb(isr[1]);
> 	if(ISRstat & 0x02)
> 	{
> 		int_q[1][int_x[1]] = ISRstat;
> 		int_x[1] = (int_x[1] + 1) & 0xF ; // modulo 16
> 		irq_flag = 1;
> 	}
> 	
> 	if(irq_flag)
> 		return(IRQ_HANDLED);
> 	else
> 		return(IRQ_NONE);
> }
> 
> static int jand_probe(struct device *dev)
> {	
> 	info = kzalloc(sizeof(struct uio_info), GFP_KERNEL);

	info should be a local variable. If you probe the driver twice
	you'll overwrite the previous value of info and cause a memory leak.

> 	if (!info)
> 	{
> 		return -ENOMEM;
> 	}
> 	
> 	info->mem[0].addr = base_addr;
> 	info->mem[0].size = base_len;
> 	info->mem[0].memtype = UIO_MEM_PHYS;
> 	
> 	info->mem[0].internal_addr = ioremap(info->mem[0].addr,info->mem[0].size);
> 	if (!info->mem[0].internal_addr)
> 		goto out_release;
> 		
> 	/* interrupt queue */

	What does this comment mean?

> 	info->mem[1].addr = (unsigned long)kmalloc(64, GFP_KERNEL);	
> 	if (!info->mem[1].addr)
> 		goto out_release1;
> 	
> 	int_q[0] = (unsigned char * )info->mem[1].addr;
> 	int_q[1] = (unsigned char * )info->mem[1].addr +32;
> 	
> 	memset(&int_q[0], 0x00, 16);
> 	int_x[0] = 0;
> 	memset(&int_q[1], 0x00, 16);
> 	int_x[1] = 0;
> 
> 	info->mem[1].memtype = UIO_MEM_LOGICAL;
> 	info->mem[1].size = 64;
> 	
> 	isr[0] = info->mem[0].internal_addr + 3;	        /* interrupt reg channel 1 */
> 	isr[1] = info->mem[0].internal_addr + 3 + 0x200;	/* interrupt reg channel 2 */
> 	
> 	info->name = "uio_jand";	
> 	info->version = "0.0.1";
> 	info->irq = irq;
> 	info->irq_flags = 0;
> 	info->handler = int_handler;
> 
> 	if (uio_register_device(dev, info))
> 		goto out_release2;
> 	printk("uio_jand started!\n");

please use dev_info instead of printk

> 	return 0;
> 	
> 	
> out_release2:
> 	kfree((void *)info->mem[1].addr);
> 	printk("uio_register_device failed!\n");

dev_err please.

> out_release1:	
> 	free_irq( irq, "uio_jand" );	
> 	iounmap(info->mem[0].internal_addr);		
> 	release_mem_region( base_addr, base_len);
> out_release:	
> 	kfree (info);
>     printk("Error exit ENODEV! \n");

dev_err and correct indentation, please.

> 	return -ENODEV;
> }
> 
> static int jand_remove(struct device *dev)
> {
> 	uio_unregister_device(info);
> 	iounmap(info->mem[0].internal_addr);
> 	release_mem_region( base_addr, base_len);
> 	free_irq( irq, "uio_jand" );		
> 	kfree((void *)info->mem[1].addr);
> 	kfree (info);
> 	return 0;
> }
> 
> 
> static int __init uio_jand_init(void)
> {
> 	uio_jand_device = platform_device_register_simple("uio_jand", -1,NULL, 0);
> 	return driver_register(&uio_jand_driver);

Please check the return value of both *_register calls.

> }
> 
> static void __exit uio_jand_exit(void)
> {
> 	platform_device_unregister(uio_jand_device);
> 	driver_unregister(&uio_jand_driver);
> }
> 
> module_init( uio_jand_init );
> module_exit( uio_jand_exit );
> 
> MODULE_LICENSE("GPL");
> MODULE_AUTHOR("A. Steinhoff");
> MODULE_DESCRIPTION("UIO Janus-D CAN driver");

If "CAN" means "Controller Area Network" it should probably be a
socketcan driver instead of UIO...

Thanks,
Hans
