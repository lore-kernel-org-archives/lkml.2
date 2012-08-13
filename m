Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab2HMUc2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:32:28 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:56711 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671Ab2HMUYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:24:20 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <netdev@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <containers@lists.linux-foundation.org>,
        David Miller <davem@davemloft.net>, Serge Hallyn <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Mon, 13 Aug 2012 13:18:25 -0700
Message-Id: <1344889115-21610-11-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1344889115-21610-1-git-send-email-ebiederm@xmission.com>
References: <87ehnav9n5.fsf@xmission.com>
 <1344889115-21610-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19v5gCtHmEVfMrw8h2c+bcyJY3bnNhK+80=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4945]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;<netdev@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 11/21] netlink: Make the sending netlink socket availabe in NETLINK_CB
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

The sending socket of an skb is already available by it's port id
in the NETLINK_CB.  If you want to know more like to examine the
credentials on the sending socket you have to look up the sending
socket by it's port id and all of the needed functions and data
structures are static inside of af_netlink.c.  So do the simple
thing and pass the sending socket to the receivers in the NETLINK_CB.

I intend to use this to get the user namespace of the sending socket
in inet_diag so that I can report uids in the context of the process
who opened the socket, the same way I report uids in the contect
of the process who opens files.

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 include/linux/netlink.h  |    1 +
 net/netlink/af_netlink.c |    6 ++++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index f74dd13..c9fdde2 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -165,6 +165,7 @@ struct netlink_skb_parms {
 	struct ucred		creds;		/* Skb credentials	*/
 	__u32			pid;
 	__u32			dst_group;
+	struct sock		*ssk;
 };
 
 #define NETLINK_CB(skb)		(*(struct netlink_skb_parms*)&((skb)->cb))
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 5463969..7cb7867 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -912,7 +912,8 @@ static void netlink_rcv_wake(struct sock *sk)
 		wake_up_interruptible(&nlk->wait);
 }
 
-static int netlink_unicast_kernel(struct sock *sk, struct sk_buff *skb)
+static int netlink_unicast_kernel(struct sock *sk, struct sk_buff *skb,
+				  struct sock *ssk)
 {
 	int ret;
 	struct netlink_sock *nlk = nlk_sk(sk);
@@ -921,6 +922,7 @@ static int netlink_unicast_kernel(struct sock *sk, struct sk_buff *skb)
 	if (nlk->netlink_rcv != NULL) {
 		ret = skb->len;
 		skb_set_owner_r(skb, sk);
+		NETLINK_CB(skb).ssk = ssk;
 		nlk->netlink_rcv(skb);
 		consume_skb(skb);
 	} else {
@@ -947,7 +949,7 @@ retry:
 		return PTR_ERR(sk);
 	}
 	if (netlink_is_kernel(sk))
-		return netlink_unicast_kernel(sk, skb);
+		return netlink_unicast_kernel(sk, skb, ssk);
 
 	if (sk_filter(sk, skb)) {
 		err = skb->len;
-- 
1.7.5.4

