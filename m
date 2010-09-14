Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab0INOx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 10:53:27 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56904 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753776Ab0INOx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 10:53:26 -0400
Date: Tue, 14 Sep 2010 16:14:33 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Thomas Richter <thor@math.tu-berlin.de>
Cc: linux-kernel@vger.kernel.org, benh@kernel.crashing.org
Subject: Re: parport_pc: irq= parameter with limited usefulness, kernel hang
 on PPC/OldWorldMac
Message-ID: <20100914161433.55457b6f@lxorguk.ukuu.org.uk>
In-Reply-To: <4C8F88EC.2020009@math.tu-berlin.de>
References: <4C8F88EC.2020009@math.tu-berlin.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> *) Under at least 2.6.31 and up, the kernel assigns IRQ 25 to the card. 
> Under 2.6.28 and below, the card
> was run in polling mode (i.e. irq was -1, not 25).
> 
> *) Furthermore, the above report suggests that the system wants to 
> handle an edge-triggered IRQ, though
> according to /proc/interrupts, IRQ 25 is level-triggered.

The parport_pc code just asks for the IRQ so any level/edge mismatch
would appear to be coming from the firmware or architecture code. The
older kernel didn't know to use the IRQ on PCI devices which stopped some
things working and hurt performance. That would also have masked the bug
you see - so the report makes total sense.

> should, according to the documentation and the parport_pc.c source do 
> that. For reasons beyond me, the kernel module wants
> to be smarter than I and *still* enables the IRQ. I'm pretty sure that 

The options only apply to legacy ports - it has always been that way.
It's not clear how you would specify which port to affect otherwise.

> *) parport_pc should take irq=none seriously and should not silently 
> override it,

parport_pc could do with a way to specify whether to use the IRQ or DMA
on PCI ports but really this shouldn't be needed if the rest of the
kernel logic is right.

> *) parport_pc should at least not crash the system completely in case 
> the IRQ is enabled.
> 
> The latter *might* be an issue with the G3 powermac hardware, which is 
> of course weird and has a couple of hardware

The latter looks like a bug in the PPC side support, perhaps misreporting
an IRQ, or mislabelling it in some way. I think the first step is to find
a PPC hacker who can figure out why the apparently sane IRQ request from
the parport layer is exploding.

Even if there is some technical reason the IRQ can't be used then the arch
code shouldn't be reporting an IRQ for it, and the parport_pc could ought
to just work.

Adding Ben to the Cc: so we it can get hunted down.

Alan
