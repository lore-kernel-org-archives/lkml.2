Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760385Ab2FUVVT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 17:21:19 -0400
Received: from mailgw13.technion.ac.il ([132.68.225.13]:1036 "EHLO
	mailgw13.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760337Ab2FUVVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 17:21:17 -0400
X-Greylist: delayed 610 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Jun 2012 17:21:16 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAG2N40+ERHMG/2dsb2JhbABFtVeBB4IZAQU6Pw4CC0YUBxExE4gLsSCJBASLKoUiYAOIQIxpAYESiBSGW4Ji
X-IronPort-AV: E=Sophos;i="4.77,453,1336338000"; 
   d="scan'208";a="14638523"
Date: Fri, 22 Jun 2012 00:11:03 +0300
From: "Nadav Har'El" <nyh@math.technion.ac.il>
To: sheng qiu <herbert1984106@gmail.com>
Cc: kvm <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: what is this function mean "is_no_device"?
Message-ID: <20120621211103.GA12824@fermat.math.technion.ac.il>
References: <CAB7xdikRU-8NxxxnAWvPF7xVOn_MxFJ8RJ53Me3vYxnzTiH-Bw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB7xdikRU-8NxxxnAWvPF7xVOn_MxFJ8RJ53Me3vYxnzTiH-Bw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012, sheng qiu wrote about "what is this function mean "is_no_device"?":
> Hi all,
> 
> does anyone can explain what "is_no_device()" and vmx_fpu_activate(vcpu) do?

This is a relatively complicated and delicate issue, so I suggest you
also refer to Intel's spec for more details, and dig deeper into the
relevant Linux code (not just in KVM). But I'll try to give you the gist
of it:

When an OS does a context switch (we're talking about an OS now, not yet
a hypervisor), it needs to save the old process's registers, and load saved
registers of the new process. The original 80386 had few enough registers
to make this switch short enough. But with the math coprocessor (the
80387 - aka the FPU, Floating Point Unit), there was a problem: It had a
bunch of registers, long (80 bits and more) registers, and switching them all
the time was a serious performance problem. This was even more of a
waste since most processes didn't actually use the FPU - so all this
switching was usually done for nothing.

So a trick was invented - "lazy FPU loading". The idea is that when
the OS switches to a different process, it does NOT load the new
process's saved FPU registers. If this process never uses the FPU, we
saved the cost of this load. But what if it *does* use the FPU? A new bit
was added to the CR0 register, the "TS" (task switch) bit. When TS is 1,
the processor "pretends" that there is no FPU (just like the original
8086 had no FPU), so every floating-point operation throws an #NM ("no
math") exception. The OS catches this exception, now finally loads the
current task's FPU registers, and zeros the TS bit. The floating-point
operation now restarts, and since the TS bit is off, it succeeds (and
uses the right content in the registers).

The is_no_device() function you notices checks if an exception is the
NM exception. "device not available" or "no device" are alternative
names of the #NM exception.

To understand vmx_fpu_activate() you need to understand now what KVM
does when both the host processes (after all, KVM is Linux) and
processes in the guest, use the FPU. To make a really long story short,
once any process in the guest uses the FPU, KVM uses "vmx_fpu_activate()"
to say that this guest now has full control of the TS bit, and the NM
exception. This will allow the guest OS to play its usual "lazy FPU loading"
tricks without the host needing to get involved - the host will only care
about the FPU when we later switch tasks from this guest to another guest
or Linux process. And vice versa - the guest might think it wants TS to
be 0 (because it had already set the FPU registers correctly for the current
task) but the host needs it to be 1 (because unknown to the guest, Linux
switched to a different host process and loaded its FPU registers).
All of these games are done using VMX's CR0 shadowing features (which you
can read about in the VMX spec).  

If you think all of this was complicated, just think what it takes to
do all of this correctly in *nested* virtualization (where the host,
guest, and guest's guest all want to delay loading the FPU registers) -
it took me about a month to get that working without bugs ;-)


-- 
Nadav Har'El                        |                  Thursday, Jun 21 2012, 
nyh@math.technion.ac.il             |-----------------------------------------
Phone +972-523-790466, ICQ 13349191 |From the Linux getopt(3) manpage: "BUGS:
http://nadav.harel.org.il           |This manpage is confusing."
