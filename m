Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997Ab0JTKky (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 06:40:54 -0400
Received: from 85-18-228-185.ip.fastwebnet.it ([85.18.228.185]:62646 "EHLO
	mail.sadel.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752915Ab0JTKkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 06:40:53 -0400
X-Greylist: delayed 1344 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Oct 2010 06:40:53 EDT
Message-ID: <4CBEC1F4.9080700@sadel.it>
Date: Wed, 20 Oct 2010 12:18:28 +0200
From: Matteo Fortini <matteo.fortini@sadel.it>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100913 Lightning/1.0b1 Icedove/3.0.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: v2.6.34: IDE on IRQ15 starving Serial on IRQ10, not on v2.4
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
we were having serial buffer overruns on a 4800bps 16550A with a Geode 
GX1 SBC,
the serial port is on IRQ10, so it should have higher priority than IDE 
(which is on IRQ15).

The PIC is in XT-PIC-XT mode, we have no APIC unfortunately.

The overruns are triggered easily with a dd if=/dev/hda of=/dev/null

IDE is a CF card using PIO mode 4, no DMA enabled.

We tried various build options, like preemption etc., and we tried both 
ide and libata.

We traced this down to the fact that the IDE subsystem is keeping the 
serial IRQ pending for the whole max request time, which is 256 requests 
in our current setup.

We fixed it by changing the value at drivers/ide/ide-probe.c:751 from 
256 to e.g. 32, which gave the IDE disk less time to keep the others 
pending, but we feel this could be some other issue.

The unmaskirq option as in hdparm -u1 /dev/hda was not fixing the 
problem, and changing the transfer mode to 32bit w/sync didn't either.

The strange thing is that the behavior is completely different in Linux 
2.4.x: we can see with a scope that the IDE request is continuously 
interrupted by the serial port, which should be the default with the 
8259 PIC.

Thank you,
Matteo
