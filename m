Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab1JMIBP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 04:01:15 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:54602 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab1JMIBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 04:01:13 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg Kroah-Hartman <gregkh@suse.de>, David Miller <davem@davemloft.net>
Cc: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Tejun Heo <htejun@gmail.com>, Jay Vosburgh <fubar@us.ibm.com>,
        Andy Gospodarek <andy@greyhouse.net>
References: <m1hb3dbae5.fsf@fess.ebiederm.org>
	<m1wrc99vjx.fsf@fess.ebiederm.org>
	<m1sjmx9vhf.fsf_-_@fess.ebiederm.org>
	<m1mxd59vfa.fsf_-_@fess.ebiederm.org>
Date: Thu, 13 Oct 2011 01:01:34 -0700
In-Reply-To: <m1mxd59vfa.fsf_-_@fess.ebiederm.org> (Eric W. Biederman's
	message of "Thu, 13 Oct 2011 00:56:25 -0700")
Message-ID: <m1ehyh9v6p.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX188kClWkHOvFMex9VUSBY6L6ABSlot27s0=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.8 RDNS_NONE Delivered to internal network by a host with no rDNS
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg Kroah-Hartman <gregkh@suse.de>, David Miller
	<davem@davemloft.net>
X-Spam-Relay-Country: **
Subject: [PATCH 4/5] sysfs: Remove support for tagged directories with untagged members.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Now that /sys/class/net/bonding_masters is implemented as a tagged sysfs
file we can remove support for untagged files in tagged directories.

This change removes any ambiguity of what a NULL namespace value
means.  A NULL namespace parameter after this patch means
that we are talking about an untagged sysfs dirent.

This makes the sysfs code much less prone to mistakes when during
maintenance.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/sysfs/dir.c   |    6 +++---
 fs/sysfs/inode.c |    2 --
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index ea9120a..352d26d 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -543,7 +543,7 @@ struct sysfs_dirent *sysfs_find_dirent(struct sysfs_dirent *parent_sd,
 	struct sysfs_dirent *sd;
 
 	for (sd = parent_sd->s_dir.children; sd; sd = sd->s_sibling) {
-		if (ns && sd->s_ns && (sd->s_ns != ns))
+		if (sd->s_ns != ns)
 			continue;
 		if (!strcmp(sd->s_name, name))
 			return sd;
@@ -885,7 +885,7 @@ static struct sysfs_dirent *sysfs_dir_pos(const void *ns,
 		while (pos && (ino > pos->s_ino))
 			pos = pos->s_sibling;
 	}
-	while (pos && pos->s_ns && pos->s_ns != ns)
+	while (pos && pos->s_ns != ns)
 		pos = pos->s_sibling;
 	return pos;
 }
@@ -896,7 +896,7 @@ static struct sysfs_dirent *sysfs_dir_next_pos(const void *ns,
 	pos = sysfs_dir_pos(ns, parent_sd, ino, pos);
 	if (pos)
 		pos = pos->s_sibling;
-	while (pos && pos->s_ns && pos->s_ns != ns)
+	while (pos && pos->s_ns != ns)
 		pos = pos->s_sibling;
 	return pos;
 }
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index e3f091a..527f0cc 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -336,8 +336,6 @@ int sysfs_hash_and_remove(struct sysfs_dirent *dir_sd, const void *ns, const cha
 	sysfs_addrm_start(&acxt, dir_sd);
 
 	sd = sysfs_find_dirent(dir_sd, ns, name);
-	if (sd && (sd->s_ns != ns))
-		sd = NULL;
 	if (sd)
 		sysfs_remove_one(&acxt, sd);
 
-- 
1.7.2.5


