Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab0GFAKj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 20:10:39 -0400
Received: from bld-mail16.adl2.internode.on.net ([150.101.137.101]:59950 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753025Ab0GFAKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 20:10:37 -0400
Date: Tue, 6 Jul 2010 10:10:32 +1000
From: Dave Chinner <david@fromorbit.com>
To: David Howells <dhowells@redhat.com>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] Rearrange i_flags to be consistent with FS_IOC_GETFLAGS
Message-ID: <20100706001032.GA25018@dastard>
References: <20100705154319.31193.56706.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100705154319.31193.56706.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 05, 2010 at 04:43:19PM +0100, David Howells wrote:
> Rearrange the constituent bits of i_flags to be consistent with the flag values
> returned by the FS_IOC_GETFLAGS ioctl where flags with common meanings occur.
> Otherwise pack the bits of i_flags as low as possible so that RISC CPUs can
> use small instructions.
> 
> This allows those filesystems that use i_flags (Ext2/3/4) to simplify their
> get/set flags routines.

This seems like a nasty landmine just waiting for someone to step
on.  The S_* flags are VFS level flags used by all filesytsems, not
just extN, and have a history of changing values and meaning as uses
come and go.  This code forces the VFS to use certain flag values
that *match on-disk values* of ext2/3/4.

Further, it opens up the possibility that further down the track
someone modifies S_* flag values (say when adding some XFS
functionality) and corrupts extN filesystems all over the place.
There isn't even compiler guards to catch someone modifying the S_*
flags in a way that makes it incompatible with the extN on-disk
definitions.


Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
