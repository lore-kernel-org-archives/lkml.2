Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229Ab2LMODG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:03:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44117 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932206Ab2LMODB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:03:01 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: NeilBrown <neilb@suse.de>, Trond Myklebust <Trond.Myklebust@netapp.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 037/241] NFS: fix bug in legacy DNS resolver.
Date: Thu, 13 Dec 2012 11:56:42 -0200
Message-Id: <1355407206-17100-38-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 8d96b10639fb402357b75b055b1e82a65ff95050 upstream.

The DNS resolver's use of the sunrpc cache involves a 'ttl' number
(relative) rather that a timeout (absolute).  This confused me when
I wrote
  commit c5b29f885afe890f953f7f23424045cdad31d3e4
     "sunrpc: use seconds since boot in expiry cache"

and I managed to break it.  The effect is that any TTL is interpreted
as 0, and nothing useful gets into the cache.

This patch removes the use of get_expiry() - which really expects an
expiry time - and uses get_uint() instead, treating the int correctly
as a ttl.

This fixes a regression that has been present since 2.6.37, causing
certain NFS accesses in certain environments to incorrectly fail.

Reported-by: Chuck Lever <chuck.lever@oracle.com>
Tested-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/nfs/dns_resolve.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/dns_resolve.c b/fs/nfs/dns_resolve.c
index b3924b8..786cd65 100644
--- a/fs/nfs/dns_resolve.c
+++ b/fs/nfs/dns_resolve.c
@@ -214,7 +214,7 @@ static int nfs_dns_parse(struct cache_detail *cd, char *buf, int buflen)
 {
 	char buf1[NFS_DNS_HOSTNAME_MAXLEN+1];
 	struct nfs_dns_ent key, *item;
-	unsigned long ttl;
+	unsigned int ttl;
 	ssize_t len;
 	int ret = -EINVAL;
 
@@ -237,7 +237,8 @@ static int nfs_dns_parse(struct cache_detail *cd, char *buf, int buflen)
 	key.namelen = len;
 	memset(&key.h, 0, sizeof(key.h));
 
-	ttl = get_expiry(&buf);
+	if (get_uint(&buf, &ttl) < 0)
+		goto out;
 	if (ttl == 0)
 		goto out;
 	key.h.expiry_time = ttl + seconds_since_boot();
-- 
1.7.9.5

