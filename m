Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964849Ab0HFSFG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 14:05:06 -0400
Received: from thunk.org ([69.25.196.29]:33859 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964829Ab0HFSFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 14:05:00 -0400
Date: Fri, 6 Aug 2010 14:04:54 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Mingming Cao <cmm@us.ibm.com>, Ric Wheeler <rwheeler@redhat.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Keith Mannthey <kmannth@us.ibm.com>, Mingming Cao <mcao@us.ibm.com>
Subject: Re: [RFC v2] ext4: Don't send extra barrier during fsync if there
 are no dirty pages.
Message-ID: <20100806180454.GA24583@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@us.ibm.com>,
	Mingming Cao <cmm@us.ibm.com>, Ric Wheeler <rwheeler@redhat.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Keith Mannthey <kmannth@us.ibm.com>, Mingming Cao <mcao@us.ibm.com>
References: <20100429235102.GC15607@tux1.beaverton.ibm.com>
 <1272934667.2544.3.camel@mingming-laptop>
 <4BE02C45.6010608@redhat.com>
 <1273002566.3755.10.camel@mingming-laptop>
 <20100629205102.GM15515@tux1.beaverton.ibm.com>
 <20100805164008.GH2901@thunk.org>
 <20100806071356.GE2109@tux1.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100806071356.GE2109@tux1.beaverton.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 06, 2010 at 12:13:56AM -0700, Darrick J. Wong wrote:
> Yes, it's a proxy for something else.  One of our larger products would like to
> use fsync() to flush dirty data out to disk (right now it looks like they use
> O_SYNC), but they're concerned that the many threads they use can create an
> fsync() storm.  So, they wanted to know how to mitigate the effects of those
> storms.  Not calling fsync() except when they really need to guarantee a disk
> write is a good start, but I'd like to get ahead of them to pick off more low
> hanging fruit like the barrier coordination and not sending barriers when
> there's no dirty data ... before they run into it. :)

Do they need a barrier operation, or do they just want to initiate the
I/O?  One of the reasons I found it hard to believe you would have
multiple threads all fsync()'ing the same file is that keeping the the
file consistent is very hard to do in such a scenario.  Maintaining
ACID-level consistency without a single thread which coordinates when
commit records gets written is I'm sure theoretically possible, but in
practice, I wasn't sure any applications would actually be _written_
that way.

If the goal is just to make sure I/O is getting initiated, without
necessarily waiting for assurance that a specific file write has hit
the disk platters, it may be that the Linux-specific
sync_file_range(2) system call might be a far more efficient way of
achieving those ends.  Without more details about what this product is
doing, it's hard to say, of course.

						- Ted
