Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab2HMUYh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:24:37 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:56770 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654Ab2HMUY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:24:28 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <netdev@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <containers@lists.linux-foundation.org>,
        David Miller <davem@davemloft.net>, Serge Hallyn <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>
Date: Mon, 13 Aug 2012 13:18:31 -0700
Message-Id: <1344889115-21610-17-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1344889115-21610-1-git-send-email-ebiederm@xmission.com>
References: <87ehnav9n5.fsf@xmission.com>
 <1344889115-21610-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19Eb30zOnKgmtDPOUbRBpcT/37Hwy7sunE=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3163]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<netdev@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 17/21] userns: Convert xt_LOG to print socket kuids and kgids as uids and gids
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

xt_LOG always writes messages via sb_add via printk.  Therefore when
xt_LOG logs the uid and gid of a socket a packet came from the
values should be converted to be in the initial user namespace.

Thus making xt_LOG as user namespace safe as possible.

Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Patrick McHardy <kaber@trash.net>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 init/Kconfig           |    1 -
 net/netfilter/xt_LOG.c |   16 ++++++++++------
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index b44c3a3..c8911eb 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -945,7 +945,6 @@ config UIDGID_CONVERTED
 	depends on NET_9P = n
 	depends on NETFILTER_XT_MATCH_OWNER = n
 	depends on NETFILTER_XT_MATCH_RECENT = n
-	depends on NETFILTER_XT_TARGET_LOG = n
 	depends on AF_RXRPC = n
 	depends on NET_KEY = n
 	depends on DNS_RESOLVER = n
diff --git a/net/netfilter/xt_LOG.c b/net/netfilter/xt_LOG.c
index ff5f75f..02a2bf4 100644
--- a/net/netfilter/xt_LOG.c
+++ b/net/netfilter/xt_LOG.c
@@ -363,10 +363,12 @@ static void dump_ipv4_packet(struct sbuff *m,
 	/* Max length: 15 "UID=4294967295 " */
 	if ((logflags & XT_LOG_UID) && !iphoff && skb->sk) {
 		read_lock_bh(&skb->sk->sk_callback_lock);
-		if (skb->sk->sk_socket && skb->sk->sk_socket->file)
+		if (skb->sk->sk_socket && skb->sk->sk_socket->file) {
+			const struct cred *cred = skb->sk->sk_socket->file->f_cred;
 			sb_add(m, "UID=%u GID=%u ",
-				skb->sk->sk_socket->file->f_cred->fsuid,
-				skb->sk->sk_socket->file->f_cred->fsgid);
+				from_kuid_munged(&init_user_ns, cred->fsuid),
+				from_kgid_munged(&init_user_ns, cred->fsgid));
+		}
 		read_unlock_bh(&skb->sk->sk_callback_lock);
 	}
 
@@ -719,10 +721,12 @@ static void dump_ipv6_packet(struct sbuff *m,
 	/* Max length: 15 "UID=4294967295 " */
 	if ((logflags & XT_LOG_UID) && recurse && skb->sk) {
 		read_lock_bh(&skb->sk->sk_callback_lock);
-		if (skb->sk->sk_socket && skb->sk->sk_socket->file)
+		if (skb->sk->sk_socket && skb->sk->sk_socket->file) {
+			const struct cred *cred = skb->sk->sk_socket->file->f_cred;
 			sb_add(m, "UID=%u GID=%u ",
-				skb->sk->sk_socket->file->f_cred->fsuid,
-				skb->sk->sk_socket->file->f_cred->fsgid);
+				from_kuid_munged(&init_user_ns, cred->fsuid),
+				from_kgid_munged(&init_user_ns, cred->fsgid));
+		}
 		read_unlock_bh(&skb->sk->sk_callback_lock);
 	}
 
-- 
1.7.5.4

