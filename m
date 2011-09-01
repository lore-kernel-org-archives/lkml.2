Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916Ab1IAT4N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 15:56:13 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40856 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757438Ab1IAT4L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 15:56:11 -0400
Subject: gpio-pca953x interrupt feature unreliable
Content-Transfer-Encoding: 8BIT
From: Jean-Francois Dagenais <jeff.dagenais@gmail.com>
Content-Type: text/plain; charset=us-ascii
Message-Id: <BA8BCC80-63E9-4798-9D2D-F6658D1E9F65@gmail.com>
Date: Thu, 1 Sep 2011 15:58:08 -0400
Cc: open list <linux-kernel@vger.kernel.org>,
        broonie@opensource.wolfsonmicro.com, haojian.zhuang@marvell.com
To: maz@misterjones.org, grant.likely@secretlab.ca
Mime-Version: 1.0 (Apple Message framework v1084)
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

(Using 3.1.0-rc4)

I have detected a flaw in the interrupt support of the gpio-pca953x driver. This is how I discovered the issue:

I have a interrupt client device which has it's interrupt signal connected to one of the GPIOs of the pca9555. The client is an ad714x device. It's interrupt routine is falling edge triggered (so says the driver, but according to the AD714x specs, it should be level,low, however this is another topic). The pca9555 is interrupting the CPU through INTA of an ethernet PCI card for which I have only done "echo 1 > /bus/pci/devices/00xyz/enable". It is "(level, low)" which matches the pca953x request_Isr call (IRQF_TRIGGER_LOW | IRQF_ONESHOT). I used two GPOs on some other device to get the !ISR signals. These show the nested nature of the cli ISR called from the pca953x's ISR.

ASCII art of my probing (use a monospace font)
              ___          _______
client !INT      |________|       |________(lost)___
              __________                   _________
cli !ISR                |____|____________|
              ___      ___         _________________
pca953x !INT     |____|   |_______|
              _____                             ____
pca953x !ISR       |___________________________|

(note: the little spike in the cli !ISR marks the end of reading the client's registers, the rest of the ISR is updating driver state machines, etc.)

Summary: The client enters interrupt, which immediately puts the pca953x in interrupt as well. When the pca953x enters it's isr thread, it reads the input status register, this immediately clears the pca953x interrupt. The pca953x ISR then figure's out it should invoke the nested ISR for the client. The client ISR starts by reading the client's status register, which clears the client interrupt. This immediately puts the pca953x back into interrupt since it's a different state that what was last read in the pca953x. This should't be a problem. The real problem is that the client goes back in interrupt before the client ISR even has time to finish. At that moment, the pca953x's input are back to the way they where when the pca953x ISR began and it read the input status register. When all of the ISR routines are done, the client has it's INT line asserted and no more interrupt will come from the pca953x.

The pca953x specs clearly state this: "Resetting the interrupt circuit is achieved when data on the port is changed to the original setting, data is read from the port that generated the interrupt."

So in essence, although the pca953x's design and doc says only edges are detected and supported, the chip design makes it impossible to guarantee that all edges will be caught. In fact, since the chip only has an input state register and no latching interrupt status register, the driver could be slightly modified to support only level based interrupt clients.

I would propose a patch, but I am missing knowledge on the internals of the kernel's irq code, so here's a description, hoping to get some feedback.  In the pca953x_irq_handler (threaded), just after reading the pca953x's input status register (which clears the pca953x INT), just before calling the nested handlers, we could re-enable the IRQ so that the pca953x_irq_handler would be re-scheduled right after if needed. Now this would always happen since the client's clearing of it's INT constitute a change. This is why a hard IRQ handler should be added to re-disable the interrupt to avoid the storm caused by the level,low interrupt. In addition to all this, the driver should be changed to support only LEVEL based clients, since this is what it can reliably detect.

Any thoughts? Hints on the precise APIs to use?

/jfd





