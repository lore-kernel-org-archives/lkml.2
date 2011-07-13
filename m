Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964911Ab1GMFuT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 01:50:19 -0400
Received: from smtp-out.google.com ([74.125.121.67]:12768 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab1GMFuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 01:50:17 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=yFFHd6sZ5HWJj+yyiqHYcxB8qwJZteB5V8Hq6ofkTKy0/e6zo1e70pmXX3TslwpLr
	srRKq92sWW2MZB8ELDGSQ==
Date: Tue, 12 Jul 2011 22:49:56 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Hugh Dickins <hughd@google.com>
cc: Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mel@csn.ul.ie>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/15] writeback: remove writeback_control.more_io
In-Reply-To: <alpine.LSU.2.00.1107121207540.1752@sister.anvils>
Message-ID: <alpine.LSU.2.00.1107122234460.3608@sister.anvils>
References: <20110607213236.634026193@intel.com> <20110607213854.888623315@intel.com> <alpine.LSU.2.00.1107111408060.13830@sister.anvils> <20110712062013.GA4654@localhost> <alpine.LSU.2.00.1107121207540.1752@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jul 2011, Hugh Dickins wrote:
> On Mon, 11 Jul 2011, Wu Fengguang wrote:
> > 
> > It's relatively easy to confirm, by reusing the below trace event to
> > show the inode (together with its state) being requeued.
> > 
> > If this is the root cause, it may equally be fixed by
> > 
> > -			requeue_io(inode, wb);
> > +			redirty_tail(inode, wb);
> > 
> > which would be useful in case the bug is so deadly that it's no longer
> > possible to do tracing.
> 
> I checked again this morning that I could reproduce it on two machines,
> one went in a few minutes, the other within the hour.  Then I made that
> patch changing the requeue_io to redirty_tail, and left home with them
> running the test with the new kernel: we'll see at the end of the day
> how they fared.

I think that fixes it.  The x86_64 is still running with that, but the
ppc64 gave up fairly early, hitting freeze in __slab_free() instead.

I've now, I believe, reconstituted what ChristophL intended from the
mm_types.h struct page patch he posted (which applied neither to mmotm,
nor to Pekka's for-next, so far as I could tell: maybe cl did some
intermediate tidying of some of the random indentation).  So now
testing that with redirty_tail on ppc64: will report in 9 hours.

Hugh
