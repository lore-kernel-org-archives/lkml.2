Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264Ab0FVFdI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 01:33:08 -0400
Received: from n3-vm1.bullet.mail.gq1.yahoo.com ([67.195.23.157]:38547 "HELO
	n3-vm1.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750905Ab0FVFdH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 01:33:07 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 108537.99110.bm@omp127.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=pCfmyXoFIqsk+GaBosnVZ1TmzNh9x4kShOJOg4lLW1+1PZVcZ6Xn96o6IUjKdzr7go4+FA6PXtjMdp7vMiWe7gFPuE+XaxCQduCUjSBlLbIOzYu0AIHzrXsQ3H2o99qts5GtF3kFYqT/Nwdos19qw+g7FhNL4rOejPbbcE3mlhs=;
Message-ID: <985037.17578.qm@web180312.mail.gq1.yahoo.com>
X-YMail-OSG: bO7WMU8VM1nL0Y7Lw2QhfZKQiPp8l0IIHvb7.g0rD3DL2z4
 PrBSW9X.eCzBLo6sfsLtY0ws43DuTbZhzADzzDsfEYgvzgmP8_g7LxBCRxpg
 xp_EWjRxczCila6_6FIjv_zOTeIAstmeNw9VRBfqqS4znFBKHKlxn6_F1Is7
 27ZkQf8oAM7v_nQd3Xg9N2uYke4WUDvg4EXMKtAuPiIAZitkSZZFVTKLpipl
 OUMgdRjt.QJa1FGPFvskMyoivGIipL6o1J7PSguzttdBIDzc6lOsxRtqliWO
 TZp_rVST7680RW_xEURo96W3zRTEdpTr_Jj.bzLV5blqrhOy_GBVjjGjAOp5
 OajPCF_BGgB0sb6KiEw3tJWSfGrk-
X-Mailer: YahooMailClassic/11.1.4 YahooMailWebService/0.8.103.269680
Date: Mon, 21 Jun 2010 22:33:05 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] USB: gadget/printer, fix sleep inside atomic
To: gregkh@suse.de, Jiri Slaby <jslaby@suse.cz>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com, "Craig W. Nadler" <craig@nadler.us>,
       David Brownell <dbrownell@users.sourceforge.net>
In-Reply-To: <1277132560-14284-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Mon, 6/21/10, Jiri Slaby <jslaby@suse.cz> wrote:

> From: Jiri Slaby <jslaby@suse.cz>
> Subject: [PATCH] USB: gadget/printer, fix sleep inside atomic
> To: gregkh@suse.de
> Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, jirislaby@gmail.com, "Craig W. Nadler" <craig@nadler.us>, "David Brownell" <dbrownell@users.sourceforge.net>
> Date: Monday, June 21, 2010, 8:02 AM
> Stanse found that sleep is called
> inside atomic context created by
> lock_printer_io spinlock in several functions. It's used in
> process
> context only and some functions sleep inside its critical
> section. As
> this is not allowed for spinlocks, switch it to mutex.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Craig W. Nadler <craig@nadler.us>
> Cc: David Brownell <dbrownell@users.sourceforge.net>

ACK ... :)

> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  drivers/usb/gadget/printer.c |   32
> ++++++++++++++++----------------
>  1 files changed, 16 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/usb/gadget/printer.c
> b/drivers/usb/gadget/printer.c
> index 43abf55..4c3ac5c 100644
> --- a/drivers/usb/gadget/printer.c
> +++ b/drivers/usb/gadget/printer.c
> @@ -82,7 +82,7 @@ static struct class *usb_gadget_class;
>  struct printer_dev {
>      spinlock_t   
>     lock;   
>     /* lock this structure */
>      /* lock buffer lists during read/write
> calls */
> -    spinlock_t   
>     lock_printer_io;
> +    struct mutex   
>     lock_printer_io;
>      struct usb_gadget   
> *gadget;
>      struct usb_request   
> *req;        /* for control
> responses */
>      u8       
>     config;
> @@ -567,7 +567,7 @@ printer_read(struct file *fd, char
> __user *buf, size_t len, loff_t *ptr)
>  
>      DBG(dev, "printer_read trying to read
> %d bytes\n", (int)len);
>  
> -   
> spin_lock(&dev->lock_printer_io);
> +   
> mutex_lock(&dev->lock_printer_io);
>      spin_lock_irqsave(&dev->lock,
> flags);
>  
>      /* We will use this flag later to check
> if a printer reset happened
> @@ -601,7 +601,7 @@ printer_read(struct file *fd, char
> __user *buf, size_t len, loff_t *ptr)
>           * call or
> not.
>           */
>          if (fd->f_flags
> & (O_NONBLOCK|O_NDELAY)) {
> -           
> spin_unlock(&dev->lock_printer_io);
> +           
> mutex_unlock(&dev->lock_printer_io);
>             
> return -EAGAIN;
>          }
>  
> @@ -648,7 +648,7 @@ printer_read(struct file *fd, char
> __user *buf, size_t len, loff_t *ptr)
>          if
> (dev->reset_printer) {
>             
> list_add(&current_rx_req->list,
> &dev->rx_reqs);
>             
> spin_unlock_irqrestore(&dev->lock, flags);
> -           
> spin_unlock(&dev->lock_printer_io);
> +           
> mutex_unlock(&dev->lock_printer_io);
>             
> return -EAGAIN;
>          }
>  
> @@ -673,7 +673,7 @@ printer_read(struct file *fd, char
> __user *buf, size_t len, loff_t *ptr)
>      dev->current_rx_buf =
> current_rx_buf;
>  
>     
> spin_unlock_irqrestore(&dev->lock, flags);
> -   
> spin_unlock(&dev->lock_printer_io);
> +   
> mutex_unlock(&dev->lock_printer_io);
>  
>      DBG(dev, "printer_read returned %d
> bytes\n", (int)bytes_copied);
>  
> @@ -697,7 +697,7 @@ printer_write(struct file *fd, const
> char __user *buf, size_t len, loff_t *ptr)
>      if (len == 0)
>          return -EINVAL;
>  
> -   
> spin_lock(&dev->lock_printer_io);
> +   
> mutex_lock(&dev->lock_printer_io);
>      spin_lock_irqsave(&dev->lock,
> flags);
>  
>      /* Check if a printer reset happens
> while we have interrupts on */
> @@ -713,7 +713,7 @@ printer_write(struct file *fd, const
> char __user *buf, size_t len, loff_t *ptr)
>           * a
> NON-Blocking call or not.
>           */
>          if (fd->f_flags
> & (O_NONBLOCK|O_NDELAY)) {
> -           
> spin_unlock(&dev->lock_printer_io);
> +           
> mutex_unlock(&dev->lock_printer_io);
>             
> return -EAGAIN;
>          }
>  
> @@ -752,7 +752,7 @@ printer_write(struct file *fd, const
> char __user *buf, size_t len, loff_t *ptr)
>  
>          if
> (copy_from_user(req->buf, buf, size)) {
>             
> list_add(&req->list, &dev->tx_reqs);
> -           
> spin_unlock(&dev->lock_printer_io);
> +           
> mutex_unlock(&dev->lock_printer_io);
>             
> return bytes_copied;
>          }
>  
> @@ -766,14 +766,14 @@ printer_write(struct file *fd, const
> char __user *buf, size_t len, loff_t *ptr)
>          if
> (dev->reset_printer) {
>             
> list_add(&req->list, &dev->tx_reqs);
>             
> spin_unlock_irqrestore(&dev->lock, flags);
> -           
> spin_unlock(&dev->lock_printer_io);
> +           
> mutex_unlock(&dev->lock_printer_io);
>             
> return -EAGAIN;
>          }
>  
>          if
> (usb_ep_queue(dev->in_ep, req, GFP_ATOMIC)) {
>             
> list_add(&req->list, &dev->tx_reqs);
>             
> spin_unlock_irqrestore(&dev->lock, flags);
> -           
> spin_unlock(&dev->lock_printer_io);
> +           
> mutex_unlock(&dev->lock_printer_io);
>             
> return -EAGAIN;
>          }
>  
> @@ -782,7 +782,7 @@ printer_write(struct file *fd, const
> char __user *buf, size_t len, loff_t *ptr)
>      }
>  
>     
> spin_unlock_irqrestore(&dev->lock, flags);
> -   
> spin_unlock(&dev->lock_printer_io);
> +   
> mutex_unlock(&dev->lock_printer_io);
>  
>      DBG(dev, "printer_write sent %d
> bytes\n", (int)bytes_copied);
>  
> @@ -820,11 +820,11 @@ printer_poll(struct file *fd,
> poll_table *wait)
>      unsigned long   
>     flags;
>      int   
>         status = 0;
>  
> -   
> spin_lock(&dev->lock_printer_io);
> +   
> mutex_lock(&dev->lock_printer_io);
>      spin_lock_irqsave(&dev->lock,
> flags);
>      setup_rx_reqs(dev);
>     
> spin_unlock_irqrestore(&dev->lock, flags);
> -   
> spin_unlock(&dev->lock_printer_io);
> +   
> mutex_unlock(&dev->lock_printer_io);
>  
>      poll_wait(fd, &dev->rx_wait,
> wait);
>      poll_wait(fd, &dev->tx_wait,
> wait);
> @@ -1461,7 +1461,7 @@ autoconf_fail:
>      }
>  
>      spin_lock_init(&dev->lock);
> -   
> spin_lock_init(&dev->lock_printer_io);
> +   
> mutex_init(&dev->lock_printer_io);
>      INIT_LIST_HEAD(&dev->tx_reqs);
>     
> INIT_LIST_HEAD(&dev->tx_reqs_active);
>      INIT_LIST_HEAD(&dev->rx_reqs);
> @@ -1594,7 +1594,7 @@ cleanup(void)
>  {
>      int status;
>  
> -   
> spin_lock(&usb_printer_gadget.lock_printer_io);
> +   
> mutex_lock(&usb_printer_gadget.lock_printer_io);
>      class_destroy(usb_gadget_class);
>     
> unregister_chrdev_region(g_printer_devno, 2);
>  
> @@ -1602,6 +1602,6 @@ cleanup(void)
>      if (status)
>          ERROR(dev,
> "usb_gadget_unregister_driver %x\n", status);
>  
> -   
> spin_unlock(&usb_printer_gadget.lock_printer_io);
> +   
> mutex_unlock(&usb_printer_gadget.lock_printer_io);
>  }
>  module_exit(cleanup);
> -- 
> 1.7.1
> 
> 
> 

