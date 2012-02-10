Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760368Ab2BJWwK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:52:10 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53942 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933021Ab2BJWu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:50:27 -0500
MIME-Version: 1.0
Message-Id: <20120210224851.528862878@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:47:47 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Bian Naimeng <biannm@cn.fujitsu.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Chuck Lever <chuck.lever@oracle.com>
Subject: [08/21] rpc client can not deal with ENOSOCK, so translate it into ENOCONN
In-Reply-To: <20120210224858.GA30752@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Bian Naimeng <biannm@cn.fujitsu.com>

commit 5fe46e9d733f19a880ef7e516002bd4c2b833e14 upstream.

If NFSv4 client send a request before connect, or the old connection was broken
because a ETIMEOUT error catched by call_status, ->send_request will return
ENOSOCK, but rpc layer can not deal with it, so make sure ->send_request can
translate ENOSOCK into ENOCONN.

Signed-off-by: Bian Naimeng <biannm@cn.fujitsu.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/xprtsock.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -563,8 +563,6 @@ static int xs_udp_send_request(struct rp
 		/* Still some bytes left; set up for a retry later. */
 		status = -EAGAIN;
 	}
-	if (!transport->sock)
-		goto out;
 
 	switch (status) {
 	case -ENOTSOCK:
@@ -584,7 +582,7 @@ static int xs_udp_send_request(struct rp
 		 * prompts ECONNREFUSED. */
 		clear_bit(SOCK_ASYNC_NOSPACE, &transport->sock->flags);
 	}
-out:
+
 	return status;
 }
 
@@ -666,8 +664,6 @@ static int xs_tcp_send_request(struct rp
 		status = -EAGAIN;
 		break;
 	}
-	if (!transport->sock)
-		goto out;
 
 	switch (status) {
 	case -ENOTSOCK:
@@ -687,7 +683,7 @@ static int xs_tcp_send_request(struct rp
 	case -ENOTCONN:
 		clear_bit(SOCK_ASYNC_NOSPACE, &transport->sock->flags);
 	}
-out:
+
 	return status;
 }
 


