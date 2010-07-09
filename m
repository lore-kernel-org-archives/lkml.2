Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab0GIUBR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 16:01:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48187 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753662Ab0GIUBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 16:01:16 -0400
Date: Fri, 9 Jul 2010 13:00:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Masayuki Ohtak <masa-korg@dsn.okisemi.com>
Cc: Arnd Bergmann <arnd@arndb.de>, "Wang, Yong Y" <yong.y.wang@intel.com>,
       qi.wang@intel.com, joel.clark@intel.com,
       andrew.chih.howe.khor@intel.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Packet hub driver of Topcliff PCH
Message-Id: <20100709130028.26174aa1.akpm@linux-foundation.org>
In-Reply-To: <4C32CB44.9010908@dsn.okisemi.com>
References: <4C204B0D.2030201@dsn.okisemi.com>
	<4C32CB44.9010908@dsn.okisemi.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Jul 2010 15:20:52 +0900
Masayuki Ohtak <masa-korg@dsn.okisemi.com> wrote:

> Hi Arnd
> 
> I have modified for your comments.
> Please confirm below.
> 
> Thanks, Ohtake.
> 
> ---
> Packet hub driver of Topcliff PCH
> 
> Topcliff PCH is the platform controller hub that is going to be used in
> Intel's upcoming general embedded platform. All IO peripherals in
> Topcliff PCH are actually devices sitting on AMBA bus. Packet hub is
> a special converter device in Topcliff PCH that translate AMBA transactions
> to PCI Express transactions and vice versa. Thus packet hub helps present
> all IO peripherals in Topcliff PCH as PCIE devices to IA system.
> Topcliff PCH has MAC address and Option ROM data.
> These data are in SROM which is connected to PCIE bus.
> Packet hub driver of Topcliff PCH can access MAC address and Option ROM data in
> SROM.

That didn't describe the most important part of the driver: the
userspace interface.  We should add here something along the lines of

The driver creates a character device /dev/pch_phub.  That device file
supports the following operations:

read(): <document the read operation - seems to read a serial ROM?>
write():<document the write operation - seems to write a serial ROM?> 
ioctl():<document the ioctl operation - seems to read/write a MAC address?>  

>
> ...
>
> +static ssize_t pch_phub_write(struct file *file, const char __user *buf,
> +			      size_t size, loff_t *ppos)
> +{
> +	unsigned int data;
> +	int ret_value1;
> +	int ret_value2;
> +	int err;
> +	unsigned int addr_offset;
> +	loff_t pos = *ppos;
> +	int ret;
> +
> +	ret = mutex_lock_interruptible(&pch_phub_mutex);
> +	if (ret) {
> +		err = -ERESTARTSYS;
> +		goto return_err_nomutex;
> +	}
> +
> +	for (addr_offset = 0; addr_offset < size; addr_offset++) {
> +		ret_value1 = get_user(data, &buf[addr_offset]);
> +		if (ret_value1) {
> +			err = -EFAULT;
> +			goto return_err;
> +		}
> +
> +		ret_value2 = pch_phub_write_serial_rom(0x80 + addr_offset + pos,
> +							data);

I suspect this function will do strange things if passed an initial
*ppos which is outside the range of the ROM.  It looks like it will write
a single byte into the ROM then will bale out.


> +		if (ret_value2) {
> +			err = ret_value2;
> +			goto return_err;
> +		}
> +
> +		if (PCH_PHUB_OROM_SIZE < pos + addr_offset) {

Is this off-by-one?

> +			*ppos += addr_offset;
> +			goto return_ok;
> +		}
> +
> +	}
> +
> +	*ppos += addr_offset;
> +
> +return_ok:
> +	mutex_unlock(&pch_phub_mutex);
> +	return addr_offset;
> +
> +return_err:
> +	mutex_unlock(&pch_phub_mutex);
> +return_err_nomutex:
> +	return err;
> +}
>
> ...
>
