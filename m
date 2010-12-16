Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406Ab0LPQRG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 11:17:06 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:64765 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab0LPQRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 11:17:04 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH V7 3/8] posix clocks: introduce dynamic clocks
Date: Thu, 16 Dec 2010 17:16:42 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Christoph Lameter <cl@linux.com>, David Miller <davem@davemloft.net>,
        John Stultz <johnstul@us.ibm.com>, Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
References: <cover.1292512461.git.richard.cochran@omicron.at> <8debe4d48d9a6484b7fbd35d8888524155fed977.1292512461.git.richard.cochran@omicron.at>
In-Reply-To: <8debe4d48d9a6484b7fbd35d8888524155fed977.1292512461.git.richard.cochran@omicron.at>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012161716.42520.arnd@arndb.de>
X-Provags-ID: V02:K0:R9tJihZOZk0Ok8L7YXWsbZ4nd2hP+OiZaXaz70dp+WS
 kZ+O6uKkAYJbeUpikLrBaojIStAAe5baZnFuQ9+o1KFKQgGEMG
 OyCsxMQ1vwfKwovd4JanbcNhUOv83h8NmWx+RxzjtYjt2tpcJY
 5YWoKtQwJeoUXlUdE8V8inG+Qoca6AQ56+yzES2TiWSNJ7zqo5
 /g/K9RAs/wXGstVGeC7aQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 December 2010, Richard Cochran wrote:
> This patch adds support for adding and removing posix clocks. The
> clock lifetime cycle is patterned after usb devices. Each clock is
> represented by a standard character device. In addition, the driver
> may optionally implemented custom character device operations.
> 
> The dynamic posix clocks do not yet do anything useful. This patch
> merely provides some needed infrastructure.
> 
> Signed-off-by: Richard Cochran <richard.cochran@omicron.at>

> +struct posix_clock_fops {
> +	int (*fasync)  (void *priv, int fd, struct file *file, int on);
> +	int (*mmap)    (void *priv, struct vm_area_struct *vma);
> +	int (*open)    (void *priv, fmode_t f_mode);
> +	int (*release) (void *priv);
> +	long (*ioctl)  (void *priv, unsigned int cmd, unsigned long arg);
> +	long (*compat_ioctl) (void *priv, unsigned int cmd, unsigned long arg);
> +	ssize_t (*read) (void *priv, uint flags, char __user *buf, size_t cnt);
> +	unsigned int (*poll) (void *priv, struct file *file, poll_table *wait);
> +};

Thanks for the change to a private ops structure. Three more
suggestions for this:

* I would recommend starting without a compat_ioctl operation if you can.
Just mandate that all ioctls for posix clocks are compatible and call
fops->ioctl from the posix_clock_compat_ioctl() function.
If you ever need compat_ioctl handling, it can still be added later.

* Instead of passing a void pointer, why not pass a struct posix_clock
pointer to the lower device and use container_of? That follows what
we do in other subsystems and allows you save one allocation, by
including the posix_clock into the specific clock struct like
ptp_clock.

> +struct posix_clock_operations {
> +	struct module *owner;
> +	struct posix_clock_fops fops;
> +	int  (*clock_adjtime)(void *priv, struct timex *tx);

You can easily combine the two structures and get rid of the extra
struct posix_clock_fops by moving its operations into
posix_clock_operations.

Looks really good otherwise.

	Arnd
