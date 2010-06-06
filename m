Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940Ab0FFH7u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 03:59:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46212 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260Ab0FFH7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 03:59:48 -0400
Date: Sun, 6 Jun 2010 17:59:43 +1000
From: Nick Piggin <npiggin@suse.de>
To: tytso@mit.edu, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
       Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, hch@infradead.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] new ->perform_write fop
Message-ID: <20100606075943.GL26335@laptop>
References: <20100518104351.GF2516@laptop>
 <20100518122714.GG2150@dastard>
 <20100518150912.GI2516@laptop>
 <20100519235054.GS8120@dastard>
 <20100520201232.GP3395@quack.suse.cz>
 <20100520230524.GU8120@dastard>
 <20100521185846.GD10149@quack.suse.cz>
 <20100522002759.GA8120@dastard>
 <20100524092034.GA3287@quack.suse.cz>
 <20100605150523.GB9159@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100605150523.GB9159@thunk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 05, 2010 at 11:05:23AM -0400, tytso@mit.edu wrote:
> On Mon, May 24, 2010 at 11:20:34AM +0200, Jan Kara wrote:
> >   Yes, exactly. I just wanted to point out that AFAICS ext4 can implement
> > proper error recovery without a need for 'punch' operation. So after all
> > Nick's copy page-by-page should be plausible at least for ext4.
> 
> Sorry for my late response to this thread; I've been busy catching up
> on another of other fronts, so I didn't have a chance to go through
> this thread until now.
> 
> First of all, I'm not against implementing a 'punch' operation for
> ext4; I've actually toyed with this idea before.
> 
> Secondly, I'm not sure it's really necessary; we already have a code
> path (which I was planning on making be the default when I have a
> chance to rewrite ext4_writepages) where the blocks are initially
> allocated with the 'uninitialized' flag in the extent tree; this is
> the same flag used for fallocate(2) support when we allocate blocks
> without filling in the data blocks.  Then, when the block I/O
> completes, we use the block I/O callback to clear the uninit flag in
> the extent tree.  This is currently used to avoid safely avoid locking
> in the read path, which is needed to speed up access for extremely
> fast (think Fusion I/O-like) flash devices.
> 
> I was already thinking about using this trick in my planned
> ext4_writepages() rewrite, and if it turns out we have common code
> that also assumes that file systems can do the equivalent fallocate(2)
> and can clear the uninitialized bit on a callback, I think that makes
> ext4 fairly similar to what XFS does, at least at the high level,
> doesn't it?
> 
> Note that strictly speaking this isn't a 'punch' operation in this
> case; it's rather an fallocate(2) and don't convert the extent to mark
> the data blocks as valid on error, which is not quite the same as a
> 'punch' operation.
> 
> Am I missing something?

No this is fine, it's actually better than a punch operation from
error recovery point of view because it wouldn't require further
modifications to to filesystem in the error case.

AFAIKS this 'uninitialised blocks' approach seems to be the most
optimal way to do block allocations that are not tightly coupled
with the pagecache.

Do you mean the ext4's file_write path?

