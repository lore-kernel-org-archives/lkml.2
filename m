Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120Ab2JERFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 13:05:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41884 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757033Ab2JERFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 13:05:48 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] firmware: Don't attempt to allocate zero bytes with vmalloc()
Date: Fri,  5 Oct 2012 18:05:31 +0100
Message-Id: <1349456731-19977-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vmalloc() will fail (very loudly) if we try to allocate zero bytes to
read a zero byte file. Instead report that we successfully read in all
zero bytes.

It's not immediately obvious to me that this is better than returning an
error but it seems better to punt the decision about that to the caller
on the off chance that it's sensible.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/firmware_class.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 8154145..a14eb92 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -62,6 +62,11 @@ static bool fw_read_file_contents(struct file *file, struct firmware *fw)
 	char *buf;
 
 	size = fw_file_size(file);
+	if (size == 0) {
+		fw->data = NULL;
+		fw->size = 0;
+		return true;
+	}
 	if (size < 0)
 		return false;
 	buf = vmalloc(size);
-- 
1.7.10.4

