Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340Ab1HCXfj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:35:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34110 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756288Ab1HCXa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:30:27 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:54 2011
Message-Id: <20110803221254.063310836@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:01:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mikulas Patocka <mpatocka@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>
Subject: [099/102] dm io: flush cpu cache with vmapped io
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit bb91bc7bacb906c9f3a9b22744c53fa7564b51ba upstream.

For normal kernel pages, CPU cache is synchronized by the dma layer.
However, this is not done for pages allocated with vmalloc. If we do I/O
to/from vmallocated pages, we must synchronize CPU cache explicitly.

Prior to doing I/O on vmallocated page we must call
flush_kernel_vmap_range to flush dirty cache on the virtual address.
After finished read we must call invalidate_kernel_vmap_range to
invalidate cache on the virtual address, so that accesses to the virtual
address return newly read data and not stale data from CPU cache.

This patch fixes metadata corruption on dm-snapshots on PA-RISC and
possibly other architectures with caches indexed by virtual address.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-io.c |   29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -38,6 +38,8 @@ struct io {
 	struct dm_io_client *client;
 	io_notify_fn callback;
 	void *context;
+	void *vma_invalidate_address;
+	unsigned long vma_invalidate_size;
 } __attribute__((aligned(DM_IO_MAX_REGIONS)));
 
 static struct kmem_cache *_dm_io_cache;
@@ -116,6 +118,10 @@ static void dec_count(struct io *io, uns
 		set_bit(region, &io->error_bits);
 
 	if (atomic_dec_and_test(&io->count)) {
+		if (io->vma_invalidate_size)
+			invalidate_kernel_vmap_range(io->vma_invalidate_address,
+						     io->vma_invalidate_size);
+
 		if (io->sleeper)
 			wake_up_process(io->sleeper);
 
@@ -159,6 +165,9 @@ struct dpages {
 
 	unsigned context_u;
 	void *context_ptr;
+
+	void *vma_invalidate_address;
+	unsigned long vma_invalidate_size;
 };
 
 /*
@@ -377,6 +386,9 @@ static int sync_io(struct dm_io_client *
 	io->sleeper = current;
 	io->client = client;
 
+	io->vma_invalidate_address = dp->vma_invalidate_address;
+	io->vma_invalidate_size = dp->vma_invalidate_size;
+
 	dispatch_io(rw, num_regions, where, dp, io, 1);
 
 	while (1) {
@@ -415,13 +427,21 @@ static int async_io(struct dm_io_client
 	io->callback = fn;
 	io->context = context;
 
+	io->vma_invalidate_address = dp->vma_invalidate_address;
+	io->vma_invalidate_size = dp->vma_invalidate_size;
+
 	dispatch_io(rw, num_regions, where, dp, io, 0);
 	return 0;
 }
 
-static int dp_init(struct dm_io_request *io_req, struct dpages *dp)
+static int dp_init(struct dm_io_request *io_req, struct dpages *dp,
+		   unsigned long size)
 {
 	/* Set up dpages based on memory type */
+
+	dp->vma_invalidate_address = NULL;
+	dp->vma_invalidate_size = 0;
+
 	switch (io_req->mem.type) {
 	case DM_IO_PAGE_LIST:
 		list_dp_init(dp, io_req->mem.ptr.pl, io_req->mem.offset);
@@ -432,6 +452,11 @@ static int dp_init(struct dm_io_request
 		break;
 
 	case DM_IO_VMA:
+		flush_kernel_vmap_range(io_req->mem.ptr.vma, size);
+		if ((io_req->bi_rw & RW_MASK) == READ) {
+			dp->vma_invalidate_address = io_req->mem.ptr.vma;
+			dp->vma_invalidate_size = size;
+		}
 		vm_dp_init(dp, io_req->mem.ptr.vma);
 		break;
 
@@ -460,7 +485,7 @@ int dm_io(struct dm_io_request *io_req,
 	int r;
 	struct dpages dp;
 
-	r = dp_init(io_req, &dp);
+	r = dp_init(io_req, &dp, (unsigned long)where->count << SECTOR_SHIFT);
 	if (r)
 		return r;
 


