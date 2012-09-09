Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab2IIXaY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:30:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51271 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756025Ab2IIXQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:16:30 -0400
Message-Id: <20120909224159.746258188@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:42:56 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 66/95] svcrpc: fix BUG() in svc_tcp_clear_pages
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit be1e44441a560c43c136a562d49a1c9623c91197 upstream.

Examination of svc_tcp_clear_pages shows that it assumes sk_tcplen is
consistent with sk_pages[] (in particular, sk_pages[n] can't be NULL if
sk_tcplen would lead us to expect n pages of data).

svc_tcp_restore_pages zeroes out sk_pages[] while leaving sk_tcplen.
This is OK, since both functions are serialized by XPT_BUSY.  However,
that means the inconsistency must be repaired before dropping XPT_BUSY.

Therefore we should be ensuring that svc_tcp_save_pages repairs the
problem before exiting svc_tcp_recv_record on error.

Symptoms were a BUG() in svc_tcp_clear_pages.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sunrpc/svcsock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 18bc130..998aa8c 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -1129,9 +1129,9 @@ static int svc_tcp_recvfrom(struct svc_rqst *rqstp)
 	if (len >= 0)
 		svsk->sk_tcplen += len;
 	if (len != want) {
+		svc_tcp_save_pages(svsk, rqstp);
 		if (len < 0 && len != -EAGAIN)
 			goto err_other;
-		svc_tcp_save_pages(svsk, rqstp);
 		dprintk("svc: incomplete TCP record (%d of %d)\n",
 			svsk->sk_tcplen, svsk->sk_reclen);
 		goto err_noclose;


