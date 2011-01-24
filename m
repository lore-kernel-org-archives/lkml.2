Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab1AXUvD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 15:51:03 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:41014 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486Ab1AXUvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 15:51:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:subject:to:cc:date:message-id:user-agent:mime-version
         :content-type:content-transfer-encoding;
        b=q9gicrJ313hHk0c58z7GkFqAE73asTOBbc35Y4oSH2TfjpPnYpPubMUDReYwuEebr9
         32Xo7eUSCzGuGiisZfEXRcDhsOYfvC+jDpV/Jtg//sfWOraGBhiMorbcAyp4X+N5ghLq
         Yi1NfMh+q6c3/7X/VtPviyEjl+0dHyVhUWSFI=
From: Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH] NLM: Fix "kernel BUG at fs/lockd/host.c:417!" or
	".../host.c:283!"
To: nbowler@elliptictech.com, trond.myklebust@netapp.com
Cc: bfields@fieldses.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 24 Jan 2011 15:50:26 -0500
Message-ID: <20110124204332.1878.35846.stgit@matisse.1015granger.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Bowler <nbowler@elliptictech.com> reports:

> We were just having some NFS server troubles, and my client machine
> running 2.6.38-rc1+ (specifically, commit 2b1caf6ed7b888c95) crashed
> hard (syslog output appended to this mail).
>
> I'm not sure what the exact timeline was or how to reproduce this,
> but the server was rebooted during all this.  Since I've never seen
> this happen before, it is possibly a regression from previous kernel
> releases.  However, I recently updated my nfs-utils (on the client) to
> version 1.2.3, so that might be related as well.

  [ BUG output redacted ]

When done searching, the for_each_host loop in next_host_state() falls
through and returns the final host on the host chain without bumping
it's reference count.

Since the host's ref count is only one at that point, releasing the
host in nlm_host_rebooted() attempts to destroy the host prematurely,
and therefore hits a BUG().

Likely, the original intent of the for_each_host behavior in
next_host_state() was to handle the case when the host chain is empty.
Searching the chain and finding no suitable host to return needs to be
handled as well.

Defensively restructure next_host_state() always to return NULL when
the loop falls through.

Introduced by commit b10e30f6 "lockd: reorganize nlm_host_rebooted".

Cc: J. Bruce Fields <bfields@fieldses.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---

I was able to reproduce this BUG on my client running 2.6.38-rc2
from earlier today.  Here is a proposed fix.  I can't reproduce the
BUG with this patch applied.

However, my reproducer hit the BUG in nlmsvc_release_host().  Nick hit
roughly the same BUG in nlmclnt_release_host(), which suggests his
"client" was also acting as a server.  The symptoms are similar enough
that I believe this patch should be sufficient to address both cases.


 fs/lockd/host.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/lockd/host.c b/fs/lockd/host.c
index 5f1bcb2..b7c99bf 100644
--- a/fs/lockd/host.c
+++ b/fs/lockd/host.c
@@ -520,7 +520,7 @@ static struct nlm_host *next_host_state(struct hlist_head *cache,
 					struct nsm_handle *nsm,
 					const struct nlm_reboot *info)
 {
-	struct nlm_host *host = NULL;
+	struct nlm_host *host;
 	struct hlist_head *chain;
 	struct hlist_node *pos;
 
@@ -532,12 +532,13 @@ static struct nlm_host *next_host_state(struct hlist_head *cache,
 			host->h_state++;
 
 			nlm_get_host(host);
-			goto out;
+			mutex_unlock(&nlm_host_mutex);
+			return host;
 		}
 	}
-out:
+
 	mutex_unlock(&nlm_host_mutex);
-	return host;
+	return NULL;
 }
 
 /**

