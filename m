Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708Ab2IUA3f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 20:29:35 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:55577 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291Ab2IUA3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 20:29:30 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-security-module@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>
Date: Thu, 20 Sep 2012 17:28:41 -0700
Message-Id: <1348187330-6616-5-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348187330-6616-1-git-send-email-ebiederm@xmission.com>
References: <87k3vote43.fsf@xmission.com>
 <1348187330-6616-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/5cSI99rEpqWOSYjbmd1g3cuai6SLlJW0=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4254]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 
X-Spam-Combo: *****;<linux-security-module@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 05/14] userns: Convert hostfs to use kuid and kgid where appropriate
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/hostfs/hostfs_kern.c |    8 ++++----
 init/Kconfig            |    2 --
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index 1241465..6c9f3a9 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -542,8 +542,8 @@ static int read_name(struct inode *ino, char *name)
 	ino->i_ino = st.ino;
 	ino->i_mode = st.mode;
 	set_nlink(ino, st.nlink);
-	ino->i_uid = st.uid;
-	ino->i_gid = st.gid;
+	i_uid_write(ino, st.uid);
+	i_gid_write(ino, st.gid);
 	ino->i_atime = st.atime;
 	ino->i_mtime = st.mtime;
 	ino->i_ctime = st.ctime;
@@ -808,11 +808,11 @@ int hostfs_setattr(struct dentry *dentry, struct iattr *attr)
 	}
 	if (attr->ia_valid & ATTR_UID) {
 		attrs.ia_valid |= HOSTFS_ATTR_UID;
-		attrs.ia_uid = attr->ia_uid;
+		attrs.ia_uid = from_kuid(&init_user_ns, attr->ia_uid);
 	}
 	if (attr->ia_valid & ATTR_GID) {
 		attrs.ia_valid |= HOSTFS_ATTR_GID;
-		attrs.ia_gid = attr->ia_gid;
+		attrs.ia_gid = from_kgid(&init_user_ns, attr->ia_gid);
 	}
 	if (attr->ia_valid & ATTR_SIZE) {
 		attrs.ia_valid |= HOSTFS_ATTR_SIZE;
diff --git a/init/Kconfig b/init/Kconfig
index 381f765..8450442 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -957,8 +957,6 @@ config UIDGID_CONVERTED
 	depends on UFS_FS = n
 	depends on XFS_FS = n
 
-	depends on !UML || HOSTFS = n
-
 	# The rare drivers that won't build
 	depends on ANDROID_BINDER_IPC = n
 
-- 
1.7.5.4

