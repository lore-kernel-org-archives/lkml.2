Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389Ab2FSCBh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 22:01:37 -0400
Received: from nm3.access.bullet.mail.mud.yahoo.com ([66.94.237.204]:40692
	"HELO nm3.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752256Ab2FSCBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 22:01:33 -0400
X-Yahoo-Newman-Id: 68213.23830.bm@smtp106.biz.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: N2FryAgVM1kR1GoJXERQEPYqXo7WjMS.OBUgqQYfbe8uDZh
 oplvkzbnm1P2qF4deolrGl7JhM0NIdcVRgcgw4DlbkVxnbvAOeD3yb57EGcD
 yoEf8SGhn6za9wDnEK44uTQjooXUuLX09xYaAfbukJvTS4iI4V0OJh6qRpL_
 1UuJpOy7A3AWqmTQ2hkJ4v8och6WPJANUPeuPv62Vtm8673hWWQvpwHxuplm
 OjF8kQB6nqiCqQDWNK0s3G77gBmYVJ0li5lPb7NIQlks9t2x.h71pfUQR810
 wVqmyxcHWhGbf1WA7nrPNmejq_3WtkAdkF2J10N963s7CI8svxO6fVu1lmJo
 9CJ13lCNzVbEoFEY2CgLma6g0.1uXYnDP6QZx8Mz7JdtIIs7IfAloynHkIHF
 aGAm.xXCSNnl6aVc9uRGtoVTau_gnDN3S66Uipp9fMnK_ik8iwZrQHM8e3OL
 zT8JPRpA5_s3UiWRtMNq5MHOTFPZcwLGIMrLNTDdbkxL1nYWUgh7KElQMi97
 biUHwYVexDBGqb95Cd7xA3LOCmg--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <4FDFDD80.9010007@schaufler-ca.com>
Date: Mon, 18 Jun 2012 19:01:36 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: LKLM <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH] Smack: user access check bounds
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH] Smack: user access check bounds

Some of the bounds checking used on the /smack/access
interface was lost when support for long labels was
added. No kernel access checks are affected, however
this is a case where /smack/access could be used
incorrectly and fail to detect the error. This patch
reintroduces the original checks.

Targeted for git://git.gitorious.org/smack-next/kernel.git

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

---

 security/smack/smackfs.c |   26 ++++++++++++--------------
 1 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 2152965..29b760d 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -215,28 +215,27 @@ static int smk_set_access(struct smack_rule *srp, struct list_head *rule_list,
  * @access: access string
  * @rule: Smack rule
  * @import: if non-zero, import labels
+ * @len: label length limit
  *
  * Returns 0 on success, -1 on failure
  */
 static int smk_fill_rule(const char *subject, const char *object,
 				const char *access, struct smack_rule *rule,
-				int import)
+				int import, int len)
 {
-	int rc = -1;
-	int done;
 	const char *cp;
 	struct smack_known *skp;
 
 	if (import) {
-		rule->smk_subject = smk_import(subject, 0);
+		rule->smk_subject = smk_import(subject, len);
 		if (rule->smk_subject == NULL)
 			return -1;
 
-		rule->smk_object = smk_import(object, 0);
+		rule->smk_object = smk_import(object, len);
 		if (rule->smk_object == NULL)
 			return -1;
 	} else {
-		cp = smk_parse_smack(subject, 0);
+		cp = smk_parse_smack(subject, len);
 		if (cp == NULL)
 			return -1;
 		skp = smk_find_entry(cp);
@@ -245,7 +244,7 @@ static int smk_fill_rule(const char *subject, const char *object,
 			return -1;
 		rule->smk_subject = skp->smk_known;
 
-		cp = smk_parse_smack(object, 0);
+		cp = smk_parse_smack(object, len);
 		if (cp == NULL)
 			return -1;
 		skp = smk_find_entry(cp);
@@ -257,7 +256,7 @@ static int smk_fill_rule(const char *subject, const char *object,
 
 	rule->smk_access = 0;
 
-	for (cp = access, done = 0; *cp && !done; cp++) {
+	for (cp = access; *cp != '\0'; cp++) {
 		switch (*cp) {
 		case '-':
 			break;
@@ -282,13 +281,11 @@ static int smk_fill_rule(const char *subject, const char *object,
 			rule->smk_access |= MAY_TRANSMUTE;
 			break;
 		default:
-			done = 1;
-			break;
+			return 0;
 		}
 	}
-	rc = 0;
 
-	return rc;
+	return 0;
 }
 
 /**
@@ -304,7 +301,8 @@ static int smk_parse_rule(const char *data, struct smack_rule *rule, int import)
 	int rc;
 
 	rc = smk_fill_rule(data, data + SMK_LABELLEN,
-			   data + SMK_LABELLEN + SMK_LABELLEN, rule, import);
+			   data + SMK_LABELLEN + SMK_LABELLEN, rule, import,
+			   SMK_LABELLEN);
 	return rc;
 }
 
@@ -340,7 +338,7 @@ static int smk_parse_long_rule(const char *data, struct smack_rule *rule,
 		goto free_out_o;
 
 	if (sscanf(data, "%s %s %s", subject, object, access) == 3)
-		rc = smk_fill_rule(subject, object, access, rule, import);
+		rc = smk_fill_rule(subject, object, access, rule, import, 0);
 
 	kfree(access);
 free_out_o:


