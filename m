Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503Ab0KSVqi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:46:38 -0500
Received: from kroah.org ([198.145.64.141]:51915 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932350Ab0KSVpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:45:44 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:44:13 2010
Message-Id: <20101119214412.966281483@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:43:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Christof Schmitt <christof.schmitt@de.ibm.com>,
        James Bottomley <James.Bottomley@suse.de>
Subject: [43/45] [SCSI] Fix race when removing SCSI devices
In-Reply-To: <20101119214439.GA26350@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Christof Schmitt <christof.schmitt@de.ibm.com>

commit 546ae796bfac6399e30da4b5af2cf7a6d0f8a4ec upstream.

Removing SCSI devices through
echo 1 > /sys/bus/scsi/devices/ ... /delete

while the FC transport class removes the SCSI target can lead to an
oops:

Unable to handle kernel pointer dereference at virtual kernel address 00000000b6815000
Oops: 0011 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Modules linked in: sunrpc qeth_l3 binfmt_misc dm_multipath scsi_dh dm_mod ipv6 qeth ccwgroup [last unloaded: scsi_wait_scan]
CPU: 1 Not tainted 2.6.35.5-45.x.20100924-s390xdefault #1
Process fc_wq_0 (pid: 861, task: 00000000b7331240, ksp: 00000000b735bac0)
Krnl PSW : 0704200180000000 00000000003ff6e4 (__scsi_remove_device+0x24/0xd0)
           R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:2 PM:0 EA:3
Krnl GPRS: 0000000000000001 0000000000000000 00000000b6815000 00000000bc24a8c0
           00000000003ff7c8 000000000056dbb8 0000000000000002 0000000000835d80
           ffffffff00000000 0000000000001000 00000000b6815000 00000000bc24a7f0
           00000000b68151a0 00000000b6815000 00000000b735bc20 00000000b735bbf8
Krnl Code: 00000000003ff6d6: a7840001            brc 8,3ff6d8
           00000000003ff6da: a7fbffd8            aghi %r15,-40
           00000000003ff6de: e3e0f0980024        stg %r14,152(%r15)
          >00000000003ff6e4: e31021200004        lg %r1,288(%r2)
           00000000003ff6ea: a71f0000            cghi    %r1,0
           00000000003ff6ee: a7a40011            brc 10,3ff710
           00000000003ff6f2: a7390003            lghi    %r3,3
           00000000003ff6f6: c0e5ffffc8b1        brasl %r14,3f8858
Call Trace:
([<0000000000001000>] 0x1000)
 [<00000000003ff7d2>] scsi_remove_device+0x42/0x54
 [<00000000003ff8ba>] __scsi_remove_target+0xca/0xfc
 [<00000000003ff99a>] __remove_child+0x3a/0x48
 [<00000000003e3246>] device_for_each_child+0x72/0xbc
 [<00000000003ff93a>] scsi_remove_target+0x4e/0x74
 [<0000000000406586>] fc_rport_final_delete+0xb2/0x23c
 [<000000000015d080>] worker_thread+0x200/0x344
 [<000000000016330c>] kthread+0xa0/0xa8
 [<0000000000106c1a>] kernel_thread_starter+0x6/0xc
 [<0000000000106c14>] kernel_thread_starter+0x0/0xc
INFO: lockdep is turned off.
Last Breaking-Event-Address:
 [<00000000003ff7cc>] scsi_remove_device+0x3c/0x54

The function __scsi_remove_target iterates through the SCSI devices on
the host, but it drops the host_lock before calling
scsi_remove_device. When the SCSI device is deleted from another
thread, the pointer to the SCSI device in scsi_remove_device can
become invalid. Fix this by getting a reference to the SCSI device
before dropping the host_lock to keep the SCSI device alive for the
call to scsi_remove_device.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/scsi_sysfs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -954,10 +954,11 @@ static void __scsi_remove_target(struct
 	list_for_each_entry(sdev, &shost->__devices, siblings) {
 		if (sdev->channel != starget->channel ||
 		    sdev->id != starget->id ||
-		    sdev->sdev_state == SDEV_DEL)
+		    scsi_device_get(sdev))
 			continue;
 		spin_unlock_irqrestore(shost->host_lock, flags);
 		scsi_remove_device(sdev);
+		scsi_device_put(sdev);
 		spin_lock_irqsave(shost->host_lock, flags);
 		goto restart;
 	}


