Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab2HMUca (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:32:30 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:56714 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673Ab2HMUYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:24:20 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <netdev@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <containers@lists.linux-foundation.org>,
        David Miller <davem@davemloft.net>, Serge Hallyn <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>, Jan Engelhardt <jengelh@medozas.de>
Date: Mon, 13 Aug 2012 13:18:32 -0700
Message-Id: <1344889115-21610-18-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1344889115-21610-1-git-send-email-ebiederm@xmission.com>
References: <87ehnav9n5.fsf@xmission.com>
 <1344889115-21610-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18DUl739BARTtzxpFhW4EmgXrss4298JfQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0593]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<netdev@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 18/21] userns xt_recent: Specify the owner/group of ip_list_perms in the initial user namespace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

xt_recent creates a bunch of proc files and initializes their uid
and gids to the values of ip_list_uid and ip_list_gid.  When
initialize those proc files convert those values to kuids so they
can continue to reside on the /proc inode.

Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Patrick McHardy <kaber@trash.net>
Cc: Jan Engelhardt <jengelh@medozas.de>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 init/Kconfig              |    1 -
 net/netfilter/xt_recent.c |   13 +++++++++++--
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index c8911eb..40f5020 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -944,7 +944,6 @@ config UIDGID_CONVERTED
 	# Networking
 	depends on NET_9P = n
 	depends on NETFILTER_XT_MATCH_OWNER = n
-	depends on NETFILTER_XT_MATCH_RECENT = n
 	depends on AF_RXRPC = n
 	depends on NET_KEY = n
 	depends on DNS_RESOLVER = n
diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index ae2ad1e..4635c9b 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -317,6 +317,8 @@ static int recent_mt_check(const struct xt_mtchk_param *par,
 	struct recent_table *t;
 #ifdef CONFIG_PROC_FS
 	struct proc_dir_entry *pde;
+	kuid_t uid;
+	kgid_t gid;
 #endif
 	unsigned int i;
 	int ret = -EINVAL;
@@ -372,6 +374,13 @@ static int recent_mt_check(const struct xt_mtchk_param *par,
 	for (i = 0; i < ip_list_hash_size; i++)
 		INIT_LIST_HEAD(&t->iphash[i]);
 #ifdef CONFIG_PROC_FS
+	uid = make_kuid(&init_user_ns, ip_list_uid);
+	gid = make_kgid(&init_user_ns, ip_list_gid);
+	if (!uid_valid(uid) || !gid_valid(gid)) {
+		kfree(t);
+		ret = -EINVAL;
+		goto out;
+	}
 	pde = proc_create_data(t->name, ip_list_perms, recent_net->xt_recent,
 		  &recent_mt_fops, t);
 	if (pde == NULL) {
@@ -379,8 +388,8 @@ static int recent_mt_check(const struct xt_mtchk_param *par,
 		ret = -ENOMEM;
 		goto out;
 	}
-	pde->uid = ip_list_uid;
-	pde->gid = ip_list_gid;
+	pde->uid = uid;
+	pde->gid = gid;
 #endif
 	spin_lock_bh(&recent_lock);
 	list_add_tail(&t->list, &recent_net->tables);
-- 
1.7.5.4

