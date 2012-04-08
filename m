Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab2DHFM4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 01:12:56 -0400
Received: from out07.mta.xmission.com ([166.70.13.237]:44064 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752835Ab2DHFMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 01:12:25 -0400
From: "\"Eric W. Beiderman" <ebiederm@xmission.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Sat,  7 Apr 2012 22:15:24 -0700
Message-Id: <1333862139-31737-28-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <m11unyn70b.fsf@fess.ebiederm.org>
References: <m11unyn70b.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+9bZR4F+hoP3CUPb93cnqjQ5KiW2bTR5E=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.1 FH_FROMEML_NOTLD E-mail address doesn't have TLD (.com, etc.)
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: **
Subject: [PATCH 28/43] userns: Convert user specfied uids and gids in chown into kuids and kgid
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/open.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 92335f6..e166801 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -506,15 +506,24 @@ static int chown_common(struct path *path, uid_t user, gid_t group)
 	struct inode *inode = path->dentry->d_inode;
 	int error;
 	struct iattr newattrs;
+	kuid_t uid;
+	kgid_t gid;
+
+	uid = make_kuid(current_user_ns(), user);
+	gid = make_kgid(current_user_ns(), group);
 
 	newattrs.ia_valid =  ATTR_CTIME;
 	if (user != (uid_t) -1) {
+		if (!uid_valid(uid))
+			return -EINVAL;
 		newattrs.ia_valid |= ATTR_UID;
-		newattrs.ia_uid = user;
+		newattrs.ia_uid = uid;
 	}
 	if (group != (gid_t) -1) {
+		if (!gid_valid(gid))
+			return -EINVAL;
 		newattrs.ia_valid |= ATTR_GID;
-		newattrs.ia_gid = group;
+		newattrs.ia_gid = gid;
 	}
 	if (!S_ISDIR(inode->i_mode))
 		newattrs.ia_valid |=
-- 
1.7.2.5

