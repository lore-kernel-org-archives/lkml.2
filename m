Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524Ab2LKCy1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 21:54:27 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:49656 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab2LKCyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 21:54:25 -0500
MIME-Version: 1.0
In-Reply-To: <slrnkcb00b.77o.narkewoody@zuhnb712.local.com>
References: <slrnkcb00b.77o.narkewoody@zuhnb712.local.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 10 Dec 2012 19:54:03 -0700
Message-ID: <CAErSpo6uWigsw160BfD1ei0M4hQ+wbK1K4Q37+6+_-+iAV3frg@mail.gmail.com>
Subject: Re: Serial8250 doesn't populate in /proc/iomem?
To: Woody Wu <narkewoody@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc@vger.kernel.org, linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc linux-arm, linux-samsung-soc, linux-serial]

On Sun, Dec 9, 2012 at 11:25 PM, Woody Wu <narkewoody@gmail.com> wrote:
> Hi, list
>
> I found some io memory information is lost from /dev/iomem and want to
> find out why.
>
> I have a 2.6.16 kernel running on a ARM board (Samsung S3C2410). From
> the kernel log, I see 16 8250 serial ports were detected, and each of
> thoese ports has a memory address:
>
> Serial: 8250/16550 driver $Revision: 1.90 $ 16 ports, IRQ sharing enabled
> serial8250: tts0 at MMIO 0xe1400000 (irq = 16) is a 16550A
> serial8250: tts1 at MMIO 0xe1400008 (irq = 16) is a 16550A
> serial8250: tts2 at MMIO 0xe1400010 (irq = 17) is a 16550A
> serial8250: tts3 at MMIO 0xe1400018 (irq = 17) is a 16550A
> serial8250: tts4 at MMIO 0xe1400020 (irq = 18) is a 16550A
> serial8250: tts5 at MMIO 0xe1400028 (irq = 18) is a 16550A
> serial8250: tts6 at MMIO 0xe1400030 (irq = 19) is a 16550A
> serial8250: tts7 at MMIO 0xe1400038 (irq = 19) is a 16550A
> serial8250: tts8 at MMIO 0xe1400040 (irq = 48) is a 16550A
> serial8250: tts9 at MMIO 0xe1400048 (irq = 48) is a 16550A
> serial8250: tts10 at MMIO 0xe1400050 (irq = 49) is a 16550A
> serial8250: tts11 at MMIO 0xe1400058 (irq = 49) is a 16550A
> serial8250: tts12 at MMIO 0xe1400060 (irq = 60) is a 16550A
> serial8250: tts13 at MMIO 0xe1400068 (irq = 60) is a 16550A
> serial8250: tts14 at MMIO 0xe1400070 (irq = 61) is a 16550A
> serial8250: tts15 at MMIO 0xe1400078 (irq = 61) is a 16550A
>
> I can read/write these serial ports from /dev/ttys*, in other words,
> they do exist.  I also can find the driver info from /proc/devices:
>
> Character devices:
>
>   ...
>   4 /dev/vc/0
>   4 tty
>   4 tts
>   5 /dev/tty
>   5 /dev/console
>   5 /dev/ptmx
>   7 vcs
>   ...
>
> The problem is, I don't understand why there is no information about
> these ports in /proc/iomem file. The 'iomem' file now contains:
>
> 11000000-11000ffe : AX88796B
> 19000000-19000ffe : AX88796B
> 30000000-33ffffff : System RAM
>   3001c000-301e826b : Kernel text
>   301ea000-302234a3 : Kernel data
> 49000000-490fffff : s3c2410-ohci
>   49000000-490fffff : ohci_hcd
> 4e000000-4e0fffff : s3c2410-nand
>   4e000000-4e0fffff : s3c2410-nand
> 50000000-50003fff : s3c2410-uart.0
>   50000000-500000ff : s3c2410-uart
> 50004000-50007fff : s3c2410-uart.1
>   50004000-500040ff : s3c2410-uart
> 50008000-5000bfff : s3c2410-uart.2
>   50008000-500080ff : s3c2410-uart
> 53000000-530fffff : s3c2410-wdt
> 54000000-540fffff : s3c2410-i2c
> 5a000000-5a0fffff : s3c2410-sdi
>   5a000000-5a0fffff : mmci-s3c2410
>
> You see, there is no serial8250 informations.
>
> Can anyone here please tell me how this can happen?  Does it mean the
> serial8250 driver don't populate or register in the /proc/iomem?

That looks like a bug to me.  There should be entries in /proc/iomem
for the hardware device (showing that something responds at that
address) and for the driver that claims the device.

I think the 8250 core does the reservation in
serial8250_request_std_resource().  You could try putting some printks
in that path to see whether it's exercised.

You're running a fairly old kernel, so it's possible the bug has
already been fixed.

Bjorn
