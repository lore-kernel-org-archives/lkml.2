Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab0FHPOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 11:14:53 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:48147 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668Ab0FHPOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 11:14:52 -0400
To: jens.axboe@oracle.com
CC: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <E1OLzoX-0003sA-2Y@pomaz-ex.szeredi.hu> (message from Miklos
	Szeredi on Tue, 08 Jun 2010 16:30:01 +0200)
Subject: Re: [PATCH 2/2] pipe: remove bogus check from "set size" fcntl
References: <E1OLznJ-0003rR-OZ@pomaz-ex.szeredi.hu> <E1OLzoX-0003sA-2Y@pomaz-ex.szeredi.hu>
Message-Id: <E1OM0Vn-0003xX-E5@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 08 Jun 2010 17:14:43 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Jun 2010, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> As it stands this check compares the number of pages to the page size.
> This makes no sense and makes the fcntl fail in almost any sane case.
> 
> Fix it by removing the check completely, round_pipe_size() will make
> sure that nr_pages >= 1 anyway.

Hmm, not quite true.  It can actually return zero if round_pipe_size()
overflows unsigned int.

Updated patch below.

Thanks,
Miklos
----

From: Miklos Szeredi <mszeredi@suse.cz>
Subject: pipe: fix check in "set size" fcntl

As it stands this check compares the number of pages to the page size.
This makes no sense and makes the fcntl fail in almost any sane case.

Fix it by checking if nr_pages is not zero (it can become zero only if
arg is too big and round_pipe_size() overflows).

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/pipe.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux-2.6/fs/pipe.c
===================================================================
--- linux-2.6.orig/fs/pipe.c	2010-06-08 16:48:18.000000000 +0200
+++ linux-2.6/fs/pipe.c	2010-06-08 17:12:04.000000000 +0200
@@ -1215,12 +1215,13 @@ long pipe_fcntl(struct file *file, unsig
 		size = round_pipe_size(arg);
 		nr_pages = size >> PAGE_SHIFT;
 
+		ret = -EINVAL;
+		if (!nr_pages)
+			goto out;
+
 		if (!capable(CAP_SYS_RESOURCE) && size > pipe_max_size) {
 			ret = -EPERM;
 			goto out;
-		} else if (nr_pages < PAGE_SIZE) {
-			ret = -EINVAL;
-			goto out;
 		}
 		ret = pipe_set_size(pipe, nr_pages);
 		break;


