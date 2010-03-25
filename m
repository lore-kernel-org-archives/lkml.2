Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab0CYKrQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 06:47:16 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42032 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752570Ab0CYKrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 06:47:15 -0400
Date: Thu, 25 Mar 2010 10:50:33 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>, jesse.brandeburg@intel.com,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Prevent nested interrupts when the IRQ stack is near
 overflowing v2
Message-ID: <20100325105033.35bceffd@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.1003250201370.3147@localhost.localdomain>
References: <20100324190150.GA18803@basil.fritz.box>
	<alpine.LFD.2.00.1003242125320.3147@localhost.localdomain>
	<alpine.LFD.2.00.1003250001500.3147@localhost.localdomain>
	<20100325003652.GG20695@one.firstfloor.org>
	<alpine.LFD.2.00.1003250201370.3147@localhost.localdomain>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Which leads to the general question why we have that IRQF_DISABLED
> shite at all. AFAICT the historical reason were IDE drivers, but we
> grew other abusers like USB, SCSI and other crap which runs hard irq
> handlers for hundreds of micro seconds in the worst case.

Anyone you've forgotten to offend ?

We have IRQF_DISABLED and stuff using that model because for something
like ten years the Linux kernel had no real sane notion of handing stuff
off to worker threads or threaded irq support and also because there were
so many errata around IRQ masking as well as all the evil business
with interrupt delivery being asynchronous to the PCI or ISA transactions
on some CPUs (eg you could write the irq mask register on the device,
read it back to ensure it occurred and *still* get an IRQ delivered after
that point because it was on the APIC bus)

Dumping everyones code under an insult without any historical context
isn't helpful.

Pretty much the only 'core' driver today which enables IRQs in the irq
handlers and needs it is the old IDE layer. There are also a couple of
drivers which play games with disable/enable_irq in the IRQ paths for
other reasons (lack of irq threads when written and a hardware model thats
totally SMP unfriendly). 8390 is the obvious one here and it at least
would be far far saner using threaded IRQs and normal locking with IRQs
unmasked.

Alan
