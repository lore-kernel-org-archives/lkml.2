Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162197Ab2GLWoW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:44:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48386 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162175Ab2GLWoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:44:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mark Rustad <mark.d.rustad@intel.com>,
        Marcus Dennis <marcusx.e.dennis@intel.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 146/187] SCSI: Fix NULL dereferences in scsi_cmd_to_driver
Date: Thu, 12 Jul 2012 15:35:02 -0700
Message-Id: <20120712191535.939016335@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rustad <mark.d.rustad@intel.com>

commit 222a806af830fda34ad1f6bc991cd226916de060 upstream.

Avoid crashing if the private_data pointer happens to be NULL. This has
been seen sometimes when a host reset happens, notably when there are
many LUNs:

host3: Assigned Port ID 0c1601
scsi host3: libfc: Host reset succeeded on port (0c1601)
BUG: unable to handle kernel NULL pointer dereference at 0000000000000350
IP: [<ffffffff81352bb8>] scsi_send_eh_cmnd+0x58/0x3a0
<snip>
Process scsi_eh_3 (pid: 4144, threadinfo ffff88030920c000, task ffff880326b160c0)
Stack:
 000000010372e6ba 0000000000000282 000027100920dca0 ffffffffa0038ee0
 0000000000000000 0000000000030003 ffff88030920dc80 ffff88030920dc80
 00000002000e0000 0000000a00004000 ffff8803242f7760 ffff88031326ed80
Call Trace:
 [<ffffffff8105b590>] ? lock_timer_base+0x70/0x70
 [<ffffffff81352fbe>] scsi_eh_tur+0x3e/0xc0
 [<ffffffff81353a36>] scsi_eh_test_devices+0x76/0x170
 [<ffffffff81354125>] scsi_eh_host_reset+0x85/0x160
 [<ffffffff81354291>] scsi_eh_ready_devs+0x91/0x110
 [<ffffffff813543fd>] scsi_unjam_host+0xed/0x1f0
 [<ffffffff813546a8>] scsi_error_handler+0x1a8/0x200
 [<ffffffff81354500>] ? scsi_unjam_host+0x1f0/0x1f0
 [<ffffffff8106ec3e>] kthread+0x9e/0xb0
 [<ffffffff81509264>] kernel_thread_helper+0x4/0x10
 [<ffffffff8106eba0>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff81509260>] ? gs_change+0x13/0x13
Code: 25 28 00 00 00 48 89 45 c8 31 c0 48 8b 87 80 00 00 00 48 8d b5 60 ff ff ff 89 d1 48 89 fb 41 89 d6 4c 89 fa 48 8b 80 b8 00 00 00
 <48> 8b 80 50 03 00 00 48 8b 00 48 89 85 38 ff ff ff 48 8b 07 4c
RIP  [<ffffffff81352bb8>] scsi_send_eh_cmnd+0x58/0x3a0
 RSP <ffff88030920dc50>
CR2: 0000000000000350


Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Tested-by: Marcus Dennis <marcusx.e.dennis@intel.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/scsi/scsi_cmnd.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -134,10 +134,16 @@ struct scsi_cmnd {
 
 static inline struct scsi_driver *scsi_cmd_to_driver(struct scsi_cmnd *cmd)
 {
+	struct scsi_driver **sdp;
+
 	if (!cmd->request->rq_disk)
 		return NULL;
 
-	return *(struct scsi_driver **)cmd->request->rq_disk->private_data;
+	sdp = (struct scsi_driver **)cmd->request->rq_disk->private_data;
+	if (!sdp)
+		return NULL;
+
+	return *sdp;
 }
 
 extern struct scsi_cmnd *scsi_get_command(struct scsi_device *, gfp_t);


