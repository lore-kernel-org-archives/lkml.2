Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965302Ab2C3VPS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:15:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34386 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965269Ab2C3VPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:15:10 -0400
Message-Id: <20120330194900.222747750@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:50:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Mikulas Patocka <mpatocka@redhat.com>,
        Milan Broz <mbroz@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Subject: [ 122/149] dm crypt: fix mempool deadlock
In-Reply-To: <20120330195823.GA31857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit aeb2deae2660a1773c83d3c6e9e6575daa3855d6 upstream.

This patch fixes a possible deadlock in dm-crypt's mempool use.

Currently, dm-crypt reserves a mempool of MIN_BIO_PAGES reserved pages.
It allocates first MIN_BIO_PAGES with non-failing allocation (the allocation
cannot fail and waits until the mempool is refilled). Further pages are
allocated with different gfp flags that allow failing.

Because allocations may be done in parallel, this code can deadlock. Example:
There are two processes, each tries to allocate MIN_BIO_PAGES and the processes
run simultaneously.
It may end up in a situation where each process allocates (MIN_BIO_PAGES / 2)
pages. The mempool is exhausted. Each process waits for more pages to be freed
to the mempool, which never happens.

To avoid this deadlock scenario, this patch changes the code so that only
the first page is allocated with non-failing gfp mask. Allocation of further
pages may fail.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-crypt.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -176,7 +176,6 @@ struct crypt_config {
 
 #define MIN_IOS        16
 #define MIN_POOL_PAGES 32
-#define MIN_BIO_PAGES  8
 
 static struct kmem_cache *_crypt_io_pool;
 
@@ -848,12 +847,11 @@ static struct bio *crypt_alloc_buffer(st
 		}
 
 		/*
-		 * if additional pages cannot be allocated without waiting,
-		 * return a partially allocated bio, the caller will then try
-		 * to allocate additional bios while submitting this partial bio
+		 * If additional pages cannot be allocated without waiting,
+		 * return a partially-allocated bio.  The caller will then try
+		 * to allocate more bios while submitting this partial bio.
 		 */
-		if (i == (MIN_BIO_PAGES - 1))
-			gfp_mask = (gfp_mask | __GFP_NOWARN) & ~__GFP_WAIT;
+		gfp_mask = (gfp_mask | __GFP_NOWARN) & ~__GFP_WAIT;
 
 		len = (size > PAGE_SIZE) ? PAGE_SIZE : size;
 


