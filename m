Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab1GTGLY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 02:11:24 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53819 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab1GTGLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 02:11:23 -0400
Message-ID: <4E267185.2070804@gmail.com>
Date: Wed, 20 Jul 2011 16:11:17 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ravishankar <ravishankarkm32@gmail.com>
CC: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>
Subject: Re: [PATCH 1/1] Staging: comedi: fix printk issue in das6402.c
References: <[PATCH]Staging: comedi: fix printk() issue in das6402.c> <1311141439-15920-1-git-send-email-ravishankarkm32@gmail.com>
In-Reply-To: <1311141439-15920-1-git-send-email-ravishankarkm32@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/07/11 15:57, Ravishankar wrote:
> From: Ravishankar<ravi.shankar@greenturtles.in>
>
> This is a patch to the das6402.c file that fixes up a printk() warning found by the checkpatch.pl tool
>
> Signed-off-by: Ravishankar<ravishankarkm32@gmail.com>
> ---
>   drivers/staging/comedi/drivers/das6402.c |   27 +++++++++++++++------------
>   1 files changed, 15 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/das6402.c b/drivers/staging/comedi/drivers/das6402.c
> index 6328f52..f9db533 100644
> --- a/drivers/staging/comedi/drivers/das6402.c
> +++ b/drivers/staging/comedi/drivers/das6402.c
> @@ -171,13 +171,13 @@ static irqreturn_t intr_handler(int irq, void *d)
>   	struct comedi_subdevice *s = dev->subdevices;
>
>   	if (!dev->attached || devpriv->das6402_ignoreirq) {
> -		printk("das6402: BUG: spurious interrupt\n");
> +		printk(KERN_WARNING "das6402: BUG: spurious interrupt\n");
>   		return IRQ_HANDLED;

Can this be:

     dev_warn(d->hw_dev, "BUG: spurious interrupt\n");

Or at least use pr_fmt to avoid having the das6402 prefix everywhere.

>   	}
>   #ifdef DEBUG
> -	printk("das6402: interrupt! das6402_irqcount=%i\n",
> -	       devpriv->das6402_irqcount);
> -	printk("das6402: iobase+2=%i\n", inw_p(dev->iobase + 2));
> +	printk(KERN_DEBUG "das6402: interrupt! das6402_irqcount=%i\n",
> +			devpriv->das6402_irqcount);
> +	printk(KERN_DEBUG "das6402: iobase+2=%i\n", inw_p(dev->iobase + 2));
>   #endif
Use pr_debug and drop the ifdef DEBUG. Same in other places.

>
>   	das6402_ai_fifo_dregs(dev, s);
> @@ -186,8 +186,8 @@ static irqreturn_t intr_handler(int irq, void *d)
>   		outw_p(SCANL, dev->iobase + 2);	/* clears the fifo */
>   		outb(0x07, dev->iobase + 8);	/* clears all flip-flops */
>   #ifdef DEBUG
> -		printk("das6402: Got %i samples\n\n",
> -		       devpriv->das6402_wordsread - diff);
> +		printk(KERN_DEBUG "das6402: Got %i samples\n\n",
> +			devpriv->das6402_wordsread - diff);
>   #endif
>   		s->async->events |= COMEDI_CB_EOA;
>   		comedi_event(dev, s);
> @@ -229,7 +229,7 @@ static int das6402_ai_cancel(struct comedi_device *dev,
>
>   	devpriv->das6402_ignoreirq = 1;
>   #ifdef DEBUG
> -	printk("das6402: Stopping acquisition\n");
> +	printk(KERN_DEBUG "das6402: Stopping acquisition\n");
>   #endif
>   	devpriv->das6402_ignoreirq = 1;
>   	outb_p(0x02, dev->iobase + 10);	/* disable external trigging */
> @@ -248,7 +248,7 @@ static int das6402_ai_mode2(struct comedi_device *dev,
>   	devpriv->das6402_ignoreirq = 1;
>
>   #ifdef DEBUG
> -	printk("das6402: Starting acquisition\n");
> +	printk(KERN_DEBUG "das6402: Starting acquisition\n");
>   #endif
>   	outb_p(0x03, dev->iobase + 10);	/* enable external trigging */
>   	outw_p(SCANL, dev->iobase + 2);	/* resets the card fifo */
> @@ -329,10 +329,12 @@ static int das6402_attach(struct comedi_device *dev,
>   	if (iobase == 0)
>   		iobase = 0x300;
>
> -	printk("comedi%d: das6402: 0x%04lx", dev->minor, iobase);
> +	printk(KERN_INFO "comedi%d: das6402: 0x%04lx", dev->minor, iobase);
>
>   	if (!request_region(iobase, DAS6402_SIZE, "das6402")) {
> -		printk(" I/O port conflict\n");
> +		printk(KERN_CONT "\n");
> +		printk(KERN_ERR "comedi%d: das6402: 0x%04lx: I/O port conflict\n",
> +		dev->minor, iobase);

You are still misunderstanding KERN_CONT I think. This should just be:

     printk(KERN_CONT " I/O port conflict\n");

If you want the message printed with KERN_ERR then don't bother with the 
continuation. There is no point in leaving out the trailing newline so 
that you can later do:

     printk(KERN_CONT "\n");

It's just silly.

>   		return -EIO;
>   	}
>   	dev->iobase = iobase;
> @@ -340,10 +342,11 @@ static int das6402_attach(struct comedi_device *dev,
>   	/* should do a probe here */
>
>   	irq = it->options[0];
> -	printk(" ( irq = %u )", irq);
> +	printk(KERN_DEBUG " ( irq = %u )", irq);

This looks like a continued line, so should be KERN_CONT.

>   	ret = request_irq(irq, intr_handler, 0, "das6402", dev);
>   	if (ret<  0) {
> -		printk("irq conflict\n");
> +		printk(KERN_CONT "\n");
> +		printk(KERN_DEBUG "( irq = %u)irq conflict\n", irq);
>   		return ret;
>   	}
>   	dev->irq = irq;

Please don't just go through and mindlessly fix checkpatch errors. Look 
at what the code is doing and try and actually fix it up properly. 
Especially when the code is in staging. These "fixes" don't really make 
the code any better.

~Ryan

