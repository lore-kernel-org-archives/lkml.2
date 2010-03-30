Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249Ab0C3XoS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:44:18 -0400
Received: from kroah.org ([198.145.64.141]:46135 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932554Ab0C3XUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:20:14 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:48:02 2010
Message-Id: <20100330224802.134379890@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:41:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [064/156] nfsd: ensure sockets are closed on error
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

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


