Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab0JKOag (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 10:30:36 -0400
Received: from gir.skynet.ie ([193.1.99.77]:39700 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754713Ab0JKOaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 10:30:35 -0400
Date: Mon, 11 Oct 2010 15:30:22 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: pacman@kosh.dhis.org
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: memory corrupting bug, bisected to 6dda9d55
Message-ID: <20101011143022.GD30667@csn.ul.ie>
References: <20101009095718.1775.qmail@kosh.dhis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20101009095718.1775.qmail@kosh.dhis.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 09, 2010 at 04:57:18AM -0500, pacman@kosh.dhis.org wrote:
> (What a big Cc: list... scripts/get_maintainer.pl made me do it.)
> 
> This will be a long story with a weak conclusion, sorry about that, but it's
> been a long bug-hunt.
> 
> With recent kernels I've seen a bug that appears to corrupt random 4-byte
> chunks of memory. It's not easy to reproduce. It seems to happen only once
> per boot, pretty quickly after userspace has gotten started, and sometimes it
> doesn't happen at all.
> 

A corruption of 4 bytes could be consistent with a pointer value being
written to an incorrect location.

> Symptoms that I have seen multiple times include:
> #1. Oops during modprobe usbcore (in apply_relocate_add)
> #2. (more frequent than #1) e2fsck dies of SIGSEGV or SIGILL
> 
> I gdb'ed one of the e2fsck crashes and found that the SIGILL was indeed an
> illegal instruction. A single instruction had been replaced by 4 seemingly
> random bytes which did not form a valid instruction. So I began doing an md5
> check of e2fsck and its dependent libs on every boot.
> 
> This made detection easier, as I found that about 50% of the time, booting a
> bad kernel would cause an md5 mismatch in /lib/libe2p.so.2.3. None of this
> corruption was actually present on disk. I was always able to boot my old
> known-good kernel and md5 all the suspect files, and they were always fine.
> 
> Using that test procedure, all the bad kernels showed the symptom on the
> second boot, and all the good kernels had 6 consecutive boots without any
> trouble. The git bisect ended here:
> 
>   commit 6dda9d55bf545013597724bf0cd79d01bd2bd944
>   Author: Corrado Zoccolo <czoccolo@gmail.com>
> 
>       page allocator: reduce fragmentation in buddy allocator by adding buddies that are merging to the tail of the free lists
> 
>    mm/page_alloc.c |   30 +++++++++++++++++++++++++-----
>    1 files changed, 25 insertions(+), 5 deletions(-)
> 
> which is way back before 2.6.35-rc1.
> 
> Since this is code that has obviously been tested by a lot of people and
> hasn't hurt most of them, I figure it must be very sensitive to hardware
> and/or kernel config options. I also considered the possibility of a compiler
> bug. Most of my testing was done with gcc 4.3.2, but I also tried 4.4.2 and
> that didn't make a difference.
> 
> This is all happening on Pegasos2 (32-bit PPC).
> 
> The latest kernel I've confirmed the bug on was 2.6.35.7. The bad commit
> reverts cleanly on top of 2.6.35.7, and that results in a good kernel as
> expected. (I can't test the latest Linus git tree until I solve the unrelated
> bug that has apparently killed the keyboard driver.)
> 
> Can someone familiar with the code take a fresh look at 6dda9d55 and spot a
> bug? If not, what should I try next?
> 

I think there is a slight bug but but not one that would cause corruption.

	if ((order < MAX_ORDER-1) && pfn_valid_within(page_to_pfn(buddy))) {

That looks like it can result in checking the buddy for an order-(MAX_ORDER-1)
page which is a bit bogus. Thing is, it should be harmless because there
isn't an unusual write made. In case it's some weird compiler optimisation
though, could you try this?

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 502a882..5b0eb8c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -530,7 +530,7 @@ static inline void __free_one_page(struct page *page,
 	 * so it's less likely to be used soon and more likely to be merged
 	 * as a higher order page
 	 */
-	if ((order < MAX_ORDER-1) && pfn_valid_within(page_to_pfn(buddy))) {
+	if ((order < MAX_ORDER-2) && pfn_valid_within(page_to_pfn(buddy))) {
 		struct page *higher_page, *higher_buddy;
 		combined_idx = __find_combined_index(page_idx, order);
 		higher_page = page + combined_idx - page_idx;
