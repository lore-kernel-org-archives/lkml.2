Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab2HMUZA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:25:00 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51310 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869Ab2HMUYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:24:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 68/82] target: Check number of unmap descriptors against our limit
Date: Mon, 13 Aug 2012 13:19:44 -0700
Message-Id: <20120813201752.414745883@linuxfoundation.org>
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

commit 7409a6657aebf8be74c21d0eded80709b27275cb upstream.

Fail UNMAP commands that have more than our reported limit on unmap
descriptors.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/target/target_core_cdb.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/target/target_core_cdb.c
+++ b/drivers/target/target_core_cdb.c
@@ -1032,6 +1032,11 @@ int target_emulate_unmap(struct se_cmd *
 	bd_dl = get_unaligned_be16(&buf[2]);
 
 	size = min(size - 8, bd_dl);
+	if (size / 16 > dev->se_sub_dev->se_dev_attrib.max_unmap_block_desc_count) {
+		cmd->scsi_sense_reason = TCM_INVALID_PARAMETER_LIST;
+		ret = -EINVAL;
+		goto err;
+	}
 
 	/* First UNMAP block descriptor starts at 8 byte offset */
 	ptr = &buf[8];


