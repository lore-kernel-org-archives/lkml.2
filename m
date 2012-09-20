Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab2ITCNQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 22:13:16 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:51778 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647Ab2ITCLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 22:11:34 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-security-module@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Eric Paris <eparis@redhat.com>, David Miller <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Theodore Tso <tytso@mit.edu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>
Date: Wed, 19 Sep 2012 18:52:20 -0700
Message-Id: <1348105949-25454-18-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348105949-25454-1-git-send-email-ebiederm@xmission.com>
References: <871uhx1n71.fsf@xmission.com>
 <1348105949-25454-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19KgR5MxSC1e05nzigrSULLLaWYZl8vzI8=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: linux-foundation.org]
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1681]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *******;<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 18/27] userns: Convert extN to support kuids and kgids in posix acls
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Convert ext2, ext3, and ext4 to fully support the posix acl changes,
using e_uid e_gid instead e_id.

Enabled building with posix acls enabled, all filesystems supporting
user namespaces, now also support posix acls when user namespaces are enabled.

Cc: Theodore Tso <tytso@mit.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/ext2/acl.c |   28 ++++++++++++++++++++--------
 fs/ext3/acl.c |   28 ++++++++++++++++++++--------
 fs/ext4/acl.c |   27 ++++++++++++++++++++-------
 init/Kconfig  |    1 -
 4 files changed, 60 insertions(+), 24 deletions(-)

diff --git a/fs/ext2/acl.c b/fs/ext2/acl.c
index 70bb1bc..110b6b3 100644
--- a/fs/ext2/acl.c
+++ b/fs/ext2/acl.c
@@ -53,16 +53,23 @@ ext2_acl_from_disk(const void *value, size_t size)
 			case ACL_OTHER:
 				value = (char *)value +
 					sizeof(ext2_acl_entry_short);
-				acl->a_entries[n].e_id = ACL_UNDEFINED_ID;
 				break;
 
 			case ACL_USER:
+				value = (char *)value + sizeof(ext2_acl_entry);
+				if ((char *)value > end)
+					goto fail;
+				acl->a_entries[n].e_uid =
+					make_kuid(&init_user_ns,
+						  le32_to_cpu(entry->e_id));
+				break;
 			case ACL_GROUP:
 				value = (char *)value + sizeof(ext2_acl_entry);
 				if ((char *)value > end)
 					goto fail;
-				acl->a_entries[n].e_id =
-					le32_to_cpu(entry->e_id);
+				acl->a_entries[n].e_gid =
+					make_kgid(&init_user_ns,
+						  le32_to_cpu(entry->e_id));
 				break;
 
 			default:
