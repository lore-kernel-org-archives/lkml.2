Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab2EXArD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 20:47:03 -0400
Received: from nm8.access.bullet.mail.mud.yahoo.com ([66.94.237.209]:37960
	"HELO nm8.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751000Ab2EXAq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 20:46:59 -0400
X-Yahoo-Newman-Id: 371763.60473.bm@smtp106.biz.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: S_wPrwcVM1m76cFXhvAxc_Xl8Swt2fIsrOx.yZyFxqimugT
 4tfUdpnGqyvUS7hz6ONgEreGYC.7UBamweTat297HJvbh8SCfL.LSwmBMrhv
 cWUdTf7EbknJfUfhkYNwT1WAWlqO38rM3WQ1zdU0ybBEEEiW9QsCxtCGmhA2
 5_WEuHE6VoV5J0w6i7iYSXEaU6tzxGrTsUS7ovqaB3wll16t6hbU3X2i99_1
 .aKSI6_V5zrI6pUHo1uJZhiG5g4D.nI.ayBh8DCRs_3L7ztD7DBs22p2znt_
 pWp61cyhHuL9vDkZWyv75E1FaGSukF70gES5LyeegWpgwGmqf1x8iiyLLqXU
 XVZ_U1HZ_fROh1NddgAbCAjia5D85v6YdjKMVsnDxUkWn0wWcNHbZeNS3rKL
 6lOASNrmk9yIu.ar5aZH2OXvzToeuVPUZDu33R22CFFLkJqpF21SMxa3v2bq
 HVzYnUxo1xpwrL2GJ6qCYzOyc6mejRe9ncgzwsjdckubwJFxxOSVAoEEqPbv
 aDm7xS3qPyC2_z64vCkiLjIgmIBSsKw--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <4FBD8502.4010602@schaufler-ca.com>
Date: Wed, 23 May 2012 17:46:58 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: LKLM <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH] Smack: fix smack_new_inode bogosities
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH] Smack: fix smack_new_inode bogosities

In January of 2012 Al Viro pointed out three bits of code that
he titled "new_inode_smack bogosities". This patch repairs these
errors.

1. smack_sb_kern_mount() included a NULL check that is impossible.
   The check and NULL case are removed.
2. smack_kb_kern_mount() included pointless locking. The locking is
   removed. Since this is the only place that lock was used the lock
   is removed from the superblock_smack structure.
3. smk_fill_super() incorrectly and unnecessarily set the Smack label
   for the smackfs root inode. The assignment has been removed.

Targeted for git://gitorious.org/smack-next/kernel.git

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

---

 security/smack/smack.h     |    1 -
 security/smack/smack_lsm.c |    8 ++------
 security/smack/smackfs.c   |    1 -
 3 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/security/smack/smack.h b/security/smack/smack.h
index cc361b8..76feb31 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -43,7 +43,6 @@ struct superblock_smack {
 	char		*smk_hat;
 	char		*smk_default;
 	int		smk_initialized;
-	spinlock_t	smk_sblock;	/* for initialization */
 };
 
 struct socket_smack {
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index d583c05..5a4d52c 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -251,7 +251,6 @@ static int smack_sb_alloc_security(struct super_block *sb)
 	sbsp->smk_floor = smack_known_floor.smk_known;
 	sbsp->smk_hat = smack_known_hat.smk_known;
 	sbsp->smk_initialized = 0;
-	spin_lock_init(&sbsp->smk_sblock);
 
 	sb->s_security = sbsp;
 
@@ -332,13 +331,10 @@ static int smack_sb_kern_mount(struct super_block *sb, int flags, void *data)
 	char *commap;
 	char *nsp;
 
-	spin_lock(&sp->smk_sblock);
-	if (sp->smk_initialized != 0) {
-		spin_unlock(&sp->smk_sblock);
+	if (sp->smk_initialized != 0)
 		return 0;
-	}
+
 	sp->smk_initialized = 1;
-	spin_unlock(&sp->smk_sblock);
 
 	for (op = data; op != NULL; op = commap) {
 		commap = strchr(op, ',');
diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 1810c9a..3686db7 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -2051,7 +2051,6 @@ static int smk_fill_super(struct super_block *sb, void *data, int silent)
 	}
 
 	root_inode = sb->s_root->d_inode;
-	root_inode->i_security = new_inode_smack(smack_known_floor.smk_known);
 
 	return 0;
 }



