Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab2GaEu6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 00:50:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48780 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755634Ab2GaEuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 00:50:54 -0400
Message-Id: <20120731044318.518249620@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 31 Jul 2012 05:43:55 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 45/73] target: Fix possible integer underflow in UNMAP emulation
In-Reply-To: <20120731044310.013763753@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Dreier <roland@purestorage.com>

commit b7fc7f3777582dea85156a821d78a522a0c083aa upstream.

It's possible for an initiator to send us an UNMAP command with a
descriptor that is less than 8 bytes; in that case it's really bad for
us to set an unsigned int to that value, subtract 8 from it, and then
use that as a limit for our loop (since the value will wrap around to
a huge positive value).

Fix this by making size be signed and only looping if size >= 16 (ie
if we have at least a full descriptor available).

Also remove offset as an obfuscated name for the constant 8.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
[bwh: Backported to 3.2: adjust filename, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/target/target_core_cdb.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/drivers/target/target_core_cdb.c
+++ b/drivers/target/target_core_cdb.c
@@ -1115,9 +1115,10 @@ int target_emulate_unmap(struct se_task
 	struct se_device *dev = cmd->se_dev;
 	unsigned char *buf, *ptr = NULL;
 	sector_t lba;
-	unsigned int size = cmd->data_length, range;
-	int ret = 0, offset;
-	unsigned short dl, bd_dl;
+	int size = cmd->data_length;
+	u32 range;
+	int ret = 0;
+	int dl, bd_dl;
 
 	if (!dev->transport->do_discard) {
 		pr_err("UNMAP emulation not supported for: %s\n",
@@ -1126,20 +1127,19 @@ int target_emulate_unmap(struct se_task
 		return -ENOSYS;
 	}
 
-	/* First UNMAP block descriptor starts at 8 byte offset */
-	offset = 8;
-	size -= 8;
-
 	buf = transport_kmap_data_sg(cmd);
 
 	dl = get_unaligned_be16(&buf[0]);
 	bd_dl = get_unaligned_be16(&buf[2]);
 
-	ptr = &buf[offset];
-	pr_debug("UNMAP: Sub: %s Using dl: %hu bd_dl: %hu size: %hu"
+	size = min(size - 8, bd_dl);
+
+	/* First UNMAP block descriptor starts at 8 byte offset */
+	ptr = &buf[8];
+	pr_debug("UNMAP: Sub: %s Using dl: %u bd_dl: %u size: %u"
 		" ptr: %p\n", dev->transport->name, dl, bd_dl, size, ptr);
 
-	while (size) {
+	while (size >= 16) {
 		lba = get_unaligned_be64(&ptr[0]);
 		range = get_unaligned_be32(&ptr[8]);
 		pr_debug("UNMAP: Using lba: %llu and range: %u\n",


