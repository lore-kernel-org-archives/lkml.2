Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481Ab0LWAMq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 19:12:46 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:65513 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab0LWAMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 19:12:44 -0500
Message-ID: <4D1293F0.7030506@bugs.id.au>
Date: Thu, 23 Dec 2010 11:12:32 +1100
From: Grant Coady <email@bugs.id.au>
Organization: scattered
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-AU; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Problem with shared interrupt latency with a RAID6 array?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

[repeat send different account as as original lost]

Built my first RAID6 array with 5 x 1TB SATA drives.

I notice this odd number in the SMART values for the last two drives on the
array.  The drives connect to an Intel ICH9R chip, the mobo has a 2.13GHz
Core2Duo CPU and 4GB memory, running Slackware64-13.1 with 2.6.36.2a kernel.

While feeding data into the array from a USB 2.0 attached drive, the box's
load average was about 3.5, the box was very responsive and I transferred
over 900GB into the RAID6 array.

The fourth and fifth drives report lots of command timeouts in the SMART
data.  Is this a problem?

Is it because the drives share an interrupt?

Extract from dmesg:

root@pooh:~# egrep -e '^(ahci|ata)' /var/log/dmesg
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ahci 0000:00:1f.2: irq 40 for MSI/MSI-X
ahci: SSS flag set, parallel bus scan disabled
ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pmp pio slum part ccc ems
ahci 0000:00:1f.2: setting latency timer to 64
ata1: SATA max UDMA/133 abar m2048@0xf6386000 port 0xf6386100 irq 40
ata2: SATA max UDMA/133 abar m2048@0xf6386000 port 0xf6386180 irq 40
ata3: SATA max UDMA/133 abar m2048@0xf6386000 port 0xf6386200 irq 40
ata4: SATA max UDMA/133 abar m2048@0xf6386000 port 0xf6386280 irq 40
ata5: SATA max UDMA/133 abar m2048@0xf6386000 port 0xf6386300 irq 40
ata6: SATA max UDMA/133 abar m2048@0xf6386000 port 0xf6386380 irq 40
ata7: PATA max UDMA/100 cmd 0xc000 ctl 0xc100 bmdma 0xc400 irq 16
ata8: PATA max UDMA/100 cmd 0xc200 ctl 0xc300 bmdma 0xc408 irq 16
ata7.00: ATAPI: PIONEER DVD-RW  DVR-110D, 1.41, max UDMA/66
ata7.00: configured for UDMA/66
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-8: ST31000528AS, CC46, max UDMA/133
ata1.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/133
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: ATA-8: ST31000528AS, CC46, max UDMA/133
ata2.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata2.00: configured for UDMA/133
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.00: ATA-8: ST31000528AS, CC46, max UDMA/133
ata3.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata3.00: configured for UDMA/133
ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata4.00: ATA-8: ST31000528AS, CC46, max UDMA/133
ata4.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata4.00: configured for UDMA/133
ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata5.00: ATA-8: ST31000528AS, CC46, max UDMA/133
ata5.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata5.00: configured for UDMA/133
ata6: SATA link down (SStatus 0 SControl 300)

And here's SMART's command timeout numbers:

root@pooh:~# for d in a b c d e; do smartctl -a /dev/sd${d} |grep Command_Timeout; done
188 Command_Timeout         0x0032   100   100   000    Old_age   Always       -       0
188 Command_Timeout         0x0032   100   100   000    Old_age   Always       -       0
188 Command_Timeout         0x0032   100   100   000    Old_age   Always       -       0
188 Command_Timeout         0x0032   100   100   000    Old_age   Always       -       65537
188 Command_Timeout         0x0032   100   100   000    Old_age   Always       -       65537

Is this a problem?  Is there something I can change in the .config?

Config and full dmesg are at:

   http://bugsplatter.id.au/kernel/boxen/pooh/config-2.6.36.2a.gz
   http://bugsplatter.id.au/kernel/boxen/pooh/dmesg-2.6.36.2a.gz

Ask, and I'll provide more info, do tests and so on.

Could this issue be related to RAID6 unreliability reports one finds for
some Linux based NAS devices on the 'net?

Thanks,
Grant.
