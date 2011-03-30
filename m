Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739Ab1C3KHe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 06:07:34 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49911 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431Ab1C3KHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 06:07:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=AfVhWZM/6W8DyIFEAogMVD9P2FC5g29iJNDQyuKuu95itSBwRQeasvJdKo/rWUevla
         rNixCxaGiOPdHnDsH1drs/tlDkeXnh5zCL9IAb7PCwpc1wiz+qzsZPc8oyh7vZDj3D1M
         565VgzUmfqFkhpo8hcYs4CpGZM6NYjQ8YtziE=
MIME-Version: 1.0
Date: Wed, 30 Mar 2011 07:07:32 -0300
Message-ID: <AANLkTim3eMR+5VQT9Cbew70bLZ_3P7eo3FXx_TxMuP1=@mail.gmail.com>
Subject: Help with dma on PCI driver
From: Luis Filipe Rossi <luisf.rossi@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tryied to post this on using google groups, but as i had some
filtering problem on other lists, i am sending using the direct
e-mail. Please answer direct to me as i am not subscribed (i am trying
to use a newsreader). Sorry if i am missing any information. If so,
please just tell me what so i can provide it.

I am developing a driver for a custom PCI board. I am following the
example on Essential Linux Device Drivers, but when i am calling the
pci_alloc_consitent i get the following error:
Mar 29 15:18:42 luis-desktop kernel: [ 4520.075823] BUG: unable to
handle kernel NULL pointer dereference at 00000004
Mar 29 15:18:42 luis-desktop kernel: [ 4520.078277] IP: [<c010797f>]
dma_generic_alloc_coherent+0xaf/0xc0
Mar 29 15:18:42 luis-desktop kernel: [ 4520.078277] *pde = 0a417067
*pte = 00000000
Mar 29 15:18:42 luis-desktop kernel: [ 4520.078277] Oops: 0002 [#1] SMP

I am running on a x86 (Pentium III) with Ubuntu Kernel 2.6.32-24
I tryed to take a look at ldd3 but no answer so far...

The idea is to alloc a buffer so my PCI card can master the bus and
place the data on that buffer....

The driver code is:

//*

 * pci_bridge-driver.c - template Linux driver for the opencores' pci
bridge . Works on * kernel 2.6.x

 *

 * tested on Xubuntu, kernel 2.6.20-15-generic

 *

 *

 * Permission to use, copy, modify, and distribute this software for any

 * purpose with or without fee is hereby granted.

 *

 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR

 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,

 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF THIRD PARTY

 * RIGHTS. IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES

 * OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,

 * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR

 * OTHER DEALINGS IN THE SOFTWARE.

 */



/*

 * Build/use notes (you'll probably need to be superuser to run most of

 * the steps below):

 *

 * 1) How to build the driver:

 *

 *      $ make

 *

 * 2) How to install the driver:

 *

 *      $ insmod pci_bridge-driver.ko

 *

 * TODO: change the code and use misc device and udev, so to avoid the
stuff below (3-4) !!

 * 3) If pci_bridge_init_major (below) is 0, then obtain the major number:

 *

 *      $ cat /proc/devices

 *

 * Look for the line that contains the string "pci_bridge". The major

 * number is to the left.

 *

 * 4) Make the pci_bridge device special file. Substitute the major

 * number obtained above for <major_number>.

 *

 *      $ mknod /dev/pci_bridge c <major_number> 0

 *

 * 5) How to remove the driver:

 *

 *      $ rmmod pci_bridge-driver

 */



#include <linux/kernel.h>

#include <linux/module.h>

#include <linux/pci.h>

#include <linux/init.h>

#include <linux/cdev.h>

#include <linux/fs.h>

#include <linux/ioctl.h>



//#include <asm/byteorder.h>              /* PCI is little endian */

#include <asm/uaccess.h>                /* copy to/from user */



#include "kint.h"



#define PCI_BRIDGE_DEVICE_ID 0x0001

#define PCI_BRIDGE_VENDOR_ID 0x1895

#define PCI_DRIVER_NAME "pci_bridge" /* driver name */

#define BRIDGE_MEM_MAPPED 0

#define BRIDGE_IO_MAPPED 1



/*

 * PCI device IDs supported by this driver. The PCI_DEVICE macro sets

 * the vendor and device fields to its input arguments, sets subvendor

 * and subdevice to PCI_ANY_ID. It does not set the class fields.

 */

static struct pci_device_id pci_bridge_ids[] =

{

	{ PCI_DEVICE(PCI_BRIDGE_VENDOR_ID, PCI_BRIDGE_DEVICE_ID), },

	{ 0, }

};



/*

 * For completeness, tell the module loading and hotplug systems

 * what PCI devices this module supports.

 */

MODULE_DEVICE_TABLE(pci, pci_bridge_ids);



/*

 * pci_register_driver parameter.

 */

static int pci_bridge_probe(struct pci_dev *, const struct pci_device_id *);

static void pci_bridge_remove(struct pci_dev *);



static struct pci_driver pci_bridge_driver =

{

	.name = PCI_DRIVER_NAME,

	.id_table = pci_bridge_ids,

	.probe = pci_bridge_probe,

	.remove = pci_bridge_remove,

};



/*

 * File operations i/f.

 */

int pci_bridge_open(struct inode *, struct file *);

int pci_bridge_release(struct inode *, struct file *);

ssize_t pci_bridge_read(struct file *, char __user *, size_t, loff_t *);

ssize_t pci_bridge_write(struct file *, const char __user *, size_t, loff_t *);

int pci_bridge_ioctl(struct inode *pnode, struct file *filp, unsigned
int cmd, unsigned long arg);

// seek file operation function

loff_t  bridge_lseek(struct file *filp, loff_t offset, int origin);



static void dma_descriptor_release(struct pci_dev *pdev);

static void dma_descriptor_setup(struct pci_dev *pdev);





static struct file_operations pci_bridge_fops =

{

	read: pci_bridge_read,

	write: pci_bridge_write,

	open: pci_bridge_open,

	release: pci_bridge_release,

	ioctl: pci_bridge_ioctl,

	llseek: bridge_lseek

};





static int __init pci_bridge_init(void);

static void __exit pci_bridge_exit(void);



/*

 * Driver major number. 0 = allocate dynamically.

 */

static int pci_bridge_init_major = 0;

static int pci_bridge_major;



/*

 * Per-device structure.

 */

static struct pci_bridge_dev

{

	struct cdev cdev;               /* Char device structure        */

	struct pci_dev *pcidev;         /* PCI device pointer           */

	int current_resource;

	u32 page_addr;

	u8 num_of_bases;

	int base_map[6];

	u32 bases[6];	

	u32 base_size[6];

	u32 base_page_offset;

	u32 offset;

	u8  interrupt_line;

} *pci_bridge_devices;



static struct device_data

{

	void *dma_buffer_rx;

	dma_addr_t dma_bus_rx;

	void *dma_buffer_tx;

	dma_addr_t dma_bus_tx;

}*c_memory_map;



/*

 * pci_bridge_probe - pci_driver probe function. Just enable the PCI device.

 * Could also check various configuration registers, find a specific PCI

 * device, request a specific region, etc.

 */

static int pci_bridge_probe(struct pci_dev *pcidev, const struct
pci_device_id *id)

{

	struct pci_bridge_dev *dev;

	printk("pci_bridge_probe called ...\n");

	if(pcidev == NULL)

	{

        	printk(KERN_NOTICE "pci_bridge_probe: PCI DEV is NULL\n");

        	return -EINVAL;

	}



	dev = pci_bridge_devices; // only one device for now

	if(dev == NULL)

		printk("pci_bridge_probe: device structure not allocated\n");

	else

	{

		pci_enable_device(pcidev);

		pci_set_master(pcidev);

		dev->pcidev = pcidev;

	}



	return 0;

}



/*

 * pci_bridge_remove - pci_driver remove function. Release allocated resources,

 * etc.

 */

static void __devexit pci_bridge_remove(struct pci_dev *dev)

{

    printk("pci_bridge_remove called ...\n");

}



/*

 * pci_bridge_init - module init function. By convention, the function is

 * declared static, even though it is not exported to the rest of the

 * kernel unless explicitly requested via the EXPORT_SYMBOL macro. The

 * __init qualifier tells the loader that the function is only used at

 * module initialization time.

 */

static int __init pci_bridge_init(void)

{

	struct pci_bridge_dev *dev;

	dev_t devno;

	int result;

	unsigned short num_of_bases;

	u32 base_address;

	printk("pci_bridge_init called ...\n");

	

	/*

	* Allocate the per-device structure(s).

	*/

	pci_bridge_devices = kmalloc(sizeof(struct pci_bridge_dev), GFP_KERNEL);

	if(pci_bridge_devices == NULL)

	{

		result = -ENOMEM;

		goto fail;

	}



	/*

	* Get a range of minor numbers to work with, asking for a dynamic

	* major unless directed otherwise at load time.

	*/

	if(pci_bridge_init_major)

	{

		pci_bridge_major = pci_bridge_init_major;

		devno = MKDEV(pci_bridge_major, 0);

		result = register_chrdev_region(devno, 1, PCI_DRIVER_NAME);

	}

	else

	{

		result = alloc_chrdev_region(&devno, 0, 1, PCI_DRIVER_NAME);

		pci_bridge_major = MAJOR(devno);

	}

	if(result < 0)

	{

		printk(KERN_NOTICE "pci_bridge: can't get major %d\n", pci_bridge_major);

		goto fail;

	}



	dev = pci_bridge_devices;/* only one device for now */



	/*

	* Initialize and add this device's character device table entry.

	*/

	dev->pcidev = NULL;

	cdev_init(&dev->cdev, &pci_bridge_fops);

	dev->cdev.owner = THIS_MODULE;

	dev->cdev.ops = &pci_bridge_fops;

	dev->offset = 0;

	result = cdev_add(&dev->cdev, devno, 1);

	if(result)

	{

		printk(KERN_NOTICE "Error %d adding %s device", result, PCI_DRIVER_NAME);

		goto fail;

	}

	

	if((result = pci_register_driver(&pci_bridge_driver)) != 0)

	{

		printk(KERN_NOTICE "Error %d registering %s PCI device",result,
PCI_DRIVER_NAME);

		goto fail;

	}

	

	if(dev->pcidev == NULL)

	{

		printk(KERN_NOTICE "PCI DEV is NULL, probe failed?\n");

		goto fail;

	}



	base_address = pci_resource_start(dev->pcidev, 0);



	printk("<1> First base address register found at %08X \n ",
pci_resource_start(dev->pcidev, 0));

	num_of_bases = 0;



	while

	((base_address = pci_resource_start(dev->pcidev, num_of_bases))!=
0x00000000 && (num_of_bases < 6))

	{

		unsigned long flags;

		flags = pci_resource_flags(dev->pcidev, num_of_bases);

		dev->bases[num_of_bases] = base_address;

		dev->base_size[num_of_bases] = pci_resource_end(dev->pcidev,
num_of_bases) - base_address + 1;

		// check if resource is IO mapped

		if (flags & IORESOURCE_IO)

		    dev->base_map[num_of_bases] = BRIDGE_IO_MAPPED;

		else

		    dev->base_map[num_of_bases] = BRIDGE_MEM_MAPPED;	

		num_of_bases++;

	}



	if (num_of_bases < 1)

		printk("<1>No implemented base address registers found! \n ");



	dev->current_resource = - 1;



	// store number of bases in structure

	dev->num_of_bases = num_of_bases;

	printk("num_of_bases found %d \n", num_of_bases);

	// display information about all base addresses found in this procedure

	for (num_of_bases = 0; num_of_bases < dev->num_of_bases; num_of_bases++)

	{

		printk("<1>BAR%d range from %08X to %08X \n ", num_of_bases,
dev->bases[num_of_bases], dev->bases[num_of_bases] +
dev->base_size[num_of_bases]);

	}

	

	if(pci_read_config_byte(dev->pcidev,PCI_INTERRUPT_LINE, &dev->interrupt_line))

	{

		printk("Could not get interrupt line");

		}

	else

	{

		printk("Interrupt Line is %d \n", dev->interrupt_line);

		}

	dma_descriptor_setup(dev->pcidev);

	



	return 0;

	

fail:

		pci_bridge_exit();

		return result;

}



/*

 * pci_bridge_exit - module exit function. Release resources allocated

 * by pci_bridge_init.

 */

static void __exit pci_bridge_exit(void)

{

	printk("pci_bridge_exit called ...\n");

	

	if(pci_bridge_devices)

	{

		struct pci_bridge_dev *dev;

		dev = &pci_bridge_devices[0];

		dma_descriptor_release(dev->pcidev);

		cdev_del(&dev->cdev);

		kfree(pci_bridge_devices);

		pci_bridge_devices = NULL;

	}

	unregister_chrdev_region(MKDEV(pci_bridge_major, 0), 1);

	pci_bridge_major = 0;

	pci_unregister_driver(&pci_bridge_driver);

}



/*

 * pci_bridge_open - open file processing.

 */

int pci_bridge_open(struct inode *inode, struct file *filep)

{

	struct pci_bridge_dev *dev;

	dev = container_of(inode->i_cdev, struct pci_bridge_dev, cdev);

	filep->private_data = dev; // used by read, write, etc

	dev->current_resource = -1;

	/* Success */

	return 0;

}



/*

 * pci_bridge_release - close processing.

 */

int pci_bridge_release(struct inode *inode, struct file *filep)

{

	/* Success */

	return 0;

}



/*

 * seek file operation function

 */

loff_t  bridge_lseek(struct file *filp, loff_t offset, int origin)

{

	struct pci_bridge_dev *dev;

	loff_t requested_offset;

	int resource_num;



	dev = filp->private_data;

	resource_num = dev->current_resource;

	switch (origin)

	{

		case SEEK_CUR:requested_offset = dev->offset + offset; break;

		case SEEK_END:requested_offset = dev->base_size[resource_num] + offset; break;

		default:requested_offset  = offset; break;

	}

	

	if ((requested_offset < 0) || (requested_offset >
dev->base_size[resource_num]))

		return -EFAULT;



	dev->offset = requested_offset;

	return requested_offset; 				

}





/*

 * pci_bridge_read - read processing.

 */

ssize_t pci_bridge_read (struct file *filp, char *buf, size_t count,
loff_t *offset_out )

{

	struct pci_bridge_dev *dev;		

	unsigned long current_address;

	unsigned long actual_count;

	unsigned long offset;

	int resource_num;

	int i;

	unsigned int value;

        unsigned int *kern_buf;

        unsigned int *kern_buf_tmp;

	unsigned long size;

	int result;



	dev = filp->private_data;

	offset = dev->offset;

	resource_num = dev->current_resource;

	size   = dev->base_size[resource_num];

	current_address = dev->page_addr + dev->base_page_offset + dev->offset;



	if (dev->current_resource < 0)

		return -ENODEV;

	

	if (offset == size)

		return 0;



	if ( (offset + count) > size )

		actual_count = size - offset;

	else

		actual_count = count;



	// verify range if it is OK to copy from

	if ((result = access_ok(VERIFY_WRITE, buf, actual_count)) ==0)

		return result;



	kern_buf = kmalloc(actual_count, GFP_KERNEL | GFP_DMA);

	kern_buf_tmp = kern_buf;

	if (kern_buf <= 0)

		return 0;



    	memcpy_fromio(kern_buf, current_address, actual_count);

	i = actual_count/4;

	while(i--)

	{

//		value = readl(current_address);	

		value = *(kern_buf);

		put_user(value, ((unsigned int *)buf));	

		buf += 4;

		++kern_buf;

//		current_address += 4;

	}



	kfree(kern_buf_tmp);

	dev->offset = dev->offset + actual_count;

	*(offset_out) = dev->offset;



	return actual_count;

 }	



/*

 * pci_bridge_write - write processing.

 */

ssize_t pci_bridge_write (struct file *filp, const char *buf, size_t
count, loff_t *offset_out)

{

	struct pci_bridge_dev *dev;

	unsigned long current_address;

	unsigned long actual_count;

	unsigned long offset;

	int resource_num;

 	int i;

	int value;

	unsigned long size;

	int result;

	int *kern_buf;

	int *kern_buf_tmp;

	

	

    	dev = filp->private_data;

	current_address = dev->page_addr + dev->base_page_offset + dev->offset;

	resource_num = dev->current_resource;

	size  = dev->base_size[resource_num];

	offset = dev->offset;



	if (dev->current_resource < 0)

		return -ENODEV;



	if (offset == size)

		return 0;



	if ( (offset + count) > size )

		actual_count = size - offset;

	else

		actual_count = count;



	// verify range if it is OK to copy from

	if ((result = access_ok(VERIFY_READ, buf, actual_count)) == 0)

		return result;

	kern_buf = kmalloc(actual_count, GFP_KERNEL | GFP_DMA);

	kern_buf_tmp = kern_buf;

	if (kern_buf <= 0)

		return 0;

	i = actual_count/4;

	while(i--)

	{

		get_user(value, ((int *)buf));

//		writel(value, current_address);

		*kern_buf = value;

		buf += 4;

		//current_address += 4;

		++kern_buf;

	}



	memcpy_toio(current_address, kern_buf_tmp, actual_count);

	kfree(kern_buf_tmp);

	dev->offset = dev->offset + actual_count;

	*(offset_out) = dev->offset;



	return actual_count;

}



/*

 * helper function for memory remaping

 */

int open_mem_mapped(struct pci_bridge_dev *dev)

{

	int resource_num = dev->current_resource;

	unsigned long num_of_pages = 0;

	unsigned long base = dev->bases[resource_num];

	unsigned long size = dev->base_size[resource_num];

	//printk("\n current resource=%d , size = %d, base=%08X",
dev->current_resource , size, dev->bases[resource_num]);

	if (!(num_of_pages = (unsigned long)(size/PAGE_SIZE)));

		num_of_pages++;



	dev->base_page_offset = base & ~PAGE_MASK;



	if ((dev->base_page_offset + size) < (num_of_pages*PAGE_SIZE))

		num_of_pages++;

	

	// remap memory mapped space

	dev->page_addr = (unsigned long)ioremap(base & PAGE_MASK,
num_of_pages * PAGE_SIZE);

	

	if (dev->page_addr == 0x00000000)

		return -ENOMEM;

	

	return 0;

}



