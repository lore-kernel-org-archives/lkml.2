Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab2GIRgx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 13:36:53 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:54362 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab2GIRgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 13:36:51 -0400
From: Rafal Krypa <r.krypa@samsung.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rafal Krypa <r.krypa@samsung.com>
Subject: [PATCH] Smack: don't show empty rules when /smack/load or /smack/load2
 is read
Date: Mon, 09 Jul 2012 19:36:34 +0200
Message-id: <1341855394-13359-1-git-send-email-r.krypa@samsung.com>
X-Mailer: git-send-email 1.7.10.4
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes empty rules (i.e. with access set to '-') from the
rule list presented to user space.

Smack by design never removes labels nor rules from its lists. Access
for a rule may be set to '-' to effectively disable it. Such rules would
show up in the listing generated when /smack/load or /smack/load2 is
read. This may cause clutter if many rules were disabled.

As a rule with access set to '-' is equivalent to no rule at all, they
may be safely hidden from the listing.

Targeted for git://git.gitorious.org/smack-next/kernel.git

Signed-off-by: Rafal Krypa <r.krypa@samsung.com>
---
 security/smack/smackfs.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 29b760d..d31e6d9 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -518,6 +518,9 @@ static void smk_rule_show(struct seq_file *s, struct smack_rule *srp, int max)
 	if (strlen(srp->smk_subject) >= max || strlen(srp->smk_object) >= max)
 		return;
 
+	if (srp->smk_access == 0)
+		return;
+
 	seq_printf(s, "%s %s", srp->smk_subject, srp->smk_object);
 
 	seq_putc(s, ' ');
@@ -532,8 +535,6 @@ static void smk_rule_show(struct seq_file *s, struct smack_rule *srp, int max)
 		seq_putc(s, 'a');
 	if (srp->smk_access & MAY_TRANSMUTE)
 		seq_putc(s, 't');
-	if (srp->smk_access == 0)
-		seq_putc(s, '-');
 
 	seq_putc(s, '\n');
 }
-- 
1.7.10.4

