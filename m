Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750956Ab1F3EDK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 00:03:10 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40486 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab1F3EDD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 00:03:03 -0400
MIME-Version: 1.0
In-Reply-To: <19966.65175.273917.314279@pilspetsen.it.uu.se>
References: <BANLkTimU=FL-QG9KcGbYOegfizf5HNH+ZQ@mail.gmail.com>
	<19966.65175.273917.314279@pilspetsen.it.uu.se>
Date: Thu, 30 Jun 2011 06:03:01 +0200
Message-ID: <BANLkTi=-xEU+GZzmNk+u2YwaXjE5RPTwgA@mail.gmail.com>
Subject: Re: [PCI Driver Help] Locking Pages of a running process
From: newton mailinglist <newtonmailinglist@gmail.com>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have rewritten my PCI driver now to implement mmap :

/**
 * Handle mmap of the htex device
 */
void htex_vma_open(struct vm_area_struct *vma)
{
	printk(KERN_NOTICE "htex VMA open, virt %lx, phys %lx\n",
	vma->vm_start, vma->vm_pgoff << PAGE_SHIFT);
}

void htex_vma_close(struct vm_area_struct *vma)
{
	printk(KERN_NOTICE "htex VMA close.\n");
}

static struct vm_operations_struct htex_vm_ops = {
	.open  = htex_vma_open,
	.close = htex_vma_close,
};

static int htex_mmap(struct file * file, struct vm_area_struct * vma)
<-------------the mmap implementation
{
   DEBUG_MSG("htex_mmap called\n");

   vma->vm_flags |= VM_RESERVED;

   if (remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
		vma->vm_end - vma->vm_start,
		vma->vm_page_prot))
		return -EAGAIN;
	
   vma->vm_ops = &htex_vm_ops;
   htex_vma_open(vma);
	
   return 0;
}

The way I use this in the C program is as follows :

//Copy bitstream file data to memory obtained from kernel
void molen_set(const char* filename)
{
	//Open the bitstream file
	int fd = open(filename, O_RDWR);
	int length = 0;
	char *arg, *bs_map;
	struct stat buf;

	if (fd < 0)
	{
		perror("molen_set : Filename Open");
		return;
	}
	
	//Get bitstream file size
	fstat(fd, &buf);
	length = buf.st_size;
	if(length == 0)
	{
		fprintf(stderr, "\nmolen_set : Empty input file\n");
		return;
	}
	
	//Map bitstream file to memory to read it in via page faults(faster
than explicit file I/O)
	bs_map = mmap(NULL, length, PROT_WRITE | PROT_READ, MAP_PRIVATE, fd, 0);
	printf("molen_set : Bitstream mapped to = %p\n", bs_map);
	printf("molen_set : Bistream size = %d\n", length);
	
	//Get user space address of empty kernel memory of length bytes
	arg = mmap(NULL, length, PROT_WRITE | PROT_READ, MAP_PRIVATE, htex_handle, 0);
	printf("molen_set : Kernel buffer user space address = %p\n", arg);
	
	//Copy bs data to kernel space buffer : this is when the page faults
actually occur ?
	memset(arg, 0, length);
	memcpy(arg, bs_map, length);

	//Send IOCTL : will set a control register in the FPGA design to make
it fetch b.s. data and start PR thru ICAP
	printf("molen_set : ioctl called\n");
	ioctl(htex_handle, HTEX_IOSET, arg);
	printf("molen_set : ioctl returned\n");

	munmap(arg, length);
	munmap(bs_map, length);
}

At this point I have copied the bitstream data into kernel memory and
I call the IOCTL to let the FPGA begin execution.
The IOCTL call causes the following IOCTL function code to execute :

static int htex_ioctl(struct inode *inode, struct file *filp, unsigned
int cmd, unsigned long arg)
{	long status;
	struct htex_dev_t *htex_dev = filp->private_data;
	int result;	
	
	DEBUG_MSG("IOCTL issued : %d\n",cmd);
	if((_IOC_TYPE(cmd) != HTEX_IOC_MAGIC) || (_IOC_NR(cmd) > HTEX_IOC_MAXNR))
		return -ENOTTY;

	switch (cmd)
	{
		...
		case HTEX_IOSET:			//Modified for prefetch
			...
			*(((u64 *)htex_dev->bar2->bar) + 1) = arg;	//write data to memory
mapped IO register of fpga
			iowrite32(HTEX_SET_C, htex_dev->bar2->bar);	//write to control
register of fpga
			...
			//result = wait_event_interruptible(wait_queue, htex_dev->done !=
0);	//removed to allow C program to continue
			status = ioread32(htex_dev->bar2->bar+0);
			htex_dev->set_done = 0; //flag to track that PR in progress,
interrupt will set it to 1
			break;
		default:
			return -ENOTTY;
	}
	return 0;
}

Once the above code executes the fpga starts sending address
translation interrupts to the driver and
its handled at the following function called by the interrupt handler :

/**
 *get the page belonging to address, lock it in memory and get the bus
address of the page
 *return 0 on failure and 1 on success
 */
