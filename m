Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620Ab1DSJZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 05:25:26 -0400
Received: from lider.pardus.org.tr ([193.140.100.216]:54965 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab1DSJZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 05:25:24 -0400
X-Spam-Score: -3.1
Message-ID: <4DAD5495.5060704@pardus.org.tr>
Date: Tue, 19 Apr 2011 12:23:33 +0300
From: =?ISO-8859-9?Q?Ozan_=C7a=F0layan?= <ozan@pardus.org.tr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110324 Pardus/2011 Thunderbird/3.1.9
MIME-Version: 1.0
To: stable@kernel.org, giridhar.malavali@qlogic.com, James.Bottomley@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org,
        andrew.vasquez@qlogic.com
Subject: [BISECTED] QLogic Corp. ISP2532-based 8Gb Fibre Channel not working
 on 2.6.35.y
Content-Type: text/plain; charset=ISO-8859-9; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

0e:00.0 Fibre Channel [0c04]: QLogic Corp. ISP2532-based 8Gb Fibre 
Channel to PCI Express HBA [1077:2532] (rev 02)

The card above doesn't work correctly on 2.6.35.12. I tried 2.6.37.y and 
it works correctly there.

First the dmesg from 2.6.35.12:

[324395.932519] QLogic Fibre Channel HBA Driver: 8.03.02-k2
[324395.932560] qla2xxx 0000:0e:00.0: PCI INT A -> GSI 30 (level, low) 
-> IRQ 30
[324395.933614] qla2xxx 0000:0e:00.0: Found an ISP2532, irq 30, iobase 
0xffffc90011a20000
[324395.934033] qla2xxx 0000:0e:00.0: irq 82 for MSI/MSI-X
[324395.934040] qla2xxx 0000:0e:00.0: irq 83 for MSI/MSI-X
[324395.934096] qla2xxx 0000:0e:00.0: Configuring PCI space...
[324395.934102] qla2xxx 0000:0e:00.0: setting latency timer to 64
[324395.947205] qla2xxx 0000:0e:00.0: Configure NVRAM parameters...
[324395.954999] qla2xxx 0000:0e:00.0: Verifying loaded RISC code...
[324396.068188] qla2xxx 0000:0e:00.0: FW: Loading via request-firmware...
[324396.096381] qla2xxx 0000:0e:00.0: Allocated (64 KB) for FCE...
[324396.096455] qla2xxx 0000:0e:00.0: Allocated (64 KB) for EFT...
[324396.096678] qla2xxx 0000:0e:00.0: Allocated (1350 KB) for firmware 
dump...
[324396.100645] qla2xxx 0000:0e:00.0: Unable to read FCP priority data.
[324396.100885] scsi4 : qla2xxx
[324396.102131] qla2xxx 0000:0e:00.0:
[324396.102132]  QLogic Fibre Channel HBA Driver: 8.03.02-k2
[324396.102134]   QLogic HPAK344A - HP 8Gb Single Channel PCI-e 2.0 FC HBA
[324396.102135]   ISP2532: PCIe (5.0GT/s x4) @ 0000:0e:00.0 hdma+, 
host#=4, fw=4.04.04 (80)
[324396.386384] qla2xxx 0000:0e:00.0: LIP reset occurred (f700).
[324396.422841] qla2xxx 0000:0e:00.0: LIP occurred (f700).
[324396.427019] qla2xxx 0000:0e:00.0: LIP reset occurred (f7f7).
[324396.477268] qla2xxx 0000:0e:00.0: LOOP UP detected (8 Gbps).
[324396.930363] qla2xxx 0000:0e:00.0: MRK-IOCB: Invalid completion 
handle (0) -- timed-out.

The logs stop here and no volumes are detected over the fibre channel.

--

Then I've generated all the patches between 2.6.35.12 and current 
linux-2.6 tree and patched them incrementally. After the following 
commit, the issue is fixed and all the volumes are correctly shown in 
/dev tree:

 From b0cd579cde8ee0c7ed52239531ba09bcbc5b54c2 Mon Sep 17 00:00:00 2001
From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Date: Fri, 28 May 2010 15:08:22 -0700
Subject: [PATCH 009/107] [SCSI] qla2xxx: Make the FC port capability 
mutual exclusive.

In case of both target and initiator capabilities reported by fc port,
the fc port port capability is made mutualy exclusive with priority given
for target capabilities.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>

Here's the dmesg with that patch applied:

[329158.803944] QLogic Fibre Channel HBA Driver: 8.03.03-k0
[329158.803990] qla2xxx 0000:0e:00.0: PCI INT A -> GSI 30 (level, low) 
-> IRQ 30
[329158.805025] qla2xxx 0000:0e:00.0: Found an ISP2532, irq 30, iobase 
0xffffc9001183a000
[329158.805445] qla2xxx 0000:0e:00.0: irq 82 for MSI/MSI-X
[329158.805452] qla2xxx 0000:0e:00.0: irq 83 for MSI/MSI-X
[329158.805509] qla2xxx 0000:0e:00.0: Configuring PCI space...
[329158.805515] qla2xxx 0000:0e:00.0: setting latency timer to 64
[329158.818720] qla2xxx 0000:0e:00.0: Configure NVRAM parameters...
[329158.826530] qla2xxx 0000:0e:00.0: Verifying loaded RISC code...
[329158.828862] qla2xxx 0000:0e:00.0: FW: Loading via request-firmware...
[329158.857110] qla2xxx 0000:0e:00.0: Allocated (64 KB) for FCE...
[329158.857185] qla2xxx 0000:0e:00.0: Allocated (64 KB) for EFT...
[329158.857324] qla2xxx 0000:0e:00.0: Allocated (1350 KB) for firmware 
dump...
[329158.861287] qla2xxx 0000:0e:00.0: Unable to read FCP priority data.
[329158.861538] scsi26 : qla2xxx
[329158.863028] qla2xxx 0000:0e:00.0:
[329158.863030]  QLogic Fibre Channel HBA Driver: 8.03.03-k0
[329158.863031]   QLogic HPAK344A - HP 8Gb Single Channel PCI-e 2.0 FC HBA
[329158.863033]   ISP2532: PCIe (5.0GT/s x4) @ 0000:0e:00.0 hdma+, 
host#=26, fw=4.04.04 (80)
[329159.146987] qla2xxx 0000:0e:00.0: LIP reset occurred (f700).
[329159.217822] qla2xxx 0000:0e:00.0: LOOP UP detected (8 Gbps).
[329159.872520] scsi 26:0:0:0: Direct-Access     HP       P2000 G3 
FC      T201 PQ: 0 ANSI: 5
[329159.872947] sd 26:0:0:0: Attached scsi generic sg3 type 0
[329159.874203] sd 26:0:0:0: [sdb] 2341837312 512-byte logical blocks: 
(1.19 TB/1.08 TiB)
[329159.874344] scsi 26:0:0:1: Direct-Access     HP       P2000 G3 
FC      T201 PQ: 0 ANSI: 5
[329159.874493] sd 26:0:0:0: [sdb] Write Protect is off
[329159.874498] sd 26:0:0:0: [sdb] Mode Sense: 93 00 00 08
[329159.874810] sd 26:0:0:1: Attached scsi generic sg4 type 0
[329159.874862] sd 26:0:0:1: [sdc] 3512755968 512-byte logical blocks: 
(1.79 TB/1.63 TiB)
[329159.874911] sd 26:0:0:0: [sdb] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[329159.875551] sd 26:0:0:1: [sdc] Write Protect is off
[329159.875555] sd 26:0:0:1: [sdc] Mode Sense: 93 00 00 08
[329159.875676] scsi 26:0:1:0: Direct-Access     HP       P2000 G3 
FC      T201 PQ: 0 ANSI: 5
[329159.875773] sd 26:0:0:1: [sdc] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[329159.876161] sd 26:0:1:0: Attached scsi generic sg5 type 0
[329159.877438] sd 26:0:1:0: [sdd] 2341837312 512-byte logical blocks: 
(1.19 TB/1.08 TiB)
[329159.877904] scsi 26:0:1:1: Direct-Access     HP       P2000 G3 
FC      T201 PQ: 0 ANSI: 5
[329159.878004]  sdc:
[329159.878055] sd 26:0:1:0: [sdd] Write Protect is off
[329159.878060] sd 26:0:1:0: [sdd] Mode Sense: 93 00 00 08
[329159.878194] sd 26:0:1:0: [sdd] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[329159.878317] sd 26:0:1:1: Attached scsi generic sg6 type 0
[329159.878515] sd 26:0:1:1: [sde] 3512755968 512-byte logical blocks: 
(1.79 TB/1.63 TiB)
[329159.878830]  sdb: sdb1
[329159.881746] scsi 26:0:2:0: Enclosure         HP       P2000 G3 
FC      T201 PQ: 0 ANSI: 5
[329159.882031] scsi 26:0:2:0: Attached scsi generic sg7 type 13
[329159.883752] scsi 26:0:3:0: Enclosure         HP       P2000 G3 
FC      T201 PQ: 0 ANSI: 5
[329159.884035] scsi 26:0:3:0: Attached scsi generic sg8 type 13
[329159.884522] sd 26:0:1:1: [sde] Write Protect is off
[329159.884527] sd 26:0:1:1: [sde] Mode Sense: 93 00 00 08
[329159.884724]  sdd:
[329159.884980] sd 26:0:1:1: [sde] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[329159.884997]  sdd1
[329159.889013] sd 26:0:0:0: [sdb] Attached SCSI disk
[329159.890006]  sde:
[329159.893286] ses 26:0:2:0: Attached Enclosure device
[329159.893292] ses 26:0:3:0: Attached Enclosure device
[329159.893485] sd 26:0:1:0: [sdd] Attached SCSI disk
[329159.893668]  unknown partition table
[329159.895408] sd 26:0:0:1: [sdc] Attached SCSI disk
[329159.909052]  unknown partition table
[329159.910954] sd 26:0:1:1: [sde] Attached SCSI disk

And with the following patch applied on top of 
b0cd579cde8ee0c7ed52239531ba09bcbc5b54c2, "Unable to read FCP priority 
data." message disappears too but it may be a cosmetic fix I don't know:

 From 2f0f3f4f06f7cfadebf58b70bd9e7f71d8fd96e4 Mon Sep 17 00:00:00 2001
From: Madhuranath Iyengar <madhuranath.iyengar@qlogic.com>
Date: Fri, 23 Jul 2010 15:28:24 +0500
Subject: [PATCH 021/107] [SCSI] qla2xxx: Appropriately log FCP priority 
data messages

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>


-------

So I think at least the first commit that I've mentioned should be 
queued for the next 2.6.35.y to fix this issue.

Thanks,
Regards

Ozan Caglayan



