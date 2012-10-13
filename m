Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769Ab2JMFHJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 01:07:09 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:37121 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab2JMFHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 01:07:07 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, Chris Mason <chris.mason@fusionio.com>,
        Josef Bacik <jbacik@fusionio.com>, Jan Kara <jack@suse.cz>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Masatake YAMATO <yamato@redhat.com>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Date: Fri, 12 Oct 2012 22:06:58 -0700
Message-ID: <87k3uvkljh.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19lZJE2Ydi/MMAUW8jVu8D+GQq3U3MP2ng=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0246]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [GIT PULL] user namespace compile fixes for 3.7
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull the for-linus git tree from:

   git://git.kernel.org:/pub/scm/linux/kernel/git/ebiederm/user-namespace.git for-linus

   HEAD: e9069f470803eeb5e243a05bc717452c6218bd71 btrfs: Fix compilation with user namespace support enabled

This tree contains three trivial fixes. One compiler warning, one thinko
fix, and one build fix.

Eric W. Biederman (3):
      userns: Properly print bluetooth socket uids
      userns: Fix posix_acl_file_xattr_userns gid conversion
      btrfs: Fix compilation with user namespace support enabled

 fs/btrfs/tree-log.c          |    4 ++--
 fs/xattr_acl.c               |    2 +-
 net/bluetooth/af_bluetooth.c |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

---

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index e9ebb47..81e407d 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2952,8 +2952,8 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
 			    struct btrfs_inode_item *item,
 			    struct inode *inode, int log_inode_only)
 {
-	btrfs_set_inode_uid(leaf, item, inode->i_uid);
-	btrfs_set_inode_gid(leaf, item, inode->i_gid);
+	btrfs_set_inode_uid(leaf, item, i_uid_read(inode));
+	btrfs_set_inode_gid(leaf, item, i_gid_read(inode));
 	btrfs_set_inode_mode(leaf, item, inode->i_mode);
 	btrfs_set_inode_nlink(leaf, item, inode->i_nlink);
 
diff --git a/fs/xattr_acl.c b/fs/xattr_acl.c
index 11efd83..9fbea87 100644
--- a/fs/xattr_acl.c
+++ b/fs/xattr_acl.c
@@ -45,7 +45,7 @@ static void posix_acl_fix_xattr_userns(
 			break;
 		case ACL_GROUP:
 			gid = make_kgid(from, le32_to_cpu(entry->e_id));
-			entry->e_id = cpu_to_le32(from_kuid(to, uid));
+			entry->e_id = cpu_to_le32(from_kgid(to, gid));
 			break;
 		default:
 			break;
diff --git a/net/bluetooth/af_bluetooth.c b/net/bluetooth/af_bluetooth.c
index 9d49ee6..ba033f0 100644
--- a/net/bluetooth/af_bluetooth.c
+++ b/net/bluetooth/af_bluetooth.c
@@ -591,7 +591,7 @@ static int bt_seq_show(struct seq_file *seq, void *v)
 			   atomic_read(&sk->sk_refcnt),
 			   sk_rmem_alloc_get(sk),
 			   sk_wmem_alloc_get(sk),
-			   sock_i_uid(sk),
+			   from_kuid(seq_user_ns(seq), sock_i_uid(sk)),
 			   sock_i_ino(sk),
 			   &src_baswapped,
 			   &dst_baswapped,
