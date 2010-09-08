Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787Ab0IHVfM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 17:35:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35046 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755268Ab0IHVfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 17:35:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "M. Vefa Bicakci" <bicave@superonline.com>
Subject: [PATCH] PM / Hibernate: Avoid hitting OOM during preallocation of memory (was: Re: Important news ...)
Date: Wed, 8 Sep 2010 23:34:01 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-rjw+; KDE/4.4.4; x86_64; ; )
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pm@lists.linux-foundation.org,
        Minchan Kim <minchan.kim@gmail.com>
References: <201009062043.37819.rjw@sisk.pl> <201009072344.53905.rjw@sisk.pl> <4C878818.1070705@superonline.com>
In-Reply-To: <4C878818.1070705@superonline.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009082334.01255.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 08, 2010, M. Vefa Bicakci wrote:
> On 07/09/10 05:44 PM, Rafael J. Wysocki wrote:
> > On Tuesday, September 07, 2010, KOSAKI Motohiro wrote:
> >>> [snip - M. Vefa Bicakci's last e-mail]
> >>
> >> Hm, interesting.
> >>
> >> Rafael's patch seems works intentionally. preallocate much much memory and
> >> release over allocated memory. But on your system, iwl3945 allocate memory 
> >> concurrently. If it try to allocate before the hibernation code release 
> >> extra memory, It may get allocation failure.
> >>
> >> So, I'm not sure wich behavior is desired.
> >>   1) preallocate enough much memory
> >> 	pros) hibernate faster
> >> 	cons) failure risk of network card memory allocation
> >>   2) preallocate small memory
> >> 	pros) hibernate slower
> >> 	cons) don't makes network card memory allocation
> >>
> >> But, I wonder why this kernel thread is not frozen. afaik, hibernation
> >> doesn't need network capability. Is this really intentional?
> > 
> > It's a kernel thread, we don't freeze them by default, only the ones that
> > directly request to be frozen.
> > 
> > BTW, please note that the card probably allocates from normal zone and that
> > may be the reason of the failure.
> > 
> >> Rafael, Could you please explain the design of hibernation and your
> >> intention?
> > 
> > The design of the preallocator is pretty straightforward.
> > 
> > First, if there's already enough free memory to make a copy of all memory in
> > use, we simply allocate as much memory as needed for that copy and return
> > (the size >= saveable condition).
> > 
> > Next, we preallocate as much memory as to accommodate the largest possible
> > image.  A little more than 50% of RAM is preallocated in this step (this causes
> > some pages that were in use before to be freed, so the resulting image size is
> > a little below 50% of RAM).
> > 
> > Next, there is the sysfs file /sys/power/image_size that represents the user's
> > desired size of the image.  If this number is much less than 50% of RAM,
> > we do our best to force the mm subsystem to free more pages so that the
> > resulting image size is possibly close to the desired one.  So, I guess, if
> > Vefa writes a greater number into /sys/power/image_size (this is in bytes),
> > the problems should go away. :-)
> > 
> > Still, I see a way to improve things in my patch.  Namely, I guess the number
> > returned by minimum_image_size() may also be regarded as the number of
> > non-highmem pages we can't free with good approximation.  Thus the
> > second argument of preallocate_image_memory() should be
> > size_normal - "the number returned by minimum_image_size()".
> > 
> > [BTW, there seems to be a bug in minimum_image_size(), because if
> > saveable < size, this means that the minimum image size is equal to saveable
> > rather than 0.  This shouldn't happen, though.]
> > 
> > Vefa, can you please test the patch below with and without the
> > patch at http://lkml.org/lkml/2010/9/5/86 (please don't try to change
> > /sys/power/image_size yet)?
> > 
> > Thanks,
> > Rafael
> 
> Dear Rafael Wysocki,
> 
> I applied the patch below to a clean 2.6.35.4 tree and tested 6 hibernate/thaw
> cycles consecutively. I am happy to report that it works properly.
> 
> Then I applied the patch at http://lkml.org/lkml/2010/9/5/86 (the "vmscan.c
> patch") on top of the tree I used above, and I also ran 6 hibernate/thaw
> cycles. Again, I am happy to report that this combination of patches also
> works properly.

Great, that's encouraging.

> I should note a few things though,
> 
> 1) I don't think I ever changed /sys/power/image_size, so we can rule out the
> possibility of that option changing the results.

Can you please check what value is there in this file?

> 2) With the patch below, for the *first* hibernation operation, the computer
> enters a "thoughtful" state without any disk activity for 6-8 (maybe 10)
> seconds after printing "Preallocating image memory". It works properly after
> the wait however.

That probably is a result of spending time in the memory allocator trying to
reduce the size of the image as much as possible.

> 3) For some reason, with the patch below by itself, or in combination with the
> above-mentioned vmscan.c patch, I haven't seen any page allocation errors
> regarding the iwl3945 driver. To be honest I am not sure why this change
> occurred, but I think you might know.

