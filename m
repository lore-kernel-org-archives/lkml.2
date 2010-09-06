Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab0IFTzz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 15:55:55 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54916 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753051Ab0IFTzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 15:55:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [Bisected Regression in 2.6.35] A full tmpfs filesystem causeshibernation to hang
Date: Mon, 6 Sep 2010 21:54:44 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-rjw+; KDE/4.4.4; x86_64; ; )
Cc: "M. Vefa Bicakci" <bicave@superonline.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pm@lists.linux-foundation.org,
        Minchan Kim <minchan.kim@gmail.com>
References: <20100903105216.B65C.A69D9226@jp.fujitsu.com> <20100906090528.C8A9.A69D9226@jp.fujitsu.com> <201009062046.43513.rjw@sisk.pl>
In-Reply-To: <201009062046.43513.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009062154.44643.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 06, 2010, Rafael J. Wysocki wrote:
> On Monday, September 06, 2010, KOSAKI Motohiro wrote:
> > > > ok, thanks. probably I've catched your point. please feel free to use my reviewed-by
> > > > for your fix.
> > > 
> > > Thanks.
> > > 
> > > In the meantime, though, I prepared a patch that should address the issue
> > > entirely.  The patch is appended and if it looks good to you, I'd rather use it
> > > instead of the previous one (it is still untested).
> > 
> > Yeah, this one looks nicer to me :)
> > 
> > Thanks, rafael!
> 
> OK, I'll put it into my linux-next branch, then.
> 
> Probably, though, I should modify the changelog, because what it really does
> is to check if it makes sense to try to allocat from non-highmem pages, but it
> doesn't really prevent the OOM from occuring.

For completness, below is the patch with the new changelog.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM / Hibernate: Avoid hitting OOM during preallocation of memory

There is a problem in hibernate_preallocate_memory() that it calls
preallocate_image_memory() with an argument that may be greater than
the total number of non-highmem memory pages that haven't been
already preallocated.  If that's the case, the OOM condition is
guaranteed to trigger, which in turn can cause significant slowdown
to occur.

To avoid that, make preallocate_image_memory() adjust its argument
before calling preallocate_image_pages(), so that it doesn't exceed
the number of non-highmem pages that weren't preallocated previously.
Change hibernate_preallocate_memory() to try to allocate from highmem
if the number of pages allocated by preallocate_image_memory() is too
low.  Modify free_unnecessary_pages() to take all possible memory
allocation patterns into account.

Reported-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/snapshot.c |   66 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 46 insertions(+), 20 deletions(-)

Index: linux-2.6/kernel/power/snapshot.c
===================================================================
--- linux-2.6.orig/kernel/power/snapshot.c
+++ linux-2.6/kernel/power/snapshot.c
@@ -1122,9 +1122,19 @@ static unsigned long preallocate_image_p
 	return nr_alloc;
 }
 
-static unsigned long preallocate_image_memory(unsigned long nr_pages)
+static unsigned long preallocate_image_memory(unsigned long nr_pages,
+					      unsigned long size_normal)
 {
-	return preallocate_image_pages(nr_pages, GFP_IMAGE);
+	unsigned long alloc;
+
+	if (size_normal <= alloc_normal)
+		return 0;
+
+	alloc = size_normal - alloc_normal;
+	if (nr_pages < alloc)
+		alloc = nr_pages;
+
+	return preallocate_image_pages(alloc, GFP_IMAGE);
 }
 
 #ifdef CONFIG_HIGHMEM
@@ -1170,15 +1180,22 @@ static inline unsigned long preallocate_
  */
 static void free_unnecessary_pages(void)
 {
-	unsigned long save_highmem, to_free_normal, to_free_highmem;
+	unsigned long save, to_free_normal, to_free_highmem;
 
-	to_free_normal = alloc_normal - count_data_pages();
-	save_highmem = count_highmem_pages();
-	if (alloc_highmem > save_highmem) {
-		to_free_highmem = alloc_highmem - save_highmem;
+	save = count_data_pages();
+	if (alloc_normal >= save) {
+		to_free_normal = alloc_normal - save;
+		save = 0;
+	} else {
+		to_free_normal = 0;
+		save -= alloc_normal;
+	}
+	save += count_highmem_pages();
+	if (alloc_highmem >= save) {
+		to_free_highmem = alloc_highmem - save;
 	} else {
 		to_free_highmem = 0;
-		to_free_normal -= save_highmem - alloc_highmem;
+		to_free_normal -= save - alloc_highmem;
 	}
 
 	memory_bm_position_reset(&copy_bm);
@@ -1259,7 +1276,7 @@ int hibernate_preallocate_memory(void)
 {
 	struct zone *zone;
 	unsigned long saveable, size, max_size, count, highmem, pages = 0;
-	unsigned long alloc, save_highmem, pages_highmem;
+	unsigned long alloc, save_highmem, pages_highmem, size_normal;
 	struct timeval start, stop;
 	int error;
 
@@ -1296,6 +1313,7 @@ int hibernate_preallocate_memory(void)
 		else
 			count += zone_page_state(zone, NR_FREE_PAGES);
 	}
+	size_normal = count;
 	count += highmem;
 	count -= totalreserve_pages;
 
@@ -1310,7 +1328,7 @@ int hibernate_preallocate_memory(void)
 	 */
 	if (size >= saveable) {
 		pages = preallocate_image_highmem(save_highmem);
-		pages += preallocate_image_memory(saveable - pages);
+		pages += preallocate_image_memory(saveable - pages, size_normal);
 		goto out;
 	}
 
@@ -1336,16 +1354,24 @@ int hibernate_preallocate_memory(void)
 	 */
 	pages_highmem = preallocate_image_highmem(highmem / 2);
 	alloc = (count - max_size) - pages_highmem;
-	pages = preallocate_image_memory(alloc);
-	if (pages < alloc)
-		goto err_out;
-	size = max_size - size;
-	alloc = size;
-	size = preallocate_highmem_fraction(size, highmem, count);
-	pages_highmem += size;
-	alloc -= size;
-	pages += preallocate_image_memory(alloc);
-	pages += pages_highmem;
+	pages = preallocate_image_memory(alloc, size_normal);
+	if (pages < alloc) {
+		/* We have exhausted non-highmem pages, try highmem. */
+		alloc -= pages;
+		pages = preallocate_image_highmem(alloc);
+		if (pages < alloc)
+			goto err_out;
+		pages += preallocate_image_highmem(max_size - size);
+	} else {
+		size = max_size - size;
+		alloc = size;
+		size = preallocate_highmem_fraction(size, highmem, count);
+		pages_highmem += size;
+		alloc -= size;
+		size = preallocate_image_memory(alloc, size_normal);
+		pages_highmem += preallocate_image_highmem(alloc - size);
+		pages += pages_highmem + size;
+	}
 
 	/*
 	 * We only need as many page frames for the image as there are saveable
