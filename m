Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751221Ab2JTELK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 00:11:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37748 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab2JTELI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 00:11:08 -0400
Subject: Re: Finding the interrupt vector of a given IRQ
From: anish kumar <anish198519851985@gmail.com>
Cc: linux-kernel@vger.kernel.org, tj@kernel.org, tglx@linutronix.de
In-Reply-To: <1350706135.3764.277.camel@anish-Inspiron-N5050>
References: <CADD2D=6-tToVN4BERWYG+3uNUC2+HBDv-xk8Pr+VWp1krqz_=w@mail.gmail.com>
	 <CAFLxGvxxhTXnS52z3bdQL+HY8YvqdMvr3bcE7VO_KtREZ=ZaWA@mail.gmail.com>
	 <CAK7N6vrEqnW0h6PumYJqusEh1LHC_L-xeh5s8twJrmxY08W2Pg@mail.gmail.com>
	 <CABOM9ZoCfU=AR8SUiXJJ6hML_cFgKyhMUX5W9RkKZDVBe-QUEw@mail.gmail.com>
	 <1350706135.3764.277.camel@anish-Inspiron-N5050>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 20 Oct 2012 13:10:53 +0900
Message-ID: <1350706253.3764.279.camel@anish-Inspiron-N5050>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-10-20 at 13:08 +0900, anish kumar wrote:
> On Fri, 2012-10-19 at 10:34 +0530, Arun KS wrote:
> > Hi Anish,
> > 
> > On Mon, May 28, 2012 at 9:16 AM, anish singh
> > <anish198519851985@gmail.com> wrote:
> >         On Mon, May 28, 2012 at 2:57 AM, richard -rw- weinberger
> >         <richard.weinberger@gmail.com> wrote:
> >         > On Sun, May 27, 2012 at 2:02 AM, Mark Farnell
> >         <mark.farnell@gmail.com> wrote:
> >         >> In the kernel, how can I find out the interrupt vector
> >         number of a
> >         >> given IRQ (for example, IRQ7)?
> >         >>
> >         >> Within the kernel module, I would like to manually set the
> >         IRQ using
> >         >> the assembly code:
> >         >>
> >         >> asm("int $<irq vector>");
> >         >>
> >         >> and let the IRQ handler installed by a different module
> >         catch that interrupt.
> >         >>
> >         >> Is this possible?
> >         >
> >         > No really because not all IRQ have an interrupt line to the
> >         CPU.
> >         > Linux can multiplex and emulate them. Think of GPIO drivers
> >         with
> >         > interrupt support.
> >         
> >         Can you please describe this in detail?It would really help a
> >         lot of
> >         people like me.Does multiplex mean that all numbers starting
> >         from
> >         0,1,2,3,...... TOTAL-interrupt will have interrupt lines
> >         associated with it
> >         eventhough all interrupt numbers are not linear?
> > 
> > GPIOs are grouped as banks. Let’s say 32 gpios are in a bank.
> > There will be only single interrupt line to interrupt controller for a
> > bank.
> > 
> > 
> > Consider that you have configured gpio1 and gpio16 as interrupts.
> > Even if interrupt happens on gpio 1 or gpio 16, the same interrupt
> > line will be triggered to 
> >   
> > Interrupt controller.
> > 
> > 
> > Now the gpio driver has to figure out reading the Interrupt status 
> > 
> > Register of GPIO to find which interrupt (gpio1 or gpio16) has really
> > fired.
> And this is done by this way:
> Suppose we have a chip(mfd-multi-funcion-driver) driver which is
> connected to processor using a gpio - this gpio line acts as interrupt
> line from the processor
> 
> ++++++++++++              ++++++++++
> + Processor+              + Chip   +---->USB  interrupt handler
> +          +gpio--------->+ MFD    +---->dock interrupt handler
> ++++++++++++              +        +---->UART interrupt handler
> 			  ++++++++++---->Factory cable interrupt handler
> 
> So the code will be as follows:
> 
> handler_function()
> {	
> 	/* find out which interrupt is triggered */
> 	/* it can be usb,dock,uart or factory cable */
> 	ret_irq = read_mfd_register();
> 	/*
>         * ok we found out the interrupt line, get a corresponding
> 	* software linux irq number by calling
>         * irq_domain_add_linear 
>         * irq_create_mapping 
>         * you would have made this calls in the probe probably
> 	*/ 
>  	handle_nested_irq(ret_irq); 
> }
> 
> handle_nested_irq inturn will call all the irq_handlers in the system
> for your UART,usb and dock driver.
> 
> mfd_driver()
> {	
> 	request_irq(gpio_to_irq(gpio), handler_function);
> }
> 
> Hope I have not missed anything.
> > 
> > So in this case a single interrupt line is multiplex for 32 gpio
> > interrupts.
> > 
> > 
> > HTH.
> > 
> > Thanks,
> > Arun
> >  
> >         > Anyway, why to you think you need to trigger the raw IRQ
> >         manually?
> >         > This sounds really odd...
> >         >
> >         >
> >         > --
> >         > Thanks,
> >         > //richard
> >         >
> >         > _______________________________________________
> >         > Kernelnewbies mailing list
> >         > Kernelnewbies@kernelnewbies.org
> >         >
> >         http://lists.kernelnewbies.org/mailman/listinfo/kernelnewbies
> >         
> >         _______________________________________________
> >         Kernelnewbies mailing list
> >         Kernelnewbies@kernelnewbies.org
> >         http://lists.kernelnewbies.org/mailman/listinfo/kernelnewbies
> >         
> > 
> 


