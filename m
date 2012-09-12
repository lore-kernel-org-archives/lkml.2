Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933119Ab2ILXve (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:51:34 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49817 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933384Ab2ILXoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:44:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 20/46] svcrpc: fix BUG() in svc_tcp_clear_pages
Date: Wed, 12 Sep 2012 16:39:10 -0700
Message-Id: <20120912233819.777174328@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912233817.662663809@linuxfoundation.org>
References: <20120912233817.662663809@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/svcsock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -1122,9 +1122,9 @@ static int svc_tcp_recvfrom(struct svc_r
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


