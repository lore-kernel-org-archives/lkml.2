Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759998Ab2C3J7k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 05:59:40 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:51084 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144Ab2C3J7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 05:59:34 -0400
Message-ID: <4F758400.3080907@suse.cz>
Date: Fri, 30 Mar 2012 11:59:28 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120320 Thunderbird/13.0a2
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Keith Packard <keithp@keithp.com>, dri-devel@lists.freedesktop.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        LKML <linux-kernel@vger.kernel.org>, daniel@ffwll.ch
Subject: Re: i915_driver_irq_handler: irq 42: nobody cared
References: <4F717CE3.4040206@suse.cz> <4F717D80.9040207@suse.cz>
In-Reply-To: <4F717D80.9040207@suse.cz>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2012 10:42 AM, Jiri Slaby wrote:
> On 03/27/2012 10:40 AM, Jiri Slaby wrote:
>> Hi,
>>
>> I'm getting spurious interrupts leading to disabling the interrupt:
>>  42:    1916853    2471662   PCI-MSI-edge      i915@pci:0000:00:02.0
>>
>> The message:
>> irq 42: nobody cared (try booting with the "irqpoll" option)
>> Pid: 20716, comm: virtuoso-t Not tainted 3.3.0-next-20120326_64+ #1673
>>
>> It is not new, but now I can reproduce it more-or-less reliably after an
>> hour or so. It usually happens when playing a game using wine.
>>
>> Do you want me to dump some registers when IRQ_NONE is returned from the
>> ISR? As this is MSI, nobody else can sit there.

The handler *constantly* returns IRQ_NONE.

With this patch:
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -28,6 +28,7 @@

 #include <linux/sysrq.h>
 #include <linux/slab.h>
+#include <linux/ratelimit.h>
 #include "drmP.h"
 #include "drm.h"
 #include "i915_drm.h"
@@ -1416,6 +1417,14 @@ static irqreturn_t
i915_driver_irq_handler(DRM_IRQ_ARGS)
                iir = new_iir;
        }

+       if (ret == IRQ_NONE && printk_ratelimit()) {
+               printk(KERN_DEBUG "%s:", __func__);
+               for_each_pipe(pipe) {
+                       printk(KERN_CONT " %d=%.8x", pipe,
+                                       pipe_stats[pipe]);
+               }
+       }
+
        return ret;
 }

And I get:
[ 3572.968581] i915_driver_irq_handler: 0=00000000 1=00000000
[ 3572.977472] i915_driver_irq_handler: 0=00000000 1=00000000
[ 3576.224839] i915_driver_irq_handler: 0=00000000 1=00000000
[ 3576.243558] i915_driver_irq_handler: 0=00000000 1=00000000
[ 3576.384912] i915_driver_irq_handler: 0=00000000 1=00000000
[ 3576.403462] i915_driver_irq_handler: 0=00000000 1=00000000
[ 3577.464100] i915_driver_irq_handler: 0=00000000 1=00000000
[ 3577.477383] i915_driver_irq_handler: 0=00000000 1=00000000
[ 3577.829016] i915_driver_irq_handler: 0=00020000 1=00000000
[ 3577.830093] i915_driver_irq_handler: 0=00020000 1=00000000
[ 3578.013015] i915_driver_irq_handler: 12 callbacks suppressed

I don't know what to dump more, because iir is obviously zero too. What
other sources of interrupts are on the (G33) chip?

> Also lspci:
> 00:02.0 VGA compatible controller [0300]: Intel Corporation 82G33/G31
> Express Integrated Graphics Controller [8086:29c2] (rev 02) (prog-if 00
> [VGA controller])
>         Subsystem: Intel Corporation 82G33/G31 Express Integrated
> Graphics Controller [8086:29c2]
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx+
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0
>         Interrupt: pin A routed to IRQ 42
>         Region 0: Memory at feb80000 (32-bit, non-prefetchable) [size=512K]
>         Region 1: I/O ports at ec00 [size=8]
>         Region 2: Memory at d0000000 (32-bit, prefetchable) [size=256M]
>         Region 3: Memory at fea00000 (32-bit, non-prefetchable) [size=1M]
>         Expansion ROM at <unassigned> [disabled]
>         Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
>                 Address: fee0300c  Data: 4179
>         Capabilities: [d0] Power Management version 2
>                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>         Kernel driver in use: i915
> 00: 86 80 c2 29 07 04 90 00 02 00 00 03 00 00 00 00
> 10: 00 00 b8 fe 01 ec 00 00 08 00 00 d0 00 00 a0 fe
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 c2 29
> 30: 00 00 00 00 90 00 00 00 00 00 00 00 05 01 00 00
> 40: 09 00 0b 01 00 00 00 00 01 00 00 00 00 00 00 00
> 50: 00 00 30 02 c9 03 00 00 00 00 00 00 00 00 80 af
> 60: 00 00 02 02 00 00 00 00 00 00 00 00 00 00 00 00
> 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 90: 05 d0 01 00 0c 30 e0 fe 79 41 00 00 00 00 00 00
> a0: 11 11 00 00 00 00 06 03 00 00 00 00 00 00 00 00
> b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> d0: 01 00 22 00 00 00 00 00 00 00 00 00 00 01 02 00
> e0: 00 00 00 00 00 00 00 00 00 80 00 00 00 00 00 00
> f0: 10 00 00 00 00 00 00 00 90 0f 03 00 e4 e0 5b af
> 
>> thanks,
-- js suse labs

