Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab2ITLox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 07:44:53 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:39176 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111Ab2ITLmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 07:42:35 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>
Date: Thu, 20 Sep 2012 04:41:44 -0700
Message-Id: <1348141326-23355-3-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348141326-23355-1-git-send-email-ebiederm@xmission.com>
References: <877grox6ql.fsf@xmission.com>
 <1348141326-23355-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19UVZ6kphLUY8R2OS6FEvTqzFROPPeY9Vk=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0007]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 03/25] userns: Convert usb functionfs to use kuid/kgid where appropriate
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Felipe Balbi <balbi@ti.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 drivers/usb/gadget/f_fs.c |   23 ++++++++++++++++-------
 init/Kconfig              |    1 -
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index 8adc79d..f9ee4e0 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -220,8 +220,8 @@ struct ffs_data {
 	/* File permissions, written once when fs is mounted */
 	struct ffs_file_perms {
 		umode_t				mode;
-		uid_t				uid;
-		gid_t				gid;
+		kuid_t				uid;
+		kgid_t				gid;
 	}				file_perms;
 
 	/*
@@ -1143,10 +1143,19 @@ static int ffs_fs_parse_opts(struct ffs_sb_fill_data *data, char *opts)
 			break;
 
 		case 3:
-			if (!memcmp(opts, "uid", 3))
-				data->perms.uid = value;
+			if (!memcmp(opts, "uid", 3)) {
+				data->perms.uid = make_kuid(current_user_ns(), value);
+				if (!uid_valid(data->perms.uid)) {
+					pr_err("%s: unmapped value: %lu\n", opts, value);
+					return -EINVAL;
+				}
+			}
 			else if (!memcmp(opts, "gid", 3))
-				data->perms.gid = value;
+				data->perms.gid = make_kgid(current_user_ns(), value);
+				if (!gid_valid(data->perms.gid)) {
+					pr_err("%s: unmapped value: %lu\n", opts, value);
+					return -EINVAL;
+				}
 			else
 				goto invalid;
 			break;
@@ -1175,8 +1184,8 @@ ffs_fs_mount(struct file_system_type *t, int flags,
 	struct ffs_sb_fill_data data = {
 		.perms = {
 			.mode = S_IFREG | 0600,
-			.uid = 0,
-			.gid = 0
+			.uid = GLOBAL_ROOT_UID,
+			.gid = GLOBAL_ROOT_GID,
 		},
 		.root_mode = S_IFDIR | 0500,
 	};
diff --git a/init/Kconfig b/init/Kconfig
index 633bde2..e7e0cc1 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -932,7 +932,6 @@ config UIDGID_CONVERTED
 	depends on NET_9P = n
 
 	# Filesystems
-	depends on USB_FUNCTIONFS = n
 	depends on DEVTMPFS = n
 	depends on XENFS = n
 
-- 
1.7.5.4

