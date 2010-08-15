Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750889Ab0HOEhU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 00:37:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:61502 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696Ab0HOEhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 00:37:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,370,1278313200"; 
   d="scan'208";a="828273555"
From: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>
To: Grant Grundler <grundler@google.com>, Jeff Garzik <jgarzik@pobox.com>,
        Tejun Heo <tj@kernel.org>
CC: Linux IDE <linux-ide@vger.kernel.org>,
        Gwendal Grignou <gwendal@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sat, 14 Aug 2010 22:37:14 -0600
Subject: RE: [PATCH] 2.6.35 libata support for > 512 byte sectors (e.g. 4K
 Native)
Thread-Topic: [PATCH] 2.6.35 libata support for > 512 byte sectors (e.g. 4K
 Native)
Thread-Index: Acs8DPWghg3cWqsCRqm/1HC409fSpgAJBb/A
Message-ID: <CAC4B8726E86A142B27A9E9A2F2F12470149041A4E@rrsmsx505.amr.corp.intel.com>
References: <AANLkTikSSmP5f1csa=xPTR=EqY4D5a=6t2oDVkZ7cA-v@mail.gmail.com>
In-Reply-To: <AANLkTikSSmP5f1csa=xPTR=EqY4D5a=6t2oDVkZ7cA-v@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o7F4bjnM026671

If you will insist on sending to my Outlook address, you'll get replies in standard broken Outlook format.  You've been warned.

---

+/* BUG: Big endian systems need accesses to "id" wrapped with le16_to_cpu().
+ */

No, it's already been converted.  See ata_dev_read_id().

---

I'm not sure about your use of a switch to set the sector size.  Have you checked the code that GCC generates for this?

---

All the places you dereference dev->sdev are within a callchain from ->queuecommand; sdev can't possibly go away.
It'd be clearer that this is the case if you used scmd->device->sector_size instead of dev->sdev->sector_size.

---

@@ -516,7 +515,7 @@ int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
 	memset(scsi_cmd, 0, sizeof(scsi_cmd));
 
 	if (args[3]) {
-		argsize = SECTOR_SIZE * args[3];
+		argsize = ATA_SECT_SIZE * args[3];
 		argbuf = kmalloc(argsize, GFP_KERNEL);
 		if (argbuf == NULL) {
 			rc = -ENOMEM;

I think this is wrong.  The ioctl does PIO Data-in; as such, it should use the native sector size, not 512.
That said, there's a possibility of data corruption for programs which use this ioctl, assuming a 512-byte sector size when it's natively 4k.
This one's tricky and needs serious thought.  I might error it if sector_size isn't 512 bytes :-)
It's a legacy ioctl anyway, right?

---

I also remember Alan pointing out that some ATA controllers don't support non-512-byte commands, and we should have a 'safe for large sectors' flag set by the controller.

-----Original Message-----
From: Grant Grundler [mailto:grundler@google.com] 
Sent: Saturday, August 14, 2010 5:01 PM
To: Jeff Garzik; Tejun Heo
Cc: Linux IDE; Wilcox, Matthew R; Gwendal Grignou; LKML
Subject: [PATCH] 2.6.35 libata support for > 512 byte sectors (e.g. 4K Native)

Attached patch enables my x86 machine to recognize and talk to a "Native 4K" SATA device.

When I started working on this, I didn't know Matthew Wilcox had posted a similar patch 2 years ago:
   http://git.kernel.org/?p=linux/kernel/git/willy/ata.git;a=shortlog;h=refs/heads/ata-large-sectors

Gwendal Grignou pointed me at the the above code and small portions of this patch include Matthew's work. That's why Mathew is first on the "Signed-off-by:". I've NOT included his use of a bitmap to determine
512 vs Native for ATA command block size - just used a simple table.
And bugs are almost certainly mine.

Lastly, the patch has been tested with a native 4K 'Engineering Sample' drive provided by Hitachi GST.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
Signed-off-by: Grant Grundler <grundler@google.com>
Reviewed-by: Gwendal Grignou <gwendal@google.com>

-----

Gwendal's review of this patch had him concerned about access to "dev->sdev->sector_size" may have risks (e.g. sdev goes away before dev does).  I didn't like adding additional fields to ata_dev that duplicate what scsi is doing and this seems to be working so far. But since I don't know how dev->sdev is protected/syncronized (despite how libata and scsi are joined at the hip), I hope someone else can comment on if my usage of dev->sdev->sector_size is a problem and why.

I believe use of ata_id_logical_per_physical_sectors() was wrong. I've replaced it with ata_id_log2_per_physical_sector() and cleaned up how block size word and alignment are referenced. It's alot easier to read where those functions are used now.


Here is the kernel output from hotplugging the SATA drive on my machine (using Marvell 7042 controller):

[ 2468.301218] ata4: exception Emask 0x10 SAct 0x0 SErr 0x4010000 action 0xe frozen [ 2468.301225] ata4: edma_err_cause=00000010 pp_flags=00000000, dev connect [ 2468.301240] ata4: SError: { PHYRdyChg DevExch } [ 2468.301257] ata4: hard resetting link [ 2471.701117] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300) [ 2471.740390] ata4.00: HPA detected: current 9770670, native 78165360 [ 2471.740399] ata4.00: ATA-7: Hitachi HTSxxxxxxxxxxxx, yyyyyyyy, max UDMA/100 [ 2471.740402] ata4.00: 9770670 sectors, multi 0: LBA48 NCQ (depth 31/32) [ 2471.764465] ata4.00: configured for UDMA/100 [ 2471.764501] ata4: EH complete
[ 2471.764988] scsi 4:0:0:0: Direct-Access     ATA      Hitachi
HTSxxxxxxxxxxxx PQ: 0 ANSI: 5
[ 2471.782914] sd 4:0:0:0: [sdd] 9770670 4096-byte logical blocks:
(40.0 GB/37.2 GiB)
[ 2471.787093] sd 4:0:0:0: [sdd] Write Protect is off [ 2471.787120] sd 4:0:0:0: [sdd] Mode Sense: 00 3a 00 00 [ 2471.788768] sd 4:0:0:0: [sdd] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[ 2471.792293] sd 4:0:0:0: [sdd] 9770670 4096-byte logical blocks:
(40.0 GB/37.2 GiB)
[ 2471.792834] sd 4:0:0:0: Attached scsi generic sg3 type 0 [ 2471.799370]  sdd: unknown partition table [ 2471.845582] sd 4:0:0:0: [sdd] 9770670 4096-byte logical blocks:
(40.0 GB/37.2 GiB)
[ 2471.853763] sd 4:0:0:0: [sdd] Attached SCSI disk

I was able to dd to/from the device and pull SMART data (not shown and probably not able to share.)

If someone has "Advanced Format Developers Kit" SATA drives from idema.org, I'd appreciate any test reports.

thanks
grant

[ patch NOT inlined because gmail will word-wrap and make a mess of it. Please use attached filed.]
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
