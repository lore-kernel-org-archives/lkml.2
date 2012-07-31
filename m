Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803Ab2GaEvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 00:51:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48872 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755719Ab2GaEvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 00:51:09 -0400
Message-Id: <20120731044315.148115472@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 31 Jul 2012 05:43:34 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jeff Layton <jlayton@redhat.com>,
        Jian Li <jiali@redhat.com>, Steve French <smfrench@gmail.com>
Subject: [ 24/73] cifs: when CONFIG_HIGHMEM is set, serialize the  read/write kmaps
In-Reply-To: <20120731044310.013763753@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 3cf003c08be785af4bee9ac05891a15bcbff856a upstream.

Jian found that when he ran fsx on a 32 bit arch with a large wsize the
process and one of the bdi writeback kthreads would sometimes deadlock
with a stack trace like this:

crash> bt
PID: 2789   TASK: f02edaa0  CPU: 3   COMMAND: "fsx"
 #0 [eed63cbc] schedule at c083c5b3
 #1 [eed63d80] kmap_high at c0500ec8
 #2 [eed63db0] cifs_async_writev at f7fabcd7 [cifs]
 #3 [eed63df0] cifs_writepages at f7fb7f5c [cifs]
 #4 [eed63e50] do_writepages at c04f3e32
 #5 [eed63e54] __filemap_fdatawrite_range at c04e152a
 #6 [eed63ea4] filemap_fdatawrite at c04e1b3e
 #7 [eed63eb4] cifs_file_aio_write at f7fa111a [cifs]
 #8 [eed63ecc] do_sync_write at c052d202
 #9 [eed63f74] vfs_write at c052d4ee
#10 [eed63f94] sys_write at c052df4c
#11 [eed63fb0] ia32_sysenter_target at c0409a98
    EAX: 00000004  EBX: 00000003  ECX: abd73b73  EDX: 012a65c6
    DS:  007b      ESI: 012a65c6  ES:  007b      EDI: 00000000
    SS:  007b      ESP: bf8db178  EBP: bf8db1f8  GS:  0033
    CS:  0073      EIP: 40000424  ERR: 00000004  EFLAGS: 00000246

Each task would kmap part of its address array before getting stuck, but
not enough to actually issue the write.

This patch fixes this by serializing the marshal_iov operations for
async reads and writes. The idea here is to ensure that cifs
aggressively tries to populate a request before attempting to fulfill
another one. As soon as all of the pages are kmapped for a request, then
we can unlock and allow another one to proceed.

There's no need to do this serialization on non-CONFIG_HIGHMEM arches
however, so optimize all of this out when CONFIG_HIGHMEM isn't set.

Reported-by: Jian Li <jiali@redhat.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <smfrench@gmail.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/cifs/cifssmb.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -89,6 +89,32 @@ static struct {
 /* Forward declarations */
 static void cifs_readv_complete(struct work_struct *work);
 
+#ifdef CONFIG_HIGHMEM
+/*
+ * On arches that have high memory, kmap address space is limited. By
+ * serializing the kmap operations on those arches, we ensure that we don't
+ * end up with a bunch of threads in writeback with partially mapped page
+ * arrays, stuck waiting for kmap to come back. That situation prevents
+ * progress and can deadlock.
+ */
+static DEFINE_MUTEX(cifs_kmap_mutex);
+
+static inline void
+cifs_kmap_lock(void)
+{
+	mutex_lock(&cifs_kmap_mutex);
+}
+
+static inline void
+cifs_kmap_unlock(void)
+{
+	mutex_unlock(&cifs_kmap_mutex);
+}
+#else /* !CONFIG_HIGHMEM */
+#define cifs_kmap_lock() do { ; } while(0)
+#define cifs_kmap_unlock() do { ; } while(0)
+#endif /* CONFIG_HIGHMEM */
+
 /* Mark as invalid, all open files on tree connections since they
    were closed when session to server was lost */
 static void mark_open_files_invalid(struct cifs_tcon *pTcon)
@@ -1540,6 +1566,7 @@ cifs_readv_receive(struct TCP_Server_Inf
 	eof_index = eof ? (eof - 1) >> PAGE_CACHE_SHIFT : 0;
 	cFYI(1, "eof=%llu eof_index=%lu", eof, eof_index);
 
+	cifs_kmap_lock();
 	list_for_each_entry_safe(page, tpage, &rdata->pages, lru) {
 		if (remaining >= PAGE_CACHE_SIZE) {
 			/* enough data to fill the page */
@@ -1589,6 +1616,7 @@ cifs_readv_receive(struct TCP_Server_Inf
 			page_cache_release(page);
 		}
 	}
+	cifs_kmap_unlock();
 
 	/* issue the read if we have any iovecs left to fill */
 	if (rdata->nr_iov > 1) {
@@ -2171,6 +2199,7 @@ cifs_async_writev(struct cifs_writedata
 	iov[0].iov_base = smb;
 
 	/* marshal up the pages into iov array */
+	cifs_kmap_lock();
 	wdata->bytes = 0;
 	for (i = 0; i < wdata->nr_pages; i++) {
 		iov[i + 1].iov_len = min(inode->i_size -
@@ -2179,6 +2208,7 @@ cifs_async_writev(struct cifs_writedata
 		iov[i + 1].iov_base = kmap(wdata->pages[i]);
 		wdata->bytes += iov[i + 1].iov_len;
 	}
+	cifs_kmap_unlock();
 
 	cFYI(1, "async write at %llu %u bytes", wdata->offset, wdata->bytes);
 


