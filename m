Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759524Ab0HLA1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:27:40 -0400
Received: from kroah.org ([198.145.64.141]:60125 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759420Ab0HLAEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:04:00 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:01:24 2010
Message-Id: <20100812000124.492358858@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:00:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Miklos Szeredi <mszeredi@suse.cz>, Jens Axboe <jaxboe@fusionio.com>
Subject: [13/54] splice: fix misuse of SPLICE_F_NONBLOCK
In-Reply-To: <20100812000249.GA30948@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Miklos Szeredi <miklos@szeredi.hu>

commit 6965031d331a642e31278fa1b5bd47f372ffdd5d upstream.

SPLICE_F_NONBLOCK is clearly documented to only affect blocking on the
pipe.  In __generic_file_splice_read(), however, it causes an EAGAIN
if the page is currently being read.

This makes it impossible to write an application that only wants
failure if the pipe is full.  For example if the same process is
handling both ends of a pipe and isn't otherwise able to determine
whether a splice to the pipe will fill it or not.

We could make the read non-blocking on O_NONBLOCK or some other splice
flag, but for now this is the simplest fix.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/splice.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

--- a/fs/splice.c
+++ b/fs/splice.c
@@ -366,17 +366,7 @@ __generic_file_splice_read(struct file *
 		 * If the page isn't uptodate, we may need to start io on it
 		 */
 		if (!PageUptodate(page)) {
-			/*
-			 * If in nonblock mode then dont block on waiting
-			 * for an in-flight io page
-			 */
-			if (flags & SPLICE_F_NONBLOCK) {
-				if (!trylock_page(page)) {
-					error = -EAGAIN;
-					break;
-				}
-			} else
-				lock_page(page);
+			lock_page(page);
 
 			/*
 			 * Page was truncated, or invalidated by the


