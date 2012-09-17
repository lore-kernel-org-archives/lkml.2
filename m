Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab2IQBIs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 21:08:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33738 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753932Ab2IQAup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:50:45 -0400
Message-Id: <20120917003635.887931499@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:37:35 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Dumazet <edumazet@google.com>,
        Petr Matousek <pmatouse@redhat.com>,
        Florian Weimer <fweimer@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 070/135] af_netlink: force credentials passing [CVE-2012-3520]
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit e0e3cea46d31d23dc40df0a49a7a2c04fe8edfea ]

Pablo Neira Ayuso discovered that avahi and
potentially NetworkManager accept spoofed Netlink messages because of a
kernel bug.  The kernel passes all-zero SCM_CREDENTIALS ancillary data
to the receiver if the sender did not provide such data, instead of not
including any such data at all or including the correct data from the
peer (as it is the case with AF_UNIX).

This bug was introduced in commit 16e572626961
(af_unix: dont send SCM_CREDENTIALS by default)

This patch forces passing credentials for netlink, as
before the regression.

Another fix would be to not add SCM_CREDENTIALS in
netlink messages if not provided by the sender, but it
might break some programs.

With help from Florian Weimer & Petr Matousek

This issue is designated as CVE-2012-3520

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Petr Matousek <pmatouse@redhat.com>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/net/scm.h        | 4 +++-
 net/netlink/af_netlink.c | 2 +-
 net/unix/af_unix.c       | 4 ++--
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/net/scm.h b/include/net/scm.h
index d456f4c..0c0017c 100644
--- a/include/net/scm.h
+++ b/include/net/scm.h
@@ -71,9 +71,11 @@ static __inline__ void scm_destroy(struct scm_cookie *scm)
 }
 
 static __inline__ int scm_send(struct socket *sock, struct msghdr *msg,
-			       struct scm_cookie *scm)
+			       struct scm_cookie *scm, bool forcecreds)
 {
 	memset(scm, 0, sizeof(*scm));
+	if (forcecreds)
+		scm_set_cred(scm, task_tgid(current), current_cred());
 	unix_get_peersec_dgram(sock, scm);
 	if (msg->msg_controllen <= 0)
 		return 0;
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index a99fb41..1af8542 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1333,7 +1333,7 @@ static int netlink_sendmsg(struct kiocb *kiocb, struct socket *sock,
 	if (NULL == siocb->scm)
 		siocb->scm = &scm;
 
-	err = scm_send(sock, msg, siocb->scm);
+	err = scm_send(sock, msg, siocb->scm, true);
 	if (err < 0)
 		return err;
 
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index d99678a..317bfe3 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1435,7 +1435,7 @@ static int unix_dgram_sendmsg(struct kiocb *kiocb, struct socket *sock,
 	if (NULL == siocb->scm)
 		siocb->scm = &tmp_scm;
 	wait_for_unix_gc();
-	err = scm_send(sock, msg, siocb->scm);
+	err = scm_send(sock, msg, siocb->scm, false);
 	if (err < 0)
 		return err;
 
@@ -1596,7 +1596,7 @@ static int unix_stream_sendmsg(struct kiocb *kiocb, struct socket *sock,
 	if (NULL == siocb->scm)
 		siocb->scm = &tmp_scm;
 	wait_for_unix_gc();
-	err = scm_send(sock, msg, siocb->scm);
+	err = scm_send(sock, msg, siocb->scm, false);
 	if (err < 0)
 		return err;
 


