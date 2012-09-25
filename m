Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab2IYNIY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 09:08:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20277 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753810Ab2IYNIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 09:08:23 -0400
Date: Tue, 25 Sep 2012 09:08:18 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH V3 07/10] Secure boot: Add a dummy kernel parameter that will
 switch on Secure Boot mode
Message-ID: <20120925130818.GE18546@hansolo.jdub.homelinux.org>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
 <1348152065-31353-8-git-send-email-mjg@redhat.com>
 <20120920163237.GA11077@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120920163237.GA11077@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This forcibly drops CAP_COMPROMISE_KERNEL from both cap_permitted and cap_bset
in the init_cred struct, which everything else inherits from.  This works on
any machine and can be used to develop even if the box doesn't have UEFI.

Signed-off-by: Josh Boyer <jwboyer@redhat.com>
---
 Documentation/kernel-parameters.txt |  7 +++++++
 kernel/cred.c                       | 17 +++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 9b2b8d3..93978d5 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2562,6 +2562,13 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			Note: increases power consumption, thus should only be
 			enabled if running jitter sensitive (HPC/RT) workloads.
 
+	secureboot_enable=
+			[KNL] Enables an emulated UEFI Secure Boot mode.  This
+			locks down various aspects of the kernel guarded by the
+			CAP_COMPROMISE_KERNEL capability.  This includes things
+			like /dev/mem, IO port access, and other areas.  It can
+			be used on non-UEFI machines for testing purposes.
+
 	security=	[SECURITY] Choose a security module to enable at boot.
 			If this boot parameter is not specified, only the first
 			security module asking for security registration will be
diff --git a/kernel/cred.c b/kernel/cred.c
index de728ac..7e6e83f 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -623,6 +623,23 @@ void __init cred_init(void)
 				     0, SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
 }
 
+void __init secureboot_enable()
+{
+	pr_info("Secure boot enabled\n");
+	cap_lower((&init_cred)->cap_bset, CAP_COMPROMISE_KERNEL);
+	cap_lower((&init_cred)->cap_permitted, CAP_COMPROMISE_KERNEL);
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

