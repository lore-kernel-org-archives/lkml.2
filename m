Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759064Ab0EXXJj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:09:39 -0400
Received: from kroah.org ([198.145.64.141]:36524 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758689Ab0EXXJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:09:37 -0400
X-Mailbox-Line: From gregkh@clark.site Mon May 24 16:03:51 2010
Message-Id: <20100524230351.837063978@clark.site>
User-Agent: quilt/0.48-8.10
Date: Mon, 24 May 2010 16:00:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Howells <dhowells@redhat.com>
Subject: [28/34] CacheFiles: Fix error handling in cachefiles_determine_cache_security()
In-Reply-To: <20100524230418.GA12770@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Howells <dhowells@redhat.com>

commit 7ac512aa8237c43331ffaf77a4fd8b8d684819ba upstream.

cachefiles_determine_cache_security() is expected to return with a
security override in place.  However, if set_create_files_as() fails, we
fail to do this.  In this case, we should just reinstate the security
override that was set by the caller.

Furthermore, if set_create_files_as() fails, we should dispose of the
new credentials we were in the process of creating.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cachefiles/security.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/cachefiles/security.c
+++ b/fs/cachefiles/security.c
@@ -77,6 +77,8 @@ static int cachefiles_check_cache_dir(st
 /*
  * check the security details of the on-disk cache
  * - must be called with security override in force
+ * - must return with a security override in force - even in the case of an
+ *   error
  */
 int cachefiles_determine_cache_security(struct cachefiles_cache *cache,
 					struct dentry *root,
@@ -99,6 +101,8 @@ int cachefiles_determine_cache_security(
 	 * which create files */
 	ret = set_create_files_as(new, root->d_inode);
 	if (ret < 0) {
+		abort_creds(new);
+		cachefiles_begin_secure(cache, _saved_cred);
 		_leave(" = %d [cfa]", ret);
 		return ret;
 	}


