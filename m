Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab2D3Kl0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 06:41:26 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:48951 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab2D3KlZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 06:41:25 -0400
MIME-Version: 1.0
In-Reply-To: <4F9E61FC.8070409@ladisch.de>
References: <fa.CZQqvHf3CBfYWzhSDPNOWxTTD9w@ifi.uio.no>
	<fa.Vmg5vDod2/oKvwyy9BcalhoT+Lo@ifi.uio.no>
	<14969994.2790.1335342903511.JavaMail.geo-discussion-forums@vbbfr18>
	<4F97BA60.4080505@ladisch.de>
	<20120427082203.GB9233@aftab.osrc.amd.com>
	<CAPRPZsCHAOvemogn7mWnWfykhANeEx5K=OG9Xt+veDjEWOiDYA@mail.gmail.com>
	<CA+5PVA6e-JaS809t9=4=SoxX4cFEYfxxb9-KAXk68ENGg6Kw8w@mail.gmail.com>
	<CAPRPZsDDEYUf2a+=ZbwvFw+qJku0UvMLf0+eNDvw+FbinCbysA@mail.gmail.com>
	<CA+5PVA4NJ4fB-qEVB45sz48E7kCdwZ+O5D9jvk16z4hrXSgCwQ@mail.gmail.com>
	<CAPRPZsB=axM88+fGkghbh3qxDv=vRQtfrKqT0e59EZPrrS0V+A@mail.gmail.com>
	<4F9E61FC.8070409@ladisch.de>
Date: Mon, 30 Apr 2012 12:41:24 +0200
Message-ID: <CAPRPZsBV-qJswWDfwMYjidEDsRzR-r5TG0or1--k599=Cju+tw@mail.gmail.com>
Subject: Re: Unhandled IRQs on AMD E-450
From: Jeroen Van den Keybus <jeroen.vandenkeybus@gmail.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Josh Boyer <jwboyer@gmail.com>, Borislav Petkov <borislav.petkov@amd.com>,
        andymatei@gmail.com, "Huang, Shane" <Shane.Huang@amd.com>,
        Borislav Petkov <bp@amd64.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why 5?  This threshold is likely to be too low; fast consecutive interrupts
> can easily happen more often with a very busy device, while an actual stuck
> interrupt will call the handler in an endless loop and very quickly result
> in many thousands of calls.

Well, 5 works fine on any machine I have tested so far. I'd like to
keep this number as low as possible in case a genuine stuck interrupt
is encountered. Computers are powerful, but I'm reluctant to spill
cycles and power.

Also, on an unshared interrupt line, unhandled IRQs should never
happen in succession. No work to be done by a handler should be the
result of acknowledging early and getting a new interrupt when work
grows in the meantime. After the resulting idle run there's no way a
properly working driver could end up being interrupted again for no
reason (aside from broken drivers and broken hardware, i.e. hardware
emitting MSIs without getting acknowledgement). Am I right ?

For shared IRQs unhandled IRQs may indeed be encountered. For this
reason, I set SPURIOUS_IRQ_TRIGGER to 5.

Of course, even if it misfires, we're back on track in a second.

On the other hand, setting it temporarily to a high value has the
benefit of being able to look at /proc/irq/.../spurious and see how
high level_max has gotten on a variety of machines. What would then be
a sensible number here ?

Also, FYI, here's the result of '$ cat /proc/irq/*/spurious' on the
E45M1-M PRO. IRQ45 is the AHCI handler and IRQ16  belongs to a device
behind the ASM1083. It is the Firewire chip emitting an interrupt
roughly every minute. When it misses, it is clearly seen how a new
PCIe assert/deassert message pair manages to reset the stuck line. In
this case, the system has switched 81 times in succession to polling
mode.

irq=  0 stuck_count=  0 stuck_level_max=  0
irq= 10 stuck_count=  0 stuck_level_max=  0
irq= 11 stuck_count=  0 stuck_level_max=  0
irq= 12 stuck_count=  0 stuck_level_max=  0
irq= 13 stuck_count=  0 stuck_level_max=  0
irq= 14 stuck_count=  0 stuck_level_max=  0
irq= 15 stuck_count=  0 stuck_level_max=  0
irq= 16 stuck_count= 81 stuck_level_max=  0
irq= 17 stuck_count=  0 stuck_level_max=  0
irq= 18 stuck_count=  0 stuck_level_max=  0
irq= 19 stuck_count=  0 stuck_level_max=  0
irq=  1 stuck_count=  0 stuck_level_max=  0
irq=  2 stuck_count=  0 stuck_level_max=  0
irq=  3 stuck_count=  0 stuck_level_max=  0
irq= 40 stuck_count=  0 stuck_level_max=  0
irq= 41 stuck_count=  0 stuck_level_max=  0
irq= 42 stuck_count=  0 stuck_level_max=  0
irq= 43 stuck_count=  0 stuck_level_max=  0
irq= 44 stuck_count=  0 stuck_level_max=  0
irq= 45 stuck_count=  0 stuck_level_max=  1
irq= 46 stuck_count=  0 stuck_level_max=  0
irq= 47 stuck_count=  0 stuck_level_max=  0
irq=  4 stuck_count=  0 stuck_level_max=  0
irq=  5 stuck_count=  0 stuck_level_max=  0
irq=  6 stuck_count=  0 stuck_level_max=  0
irq=  7 stuck_count=  0 stuck_level_max=  0
irq=  8 stuck_count=  0 stuck_level_max=  0
irq=  9 stuck_count=  0 stuck_level_max=  0


>> --- linux-3.2.16.orig/include/linux/irqdesc.h 2012-04-23
>> 00:31:32.000000000 +0200
>
> Your mailer wraps lines; see Documentation/email-clients.txt.

Great. I only have gmail accounts. Documentation states it won't work
with gmail. Any suggestions ?


Jeroen.
