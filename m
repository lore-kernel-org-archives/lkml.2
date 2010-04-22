Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256Ab0DVTf0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:35:26 -0400
Received: from kroah.org ([198.145.64.141]:41528 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756884Ab0DVT3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:29:51 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:23 2010
Message-Id: <20100422190923.158036324@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:10:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: [176/197] nfsd: ensure sockets are closed on error
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Neil Brown <neilb@suse.de>

commit 301e99ce4a2f42a317129230fd42e6cd874c64b0 upstream.

One the changes in commit d7979ae4a "svc: Move close processing to a
single place" is:

  err_delete:
-       svc_delete_socket(svsk);
+       set_bit(SK_CLOSE, &svsk->sk_flags);
        return -EAGAIN;

This is insufficient. The recvfrom methods must always call
svc_xprt_received on completion so that the socket gets re-queued if
there is any more work to do.  This particular path did not make that
call because it actually destroyed the svsk, making requeue pointless.
When the svc_delete_socket was change to just set a bit, we should have
added a call to svc_xprt_received,

This is the problem that b0401d7253 attempted to fix, incorrectly.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sunrpc/svcsock.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -968,6 +968,7 @@ static int svc_tcp_recv_record(struct sv
 	return len;
  err_delete:
 	set_bit(XPT_CLOSE, &svsk->sk_xprt.xpt_flags);
+	svc_xprt_received(&svsk->sk_xprt);
  err_again:
 	return -EAGAIN;
 }


