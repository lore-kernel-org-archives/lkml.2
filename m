Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab2ACTpI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 14:45:08 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:35944 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438Ab2ACTpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 14:45:05 -0500
From: Haogang Chen <haogangchen@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Ian Campbell <Ian.Campbell@citrix.com>
Cc: xen-devel@lists.xensource.com, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Haogang Chen <haogangchen@gmail.com>
Subject: [PATCH] XEN: xenbus: integer overflow in process_msg()
Date: Tue,  3 Jan 2012 14:42:11 -0500
Message-Id: <1325619731-13936-1-git-send-email-haogangchen@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a potential integer overflow in process_msg() that could result
in cross-domain attack.

	body = kmalloc(msg->hdr.len + 1, GFP_NOIO | __GFP_HIGH);

When a malicious guest passes 0xffffffff in msg->hdr.len, the subsequent
call to xb_read() would write to a zero-length buffer. This causes
kernel oops in the receiving guest and hangs its xenbus kernel thread.
The patch returns -EINVAL in that case.

Signed-off-by: Haogang Chen <haogangchen@gmail.com>
---
 drivers/xen/xenbus/xenbus_xs.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_xs.c b/drivers/xen/xenbus/xenbus_xs.c
index ede860f..e32aefb 100644
--- a/drivers/xen/xenbus/xenbus_xs.c
+++ b/drivers/xen/xenbus/xenbus_xs.c
@@ -801,6 +801,12 @@ static int process_msg(void)
 		goto out;
 	}
 
+	if (msg->hdr.len == UINT_MAX) {
+		kfree(msg);
+		err = -EINVAL;
+		goto out;
+	}
+
 	body = kmalloc(msg->hdr.len + 1, GFP_NOIO | __GFP_HIGH);
 	if (body == NULL) {
 		kfree(msg);
-- 
1.7.5.4

