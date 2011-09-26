Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab1IZVnm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 17:43:42 -0400
Received: from nm26.access.bullet.mail.mud.yahoo.com ([66.94.237.91]:46897
	"HELO nm26.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752517Ab1IZVnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 17:43:41 -0400
X-Yahoo-Newman-Id: 618020.27316.bm@smtp101.biz.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 11EFkRkVM1n32zVLNWKmVEvR.3Km4mv7q0iz99P8uDnwtUN
 XehKFJLaF4JtxSqdoRVWRIDkv2lMFrFNqKwex78ihfHMdaR80LU8qxuWNHfP
 0Ox4ZeYv4uD_PezRP0NnRZus7W7bp33qVwyPUm9pAG_CxLLP1K5j3oSyIkQ3
 VgFAwt4OwjNJN0RpWplKXOKDy3f9zmgDAtxIfMud7zfCthrbD7yYB3AFS3e1
 ZXqqIItudpUPtH65zPIJOkDoL8ve5pAr_hsaYe5MY3MLHUROwT_8i.a_bmHf
 61hEkQYriUbwVbWkKGrL_gKvQKwiQ2G_Wi7.SIZaXrYos3zf5Wv_Dbaam0EQ
 8bWIxSMHvjf8mpi4yjWf3Ynr5mkFeZKhWKhh9yMYPH0GDususi03n_KBaF0I
 mC1y7t1G5jmvRzZFw45KS.xpMBapzwtj_GgR.RBI-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <4E80F20B.9050608@schaufler-ca.com>
Date: Mon, 26 Sep 2011 14:43:39 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: LKLM <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH] Smack: Provide information for UDS getsockopt(SO_PEERCRED)
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



This patch is targeted for the smack-next tree.

This patch takes advantage of the recent changes for performance
and points the packet labels on UDS connect at the output label of
the far side. This makes getsockopt(...SO_PEERCRED...) function
properly. Without this change the getsockopt does not provide any
information.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
---

 security/smack/smack_lsm.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 2e71c3f..7d29351 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -2767,6 +2767,7 @@ static int smack_unix_stream_connect(struct sock *sock,
 {
 	struct socket_smack *ssp = sock->sk_security;
 	struct socket_smack *osp = other->sk_security;
+	struct socket_smack *nsp = newsk->sk_security;
 	struct smk_audit_info ad;
 	int rc = 0;
 
@@ -2776,6 +2777,14 @@ static int smack_unix_stream_connect(struct sock *sock,
 	if (!capable(CAP_MAC_OVERRIDE))
 		rc = smk_access(ssp->smk_out, osp->smk_in, MAY_WRITE, &ad);
 
+	/*
+	 * Cross reference the peer labels for SO_PEERSEC.
+	 */
+	if (rc == 0) {
+		nsp->smk_packet = ssp->smk_out;
+		ssp->smk_packet = osp->smk_out;
+	}
+
 	return rc;
 }
 

