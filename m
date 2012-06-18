Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688Ab2FRAdK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 20:33:10 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:47657 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966Ab2FRAdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 20:33:08 -0400
Message-ID: <1339979586.1666.13.camel@shrek.rexursive.com>
Subject: Re: [PATCH]: In kernel hibernation, suspend to both
From: Bojan Smojver <bojan@rexursive.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Borislav Petkov <bp@alien8.de>, Alan Stern <stern@rowland.harvard.edu>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Date: Mon, 18 Jun 2012 10:33:06 +1000
In-Reply-To: <201206172221.55493.rjw@sisk.pl>
References: <90304ca8-31ef-4919-bf9d-e0498b0de87b@email.android.com>
	 <20120616230706.GA26955@liondog.tnic>
	 <43c43f4c-6eab-42ca-a7b0-5ce274697287@email.android.com>
	 <201206172221.55493.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.2 (3.4.2-1.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-06-17 at 22:21 +0200, Rafael J. Wysocki wrote:
> Yeah, that will do.

Something like this maybe. I didn't really test this, so Borislav,
please let me know whether this is something that may works for you.

-------------------------
 kernel/power/swap.c |   33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 11e22c0..c24d354 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -448,9 +448,9 @@ static int save_image(struct swap_map_handle *handle,
 	struct timeval start;
 	struct timeval stop;
 
-	printk(KERN_INFO "PM: Saving image data pages (%u pages) ...     ",
+	printk(KERN_INFO "PM: Saving image data pages (%u pages) ",
 		nr_to_write);
-	m = nr_to_write / 100;
+	m = nr_to_write / 10;
 	if (!m)
 		m = 1;
 	nr_pages = 0;
@@ -464,7 +464,7 @@ static int save_image(struct swap_map_handle *handle,
 		if (ret)
 			break;
 		if (!(nr_pages % m))
-			printk(KERN_CONT "\b\b\b\b%3d%%", nr_pages / m);
+			printk(KERN_CONT ".");
 		nr_pages++;
 	}
 	err2 = hib_wait_on_bio_chain(&bio);
@@ -472,7 +472,7 @@ static int save_image(struct swap_map_handle *handle,
 	if (!ret)
 		ret = err2;
 	if (!ret)
-		printk(KERN_CONT "\b\b\b\bdone\n");
+		printk(KERN_CONT " done.\n");
 	else
 		printk(KERN_CONT "\n");
 	swsusp_show_speed(&start, &stop, nr_to_write, "Wrote");
@@ -668,9 +668,9 @@ static int save_image_lzo(struct swap_map_handle *handle,
 
 	printk(KERN_INFO
 		"PM: Using %u thread(s) for compression.\n"
-		"PM: Compressing and saving image data (%u pages) ...     ",
+		"PM: Compressing and saving image data (%u pages) ",
 		nr_threads, nr_to_write);
-	m = nr_to_write / 100;
+	m = nr_to_write / 10;
 	if (!m)
 		m = 1;
 	nr_pages = 0;
@@ -690,8 +690,7 @@ static int save_image_lzo(struct swap_map_handle *handle,
 				       data_of(*snapshot), PAGE_SIZE);
 
 				if (!(nr_pages % m))
-					printk(KERN_CONT "\b\b\b\b%3d%%",
-				               nr_pages / m);
+					printk(KERN_CONT ".");
 				nr_pages++;
 			}
 			if (!off)
@@ -762,7 +761,7 @@ out_finish:
 	if (!ret)
 		ret = err2;
 	if (!ret) {
-		printk(KERN_CONT "\b\b\b\bdone\n");
+		printk(KERN_CONT " done.\n");
 	} else {
 		printk(KERN_CONT "\n");
 	}
@@ -973,9 +972,9 @@ static int load_image(struct swap_map_handle *handle,
 	int err2;
 	unsigned nr_pages;
 
-	printk(KERN_INFO "PM: Loading image data pages (%u pages) ...     ",
+	printk(KERN_INFO "PM: Loading image data pages (%u pages) ",
 		nr_to_read);
-	m = nr_to_read / 100;
+	m = nr_to_read / 10;
 	if (!m)
 		m = 1;
 	nr_pages = 0;
@@ -993,7 +992,7 @@ static int load_image(struct swap_map_handle *handle,
 		if (ret)
 			break;
 		if (!(nr_pages % m))
-			printk("\b\b\b\b%3d%%", nr_pages / m);
+			printk(".");
 		nr_pages++;
 	}
 	err2 = hib_wait_on_bio_chain(&bio);
@@ -1001,7 +1000,7 @@ static int load_image(struct swap_map_handle *handle,
 	if (!ret)
 		ret = err2;
 	if (!ret) {
-		printk("\b\b\b\bdone\n");
+		printk(" done.\n");
 		snapshot_write_finalize(snapshot);
 		if (!snapshot_image_loaded(snapshot))
 			ret = -ENODATA;
@@ -1185,9 +1184,9 @@ static int load_image_lzo(struct swap_map_handle *handle,
 
 	printk(KERN_INFO
 		"PM: Using %u thread(s) for decompression.\n"
-		"PM: Loading and decompressing image data (%u pages) ...     ",
+		"PM: Loading and decompressing image data (%u pages) ",
 		nr_threads, nr_to_read);
-	m = nr_to_read / 100;
+	m = nr_to_read / 10;
 	if (!m)
 		m = 1;
 	nr_pages = 0;
@@ -1319,7 +1318,7 @@ static int load_image_lzo(struct swap_map_handle *handle,
 				       data[thr].unc + off, PAGE_SIZE);
 
 				if (!(nr_pages % m))
-					printk("\b\b\b\b%3d%%", nr_pages / m);
+					printk(".");
 				nr_pages++;
 
 				ret = snapshot_write_next(snapshot);
@@ -1344,7 +1343,7 @@ out_finish:
 	}
 	do_gettimeofday(&stop);
 	if (!ret) {
-		printk("\b\b\b\bdone\n");
+		printk(" done.\n");
 		snapshot_write_finalize(snapshot);
 		if (!snapshot_image_loaded(snapshot))
 			ret = -ENODATA;
-------------------------

-- 
Bojan

