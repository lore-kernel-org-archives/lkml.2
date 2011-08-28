Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527Ab1H1CFs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 22:05:48 -0400
Received: from vm4.telegraphics.com.au ([98.124.60.149]:49081 "EHLO
	vps4.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab1H1CFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 22:05:42 -0400
Date: Sun, 28 Aug 2011 12:08:11 +1000 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Linux/m68k <linux-m68k@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: m68k: [v5] Convert to genirq (WIP)
In-Reply-To: <CAMuHMdUZe0Y55ZPee+umJdEsmY5X-EB-KoC-w-SGEtbPMAcf3g@mail.gmail.com>
Message-ID: <alpine.OSX.2.00.1108271506320.190@ibook.local>
References: <CAMuHMdUZe0Y55ZPee+umJdEsmY5X-EB-KoC-w-SGEtbPMAcf3g@mail.gmail.com>
User-Agent: Alpine 2.00 (OSX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 26 Aug 2011, Geert Uytterhoeven wrote:

> - [PATCH 18/24]: m68k/mac: Optimize interrupts using chain handlers (NEW)

That patch has a mistake --

	irq_set_chained_handler(IRQ_AUTO_4, psc_irq);
	irq_set_handler_data(IRQ_AUTO_3, (void *)0x40);
	irq_set_chained_handler(IRQ_AUTO_5, psc_irq);
	irq_set_handler_data(IRQ_AUTO_3, (void *)0x50);
	irq_set_chained_handler(IRQ_AUTO_6, psc_irq);
	irq_set_handler_data(IRQ_AUTO_3, (void *)0x60);

should be

	irq_set_chained_handler(IRQ_AUTO_4, psc_irq);
	irq_set_handler_data(IRQ_AUTO_4, (void *)0x40);
	irq_set_chained_handler(IRQ_AUTO_5, psc_irq);
	irq_set_handler_data(IRQ_AUTO_5, (void *)0x50);
	irq_set_chained_handler(IRQ_AUTO_6, psc_irq);
	irq_set_handler_data(IRQ_AUTO_6, (void *)0x60);

I also found that the mac_esp driver probe (when in PIO mode) locks up the 
machine. I worked around this by changing the 
disable_irq(IRQ_VIA2_3)/enable_irq(IRQ_VIA2_3) calls to 
local_irq_save/local_irq_restore, but this is not a good solution.

Apparently genirq doesn't permit nested disable_irq/enable_irq calls. But 
I haven't found any outer disable_irq/enable_irq pair yet, so I'm only 
guessing as to the cause of the problem. I'll keep looking.

On one VIA-based machine that I tested, !CONFIG_USE_GENERIC_HARDIRQS 
gives:

# cat /proc/interrupts
auto       1:       2299 via1
auto       2:       3876 via2
auto       4:        562 SCC
auto       7:          0 NMI
mac       10:        590 pmu-shift
mac       12:         90 pmu-clock
mac       14:       1635 timer
mac       17:       3876 nubus
mac       56:       3879 sonic

whereas, CONFIG_USE_GENERIC_HARDIRQS=y gives:

# cat /proc/interrupts
           CPU0       
  4:       5303      auto  SCC
  7:          0      auto  NMI
 10:       2136       mac  pmu-shift
 12:        607       mac  pmu-clock
 14:      41858       mac  timer
 56:      66876       mac  sonic
ERR:          0

Are there no counters for chained IRQs?

Other than these issues everything looks OK. I will test OSS and Baboon 
when I get the relevant hardware set up.

Finn
