Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066Ab2BXNeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 08:34:19 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:60065 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755195Ab2BXNeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 08:34:17 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of daniel@ffwll.ch designates 10.180.104.4 as permitted sender) smtp.mail=daniel@ffwll.ch; dkim=pass header.i=daniel@ffwll.ch
Date: Fri, 24 Feb 2012 14:34:31 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>
Subject: Re: [PATCH] mm: extend prefault helpers to fault in more than
 PAGE_SIZE
Message-ID: <20120224133431.GA3913@phenom.ffwll.local>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>
References: <1329393696-4802-1-git-send-email-daniel.vetter@ffwll.ch>
 <1329393696-4802-2-git-send-email-daniel.vetter@ffwll.ch>
 <20120223143658.0e318ce2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120223143658.0e318ce2.akpm@linux-foundation.org>
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 02:36:58PM -0800, Andrew Morton wrote:
> On Thu, 16 Feb 2012 13:01:36 +0100
> Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> 
> > drm/i915 wants to read/write more than one page in its fastpath
> > and hence needs to prefault more than PAGE_SIZE bytes.
> > 
> > I've checked the callsites and they all already clamp size when
> > calling fault_in_pages_* to the same as for the subsequent
> > __copy_to|from_user and hence don't rely on the implicit clamping
> > to PAGE_SIZE.
> > 
> > Also kill a copy&pasted spurious space in both functions while at it.
> >
> > ...
> >
> > --- a/include/linux/pagemap.h
> > +++ b/include/linux/pagemap.h
> > @@ -408,6 +408,7 @@ extern void add_page_wait_queue(struct page *page, wait_queue_t *waiter);
> >  static inline int fault_in_pages_writeable(char __user *uaddr, int size)
> >  {
> >  	int ret;
> > +	char __user *end = uaddr + size - 1;
> >  
> >  	if (unlikely(size == 0))
> >  		return 0;
> > @@ -416,17 +417,20 @@ static inline int fault_in_pages_writeable(char __user *uaddr, int size)
> >  	 * Writing zeroes into userspace here is OK, because we know that if
> >  	 * the zero gets there, we'll be overwriting it.
> >  	 */
> > -	ret = __put_user(0, uaddr);
> > +	while (uaddr <= end) {
> > +		ret = __put_user(0, uaddr);
> > +		if (ret != 0)
> > +			return ret;
> > +		uaddr += PAGE_SIZE;
> > +	}
> 
> The callsites in filemap.c are pretty hot paths, which is why this
> thing remains explicitly inlined.  I think it would be worth adding a
> bit of code here to avoid adding a pointless test-n-branch and larger
> cache footprint to read() and write().
> 
> A way of doing that is to add another argument to these functions, say
> "bool multipage".  Change the code to do
> 
> 	if (multipage) {
> 		while (uaddr <= end) {
> 			...
> 		}
> 	}
> 
> and change the callsites to pass in constant "true" or "false".  Then
> compile it up and manually check that the compiler completely removed
> the offending code from the filemap.c callsites.
> 
> Wanna have a think about that?  If it all looks OK then please be sure
> to add code comments explaining why we did this.

I wasn't really happy with the added branch either, but failed to come up
with a trick to avoid it. Imho adding new _multipage variants of these
functions instead of adding a constant argument is simpler because the
functions don't really share much thanks to the block below. I'll see what
it looks like (and obviously add a comment explaining what's going on).

> >  	if (ret == 0) {
> > -		char __user *end = uaddr + size - 1;
> > -
> >  		/*
> >  		 * If the page was already mapped, this will get a cache miss
> >  		 * for sure, so try to avoid doing it.
> >  		 */
> > -		if (((unsigned long)uaddr & PAGE_MASK) !=
> > +		if (((unsigned long)uaddr & PAGE_MASK) ==
> >  				((unsigned long)end & PAGE_MASK))
> 
> Maybe I'm having a dim day, but I don't immediately see why != got
> turned into ==.

Because of the loop uaddr will now point one page beyond the last
prefaulted page. To check whether end spilled into a new page we therefore
need to check whether uaddr and end are in the same pfn. Before uaddr
wasn't changed and hence the checking for a different pfn worked
correctly.

> Once we have this settled I'd suggest that the patch be carried in
> whatever-git-tree-needs-it.

Thanks for the comments.

Yours, Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
