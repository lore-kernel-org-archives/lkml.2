Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635Ab2HTLEf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 07:04:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40851 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282Ab2HTLEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 07:04:32 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>
Subject: [PATCH 1/3] firmware loader: fix firmware -ENOENT situations
Date: Mon, 20 Aug 2012 19:04:15 +0800
Message-Id: <1345460657-24093-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the requested firmware image doesn't exist, firmware->priv
should be set for the later concurrent requests, otherwise
warning and oops will be triggered inside firmware_free_data().

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/base/firmware_class.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index ed0510a..edc88bc 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -718,6 +718,7 @@ _request_firmware_prepare(const struct firmware **firmware_p, const char *name,
 	mutex_lock(&fw_lock);
 	if (test_bit(FW_STATUS_ABORT, &buf->status)) {
 		fw_priv = ERR_PTR(-ENOENT);
+		firmware->priv = buf;
 		_request_firmware_cleanup(firmware_p);
 		goto exit;
 	} else if (test_bit(FW_STATUS_DONE, &buf->status)) {
-- 
1.7.9.5