/*

 * ioctl: see kint.h for the meaning of args

 */

int pci_bridge_ioctl(struct inode *pnode, struct file *filp, unsigned
int cmd, unsigned long arg)

{



	int error = 0;

	unsigned long base;

	unsigned long base_size;

	struct pci_bridge_dev *dev;

	dev = filp->private_data;



	if (_IOC_TYPE(cmd) != BRIDGE_IOC_NUM) return -EINVAL;

	if (_IOC_NR(cmd) > BRIDGE_IOC_MAX_NUM) return -EINVAL;



	switch (cmd)

	{

		case BRIDGE_IOC_CURRESGET:

			// current resource - they start at 1

			return (dev->current_resource + 1);

		

		case BRIDGE_IOC_CURRESSET:

			// check if resource is in a range of implemented resources

			if (arg < 0 )

				return -EINVAL;



			// unmap previous resource if it was mapped

			if (dev->current_resource >= 0)

			{

				iounmap((void *)dev->page_addr);

			}	



			if (arg == 0)

			{

				// previous resource unmaped - that's all

				dev->current_resource = -1;

				return 0;	

			}



			if (dev->num_of_bases < arg)

				return -ENODEV;



			// IO mapped not supported yet

			if (dev->base_map[arg-1] == BRIDGE_IO_MAPPED)

			{

				// set current resource to none, since it was unmapped

				dev->current_resource = -1;

				return -ENODEV;

			}

			dev->current_resource= (int)(arg-1);

			// remap new resource

			if ( (error = open_mem_mapped(dev)) )

			{

				dev->current_resource = -1;

				return error;

			}

			return 0;



		case BRIDGE_IOC_CURBASE:

			// check if any resource is currently activated

			if (dev->current_resource>=0)

			{

				base = dev->bases[dev->current_resource];

				printk("\n CURR_RES = %d",dev->current_resource );

			}

			else

				base = 0x00000000;

			

			*(unsigned long *)arg = base;

			return 0;



		case BRIDGE_IOC_CURBASEMAP:

			// check if any resource is currently activated

			if (dev->current_resource>=0)

				base = dev->page_addr;

			else

				base = 0x00000000;

	

			*(unsigned long *)arg = base;



			return 0;



		case BRIDGE_IOC_CURBASESIZE:	

			// check if any resource is currently activated

			if (dev->current_resource>=0)

				base_size = dev->base_size[dev->current_resource];

			else

				base_size = 0x00000000;

			

			*(unsigned long *)arg = base_size;

			return 0;



		case BRIDGE_IOC_NUMOFRES:	

			return (dev->num_of_bases);



		default:

			return -EINVAL;

		

	}



}

