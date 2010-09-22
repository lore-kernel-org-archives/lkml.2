Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab0IVQpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 12:45:50 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:26802 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab0IVQpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 12:45:49 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Early console confusion
Date: Wed, 22 Sep 2010 10:44:58 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; x86_64; ; )
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, yinghai@kernel.org,
        just.for.lkml@googlemail.com, tglx@linutronix.de, hpa@linux.intel.com,
        Feng Tang <feng.tang@intel.com>, Alan Cox <alan@linux.intel.com>,
        greg@kroah.com
References: <4C7B0578.8090807@kernel.org> <201009220912.45360.bjorn.helgaas@hp.com> <4C9A271F.30608@zytor.com>
In-Reply-To: <4C9A271F.30608@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009221044.58735.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 22, 2010 09:56:15 am H. Peter Anvin wrote:
> On 09/22/2010 08:12 AM, Bjorn Helgaas wrote:
> > Can somebody explain the differences between
> > 
> > 	earlycon=uart,...
> > 	earlycon=uart8250,...
> > 	earlyprintk=serial,...
> > 	console=uart,...
> > 	console=uart8250,...
> > 
> > I'm not really convinced we need them all, and it's getting a
> > little confusing.
> 
> Some of them come from the embedded industry, where it's felt that you
> have to be able to specify the exact parameters because there are no
> standards, and some come from the PC world where "serial port 0" is a
> well-defined concept and noone wants to bloody call it "uart8250,0x3f8".

OK, my fault for not asking a specific question :-)  Let me try again.

For "earlycon=" and "console=", we support both "uart" and "uart8250".
I see the value of "uart8250", because we might want to support a
non-8250 UART someday.  But keeping "uart" just seems confusing.

We support both of the following, but I can't tell what the difference
is or why we need both:

    earlycon=uart8250,io,0x3f8,9600n8
    console=uart8250,io,0x3f8,9600n8

We support both of the following (per kernel-parameters.txt, anyway),
but again, I don't know what the difference is:

    earlyprintk=serial,ttyS0
    earlyprintk=ttyS0

If we don't like "uart8250,io,0x3f8" (which I agree is awfully clunky),
we could easily add something like "console=com1" which encapsulated
the well-defined PC concept.  It would be similar to "earlyprintk=ttyS0",
and if it could be made *enough* like it, maybe "earlyprintk=ttyS0"
could be dropped.

I also see the recent "earlyprintk=hsu" patch from  Feng Tang, and I
wonder whether that could be recast in the "console=hsu" style.  Like
"com1", "hsu" is apparently enough to specifically identify a device.

I think it's nicer to extend "console=" in ways that allow early
devices, because then users don't have to mess with both "console="
and "earlyprintk=".  The 8250_early driver has a reasonable model
of switching from the early device to the real one automatically,
so maybe something like this is all we would need:

    console=ttyS0  (late only, use whatever device becomes ttyS0)
    console=com1   (early and late, use I/O port 0x3f8 on PCs)
    console=hsu    (early and late, use Medfield UART)
    console=uart8250,mmio,...  (early and late, for MMIO UARTs)
    console=uartXYZ,mmio,...   (early and late, for non-8250 UARTs)
    console=vga    (early and late, use legacy VGA (switch to tty0 late))
    console=tty0   (late only)

Bjorn
