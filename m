Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964795Ab2HVSuj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 14:50:39 -0400
Received: from nm12-vm3.bullet.mail.gq1.yahoo.com ([98.136.218.190]:31029 "HELO
	nm12-vm3.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756237Ab2HVSug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 14:50:36 -0400
X-Yahoo-Newman-Id: 753969.44760.bm@smtp102.biz.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: U07sIS8VM1nOnl5E4vNgC0v4cBpTBja2Pgqu.n6e_.jeM8S
 yBVtZHDWLOLGbz.gL73o3Gny6SKf27.wx7h2F0OVh7CeT8H9A.ba3FY_1CpL
 Dh6p43iNOTnQ3Zljc6iKpis4T5teQ_lZ9R.YmY4.IftjzdZudjNDwqBq9OeC
 _ccWByOsDLb76PvTTKOMN1gtUgR1eqVcSGjWoru2A42kXMKQKliTSnbVUjB.
 eCvJfXvt2V6rc6JbyDUqB9d1L8tHH2GU10nZfU3g99lGe9HrPUeHIZwnTSTs
 R.vnnjMT29APnV8nI8Uc2G0ije9Y2ah7GSwc7uozWZA6nHsNoJw7dC0SjA5y
 R3EqhUjtiV1VQxuGzcaTv7GUERSLlwEwRxcDQtnjkxqxieosk_weddX3zfFm
 JeJ.egp3b20yAC7pOpitjDeh.FH5cxjOsa_B62z4dNtRZvzAJZIFd9qF1mgZ
 31mQEjGgmFwy6zZ9uIHTHZH0RcMfwVW0eQg2F_SPTAtYZZvMlEPh4ihS13HK
 wejC77v3U6DB5opjIAi5oQyR04wWfoGqYotjonVHyRQ--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <50352873.9070706@schaufler-ca.com>
Date: Wed, 22 Aug 2012 11:44:03 -0700
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

