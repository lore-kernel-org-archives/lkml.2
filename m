Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab0KZT3j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 14:29:39 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:43128 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753760Ab0KZT3i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 14:29:38 -0500
Date: Fri, 26 Nov 2010 11:29:20 -0800
From: Andres Salomon <dilinger@queued.net>
To: Daniel Drake <dsd@laptop.org>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v4 resend] OLPC: Add XO-1 suspend/resume support
Message-ID: <20101126112920.48df6216@debxo>
In-Reply-To: <AANLkTikRoB2xmtwW=ddjJy-RdEpwrwT+5ngV3HC5t5k9@mail.gmail.com>
References: <20101118202837.B24899D401B@zog.reactivated.net>
	<alpine.LFD.2.00.1011261037560.2900@localhost6.localdomain6>
	<AANLkTikRoB2xmtwW=ddjJy-RdEpwrwT+5ngV3HC5t5k9@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Nov 2010 16:28:51 +0000
Daniel Drake <dsd@laptop.org> wrote:

[...]
> Re. the printk thing, this was your doing:
> http://dev.laptop.org/git/olpc-2.6/commit/?h=stable&id=b4334e9e1444761f19806f9066c6b38ce23079bf
[...]
> ---------- Forwarded message ----------
> From: Thomas Gleixner <tglx@linutronix.de>
> Date: 26 November 2010 09:43
> Subject: Re: [PATCH v4 resend] OLPC: Add XO-1 suspend/resume support
> To: Daniel Drake <dsd@laptop.org>
> Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
> 
> 
> On Thu, 18 Nov 2010, Daniel Drake wrote:
> > Feedback after the first submission was quickly acted upon and I
> > haven't been able to get a peep since.
> 
> Sorry, fell off the radar.
> 
> > +
> > +wakeup_start:
> > +#    jmp wakeup_start
> 
>  Debug leftover ?


Leftovers from the original patch; certainly should be removed.


> 
> > +asmlinkage int olpc_xo1_do_sleep(u8 sleep_state)
> > +{
> > +     void *pgd_addr = __va(read_cr3());
> > +     printk(KERN_ERR "xo1_do_sleep!\n"); /* this needs to remain
> > here so
> > +                                           * that gcc doesn't
> > optimize
> > +                                           * away our __va! */
> > +
> 
>  This looks suspect along with the __volatile__ magic below. Care to
>  explain, what you fear that gcc is optimizing away ?
> 


I'm working from memory here; in the version of gcc we were using
at the time (stock FC5 or FC6), setting pgd_addr immediately followed
by the asm below resulted in gcc optimizing away the __va().  The asm
turned into simply:

movl %cr3, %eax

With no mention of PAGE_OFFSET.  Messing with 'volatile' didn't help.
Adding the printk did, as it causes %eax to get clobbered, forcing
temporary storage of %cr3 into a separate register.  A lot has changed
since then (compilers, this code, as well as the definition of
read_cr3()), so I highly suspect that it's no longer needed.
 

> > +     /* Enable wakeup through power button */
> > +     outl((CS5536_PM_PWRBTN << 16) | 0xFFFF, acpi_base + PM1_STS);
> > +
> > +     __asm__ __volatile__("movl %0,%%eax" : : "r" (pgd_addr));
> > +     __asm__("call *(%%edi); cld"
> > +             : : "D" (&ofw_bios_entry));
> > +     __asm__ __volatile__("movb $0x34, %al\n\t"
> > +                          "outb %al, $0x70\n\t"
> > +                          "movb $0x30, %al\n\t"
> > +                          "outb %al, $0x71\n\t");
> 
> Looks good otherwise.
> 
> Thanks,
> 
>        tglx

