Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab0INOcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 10:32:53 -0400
Received: from charybdis.rus.uni-stuttgart.de ([129.69.1.58]:46065 "EHLO
	charybdis.rus.uni-stuttgart.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752060Ab0INOcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 10:32:50 -0400
X-Greylist: delayed 605 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Sep 2010 10:32:50 EDT
Message-ID: <4C8F8531.8000006@math.tu-berlin.de>
Date: Tue, 14 Sep 2010 16:22:41 +0200
From: Thomas Richter <thor@math.tu-berlin.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: ALSA: Midi on emu10k1 broken for more than 2GB memory
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks, (please forward replies to thor@math.tu-berlin.de - thanks)

the following is a question and a quick dirty fix for midi problems on 
the emu10k1 (Soundblaster) cards for 64 bit systems
with more than 2GB memory. Problem of this card is, as the alsa team is 
definitely aware of, that the card can only DMA into
the lowest 2GB of memory, PCI DMA seems to use only 31 bit of the 
available 32 bit. The current emu10k1 driver is aware of
this problem and uses the following strategy to allocate DMA memory for 
the card:

i) Get regular memory,
- if the result has bits 31 or above set,
ii) fall back to the ISA (16MB) memory zone.

Unfortunately, the ISA memory zone runs out of memory pretty early - 
this means that it is for typical configurations not
possible to load soundfonts, they simply won't fit. As a result, midi 
output is broken.

Many linux distributions work around this by offering a timidity based 
midi-server, but this is in so far unsatisfactory as it causes
additional CPU load, besides the problem lies a bit deeper in the kernel 
memory management and its unability to allocate
memory for such broken hardware flexible enough.

A possible quick workaround would be a kernel option (probably under 
"kernel hacking") to make the 32bit DMA zone a 31bit DMA
zone, i.e. in

arch/x86/include/asm/dma.h

make this line

#define MAX_DMA32_PFN ((4UL * 1024 * 1024 * 1024) >> PAGE_SHIFT)

configurable. I'm currently running a custom-patched 2.6.32.21 with this 
configuration active, and run the same modification on
several kernels before without observing any major drawback from that, 
the system runs stable (and of course, with emu10k1 midi).

I'm not really competent enough to provide a patch that would integrate 
nicely into the configuration mechanism, but it seems easy
enough to do until a better memory management becomes available.

The system here is a Asus M2N with 6GB memory and an 
emu10k1/soundblaster card, though the board shouldn't really matter, it
is a emu10k1 problem that appears whenever more than 2GB are in the system.

Comments, suggestions, activities?

Thanks,

Thomas

