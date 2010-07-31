Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856Ab0GaBDL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 21:03:11 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:49400 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab0GaBDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 21:03:09 -0400
Subject: Re: [PATCH]: Compress hibernation image with LZO (in-kernel)
From: Bojan Smojver <bojan@rexursive.com>
To: Nigel Cunningham <nigel@tuxonice.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4C5362E7.3000706@tuxonice.net>
References: <1280465201.2600.10.camel@shrek.rexursive.com>
	 <1280486667.2608.1.camel@shrek.rexursive.com>
	 <4C534C9D.8000600@tuxonice.net>
	 <1280532174.2583.1.camel@shrek.rexursive.com>
	 <4C5362E7.3000706@tuxonice.net>
Content-Type: multipart/mixed; boundary="=-sc7A1qGEcx4eI5ZVenHY"
Date: Sat, 31 Jul 2010 11:03:04 +1000
Message-ID: <1280538184.2583.11.camel@shrek.rexursive.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-sc7A1qGEcx4eI5ZVenHY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Sat, 2010-07-31 at 09:40 +1000, Nigel Cunningham wrote:

> How about vmallocing the cmp as well? That would greatly reduce the 
> potential for page allocation failures while still letting you use an 
> order 6 area.

In save_image(), that worked. In load_image() it would cause a crash
(something about kernel not being able to satisfy paging request). So, I
just made it __get_free_pages() instead. But, yeah good point.

Keep in mind that I have absolutely no idea how kernel memory allocation
works. I'm kinda coping and pasting code and hoping it doesn't crash :-)

> > PS. I guess with this, read_sync can simply disappear as well.
> 
> I haven't looked at the code for a while, but it might still be needed 
> for the header? I know that in TuxOnIce, I need to read the first page 
> synchronously when bootstrapping reading the image (can't read the next 
> page until you know where it is, and its location is on the first page). 
> Since swsusp uses those index pages, I think it would have the same 
> issue - they would need to be read before it could read the following 
> pages. Of course I'm going off memory :)

I think it can go, because the header is already read/written with &bio
set to NULL (sync read). See patch to remove read_sync.

-- 
Bojan

--=-sc7A1qGEcx4eI5ZVenHY
Content-Disposition: attachment; filename="hibernate-no-sync_read.patch"
Content-Type: text/x-patch; name="hibernate-no-sync_read.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

diff --git a/kernel/power/power.h b/kernel/power/power.h
index 006270f..a760cf8 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -103,10 +103,6 @@ struct snapshot_handle {
 	void		*buffer;	/* address of the block to read from
 					 * or write to
 					 */
-	int		sync_read;	/* Set to one to notify the caller of
-					 * snapshot_write_next() that it may
-					 * need to call wait_on_bio_chain()
-					 */
 };
 
 /* This macro returns the address from/to which the caller of
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 25ce010..f24ee24 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -2135,8 +2135,6 @@ int snapshot_write_next(struct snapshot_handle *handle)
 	if (handle->cur > 1 && handle->cur > nr_meta_pages + nr_copy_pages)
 		return 0;
 
-	handle->sync_read = 1;
-
 	if (!handle->cur) {
 		if (!buffer)
 			/* This makes the buffer be freed by swsusp_free() */
@@ -2169,7 +2167,6 @@ int snapshot_write_next(struct snapshot_handle *handle)
 			memory_bm_position_reset(&orig_bm);
 			restore_pblist = NULL;
 			handle->buffer = get_buffer(&orig_bm, &ca);
-			handle->sync_read = 0;
 			if (IS_ERR(handle->buffer))
 				return PTR_ERR(handle->buffer);
 		}
@@ -2178,8 +2175,6 @@ int snapshot_write_next(struct snapshot_handle *handle)
 		handle->buffer = get_buffer(&orig_bm, &ca);
 		if (IS_ERR(handle->buffer))
 			return PTR_ERR(handle->buffer);
-		if (handle->buffer != buffer)
-			handle->sync_read = 0;
 	}
 	handle->cur++;
 	return PAGE_SIZE;

--=-sc7A1qGEcx4eI5ZVenHY--

