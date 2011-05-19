Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934235Ab1ESSOv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:14:51 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:60188 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934016Ab1ESSJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:09:05 -0400
X-Sasl-enc: zdFCXYOAiLjYQBk+QuCJmuG3vrPNyOv4tr20HkY74xKF 1305828544
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:05:59 2011
Message-Id: <20110519180559.099351581@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:05:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, Connor H <cmdkhh@gmail.com>,
        Jeff Garzik <jgarzik@pobox.com>
Subject: [50/71] libata: fix oops when LPM is used with PMP
In-Reply-To: <20110519180626.GA16555@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 5f6f12ccf3aa42cfc0c5bde9228df0c843dd63f7 upstream.

ae01b2493c (libata: Implement ATA_FLAG_NO_DIPM and apply it to mcp65)
added ATA_FLAG_NO_DIPM and made ata_eh_set_lpm() check the flag.
However, @ap is NULL if @link points to a PMP link and thus the
unconditional @ap->flags dereference leads to the following oops.

  BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
  IP: [<ffffffff813f98e1>] ata_eh_recover+0x9a1/0x1510
  ...
  Pid: 295, comm: scsi_eh_4 Tainted: P            2.6.38.5-core2 #1 System76, Inc. Serval Professional/Serval Professional
  RIP: 0010:[<ffffffff813f98e1>]  [<ffffffff813f98e1>] ata_eh_recover+0x9a1/0x1510
  RSP: 0018:ffff880132defbf0  EFLAGS: 00010246
  RAX: 0000000000000000 RBX: ffff880132f40000 RCX: 0000000000000000
  RDX: ffff88013377c000 RSI: ffff880132f40000 RDI: 0000000000000000
  RBP: ffff880132defce0 R08: ffff88013377dc58 R09: ffff880132defd98
  R10: 0000000000000000 R11: 00000000ffffffff R12: 0000000000000000
  R13: 0000000000000000 R14: ffff88013377c000 R15: 0000000000000000
  FS:  0000000000000000(0000) GS:ffff8800bf700000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
  CR2: 0000000000000018 CR3: 0000000001a03000 CR4: 00000000000406e0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
  Process scsi_eh_4 (pid: 295, threadinfo ffff880132dee000, task ffff880133b416c0)
  Stack:
   0000000000000000 ffff880132defcc0 0000000000000000 ffff880132f42738
   ffffffff813ee8f0 ffffffff813eefe0 ffff880132defd98 ffff88013377f190
   ffffffffa00b3e30 ffffffff813ef030 0000000032defc60 ffff880100000000
  Call Trace:
   [<ffffffff81400867>] sata_pmp_error_handler+0x607/0xc30
   [<ffffffffa00b273f>] ahci_error_handler+0x1f/0x70 [libahci]
   [<ffffffff813faade>] ata_scsi_error+0x5be/0x900
   [<ffffffff813cf724>] scsi_error_handler+0x124/0x650
   [<ffffffff810834b6>] kthread+0x96/0xa0
   [<ffffffff8100cd64>] kernel_thread_helper+0x4/0x10
  Code: 8b 95 70 ff ff ff b8 00 00 00 00 48 3b 9a 10 2e 00 00 48 0f 44 c2 48 89 85 70 ff ff ff 48 8b 8d 70 ff ff ff f6 83 69 02 00 00 01 <48> 8b 41 18 0f 85 48 01 00 00 48 85 c9 74 12 48 8b 51 08 48 83
  RIP  [<ffffffff813f98e1>] ata_eh_recover+0x9a1/0x1510
   RSP <ffff880132defbf0>
  CR2: 0000000000000018

Fix it by testing @link->ap->flags instead.

stable: ATA_FLAG_NO_DIPM was added during 2.6.39 cycle but was
        backported to 2.6.37 and 38.  This is a fix for that and thus
        also applicable to 2.6.37 and 38.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: "Nathan A. Mourey II" <nmoureyii@ne.rr.com>
LKML-Reference: <1304555277.2059.2.camel@localhost.localdomain>
Cc: Connor H <cmdkhh@gmail.com>
Signed-off-by: Jeff Garzik <jgarzik@pobox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/libata-eh.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -3276,7 +3276,7 @@ static int ata_eh_set_lpm(struct ata_lin
 	struct ata_eh_context *ehc = &link->eh_context;
 	struct ata_device *dev, *link_dev = NULL, *lpm_dev = NULL;
 	enum ata_lpm_policy old_policy = link->lpm_policy;
-	bool no_dipm = ap->flags & ATA_FLAG_NO_DIPM;
+	bool no_dipm = link->ap->flags & ATA_FLAG_NO_DIPM;
 	unsigned int hints = ATA_LPM_EMPTY | ATA_LPM_HIPM;
 	unsigned int err_mask;
 	int rc;


