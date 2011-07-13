Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965369Ab1GMLry (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 07:47:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36114 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965051Ab1GMLrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 07:47:53 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FS-Cache: Fix bounds check
To: geert@linux-m68k.org
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        David Howells <dhowells@redhat.com>
Date: Wed, 13 Jul 2011 12:47:38 +0100
Message-ID: <20110713114737.29760.95481.stgit@warthog.procyon.org.uk>
In-Reply-To: <20110712124622.9331.83332.sendpatchset@squad5-lp1.lab.bos.redhat.com>
References: <20110712124622.9331.83332.sendpatchset@squad5-lp1.lab.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__fscache_uncache_all_inode_pages() has a loop that goes through page index
numbers go up to (loff_t)-1.  This is incorrect.  The limit should be
(pgoff_t)-1 as on a 32-bit machine the pgoff_t is smaller than loff_t.

On m68k the following error is observed:

fs/fscache/page.c: In function '__fscache_uncache_all_inode_pages':
fs/fscache/page.c:979: warning: comparison is always false due to
limited range of data type

[Should there be a PGOFF_T_MAX constant defined?]

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/fscache/page.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/fscache/page.c b/fs/fscache/page.c
index 60315b3..112359d 100644
--- a/fs/fscache/page.c
+++ b/fs/fscache/page.c
@@ -993,7 +993,7 @@ void __fscache_uncache_all_inode_pages(struct fscache_cookie *cookie,
 
 	pagevec_init(&pvec, 0);
 	next = 0;
-	while (next <= (loff_t)-1 &&
+	while (next <= (pgoff_t)-1 &&
 	       pagevec_lookup(&pvec, mapping, next, PAGEVEC_SIZE)
 	       ) {
 		for (i = 0; i < pagevec_count(&pvec); i++) {

