Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265Ab0J0VE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 17:04:59 -0400
Received: from c-67-162-90-113.hsd1.in.comcast.net ([67.162.90.113]:58292 "HELO
	kosh.dhis.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757156Ab0J0VE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 17:04:58 -0400
Message-ID: <20101027210457.23673.qmail@kosh.dhis.org>
From: pacman@kosh.dhis.org
Subject: Re: Pegasos OHCI bug (was Re: PROBLEM: memory corrupting bug,
To: olaf@aepfle.de (Olaf Hering)
Date: Wed, 27 Oct 2010 16:04:57 -0500 (GMT+5)
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101027101351.GA28218@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olaf Hering writes:
> 
> On Wed, Oct 27, pacman@kosh.dhis.org wrote:
> 
> > |1. How do I locate all usb nodes in the device tree?
> > |
> > |2. How do I know if a particular usb node is OHCI?
> 
> In the installed system, run 'lspci | grep -i usb', this gives the pci
> bus numbers.  Then run 'find /sys -name devspec', and look or the bus

Once the system is running, I have no problem figuring it out. What I meant
was how do I write some code to identify OHCI devices correctly, from within
the limited environment of the Forth interpreter, which will work in the
general case.

I already know that /pci@80000000/usb@5 and /pci@80000000/usb@5,1 are the
problem nodes on my machine. And I've learned enough about OF to do a full
recursive device tree search to find the USB nodes, so the first question is
answered.

But the UHCI and OHCI nodes look very much alike in the OF properties. "name"
is just "usb" and there's no "compatible".

The big question that I'm still stumbling over is how to access the device
registers. The "reg" property looks like this:
             phys                 size
 -------------------------- -----------------
 00002800 00000000 00000000 00000000 00000000
 02002810 00000000 00000000 00000000 00001000
so I take the second group of 5 words, which should be the device registers,
and try to map it to a virtual address. The members are unpacked on the stack
like this:
  00000000 00000000 02002810 00000000 00001000
which looks like this stack diagram from OF spec:
  map-in ( phys.lo ... phys.hi size -- virt )
and the method call goes like this:
  " map-in" $call-parent
The result: "invalid pointer". But I notice it only popped 4 items. I think
maybe the "size" for map-in is not the same as the "size" found in the reg
property. Maybe #size-cells applies in one place but not the other. Thanks
for not documenting that! Try again:
  00000000 00000000 02002810 00001000 " map-in" $call-parent
This one doesn't complain, but leaves me a 0 on the stack as its answer. The
OHCI registers have been mapped to virtual address 0? Doesn't seem likely.

-- 
Alan Curry
