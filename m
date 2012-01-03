Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab2ACOpv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 09:45:51 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:54800 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716Ab2ACOpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 09:45:49 -0500
Date: Tue, 3 Jan 2012 14:45:32 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jan Kara <jack@suse.cz>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: linux-next: build failure after merge of the vfs tree
Message-ID: <20120103144531.GA23916@ZenIV.linux.org.uk>
References: <20120103124331.f0f0043f8ca464c9ff13f4d3@canb.auug.org.au>
 <20120103133942.GC31457@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120103133942.GC31457@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 03, 2012 at 02:39:42PM +0100, Jan Kara wrote:

>   Thanks Stephen! Al, how shall we resolve this? You wrote you can provide
> a VFS helper like get_super() which will also guarantee that the fs is
> unfrozen.  That could be used in quotactl_block() and fsync_bdev(). If you
> plan to do this for 3.3 then I can just remove the quota fix and let you
> do it.

I started digging in that area and I really don't like what I'm seeing.
sget() race fix from Aug 2010 (MS_BORN one) had not covered all cases.
The thing is, we can get hit with this:
	1) mount(2) does sget(), etc. and fails very late in the game - with
->s_root already allocated.  For some filesystems such failure exits are
possible.
	2) something crawling through the superblock list finds our new
sb before we realize it's doomed.  Tries to grab s_umount, gets blocked.
	3) in the meanwhile *another* mount(2) does sget() that catches
the same sb and decides to pick it.  ->s_active is grabbed, we get blocked
on attempt to get ->s_umount exclusive.
	4) the original mount(2) gets to the failure point and does
deactivate_locked_super().  ->s_active is decremented, ->s_umount unlocked.
However, because of (3) ->s_active does not reach 0 yet.  Guy stuck in (2)
gets to run.  ->s_root is non-NULL here.  And fs is not in a good shape...
	5) sget() from (3) gets to ->s_umount, notices that MS_BORN hadn't
been set and does deactivate_locked_super().  Now ->s_active is 0 and
we get around to shutting the sucker down.  ->kill_sb() gets called, ->s_root
is dropped, etc. - the whole nine yards.  Caller of sget() had been saved from
the race.  However, whoever that had been in (2) and (4) still got hit.

IOW, MS_BORN check is needed in the places that go through the superblock
list, grab ->s_umount and check ->s_root.  That will close the hole for
good.

We also have a problem in get_active_super() caller; again, the missing MS_BORN
check (in freeze_super(), after getting ->s_umount).

I went through the ->mount() instances; most of them can't fail with non-NULL
->s_root at all or, if they do, leave the superblock in basically usable
shape.  However, some might be b0rken; among other things, ext4 and minixfs
*definitely* can leak root dentry on late failure exits.  Still doing RTFS...

Another fun question - can ->statfs() ever wait for fs to be thawed?  If so,
we have another problem like the one spotted by Mikulas - in ustat(2).  And
if not, we'd damn better document that requirement.
