Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab1HAQol (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 12:44:41 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:41200
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753110Ab1HAQof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 12:44:35 -0400
Date: Mon, 1 Aug 2011 12:44:14 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Dave Chinner <david@fromorbit.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: xfstests 073 regression
Message-ID: <20110801164414.GA1398@infradead.org>
References: <20110728164105.GA18258@infradead.org>
 <20110729142121.GA21149@localhost>
 <20110730134422.GA1884@infradead.org>
 <20110731151014.GA23106@localhost>
 <20110731234749.GQ5404@dastard>
 <CA+55aFzkb58Gtzgpd3oQgXekpg4APN6jDLNCh=CAMQ0zwyE4kg@mail.gmail.com>
 <20110801012813.GR5404@dastard>
 <CA+55aFwtfUeUn=MuqSEyPiPeC5=k2xK2ULd9-5ShQAJ=4T0CvQ@mail.gmail.com>
 <20110801020951.GA12870@dastard>
 <20110801055212.GB21021@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110801055212.GB21021@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 01, 2011 at 01:52:12PM +0800, Wu Fengguang wrote:
> There is another type of work that won't abort: the one that started
> by __bdi_start_writeback() and I'd call it "nr_pages" work since its
> termination condition is simply nr_pages and nothing more. It's not
> the for_background or for_kupdate works that will abort as soon as
> other works are queued. 

We have two callers of __bdi_start_writeback: bdi_start_writeback
and wakeup_flusher_threads.

The first one want to write all pages for a bdi when a laptop-mode
completion comes in.  It's a bit like the first pass of a sync in
that it's a) asynchronous and b) skipping inodes or even superblocks
has absolutely no data integrity or system balance effect.

The second one is a huge mess.  We may call it either in places like
sync that want to write all pages, and have similar characteristics
as above.  Or in some places where the VM wants to write a certain
number of pages - but the writeback code totally fucks that goal
up by trying to write the requested number of pages per BDI, leading
to much more massive writeback than we have requested on any
larger system.  And what the callers appear to actually want is to
either increase background writeback a bit, or free a certain number
of pages (in one case even just in the lowmem zone).