I think we just keep enough free pages in the normal zone all the time for the
driver to allocate from.

> 4) I made sure that I was not being impatient with the previous snapshot.c
> patch, so I tested that on its own once again, and I confirmed that hibernation
> hangs with the older version of the snapshot.c patch.
> 
> I am very happy that we are getting closer to a solution. Please let me know
> if there is anything I need to test further.

Below is the patch I'd like to apply.  It should work just like the previous
one (there are a few fixes that shouldn't affect the functionality in it), but
please test it if you can.

I think the slowdown you saw in 2) may be eliminated by increasing the
image_size value, so I'm going to prepare a patch that will compute the
value automatically during boot so that it's approximately 50% of RAM.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM / Hibernate: Avoid hitting OOM during preallocation of memory

There is a problem in hibernate_preallocate_memory() that it calls
preallocate_image_memory() with an argument that may be greater than
the total number of available non-highmem memory pages.  If that's
the case, the OOM condition is guaranteed to trigger, which in turn
can cause significant slowdown to occur during hibernation.

To avoid that, make preallocate_image_memory() adjust its argument
before calling preallocate_image_pages(), so that the total number of
saveable non-highem pages left is not less than the minimum size of
a hibernation image.  Change hibernate_preallocate_memory() to try to
allocate from highmem if the number of pages allocated by
preallocate_image_memory() is too low.

Modify free_unnecessary_pages() to take all possible memory
allocation patterns into account.

Reported-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/snapshot.c |   85 ++++++++++++++++++++++++++++++++++++------------
 1 file changed, 65 insertions(+), 20 deletions(-)

Index: linux-2.6/kernel/power/snapshot.c
===================================================================
--- linux-2.6.orig/kernel/power/snapshot.c
+++ linux-2.6/kernel/power/snapshot.c
@@ -1122,9 +1122,19 @@ static unsigned long preallocate_image_p
 	return nr_alloc;
 }
 
-static unsigned long preallocate_image_memory(unsigned long nr_pages)
+static unsigned long preallocate_image_memory(unsigned long nr_pages,
+					      unsigned long avail_normal)
 {
-	return preallocate_image_pages(nr_pages, GFP_IMAGE);
+	unsigned long alloc;
+
+	if (avail_normal <= alloc_normal)
+		return 0;
+
+	alloc = avail_normal - alloc_normal;
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
+	unsigned long alloc, save_highmem, pages_highmem, avail_normal;
 	struct timeval start, stop;
 	int error;
 
@@ -1296,6 +1313,7 @@ int hibernate_preallocate_memory(void)
 		else
 			count += zone_page_state(zone, NR_FREE_PAGES);
 	}
+	avail_normal = count;
 	count += highmem;
 	count -= totalreserve_pages;
 
@@ -1310,12 +1328,21 @@ int hibernate_preallocate_memory(void)
 	 */
 	if (size >= saveable) {
 		pages = preallocate_image_highmem(save_highmem);
-		pages += preallocate_image_memory(saveable - pages);
+		pages += preallocate_image_memory(saveable - pages, avail_normal);
 		goto out;
 	}
 
 	/* Estimate the minimum size of the image. */
 	pages = minimum_image_size(saveable);
+	/*
+	 * To avoid excessive pressure on the normal zone, leave room in it to
+	 * accommodate an image of the minimum size (unless it's already too
+	 * small, in which case don't preallocate pages from it at all).
+	 */
+	if (avail_normal > pages)
+		avail_normal -= pages;
+	else
+		avail_normal = 0;
 	if (size < pages)
 		size = min_t(unsigned long, pages, max_size);
 
@@ -1336,16 +1363,34 @@ int hibernate_preallocate_memory(void)
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
+	pages = preallocate_image_memory(alloc, avail_normal);
+	if (pages < alloc) {
+		/* We have exhausted non-highmem pages, try highmem. */
+		alloc -= pages;
+		pages += pages_highmem;
+		pages_highmem = preallocate_image_highmem(alloc);
+		if (pages_highmem < alloc)
+			goto err_out;
+		pages += pages_highmem;
+		/*
+		 * size is the desired number of saveable pages to leave in
+		 * memory, so try to preallocate (all memory - size) pages.
+		 */
+		alloc = (count - pages) - size;
+		pages += preallocate_image_highmem(alloc);
+	} else {
+		/*
+		 * There are approximately max_size saveable pages at this point
+		 * and we want to reduce this number down to size.
+		 */
+		alloc = max_size - size;
+		size = preallocate_highmem_fraction(alloc, highmem, count);
+		pages_highmem += size;
+		alloc -= size;
+		size = preallocate_image_memory(alloc, avail_normal);
+		pages_highmem += preallocate_image_highmem(alloc - size);
+		pages += pages_highmem + size;
+	}
 
 	/*
 	 * We only need as many page frames for the image as there are saveable
