Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab1KNXMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 18:12:50 -0500
Received: from smtp.outflux.net ([198.145.64.163]:42700 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753802Ab1KNXMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 18:12:49 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Tony Luck <tony.luck@intel.com>, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 3/3] efivars: pass back allocated buffer for pstore
Date: Mon, 14 Nov 2011 15:12:38 -0800
Message-Id: <1321312358-11234-4-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1321312358-11234-1-git-send-email-keescook@chromium.org>
References: <1321312358-11234-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since pstore cannot hold the buf_lock while it populates the VFS, the backend
needs to provide an allocated buffer with the contents.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/firmware/efivars.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 8370f72..a54a6b9 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -457,7 +457,8 @@ static int efi_pstore_close(struct pstore_info *psi)
 }
 
 static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
-			       struct timespec *timespec, struct pstore_info *psi)
+			       struct timespec *timespec,
+			       char **buf, struct pstore_info *psi)
 {
 	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
 	struct efivars *efivars = psi->data;
@@ -478,7 +479,11 @@ static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
 				timespec->tv_nsec = 0;
 				get_var_data_locked(efivars, &efivars->walk_entry->var);
 				size = efivars->walk_entry->var.DataSize;
-				memcpy(psi->buf, efivars->walk_entry->var.Data, size);
+				*buf = kmalloc(size, GFP_KERNEL);
+				if (*buf == NULL)
+					return -ENOMEM;
+				memcpy(*buf, efivars->walk_entry->var.Data,
+				       size);
 				efivars->walk_entry = list_entry(efivars->walk_entry->list.next,
 					           struct efivar_entry, list);
 				return size;
-- 
1.7.0.4

