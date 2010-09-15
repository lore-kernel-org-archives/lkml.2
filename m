Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab0IOCXr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 22:23:47 -0400
Received: from cantor.suse.de ([195.135.220.2]:33388 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066Ab0IOCXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 22:23:46 -0400
Date: Wed, 15 Sep 2010 12:23:34 +1000
From: Neil Brown <neilb@suse.de>
To: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: Deadlock possibly caused by too_many_isolated.
Message-ID: <20100915122334.3fa7b35f@notabene>
In-Reply-To: <4C90139A.1080809@redhat.com>
References: <20100915091118.3dbdc961@notabene>
	<4C90139A.1080809@redhat.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Sep 2010 20:30:18 -0400
Rik van Riel <riel@redhat.com> wrote:

> On 09/14/2010 07:11 PM, Neil Brown wrote:
> 
> > Index: linux-2.6.32-SLE11-SP1/mm/vmscan.c
> > ===================================================================
> > --- linux-2.6.32-SLE11-SP1.orig/mm/vmscan.c	2010-09-15 08:37:32.000000000 +1000
> > +++ linux-2.6.32-SLE11-SP1/mm/vmscan.c	2010-09-15 08:38:57.000000000 +1000
> > @@ -1106,6 +1106,11 @@ static unsigned long shrink_inactive_lis
> >   		/* We are about to die and free our memory. Return now. */
> >   		if (fatal_signal_pending(current))
> >   			return SWAP_CLUSTER_MAX;
> > +		if (!(sc->gfp_mask&  __GFP_IO))
> > +			/* Not allowed to do IO, so mustn't wait
> > +			 * on processes that might try to
> > +			 */
> > +			return SWAP_CLUSTER_MAX;
> >   	}
> >
> >   	/*
> 
> Close.  We must also be sure that processes without __GFP_FS
> set in their gfp_mask do not wait on processes that do have
> __GFP_FS set.
> 
> Considering how many times we've run into a bug like this,
> I'm kicking myself for not having thought of it :(
> 

So maybe this?  I've added the test for __GFP_FS, and moved the test before
the congestion_wait on the basis that we really want to get back up the stack
and try the mempool ASAP.

Thanks,
NeilBrown



From: NeilBrown <neilb@suse.de>

mm: Avoid possible deadlock caused by too_many_isolated()


If too_many_isolated() returns true while performing direct reclaim we can
end up waiting for other threads to complete their direct reclaim.
If those threads are allowed to enter the FS or IO to free memory, but
this thread is not, then it is possible that those threads will be waiting on
this thread and so we get a circular deadlock.

So: if too_many_isolated() returns true when the allocation did not permit FS
or IO, fail shrink_inactive_list rather than blocking.

Signed-off-by: NeilBrown <neilb@suse.de>

--- linux-2.6.32-SLE11-SP1.orig/mm/vmscan.c	2010-09-15 08:37:32.000000000 +1000
+++ linux-2.6.32-SLE11-SP1/mm/vmscan.c	2010-09-15 12:17:16.000000000 +1000
@@ -1101,6 +1101,12 @@ static unsigned long shrink_inactive_lis
 	int lumpy_reclaim = 0;
 
 	while (unlikely(too_many_isolated(zone, file, sc))) {
+		if ((sc->gfp_mask & GFP_IOFS) != GFP_IOFS)
+			/* Not allowed to do IO, so mustn't wait
+			 * on processes that might try to
+			 */
+			return SWAP_CLUSTER_MAX;
+
 		congestion_wait(BLK_RW_ASYNC, HZ/10);
 
 		/* We are about to die and free our memory. Return now. */
