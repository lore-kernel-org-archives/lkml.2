Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab2HGR1O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 13:27:14 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:33892 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab2HGR1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 13:27:11 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Miller <davem@davemloft.net>
Cc: Vlad Yasevich <vyasevich@gmail.com>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jan Ariyasu <jan.ariyasu@hp.com>, Jan Ariyasu <jan.ariyasu@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, Thomas Graf <tgraf@infradead.org>,
        Xi Wang <xi.wang@gmail.com>
References: <1344115837-6150-1-git-send-email-jan.ariyasu@hp.com>
	<87mx27rig7.fsf@xmission.com> <87zk67q31q.fsf_-_@xmission.com>
	<87ipcud3ld.fsf_-_@xmission.com>
Date: Tue, 07 Aug 2012 10:27:02 -0700
In-Reply-To: <87ipcud3ld.fsf_-_@xmission.com> (Eric W. Biederman's message of
	"Tue, 07 Aug 2012 10:17:02 -0700")
Message-ID: <87sjbybok9.fsf_-_@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19uQ/a3w3msVF42+NsrhuHrqa+xS0+NC8s=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0041]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;David Miller <davem@davemloft.net>
X-Spam-Relay-Country: 
Subject: [PATCH net-next 4/7] sctp: Push struct net down into sctp_in_scope
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


struct net will be needed shortly when the tunables are made per network
namespace.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 include/net/sctp/structs.h |    2 +-
 net/sctp/bind_addr.c       |    4 ++--
 net/sctp/protocol.c        |    2 +-
 net/sctp/sm_make_chunk.c   |    3 ++-
 4 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 88d2179..b0882f3 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1248,7 +1248,7 @@ int sctp_raw_to_bind_addrs(struct sctp_bind_addr *bp, __u8 *raw, int len,
 			   __u16 port, gfp_t gfp);
 
 sctp_scope_t sctp_scope(const union sctp_addr *);
-int sctp_in_scope(const union sctp_addr *addr, const sctp_scope_t scope);
+int sctp_in_scope(struct net *net, const union sctp_addr *addr, const sctp_scope_t scope);
 int sctp_is_any(struct sock *sk, const union sctp_addr *addr);
 int sctp_addr_is_valid(const union sctp_addr *addr);
 int sctp_is_ep_boundall(struct sock *sk);
diff --git a/net/sctp/bind_addr.c b/net/sctp/bind_addr.c
index a85ce4b..23389ba 100644
--- a/net/sctp/bind_addr.c
+++ b/net/sctp/bind_addr.c
@@ -457,7 +457,7 @@ static int sctp_copy_one_addr(struct net *net, struct sctp_bind_addr *dest,
 
 	if (sctp_is_any(NULL, addr)) {
 		error = sctp_copy_local_addr_list(net, dest, scope, gfp, flags);
-	} else if (sctp_in_scope(addr, scope)) {
+	} else if (sctp_in_scope(net, addr, scope)) {
 		/* Now that the address is in scope, check to see if
 		 * the address type is supported by local sock as
 		 * well as the remote peer.
@@ -494,7 +494,7 @@ int sctp_is_any(struct sock *sk, const union sctp_addr *addr)
 }
 
 /* Is 'addr' valid for 'scope'?  */
-int sctp_in_scope(const union sctp_addr *addr, sctp_scope_t scope)
+int sctp_in_scope(struct net *net, const union sctp_addr *addr, sctp_scope_t scope)
 {
 	sctp_scope_t addr_scope = sctp_scope(addr);
 
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index de25d9c..85f87c3 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -210,7 +210,7 @@ int sctp_copy_local_addr_list(struct net *net, struct sctp_bind_addr *bp,
 	list_for_each_entry_rcu(addr, &net->sctp.local_addr_list, list) {
 		if (!addr->valid)
 			continue;
-		if (sctp_in_scope(&addr->a, scope)) {
+		if (sctp_in_scope(net, &addr->a, scope)) {
 			/* Now that the address is in scope, check to see if
 			 * the address type is really supported by the local
 			 * sock as well as the remote peer.
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 479a70e..fb12835 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -2466,6 +2466,7 @@ static int sctp_process_param(struct sctp_association *asoc,
 			      const union sctp_addr *peer_addr,
 			      gfp_t gfp)
 {
+	struct net *net = sock_net(asoc->base.sk);
 	union sctp_addr addr;
 	int i;
 	__u16 sat;
@@ -2494,7 +2495,7 @@ do_addr_param:
 		af = sctp_get_af_specific(param_type2af(param.p->type));
 		af->from_addr_param(&addr, param.addr, htons(asoc->peer.port), 0);
 		scope = sctp_scope(peer_addr);
-		if (sctp_in_scope(&addr, scope))
+		if (sctp_in_scope(net, &addr, scope))
 			if (!sctp_assoc_add_peer(asoc, &addr, gfp, SCTP_UNCONFIRMED))
 				return 0;
 		break;
-- 
1.7.5.4