#define TX_BUFFER_FLAGS	 	0x00

#define RX_BUFFER_FLAGS 	0x00

#define TX_DATA_LEN		0x04

#define RX_DATA_LEN		0x04	

#define TX_BUFFER_OFFSET 	0x0c

#define RX_BUFFER_OFFSET 	0x0c

#define TX_BUFFER_SIZE 		4096

#define RX_BUFFER_SIZE		4096

#define WB_RX_BUFFER_AM		0xFF000000

#define WB_TX_BUFFER_AM		0xFF000000



static void dma_descriptor_setup(struct pci_dev *pdev)

{	

	unsigned long current_address;

	unsigned int  register_value;

	int error = 0;

	unsigned int c_tx_data;

	printk("DMA ALLOC ROUTINE STARTED\n");

	c_memory_map->dma_buffer_rx = pci_alloc_consistent(pdev,
RX_BUFFER_SIZE+RX_BUFFER_OFFSET, &c_memory_map->dma_bus_rx);

	printk("RX DMA BUFFER READY\n");

	c_memory_map->dma_buffer_tx = pci_alloc_consistent(pdev,
TX_BUFFER_SIZE+TX_BUFFER_OFFSET, &c_memory_map->dma_bus_tx);

	printk("TX DMA BUFFER READY\n");

	pci_bridge_devices->current_resource = 0;

	if ( (error = open_mem_mapped(pci_bridge_devices)) )

	{

		pci_bridge_devices->current_resource = -1;

		printk("Could not set BAR0 on DMA alloc\n");

		return;

	}

	printk("PCI ADDRESS FOR TX IS %d AND PCI ADDRESS FOR RX IS %d\n",
c_memory_map->dma_bus_rx, c_memory_map->dma_bus_tx);

	current_address = pci_bridge_devices->page_addr +
pci_bridge_devices->base_page_offset + BRIDGE_W_AM1_ADDR;

	register_value = WB_RX_BUFFER_AM;

	memcpy_toio(current_address, &register_value, 4);

	current_address = pci_bridge_devices->page_addr +
pci_bridge_devices->base_page_offset + BRIDGE_W_AM2_ADDR;

	register_value = WB_TX_BUFFER_AM;

	memcpy_toio(current_address, &register_value, 4);	

}



static void dma_descriptor_release(struct pci_dev *pdev)

{

	pci_free_consistent(pdev, RX_BUFFER_SIZE+RX_BUFFER_OFFSET,
c_memory_map->dma_buffer_rx, c_memory_map->dma_bus_rx);

	pci_free_consistent(pdev, TX_BUFFER_SIZE+TX_BUFFER_OFFSET,
c_memory_map->dma_buffer_tx, c_memory_map->dma_bus_tx);

}



MODULE_LICENSE("GPL");



module_init(pci_bridge_init);

module_exit(pci_bridge_exit);



Any help would be apreciated..
