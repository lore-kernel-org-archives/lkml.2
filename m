Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab2HMUYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:24:54 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55329 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848Ab2HMUYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:24:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 67/82] target: Fix possible integer underflow in UNMAP emulation
Date: Mon, 13 Aug 2012 13:19:43 -0700
Message-Id: <20120813201752.331185916@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813201746.448504360@linuxfoundation.org>
References: <20120813201746.448504360@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/target/target_core_cdb.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/drivers/target/target_core_cdb.c
+++ b/drivers/target/target_core_cdb.c
@@ -1014,9 +1014,10 @@ int target_emulate_unmap(struct se_cmd *
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
@@ -1025,20 +1026,19 @@ int target_emulate_unmap(struct se_cmd *
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


