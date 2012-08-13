Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab2HMUY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:24:27 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:56690 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654Ab2HMUYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:24:18 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <netdev@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <containers@lists.linux-foundation.org>,
        David Miller <davem@davemloft.net>, Serge Hallyn <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Patrick McHardy <kaber@trash.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>, Changli Gao <xiaosuo@gmail.com>
Date: Mon, 13 Aug 2012 13:18:30 -0700
Message-Id: <1344889115-21610-16-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1344889115-21610-1-git-send-email-ebiederm@xmission.com>
References: <87ehnav9n5.fsf@xmission.com>
 <1344889115-21610-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18FBa23ya3on1OTzz8rVQ0CwKhWvsKuVU8=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4999]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_00 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;<netdev@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 16/21] userns: Convert cls_flow to work with user namespaces enabled
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

The flow classifier can use uids and gids of the sockets that
are transmitting packets and do insert those uids and gids
into the packet classification calcuation.  I don't fully
understand the details but it appears that we can depend
on specific uids and gids when making traffic classification
decisions.

To work with user namespaces enabled map from kuids and kgids
into uids and gids in the initial user namespace giving raw
integer values the code can play with and depend on.

To avoid issues of userspace depending on uids and gids in
packet classifiers installed from other user namespaces
and getting confused deny all packet classifiers that
use uids or gids that are not comming from a netlink socket
in the initial user namespace.

Cc: Patrick McHardy <kaber@trash.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Changli Gao <xiaosuo@gmail.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 init/Kconfig         |    1 -
 net/sched/cls_flow.c |   16 ++++++++++++----
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 2660b31..b44c3a3 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -943,7 +943,6 @@ config UIDGID_CONVERTED
 
 	# Networking
 	depends on NET_9P = n
-	depends on NET_CLS_FLOW = n
 	depends on NETFILTER_XT_MATCH_OWNER = n
 	depends on NETFILTER_XT_MATCH_RECENT = n
 	depends on NETFILTER_XT_TARGET_LOG = n
diff --git a/net/sched/cls_flow.c b/net/sched/cls_flow.c
index ae854f3..ce82d0c 100644
--- a/net/sched/cls_flow.c
+++ b/net/sched/cls_flow.c
@@ -193,15 +193,19 @@ static u32 flow_get_rtclassid(const struct sk_buff *skb)
 
 static u32 flow_get_skuid(const struct sk_buff *skb)
 {
-	if (skb->sk && skb->sk->sk_socket && skb->sk->sk_socket->file)
-		return skb->sk->sk_socket->file->f_cred->fsuid;
+	if (skb->sk && skb->sk->sk_socket && skb->sk->sk_socket->file) {
+		kuid_t skuid = skb->sk->sk_socket->file->f_cred->fsuid;
+		return from_kuid(&init_user_ns, skuid);
+	}
 	return 0;
 }
 
 static u32 flow_get_skgid(const struct sk_buff *skb)
 {
-	if (skb->sk && skb->sk->sk_socket && skb->sk->sk_socket->file)
-		return skb->sk->sk_socket->file->f_cred->fsgid;
+	if (skb->sk && skb->sk->sk_socket && skb->sk->sk_socket->file) {
+		kgid_t skgid = skb->sk->sk_socket->file->f_cred->fsgid;
+		return from_kgid(&init_user_ns, skgid);
+	}
 	return 0;
 }
 
@@ -387,6 +391,10 @@ static int flow_change(struct sk_buff *in_skb,
 
 		if (fls(keymask) - 1 > FLOW_KEY_MAX)
 			return -EOPNOTSUPP;
+
+		if ((keymask & (FLOW_KEY_SKUID|FLOW_KEY_SKGID)) &&
+		    sk_user_ns(NETLINK_CB(in_skb).ssk) != &init_user_ns)
+			return -EOPNOTSUPP;
 	}
 
 	err = tcf_exts_validate(tp, tb, tca[TCA_RATE], &e, &flow_ext_map);
-- 
1.7.5.4

