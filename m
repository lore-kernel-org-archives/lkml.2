Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab2HMUYe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:24:34 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:53797 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670Ab2HMUYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:24:20 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <netdev@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <containers@lists.linux-foundation.org>,
        David Miller <davem@davemloft.net>, Serge Hallyn <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jan Engelhardt <jengelh@medozas.de>, Patrick McHardy <kaber@trash.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon, 13 Aug 2012 13:18:33 -0700
Message-Id: <1344889115-21610-19-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1344889115-21610-1-git-send-email-ebiederm@xmission.com>
References: <87ehnav9n5.fsf@xmission.com>
 <1344889115-21610-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+f/lPueVEmdbiSNL68sUA5VFSXylGTrrI=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0671]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<netdev@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 19/21] userns: xt_owner: Add basic user namespace support.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

- Only allow adding matches from the initial user namespace
- Add the appropriate conversion functions to handle matches
  against sockets in other user namespaces.

Cc: Jan Engelhardt <jengelh@medozas.de>
Cc: Patrick McHardy <kaber@trash.net>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 init/Kconfig             |    1 -
 net/netfilter/xt_owner.c |   30 ++++++++++++++++++++++++------
 2 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 40f5020..76ffca9 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -943,7 +943,6 @@ config UIDGID_CONVERTED
 
 	# Networking
 	depends on NET_9P = n
-	depends on NETFILTER_XT_MATCH_OWNER = n
 	depends on AF_RXRPC = n
 	depends on NET_KEY = n
 	depends on DNS_RESOLVER = n
diff --git a/net/netfilter/xt_owner.c b/net/netfilter/xt_owner.c
index 772d738..ca2e577 100644
--- a/net/netfilter/xt_owner.c
+++ b/net/netfilter/xt_owner.c
@@ -17,6 +17,17 @@
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_owner.h>
 
+static int owner_check(const struct xt_mtchk_param *par)
+{
+	struct xt_owner_match_info *info = par->matchinfo;
+
+	/* For now only allow adding matches from the initial user namespace */
+	if ((info->match & (XT_OWNER_UID|XT_OWNER_GID)) &&
+	    (current_user_ns() != &init_user_ns))
+		return -EINVAL;
+	return 0;
+}
+
 static bool
 owner_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
@@ -37,17 +48,23 @@ owner_mt(const struct sk_buff *skb, struct xt_action_param *par)
 		return ((info->match ^ info->invert) &
 		       (XT_OWNER_UID | XT_OWNER_GID)) == 0;
 
-	if (info->match & XT_OWNER_UID)
-		if ((filp->f_cred->fsuid >= info->uid_min &&
-		    filp->f_cred->fsuid <= info->uid_max) ^
+	if (info->match & XT_OWNER_UID) {
+		kuid_t uid_min = make_kuid(&init_user_ns, info->uid_min);
+		kuid_t uid_max = make_kuid(&init_user_ns, info->uid_max);
+		if ((uid_gte(filp->f_cred->fsuid, uid_min) &&
+		     uid_lte(filp->f_cred->fsuid, uid_max)) ^
 		    !(info->invert & XT_OWNER_UID))
 			return false;
+	}
 
-	if (info->match & XT_OWNER_GID)
-		if ((filp->f_cred->fsgid >= info->gid_min &&
-		    filp->f_cred->fsgid <= info->gid_max) ^
+	if (info->match & XT_OWNER_GID) {
+		kgid_t gid_min = make_kgid(&init_user_ns, info->gid_min);
+		kgid_t gid_max = make_kgid(&init_user_ns, info->gid_max);
+		if ((gid_gte(filp->f_cred->fsgid, gid_min) &&
+		     gid_lte(filp->f_cred->fsgid, gid_max)) ^
 		    !(info->invert & XT_OWNER_GID))
 			return false;
+	}
 
 	return true;
 }
@@ -56,6 +73,7 @@ static struct xt_match owner_mt_reg __read_mostly = {
 	.name       = "owner",
 	.revision   = 1,
 	.family     = NFPROTO_UNSPEC,
+	.checkentry = owner_check,
 	.match      = owner_mt,
 	.matchsize  = sizeof(struct xt_owner_match_info),
 	.hooks      = (1 << NF_INET_LOCAL_OUT) |
-- 
1.7.5.4

