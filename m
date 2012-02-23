Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181Ab2BWUmk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 15:42:40 -0500
Received: from gate.crashing.org ([63.228.1.57]:33284 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756347Ab2BWUmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 15:42:39 -0500
Message-ID: <1330029747.20389.37.camel@pasglop>
Subject: Re: [PATCH] tty: the briq panel isn't a tty, make it use its own
 locking
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 24 Feb 2012 07:42:27 +1100
In-Reply-To: <20120223133931.6227.89653.stgit@bob.linux.org.uk>
References: <20120223133931.6227.89653.stgit@bob.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-23 at 13:39 +0000, Alan Cox wrote:
> From: Alan Cox <alan@linux.intel.com>
> 
> The driver appears to be terminall broken, if nobody is maintaining it then
> perhaps it should go into staging and the out-tray.

Hrm, I don't think anybody maintains it but I do have a BriQ somewhere
in storage, so I suppose I could pick it up, not that I need another
crap driver to deal with right now though...

Cheers,
Ben.

> (Fixed bug noted by Jiri)
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
> 
>  drivers/char/briq_panel.c |   26 +++++++-------------------
>  1 files changed, 7 insertions(+), 19 deletions(-)
> 
> 
> diff --git a/drivers/char/briq_panel.c b/drivers/char/briq_panel.c
> index 095ab90..3335d07 100644
> --- a/drivers/char/briq_panel.c
> +++ b/drivers/char/briq_panel.c
> @@ -20,6 +20,7 @@
>  #include <linux/mm.h>
>  #include <linux/init.h>
>  
> +#include <asm/bitops.h>
>  #include <asm/uaccess.h>
>  #include <asm/io.h>
>  #include <asm/prom.h>
> @@ -30,7 +31,7 @@
>  #define		BRIQ_PANEL_VER		"1.1 (04/20/2002)"
>  #define		BRIQ_PANEL_MSG0		"Loading Linux"
>  
> -static int		vfd_is_open;
> +static unsigned long	vfd_is_open;
>  static unsigned char	vfd[40];
>  static int		vfd_cursor;
>  static unsigned char	ledpb, led;
> @@ -66,37 +67,27 @@ static void set_led(char state)
>  
>  static int briq_panel_open(struct inode *ino, struct file *filep)
>  {
> -	tty_lock();
> -	/* enforce single access, vfd_is_open is protected by BKL */
> -	if (vfd_is_open) {
> -		tty_unlock();
> +	/* enforce single open */
> +	if (test_and_set_bit(0, &vfd_is_open))
>  		return -EBUSY;
>  	}
> -	vfd_is_open = 1;
> -
> -	tty_unlock();
>  	return 0;
>  }
>  
>  static int briq_panel_release(struct inode *ino, struct file *filep)
>  {
> -	if (!vfd_is_open)
> -		return -ENODEV;
> -
> -	vfd_is_open = 0;
> -
> +	clear_bit(0, &vfd_is_open);
>  	return 0;
>  }
>  
> +/* Note that single open doesn't mean single threaded read or write so all
> +   this code is unsafe */
>  static ssize_t briq_panel_read(struct file *file, char __user *buf, size_t count,
>  			 loff_t *ppos)
>  {
>  	unsigned short c;
>  	unsigned char cp;
>  
> -	if (!vfd_is_open)
> -		return -ENODEV;
> -
>  	c = (inb(BRIQ_PANEL_LED_IOPORT) & 0x000c) | (ledpb & 0x0003);
>  	set_led(' ');
>  	/* upper button released */
> @@ -137,9 +128,6 @@ static ssize_t briq_panel_write(struct file *file, const char __user *buf, size_
>  	size_t indx = len;
>  	int i, esc = 0;
>  
> -	if (!vfd_is_open)
> -		return -EBUSY;
> -
>  	for (;;) {
>  		char c;
>  		if (!indx)


