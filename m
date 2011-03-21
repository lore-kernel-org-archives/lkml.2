Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932395Ab1CUXZA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:25:00 -0400
Received: from kroah.org ([198.145.64.141]:52731 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932156Ab1CUXSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:18:20 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:03:27 2011
Message-Id: <20110321230327.494574359@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:02:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Signed-off-by: Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        James Bottomley <James.Bottomley@suse.de>
Subject: [56/78] [SCSI] target: Fix volume size misreporting for volumes > 2TB
In-Reply-To: <20110321230346.GA14681@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit 904f0bc482201fa86e75c330d79dfd11be494cf8 upstream.

the target infrastructure fails to send the correct conventional size
to READ_CAPACITY that force a retry with READ_CAPACITY_16, which reads
the capacity for devices > 2TB.  Fix by adding the correct return to
trigger RC(16).

Reported-by: Ben Jarvis <bjarvismn@gmail.com>
Signed-off-by: Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/target/target_core_cdb.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/target/target_core_cdb.c
+++ b/drivers/target/target_core_cdb.c
@@ -667,7 +667,13 @@ target_emulate_readcapacity(struct se_cm
 {
 	struct se_device *dev = SE_DEV(cmd);
 	unsigned char *buf = cmd->t_task->t_task_buf;
-	u32 blocks = dev->transport->get_blocks(dev);
+	unsigned long long blocks_long = dev->transport->get_blocks(dev);
+	u32 blocks;
+
+	if (blocks_long >= 0x00000000ffffffff)
+		blocks = 0xffffffff;
+	else
+		blocks = (u32)blocks_long;
 
 	buf[0] = (blocks >> 24) & 0xff;
 	buf[1] = (blocks >> 16) & 0xff;


