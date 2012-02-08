Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab2BHObS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 09:31:18 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:46602 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969Ab2BHObR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 09:31:17 -0500
Date: Wed, 8 Feb 2012 14:32:38 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adam Jackson <ajax@redhat.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, gregkh@linuxfoundation.org
Subject: Re: [PATCH 1/2] char/mem: Add /dev/io (v2)
Message-ID: <20120208143238.0003287e@pyramind.ukuu.org.uk>
In-Reply-To: <4F3280C7.1030401@redhat.com>
References: <1328623901-20628-1-git-send-email-ajax@redhat.com>
	<1328657985-13942-1-git-send-email-ajax@redhat.com>
	<20120208001724.7e5c7be4@pyramind.ukuu.org.uk>
	<4F31C417.30502@redhat.com>
	<20120208092611.49ada8c5@pyramind.ukuu.org.uk>
	<4F3280C7.1030401@redhat.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > They are both equally insane and have effectively identical security
> > semntics. Continuing to use iopl is both faster and avoids adding a kernel
> > API however. Even better it's x86 specific so that piece of manure
> > doesn't escape onto other platforms without the legacy vesa mess.
> 
> Every point in this paragraph is at best misleading, if not outright wrong.

Really - exactly where is it wrong. None of your claims below seems
valid. I think my statement is accurate even after your response.
> 
> iopl does not have identical security semantics to ioperm.  iopl lets my 

I didn't mention ioperm. I said /dev/ports

> X server disable interrupts.  /dev/io would not, and would let me add a 

Yes it would - you can issue I/O accesses to the interrupt controller. So
let me repeat that - the two are the same thing and equally insane.

> Your definition of "faster" is spurious.  VBE calls are not a 

You are not the only user of iopl, and they are faster. You may not
*care* about the speed difference but the fact is they are faster.

> performance path and system call overhead is negligible compared to I/O 
> serialization.  If anything /dev/io can be _faster_ in the mainline case 
> because we'll no longer need to handle the ioperm bitmask on every 
> context switch.

See before - I never mentioned ioperm.

> The current patch set results in a net gain of zero kernel interfaces, 
> once /dev/port is put down in a year.  I will admit that the current 

People will be shipping code using it for years.

> /dev/port is probably not a meaningfully used API, seeing how it's been 
> broken since literally kernel 0.10.  But it's there and enabled by 
> default.  I would like it to work, please.

So why hasn't it changed - because nobody has had a problem with it.

> Invoking architecture-specificity is spurious.  Competent architectures 
> have a usable framebuffer interface from the firmware, so vesa never 
> comes up.

Exactly - so they don't need another port interface.
 
> Basically what I'm hearing here is "don't bother doing this well since 
> you already have a way you're doing it badly".  That's crap.  I've 
> written the code to do it well.  I've signed up for the support cost. 
> Can I please have something good instead of something bad?  I sort of 
> thought "good" was the whole point of what we're doing here.

I'm all for doing it well but that isn't doing it well. Its adding
another turd which is logically and functionally equivalent to the
existing one. Two turds is not usually better than one unless you are
running a methane digestion plant.

iopl is functionally equivalent to your io port code. It's already in the
kernel, it already works and it's already maintained.

To be useful a port interface really needs to aware of hotplug, device
mappings and the like. For VESA that's going to be pretty horrible both
because of the uncontrolled nature of the interface and because of the
vga "magic" both for ports and routing.

An interface where you could do something like

	open a port channel
	bind device X to port channel  (imports its I/O ranges)
	bind portrange A-B to port channel (for nasties like the vga
				ports)

read/write in 1/2/4/(8 ?) byte chunks meaningfully

	close

and which properly handled device hotplug - ie if you bind to device X, X
is unplugged then the next read/write errors, or at least the address
space is not freed until it isn't in the port range space.

Now that would be an improvement, but it seems to be a fair amount of
work.

Alan



