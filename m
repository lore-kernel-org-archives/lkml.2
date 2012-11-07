Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab2KGHov (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 02:44:51 -0500
Received: from mga14.intel.com ([143.182.124.37]:20014 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281Ab2KGHou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 02:44:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,727,1344236400"; 
   d="scan'208";a="214462769"
Subject: [PATCH] firmware loader: Fix the race FW_STATUS_DONE is followed
 by class_timeout
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: ming.lei@canonical.com, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, chuansheng.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Nov 2012 00:45:44 +0800
Message-ID: <1352306744.15558.1608.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There is a race condition as below when calling request_firmware():

CPU1					CPU2
write 0 > loading
mutex_lock(&fw_lock);
...
set_bit FW_STATUS_DONE                  class_timeout is coming
					set_bit FW_STATUS_ABORT
complete_all &completion
...
mutex_unlock(&fw_lock)

In this time, the bit FW_STATUS_DONE and FW_STATUS_ABORT are set,
and request_firmware() will return failure due to condition in
_request_firmware_load():

	if (!buf->size || test_bit(FW_STATUS_ABORT, &buf->status))
		retval = -ENOENT;

But from the above scenerio, it should be a succcessful requesting.
So we need judge if the FW_STATUS_DONE is set before calling abort
in timeout function firmware_class_timeout().

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 drivers/base/firmware_class.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 8945f4e..35fffd8 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -671,6 +671,13 @@ static void firmware_class_timeout(u_long data)
 {
 	struct firmware_priv *fw_priv = (struct firmware_priv *) data;
 
+	mutex_lock(&fw_lock);
+	if (test_bit(FW_STATUS_DONE, &(fw_priv->buf->status))) {
+		mutex_unlock(&fw_lock);
+		return;
+	}
+	mutex_unlock(&fw_lock);
+
 	fw_load_abort(fw_priv);
 }
 
-- 
1.7.0.4



