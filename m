Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184Ab1JQIMe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 04:12:34 -0400
Received: from office.intopix.com ([212.166.54.212]:47267 "EHLO
	office.intopix.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740Ab1JQIMd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 04:12:33 -0400
X-Greylist: delayed 1230 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Oct 2011 04:12:32 EDT
From: Charles Buysschaert <Charles.Buysschaert@intopix.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Speed of RAM reserved with memmap kernel command line option.
Thread-Topic: Speed of RAM reserved with memmap kernel command line option.
Thread-Index: AcyMoYqk4aToPCQsSBu7Gz7pox+iqA==
Date: Mon, 17 Oct 2011 07:51:53 +0000
Message-ID: <894F5F1132E3C5458AAB08FA0A1AC9380F1E2F12@IPX-MAIL.Intopix.com>
Accept-Language: en-US, fr-BE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.128.0.206]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Intopix-MailScanner: Found to be clean
X-Intopix-MailScanner-From: charles.buysschaert@intopix.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all, 

We are writing a PCI-e "frame grabber-like" driver for linux 2.6 kernel.

For exchanging data with the board, we would like to be able to use a big piece of consecutive memory.  
-> we reserve 512 megs after the first Gig of RAM by setting "memmap=512M$1024M" in grub.conf.

In order to give access to that memory in user space, I use "remap_pfn_range" : 

int myboard_mmap(struct file *filep, struct vm_area_struct *vma) {
  unsigned int board;

  board = MINOR(filep->f_dentry->d_inode->i_rdev);
  vma->vm_flags |= VM_LOCKED;

  if(remap_pfn_range(vma, vma->vm_start, myboard_var[board].dmablkp>>PAGE_SHIFT, DMA_BUFFER_SIZE, vma->vm_page_prot)) {
    printk(KERN_ERR "myboard: myboard_mmap: failed to mmap\n");
    return -EAGAIN;
  }

  return 0;
}

(I have set myboard_var[board].dmablkp to the address I set in grub.conf: 0x40000000)

However when writing or reading that part of memory, speed is terrible. 
I compared the performances to the ones I can reach using a piece of memory got with malloc: 
For transfering 128 megs:
With malloc"ed" RAM : 23053us
With "mmap"ed RAM : 1913389us

I guess cache is not used. Does anyone know if there is a way to speed this up? How could we set that area to "cached"? 

We have seen this post:
http://www.linux-mips.org/archives/linux-mips/2006-02/msg00120.html

And we tried adding this to our driver: 

static inline pgprot_t pgprot_cached(pgprot_t _prot)

{
    unsigned long prot = pgprot_val(_prot);
    prot = (prot & ~_CACHE_MASK);
    return __pgprot(prot);
}

vma->vm_page_prot = pgprot_cached(vma->vm_page_prot);

But it did not help...

Thank you in advance! 

Best regards,

Charles


