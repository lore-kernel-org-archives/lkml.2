Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608Ab2KNF6c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 00:58:32 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55193 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756359Ab2KNFuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:50:51 -0500
Message-Id: <20121114053940.232994658@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:40:19 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        NeilBrown <neilb@suse.de>, Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 46/82] NFS: fix bug in legacy DNS resolver.
In-Reply-To: <20121114053933.726869752@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfs/dns_resolve.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/dns_resolve.c b/fs/nfs/dns_resolve.c
index 31c26c4..ca4b11e 100644
--- a/fs/nfs/dns_resolve.c
+++ b/fs/nfs/dns_resolve.c
@@ -217,7 +217,7 @@ static int nfs_dns_parse(struct cache_detail *cd, char *buf, int buflen)
 {
 	char buf1[NFS_DNS_HOSTNAME_MAXLEN+1];
 	struct nfs_dns_ent key, *item;
-	unsigned long ttl;
+	unsigned int ttl;
 	ssize_t len;
 	int ret = -EINVAL;
 
@@ -240,7 +240,8 @@ static int nfs_dns_parse(struct cache_detail *cd, char *buf, int buflen)
 	key.namelen = len;
 	memset(&key.h, 0, sizeof(key.h));
 
-	ttl = get_expiry(&buf);
+	if (get_uint(&buf, &ttl) < 0)
+		goto out;
 	if (ttl == 0)
 		goto out;
 	key.h.expiry_time = ttl + seconds_since_boot();


