Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933000Ab0I0SGq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 14:06:46 -0400
Received: from www.tglx.de ([62.245.132.106]:36755 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755835Ab0I0SGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 14:06:43 -0400
Date: Mon, 27 Sep 2010 20:01:26 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tony Luck <tony.luck@intel.com>
cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>, linux-alpha@vger.kernel.org,
        linux-cris-kernel@axis.com, Haavard Skinnemoen <hskinnemoen@atmel.com>,
        linux-ia64@vger.kernel.org,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Greg Ungerer <gerg@uclinux.org>, Jeff Dike <jdike@addtoit.com>,
        linux-parisc@vger.kernel.org, Chris Zankel <chris@zankel.net>,
        linux-arch@vger.kernel.org
Subject: Re: [RFC trollpatch 1/1] genirq: Remove the fits all and nothing
 __do_IRQ() code
In-Reply-To: <AANLkTikVHO9DmyTX==CwViDK1rP0masBwjMakHZ0U=kZ@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1009271953390.2416@localhost6.localdomain6>
References: <20100908152036.643594727@linutronix.de> <AANLkTikVHO9DmyTX==CwViDK1rP0masBwjMakHZ0U=kZ@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463795968-1703548383-1285610489=:2416"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463795968-1703548383-1285610489=:2416
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT



On Mon, 27 Sep 2010, Tony Luck wrote:

> On Wed, Sep 8, 2010 at 11:14 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >  The following architectures are still using __do_IRQ():
> >
> >  alpha, cris, ia64, h8300, m32r, m68knommu, parisc, um
> 
> Thomas,
> 
> I (belatedly) took a look at fixing ia64 ... but I've run into a small snag.
> The __do_IRQ() routine makes a call to:
> 
>  desc->chip->end(irq);
> 
> while neither of the "handle_level_irq()" nor "handle_edge_irq()"
> functions do this.
> 
> On ia64 iosapic_end_level_irq() call iosapic_eoi() for me. Without it
> my system hangs during boot (with some driver timeout complaining
> about dropped interrupts).
> 
> Is the omission of desc->chip->end(irq); deliberate? In which case
> I need to find another place to call iosapic_eoi(). Or is it accidental?

No, it's deliberate. The solution is to use the correct flow handler
for your device. We have currently several flow handlers implemented:

    handle_level_irq
	{
		if (chip->mask_ack)
			chip->mask_ack()
		else {
		     chip->mask();
		     if (chip->ack)
		     	chip->ack();
		}

		....

		chip->unmask();
	}

    handle_edge_irq
	{
		chip->ack()

		...
	}

    handle_simple_irq
	{
		...
	}

    handle_fasteoi_irq
	{
		...
		chip->eoi();
	}

    handle_percpu_irq
	{	
		if (chip->ack)
		     	chip->ack();
		
		if (chip->eoi)
		     	chip->eoi();
	}

Note, that handle_percpu_irq does not take the irq_desc->lock.

So the trick is to select the matching handler and have separate irq
chip implementations if necessary.

Hope that helps.

Thanks,

	tglx

---1463795968-1703548383-1285610489=:2416--
