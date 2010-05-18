Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab0ERT6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 15:58:45 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:43493 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899Ab0ERT6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 15:58:43 -0400
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
References: <20100518164520.7e9652b1.sfr@canb.auug.org.au>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 18 May 2010 12:58:33 -0700
In-Reply-To: <20100518164520.7e9652b1.sfr@canb.auug.org.au> (Stephen Rothwell's message of "Tue\, 18 May 2010 16\:45\:20 +1000")
Message-ID: <m1hbm5f0d2.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Rcpt-To: sfr@canb.auug.org.au, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org, linux-next@vger.kernel.org, greg@kroah.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Stephen Rothwell <sfr@canb.auug.org.au>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: linux-next: build failure after merge of the driver-core tree
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Greg this fixes the conflict with the vfs tree we see in linux-next.

Al I will be happy to work with you to rework this hunk of code in the
next cycle so you can kill sb_lock.  It is just too late in the cycle
to be making more than the minimal change necessary.

Eric

From: Eric W. Biederman <ebiederm@aristanetworks.com>
Date: Tue, 18 May 2010 12:24:26 -0700
Subject: [PATCH] sysfs:  Remove usage of S_BIAS to avoid merge conflict with the vfs tree

In Al's latest vfs tree the code is reworked and S_BIAS has been removed.

It turns out that checking to see if a super block is in the
middle of an unmount in sysfs_exit_ns is unnecessary because we
remove the super_block from the s_supers/s_instances list before
struct sysfs_super_info pointed to by sb->s_fs_info is freed.

For now just delete the unnecessary check to see if a superblock is in the
middle of an unmount, it isn't necessary with or without Al's changes
and it just causes a needless conflict.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 fs/sysfs/mount.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index bbba090..74f0529 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -144,6 +144,9 @@ static void sysfs_kill_sb(struct super_block *sb)
 {
 	struct sysfs_super_info *info = sysfs_info(sb);
 
+	/* Remove the superblock from fs_supers/s_instances
+	 * so we can't find it, before freeing sysfs_super_info.
+	 */
 	kill_anon_super(sb);
 	kfree(info);
 }
@@ -162,9 +165,11 @@ void sysfs_exit_ns(enum kobj_ns_type type, const void *ns)
 	spin_lock(&sb_lock);
 	list_for_each_entry(sb, &sysfs_fs_type.fs_supers, s_instances) {
 		struct sysfs_super_info *info = sysfs_info(sb);
-		/* Ignore superblocks that are in the process of unmounting */
-		if (sb->s_count <= S_BIAS)
-			continue;
+		/*
+		 * If we see a superblock on the fs_supers/s_instances
+		 * list the unmount has not completed and sb->s_fs_info
+		 * points to a valid struct sysfs_super_info.
+		 */
 		/* Ignore superblocks with the wrong ns */
 		if (info->ns[type] != ns)
 			continue;
-- 
1.6.6.1

