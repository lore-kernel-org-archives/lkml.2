Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759523Ab1KWBzg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 20:55:36 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59350 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659Ab1KWBze convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 20:55:34 -0500
From: Xi Wang <xi.wang@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] sctp: integer overflow in sctp_auth_create_key()
Date: Tue, 22 Nov 2011 20:55:30 -0500
Message-Id: <028246D6-9024-4E43-93A1-25A87878CBBC@gmail.com>
Cc: Vlad Yasevich <vladislav.yasevich@hp.com>,
        Sridhar Samudrala <sri@us.ibm.com>,
        "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, security@kernel.org
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1084)
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous commit 30c2235c is incomplete and cannot prevent integer
overflows. For example, when key_len is 0x80000000 (INT_MAX + 1), the
left-hand side of the check, (INT_MAX - key_len), which is unsigned,
becomes 0xffffffff (UINT_MAX) and bypasses the check.

Signed-off-by: Xi Wang <xi.wang@gmail.com>
---
net/sctp/auth.c |    2 +-
1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/sctp/auth.c b/net/sctp/auth.c
index 865e68f..989e0fd 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -82,7 +82,7 @@ static struct sctp_auth_bytes *sctp_auth_create_key(__u32 key_len, gfp_t gfp)
	struct sctp_auth_bytes *key;

	/* Verify that we are not going to overflow INT_MAX */
-	if ((INT_MAX - key_len) < sizeof(struct sctp_auth_bytes))
+	if (key_len > INT_MAX - sizeof(struct sctp_auth_bytes))
		return NULL;

	/* Allocate the shared key */
-- 
1.7.5.4

