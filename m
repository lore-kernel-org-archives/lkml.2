Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253Ab0IAHbM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 03:31:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:62827 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab0IAHbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 03:31:10 -0400
Message-ID: <4C7E015B.1010506@steinhoff.de>
Date: Wed, 01 Sep 2010 09:31:39 +0200
From: Armin Steinhoff <armin@steinhoff.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2 ThunderBrowse/3.3.2
MIME-Version: 1.0
To: "Hans J. Koch" <hjk@linutronix.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: UIO and Fedora 13  (kernel 33.6)
References: <dda83e781002141023t2abe95b8w83f59d6f411f68a2@mail.gmail.com> <alpine.DEB.2.01.1002142229470.28195@bogon.housecafe.de> <dda83e781002142245l5c95d08bu214a796be289eb22@mail.gmail.com> <dda83e781002142246i61737ae2j4fe7efb660b53d07@mail.gmail.com> <4C7B8CA6.4010504@steinhoff.de> <20100830162435.GB2566@local> <4C7CA7E4.8010005@steinhoff.de> <20100831103523.GA2598@local>
In-Reply-To: <20100831103523.GA2598@local>
Content-Type: multipart/mixed;
 boundary="------------040602060709020407070208"
X-Provags-ID: V02:K0:jE1iBuyTum7Qh4aKzu+QRFGcDJlKm5a9m7WZ0nKF5Ih
 4xa+9MtHOWC9iHpqeukzqTVJUKOZTtKz6tqZ3Kki1BjUTNvtVb
 S0qC12qmGSeNUbte/eW0f4jnch7o4rUrr+XLPj0JxY03xigDDR
 VD3mVKjIXMrSbPc8b5+HqT/Pt+ViPtRzdIWqDnXIhuGrT6Vo4A
 gS7ZYJ0u68+y9rok1sDKw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040602060709020407070208
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit


Small correction ... I don't mean the "initial platform_data" but the 
initial resource data of the platform driver.

--Armin


   Hans J. Koch wrote:
> After a successfull uio_register_device() there is both a /dev/uioX
> and a directory /sys/class/uio/uioX/.

In the attachment is an updated version of uio_jand.

The module uio_jand.ko can be inserted and removed,  no messages visible 
by dmesg, no kernel oops, no dev/uio*  and no class entries available.

There are only entries of uio_jand in /sys/module, 
/sys/bus/platform/drivers and /sys/uio/holders ... I'm really confused =:-/

It's completely unclear how to write the initial platform_data of the 
platform device in the example uio_smx.c :

      regs = platform_get_resource(dev, IORESOURCE_MEM, 0);
      if (!regs) {
          dev_err(&dev->dev, "No memory resource specified\n");
          goto out_free;

Same issue in uio_platform_genirq ...

Cheers

--Armin






--------------040602060709020407070208
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
#include <linux/ioport.h>
#include <linux/device.h>
#include <linux/uio_driver.h>
#include <linux/platform_device.h>
#include <linux/moduleparam.h>
#include <linux/io.h>


#define INT_QUEUE_SIZE 64

static unsigned char int_x[2], * int_q[2];
static	void __iomem *isr[2]; 

static unsigned int irq = 11;
module_param (irq, uint, 0);
MODULE_PARM_DESC (irq, "IRQ (default 11)");

static unsigned long base_addr = 0xd00000;
module_param (base_addr, ulong, 0);
MODULE_PARM_DESC (base_addr, "Base address (default 0xD0000)");

static unsigned long base_len;
module_param (base_len, ulong, 0);
MODULE_PARM_DESC (base_len, "Base length (default 0x1)");

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

static int jand_probe(struct platform_device *dev)
{	
	struct uio_info *info;
	
	dev_info(&dev->dev, "start probe %d\n", 1);
	info = kzalloc(sizeof(struct uio_info), GFP_KERNEL);
	if (!info)
	{
		return -ENOMEM;
	}
	
	info->mem[0].addr = base_addr;
	info->mem[0].size = base_len;
	info->mem[0].memtype = UIO_MEM_PHYS;
	
	if(request_mem_region( info->mem[0].addr, info->mem[0].size, "uio_jand"))
	{
		dev_err(&dev->dev, "request_mem_region failed %d\n", 2);
		goto out_release;
	}
	
	info->mem[0].internal_addr = ioremap(info->mem[0].addr,info->mem[0].size);
	if (!info->mem[0].internal_addr)
	{
		dev_err(&dev->dev, "ioremap failed %d\n", 3);
		goto out_release;
	}
		
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
	if( request_irq(irq, int_handler, IRQF_DISABLED,"uio_jand", NULL) ) 
	{
		goto out_release2;
	}
	
	info->name = "uio_jand";	
	info->version = "0.0.2";
	info->irq = irq;
	info->irq_flags = 0;
	info->handler = int_handler; // different ptr types ?
	
	platform_set_drvdata(dev, info);
	
	if (uio_register_device(&dev->dev, info))
	{
		dev_err(&dev->dev, "uio_register_device failed %d\n", 4);
		goto out_release2;
	}

	dev_info(&dev->dev, "uio_jand started! %d\n", 5);
	return 0;
	
	
out_release2:
	kfree((void *)info->mem[1].addr);
	dev_err(&dev->dev, "uio_register_device failed %d \n", 6);
out_release1:	
	free_irq( irq, "uio_jand" );	
	iounmap(info->mem[0].internal_addr);		
	release_mem_region( base_addr, base_len);
out_release:	
	kfree (info);
    dev_err(&dev->dev, "Error exit ENODEV! %d\n", 7);
	return -ENODEV;
}

static int jand_remove(struct platform_device *dev)
{
	struct uio_info *info = platform_get_drvdata(dev);
	
	uio_unregister_device(info);
	iounmap(info->mem[0].internal_addr);
	release_mem_region( base_addr, base_len);
	free_irq( irq, "uio_jand" );		
	kfree((void *)info->mem[1].addr);
	kfree (info);
	return 0;
}

static struct platform_driver uio_jand_driver = {
	 .probe  = jand_probe,
     .remove = jand_remove,
     .driver = {
	 .name	= "uio_jand",
     .owner	= THIS_MODULE,
      },
};

static int __init uio_jand_init(void)
{
	return platform_driver_register(&uio_jand_driver);
}

static void __exit uio_jand_exit(void)
{
	platform_driver_unregister(&uio_jand_driver);
}

module_init( uio_jand_init );
module_exit( uio_jand_exit );

MODULE_LICENSE("GPL");
MODULE_AUTHOR("A. Steinhoff");
MODULE_DESCRIPTION("UIO Janus-D CAN driver");


--------------040602060709020407070208--
