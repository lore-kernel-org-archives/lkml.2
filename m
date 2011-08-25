Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab1HYQmd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 12:42:33 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:42723
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753337Ab1HYQ2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 12:28:55 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 04/59] Staging: hv: Add code to parse struct hv_vmbus_device_id table
Date: Thu, 25 Aug 2011 09:48:30 -0700
Message-Id: <1314290965-2698-4-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314290965-2698-1-git-send-email-kys@microsoft.com>
References: <1314290866-2644-1-git-send-email-kys@microsoft.com>
 <1314290965-2698-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add code to parse struct hv_vmbus_device_id table.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 scripts/mod/file2alias.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index e26e2fb..b74d21a 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -735,6 +735,27 @@ static int do_virtio_entry(const char *filename, struct virtio_device_id *id,
 	return 1;
 }
 
+/*
+ * Looks like: vmbus:guid
+ * Each byte of the guid will be represented by two hex characters
+ * in the name.
+ */
+
+static int do_vmbus_entry(const char *filename, struct hv_vmbus_device_id *id,
+			  char *alias)
+{
+	int i;
+	char guid_name[((sizeof(struct hv_vmbus_device_id) + 1)) * 2];
+
+	for (i = 0; i < (sizeof(struct hv_vmbus_device_id) * 2); i += 2)
+		sprintf(&guid_name[i], "%02x", id->guid[i/2]);
+
+	strcpy(alias, "vmbus:");
+	strcat(alias, guid_name);
+
+	return 1;
+}
+
 /* Looks like: i2c:S */
 static int do_i2c_entry(const char *filename, struct i2c_device_id *id,
 			char *alias)
@@ -994,6 +1015,10 @@ void handle_moddevtable(struct module *mod, struct elf_info *info,
 		do_table(symval, sym->st_size,
 			 sizeof(struct virtio_device_id), "virtio",
 			 do_virtio_entry, mod);
+	else if (sym_is(symname, "__mod_vmbus_device_table"))
+		do_table(symval, sym->st_size,
+			 sizeof(struct hv_vmbus_device_id), "vmbus",
+			 do_vmbus_entry, mod);
 	else if (sym_is(symname, "__mod_i2c_device_table"))
 		do_table(symval, sym->st_size,
 			 sizeof(struct i2c_device_id), "i2c",
-- 
1.7.4.1

