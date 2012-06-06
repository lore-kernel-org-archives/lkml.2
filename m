Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759325Ab2FFXVX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 19:21:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47502 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600Ab2FFXVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 19:21:22 -0400
Date: Wed, 6 Jun 2012 16:21:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roland Dreier <roland@kernel.org>
Cc: Joern Engel <joern@logfs.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] btree: Fix tree corruption in btree_get_prev()
Message-Id: <20120606162121.7d8e8f52.akpm@linux-foundation.org>
In-Reply-To: <1339003047-15734-1-git-send-email-roland@kernel.org>
References: <1339003047-15734-1-git-send-email-roland@kernel.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  6 Jun 2012 10:17:26 -0700
Roland Dreier <roland@kernel.org> wrote:

> From: Roland Dreier <roland@purestorage.com>
> 
> The memory the parameter __key points to is used as an iterator in
> btree_get_prev(), so if we save off a bkey() pointer in retry_key and
> then assign that to __key, we'll end up corrupting the btree internals
> when we do eg
> 
> 	longcpy(__key, bkey(geo, node, i), geo->keylen);
> 
> to return the key value.  What we should do instead is use longcpy() to
> copy the key value that retry_key points to __key.
> 
> This can cause a btree to get corrupted by seemingly read-only
> operations such as btree_for_each_safe.
> 
> Acked-by: Joern Engel <joern@logfs.org>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Roland Dreier <roland@purestorage.com>
> ---
>  lib/btree.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/btree.c b/lib/btree.c
> index e5ec1e9..b6e889b 100644
> --- a/lib/btree.c
> +++ b/lib/btree.c
> @@ -351,7 +351,7 @@ retry:
>  	}
>  miss:
>  	if (retry_key) {
> -		__key = retry_key;
> +		longcpy(__key, retry_key, geo->keylen);
>  		retry_key = NULL;
>  		goto retry;
>  	}

Fair enough.

I think we can do this to save a few cycles?

--- a/lib/btree.c~btree-fix-tree-corruption-in-btree_get_prev-fix
+++ a/lib/btree.c
@@ -319,8 +319,8 @@ void *btree_get_prev(struct btree_head *
 
 	if (head->height == 0)
 		return NULL;
-retry:
 	longcpy(key, __key, geo->keylen);
+retry:
 	dec_key(geo, key);
 
 	node = head->node;
@@ -351,7 +351,7 @@ retry:
 	}
 miss:
 	if (retry_key) {
-		longcpy(__key, retry_key, geo->keylen);
+		longcpy(key, retry_key, geo->keylen);
 		retry_key = NULL;
 		goto retry;
 	}
_

