Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759281Ab2FFXga (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 19:36:30 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:61391 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059Ab2FFXg3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 19:36:29 -0400
MIME-Version: 1.0
In-Reply-To: <20120606162121.7d8e8f52.akpm@linux-foundation.org>
References: <1339003047-15734-1-git-send-email-roland@kernel.org> <20120606162121.7d8e8f52.akpm@linux-foundation.org>
From: Roland Dreier <roland@kernel.org>
Date: Wed, 6 Jun 2012 16:36:08 -0700
X-Google-Sender-Auth: ibwvXR_Lxy4rmpDKg9WNbgAtK_k
Message-ID: <CAG4TOxPHXg_cDpG2gMNKgyNGs2BcXbM3bTgiuS+mjnPZFhbD8A@mail.gmail.com>
Subject: Re: [PATCH 1/2] btree: Fix tree corruption in btree_get_prev()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joern Engel <joern@logfs.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 6, 2012 at 4:21 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> I think we can do this to save a few cycles?
>
> --- a/lib/btree.c~btree-fix-tree-corruption-in-btree_get_prev-fix
> +++ a/lib/btree.c
> @@ -319,8 +319,8 @@ void *btree_get_prev(struct btree_head *
>
>        if (head->height == 0)
>                return NULL;
> -retry:
>        longcpy(key, __key, geo->keylen);
> +retry:
>        dec_key(geo, key);
>
>        node = head->node;
> @@ -351,7 +351,7 @@ retry:
>        }
>  miss:
>        if (retry_key) {
> -               longcpy(__key, retry_key, geo->keylen);
> +               longcpy(key, retry_key, geo->keylen);
>                retry_key = NULL;
>                goto retry;
>        }

Looks reasonable to me, and passes my hacky userspace
test harness.

On the other hand, your change makes me think we don't
even need a separate iterator (and we can avoid the variable
length array declaration), ie we could do

--- a/lib/btree.c
+++ b/lib/btree.c
@@ -312,7 +312,7 @@ void *btree_get_prev(struct btree_head *head,
struct btree_geo *geo,
 {
 	int i, height;
 	unsigned long *node, *oldnode;
-	unsigned long *retry_key = NULL, key[geo->keylen];
+	unsigned long *retry_key = NULL;

 	if (keyzero(geo, __key))
 		return NULL;
@@ -320,13 +320,12 @@ void *btree_get_prev(struct btree_head *head,
struct btree_geo *geo,
 	if (head->height == 0)
 		return NULL;
 retry:
-	longcpy(key, __key, geo->keylen);
-	dec_key(geo, key);
+	dec_key(geo, __key);

 	node = head->node;
 	for (height = head->height ; height > 1; height--) {
 		for (i = 0; i < geo->no_pairs; i++)
-			if (keycmp(geo, node, i, key) <= 0)
+			if (keycmp(geo, node, i, __key) <= 0)
 				break;
 		if (i == geo->no_pairs)
 			goto miss;
@@ -341,7 +340,7 @@ retry:
 		goto miss;

 	for (i = 0; i < geo->no_pairs; i++) {
-		if (keycmp(geo, node, i, key) <= 0) {
+		if (keycmp(geo, node, i, __key) <= 0) {
 			if (bval(geo, node, i)) {
 				longcpy(__key, bkey(geo, node, i), geo->keylen);
 				return bval(geo, node, i);

but this means even if we fail and return NULL we mess with the
caller's __key.  So your way may be better.

Joern?

 - R.
