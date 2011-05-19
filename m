Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933558Ab1ESQhT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 12:37:19 -0400
Received: from adelie.canonical.com ([91.189.90.139]:55198 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933190Ab1ESQhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 12:37:16 -0400
Date: Thu, 19 May 2011 17:37:09 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        nbd@openwrt.org, neilb@suse.de, hramrach@centrum.cz,
        jordipujolp@gmail.com, mszeredi@suse.cz
Subject: Re: [PATCH 0/7] overlay filesystem v9
Message-ID: <20110519163709.GH3702@shadowen.org>
References: <1305635452-14835-1-git-send-email-miklos@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305635452-14835-1-git-send-email-miklos@szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 02:30:45PM +0200, Miklos Szeredi wrote:

> Here's an updated version of the overlay filesystem.
> 
> Git tree is here:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs.v9

Ok I pulled this into the Ubuntu kernel and made an Ubuntu Live CD
for testing.  Overall it worked pretty well, no hangs, no crashes,
performance seemed reasonable.  We hit one issue with hard links which
fail to be possible on overlayfs mounts when the Yama LSM (out of tree)
is enabled.  This module applies more aggressive checks on hard-links
preventing links to files you cannot read.

The bug seems to be related to the way we handle user and group owners for
the overlayfs inodes, which we do not initialise (and they remain as 0,0).
While these ownerships are never exposed to userspace they are exposed
to the LSM layer, and the LSM module checks the wrong owner and fails
to allow the links.

>From what I can see it is completly reasonable to initialise the ownership
fields in the overlayfs inode from the underlying inode, or for new files
ones initialise it in the normal way based on the containing directory.
Now I am nothing like a filesystems expert but looking at what other
filesystems do I think the patch below is sufficient, but certainly it
needs some sanity checking.  At least it fixes all the issues I see here.

With this in place I have been able to boot a Natty release live CD
image, and upgrade it in place to the latest and greatest of everything.
Very nice.  Thanks for your work continuing work on overlayfs.  It is
starting to look good enough to merge.

Comments?

-apw
