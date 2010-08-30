Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab0H3Ksx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 06:48:53 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:59676 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab0H3Ksw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 06:48:52 -0400
Message-ID: <4C7B8CA6.4010504@steinhoff.de>
Date: Mon, 30 Aug 2010 12:49:10 +0200
From: Armin Steinhoff <armin@steinhoff.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2 ThunderBrowse/3.3.2
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: "Hans J. Koch" <hjk@linutronix.de>
Subject: UIO and Fedora 13  (kernel 33.6)
References: <dda83e781002141023t2abe95b8w83f59d6f411f68a2@mail.gmail.com>	 <alpine.DEB.2.01.1002142229470.28195@bogon.housecafe.de>	 <dda83e781002142245l5c95d08bu214a796be289eb22@mail.gmail.com> <dda83e781002142246i61737ae2j4fe7efb660b53d07@mail.gmail.com>
In-Reply-To: <dda83e781002142246i61737ae2j4fe7efb660b53d07@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------030802010705040901000408"
X-Provags-ID: V02:K0:I9sUUpskqR4J/JEVk/4PetrRaqbmSkJR2YAW/q4xM9T
 CUUP5asiE2J+cr7watZHd5+4huYMvJ+1HPtA/2Py6aBbcZ0Y6l
 vL88B2ZklPjqwALOJG39thqUi6+OD11HS3ygLhUndZVR9j98g2
 VSDNSTrcwWXBPx2epCCHz7Le09cflzykxfwEBwj4iuK3zGQ0AW
 43OTHp2/JdKntg2wC6wjg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030802010705040901000408
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

  Hi,

I'm writing an UIO driver for a plain PC/104 board (ISA bus).
After insmod <my_driver_mod> I don't see an entry of uio0 in /dev and 
also no entries in /sys/class. There are no error messages at module load.

The same happens after loading the module uio.ko and uio_pdrv.ko ... no 
entries at all, no error messages.

In the attachment is the kernel part of the driver. What could be the 
problem?

--Armin

a-steinhoff-at-web-de

--------------030802010705040901000408
Content-Type: text/x-csrc;
 name="uio_jand.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="uio_jand.c"

/*
 * UIO CAN L2
 *
 * (C) Armin Steinhoff <as@steinhoff-automation.com>
 * (C) 2007 Hans J. Koch <hjk@linutronix.de>
 * Original code (C) 2005 Benedikt Spranger <b.spranger@linutronix.de>
 *
 * Licensed under GPL version 2 only.
 *
 */

#include <linux/device.h>
#include <linux/module.h>
#include <linux/uio_driver.h>
#include <linux/platform_device.h>
#include <linux/moduleparam.h>
#include <asm/io.h>

#define DEBUG 1
#define DRIVER_MAJOR 240
#define INT_QUEUE_SIZE 64

static struct uio_info *info;
static unsigned char int_x[2], * int_q[2];
static	void __iomem *isr[2]; 

static unsigned int irq = 11;
module_param (irq, uint, 11);
MODULE_PARM_DESC (irq, "IRQ (default 11)");

static unsigned long base_addr = 0xd00000;
module_param (base_addr, ulong, 0xd00000);
MODULE_PARM_DESC (base_addr, "Base address (default 0xD0000)");

static unsigned long base_len;
module_param (base_len, ulong, 0x1);
MODULE_PARM_DESC (base_len, "Base length (default 0x1)");

static struct platform_device * uio_jand_device;
static int jand_probe(struct device *dev);
static int jand_remove(struct device *dev);

static struct device_driver uio_jand_driver = 
{
 .name   = "uio_jand",
 .bus    = &platform_bus_type,
 .probe  = jand_probe,
 .remove = jand_remove,
};

static irqreturn_t int_handler(int irq, struct uio_info *dev_info)
{
    int irq_flag = 0;
	unsigned char ISRstat;
	
	ISRstat = readb(isr[0]);
	if(ISRstat & 0x02)
	{
		int_q[0][int_x[0]] = ISRstat;
		int_x[0] = (int_x[0] + 1) & 0xF ; // modulo 16
		
		irq_flag = 1;
	}

	ISRstat = readb(isr[1]);
	if(ISRstat & 0x02)
	{
		int_q[1][int_x[1]] = ISRstat;
		int_x[1] = (int_x[1] + 1) & 0xF ; // modulo 16
		irq_flag = 1;
	}
	
	if(irq_flag)
		return(IRQ_HANDLED);
	else
		return(IRQ_NONE);
}

static int jand_probe(struct device *dev)
{	
	info = kzalloc(sizeof(struct uio_info), GFP_KERNEL);
	if (!info)
	{
		return -ENOMEM;
	}
	
	info->mem[0].addr = base_addr;
	info->mem[0].size = base_len;
	info->mem[0].memtype = UIO_MEM_PHYS;
	
	info->mem[0].internal_addr = ioremap(info->mem[0].addr,info->mem[0].size);
	if (!info->mem[0].internal_addr)
		goto out_release;
		
	/* interrupt queue */
	info->mem[1].addr = (unsigned long)kmalloc(64, GFP_KERNEL);	
	if (!info->mem[1].addr)
		goto out_release1;
	
	int_q[0] = (unsigned char * )info->mem[1].addr;
	int_q[1] = (unsigned char * )info->mem[1].addr +32;
	
	memset(&int_q[0], 0x00, 16);
	int_x[0] = 0;
	memset(&int_q[1], 0x00, 16);
	int_x[1] = 0;

	info->mem[1].memtype = UIO_MEM_LOGICAL;
	info->mem[1].size = 64;
	
	isr[0] = info->mem[0].internal_addr + 3;	        /* interrupt reg channel 1 */
	isr[1] = info->mem[0].internal_addr + 3 + 0x200;	/* interrupt reg channel 2 */
	
	info->name = "uio_jand";	
	info->version = "0.0.1";
	info->irq = irq;
	info->irq_flags = 0;
	info->handler = int_handler;

	if (uio_register_device(dev, info))
		goto out_release2;
	printk("uio_jand started!\n");
	return 0;
	
	
out_release2:
	kfree((void *)info->mem[1].addr);
	printk("uio_register_device failed!\n");
out_release1:	
	free_irq( irq, "uio_jand" );	
	iounmap(info->mem[0].internal_addr);		
	release_mem_region( base_addr, base_len);
out_release:	
	kfree (info);
    printk("Error exit ENODEV! \n");
	return -ENODEV;
}

static int jand_remove(struct device *dev)
{
	uio_unregister_device(info);
	iounmap(info->mem[0].internal_addr);
	release_mem_region( base_addr, base_len);
	free_irq( irq, "uio_jand" );		
	kfree((void *)info->mem[1].addr);
	kfree (info);
	return 0;
}


static int __init uio_jand_init(void)
{
	uio_jand_device = platform_device_register_simple("uio_jand", -1,NULL, 0);
	return driver_register(&uio_jand_driver);
}

static void __exit uio_jand_exit(void)
{
	platform_device_unregister(uio_jand_device);
	driver_unregister(&uio_jand_driver);
}

module_init( uio_jand_init );
module_exit( uio_jand_exit );

MODULE_LICENSE("GPL");
MODULE_AUTHOR("A. Steinhoff");
MODULE_DESCRIPTION("UIO Janus-D CAN driver");

--------------030802010705040901000408--
