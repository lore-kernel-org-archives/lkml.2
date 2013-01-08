Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab3AHTsi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 14:48:38 -0500
Received: from relay1.sgi.com ([192.48.179.29]:60199 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756625Ab3AHTsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 14:48:37 -0500
Date: Tue, 8 Jan 2013 13:48:33 -0600
From: Ben Myers <bpm@sgi.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Sergei Trofimovich <slyfox@gentoo.org>, Alex Elder <elder@kernel.org>,
        Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com, Phil White <pwhite@sgi.com>
Subject: Re: [PATCH] xfs: return -EINVAL instead of -EUCLEAN when mounting
 non-xfs
Message-ID: <20130108194833.GY27055@sgi.com>
References: <20121230015615.6cc9e03c@sf>
 <1356823010-29768-1-git-send-email-slyfox@gentoo.org>
 <20130103181929.GA23049@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130103181929.GA23049@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Thu, Jan 03, 2013 at 01:19:29PM -0500, Christoph Hellwig wrote:
> On Sun, Dec 30, 2012 at 02:16:50AM +0300, Sergei Trofimovich wrote:
> > It fixes boot panic when trying to boot from btrfs filesystem.
> > kernel tries to mount as xfs and gets fatal -EUCLEAN:
> > 
> > [    0.170000] VFS: Cannot open root device "ubda" or unknown-block(98,0): error -117
> > [    0.170000] Please append a correct "root=" boot option; here are the available partitions:
> > [    0.170000] 6200         1048576 ubda  driver: uml-blkdev
> > [    0.170000] Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(98,0)
> > 
> > init/do_mounts.c expects only -EINVAL as 'retry another' option.
> > Fixes regression introduced by commit 98021821a502db347bd9c7671beeee6e8ce07ea6
> 
> Looks reasonable, but  think xfs_readsb should simply be changed to
> turn all EFSCORRUPTED returns into EINVAL if loud is not set.

I think there are some EFSCORRUPTED returns that should not result in 'retry
another' behavior.  E.g. mounting an xfs filesystem where super block magic is
good but you have a corrupted log probably shouldn't result in a retry with
ext3.  It is useful to be able to distinguish between that special case of
sb->sb_magic != XFS_SB_MAGIC and a truly corrupted filesystem.

Here EWRONGFS (EINVAL) in the quiet case is better than EFSCORRUPTED, but
unfortunately we still can't tell EWRONGFS from other EINVAL returns in
b_error.  Adding a new errno as Ted suggested might make some sense.

Regards,
	Ben
