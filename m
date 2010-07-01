Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932228Ab0GASYv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:24:51 -0400
Received: from kroah.org ([198.145.64.141]:40909 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932129Ab0GASYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:24:39 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:32:19 2010
Message-Id: <20100701173219.463415889@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:32:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Wei Yongjun <yjwei@cn.fujitsu.com>,
       Vlad Yasevich <vladislav.yasevich@hp.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 149/149] sctp: fix append error cause to ERROR chunk correctly
In-Reply-To: <20100701175144.GA2116@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sctp/sm_make_chunk.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -140,7 +140,7 @@ int sctp_init_cause_fixed(struct sctp_ch
 	len = sizeof(sctp_errhdr_t) + paylen;
 	err.length  = htons(len);
 
-	if (skb_tailroom(chunk->skb) >  len)
+	if (skb_tailroom(chunk->skb) < len)
 		return -ENOSPC;
 	chunk->subh.err_hdr = sctp_addto_chunk_fixed(chunk,
 						     sizeof(sctp_errhdr_t),
@@ -1412,7 +1412,7 @@ void *sctp_addto_chunk(struct sctp_chunk
 void *sctp_addto_chunk_fixed(struct sctp_chunk *chunk,
 			     int len, const void *data)
 {
-	if (skb_tailroom(chunk->skb) > len)
+	if (skb_tailroom(chunk->skb) >= len)
 		return sctp_addto_chunk(chunk, len, data);
 	else
 		return NULL;


