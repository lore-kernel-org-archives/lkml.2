Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411Ab2IDPzv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 11:55:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52242 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757135Ab2IDPzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 11:55:47 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
        Josh Boyer <jwboyer@redhat.com>
Subject: [PATCH 08/11] Secure boot: Add a dummy kernel parameter that will switch on Secure Boot mode
Date: Tue,  4 Sep 2012 11:55:14 -0400
Message-Id: <1346774117-2277-9-git-send-email-mjg@redhat.com>
In-Reply-To: <1346774117-2277-1-git-send-email-mjg@redhat.com>
References: <1346774117-2277-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.206
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Boyer <jwboyer@redhat.com>

This forcibly drops CAP_SECURE_FIRMWARE from both cap_permitted and cap_bset
in the init_cred struct, which everything else inherits from.  This works on
any machine and can be used to develop even if the box doesn't have UEFI.

Signed-off-by: Josh Boyer <jwboyer@redhat.com>
---
 kernel/cred.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/kernel/cred.c b/kernel/cred.c
index de728ac..47669a9 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -623,6 +623,23 @@ void __init cred_init(void)
 				     0, SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
 }
 
+void __init secureboot_enable()
+{
+	pr_info("Secure boot enabled\n");
+	cap_lower((&init_cred)->cap_bset, CAP_SECURE_FIRMWARE);
+	cap_lower((&init_cred)->cap_permitted, CAP_SECURE_FIRMWARE);
+}
+
+/* Dummy Secure Boot enable option to fake out UEFI SB=1 */
+static int __init secureboot_enable_opt(char *str)
+{
+	int sb_enable = !!simple_strtol(str, NULL, 0);
+	if (sb_enable)
+		secureboot_enable();
+	return 1;
+}
+__setup("secureboot_enable=", secureboot_enable_opt);
+
 /**
  * prepare_kernel_cred - Prepare a set of credentials for a kernel service
  * @daemon: A userspace daemon to be used as a reference
-- 
1.7.11.4

