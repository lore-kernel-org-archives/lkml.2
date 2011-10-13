Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab1JMICW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 04:02:22 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:34396 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab1JMICU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 04:02:20 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg Kroah-Hartman <gregkh@suse.de>, David Miller <davem@davemloft.net>
Cc: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Tejun Heo <htejun@gmail.com>, Jay Vosburgh <fubar@us.ibm.com>,
        Andy Gospodarek <andy@greyhouse.net>
References: <m1hb3dbae5.fsf@fess.ebiederm.org>
	<m1wrc99vjx.fsf@fess.ebiederm.org>
	<m1sjmx9vhf.fsf_-_@fess.ebiederm.org>
	<m1mxd59vfa.fsf_-_@fess.ebiederm.org>
	<m1ehyh9v6p.fsf_-_@fess.ebiederm.org>
Date: Thu, 13 Oct 2011 01:02:43 -0700
In-Reply-To: <m1ehyh9v6p.fsf_-_@fess.ebiederm.org> (Eric W. Biederman's
	message of "Thu, 13 Oct 2011 01:01:34 -0700")
Message-ID: <m1aa959v4s.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19Hp8fK66WfSWOXa4vP8TA4gJi2EHfJCtY=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.8 RDNS_NONE Delivered to internal network by a host with no rDNS
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg Kroah-Hartman <gregkh@suse.de>, David Miller
	<davem@davemloft.net>
X-Spam-Relay-Country: **
Subject: [PATCH 5/5] sysfs: Reject with a warning invalid uses of tagged directories.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


sysfs is a core piece of ifrastructure that many people use and
few people have all of the rules in their head on how to use
it correctly.  Add warnings for people using tagged directories
improperly to that any misuses can be caught and diagnosed quickly.

A single inexpensive test in sysfs_find_dirent is almost sufficient
to catch all possible misuses.  An additional warning is needed
in sysfs_add_dirent so that we actually fail when attempting to
add an untagged dirent in a tagged directory.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/sysfs/dir.c  |   14 ++++++++++++++
 fs/sysfs/file.c |    3 ---
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 352d26d..26f370a 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -384,6 +384,13 @@ int __sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 {
 	struct sysfs_inode_attrs *ps_iattr;
 
+	if (!!sysfs_ns_type(acxt->parent_sd) != !!sd->s_ns) {
+		WARN(1, KERN_WARNING "sysfs: ns %s in '%s' for '%s'\n",
+			sysfs_ns_type(acxt->parent_sd)? "required": "invalid",
+			acxt->parent_sd->s_name, sd->s_name);
+		return -EINVAL;
+	}
+
 	if (sysfs_find_dirent(acxt->parent_sd, sd->s_ns, sd->s_name))
 		return -EEXIST;
 
@@ -542,6 +549,13 @@ struct sysfs_dirent *sysfs_find_dirent(struct sysfs_dirent *parent_sd,
 {
 	struct sysfs_dirent *sd;
 
+	if (!!sysfs_ns_type(parent_sd) != !!ns) {
+		WARN(1, KERN_WARNING "sysfs: ns %s in '%s' for '%s'\n",
+			sysfs_ns_type(parent_sd)? "required": "invalid",
+			parent_sd->s_name, name);
+		return NULL;
+	}
+
 	for (sd = parent_sd->s_dir.children; sd; sd = sd->s_sibling) {
 		if (sd->s_ns != ns)
 			continue;
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 07c1b4e..d4e6080 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -466,9 +466,6 @@ void sysfs_notify(struct kobject *k, const char *dir, const char *attr)
 	mutex_lock(&sysfs_mutex);
 
 	if (sd && dir)
-		/* Only directories are tagged, so no need to pass
-		 * a tag explicitly.
-		 */
 		sd = sysfs_find_dirent(sd, NULL, dir);
 	if (sd && attr)
 		sd = sysfs_find_dirent(sd, NULL, attr);
-- 
1.7.2.5

