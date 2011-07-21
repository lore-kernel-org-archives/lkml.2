Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab1GUXPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 19:15:17 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:53853 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab1GUXPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 19:15:15 -0400
Message-ID: <4E28B2FA.5020309@gmail.com>
Date: Fri, 22 Jul 2011 09:15:06 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ravishankr <ravishankarkm32@gmail.com>
CC: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>
Subject: Re: [PATCH 1/1 v2] Staging: comedi: fix printk issue in das6402.c
References: <[PATCH]Staging: comedi: fix  printk() issue in das6402.c> <1311243909-5416-1-git-send-email-ravishankrkm32@gmail.com>
In-Reply-To: <1311243909-5416-1-git-send-email-ravishankrkm32@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/07/11 20:25, Ravishankr wrote:
> From: Ravishankar<ravi.shankar@greenturtles.in>
>
> This is a patch to the das6402.c file that fixes up a printk() warning found by the checkpatch.pl tool
>
> Signed-off-by: Ravishankar<ravishankarkm32@gmail.com>

Hi Ravishankar,

Looks much better. Couple more comments below.

~Ryan

> ---
>
> Added define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> Converted printks to pr_<level>
>
>   drivers/staging/comedi/drivers/das6402.c |   35 ++++++++++++------------------
>   1 files changed, 14 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/das6402.c b/drivers/staging/comedi/drivers/das6402.c
> index 6328f52..facf173 100644
> --- a/drivers/staging/comedi/drivers/das6402.c
> +++ b/drivers/staging/comedi/drivers/das6402.c
> @@ -38,6 +38,8 @@ Devices: [Keithley Metrabyte] DAS6402 (das6402)
>   This driver has suffered bitrot.
>   */
>
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>   #include<linux/interrupt.h>
>   #include "../comedidev.h"
>
> @@ -171,24 +173,20 @@ static irqreturn_t intr_handler(int irq, void *d)
>   	struct comedi_subdevice *s = dev->subdevices;
>
>   	if (!dev->attached || devpriv->das6402_ignoreirq) {
> -		printk("das6402: BUG: spurious interrupt\n");
> +		dev_warn(dev->hw_dev, "BUG: spurious interrupt\n");
>   		return IRQ_HANDLED;
>   	}
> -#ifdef DEBUG
> -	printk("das6402: interrupt! das6402_irqcount=%i\n",
> -	       devpriv->das6402_irqcount);
> -	printk("das6402: iobase+2=%i\n", inw_p(dev->iobase + 2));
> -#endif
> +	pr_debug("interrupt! das6402_irqcount=%i\n",
> +			devpriv->das6402_irqcount);
> +	pr_debug("iobase+2=%i\n", inw_p(dev->iobase + 2));
>
You can use dev_dbg for these two. Also changes other printk calls 
appropriately to use dev_ versions.

>   	das6402_ai_fifo_dregs(dev, s);
>
>   	if (s->async->buf_write_count>= devpriv->ai_bytes_to_read) {
>   		outw_p(SCANL, dev->iobase + 2);	/* clears the fifo */
>   		outb(0x07, dev->iobase + 8);	/* clears all flip-flops */
> -#ifdef DEBUG
> -		printk("das6402: Got %i samples\n\n",
> -		       devpriv->das6402_wordsread - diff);
> -#endif
> +		pr_debug("Got %i samples\n\n",
> +				devpriv->das6402_wordsread - diff);
>   		s->async->events |= COMEDI_CB_EOA;
>   		comedi_event(dev, s);
>   	}
> @@ -228,9 +226,7 @@ static int das6402_ai_cancel(struct comedi_device *dev,
>   	 */
>
>   	devpriv->das6402_ignoreirq = 1;
> -#ifdef DEBUG
> -	printk("das6402: Stopping acquisition\n");
> -#endif
> +	pr_debug("Stopping acquisition\n");
>   	devpriv->das6402_ignoreirq = 1;
>   	outb_p(0x02, dev->iobase + 10);	/* disable external trigging */
>   	outw_p(SCANL, dev->iobase + 2);	/* resets the card fifo */
> @@ -246,10 +242,7 @@ static int das6402_ai_mode2(struct comedi_device *dev,
>   			    struct comedi_subdevice *s, comedi_trig * it)
>   {
>   	devpriv->das6402_ignoreirq = 1;
> -
> -#ifdef DEBUG
> -	printk("das6402: Starting acquisition\n");
> -#endif
> +	pr_debug("Starting acquisition\n");
>   	outb_p(0x03, dev->iobase + 10);	/* enable external trigging */
>   	outw_p(SCANL, dev->iobase + 2);	/* resets the card fifo */
>   	outb_p(IRQ | CONVSRC | BURSTEN | INTE, dev->iobase + 9);
> @@ -329,10 +322,10 @@ static int das6402_attach(struct comedi_device *dev,
>   	if (iobase == 0)
>   		iobase = 0x300;
>
> -	printk("comedi%d: das6402: 0x%04lx", dev->minor, iobase);
> +	printk(KERN_INFO "comedi%d: das6402: 0x%04lx", dev->minor, iobase);

Use either pr_info/pr_cont here for consistency with other calls. You 
can probably use the dev_ versions here too.

>
>   	if (!request_region(iobase, DAS6402_SIZE, "das6402")) {
> -		printk(" I/O port conflict\n");
> +		printk(KERN_CONT " I/O port conflict\n");
>   		return -EIO;
>   	}
>   	dev->iobase = iobase;
> @@ -340,10 +333,10 @@ static int das6402_attach(struct comedi_device *dev,
>   	/* should do a probe here */
>
>   	irq = it->options[0];
> -	printk(" ( irq = %u )", irq);
> +	printk(KERN_CONT " ( irq = %u )", irq);
>   	ret = request_irq(irq, intr_handler, 0, "das6402", dev);
>   	if (ret<  0) {
> -		printk("irq conflict\n");
> +		printk(KERN_CONT "irq conflict\n");
>   		return ret;
>   	}
>   	dev->irq = irq;

