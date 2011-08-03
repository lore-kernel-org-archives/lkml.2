Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651Ab1HDGCY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 02:02:24 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50640 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab1HDGCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 02:02:18 -0400
Date: Wed, 3 Aug 2011 19:29:22 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Nigel Cunningham <nigel@tuxonice.net>,
        Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>, Christoph <cr2005@u-club.de>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        xfs@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] PM / Freezer: Freeze filesystems along with
 freezing processes (was: Re: PM / hibernate xfs lock up /
 xfs_reclaim_inodes_ag)
Message-ID: <20110803172922.GA2126@ucw.cz>
References: <4E1C70AD.1010101@u-club.de>
 <20110727103308.GA20805@infradead.org>
 <4E300317.7090108@tuxonice.net>
 <201108032315.06012.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201108032315.06012.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Freeze all filesystems during the freezing of tasks by calling
> freeze_bdev() for each of them and thaw them during the thawing
> of tasks with the help of thaw_bdev().
> 
> This is needed by hibernation, because some filesystems (e.g. XFS)
> deadlock with the preallocation of memory used by it if the memory
> pressure caused by it is too heavy.
> 
> The additional benefit of this change is that, if something goes
> wrong after filesystems have been frozen, they will stay in a
> consistent state and journal replays won't be necessary (e.g. after
> a failing suspend or resume).  In particular, this should help to
> solve a long-standing issue that in some cases during resume from
> hibernation the boot loader causes the journal to be replied for the
> filesystem containing the kernel image and initrd causing it to
> become inconsistent with the information stored in the hibernation
> image.

> +/**
> + * freeze_filesystems - Force all filesystems into a consistent state.
> + */
> +void freeze_filesystems(void)
> +{
> +	struct super_block *sb;
> +
> +	lockdep_off();

Ouch. So... why do we need to silence this?

> +	/*
> +	 * Freeze in reverse order so filesystems dependant upon others are
> +	 * frozen in the right order (eg. loopback on ext3).
> +	 */
> +	list_for_each_entry_reverse(sb, &super_blocks, s_list) {
> +		if (!sb->s_root || !sb->s_bdev ||
> +		    (sb->s_frozen == SB_FREEZE_TRANS) ||
> +		    (sb->s_flags & MS_RDONLY) ||
> +		    (sb->s_flags & MS_FROZEN))
> +			continue;

Should we stop NFS from modifying remote server, too?

Plus... ext3 writes to read-only filesystems on mount; not sure if it
does it later. But RDONLY means 'user cant write to it' not 'bdev will
not be modified'. Should we freeze all?

How can 'already frozen' happen?

> +	list_for_each_entry(sb, &super_blocks, s_list)
> +		if (sb->s_flags & MS_FROZEN) {
> +			sb->s_flags &= ~MS_FROZEN;
> +			thaw_bdev(sb->s_bdev, sb);
> +		}

...because we'll unfreeze it even if we did not freeze it...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
