Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab0IGVp4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 17:45:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58728 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164Ab0IGVpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 17:45:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "M. Vefa Bicakci" <bicave@superonline.com>
Subject: Re: Important news regarding the two different patches
Date: Tue, 7 Sep 2010 23:44:53 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pm@lists.linux-foundation.org,
        Minchan Kim <minchan.kim@gmail.com>
References: <201009062043.37819.rjw@sisk.pl> <4C8596B1.6010005@superonline.com> <20100907104218.C8EF.A69D9226@jp.fujitsu.com>
In-Reply-To: <20100907104218.C8EF.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009072344.53905.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 07, 2010, KOSAKI Motohiro wrote:
> > Hello,
> > 
> > When I apply both of the patches, then I don't get any hangs with
> > hibernation. However, I do get another problem, which I am not sure
> > is related or not. I should note that I haven't experienced this
> > with only the vmscan.c patch, but maybe I haven't repeated my test
> > enough times.
> > 
> > One test consists of an automated run of 7 hibernate/thaw cycles. 
> > 
> > Here's what I got in dmesg in two of the iterations in one test.
> > Sorry for the long e-mail and the long lines.
> > 
> > === 8< ===
> > [  166.512085] PM: Hibernation mode set to 'reboot'
> > [  166.516503] PM: Marking nosave pages: 000000000009f000 - 0000000000100000
> > [  166.517654] PM: Basic memory bitmaps created
> > [  166.518781] PM: Syncing filesystems ... done.
> > [  166.546308] Freezing user space processes ... (elapsed 0.01 seconds) done.
> > [  166.559596] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
> > [  166.571649] PM: Preallocating image memory... 
> > [  185.712457] iwl3945: page allocation failure. order:0, mode:0xd0
> > [  185.714564] Pid: 1225, comm: iwl3945 Not tainted 2.6.35.4-test-mm5v2-vmscan+snapshot-dirty #7
> > [  185.715741] Call Trace:
> > [  185.716853]  [<c019aa67>] ? __alloc_pages_nodemask+0x577/0x630
> > [  185.718126]  [<f8a562c5>] ? iwl3945_rx_allocate+0x75/0x240 [iwl3945]
> > [  185.719379]  [<c03f0516>] ? schedule+0x356/0x730
> > [  185.720556]  [<f8a56d50>] ? iwl3945_rx_replenish+0x20/0x50 [iwl3945]
> > [  185.721914]  [<f8a56dbc>] ? iwl3945_bg_rx_replenish+0x3c/0x50 [iwl3945]
> > [  185.723929]  [<c014b167>] ? worker_thread+0x117/0x1f0
> > [  185.725745]  [<f8a56d80>] ? iwl3945_bg_rx_replenish+0x0/0x50 [iwl3945]
> > [  185.727097]  [<c014ebd0>] ? autoremove_wake_function+0x0/0x40
> > [  185.728468]  [<c014b050>] ? worker_thread+0x0/0x1f0
> > [  185.730235]  [<c014e854>] ? kthread+0x74/0x80
> > [  185.731601]  [<c014e7e0>] ? kthread+0x0/0x80
> > [  185.732919]  [<c0103cb6>] ? kernel_thread_helper+0x6/0x10
> 
> Hm, interesting.
> 
> Rafael's patch seems works intentionally. preallocate much much memory and
> release over allocated memory. But on your system, iwl3945 allocate memory 
> concurrently. If it try to allocate before the hibernation code release 
> extra memory, It may get allocation failure.
> 
> So, I'm not sure wich behavior is desired.
>   1) preallocate enough much memory
> 	pros) hibernate faster
> 	cons) failure risk of network card memory allocation
>   2) preallocate small memory
> 	pros) hibernate slower
> 	cons) don't makes network card memory allocation
> 
> But, I wonder why this kernel thread is not frozen. afaik, hibernation
> doesn't need network capability. Is this really intentional?

It's a kernel thread, we don't freeze them by default, only the ones that
directly request to be frozen.

BTW, please note that the card probably allocates from normal zone and that
may be the reason of the failure.

> Rafael, Could you please explain the design of hibernation and your
> intention?

The design of the preallocator is pretty straightforward.

First, if there's already enough free memory to make a copy of all memory in
use, we simply allocate as much memory as needed for that copy and return
(the size >= saveable condition).

Next, we preallocate as much memory as to accommodate the largest possible
image.  A little more than 50% of RAM is preallocated in this step (this causes
some pages that were in use before to be freed, so the resulting image size is
a little below 50% of RAM).

Next, there is the sysfs file /sys/power/image_size that represents the user's
desired size of the image.  If this number is much less than 50% of RAM,
we do our best to force the mm subsystem to free more pages so that the
resulting image size is possibly close to the desired one.  So, I guess, if
Vefa writes a greater number into /sys/power/image_size (this is in bytes),
the problems should go away. :-)

Still, I see a way to improve things in my patch.  Namely, I guess the number
returned by minimum_image_size() may also be regarded as the number of
non-highmem pages we can't free with good approximation.  Thus the
second argument of preallocate_image_memory() should be
size_normal - "the number returned by minimum_image_size()".

[BTW, there seems to be a bug in minimum_image_size(), because if
saveable < size, this means that the minimum image size is equal to saveable
rather than 0.  This shouldn't happen, though.]

Vefa, can you please test the patch below with and without the
patch at http://lkml.org/lkml/2010/9/5/86 (please don't try to change
/sys/power/image_size yet)?

Thanks,
Rafael


---
 kernel/power/snapshot.c |   75 +++++++++++++++++++++++++++++++++++-------------
 1 file changed, 55 insertions(+), 20 deletions(-)

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
+	 * accommodate the image of the minimum size (unless it's already too
+	 * small, in which case don't preallocate pages from it at all).
+	 */
+	if (avail_normal > pages)
+		avail_normal -= pages;
+	else
+		avail_normal = 0;
 	if (size < pages)
 		size = min_t(unsigned long, pages, max_size);
 
@@ -1336,16 +1363,24 @@ int hibernate_preallocate_memory(void)
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
+		size = preallocate_image_memory(alloc, avail_normal);
+		pages_highmem += preallocate_image_highmem(alloc - size);
+		pages += pages_highmem + size;
+	}
 
 	/*
 	 * We only need as many page frames for the image as there are saveable
