Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131Ab2IUA3G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 20:29:06 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:41684 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756593Ab2IUA3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 20:29:03 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-security-module@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Signed-off-by: Jens Axboe" <jaxboe@fusionio.com>
Date: Thu, 20 Sep 2012 17:28:37 -0700
Message-Id: <1348187330-6616-1-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <87k3vote43.fsf@xmission.com>
References: <87k3vote43.fsf@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19Z8Z124jNBoEpWxpBKBaBUcS6Sji3iWYQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0001]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-security-module@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 01/14] userns: Convert loop to use kuid_t instead of uid_t
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Cc: Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 drivers/block/loop.c |    4 ++--
 include/linux/loop.h |    2 +-
 init/Kconfig         |    1 -
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 3bba655..e9d594f 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1038,10 +1038,10 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 {
 	int err;
 	struct loop_func_table *xfer;
-	uid_t uid = current_uid();
+	kuid_t uid = current_uid();
 
 	if (lo->lo_encrypt_key_size &&
-	    lo->lo_key_owner != uid &&
+	    !uid_eq(lo->lo_key_owner, uid) &&
 	    !capable(CAP_SYS_ADMIN))
 		return -EPERM;
 	if (lo->lo_state != Lo_bound)
diff --git a/include/linux/loop.h b/include/linux/loop.h
index 11a41a8..9635116 100644
--- a/include/linux/loop.h
+++ b/include/linux/loop.h
@@ -44,7 +44,7 @@ struct loop_device {
 	int		lo_encrypt_key_size;
 	struct loop_func_table *lo_encryption;
 	__u32           lo_init[2];
-	uid_t		lo_key_owner;	/* Who set the key */
+	kuid_t		lo_key_owner;	/* Who set the key */
 	int		(*ioctl)(struct loop_device *, int cmd, 
 				 unsigned long arg); 
 
diff --git a/init/Kconfig b/init/Kconfig
index f0371a6..f315997 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -960,7 +960,6 @@ config UIDGID_CONVERTED
 	depends on !UML || HOSTFS = n
 
 	# The rare drivers that won't build
-	depends on BLK_DEV_LOOP = n
 	depends on ANDROID_BINDER_IPC = n
 
 	# Security modules
-- 
1.7.5.4

