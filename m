Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993331Ab2KOEM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:12:56 -0500
Received: from mail.kernel.org ([198.145.19.201]:49842 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993263Ab2KOEMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:12:45 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neilb@suse.de>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 27/57] NFS: fix bug in legacy DNS resolver.
Date: Wed, 14 Nov 2012 20:11:35 -0800
Message-Id: <20121115040934.889380736@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040933.223998671@linuxfoundation.org>
References: <20121115040933.223998671@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/dns_resolve.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/nfs/dns_resolve.c
+++ b/fs/nfs/dns_resolve.c
@@ -214,7 +214,7 @@ static int nfs_dns_parse(struct cache_de
 {
 	char buf1[NFS_DNS_HOSTNAME_MAXLEN+1];
 	struct nfs_dns_ent key, *item;
-	unsigned long ttl;
+	unsigned int ttl;
 	ssize_t len;
 	int ret = -EINVAL;
 
@@ -237,7 +237,8 @@ static int nfs_dns_parse(struct cache_de
 	key.namelen = len;
 	memset(&key.h, 0, sizeof(key.h));
 
-	ttl = get_expiry(&buf);
+	if (get_uint(&buf, &ttl) < 0)
+		goto out;
 	if (ttl == 0)
 		goto out;
 	key.h.expiry_time = ttl + seconds_since_boot();


