Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab1BIAg3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 19:36:29 -0500
Received: from smtp105.prem.mail.sp1.yahoo.com ([98.136.44.60]:28364 "HELO
	smtp105.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755128Ab1BIAg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 19:36:27 -0500
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: bilaBesVM1nH9CHUlD7v50f8oz9r3uJwEOw1TZ2lV.pwRkn
 PYk4eZ31KYSGBR2INQeilCOM2bR9Kfar94wmzF6fdjBxPwMkJ48y1.qdBgUt
 pLU5gb_x0Vw3rEffX2OaiySu0KuyQo5cFv0WNv6ZAaFV3_MGVGr6GPBhz.uw
 FGLPKM1SEeVhfSj3SXcRz61mNRyPd.qcFFmhHl5bdKvqrSyyqXixJDVvh7WT
 DOryaD1FuhUDtmbDC9XMBELOF7cTX.rInlAw3thvgBVGsv4qC8coeJYLRN1u
 ElIvm3N4b5OB_eySq2H64syE0ozs-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4D51E188.9090008@schaufler-ca.com>
Date: Tue, 08 Feb 2011 16:36:24 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: Casey Schaufler <casey@schaufler-ca.com>,
        LKLM <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        "Sakkinen Jarkko.2 \(EXT-Tieto/Tampere\)" 
	<ext-jarkko.2.sakkinen@nokia.com>,
        Janne Karhunen <Janne.Karhunen@nokia.com>,
        "Reshetova Elena \(Nokia-D/Helsinki\)" <elena.reshetova@nokia.com>
Subject: Re: Subject: [PATCH] Smack: mmap controls for library containment
References: <4D346C8E.3080408@schaufler-ca.com>
In-Reply-To: <4D346C8E.3080408@schaufler-ca.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Subject: [PATCH] Smack: correct behavior in the mmap hook

  The mmap policy enforcement was not properly handling the
  interaction between the global and local rule lists.
  Instead of going through one and then the other, which
  missed the important case where a rule specified that
  there should be no access, combine the access limitations
  where there is a rule in each list.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

---
 security/smack/smack_lsm.c |   85 +++++++++++++++++++++++++------------------
 1 files changed, 49 insertions(+), 36 deletions(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 123a499..92cb715 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1110,38 +1110,6 @@ static int smack_file_fcntl(struct file *file, unsigned int cmd,
 }
 
 /**
- * smk_mmap_list_check - the mmap check
- * @sub: subject label
- * @obj: object label
- * @access: access mode
- * @local: the task specific rule list
- *
- * Returns 0 if acces is permitted, -EACCES otherwise
- */
-static int smk_mmap_list_check(char *sub, char *obj, int access,
-				struct list_head *local)
-{
-	int may;
-
-	/*
-	 * If there is not a global rule that
-	 * allows access say no.
-	 */
-	may = smk_access_entry(sub, obj, &smack_rule_list);
-	if (may == -ENOENT || (may & access) != access)
-		return -EACCES;
-	/*
-	 * If there is a task local rule that
-	 * denies access say no.
-	 */
-	may = smk_access_entry(sub, obj, local);
-	if (may != -ENOENT && (may & access) != access)
-		return -EACCES;
-
-	return 0;
-}
-
-/**
  * smack_file_mmap :
  * Check permissions for a mmap operation.  The @file may be NULL, e.g.
  * if mapping anonymous memory.
@@ -1160,8 +1128,12 @@ static int smack_file_mmap(struct file *file,
 	struct task_smack *tsp;
 	char *sp;
 	char *msmack;
+	char *osmack;
 	struct inode_smack *isp;
 	struct dentry *dp;
+	int may;
+	int mmay;
+	int tmay;
 	int rc;
 
 	/* do DAC check on address space usage */
@@ -1199,16 +1171,57 @@ static int smack_file_mmap(struct file *file,
 	list_for_each_entry_rcu(srp, &smack_rule_list, list) {
 		if (srp->smk_subject != sp)
 			continue;
+
+		osmack = srp->smk_object;
 		/*
 		 * Matching labels always allows access.
 		 */
-		if (msmack == srp->smk_object)
+		if (msmack == osmack)
+			continue;
+		/*
+		 * If there is a matching local rule take
+		 * that into account as well.
+		 */
+		may = smk_access_entry(srp->smk_subject, osmack,
+					&tsp->smk_rules);
+		if (may == -ENOENT)
+			may = srp->smk_access;
+		else
+			may &= srp->smk_access;
+		/*
+		 * If may is zero the SMACK64MMAP subject can't
+		 * possibly have less access.
+		 */
+		if (may == 0)
 			continue;
 
-		rc = smk_mmap_list_check(msmack, srp->smk_object,
-					 srp->smk_access, &tsp->smk_rules);
-		if (rc != 0)
+		/*
+		 * Fetch the global list entry.
+		 * If there isn't one a SMACK64MMAP subject
+		 * can't have as much access as current.
+		 */
+		mmay = smk_access_entry(msmack, osmack, &smack_rule_list);
+		if (mmay == -ENOENT) {
+			rc = -EACCES;
 			break;
+		}
+		/*
+		 * If there is a local entry it modifies the
+		 * potential access, too.
+		 */
+		tmay = smk_access_entry(msmack, osmack, &tsp->smk_rules);
+		if (tmay != -ENOENT)
+			mmay &= tmay;
+
+		/*
+		 * If there is any access available to current that is
+		 * not available to a SMACK64MMAP subject
+		 * deny access.
+		 */
+		if ((may | mmay) != may) {
+			rc = -EACCES;
+			break;
+		}
 	}
 
 	rcu_read_unlock();



