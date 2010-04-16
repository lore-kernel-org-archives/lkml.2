Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431Ab0DPU1y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 16:27:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:34550 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932381Ab0DPU1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 16:27:52 -0400
Subject: Re: Process-shared futexes on hugepages puts the kernel in an
 infinite loop in 2.6.32.11; is this fixed now?
From: Peter Zijlstra <peterz@infradead.org>
To: r6144 <rainy6144@gmail.com>
Cc: linux-kernel@vger.kernel.org, Darren Hart <dvhltc@us.ibm.com>,
       tglx <tglx@linutronix.de>, Mel Gorman <mel@csn.ul.ie>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
In-Reply-To: <1271432722.2564.16.camel@localhost.localdomain>
References: <1271432722.2564.16.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Apr 2010 22:27:48 +0200
Message-ID: <1271449668.1674.466.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-16 at 23:45 +0800, r6144 wrote:
> Hello all,
> 
> I'm having an annoying kernel bug regarding huge pages in Fedora 12:
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=552257
> 
> Basically I want to use huge pages in a multithreaded number crunching
> program, which happens to use process-shared semaphores (because fftw
> does it).  The futex for the semaphore ends up lying on a huge page, and
> I then get an endless loop in get_futex_key(), apparently because the
> anonymous huge page containing the futex does not have a page->mapping.
> A test case is provided in the above link.
> 
> I reported the bug to Fedora bugzilla months ago, but haven't received
> any feedback yet. 

No, it works much better if you simply mail LKML and CC people who work
on the code in question ;-)

>  The Fedora kernel is based on 2.6.32.11, and a
> cursory glance at the 2.6.34-rc3 source does not yield any relevant
> change.
> 
> So, could anyone tell me if the current mainline kernel might act better
> in this respect, before I get around to compiling it?

Right, so I had a quick chat with Mel, and it appears MAP_PRIVATE
hugetlb pages don't have their page->mapping set.

I guess something like the below might work, but I'd really rather not
add hugetlb knowledge to futex.c. Does anybody else have a better idea?
Maybe create something similar to an anon_vma for hugetlb pages?

---
 kernel/futex.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index e7a35f1..b0f1b2d 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -252,7 +252,7 @@ again:
 
 	page = compound_head(page);
 	lock_page(page);
-	if (!page->mapping) {
+	if (!page->mapping && !PageHuge(page)) {
 		unlock_page(page);
 		put_page(page);
 		goto again;
@@ -265,7 +265,7 @@ again:
 	 * it's a read-only handle, it's expected that futexes attach to
 	 * the object not the particular process.
 	 */
-	if (PageAnon(page)) {
+	if (PageAnon(page) || (PageHuge(page) && !page->mapping)) {
 		key->both.offset |= FUT_OFF_MMSHARED; /* ref taken on mm */
 		key->private.mm = mm;
 		key->private.address = address;


