Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab2KFWUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 17:20:33 -0500
Received: from [93.179.225.50] ([93.179.225.50]:39260 "EHLO shrek.podlesie.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753295Ab2KFWUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 17:20:30 -0500
From: Krzysztof Mazur <krzysiek@podlesie.net>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Chas Williams - CONTRACTOR <chas@cmf.nrl.navy.mil>,
        David Woodhouse <David.Woodhouse@intel.com>, davem@davemloft.net,
        Krzysztof Mazur <krzysiek@podlesie.net>
Subject: [PATCH v3 6/7] pppoatm: don't send frames on not-ready vcc
Date: Tue,  6 Nov 2012 23:17:01 +0100
Message-Id: <1352240222-363-7-git-send-email-krzysiek@podlesie.net>
X-Mailer: git-send-email 1.8.0.233.g54991f2
In-Reply-To: <1352240222-363-1-git-send-email-krzysiek@podlesie.net>
References: <1352240222-363-1-git-send-email-krzysiek@podlesie.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patches "atm: detach protocol before closing vcc"
and "pppoatm: allow assign only on a connected socket" fixed
common cases where the pppoatm_send() crashes while sending
frame to not-ready vcc. However there are still some other cases
where we can send frames to vcc, which is flagged as ATM_VF_CLOSE
(for instance after vcc_release_async()) or it's opened but not
ready yet.

Now pppoatm_send(), like vcc_sendmsg(), checks for vcc flags that
indicate that vcc is not ready.

Signed-off-by: Krzysztof Mazur <krzysiek@podlesie.net>
Cc: David Woodhouse <David.Woodhouse@intel.com>
---
 net/atm/pppoatm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/atm/pppoatm.c b/net/atm/pppoatm.c
index c4a57bc..bf5d6c9 100644
--- a/net/atm/pppoatm.c
+++ b/net/atm/pppoatm.c
@@ -284,6 +284,10 @@ static int pppoatm_send(struct ppp_channel *chan, struct sk_buff *skb)
 	bh_lock_sock(sk_atm(vcc));
 	if (sock_owned_by_user(sk_atm(vcc)))
 		goto nospace;
+	if (test_bit(ATM_VF_RELEASED, &vcc->flags)
+			|| test_bit(ATM_VF_CLOSE, &vcc->flags)
+			|| !test_bit(ATM_VF_READY, &vcc->flags))
+		goto nospace;
 
 	switch (pvcc->encaps) {		/* LLC encapsulation needed */
 	case e_llc:
-- 
1.8.0.233.g54991f2

