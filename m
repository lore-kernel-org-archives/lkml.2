Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887Ab1CIBas (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 20:30:48 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:5857 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755632Ab1CIBaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 20:30:46 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAENldk15LK5J/2dsb2JhbACmZnXCOw2FVgSTFQ
Date: Wed, 9 Mar 2011 12:30:41 +1100
From: Dave Chinner <david@fromorbit.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Marco Stornelli <marco.stornelli@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v3] Check for immutable/append flag in fallocate path
Message-ID: <20110309013041.GH1956@dastard>
References: <4D6221B8.9040303@gmail.com>
 <4D6F5473.2070709@gmail.com>
 <4D720469.1010101@gmail.com>
 <20110308051121.GE1956@dastard>
 <92E5B019-756F-4CBE-829C-724564D4D650@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <92E5B019-756F-4CBE-829C-724564D4D650@dilger.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07, 2011 at 10:38:37PM -0700, Andreas Dilger wrote:
> On 2011-03-07, at 10:11 PM, Dave Chinner wrote:
> > On Sat, Mar 05, 2011 at 10:37:45AM +0100, Marco Stornelli wrote:
> >> From: Marco Stornelli <marco.stornelli@gmail.com>
> >> 
> >> In the fallocate path the kernel doesn't check for the immutable/append
> >> flag. It's possible to have a race condition in this scenario: an
> >> application open a file in read/write and it does something, meanwhile
> >> root set the immutable flag on the file, the application at that point
> >> can call fallocate with success. In addition, we don't allow to do any
> >> unreserve operation on an append only file but only the reserve one.
> >> 
> >> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
> >> ---
> >> Patch is against 2.6.38-rc7
> >> 
> >> ChangeLog:
> >> v3: Modified do_fallocate instead of every single fs
> >> v2: Added the check for append-only file for XFS
> >> v1: First draft
> >> 
> >> --- open.c.orig	2011-03-01 22:55:12.000000000 +0100
> >> +++ open.c	2011-03-04 15:28:43.000000000 +0100
> >> @@ -233,6 +233,14 @@ int do_fallocate(struct file *file, int
> >> 
> >> 	if (!(file->f_mode & FMODE_WRITE))
> >> 		return -EBADF;
> >> +
> >> +	/* It's not possible punch hole on append only file */
> >> +	if (mode & FALLOC_FL_PUNCH_HOLE && IS_APPEND(inode))
> >> +		return -EPERM;
> > 
> > Seeing as I didn't get an answer in before you reposted, I still
> > think punching an append-only file is a valid thing to want to do.
> > 
> > I've seen this done in the past for application-level transaction
> > journal files. The journal file is append only so new transactions
> > can only be written at the end of the file i.e. you cannot overwrite
> > (and therefore corrupt) existing transactions. However, once a
> > transaction is complete and the changes flushed to disk, the
> > transaction is punched out of the file to zero the range so it
> > doesn't get replayed during recovery after a system crash.
> 
> To my thinking "append only" means just that - only new data can
> be written at the end of the file, and existing data cannot be
> modified.  Allowing hole punch on such a file (e.g. range 0 .. ~0)
> would allow erasing all of the data, entirely bypassing the
> append-only flag.

Not worth arguing over. XFS_IOC_UNRESVSP won't get changed, so the
applications already doing this can just keep using that interface...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
