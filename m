Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750843Ab1ABHVP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:21:15 -0500
Received: from mail.windriver.com ([147.11.1.11]:33794 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab1ABHVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:21:11 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Wei Yongjun <yjwei@cn.fujitsu.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 001/260] sctp: fix append error cause to ERROR chunk correctly
Date: Sun,  2 Jan 2011 02:14:57 -0500
Message-Id: <1293952756-15010-2-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:20:02.0100 (UTC) FILETIME=[787F3F40:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yjwei@cn.fujitsu.com>

commit 2e3219b5c8a2e44e0b83ae6e04f52f20a82ac0f2 upstream.

commit 5fa782c2f5ef6c2e4f04d3e228412c9b4a4c8809
  sctp: Fix skb_over_panic resulting from multiple invalid \
    parameter errors (CVE-2010-1173) (v4)

cause 'error cause' never be add the the ERROR chunk due to
some typo when check valid length in sctp_init_cause_fixed().

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Reviewed-by: Neil Horman <nhorman@tuxdriver.com>
Acked-by: Vlad Yasevich <vladislav.yasevich@hp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/sctp/sm_make_chunk.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 30c1767..70d6c10 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -141,7 +141,7 @@ int sctp_init_cause_fixed(struct sctp_chunk *chunk, __be16 cause_code,
 	len = sizeof(sctp_errhdr_t) + paylen;
 	err.length  = htons(len);
 
-	if (skb_tailroom(chunk->skb) >  len)
+	if (skb_tailroom(chunk->skb) < len)
 		return -ENOSPC;
 	chunk->subh.err_hdr = sctp_addto_chunk_fixed(chunk,
 						     sizeof(sctp_errhdr_t),
@@ -1421,7 +1421,7 @@ void *sctp_addto_chunk(struct sctp_chunk *chunk, int len, const void *data)
 void *sctp_addto_chunk_fixed(struct sctp_chunk *chunk,
 			     int len, const void *data)
 {
-	if (skb_tailroom(chunk->skb) > len)
+	if (skb_tailroom(chunk->skb) >= len)
 		return sctp_addto_chunk(chunk, len, data);
 	else
 		return NULL;
-- 
1.7.3.3

