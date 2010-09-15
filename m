Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab0IOGdA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 02:33:00 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:37398 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab0IOGc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 02:32:59 -0400
To: Andrew Morton <akpm@linux-foundation.org>
CC: JBeulich@novell.com, linux-kernel@vger.kernel.org, rjw@sisk.pl,
        miklos@szeredi.hu
In-reply-to: <20100914160654.20c91c22.akpm@linux-foundation.org> (message from
	Andrew Morton on Tue, 14 Sep 2010 16:06:54 -0700)
Subject: Re: [PATCH] use clear_page()/copy_page() in favor of
 memset()/memcpy() on whole pages
References: <4C7FB50D0200007800013F36@vpn.id2.novell.com> <20100914160654.20c91c22.akpm@linux-foundation.org>
Message-Id: <E1OvlY2-0004Vd-Ss@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 15 Sep 2010 08:32:50 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Sep 2010, Andrew Morton wrote:
> On Thu, 02 Sep 2010 13:30:37 +0100
> "Jan Beulich" <JBeulich@novell.com> wrote:
> 
> > After all that's what they are intended for.
> > 
> > ...
> >
> > --- linux-2.6.36-rc3/fs/fuse/dev.c
> > +++ 2.6.36-rc3-use-clear_page/fs/fuse/dev.c
> > @@ -811,7 +811,7 @@ static int fuse_copy_page(struct fuse_co
> >  
> >  	if (page && zeroing && count < PAGE_SIZE) {
> >  		void *mapaddr = kmap_atomic(page, KM_USER1);
> > -		memset(mapaddr, 0, PAGE_SIZE);
> > +		clear_page(mapaddr);
> >  		kunmap_atomic(mapaddr, KM_USER1);
> >  	}
> >  	while (count) {
> 
> fuse wanted to use clear_highpage() here.  But clear_highpage() uses
> KM_USER0.  I don't immediately see why fuse uses KM_USER1 here?

There used to be KM_USER0 kmaps in there, but now they've been
replaced with plain kmaps.  So switching to clear_highpage() should be
fine.

Incremental patch appended.

Thanks,
Miklos
----

Subject: fuse: use clear_highpage() and  KM_USER0 instead of KM_USER1
From: Miklos Szeredi <mszeredi@suse.cz>

Commit 7909b1c640 (fuse: don't use atomic kmap) removed KM_USER0 usage
from fuse/dev.c.  Switch KM_USER1 uses to KM_USER0 for clarity.  Also
replace open coded clear_highpage().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/fuse/dev.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

Index: linux-2.6/fs/fuse/dev.c
===================================================================
--- linux-2.6.orig/fs/fuse/dev.c	2010-09-15 08:22:34.000000000 +0200
+++ linux-2.6/fs/fuse/dev.c	2010-09-15 08:24:30.000000000 +0200
@@ -809,11 +809,9 @@ static int fuse_copy_page(struct fuse_co
 	int err;
 	struct page *page = *pagep;
 
-	if (page && zeroing && count < PAGE_SIZE) {
-		void *mapaddr = kmap_atomic(page, KM_USER1);
-		clear_page(mapaddr);
-		kunmap_atomic(mapaddr, KM_USER1);
-	}
+	if (page && zeroing && count < PAGE_SIZE)
+		clear_highpage(page);
+
 	while (count) {
 		if (cs->write && cs->pipebufs && page) {
 			return fuse_ref_page(cs, page, offset, count);
@@ -830,10 +828,10 @@ static int fuse_copy_page(struct fuse_co
 			}
 		}
 		if (page) {
-			void *mapaddr = kmap_atomic(page, KM_USER1);
+			void *mapaddr = kmap_atomic(page, KM_USER0);
 			void *buf = mapaddr + offset;
 			offset += fuse_copy_do(cs, &buf, &count);
-			kunmap_atomic(mapaddr, KM_USER1);
+			kunmap_atomic(mapaddr, KM_USER0);
 		} else
 			offset += fuse_copy_do(cs, NULL, &count);
 	}
