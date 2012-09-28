Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031851Ab2I1UEs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:04:48 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51579 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758873Ab2I1SzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:55:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <edumazet@google.com>,
        Petr Matousek <pmatouse@redhat.com>,
        Florian Weimer <fweimer@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 025/262] af_netlink: force credentials passing [CVE-2012-3520]
Date: Fri, 28 Sep 2012 11:49:14 -0700
Message-Id: <20120928183000.927188115@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/scm.h        |    4 +++-
 net/netlink/af_netlink.c |    2 +-
 net/unix/af_unix.c       |    4 ++--
 3 files changed, 6 insertions(+), 4 deletions(-)

--- a/include/net/scm.h
+++ b/include/net/scm.h
@@ -71,9 +71,11 @@ static __inline__ void scm_destroy(struc
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
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1344,7 +1344,7 @@ static int netlink_sendmsg(struct kiocb
 	if (NULL == siocb->scm)
 		siocb->scm = &scm;
 
-	err = scm_send(sock, msg, siocb->scm);
+	err = scm_send(sock, msg, siocb->scm, true);
 	if (err < 0)
 		return err;
 
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1448,7 +1448,7 @@ static int unix_dgram_sendmsg(struct kio
 	if (NULL == siocb->scm)
 		siocb->scm = &tmp_scm;
 	wait_for_unix_gc();
-	err = scm_send(sock, msg, siocb->scm);
+	err = scm_send(sock, msg, siocb->scm, false);
 	if (err < 0)
 		return err;
 
@@ -1617,7 +1617,7 @@ static int unix_stream_sendmsg(struct ki
 	if (NULL == siocb->scm)
 		siocb->scm = &tmp_scm;
 	wait_for_unix_gc();
-	err = scm_send(sock, msg, siocb->scm);
+	err = scm_send(sock, msg, siocb->scm, false);
 	if (err < 0)
 		return err;
 


