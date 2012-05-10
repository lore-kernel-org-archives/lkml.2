Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761041Ab2EJSTY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 14:19:24 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:43182 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756214Ab2EJSTW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 14:19:22 -0400
Subject: gpio: pca953x: interrupt feature unreliable (re-re-send, Grant please acknowledge!!)
Content-Transfer-Encoding: 8BIT
From: Jean-Francois Dagenais <jeff.dagenais@gmail.com>
Content-Type: text/plain; charset=us-ascii
Message-Id: <8495990E-0B78-4B47-A00D-36D45DC3450F@gmail.com>
Date: Thu, 10 May 2012 14:19:17 -0400
Cc: torvalds@linux-foundation.org, open list <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, eric.miao@marvell.com,
        maz@misterjones.org
To: Grant Likely <grant.likely@secretlab.ca>, linus.walleij@stericsson.com
Mime-Version: 1.0 (Apple Message framework v1084)
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here's a fun, yet potentially dangerous problem.

I've sent this twice already, without any feedback. I'm just trying to get more 
visibility on this because I believe it to be a serious issue depending where 
this chip may be used. Interrupts could be missed in what could be very tough 
conditions to replicate. In my setup I could reproduce the problem easily and 
took great care in analysing and documenting it.
===============Re-Re-Send (with edits)==================
Hi all,
(Using 3.1.0-rc4, didn't change since)

I have detected a flaw in the interrupt support of the gpio-pca953x driver. 
This is how I discovered the issue:

I have a interrupt client device which has it's interrupt signal connected to 
one of the GPIOs of the pca9555. The client is an ad714x device. It's interrupt 
routine is falling edge triggered (so says the driver, but according to the 
AD714x specs, it should be level,low, however this is another topic). The 
pca9555 is interrupting the CPU through INTA of an ethernet PCI card for which 
I have blacklisted the driver module and only done "echo 1 > 
/bus/pci/devices/00xyz/enable". It is "(level, low)" which matches the pca953x 
request_threaded_isr call (IRQF_TRIGGER_LOW | IRQF_ONESHOT). I used two GPOs on 
some other device to get the !ISR signals shown below. These show the nested 
nature of the cli ISR called from the pca953x's ISR.
ASCII art of my probing (use a monospace font, "!ISR"==low, mean ISR running)

Events(lined-up):1  2 3 4 5  6    7       8    9
             ____          _______
client !INT      |________|       |________(lost)___
             ___________                   _________
cli !ISR                |____|____________|
             ____      ___         _________________
pca953x !INT     |____|   |_______|
             ______                             ____
pca953x !ISR       |___________________________|
(note: the little spike in the cli !ISR marks the end of reading the client's 
status registers, the rest of the ISR is updating driver state machines, etc.)

Summary: The client enters interrupt(1), which immediately puts the pca953x in 
interrupt as well(1). When the pca953x enters it's isr thread(2), it reads the 
input status register, this immediately clears the pca953x interrupt(3). The 
pca953x ISR then figure's out it should invoke the nested ISR for the client. 
The client ISR starts (4) by reading the client chip's status register, which 
clears the client interrupt(5). This immediately puts the pca953x back into 
interrupt (5) since it's a different state than what was last read in the 
pca953x ISR(3). Since pca953x registered it's interrupt with IRQF_ONESHOT, this 
new IRQ state is masked and goes un-noticed. The pca953x chips' FLAW IS THEN 
REVEILED if/when the client chip goes back in interrupt before (7) the client 
ISR (and the pca053x's ISR with the current code) even has time to finish(8 and 
9). At that moment, the pca953x's input are back to the way they where when the 
pca953x ISR last read the input status register. So when all of the ISR 
routines are done (9...), the client has it's INT line asserted and no more 
interrupt will come from the pca953x because of this.

pca953x specs quote: "Resetting the interrupt circuit is achieved when data on 
the port is CHANGED TO THE ORIGINAL SETTING, data is read from the port that 
generated the interrupt or in a Stop event. [...] Interrupts that occur during 
the ACK or NACK clock pulse CAN BE LOST (or be very short) due to the resetting 
of the interrupt during this pulse."

So in essence, although the pca953x.c's design and doc says only edges are 
detected and supported, the chip design makes it IMPOSSIBLE to guarantee that 
all edges will be caught.

The IRQ function SHOULD BE REMOVED from the driver since the chip cannot honor 
the driver's promise. At the very least, for system integrators that want to 
use level base interrupts implemented by the pca953x, changes to the driver 
should be made to correctly handle the lack of LATCHING INTERRUPT STATUS 
register...

I would propose a patch, but I am missing knowledge on the internals of the 
kernel's irq code, so here's a simple suggestion description, hoping to get 
some feedback.

First of all, I propose pca953x_irq_set_type should only support 
IRQ_TYPE_LEVEL_HIGH and IRQ_TYPE_LEVEL_LOW. pca953x_irq_handler should be 
adjusted accordingly.

To make sure we catch as many transitions of pca953x chips INT as possible 
(yikes), we make pca953x_irq_setup() request it's own interrupt as both rising 
and falling (IRQF_TRIGGER_RISING|IRQF_TRIGGER_FALLING, is that even possible?) 
without IRQF_ONESHOT, so that pca953x_irq_handler is rescheduled for running 
even when it's already running.

Any thoughts? Maybe there are more/less fancy, or better yet, "correct" ways of 
doing this? Will this even work?

/jfd

