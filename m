Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758574Ab1GKS6z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 14:58:55 -0400
Received: from smtp-out.google.com ([216.239.44.51]:5049 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758563Ab1GKS6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 14:58:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	message-id:user-agent:mime-version:content-type:x-system-of-record;
	b=sosJJaIhS0CtwJcckivrtekgWuhfZ+ViZntsQ2BCA7XbWFpWd806GrM65sJbOWZ3n
	4eq3BNw+MhGDGJizCLbrQ==
Date: Mon, 11 Jul 2011 11:58:41 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Christoph Lameter <cl@linux.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH next/mmotm] slub: partly fix freeze in __slab_free
Message-ID: <alpine.LSU.2.00.1107111156310.13035@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My load tests on PowerPC freeze within minutes in __slab_free().
I happened to try PPC first, didn't try without this fix on x86.

It looks as if the author was interrupted while devising the new
cmpxchg_double_slab() version of __slab_free(): its decision to
spin_lock_irqsave() depends on several uninitialized fields,
and fixing that (by copying page to new) mostly fixes it.

But I didn't think about it very much, and this may well not be what
the author intends; and I have seen a couple of much rarer freezes
in __slab_free() on PPC (not yet on x86) even after applying this.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 mm/slub.c |    1 +
 1 file changed, 1 insertion(+)

--- mmotm/mm/slub.c	2011-07-08 18:59:44.135443127 -0700
+++ linux/mm/slub.c	2011-07-10 05:07:08.000000000 -0700
@@ -2217,6 +2217,7 @@ static void __slab_free(struct kmem_cach
 		return;
 
 	do {
+		new = *page;
 		prior = page->freelist;
 		counters = page->counters;
 		set_freepointer(s, object, prior);
