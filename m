Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab1HNQ24 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:28:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36323 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753779Ab1HNQG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:06:26 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:53 2011
Message-Id: <20110812210553.429837808@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:04:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Anton Blanchard <anton@samba.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [15/90] net: sendmmsg should only return an error if no messages were sent
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Anton Blanchard <anton@samba.org>

commit 728ffb86f10873aaf4abd26dde691ee40ae731fe upstream.

sendmmsg uses a similar error return strategy as recvmmsg but it
turns out to be a confusing way to communicate errors.

The current code stores the error code away and returns it on the next
sendmmsg call. This means a call with completely valid arguments could
get an error from a previous call.

Change things so we only return an error if no datagrams could be sent.
If less than the requested number of messages were sent, the application
must retry starting at the first failed one and if the problem is
persistent the error will be returned.

This matches the behaviour of other syscalls like read/write - it
is not an error if less than the requested number of elements are sent.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/socket.c |   27 +++------------------------
 1 file changed, 3 insertions(+), 24 deletions(-)

--- a/net/socket.c
+++ b/net/socket.c
@@ -2005,12 +2005,9 @@ int __sys_sendmmsg(int fd, struct mmsghd
 	if (!sock)
 		return err;
 
-	err = sock_error(sock->sk);
-	if (err)
-		goto out_put;
-
 	entry = mmsg;
 	compat_entry = (struct compat_mmsghdr __user *)mmsg;
+	err = 0;
 
 	while (datagrams < vlen) {
 		/*
@@ -2037,29 +2034,11 @@ int __sys_sendmmsg(int fd, struct mmsghd
 		++datagrams;
 	}
 
-out_put:
 	fput_light(sock->file, fput_needed);
 
-	if (err == 0)
-		return datagrams;
-
-	if (datagrams != 0) {
-		/*
-		 * We may send less entries than requested (vlen) if the
-		 * sock is non blocking...
-		 */
-		if (err != -EAGAIN) {
-			/*
-			 * ... or if sendmsg returns an error after we
-			 * send some datagrams, where we record the
-			 * error to return on the next call or if the
-			 * app asks about it using getsockopt(SO_ERROR).
-			 */
-			sock->sk->sk_err = -err;
-		}
-
+	/* We only return an error if no datagrams were able to be sent */
+	if (datagrams != 0)
 		return datagrams;
-	}
 
 	return err;
 }


