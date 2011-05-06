Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084Ab1EFAY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:24:28 -0400
Received: from kroah.org ([198.145.64.141]:36611 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754232Ab1EFAYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:24:25 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:07 2011
Message-Id: <20110506002207.483960396@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:20:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vasiliy Kulikov <segoon@openwall.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [024/143] agp: fix OOM and buffer overflow
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Vasiliy Kulikov <segoon@openwall.com>

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
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/char/agp/generic.c
+++ b/drivers/char/agp/generic.c
@@ -123,6 +123,9 @@ static struct agp_memory *agp_create_use
 	struct agp_memory *new;
 	unsigned long alloc_size = num_agp_pages*sizeof(struct page *);
 
+	if (INT_MAX/sizeof(struct page *) < num_agp_pages)
+		return NULL;
+
 	new = kzalloc(sizeof(struct agp_memory), GFP_KERNEL);
 	if (new == NULL)
 		return NULL;
@@ -242,11 +245,14 @@ struct agp_memory *agp_allocate_memory(s
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


