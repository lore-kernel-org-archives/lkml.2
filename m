Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab1EGBrw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 21:47:52 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47622 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab1EGBru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 21:47:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:from:date:x-google-sender-auth:message-id
         :subject:to:content-type;
        b=sqyqG6rU3okYAJDmi1MZlogyFG0lySz4DOJBGa7VNbZ6Xpxwh8QTduLRP/yjmrPlqn
         P15O7dodcPl+426h6aO49jA2iq+M4QNxP9/ywqsn86h9PkodZ/tCxPNC91MgpB/ycqgA
         zAH7o3UOM5ApEB+cDQSVKAYSP5ZvLJq/3dawc=
MIME-Version: 1.0
From: Andrew Lutomirski <luto@mit.edu>
Date: Fri, 6 May 2011 21:47:30 -0400
X-Google-Sender-Auth: yjFoa-pmDPqc5s6sHx9JjrXvaiM
Message-ID: <BANLkTiniZQovB6mYwfi4x1=JYuGMh1y6Cw@mail.gmail.com>
Subject: [2.6.39 regression] Cougar Point ahci COMRESET on boot
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(This is only a regression in the sense that the bug exists in 2.6.38
but is much worse in 2.6.39-rc6.)

I have two Sandy Bridge / Cougar Point machines: one H67 desktop and
one QM67 laptop.  They have disks from different manufacturers.  Both
of them have trouble loading ahci on bootup.  On 2.6.38.5, the symptom
is that, on boot, the system waits 10 seconds or so, then generates a
COMRESET failed (errno=-16) error, then works.  On 2.6.39-rc6, it's
worse: it gives the COMRESET error three times and then brings up the
disk at 1.5Gbps.  That means that my bootup time goes from 10 seconds
or so on 2.6.38 to 56 seconds on 2.6.39-rc6.

On the desktop on 2.6.38, dmesg |egrep -i 'ata|ahci' says:

[    0.857245] libata version 3.00 loaded.
[    2.036680] ahci 0000:00:1f.2: version 3.0
[    2.036707] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.036768] ahci 0000:00:1f.2: irq 44 for MSI/MSI-X
[    2.047240] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6
Gbps 0xd impl SATA mode
[    2.047245] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio
slum part ems apst
[    2.047252] ahci 0000:00:1f.2: setting latency timer to 64
[    2.052019] scsi0 : ahci
[    2.052135] scsi1 : ahci
[    2.052241] scsi2 : ahci
[    2.052329] scsi3 : ahci
[    2.052421] scsi4 : ahci
[    2.052509] scsi5 : ahci
[    2.052722] ata1: SATA max UDMA/133 abar m2048@0xfe625000 port
0xfe625100 irq 44
[    2.052724] ata2: DUMMY
[    2.052727] ata3: SATA max UDMA/133 abar m2048@0xfe625000 port
0xfe625200 irq 44
[    2.052731] ata4: SATA max UDMA/133 abar m2048@0xfe625000 port
0xfe625280 irq 44
[    2.052734] ata5: DUMMY
[    2.052735] ata6: DUMMY
[    2.357095] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.357125] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.358782] ata4.00: ATAPI: ATAPI   iHAS124   Y, BL0V, max UDMA/100
[    2.360261] ata3.00: ATA-8: WDC WD20EARS-00MVWB0, 51.0AB51, max UDMA/133
[    2.360266] ata3.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth
31/32), AA
[    2.360706] ata4.00: configured for UDMA/100
[    2.363496] ata3.00: configured for UDMA/133
[    7.405154] ata1: link is slow to respond, please be patient (ready=0)
[   12.094412] ata1: COMRESET failed (errno=-16)
[   12.401242] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[   12.514036] ata1.00: ATA-9: OCZ-VERTEX3, 2.02, max UDMA/133
[   12.514041] ata1.00: 468862128 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[   12.665431] ata1.00: configured for UDMA/133
[   12.665585] scsi 0:0:0:0: Direct-Access     ATA      OCZ-VERTEX3
  2.02 PQ: 0 ANSI: 5
[   12.666026] scsi 2:0:0:0: Direct-Access     ATA      WDC
WD20EARS-00M 51.0 PQ: 0 ANSI: 5
[   12.667587] scsi 3:0:0:0: CD-ROM            ATAPI    iHAS124   Y
  BL0V PQ: 0 ANSI: 5

The laptop looks pretty much the same, as does 2.6.39-rc6.
