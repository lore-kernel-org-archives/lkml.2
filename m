Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab1FPHBa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:01:30 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:35480 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755404Ab1FPHBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:01:23 -0400
X-Sasl-enc: CkQMBCNYiWhjzH8en08VweTDXfKKbl8NcQu/BOit3XLr 1308207682
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:35 2011
Message-Id: <20110616000235.364384744@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:00:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>
Subject: [65/89] cifs: dont allow cifs_reconnect to exit with NULL socket
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
 pointer

From: Jeff Layton <jlayton@redhat.com>

commit 7fdbaa1b8daa1009b705985b903e3d2ebccad456 upstream.

It's possible for the following set of events to happen:

cifsd calls cifs_reconnect which reconnects the socket. A userspace
process then calls cifs_negotiate_protocol to handle the NEGOTIATE and
gets a reply. But, while processing the reply, cifsd calls
cifs_reconnect again.  Eventually the GlobalMid_Lock is dropped and the
reply from the earlier NEGOTIATE completes and the tcpStatus is set to
CifsGood. cifs_reconnect then goes through and closes the socket and sets the
pointer to zero, but because the status is now CifsGood, the new socket
is not created and cifs_reconnect exits with the socket pointer set to
NULL.

Fix this by only setting the tcpStatus to CifsGood if the tcpStatus is
CifsNeedNegotiate, and by making sure that generic_ip_connect is always
called at least once in cifs_reconnect.

Note that this is not a perfect fix for this issue. It's still possible
that the NEGOTIATE reply is handled after the socket has been closed and
reconnected. In that case, the socket state will look correct but it no
NEGOTIATE was performed on it be for the wrong socket. In that situation
though the server should just shut down the socket on the next attempted
send, rather than causing the oops that occurs today.

Reported-and-Tested-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/connect.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -199,7 +199,7 @@ cifs_reconnect(struct TCP_Server_Info *s
 	}
 	spin_unlock(&GlobalMid_Lock);
 
-	while (server->tcpStatus == CifsNeedReconnect) {
+	do {
 		try_to_freeze();
 
 		/* we should try only the port we connected to before */
@@ -214,7 +214,7 @@ cifs_reconnect(struct TCP_Server_Info *s
 				server->tcpStatus = CifsNeedNegotiate;
 			spin_unlock(&GlobalMid_Lock);
 		}
-	}
+	} while (server->tcpStatus == CifsNeedReconnect);
 
 	return rc;
 }
@@ -3208,7 +3208,7 @@ int cifs_negotiate_protocol(unsigned int
 	}
 	if (rc == 0) {
 		spin_lock(&GlobalMid_Lock);
-		if (server->tcpStatus != CifsExiting)
+		if (server->tcpStatus == CifsNeedNegotiate)
 			server->tcpStatus = CifsGood;
 		else
 			rc = -EHOSTDOWN;


