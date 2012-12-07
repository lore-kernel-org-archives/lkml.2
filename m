Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423908Ab2LGTGu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 14:06:50 -0500
Received: from mx.treblig.org ([80.68.94.177]:49963 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674Ab2LGTGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 14:06:48 -0500
Date: Fri, 7 Dec 2012 19:06:48 +0000
From: "Dr. David Alan Gilbert" <dave@treblig.org>
To: gtdev@spearhead.de
Cc: linux-kernel@vger.kernel.org
Subject: parallel port on Mostech/NetMos Technology PCIe 9912
Message-ID: <20121207190648.GA16006@gallifrey>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.36.4-kvm-i386-20110819 (i686)
X-Uptime: 18:55:49 up 277 days,  5:29,  1 user,  load average: 0.00, 0.01,
 0.05
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicos,
  I've just tried a noname Mostech 9901 Parallel+2 serial card with the
parallel_serial driver and the parallel doesn't seem happy (not tried
the serial yet). It's connected to an ancient Brother HL-1030
(which to be fair is fussy about which USB-parallel leads it works with).

Using the parallel_serial's autodetect in 3.7.0rc5 it finds it as:

Dec  7 18:05:17 thedr kernel: [    8.092836] lp: driver loaded but no devices found
Dec  7 18:05:17 thedr kernel: [    8.637003] parport0: PC-style at 0xe010 (0xe000), irq 18, using FIFO [PCSPP,TRISTATE,COMPAT,ECP]
Dec  7 18:05:17 thedr kernel: [    8.713196] ppdev: user-space parallel port driver
Dec  7 18:05:17 thedr kernel: [    8.749639] lp0: using parport0 (interrupt-driven).

Printing first caused a complete hang, the second time it got further
managing to print about 1/3 of a page before spewing blank pages
rapidly, with the log message:

Dec  7 18:13:15 thedr kernel: [  491.016639] lp0: ECP mode
Dec  7 18:13:29 thedr kernel: [  504.464473] lp0: ECP mode
Dec  7 18:13:39 thedr kernel: [  515.065742] FIFO write timed out
Dec  7 18:13:49 thedr kernel: [  525.138859] FIFO write timed out

Instead I passed parport_pc the io and irq from the lspci and it's working,
although in polling mode:

Dec  7 18:27:14 thedr kernel: [   15.024104] parport0: PC-style at 0xe010, irq 18 [PCSPP,TRISTATE,EPP]
Dec  7 18:27:14 thedr kernel: [   15.024110] parport0: irq 18 in use, resorting to polled operation
Dec  7 18:27:14 thedr kernel: [   15.025954] parport0: Printer, Brother HL-1030 series
Dec  7 18:27:14 thedr kernel: [   15.026157] lp0: using parport0 (polling).

(This is with an Ubuntu Quantal user space - I'm assuming the inuse is
because parport_serial also got loaded).

Here is the lspci -v output:
02:00.0 Serial controller: NetMos Technology PCIe 9912 Multi-I/O Controller (prog-if 02 [16550])
        Subsystem: Device a000:1000
        Flags: bus master, fast devsel, latency 0, IRQ 16
        I/O ports at e030 [size=8]
        Memory at f7c05000 (32-bit, non-prefetchable) [size=4K]
        Memory at f7c04000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: <access denied>
        Kernel driver in use: serial

02:00.1 Serial controller: NetMos Technology PCIe 9912 Multi-I/O Controller (prog-if 02 [16550])
        Subsystem: Device a000:1000
        Flags: bus master, fast devsel, latency 0, IRQ 17
        I/O ports at e020 [size=8]
        Memory at f7c03000 (32-bit, non-prefetchable) [size=4K]
        Memory at f7c02000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: <access denied>
        Kernel driver in use: serial

02:00.2 Parallel controller: NetMos Technology PCIe 9912 Multi-I/O Controller (prog-if 03 [IEEE1284])
        Subsystem: Device a000:2000
        Flags: bus master, fast devsel, latency 0, IRQ 14
        I/O ports at e010 [size=8]
        I/O ports at e000 [size=8]
        Memory at f7c01000 (32-bit, non-prefetchable) [size=4K]
        Memory at f7c00000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: <access denied>
        Kernel modules: parport_serial

The chip package reads:
  Moschip MCS9901CV-CC
  QK1W3-000
  1102

  FZC0AA095

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\ gro.gilbert @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
