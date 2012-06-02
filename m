Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966238Ab2FBCUw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 22:20:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33241 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760307Ab2FBCUv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 22:20:51 -0400
MIME-Version: 1.0
In-Reply-To: <CAKB833k7pNMF7+37nCx0GkBqxCBuBx5yffFB5z2shosDVh6HhQ@mail.gmail.com>
References: <CAKB833k7pNMF7+37nCx0GkBqxCBuBx5yffFB5z2shosDVh6HhQ@mail.gmail.com>
Date: Sat, 2 Jun 2012 07:50:50 +0530
Message-ID: <CAKB833=F-Tkss-opb62eeF-zdGdXpG_Z=ONRazdGG1-gF1RidQ@mail.gmail.com>
Subject: Need help regarding parallel port interrupt in kernel 3.2
From: Vishal Nandanwar <operational.people@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am working on a parallel port code, in which I want to achieve the
interrupt on pin 10. I have created a sample circuit as mentioned in
Book LDD. I have connected pin 9 to pin 10 and writing 0x00 and 0xFF
on the port to generate interrupt.

I have created one sample code.

##--------------------------------------------------------------------------------------------------------------------------------
[Code]
#include<linux/init.h>
#include<linux/module.h>
#include<linux/fs.h>
#include<linux/cdev.h>
#include<linux/slab.h>
#include<linux/io.h>
#include<linux/ioport.h>
#include<linux/interrupt.h>
#include<asm/uaccess.h>
#include<asm/irq.h>

#include "parportD.h"

MODULE_LICENSE("Dual BSD/GPL");

int parportD_minor, parportD_major, parportD_count;
struct cdev *parportD_cdev;
dev_t dev = 0;
int flag;
int intID = 3;
int s = 0;
struct resource *res;
unsigned long portID = 0x378;
unsigned long length = 0x08;

struct file_operations cDevice_fops = {
       .owner = THIS_MODULE,
       .read = parportD_read,
       .write = parportD_write,
       .open = parportD_open,
       .release = parportD_release,
};

irqreturn_t intHandle(int irq, void *dev_id)
{
       printk("Interrupt occured.");
       s = 1;
       outb_p(0x00, portID + 2);
       outb_p(0x10, portID + 2);


       return IRQ_HANDLED;
}

static int parportD_init(void) {

       int retVal, err;

       printk("parportD initialization started.\n");

       parportD_count = 0x01;
       parportD_minor = 0x00;

/*      res = request_region(portID, length ,"parportD");
       if (res == NULL) {
               printk(KERN_NOTICE "Port allocation failed.");
               return -1;
       }*/

       retVal = alloc_chrdev_region(&dev, parportD_minor, 1, "parportD");
       if (retVal != 0x00) {
               printk(KERN_NOTICE "chrdev region allocation failed.");
               return -1;
       }

       parportD_major = MAJOR(dev);
       parportD_minor = MINOR(dev);

       printk("retVal = %d\n", retVal);
       printk("Major number = %d\n", parportD_major);
       printk("Minor number = %d\n", parportD_minor);
       printk("Device count = %d\n", parportD_count);

       parportD_cdev = cdev_alloc();

       cdev_init(parportD_cdev, &cDevice_fops);
       parportD_cdev->owner = THIS_MODULE;
       err = cdev_add(parportD_cdev, dev, 1);
       if (err < 0) {
               printk(KERN_NOTICE "Error %d adding parportD", err);
       } else {
               printk("parportD initialization completed.\n");
       }

       //request IRQ
       retVal = request_irq(intID, intHandle, IRQF_DISABLED, "parportD", NULL);

       printk("Interrupt request return value = %d\n", retVal);

       if (retVal ) {
           printk("Interrupt request failed. = %d\n", retVal);
       } else {
         //enable intrrupts
         outb(0x10, portID+2);
          printk("Interrupt enabled.\n");
       }

       return 0;
}

static void parportD_exit(void) {
       printk("parportD exit started.\n");
       cdev_del(parportD_cdev);
       free_irq(intID, NULL);
       release_region(0x378, 8);

       printk("parportD exit completed.\n");
}

int parportD_open(struct inode *inode, struct file *filep) {
       int retVal = 0x00;
       printk("parportD opend.\n");

       return retVal;
}

int parportD_release(struct inode *inode, struct file *filep) {
       printk("\nparportD released.\n");
       return 0x00;
}

ssize_t parportD_read(struct file *filep, char *buf, size_t count,
loff_t *f_pos) {
       /*ssize_t retVal = 0x00;
       printk("Device read received.\n");

       retVal = copy_to_user((void *)buf, (void*)data, count);
       printk("Device read = %s ratVal = %d count = %d \n", buf,
retVal, count);*/

       return count;
}

ssize_t parportD_write(struct file *filep, const char *buf, size_t
count, loff_t *f_pos) {
       printk("Device write received.\n");
       printk("s = %d\n", s);

       if(flag == 0) {
               flag = 1;
               outb(0, portID);
               printk("Wrote 0 on port. \n");
       } else {
               flag = 0;
               outb(255, portID);
               printk("Wrote 255 on port. \n");
       }

       printk("Data received = %s", buf);

       return count;
}

module_init(parportD_init);
module_exit(parportD_exit);
[/Code]
##------------------------------------------------------------------------------------------------------------------------------

Problem here is, I am not getting interrupt or my interrupt handler is
not executing. I wonder do we need to do any setting in BIOS for this
interrupt? Or do we need to enable any flag during kernel compilation?

Vishal N
