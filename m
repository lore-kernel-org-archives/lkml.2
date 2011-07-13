Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965320Ab1GMK5y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 06:57:54 -0400
Received: from smtp-out.google.com ([216.239.44.51]:1388 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965021Ab1GMK5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 06:57:52 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=CKiJLzzLilbmRRb1aoRZ2itzXz62nw5S8QrNjOH3M9ksOLvymA+0eROCD6SW/0aKo
	ptX66rLIGyq0Ll2Aqub9Q==
Date: Wed, 13 Jul 2011 03:57:40 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Wu Fengguang <fengguang.wu@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mel@csn.ul.ie>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/15] writeback: remove writeback_control.more_io
In-Reply-To: <alpine.LSU.2.00.1107122234460.3608@sister.anvils>
Message-ID: <alpine.LSU.2.00.1107130350570.4184@sister.anvils>
References: <20110607213236.634026193@intel.com> <20110607213854.888623315@intel.com> <alpine.LSU.2.00.1107111408060.13830@sister.anvils> <20110712062013.GA4654@localhost> <alpine.LSU.2.00.1107121207540.1752@sister.anvils>
 <alpine.LSU.2.00.1107122234460.3608@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jul 2011, Hugh Dickins wrote:
> On Tue, 12 Jul 2011, Hugh Dickins wrote:
> > On Mon, 11 Jul 2011, Wu Fengguang wrote:
> > > 
> > > It's relatively easy to confirm, by reusing the below trace event to
> > > show the inode (together with its state) being requeued.
> > > 
> > > If this is the root cause, it may equally be fixed by
> > > 
> > > -			requeue_io(inode, wb);
> > > +			redirty_tail(inode, wb);
> > > 
> > > which would be useful in case the bug is so deadly that it's no longer
> > > possible to do tracing.
> > 
> > I checked again this morning that I could reproduce it on two machines,
> > one went in a few minutes, the other within the hour.  Then I made that
> > patch changing the requeue_io to redirty_tail, and left home with them
> > running the test with the new kernel: we'll see at the end of the day
> > how they fared.
> 
> I think that fixes it.  The x86_64 is still running with that, but the
> ppc64 gave up fairly early, hitting freeze in __slab_free() instead.
> 
> I've now, I believe, reconstituted what ChristophL intended from the
> mm_types.h struct page patch he posted (which applied neither to mmotm,
> nor to Pekka's for-next, so far as I could tell: maybe cl did some
> intermediate tidying of some of the random indentation).  So now
> testing that with redirty_tail on ppc64: will report in 9 hours.

Same result as before.  The x86_64 is still going fine, but the ppc64
again seized up in __slab_free() after two and a half hours of load.

I think we should assume that your -requeue_io +redirty_tail is a good
fix for the writeback freeze (if you can reassure us, that it does not
risk postponing some writes indefinitely), and I move over to the other
thread to pursue the struct page __slab_free() freeze.

Thanks!
Hugh
