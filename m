Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab2BEWom (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:44:42 -0500
Received: from 1wt.eu ([62.212.114.60]:61872 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753749Ab2BEW0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:20 -0500
Message-Id: <20120205220949.664105202@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:09:54 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Vasiliy Kulikov <segoon@openwall.com>, Dave Airlie <airlied@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 05/91] agp: fix OOM and buffer overflow
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

commit b522f02184b413955f3bc952e3776ce41edc6355 upstream.

page_count is copied from userspace.  agp_allocate_memory() tries to
check whether this number is too big, but doesn't take into account the
wrap case.  Also agp_create_user_memory() doesn't check whether
alloc_size is calculated from num_agp_pages variable without overflow.
This may lead to allocation of too small buffer with following buffer
overflow.

Another problem in agp code is not addressed in the patch - kernel memory
exhaustion (AGPIOC_RESERVE and AGPIOC_ALLOCATE ioctls).  It is not checked
whether requested pid is a pid of the caller (no check in agpioc_reserve_wrap()).
Each allocation is limited to 16KB, though, there is no per-process limit.
This might lead to OOM situation, which is not even solved in case of the
caller death by OOM killer - the memory is allocated for another (faked) process.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/agp/generic.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

Index: longterm-2.6.27/drivers/char/agp/generic.c
===================================================================
--- longterm-2.6.27.orig/drivers/char/agp/generic.c	2012-02-05 22:34:35.500916106 +0100
+++ longterm-2.6.27/drivers/char/agp/generic.c	2012-02-05 22:34:35.639914999 +0100
@@ -123,6 +123,9 @@
 	struct agp_memory *new;
 	unsigned long alloc_size = num_agp_pages*sizeof(struct page *);
 
+	if (INT_MAX/sizeof(struct page *) < num_agp_pages)
+		return NULL;
+
 	new = kzalloc(sizeof(struct agp_memory), GFP_KERNEL);
 	if (new == NULL)
 		return NULL;
@@ -236,11 +239,14 @@
 	int scratch_pages;
 	struct agp_memory *new;
 	size_t i;
+	int cur_memory;
 
 	if (!bridge)
 		return NULL;
 
-	if ((atomic_read(&bridge->current_memory_agp) + page_count) > bridge->max_memory_agp)
+	cur_memory = atomic_read(&bridge->current_memory_agp);
+	if ((cur_memory + page_count > bridge->max_memory_agp) ||
+	    (cur_memory + page_count < page_count))
 		return NULL;
 
 	if (type >= AGP_USER_TYPES) {


