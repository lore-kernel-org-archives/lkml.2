Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814Ab2KZRA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:00:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47029 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074Ab2KZRAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:00:24 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 011/270] netfilter: nf_nat_sip: fix incorrect handling of EBUSY for RTCP expectation
Date: Mon, 26 Nov 2012 14:55:01 -0200
Message-Id: <1353949160-26803-12-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 3f509c689a07a4aa989b426893d8491a7ffcc410 upstream.

We're hitting bug while trying to reinsert an already existing
expectation:

kernel BUG at kernel/timer.c:895!
invalid opcode: 0000 [#1] SMP
[...]
Call Trace:
 <IRQ>
 [<ffffffffa0069563>] nf_ct_expect_related_report+0x4a0/0x57a [nf_conntrack]
 [<ffffffff812d423a>] ? in4_pton+0x72/0x131
 [<ffffffffa00ca69e>] ip_nat_sdp_media+0xeb/0x185 [nf_nat_sip]
 [<ffffffffa00b5b9b>] set_expected_rtp_rtcp+0x32d/0x39b [nf_conntrack_sip]
 [<ffffffffa00b5f15>] process_sdp+0x30c/0x3ec [nf_conntrack_sip]
 [<ffffffff8103f1eb>] ? irq_exit+0x9a/0x9c
 [<ffffffffa00ca738>] ? ip_nat_sdp_media+0x185/0x185 [nf_nat_sip]

We have to remove the RTP expectation if the RTCP expectation hits EBUSY
since we keep trying with other ports until we succeed.

Reported-by: Rafal Fitt <rafalf@aplusc.com.pl>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ipv4/netfilter/nf_nat_sip.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/nf_nat_sip.c b/net/ipv4/netfilter/nf_nat_sip.c
index ea4a238..bb71caa 100644
--- a/net/ipv4/netfilter/nf_nat_sip.c
+++ b/net/ipv4/netfilter/nf_nat_sip.c
@@ -501,7 +501,10 @@ static unsigned int ip_nat_sdp_media(struct sk_buff *skb, unsigned int dataoff,
 		ret = nf_ct_expect_related(rtcp_exp);
 		if (ret == 0)
 			break;
-		else if (ret != -EBUSY) {
+		else if (ret == -EBUSY) {
+			nf_ct_unexpect_related(rtp_exp);
+			continue;
+		} else if (ret < 0) {
 			nf_ct_unexpect_related(rtp_exp);
 			port = 0;
 			break;
-- 
1.7.9.5

