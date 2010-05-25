Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab0EYPeF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 11:34:05 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:50397 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353Ab0EYPeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 11:34:02 -0400
Date: Tue, 25 May 2010 11:33:39 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Yu, Luming" <luming.yu@intel.com>, Philip Langdale <philipl@overt.org>,
       Jeff Garrett <jeff@jgarrett.org>, Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "venki@google.com" <venki@google.com>
Subject: Re: acpi_idle: Very idle Core i7 machine never enters C3
In-reply-to: <20100525124325.GC7876@srcf.ucam.org>
Message-id: <alpine.LFD.2.00.1005251114420.4114@localhost.localdomain>
References: <87y6jkee1b.fsf@basil.nowhere.org>
 <20100205160900.GA2736@jgarrett.org>
 <alpine.LFD.2.00.1002051238280.4050@localhost.localdomain>
 <20100426194002.586fbaa5@fido5> <20100427124703.GA16706@jgarrett.org>
 <alpine.LFD.2.00.1004301218280.2489@sony>
 <20100430174447.GA14889@srcf.ucam.org>
 <d7f2dd35a4361e5156079278543769a0@localhost>
 <alpine.LFD.2.00.1005250125590.20648@localhost.localdomain>
 <CE761E84DADF2947A4AF22FB8D97A4731E0366B5@shsmsx501.ccr.corp.intel.com>
 <20100525124325.GC7876@srcf.ucam.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: MULTIPART/MIXED; BOUNDARY="8323328-1140314680-1274801622=:4114"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1140314680-1274801622=:4114
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Tue, 25 May 2010, Matthew Garrett wrote:

> On the other hand, the relevant section of spec is:
> 
> "OSPM uses the BM_STS bit to determine the power state to enter when 
> considering a transition to or from the C2/C3 power state. The BM_STS is 
> an optional bit that indicates when bus masters are active. OSPM uses 
> this bit to determine the policy between the C2 and C3 power states: a 
> lot of bus master activity demotes the CPU power state to the C2 (or C1 
> if C2 is not supported), no bus master activity promotes the CPU power 
> state to the C3 power state. OSPM keeps a running history of the BM_STS 
> bit to determine CPU power state policy."
> 
> while the description of the bit itself is:
> 
> "This is the bus master status bit. This bit is set any time a system 
> bus master requests the system bus, and can only be cleared by writing a 
> “1” to this bit position. Notice that this bit reflects bus master 
> activity, not CPU activity (this bit monitors any bus master that can 
> cause an incoherent cache for a processor in the C3 state when the bus 
> master performs a memory transaction)."
> 
> which implies that as long as you don't have any cache coherency 
> concerns, it's acceptable (if potentially suboptimal) to enter C3 even 
> if the bit is set.

As I wrote, the HW people tell me that implication is usually correct,
but there exist cases where it is incorrect.  (Of course the way
it is supposed to work is that when BM_STS is not meaningful,
it always returns zero)

The ACPI spec talks about BM_STS being set by traffic that is incoherent
with the frozen cache of C3, requiring a wake up of the processor
from C3 to snoop the traffic.  It was written 10 years before the
hardware started automatically snooping the L3 when the processor was off,
and before the hardware learned how to automatically flush the cache
to get into deep C-states.  So the description is stale, but the
underlying issue is unchanged.  There exist devices which can not
handle the wakeup latency of some deep C-states.  The BM_STS bit
is a chip-set bit that the BIOS writer can use to prevent the OS
from using the deep C-states when those devices are active.

I'm told that the cases in question are some legacy devices
hanging off the LPC bus, which should be rare.  More interesting
in isochronous traffic over some 1394 controllers -- though
I don't know if Linux runs into that.  If we do, one option
would be to ignore BM_STS, but to use pm_qos to disable the
deep c-state when needed -- a mechanism we've used for
several devices in the past.

I believe that the BIOS writer also has the option to keep
BM_STS set always.  However, that doesn't make sense to me
as it would be simpler to just disable the C-state in _CST
on that platform.

So if we see a nehalem system that has BM_STS *always* set,
even when no devices are active in the system, my guess is
that the BIOS mis-configured the chip-set and we should
ignore that bit.  If BM_STS is changing at run time, then
that is a more interesting situation, and we should endeavor
to find what device activity is changing it.

Len Brown, Intel Open Source Technology Center
--8323328-1140314680-1274801622=:4114--