@@ -96,14 +103,19 @@ ext2_acl_to_disk(const struct posix_acl *acl, size_t *size)
 	ext_acl->a_version = cpu_to_le32(EXT2_ACL_VERSION);
 	e = (char *)ext_acl + sizeof(ext2_acl_header);
 	for (n=0; n < acl->a_count; n++) {
+		const struct posix_acl_entry *acl_e = &acl->a_entries[n];
 		ext2_acl_entry *entry = (ext2_acl_entry *)e;
-		entry->e_tag  = cpu_to_le16(acl->a_entries[n].e_tag);
-		entry->e_perm = cpu_to_le16(acl->a_entries[n].e_perm);
-		switch(acl->a_entries[n].e_tag) {
+		entry->e_tag  = cpu_to_le16(acl_e->e_tag);
+		entry->e_perm = cpu_to_le16(acl_e->e_perm);
+		switch(acl_e->e_tag) {
 			case ACL_USER:
+				entry->e_id = cpu_to_le32(
+					from_kuid(&init_user_ns, acl_e->e_uid));
+				e += sizeof(ext2_acl_entry);
+				break;
 			case ACL_GROUP:
-				entry->e_id =
-					cpu_to_le32(acl->a_entries[n].e_id);
+				entry->e_id = cpu_to_le32(
+					from_kgid(&init_user_ns, acl_e->e_gid));
 				e += sizeof(ext2_acl_entry);
 				break;
 
diff --git a/fs/ext3/acl.c b/fs/ext3/acl.c
index 2cf6a80..dbb5ad5 100644
--- a/fs/ext3/acl.c
+++ b/fs/ext3/acl.c
@@ -48,16 +48,23 @@ ext3_acl_from_disk(const void *value, size_t size)
 			case ACL_OTHER:
 				value = (char *)value +
 					sizeof(ext3_acl_entry_short);
-				acl->a_entries[n].e_id = ACL_UNDEFINED_ID;
 				break;
 
 			case ACL_USER:
+				value = (char *)value + sizeof(ext3_acl_entry);
+				if ((char *)value > end)
+					goto fail;
+				acl->a_entries[n].e_uid =
+					make_kuid(&init_user_ns,
+						  le32_to_cpu(entry->e_id));
+				break;
 			case ACL_GROUP:
 				value = (char *)value + sizeof(ext3_acl_entry);
 				if ((char *)value > end)
 					goto fail;
-				acl->a_entries[n].e_id =
-					le32_to_cpu(entry->e_id);
+				acl->a_entries[n].e_gid =
+					make_kgid(&init_user_ns,
+						  le32_to_cpu(entry->e_id));
 				break;
 
 			default:
@@ -91,14 +98,19 @@ ext3_acl_to_disk(const struct posix_acl *acl, size_t *size)
 	ext_acl->a_version = cpu_to_le32(EXT3_ACL_VERSION);
 	e = (char *)ext_acl + sizeof(ext3_acl_header);
 	for (n=0; n < acl->a_count; n++) {
+		const struct posix_acl_entry *acl_e = &acl->a_entries[n];
 		ext3_acl_entry *entry = (ext3_acl_entry *)e;
-		entry->e_tag  = cpu_to_le16(acl->a_entries[n].e_tag);
-		entry->e_perm = cpu_to_le16(acl->a_entries[n].e_perm);
-		switch(acl->a_entries[n].e_tag) {
+		entry->e_tag  = cpu_to_le16(acl_e->e_tag);
+		entry->e_perm = cpu_to_le16(acl_e->e_perm);
+		switch(acl_e->e_tag) {
 			case ACL_USER:
+				entry->e_id = cpu_to_le32(
+					from_kuid(&init_user_ns, acl_e->e_uid));
+				e += sizeof(ext3_acl_entry);
+				break;
 			case ACL_GROUP:
-				entry->e_id =
-					cpu_to_le32(acl->a_entries[n].e_id);
+				entry->e_id = cpu_to_le32(
+					from_kgid(&init_user_ns, acl_e->e_gid));
 				e += sizeof(ext3_acl_entry);
 				break;
 
diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
index 42b95fc..d3c5b88 100644
--- a/fs/ext4/acl.c
+++ b/fs/ext4/acl.c
@@ -55,16 +55,23 @@ ext4_acl_from_disk(const void *value, size_t size)
 		case ACL_OTHER:
 			value = (char *)value +
 				sizeof(ext4_acl_entry_short);
-			acl->a_entries[n].e_id = ACL_UNDEFINED_ID;
 			break;
 
 		case ACL_USER:
+			value = (char *)value + sizeof(ext4_acl_entry);
+			if ((char *)value > end)
+				goto fail;
+			acl->a_entries[n].e_uid =
+				make_kuid(&init_user_ns,
+					  le32_to_cpu(entry->e_id));
+			break;
 		case ACL_GROUP:
 			value = (char *)value + sizeof(ext4_acl_entry);
 			if ((char *)value > end)
 				goto fail;
-			acl->a_entries[n].e_id =
-				le32_to_cpu(entry->e_id);
+			acl->a_entries[n].e_gid =
+				make_kgid(&init_user_ns,
+					  le32_to_cpu(entry->e_id));
 			break;
 
 		default:
@@ -98,13 +105,19 @@ ext4_acl_to_disk(const struct posix_acl *acl, size_t *size)
 	ext_acl->a_version = cpu_to_le32(EXT4_ACL_VERSION);
 	e = (char *)ext_acl + sizeof(ext4_acl_header);
 	for (n = 0; n < acl->a_count; n++) {
+		const struct posix_acl_entry *acl_e = &acl->a_entries[n];
 		ext4_acl_entry *entry = (ext4_acl_entry *)e;
-		entry->e_tag  = cpu_to_le16(acl->a_entries[n].e_tag);
-		entry->e_perm = cpu_to_le16(acl->a_entries[n].e_perm);
-		switch (acl->a_entries[n].e_tag) {
+		entry->e_tag  = cpu_to_le16(acl_e->e_tag);
+		entry->e_perm = cpu_to_le16(acl_e->e_perm);
+		switch (acl_e->e_tag) {
 		case ACL_USER:
+			entry->e_id = cpu_to_le32(
+				from_kuid(&init_user_ns, acl_e->e_uid));
+			e += sizeof(ext4_acl_entry);
+			break;
 		case ACL_GROUP:
-			entry->e_id = cpu_to_le32(acl->a_entries[n].e_id);
+			entry->e_id = cpu_to_le32(
+				from_kgid(&init_user_ns, acl_e->e_gid));
 			e += sizeof(ext4_acl_entry);
 			break;
 
diff --git a/init/Kconfig b/init/Kconfig
index 2a388e5..ed6310b 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -927,7 +927,6 @@ config UIDGID_CONVERTED
 	# Features
 	depends on IMA = n
 	depends on EVM = n
-	depends on FS_POSIX_ACL = n
 	depends on QUOTA = n
 	depends on QUOTACTL = n
 
-- 
1.7.5.4

