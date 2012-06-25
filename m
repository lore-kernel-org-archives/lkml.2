Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292Ab2FYQlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 12:41:21 -0400
Received: from smtp.outflux.net ([198.145.64.163]:55427 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754534Ab2FYQlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 12:41:19 -0400
Date: Mon, 25 Jun 2012 09:40:49 -0700
From: Kees Cook <keescook@chromium.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, Miklos Szeredi <mszeredi@suse.cz>
Subject: Re: linux-next: build failure after merge of the akpm tree
Message-ID: <20120625164049.GO5042@outflux.net>
References: <20120625164141.1c5b1b543e0309005dfd0d9c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120625164141.1c5b1b543e0309005dfd0d9c@canb.auug.org.au>
Organization: Outflux
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Mon, Jun 25, 2012 at 04:41:41PM +1000, Stephen Rothwell wrote:
> After merging the akpm tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> fs/namei.c: In function 'path_openat':
> fs/namei.c:2874:4: error: 'filp' undeclared (first use in this function)
> 
> Caused by patch "fs: add link restrictions" from the akpm tree
> interacting with (at least) commit 4066cd545681 ("vfs: remove open
> intents from nameidata") from the vfs tree.
> 
> I don't know how to fix this, so I have reverted the akpm patch for today
> (in the hope that someone else will fix it).

It looks like namei.c changed the logic of the lookup loop. This should
fix it.

Signed-off-by: Kees Cook <keescook@chromium.org>

---

diff -uNrp a/fs/namei.c b/fs/namei.c
--- a/fs/namei.c	2012-06-25 09:30:28.125746562 -0700
+++ b/fs/namei.c	2012-06-25 09:31:29.456997558 -0700
@@ -2870,10 +2870,8 @@ static struct file *path_openat(int dfd,
 			break;
 		}
 		error = may_follow_link(&link);
-		if (unlikely(error)) {
-			filp = ERR_PTR(error);
+		if (unlikely(error))
 			break;
-		}
 		nd->flags |= LOOKUP_PARENT;
 		nd->flags &= ~(LOOKUP_OPEN|LOOKUP_CREATE|LOOKUP_EXCL);
 		error = follow_link(&link, nd, &cookie);


-- 
Kees Cook
Chrome OS Security
