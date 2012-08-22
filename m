Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933339Ab2HVVtK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 17:49:10 -0400
Received: from nm4.access.bullet.mail.mud.yahoo.com ([66.94.237.205]:27357
	"HELO nm4.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932343Ab2HVVtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 17:49:06 -0400
X-Yahoo-Newman-Id: 649693.16973.bm@smtp108.biz.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: P48zgFsVM1lul5nmNe_7HaioxKrxfCsT5AsW7jJqyUxND1K
 OyD5sVZzW81ZxUlJRblwNL9XALqw5fjWhrTqbgY0QJ_bpd6j8e_FkDQ.Gxdq
 zfYQDiXJ3ndI9NSM5n2LOihMWosq.Qw3KXgDsSfY.QkEFaWIHMaaTpEe9aht
 NNxX5tSfLFh2yMLjnOl0gg3zkiD7NqkCDuxaoxf8vZPUFhvuSS8Uox32K8DY
 GMOX6H2Knhk6l.YUKIeMH5LXbPotpVCOSlpRShVrDnRkaRRwARVS6u4Y_gfr
 H9XEuE7m_tZNtaGGZtI9sGpsynrOmM8JUP5TmVrgSzSuTLI2bbWXEXnf0nX9
 yYLTRvKnkwG7ovwgIhNRthxr38aS4GkBEluIKaaKHGsNQM50bVjS7KQojb4G
 d94glYFmXpZ7ZKVeBIvlt94Ee3lxrxQPPtTBjLg6qBajYk2.PIEsf.s_sTkR
 t6DT4jXkASoI9F1D_VqR769LWNj__456gxYloaZ9jyTqEfrkTRaxBs_6TI0F
 F5msVBxZId8IFYWXc8Kk_EE4y624hiPaleJ.bvMz1v1JHWV6Xb0M-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <503553D1.2040504@schaufler-ca.com>
Date: Wed, 22 Aug 2012 14:49:05 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: LKLM <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH] Smack: setprocattr memory leak fix
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH] Smack: setprocattr memory leak fix

The data structure allocations being done in prepare_creds
are duplicated in smack_setprocattr. This results in the
structure allocated in prepare_creds being orphaned and
never freed. The duplicate code is removed from
smack_setprocattr.

Targeted for git://git.gitorious.org/smack-next/kernel.git

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

---

 security/smack/smack_lsm.c |   14 ++------------
 1 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index ce9273a..2874c73 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -2684,9 +2684,7 @@ static int smack_getprocattr(struct task_struct *p, char *name, char **value)
 static int smack_setprocattr(struct task_struct *p, char *name,
 			     void *value, size_t size)
 {
-	int rc;
 	struct task_smack *tsp;
-	struct task_smack *oldtsp;
 	struct cred *new;
 	char *newsmack;
 
@@ -2716,21 +2714,13 @@ static int smack_setprocattr(struct task_struct *p, char *name,
 	if (newsmack == smack_known_web.smk_known)
 		return -EPERM;
 
-	oldtsp = p->cred->security;
 	new = prepare_creds();
 	if (new == NULL)
 		return -ENOMEM;
 
-	tsp = new_task_smack(newsmack, oldtsp->smk_forked, GFP_KERNEL);
-	if (tsp == NULL) {
-		kfree(new);
-		return -ENOMEM;
-	}
-	rc = smk_copy_rules(&tsp->smk_rules, &oldtsp->smk_rules, GFP_KERNEL);
-	if (rc != 0)
-		return rc;
+	tsp = new->security;
+	tsp->smk_task = newsmack;
 
-	new->security = tsp;
 	commit_creds(new);
 	return size;
 }

