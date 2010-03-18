Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289Ab0CRVsz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 17:48:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43619 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163Ab0CRVsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 17:48:54 -0400
Date: Fri, 19 Mar 2010 08:48:44 +1100
From: Neil Brown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>,
       Mikulas Patocka <mpatocka@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>,
       device-mapper development <dm-devel@redhat.com>, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dm: max_segments=1 if merge_bvec_fn is not supported
Message-ID: <20100319084844.7ea9db41@notabene.brown>
In-Reply-To: <20100318114858.0303157e.akpm@linux-foundation.org>
References: <20100306211012.GA9689@racke>
	<20100308163345.42841480@notabene.brown>
	<Pine.LNX.4.64.1003080321190.25635@hs20-bc2-1.build.redhat.com>
	<20100308131449.GA15156@racke>
	<20100318114858.0303157e.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Mar 2010 11:48:58 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 8 Mar 2010 14:14:49 +0100
> Lars Ellenberg <lars.ellenberg@linbit.com> wrote:
> 
> > On Mon, Mar 08, 2010 at 03:35:37AM -0500, Mikulas Patocka wrote:
> > > Hi
> > > 
> > > That patch with limits->max_segments = 1; is wrong. It fixes this bug 
> > > sometimes and sometimes not.
> > > 
> > > The problem is, if someone attempts to create a bio with two vector 
> > > entries, the first maps the last sector contained in some page and the 
> > > second maps the first sector of the next physical page: it has one 
> > > segment, it has size <= PAGE_SIZE, but it still may cross raid stripe and 
> > > the raid driver will reject it.
> > 
> > Now that you put it that way ;)
> > You are right.
> > 
> > My asumption that "single segment" was  
> > equalvalent in practice with "single bvec"
> > does not hold true in that case.
> > 
> > Then, what about adding seg_boundary_mask restrictions as well?
> > 	max_sectors = PAGE_SIZE >> 9;
> > 	max_segments = 1;
> > 	seg_boundary_mask = PAGE_SIZE -1;
> > or some such.
> > 
> > > > > This is not the first time this has been patched, btw.
> > > > > See https://bugzilla.redhat.com/show_bug.cgi?id=440093
> > > > > and the patch by Mikulas:
> > > > > https://bugzilla.redhat.com/attachment.cgi?id=342638&action=diff
> > > 
> > > Look at this patch, it is the proper way how to fix it: create a 
> > > merge_bvec_fn that reject more than one biovec entry.
> > 
> > If adding seg_boundary_mask is still not sufficient,
> > lets merge that patch instead?
> > Why has it been dropped, respectively never been merged?
> > It became obsolete for dm-linear by 7bc3447b,
> > but in general the bug is still there, or am I missing something?
> > 
> 
> This all seemed to die.  Does Neil's mysterypatch fix all these issues?
> 
> Neil, was that patch tagged for -stable backporting?

The patch at the top of my 'for-linus' branch (which Linus doesn't seem to
have pulled yet) fixes this for md and is tagged for -stable backporting.
I just sets max_segments and seg_boundary_mask.  There is no point setting
max_sectors as well.  I found that setting merge_bvec_fn, while a perfectly
correct approach, was more cumbersome.

My patch doesn't fix this for dm.  I assume the dm developers will do that.

NeilBrown
