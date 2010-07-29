Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199Ab0G2XbV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 19:31:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45078 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755451Ab0G2XbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 19:31:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Hugh Dickins <hughd@google.com>
Subject: Re: Memory corruption during hibernation since 2.6.31
Date: Fri, 30 Jul 2010 01:29:33 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc6-rjw+; KDE/4.4.4; x86_64; ; )
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Ondrej Zary <linux@rainbow-software.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@in.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
References: <201007282334.08063.rjw@sisk.pl> <20100729142429.58b49dce.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.1.00.1007291027410.7491@tigran.mtv.corp.google.com>
In-Reply-To: <alpine.DEB.1.00.1007291027410.7491@tigran.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007300129.33912.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 29, 2010, Hugh Dickins wrote:
> On Thu, 29 Jul 2010, KAMEZAWA Hiroyuki wrote:
> > On Thu, 29 Jul 2010 14:23:33 +0900 (JST)
> > KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> > 
> > > Can you please add explicit commenting in the code?
> > > 
> > How about this ?
> > ==
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > At hibernation, all pages-should-be-saved are written into a image (here, swap).
> > Then, swap_map[], memmap etcs are also saved into disks.
> > 
> > But, swap allocation happens one by one. So, the final image of swap_map[] is
> > different from saved one and the commit c9e444103b5e7a5a3519f9913f59767f92e33baf
> > changes page's state while assiging swap. Because memory can be modified in
> > hibernation is only not-to-be-save memory. it's a breakage.
> > 
> > This patch fixes it by disabling swap entry reuse at hibernation.
> > 
> > 
> > 
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > ---
> >  mm/swapfile.c |    4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > Index: linux-2.6.34.org/mm/swapfile.c
> > ===================================================================
> > --- linux-2.6.34.org.orig/mm/swapfile.c
> > +++ linux-2.6.34.org/mm/swapfile.c
> > @@ -315,8 +315,15 @@ checks:
> >  	if (offset > si->highest_bit)
> >  		scan_base = offset = si->lowest_bit;
> >  
> > -	/* reuse swap entry of cache-only swap if not busy. */
> > -	if (vm_swap_full() && si->swap_map[offset] == SWAP_HAS_CACHE) {
> > +	/*
> > + 	 * reuse swap entry of cache-only swap if not busy &&
> > + 	 * when we're called via pageout(). At hibernation, swap-reuse
> > + 	 * is harmful because it changes memory status...which may
> > + 	 * be saved already.
> > + 	 */
> > +	if (vm_swap_full()
> > +		&& usage == SWAP_HAS_CACHE
> > +		&& si->swap_map[offset] == SWAP_HAS_CACHE) {
> >  		int swap_was_freed;
> >  		spin_unlock(&swap_lock);
> >  		swap_was_freed = __try_to_reclaim_swap(si, offset);
> > 
> > --
> 
> KAMEZAWA-San, that is a brilliant realization, I salute you.
> 
> So, in between snapshotting the image and actually hibernating, we have
> two parallel universes, one frozen in the image, the other writing that
> out to swap: with the danger that the latter (which is about to die)
> will introduce fatal inconsistencies in the former by placing pages in
> swap locations innocently reallocated from it.  (Excuse me while I go
> write the movie script.)
> 
> I'd never got to think about that before.
> 
> Your fix is neat though hacky (it's somewhat of a coincidence that the
> usage arg happens to distinguish the hibernation case), and should be
> enough to fix "your" regression, but is it really enough?
> 
> I'm worrying about the try_to_free_swap() calls in shrink_page_list():
> can't those get called from direct reclaim (even if GFP_NOIO), and can't
> direct reclaim get invoked from somewhere in the I/O path below
> swap_writepage(), used for writing out the hibernation image?
> 
> Direct reclaim because kswapd does set_freezable(), so should itself
> be out of the picture.  But we cannot freeze writing the hibernation
> image, and its occasional need for memory, so maybe a different approach
> is required.

We preallocate memory for the I/O related to the writing of hibernation
images, so swapping things out shouldn't be necessary at that time just for
this purpose.  The I/O itself is done directly at the block layer level and it
will never be frozen, because it is done by the hibernate process itself.

> I've CC'ed Andrea because we were having an offline conversation about
> whether ksmd (and his khugepaged) need to set_freezable(); and I wonder
> if this swap bug underlies his interest, though he was mainly worrying
> about I/O in progress.
> 
> Despite reading Documentation/power/freezing-of-tasks.txt, I have no
> clear idea of what really needs freezing, and whether freezing can
> fully handle the issues.  Rafael, please can you advise?

Well, the rule of thumb (if it can be called this way) is that the contents of
the image has to be consistent with whatever is stored in permanent storage.
So, for example, filesystems that were mounted before creating the image
cannot be modified until the image is restored.  Consequently, if there are
any kernel threads that might cause that to happen, they need to be frozen.

Now, if I understand it correctly, the failure mode is that certain page had
been swapped out before the image was created and then it was swapped in
while we were writing the image out and the slot occupied by it was re-used.
In that case the image would contain wrong information on the state of the
swap and that would result in wrong data being loaded into memory on an attempt
to swap that page in after resume.

So, generally, we have to avoid doing things that would result in swapping
memory pages out after we have created a hibernation image.  If that can be
achieved by freezing certain kernel threads, that probably is the simplest
approach.

Thanks,
Rafael
