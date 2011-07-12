Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab1GLLsa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 07:48:30 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62700 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab1GLLs3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 07:48:29 -0400
MIME-Version: 1.0
In-Reply-To: <CAGZ=bqJqYBmbOHZ+LcG2_yiwZbgLwxNeWp+CYcvsEhdpaz-Gow@mail.gmail.com>
References: <BANLkTinWkJa0zWgV7RVWtt4d3qf9dapFkg@mail.gmail.com>
	<BANLkTimF0AsS3=-S=gmbcjBC5JuKr=6Prw@mail.gmail.com>
	<BANLkTimp2cafUrALLdqeSBWeMsA+ybiUpQ@mail.gmail.com>
	<BANLkTikO+cUbCFPAuNSE01xSmOzhwWP0mQ@mail.gmail.com>
	<BANLkTimAHc6+ZPd7gUpr0-eHGpyLSwJFEA@mail.gmail.com>
	<CABBBjTJkisyWsRBn28Lj5vCne5qbKP0qSVvM0ytXF_Y8O29_3A@mail.gmail.com>
	<CAGZ=bqJqYBmbOHZ+LcG2_yiwZbgLwxNeWp+CYcvsEhdpaz-Gow@mail.gmail.com>
Date: Tue, 12 Jul 2011 13:48:28 +0200
Message-ID: <CABBBjTKw9RVh6Jw9wjmyUoGajmv0x++G2OXaDjwSbniW8656yw@mail.gmail.com>
Subject: Re: [PCI Driver]Physical address being returned as 0 in mmap
From: newton mailinglist <newtonmailinglist@gmail.com>
To: Kyle Moffett <kyle@moffetthome.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kyle,

Thanks so

> First of all, you need to make sure you have all of the cache and DMA
> flushes correct.  *ALL* memory that the FPGA might access while running
> the user code must be cache flushed and appropriately dma_sync_*()ed.
> Otherwise your FPGA will read old data.
> This means in particular that you can't really read arbitrary data from the
> program memory, you need to enumerate everything that the hardware
> needs in advance from the kernel, or be able to flush it on demand, which
> is somewhat of a performance killer.

Well yes, I actually do know exactly the data which I have to send to
the fpga in advance.
Its a fixed set of data(about 1 MB) and the CPU will not change it or
access it in any way once its inside the DMA buffer i.e. the
C program will not modify the data anymore. All I need to do is send
this fixed data to the fpga.

I was able to solve the issue finally.

Thanks so much for all the help.

So the way I do it using the DMA API is , I allocate the a buffer in
kernel space when the driver starts up :

//Allocate PCI consistent memory
cpu_addr_virt = (unsigned long)pci_alloc_consistent(htex_dev->dev,
BS_SIZE, &dma_handle);

Then whenever I need to use the buffer, I simply copy the data to it :
memset((void*)cpu_addr_virt, 0, BS_SIZE);
memcpy((void*)cpu_addr_virt, (void*)arg, BS_SIZE);

The physical addresses are known beforehand as the buffer is allocated
at startup and are valid for the entire lifetime of the driver
so no address translations are needed afterwards.

Thanks,
Abhi
