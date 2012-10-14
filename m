Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045Ab2JNPNt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 11:13:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46167 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754285Ab2JNOmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:42:06 -0400
Message-Id: <20121014143552.299243513@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:37:50 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Rafal Fitt <rafalf@aplusc.com.pl>
Subject: [ 137/147] netfilter: nf_nat_sip: fix incorrect handling of EBUSY  for RTCP expectation
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/netfilter/nf_nat_sip.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/nf_nat_sip.c b/net/ipv4/netfilter/nf_nat_sip.c
index 4ad9cf1..9c87cde 100644
--- a/net/ipv4/netfilter/nf_nat_sip.c
+++ b/net/ipv4/netfilter/nf_nat_sip.c
@@ -502,7 +502,10 @@ static unsigned int ip_nat_sdp_media(struct sk_buff *skb, unsigned int dataoff,
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


