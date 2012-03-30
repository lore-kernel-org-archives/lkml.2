Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966081Ab2C3VpF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:45:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37370 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966044Ab2C3VVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:21:22 -0400
Message-Id: <20120330194843.145070187@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:49:56 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Joern Engel <joern@logfs.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 091/175] target: prevent NULL pointer dereference in target_report_luns
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?J=C3=B6rn=20Engel?= <joern@logfs.org>

commit 47f1b8803e1e358ebbf4f82bfdb98971c912a2c3 upstream.

transport_kmap_data_sg can return NULL.  I never saw this trigger, but
returning -ENOMEM seems better than a crash.  Also removes a pointless
case while at it.

Signed-off-by: Joern Engel <joern@logfs.org>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_device.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -657,7 +657,9 @@ int target_report_luns(struct se_task *s
 	unsigned char *buf;
 	u32 cdb_offset = 0, lun_count = 0, offset = 8, i;
 
-	buf = (unsigned char *) transport_kmap_data_sg(se_cmd);
+	buf = transport_kmap_data_sg(se_cmd);
+	if (!buf)
+		return -ENOMEM;
 
 	/*
 	 * If no struct se_session pointer is present, this struct se_cmd is


