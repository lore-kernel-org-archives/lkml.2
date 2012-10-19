Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461Ab2JSCrt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 22:47:49 -0400
Received: from mail.kernel.org ([198.145.19.201]:51527 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757402Ab2JSCrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:47:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Rafal Fitt <rafalf@aplusc.com.pl>, David Miller <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ 39/62] netfilter: nf_nat_sip: fix incorrect handling of EBUSY for RTCP expectation
Date: Thu, 18 Oct 2012 19:45:07 -0700
Message-Id: <20121019024302.283447688@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024255.944999470@linuxfoundation.org>
References: <20121019024255.944999470@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Acked-by: David Miller <davem@davemloft.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv4/netfilter/nf_nat_sip.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/ipv4/netfilter/nf_nat_sip.c
+++ b/net/ipv4/netfilter/nf_nat_sip.c
@@ -501,7 +501,10 @@ static unsigned int ip_nat_sdp_media(str
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