int translate_address(unsigned long int virt_addr, struct htex_dev_t *htex_dev)
{
	int result;
	unsigned long int translated;
	unsigned long int index = 0;
	unsigned long int tag = 0;
	struct page *page;	
	
	index = virt_to_index(virt_addr);
	tag = virt_to_tag(virt_addr);

	DEBUG_MSG("translate_address: virt_addr = %lx, index=%lx, tag=%lx\n",
virt_addr, index, tag);
	
	//check if index already has a valid entry and if so
	//release this entry before replacing it : this is no use, it was the
older approach using user space pages
/*	if(htex_dev->entries[index].page)
		release_page(htex_dev, index);*/
	
	
	//init_rwsem(&sem);
	if(down_read_trylock(&htex_dev->tsk->mm->mmap_sem))
		DEBUG_MSG("translate_address: lock was granted!\n");
	else{
		DEBUG_MSG("translate_address: A Lock was not granted, skipping
address translation\n");
		goto cleanup;
	}
	
	//get page : Note this was the earlier approach (see mail text for explanation)
/*	result = get_user_pages(htex_dev->tsk, htex_dev->tsk->mm,
virt_addr, 1, 0, 0, &page, NULL);
	DEBUG_MSG("translate_address: result = %d\n", result);
	if (result <= 0)
	{
		ERROR_MSG("translate_address: Unable to get page\n");
		//htx_dump_tlb(htex_dev);
		return 0;
	}
	
	//get bus address of page
	translated = pci_map_page(htex_dev->dev, page, 0, PAGE_SIZE,
DMA_BIDIRECTIONAL);

	*/
	
	//This is how I do it now
	translated = virt_to_phys((volatile void *)virt_addr);
<---------------------------
	

	DEBUG_MSG("translate_address: Translated Address: %lx\n", translated);
	
	update_htx_tlb(index, tag, translated, htex_dev);
	//update entry in array
	htex_dev->entries[index].page = page;
	htex_dev->entries[index].hw_addr = translated;
	
	cleanup:
	up_read(&htex_dev->tsk->mm->mmap_sem);
	return 1;
}


So the above function translates the passed virt_addr to the physical
address using virt_to_phys().
However this does not seem as expected as I get the translated
physical address to be same as the virtual address.
Here is some sample output from DMESG :

[ 1102.286894] htex: Address translation request
[ 1102.286896] htex: Address = 7f7fe1589000
[ 1102.286899] htex: translate_address: virt_addr = 7f7fe1589000,
index=189, tag=3fbff0a
[ 1102.286901] htex: translate_address: lock was granted!
[ 1102.286903] htex: translate_address: Translated Address: f77fe1589000
[ 1102.286906] htex: 78971 cycles 23176 cycles
[ 1102.288250] htex VMA close.
[ 1104.682724] htex: close

I dont think the physical address should be the same as virtual address.

I was following a different approach earlier which did work but
involved suspending the C program inside the IOCTL call.
So what I did then was map the bitstream file data in user space using :

bs_map = mmap(NULL, length, PROT_WRITE | PROT_READ, MAP_PRIVATE, fd, 0);

Then suspend the C program in the IOCTL call using :

result = wait_event_interruptible(wait_queue, htex_dev->done != 0);

Then I translated the address using the following (the commented out
code in translate_address() ) :

result = get_user_pages(htex_dev->tsk, htex_dev->tsk->mm, virt_addr,
1, 0, 0, &page, NULL);
translated = pci_map_page(htex_dev->dev, page, 0, PAGE_SIZE, DMA_BIDIRECTIONAL);

This enabled DMA access to user space pages and address translation
went smoothly. I am now try to do the opposite,
i.e. putting the user data directly into kernel space memory after
obtaining space from the kernel. But the
address translation does not appear correct.

I think putting required data in kernel space is the correct way to go
as the C program will continue to run during
the address translation interrupts and its perhaps best to not touch
user pages or attempt to translate user space virtual addresses while
the program runs.

Thanks,
Abh

On Mon, Jun 20, 2011 at 10:02 AM, Mikael Pettersson <mikpe@it.uu.se> wrote:
> newton mailinglist writes:
>  > Hi,
>  >
>  > I have written a PCI driver for my device. The device is an FPGA which
>  > is configured with a design that allows it to have direct access to
>  > memory of a host computer to which the fpga board is connected. My
>  > device driver is responsible for translating virtual addresses to
>  > physical addresses and sending these to the FPGA so the DMA unit in
>  > the FPGA can directly access pages in memory.
>  >
>  > I have a C program which uses the driver to open this PCI device and
>  > then sends a command to the device, so it can begin accessing
>  > memory(for some calculations done in the fpga). This is done via
>  > IOCTL. The FPGA sends an interrupt when its done. However my program
>  > does not wait for the FPGA but instead resumes execution immmediately
>  > after the IOCTL call returns. If the FPGA has a virtual address which
>  > it needs to translate, it interrupts my PCI driver and I want to
>  > translate this address in the interrupt handler and write back the
>  > translated address to the device using memory mapped I/O.
>  >
>  > The issue is that when my driver gets the virtual address, it attempts
>  > to lock the user space pages first(those of the running C program) in
>  > memory using get_user_pages() and then translates the address using
>  > pci_map_page(). Pinning the pages in memory is needed as the fpga will
>  > access them later using DMA. Here is the code I use   :
>
> Instead of sending user-space pages from an application to the driver,
> expecting the driver to do address space translations and locking,
> your driver should implement mmap() and user-space should get its I/O
> buffers by mmap()ing the device.
>
