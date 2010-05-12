Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab0ELOeX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 10:34:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23829 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755237Ab0ELOeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 10:34:21 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] CacheFiles: Fix error handling in
	cachefiles_determine_cache_security()
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, linux-cachefs@redhat.com,
       linux-kernel@vger.kernel.org
Date: Wed, 12 May 2010 15:34:03 +0100
Message-ID: <20100512143403.2722.29652.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cachefiles_determine_cache_security() is expected to return with a security
override in place.  However, if set_create_files_as() fails, we fail to do
this.  In this case, we should just reinstate the security override that was
set by the caller.

Furthermore, if set_create_files_as() fails, we should dispose of the new
credentials we were in the process of creating.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/cachefiles/security.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/cachefiles/security.c b/fs/cachefiles/security.c
index b5808cd..039b501 100644
--- a/fs/cachefiles/security.c
+++ b/fs/cachefiles/security.c
@@ -77,6 +77,8 @@ static int cachefiles_check_cache_dir(struct cachefiles_cache *cache,
 /*
  * check the security details of the on-disk cache
  * - must be called with security override in force
+ * - must return with a security override in force - even in the case of an
+ *   error
  */
 int cachefiles_determine_cache_security(struct cachefiles_cache *cache,
 					struct dentry *root,
@@ -99,6 +101,8 @@ int cachefiles_determine_cache_security(struct cachefiles_cache *cache,
 	 * which create files */
 	ret = set_create_files_as(new, root->d_inode);
 	if (ret < 0) {
+		abort_creds(new);
+		cachefiles_begin_secure(cache, _saved_cred);
 		_leave(" = %d [cfa]", ret);
 		return ret;
 	}

