Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834Ab2BLVNc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 16:13:32 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:40555 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929Ab2BLVNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 16:13:31 -0500
Date: Sun, 12 Feb 2012 21:13:25 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>, mpatocka@redhat.com,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 1/2] vfs: Provide function to get superblock and wait for
 it to thaw
Message-ID: <20120212211325.GT23916@ZenIV.linux.org.uk>
References: <1328868181-16979-1-git-send-email-jack@suse.cz>
 <1328868181-16979-2-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328868181-16979-2-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 11:03:00AM +0100, Jan Kara wrote:
> In quota code we need to find a superblock corresponding to a device and wait
> for superblock to be unfrozen. However this waiting has to happen without
> s_umount semaphore because that is required for superblock to thaw. So provide
> a function in VFS for this to keep dances with s_umount where they belong.

Eww...  All it takes is
struct super_block *get_super_thawed(struct block_device *bdev)
{
        while (1) {
                struct super_block *s = get_super(bdev);
                if (!s || s->s_frozen == SB_UNFROZEN)
                        return s;
		up_read(&s->s_umount);
		vfs_check_frozen(s, SB_FREEZE_WRITE);
		put_super(s);
        }
}
and there's no need of extra arguments, etc. whatsoever.  Both patches
applied, with implementation of get_super_thawed() done as above.
