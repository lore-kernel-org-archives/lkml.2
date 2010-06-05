Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418Ab0FEPFr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 11:05:47 -0400
Received: from THUNK.ORG ([69.25.196.29]:44622 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754292Ab0FEPFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 11:05:46 -0400
Date: Sat, 5 Jun 2010 11:05:23 -0400
From: tytso@mit.edu
To: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>, Nick Piggin <npiggin@suse.de>,
       Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, hch@infradead.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] new ->perform_write fop
Message-ID: <20100605150523.GB9159@thunk.org>
Mail-Followup-To: tytso@mit.edu, Jan Kara <jack@suse.cz>,
	Dave Chinner <david@fromorbit.com>, Nick Piggin <npiggin@suse.de>,
	Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
	chris.mason@oracle.com, hch@infradead.org,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20100518080503.GF2150@dastard>
 <20100518104351.GF2516@laptop>
 <20100518122714.GG2150@dastard>
 <20100518150912.GI2516@laptop>
 <20100519235054.GS8120@dastard>
 <20100520201232.GP3395@quack.suse.cz>
 <20100520230524.GU8120@dastard>
 <20100521185846.GD10149@quack.suse.cz>
 <20100522002759.GA8120@dastard>
 <20100524092034.GA3287@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100524092034.GA3287@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 11:20:34AM +0200, Jan Kara wrote:
>   Yes, exactly. I just wanted to point out that AFAICS ext4 can implement
> proper error recovery without a need for 'punch' operation. So after all
> Nick's copy page-by-page should be plausible at least for ext4.

Sorry for my late response to this thread; I've been busy catching up
on another of other fronts, so I didn't have a chance to go through
this thread until now.

First of all, I'm not against implementing a 'punch' operation for
ext4; I've actually toyed with this idea before.

Secondly, I'm not sure it's really necessary; we already have a code
path (which I was planning on making be the default when I have a
chance to rewrite ext4_writepages) where the blocks are initially
allocated with the 'uninitialized' flag in the extent tree; this is
the same flag used for fallocate(2) support when we allocate blocks
without filling in the data blocks.  Then, when the block I/O
completes, we use the block I/O callback to clear the uninit flag in
the extent tree.  This is currently used to avoid safely avoid locking
in the read path, which is needed to speed up access for extremely
fast (think Fusion I/O-like) flash devices.

I was already thinking about using this trick in my planned
ext4_writepages() rewrite, and if it turns out we have common code
that also assumes that file systems can do the equivalent fallocate(2)
and can clear the uninitialized bit on a callback, I think that makes
ext4 fairly similar to what XFS does, at least at the high level,
doesn't it?

Note that strictly speaking this isn't a 'punch' operation in this
case; it's rather an fallocate(2) and don't convert the extent to mark
the data blocks as valid on error, which is not quite the same as a
'punch' operation.

Am I missing something?

					- Ted
