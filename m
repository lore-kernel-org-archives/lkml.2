Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757665Ab2BHVT2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 16:19:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36538 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757652Ab2BHVTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 16:19:24 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 15/17] FS-Cache: Limit the number of I/O error reports for a
 cache
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-cachefs@redhat.com,
        linux-nfs@vger.kernel.org
Date: Wed, 08 Feb 2012 21:19:15 +0000
Message-ID: <20120208211915.15607.60413.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120208211640.15607.58537.stgit@warthog.procyon.org.uk>
References: <20120208211640.15607.58537.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Limit the number of I/O error reports for a cache to 1 to prevent massive
amounts of noise.  After the first I/O error the cache is taken off line
automatically, so must be restarted to resume caching.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/fscache/cache.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/fscache/cache.c b/fs/fscache/cache.c
index 6a3c48a..b52aed1 100644
--- a/fs/fscache/cache.c
+++ b/fs/fscache/cache.c
@@ -314,10 +314,10 @@ EXPORT_SYMBOL(fscache_add_cache);
  */
 void fscache_io_error(struct fscache_cache *cache)
 {
-	set_bit(FSCACHE_IOERROR, &cache->flags);
-
-	printk(KERN_ERR "FS-Cache: Cache %s stopped due to I/O error\n",
-	       cache->ops->name);
+	if (!test_and_set_bit(FSCACHE_IOERROR, &cache->flags))
+		printk(KERN_ERR "FS-Cache:"
+		       " Cache '%s' stopped due to I/O error\n",
+		       cache->ops->name);
 }
 EXPORT_SYMBOL(fscache_io_error);
 

