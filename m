Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594Ab0HBBcl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 21:32:41 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58799 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab0HBBck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 21:32:40 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 2 Aug 2010 10:27:50 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Bojan Smojver <bojan@rexursive.com>
Cc: Nigel Cunningham <nigel@tuxonice.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: Compress hibernation image with LZO (in-kernel)
Message-Id: <20100802102750.7d414819.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1280712068.2671.0.camel@shrek.rexursive.com>
References: <1280465201.2600.10.camel@shrek.rexursive.com>
	<1280486667.2608.1.camel@shrek.rexursive.com>
	<4C534C9D.8000600@tuxonice.net>
	<1280532174.2583.1.camel@shrek.rexursive.com>
	<4C5362E7.3000706@tuxonice.net>
	<1280538184.2583.11.camel@shrek.rexursive.com>
	<4C537A01.5040808@tuxonice.net>
	<1280540035.2658.5.camel@shrek.rexursive.com>
	<1280551286.3097.6.camel@shrek.rexursive.com>
	<20100802091752.3c9f180d.kamezawa.hiroyu@jp.fujitsu.com>
	<1280710453.2727.8.camel@shrek.rexursive.com>
	<20100802101058.d4f1c7b6.kamezawa.hiroyu@jp.fujitsu.com>
	<1280712068.2671.0.camel@shrek.rexursive.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Aug 2010 11:21:08 +1000
Bojan Smojver <bojan@rexursive.com> wrote:

> On Mon, 2010-08-02 at 10:10 +0900, KAMEZAWA Hiroyuki wrote:
> > Why swsusp can avoid memory leak is that it records which
> > pages should be freed after resume in the bitmap, which will be saved
> > to image header(?) 
> 
> Right. So, are you saying that all allocations in save_image() should be
> done using __get_free_page() or __get_free_pages() and not with
> vmalloc()?
> 
I don't say so but a consideration about following is required.
(And it's good to write "we're safe because...as comment")

 1. Information about pointers used for vmalloc are saved into image.
 2. Information(1) is properly recovered after resume and we can free it.
 3. No more allocation will happen once we start wriritng to the disk.

Then, vmalloc() area itself's information will be saved as
  "this vmalloc area is used"

and, at resume, recoreved as
  "this vmalloc area is used"

Then, you can free it because you remember pointers.

Then, you should make 

@@ -372,6 +380,38 @@ static int save_image(struct swap_map_handle *handle,
 	struct bio *bio;
 	struct timeval start;
 	struct timeval stop;
+	size_t ul, cl;
+	unsigned char *unc, *cmp, *wrk, *page; 

as global variable. Because global variables will be saved as it is,
you can find it after resume and free used vmalloc() buffers.

Maybe freeing it at swsusp_free() will be clean.


Thanks,
-Kame

